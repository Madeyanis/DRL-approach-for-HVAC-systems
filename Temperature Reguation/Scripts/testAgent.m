%% ONOFF controller

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
R = e * k/s; R = R*2.5; % Plus la resistance est grande plus le building est bien isolé.
c = 1256; c = c / 3600;

% Tref et Tout
% Tout = 13 + 2*rand(1, 24);

% Atz = -(mdot/(10*M)) - (1/(M*c*R));
% Bd = (1/(M*c*R));
% % Bd = Bd *10;
% Bd = 0.03;
% Atz = -0.15;
% Bh = mdot/(3*M);


Tout = [0, 1, 1, 2, 2, 3, 3, 4, 4, 5, 4, 5, 5, 4, 4, 3, 3, 2, 2, 1, 2, 1, 0, 0];
Tout = Tout + 2.5;
% aaa = 1;
% bbb = 6;
% Tout = (bbb-aaa).*rand(Tf/Ts,1) + aaa;
% Tout = 6*ones(1, 24);
% Ref = [zeros(1, 7) 20*ones(1, 9) zeros(1, 8)];
Ref = 20*ones(1, 24);
% Ref = [zeros(1, Tf/3) 19*ones(1,2*(Tf/3))];
Tz_init = Tout(1);

alpha = 0.15;
theta = 0.15;
gama = 0.7;

%% Faults
biais_sensor = 1;

%% Evaluation the control

% Temperature regulation (RMSE)
Tzone = out.TR.Data(:, 1);
Treference = out.TR.Data(:, 2);
E_T_R = mae(Tzone, Treference);
% Energy consumption
E_C = out.Energy.Data(end, 1);
% Use of Equipment
Commands = out.Energy.Data(:, 2);
plot(diff(Commands))


OnOffCommands = Commands;
dif_OnOff = diff(OnOffCommands);

%% Load Rl commands
RL_Commands = load("commandRL.mat").Commands ;
Dif_RL = diff(RL_Commands);
RL_Commands(end)=[];

xx = linspace(0,24,119);
OnOffCommands(end) = [];

figure;
subplot(2, 2, 1)
plot(xx, RL_Commands)
ylim([0, 8])
subplot(2, 2, 2)
plot(xx, OnOffCommands)
ylim([0, 8])
subplot(2, 2, 3)
plot(xx, Dif_RL)
ylim([-8 8])
subplot(2, 2, 4)
plot(xx, dif_OnOff)
ylim([-8 8])