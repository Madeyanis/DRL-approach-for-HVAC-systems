function y = DataSelection(x, day)
c = 1;
for i = 1 : length(x)
    if x(i, 2) == 1
        if x(i, 3) == day
            y(c) = x(i, 6);
            c = c + 1;
        end
    end
end

y = y(1:4:end);

end

