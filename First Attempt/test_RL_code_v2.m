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

Tout = [7 6 5 6 4 4 6 8 9 10 11 12 14 14 16 17 14 12 10 9 8 8 7 6];
% Tout = 10*ones(1, Tf);
% Tout = [7 6 5 6 4 4 6 8 9 10 11 12];
% Ref = [zeros(1, 7) 20*ones(1, 9) zeros(1, 8)];
Ref = [20*ones(1, 24)];
% Ref = [zeros(1, Tf/3) 19*ones(1,2*(Tf/3))];
Tz_init = Tout(1);

alpha = 0.15;
theta = 0.15;
gama = 0.7;


%% Env Creation
mdl = 'ModelEnv_Test_RL_4';

% Observations and actions definitions
actionInfo = rlNumericSpec([1 1]);
actionInfo.Name = 'Heater';
actionInfo.Description = 'Heater Level';
actionInfo.UpperLimit = 6;
actionInfo.LowerLimit = 0;

observationInfo = rlNumericSpec([3 1]);
observationInfo.Name = 'Observations';
observationInfo.Description = 'Tout, Tzone';

%% Agent creation

L = 5; % number of neurons
statePath = [
    featureInputLayer(3,'Normalization','none','Name','observation')
    fullyConnectedLayer(L,'Name','fc1')
    reluLayer('Name','relu1')
    additionLayer(2,'Name','add')
    reluLayer('Name','relu2')
    fullyConnectedLayer(1,'Name','fc2')
    reluLayer('Name', 'relu3')];

actionPath = [
    featureInputLayer(1,'Normalization','none','Name','action')
    fullyConnectedLayer(L-1, 'Name', 'fc3')];
    

criticNetwork = layerGraph(statePath);
criticNetwork = addLayers(criticNetwork, actionPath);
    
criticNetwork = connectLayers(criticNetwork,'fc5','add/in2');

criticOptions = rlRepresentationOptions('LearnRate',1e-3,'GradientThreshold',1,'L2RegularizationFactor',1e-4);

critic = rlQValueRepresentation(criticNetwork,observationInfo,actionInfo,...
    'Observation',{'observation'},'Action',{'action'},criticOptions);

actorNetwork = [
    featureInputLayer(3,'Normalization','none','Name','observation')
    fullyConnectedLayer(L+1,'Name','fc1')
    reluLayer('Name','relu1')
    fullyConnectedLayer(1,'Name','fc4')];

actorOptions = rlRepresentationOptions('LearnRate',1e-2,'GradientThreshold',1);
actor = rlDeterministicActorRepresentation(actorNetwork,observationInfo,actionInfo,...
    'Observation',{'observation'},'Action',{'fc4'},actorOptions);

%% Options

agentOptions = rlDDPGAgentOptions(...
    'SampleTime',Ts,...
    'TargetSmoothFactor',1e-3,...
    'ExperienceBufferLength',1e6,...
    'DiscountFactor',0.99,...
    'MiniBatchSize',64);

% agentOptions.EpsilonGreedyExploration.EpsilonDecay = 1e-5;
% agentOptions.EpsilonGreedyExploration.EpsilonMin = 0.005;
% agentOptions.EpsilonGreedyExploration.Epsilon = 0.95;

agent = rlDDPGAgent(actor,critic,agentOptions);

agentBlk = [mdl '/RL Agent'];

%% Env definition
agentBlk = [mdl '/RL Agent'];
% load('FinalAgent2.mat', 'agent')
env = rlSimulinkEnv(mdl,agentBlk, observationInfo, actionInfo);

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

%% 