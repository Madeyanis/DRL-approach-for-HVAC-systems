clear all;
close all;
clc;

%% Simulation parameters
Ts = 0.2;
Tf = 24;
%% Buidling 
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
R = R/120;
c = 1256; c = c / 3600;
Atz = -(mdot/(10*M)) - (1/(M*c*R));
Bd = (1/(M*c*R));
Bd = 0.03;
Atz = -0.15;
Bh = mdot/(3*M);

alpha = 0.15;
theta = 0.15;
gama = 0.7;

%% Data ingestion
WeatherData = readtable(['C:\Users\masdoua1\OneDrive\GitHub\RL approach\' ...
    'Temperature Reguation\Scripts\Data\inputs\Weather\Weather2019.csv']);

% Add Date_ column
% for i = 1 : length(WeatherData.Temperature)
%     WeatherData.Date_(i) = datetime(WeatherData.Year(i), WeatherData.Month(i), ...
%                                     WeatherData.Day(i), WeatherData.Hour(i), ...
%                                     WeatherData.Minute(i), 0);
% end

% SolarRadiation = WeatherData.GHI; % Solar Data
% Humidity = WeatherData.RelativeHumidity; % Humidity data

% Transforma data from table to numpy

WeatherData = table2array(WeatherData);

% Data selection

%

c = 1;
for i = 1 : length(WeatherData)
    if WeatherData(i, 2) == 1
        if WeatherData(i, 3) == 13
            Tout(c) = WeatherData(i, 6); % Outside temperature
            It(c) = WeatherData(i, 17); % Solar Radiation GHI
            c = c + 1;
        end
    end
end

Tout = Tout(1:4:end);
It = It(1:4:end);

%% Env Creation
% Temperature initialization
Ref = 20*ones(1, 24);
Tz_init = Tout(1);
% Human Activity
Qh = 150; % human apport
HumanAct = [zeros(1, 8) ones(1, 8) zeros(1, 8)]; % changer ça en [ones(1, 12) ones(2, 12)]
% Appliances and equipments
App_Equi = [zeros(1, 8) ones(1, 8) zeros(1, 8)];
Qe = 100;

mdl = 'model';
% Observations and actions definitions
actInfo = rlFiniteSetSpec([0, 1, 4, 7]);
actInfo.Name = 'Heater';
actInfo.Description = 'Heater Level';

obsInfo = rlNumericSpec([3 1]);
obsInfo.Name = 'Observations';
obsInfo.Description = 'Tout, Tzone';

%% Faults
biais_sensor = 0;

%% Env definition
agentBlk = [mdl '/RL Agent'];
load('AgentDQN147.mat', 'agent')
env = rlSimulinkEnv(mdl,agentBlk, obsInfo, actInfo);
env.ResetFcn = @(in) setVariable(in,'Tz',Tout(1),'Workspace',mdl);

%% Simulate trained agent
maxsteps = ceil(Tf/Ts);
simOpts = rlSimulationOptions('MaxSteps',maxsteps);
experiences = sim(env,agent,simOpts);

% %% sauvegarder les matrices
% tz = experiences.SimulationInfo.simout.Data(1:5:end, 2);
% tz(1) = [];
% tz(25:end) = [];
% fault = experiences.SimulationInfo.simout.Data(1:5:end, 1);
% fault(1) = [];
% fault(25:end) = [];
% control = experiences.SimulationInfo.simout.Data(1:5:end, 3);
% control(1) = [];
% control(25:end) = [];
% matrixAsauvegarder = [Tout; Ref; tz'; fault'; control'];
% save('C:\Users\masdoua1\OneDrive\GitHub\RL approach\Temperature Reguation\Scripts\Data\exp27.mat', 'matrixAsauvegarder');