clear all
close all
clc

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
% Tout = 10*ones(1, 24);
Ref = [zeros(1, 7) 20*ones(1, 9) zeros(1, 8)];
Tz_init = Tout(1);

alpha = 0.15;
theta = 0.15;
gama = 0.7;

%% Step 
Ts = 1;

%% Section after simulink simulation
t = 0:Ts:24-Ts;


Tout = out.simout.Data(:, 1); Tout(end)=[];
Tch = out.simout.Data(:, 2); Tch(end)=[];
Tz = out.simout.Data(:, 3); Tz(end)=[];
ref = out.simout.Data(:, 4); ref(end)=[];

plot (t, ref)
hold on
plot(t, Tout)
hold on
plot(t, Tch)
hold on
plot(t, Tz)
grid on