
clc
clear
count_1 = 0; count_2 = 0; count_3 = 0; count_4 = 0; count_5 = 0;
total_iteration = 1000000;
for n = 1 : total_iteration
    x = rand * 10;
    y = rand * 100;
    angle = 2 * pi * rand();
    %define the coordination of other sides of the rod
    x_2 = x + (1.2 * cos(angle));
    y_2 = y + (1.2 * sin(angle));
    %control the center of mass for pen is falling down or not
    cm_x = x + (0.6 * cos(angle));
    cm_y = y + (0.6 * sin(angle));
    %determine which tip is upper one 
    if y > y_2
        upper_tip = y;
        lower_tip = y_2;
    else 
        upper_tip = y_2;
        lower_tip = y;
    end
    %control the closest lines for each tip
    d_upper = round(upper_tip);
    d_lower = round(lower_tip);
    if cm_x < 0 || cm_x > 10 || cm_y < 0 || cm_y > 100
        %it has been neglected that the probability of falling from corners is very low
        if cm_x < 0 || cm_x > 10
            %determine the last point where the pen touches the table
            if cm_x < 0
                l_y = (((0 - x)*tan(angle)) + y);
            elseif cm_x > 10
                l_y = (((10 - x)*tan(angle)) + y);
            end
            %determine which tip is upper one 
            if l_y > y
                upper_tip = l_y;
                lower_tip = y;
            else 
                upper_tip = y;
                lower_tip = l_y;
            end
            %closest line should be 0 or 10
            closest_line = round((upper_tip + lower_tip) / 2);
            if (upper_tip > closest_line) && (lower_tip < closest_line)
                count_5 = count_5 + 1; %probability 5 will occur
            else
                count_4 = count_4 + 1; %probability 4 will occur
            end
        %if the pen falls from the top or bottom, it definitely touches the lines
        elseif cm_y < 0 || cm_y > 100
            count_5 = count_5 + 1; %probability 5 will occur
        end       
    elseif cm_x > 0 || cm_x < 10 || cm_y > 0 || cm_y < 100 %checking the pen is inside the table
        count_1 = count_1 + 1; 
        if x_2 < 0 || x_2 > 10 %check the other tip of the pencil is on table or not
            l_y = (((round(x_2) - x)*tan(angle)) + y); %determine the last point where the pen touches the table
            if l_y > y
                upper_tip = l_y;
                lower_tip = y;
            else 
                upper_tip = y;
                lower_tip = l_y;
            end
            d_upper = round(upper_tip);
            d_lower = round(lower_tip);
            if (d_upper ~= d_lower) && (upper_tip > d_upper) && (lower_tip < d_lower)
                %if the closest lines of the two ends are not the same and 
                %the lower tip is below the line and the upper tip is above the nearest line
                %they intersect with two lines
                count_2 = count_2 + 1;
            elseif (d_upper ~= d_lower) && (upper_tip > d_upper) && (lower_tip > d_lower)
                %if the lower end is above the nearest line, they intersect with a single line
                count_3 = count_3 + 1;
            elseif (d_upper ~= d_lower) && (upper_tip < d_upper) && (lower_tip < d_lower)
                %if the lower end is below the nearest line, they intersect with a single line
                count_3 = count_3 + 1;
            elseif (d_upper == d_lower) && (upper_tip > d_upper) && (upper_tip < d_lower)
                %if the upper type is above the line and the lower type is below the line, there is an intersection 
                count_3 = count_3 + 1;
            end
        else
            if (d_upper ~= d_lower) && (upper_tip > d_upper) && (lower_tip < d_lower)
                %if the closest lines of the two ends are not the same and 
                %the lower tip is below the line and the upper tip is above the nearest line
                %they intersect with two lines
                count_2 = count_2 + 1;
            elseif (d_upper ~= d_lower) && (upper_tip > d_upper) && (lower_tip > d_lower)
                %if the lower end is above the nearest line, they intersect with a single line
                count_3 = count_3 + 1;
            elseif (d_upper ~= d_lower) && (upper_tip < d_upper) && (lower_tip < d_lower)
                %if the lower end is below the nearest line, they intersect with a single line
                count_3 = count_3 + 1;
            elseif (d_upper == d_lower) && (upper_tip > d_upper) && (upper_tip < d_lower)
                %if the upper type is above the line and the lower type is below the line, there is an intersection 
                count_3 = count_3 + 1;
            end
        end
    end
end
%using monte carlo approximation for each probability
probability_1 = count_1 / total_iteration; 
probability_2 = count_2 / total_iteration;
probability_3 = count_3 / total_iteration;
probability_4 = count_4 / total_iteration;
probability_5 = count_5 / total_iteration;
fprintf("Pen stays on the table with a probability of %.4f \n", probability_1)
fprintf("Pen stays on the table while intersecting two parallel lines with a probability of %.4f \n", probability_2)    
fprintf("Pen stays on the table while intersecting only one of the parallel lines with a probability of %.4f \n", probability_3) 
fprintf("Pen falls from the table without intersecting the parallel lines with a probability of %.4f \n", probability_4) 
fprintf("Pen falls from the table by intersecting the parallel lines with a probability of %.4f \n", probability_5) 


