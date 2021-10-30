clc
clear all
close all

load('FinalAgent2.mat', 'agent');

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
Ref = 20*ones(1, 24);
% Ref = [zeros(1, Tf/3) 19*ones(1,2*(Tf/3))];
Tz_init = Tout(1);

alpha = 0.15;
theta = 0.15;
gama = 0.7;


%% Env Creation
mdl = 'ModelEnv_Test_RL_4';

% Observations and actions definitions
actInfo = rlFiniteSetSpec([0, 1, 4, 7]);
actInfo.Name = 'Heater';
actInfo.Description = 'Heater Level';

obsInfo = rlNumericSpec([3 1]);
obsInfo.Name = 'Observations';
obsInfo.Description = 'Tout, Tzone';

%% Env definition
agentBlk = [mdl '/RL Agent'];
env = rlSimulinkEnv(mdl,agentBlk, obsInfo, actInfo);

env.ResetFcn = @(in) setVariable(in,'Tz',Tout(1),'Workspace',mdl);

%% Simulate trained agent
maxsteps = ceil(Tf/Ts);
simOpts = rlSimulationOptions('MaxSteps',maxsteps);
experiences = sim(env,agent,simOpts);
