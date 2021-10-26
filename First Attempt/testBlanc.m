clear all
close all
clc

%% Env Creation

% Constants:
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
R = e * k/s ;
c = 1256; c = c / 3600;

mdl = 'ModelEnv_Test_RL';

% Observations and actions definitions
actInfo = rlFiniteSetSpec([0, 1, 4, 7]);
actInfo.Name = 'Heater';
actInfo.Description = 'No Heater, Heater Level 1, Heater Level 2, Heater Level 3';

obsInfo = rlNumericSpec([2 1]);
obsInfo.Name = 'Observations';
obsInfo.Description = 'Tzone';

% Tref et Tout
Tout = 13 + 2*rand(1, 240);
Tref = 20*ones(1, 120);
Tref = [Tref 16*ones(1, 120)];

Tz_init = Tout(1);

% Zone Model
num = 0.4944; den = [1, 0.4944];
Ts = 0.1;
Tf = 24;

% env = rlSimulinkEnv('ModelEnv',agentBlocks,obsInfo,actInfo);

dnn = [
    featureInputLayer(2, 'Normalization', 'none', 'Name', 'state')
    fullyConnectedLayer(5, 'Name', 'CriticStateFC1')
    reluLayer('Name', 'CriticRelu1')
    fullyConnectedLayer(5, 'Name', 'CriticStateFC2')
    reluLayer('Name','CriticCommonRelu')
    fullyConnectedLayer(length(actInfo.Elements), 'Name', 'output')];

% set some options for the critic
criticOpts = rlRepresentationOptions('LearnRate',0.01,'GradientThreshold',1);

% create the critic based on the network approximator
critic = rlQValueRepresentation(dnn,obsInfo,actInfo,'Observation',{'state'},criticOpts);

agentOptions = rlDQNAgentOptions(...
    'UseDoubleDQN',false, ...
    'TargetSmoothFactor',5e-3, ...
    'SampleTime', Ts, ...
    'ExperienceBufferLength',1e6, ...
    'SequenceLength',1);
agentOptions.EpsilonGreedyExploration.EpsilonDecay = 1e-4;

agent = rlDQNAgent(critic,agentOptions);

agentBlk = [mdl '/RL Agent'];

env = rlSimulinkEnv(mdl,agentBlk, obsInfo, actInfo);

env.ResetFcn = @(in) setVariable(in,'Tz',randn,'Workspace',mdl);

