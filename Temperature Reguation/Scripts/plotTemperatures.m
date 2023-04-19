function plotTemperatures(exp)

    ref = exp.SimulationInfo.Temperatures.Data(:, 1);
    Tz  = exp.SimulationInfo.Temperatures.Data(:, 2);
    t   = exp.SimulationInfo.Temperatures.Time;
    
    ref(end) = []; Tz(end) = []; t(end) = [];

    figure;
    plot(t, ref, LineStyle="--", LineWidth=3, Color='green')
    hold on
    plot(t, Tz, LineStyle="-", LineWidth=3, Color='blue')
    ylim ([0, 25]);
    grid on


end
