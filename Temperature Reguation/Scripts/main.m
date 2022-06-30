
clear all
close all
clc

Ts = 0.2;
Tf = 24;

mdot = 50;
Volume = 84;
DensiteAir = 1.204;
M = Volume * DensiteAir;
e = 0.355;
k = 2781;
s1 = (6*4) * 2;
s2 = (6*3.5) * 2;
s3 = (4*3.5) * 2;
s = s1 + s2 + s3;
R = e * k/s ; R = R*10;
c = 1256; c = c / 3600;

% Tref et Tout
% Tout = 13 + 2*rand(1, 24);

Atz = -(mdot/(10*M)) - (1/(M*c*R));
Bd = (1/(M*c*R));
% Bd = Bd *10;
Bd = 0.03;
Atz = -0.15;
Bh = mdot/(3*M);

aaa = 5;
bbb = 18;
Tout = (bbb-aaa).*rand(Tf/Ts,1) + aaa;
% Ref = [zeros(1, 7) 20*ones(1, 9) zeros(1, 8)];
Ref = 20*ones(1, 24);
% Ref = [zeros(1, Tf/3) 19*ones(1,2*(Tf/3))];
Tz_init = Tout(1);

alpha = 0.15;
theta = 0.15;
gama = 0.7;


%% Env Creation
mdl = 'model';

% Observations and actions definitions
actInfo = rlFiniteSetSpec([0, 1, 2, 3, 4, 5, 6]);
actInfo.Name = 'Heater';
actInfo.Description = 'Heater Level';

obsInfo = rlNumericSpec([3 1]);
obsInfo.Name = 'Observations';
obsInfo.Description = 'Tout, Tzone';

%% Agent creation
L = 200;
dnn = [
    featureInputLayer(obsInfo.Dimension(1), 'Normalization', 'none', 'Name', 'state')
    fullyConnectedLayer(L, 'Name', 'fc2')
    reluLayer('Name','relu2')
    fullyConnectedLayer(L+1,'Name','fc10')
    reluLayer('Name','relu10')
    fullyConnectedLayer(L+1,'Name','fc11')
    reluLayer('Name','relu11')
    fullyConnectedLayer(L+1,'Name','fc12')
    reluLayer('Name','relu12')
    dropoutLayer(0.5)
    fullyConnectedLayer(length(actInfo.Elements), 'Name', 'output')];


% set some options for the critic
criticOpts = rlRepresentationOptions('LearnRate',0.005,'GradientThreshold',1);

% create the critic based on the network approximator
critic = rlQValueRepresentation(dnn,obsInfo,actInfo,'Observation',{'state'},criticOpts);

agentOptions = rlDQNAgentOptions(...
    'UseDoubleDQN',false, ...
    'TargetSmoothFactor',5e-3, ...
    'SampleTime', Ts, ...
    'ExperienceBufferLength',1e6, ...
    'NumStepsToLookAhead', 1, ...
    'SequenceLength',1);

agentOptions.EpsilonGreedyExploration.EpsilonDecay = 1e-5;

agent = rlDQNAgent(critic,agentOptions);

agentBlk = [mdl '/RL Agent'];

%% Env definition
agentBlk = [mdl '/RL Agent'];
% load('FinalAgent.mat', 'agent')
env = rlSimulinkEnv(mdl,agentBlk, obsInfo, actInfo);

env.ResetFcn = @(in) setVariable(in,'Tz',Tout(1),'Workspace',mdl);

%% Train part
maxepisodes = 5000;
maxsteps = ceil(Tf/Ts);
trainOpts = rlTrainingOptions(...
    'MaxEpisodes',maxepisodes, ...
    'MaxStepsPerEpisode',maxsteps, ...
    'ScoreAveragingWindowLength',30, ...
    'Verbose',false, ...
    'Plots','training-progress',...
    'StopTrainingCriteria','AverageReward',...
    'StopTrainingValue',100000000);

trainingStats = train(agent,env,trainOpts);

%% Simulate trained agent
maxsteps = ceil(Tf/Ts);
simOpts = rlSimulationOptions('MaxSteps',maxsteps);
experiences = sim(env,agent,simOpts);

%% 