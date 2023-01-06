%%
% Autor: Yanis Masdoua, PhD



%% 
clear all
close all 
clc

%% Data acquisition
data = readtable('C:\Users\masdoua1\Downloads\data\82e0f28ba395dd5b9dfe624c42103ed8\505393_49.13_6.18_2019.csv');
% data = table2array(data);


for i = 1 : length(data.Temperature)
   
    % datetime(Y,M,D,H,MI,S)
    data.Date_(i) = datetime(data.Year(i), data.Month(i), data.Day(i), data.Hour(i), data.Minute(i), 0);

end

figure(1);
yyaxis left
plot(data.Date_, data.DHI, 'Color','green')
hold on
plot(data.Date_, data.GHI, 'Color','red')
hold on 
plot(data.Date_, data.DNI, 'Color', 'black')
