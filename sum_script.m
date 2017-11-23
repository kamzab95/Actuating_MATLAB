% y = ax^2 + bx + c
a = 2
b = 1
c = 4

if a ~= 0
    delta = b^2 - 4*a*c
    if delta > 0
        x1 = (-b - sqrt(delta))/(2*a)
        x2 = (-b + sqrt(delta))/(2*a)
    elseif delta < 0
        disp("I'm not able to solve it :'(");
    else
        x0 = -b/(2*a)
    end
else
    if b ~= 0
        x = -c/b
    else
        if c == 0
            disp("nieskonczenie wiele");
        else
            disp("brak rozwiązan");
        end
    end
end