function plotTemperatures(experiences)

    ref = experiences.SimulationInfo.out.Data(:, 1);
    Tz  = experiences.SimulationInfo.out.Data(:, 2);
    com  = experiences.SimulationInfo.out.Data(:, 3);
    t   = experiences.SimulationInfo.out.Time;
    Fault = experiences.SimulationInfo.FaultDetection.Data(:, 1);
    Fault = Fault';
    n = 3;
    Detection = circshift(Fault,[0,-n]);
    Detection(end-n+1:end) = zeros(1,n);

    ref(end) = []; Tz(end) = []; t(end) = []; com(end)=[]; Fault(end) = []; Detection(end) = [];

    figure;

    subplot(311)
    plot(t, ref, LineStyle="--", LineWidth=3, Color='green')
    hold on
    plot(t, Tz, LineStyle="-", LineWidth=3, Color='blue')
    xticks(0:5:25)
    ylim ([0, 25]);
    xlabel('Time (h)')
    ylabel('Temperature (°C)')
    grid minor
    legend('Reference','Zone temperature','FontSize',14)

    subplot(312)
    plot(t, Detection, LineStyle="-", LineWidth=3, Color='red')
    hold on 
    plot(t, Fault, LineStyle="- -", LineWidth=3, Color='blue')
    ylim([0, 1.5])
    xlabel('Time (h)')
    grid minor
    legend('Fault apparence', 'Real Time FDI (Heater Resistor Fault)', 'FontSize',14)

    subplot(313)
    plot(t, com, LineWidth=3, Color='red')
    ylim([0, 8])
    xlabel('Time (h)')
    ylabel('Heating command level')
    grid minor
    legend('HVAC System Command', 'FontSize',14)
  
end
