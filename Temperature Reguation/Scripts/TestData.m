%%
% Autor: Yanis Masdoua, PhD



%% 
clear all
close all 
clc

%% Data acquisition
data = readtable('C:\Users\masdoua1\Downloads\data\82e0f28ba395dd5b9dfe624c42103ed8\505393_49.13_6.18_2019.csv');
data2 = table2array(data);

% figure(1);
% yyaxis left
% plot(data.Date_, data.GHI, 'Color','red')
% yyaxis right
% plot(data.Date_, data.Temperature, Color='blue', LineWidth=3)


c = 1;
for i = 1 : length(data2)
    if data2(i, 2) == 1
        if data2(i, 3) == 13
            Tout(c) = data2(i, 6); % Outside temperature
            It(c) = data2(i, 17); % Solar Radiation GHI
            c = c + 1;
        end
    end
end
Tout = Tout(1:4:end);
It = It(1:4:end);