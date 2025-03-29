close all 
clc

act_infos = rlFiniteSetSpec([0, 1, 2, 3]);
act_infos.Name = 'Heater';
act_infos.Description = 'No Heater, Heater Level 1, Heater Level 2, Heater Level 3';

obs_infos = rlNumericSpec([1 1]);
obsInfo.Name = 'Tzone';


%% Definition du modèle

data = readtable('C:\Users\masdoua1\OneDrive\Research\Trnsys\building project\BuildingProject7\ResultsWithoutGainTheatOn.txt');
data = table2array(data);
data(1, :) = [];

% Nombre de journée a prévoir
jour = 5;

% constants definition and load data
Volume = 84;
DensiteAir = 1.204;
% M = Masse d'air à l'interieur de la zone (kg)
M = Volume * DensiteAir;
% c = Capacité calorifique de l'air à pression constante (j/kg.K)
c = 1256; c = c / 3600;
% m = Débit du fluid entrant dans le heater
mpump = 50;
% Theat = température du heater (commande à réguler)
% Q = Apport d'un seul occupant (watt)
Q = 150;
% N = Nombre d'occupant
N = 2 * [zeros(1, 39), ones(1, 21), zeros(1, 5), ones(1, 25), zeros(1, 30)];
N = repmat(N, 1, jour);
% Sf = surface exposé au soleil
Sf = 1.5;
% R = résistance thermique de l'enveloppe du bâtiment, R = e / (k*s)
% k = conductivité thermique du matériau, S = surface du materiau
% e = epaisseur du matériau
e = 0.355;
k = 2781;
s1 = (6*4) * 2;
s2 = (6*3.5) * 2;
s3 = (4*3.5) * 2;
s = s1 + s2 + s3;
R = e * k/s ;
R = R*0.001;
% Ppv : Production panneaux photovoltaiques 
PvProduction = data(:, 2); PvProduction = PvProduction * 1000;
% Radiation solaire 
SolaRadiation = data(:, 4); SolaRadiation = SolaRadiation * 1000;
% temperature ambiante
Tout = data(:, 5);
% Chauffage
cpf = (4.19/3.6);

% Some variables for Mpc
Ts = 0.2;
P = 5;
m = 3;
Tstop = 24*jour;

time = (0 : Ts : (Tstop)-Ts);

% Reference definition
r = N/2;
r = 19 *r;
% r(length(time)+1:end)= [];

% time manipulation for variables

Tout = Tout(1:(24*jour));
PvProduction = PvProduction(1:(24*jour));
SolaRadiation = SolaRadiation(1:(24*jour));

x = 0:((24*jour)-1);
Tout = interp1(x', Tout, time);
SolaRadiation = interp1(x', SolaRadiation, time);
PvProduction = interp1(x', PvProduction, time);

for i = 1 : length(Tout)

    if isnan(Tout(i))
        Tout(i) = Tout(i-1);
    end
    if isnan(SolaRadiation(i))
        SolaRadiation(i) = SolaRadiation(i-1);
    end
    if isnan(PvProduction(i))
        PvProduction(i) = PvProduction(i-1);
    end
    
end


QN = Q*N;


% Normaliser les unités
PvProduction = PvProduction / 1000; %% Pour avoir les KW

% entities declaration
A  = (-(1/M)*mpump)-1/(M*c*R);
B  = (1/M)*mpump;
C  = 1;
Bd = [1/(M*c*R) Sf/M*c Sf/M*c Sf/M*c Sf/M*c Q/M*c];
% B = [B Bd];
D = 0 ;
model = ss(A,B,C,D);
[num, den]= ss2tf(A, B, C, D);
num = mpump/M;
den = [1 (mpump/M)+(1/M*c*R)];

sys_batiment = tf(num, den);

