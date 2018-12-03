function [] = WindPlot(WD,WS,WS31,WS30,WS28,chord,twist,r,Power)
% This function creates the wind rose plot, the wind speed distribution and
% energy output plots, as well as the airfoil plot

%% WIND ROSE PLOT
    
% CREATES WIND ROSE PLOT SEPARATED BY WIND SPEED RANGES FOR WIND DIRECTION DATA
figure;
pax = polaraxes; % assigned and used below to edit default characteristics of polarhistogram plotting
polarhistogram(WD(WS<=25),deg2rad(0:10:360),'FaceColor','r','FaceAlpha',1); hold on;
polarhistogram(WD(WS<10),deg2rad(0:10:360),'FaceColor','y','FaceAlpha',1);
polarhistogram(WD(WS<7),deg2rad(0:10:360),'FaceColor','g','FaceAlpha',1);
polarhistogram(WD(WS<4),deg2rad(0:10:360),'FaceColor','b','FaceAlpha',1);
    
% FORMATS WINDROSE PLOT
grid on; title('Wind Rose Plot Calgary 2017: Hours per wind speed range'); % Sets title and turns grid on
thetaticks(0:45/2:360); % sets values of theta axis ticks
thetaticklabels({'N','NNE','NE','ENE','E','ESE','SE','SSE','S','SSW','SW','WSW','W','WNW','NW','NNW'}); % sets tick labels for compass increments
legend({'10-25 m/s','7-9 m/s','4-6 m/s','0-3 m/s'},'location','northeastoutside'); % creates legend
% the following reflect default settings of polarhistogram over y=x to get for a compass layout
pax.ThetaDir = 'clockwise';
pax.ThetaZeroLocation = 'top';


%% RELATIVE DISTRIBUTION OF WIND SPEED AND ENERGY OUTPUT PLOTS

Power = [0;Power]; % adds the power output for windspeed = 0

% LOOPS THAT CREATE THE RELATIVE DISTRIBUTION OF WINDSPEED AND ENERGY
% OUTPUT PLOTS FOR MONTHS WITH 31 DAYS
for i = 1:7 % iterate through the 7 months with 31 days
    lowlim = min(WS31(i,:)); % finds lower limit of windspeed for the months with 31 days
    uplim = max(WS31(i,:)); % finds the upper limit of windspeed for the months with 31 days
    x = lowlim:uplim; % sets x as a vector from the lowest wind speed of the month to the fastest windspeed of the month incremented by 1
    hours = zeros(1,length(x)); % sets hours as a vector the same length of x
    Energy = zeros(1,length(x)); % sets energy as a vector the same length of  x
    month = ['Jan';'Mar';'May';'Jul';'Aug';'Oct';'Dec']; % array of strings just for titles of figures
            
    for j = 1:length(hours)
    	hours(j) = sum(WS31(i,:) == x(j)); % sets each value of hours to the number of hours in that month that the wind speed was observed
    	Energy(j) = Power(j)*hours(j); % sets each value of Energy to the Power at that windspeed*#hours at that windspeed (E=P*t)
    end
        
    % PLOTS WINDSPEED DISTRIBUTIONS AND ENERGY OUTPUT
    figure;
    yyaxis left; % sets left y axis as preference for upcoming plot
    bar(x,hours); % creates a bar graph for windspeed distribution
    ylabel('Occurence (hours/year)');
    ylim([0,125]);
    if i == 5 
        ylim([0,145]);
    end
    yyaxis right; % sets right y axis as preference for upcoming plot
    line(x,Energy,'Linewidth',3); % creates a line graph for energy output per windspeed
    xlabel('Windspeed at 85 m Hub Height (m/s)');
    ylabel('Energy Output (Wh) ');
    title([month(i,:),' Windspeed and Energy Distribution']);
    grid on;  
end

% LOOPS THAT CREATE THE RELATIVE DISTRIBUTION OF WINDSPEED AND ENERGY
% OUTPUT PLOTS FOR MONTHS WITH 30 DAYS
for i = 1:4 % iterate through the four months with 30 days
    
	lowlim = min(WS30(i,:)); % finds the lower limit of windspeed for the months with 30 days
	uplim = max(WS30(i,:)); % finds the upper limit of windspeed for the months with 30 days
	x = lowlim:uplim; % sets x as a vector from the lowest wind speed of the month to the fastest windspeed of the month incremented by 1
	hours = zeros(1,length(x)); % sets hours as a vector the same length of x
	Energy = zeros(1,length(x)); % sets energy as a vector the same length of  x
	month = ['Apr';'Jun';'Sep';'Nov']; % array of strings just for titles of figures      
	
    for j = 1:length(hours)
        hours(j) = sum(WS30(i,:) == x(j)); % sets each value of hours to the number of hours in that month that the wind speed was observed
    	Energy(j) = Power(j)*hours(j); % sets each value of Energy to the Power at that windspeed*#hours at that windspeed (E=P*t)
    end
  
    % PLOTS WINDSPEED DISTRIBUTIONS AND ENERGY OUTPUT     
    figure;
    yyaxis left; % sets left y axis as preference for upcoming plot
    bar(x,hours); % creates a bar graph for windspeed distribution
    ylabel('Occurence (hours/year)'); 
    ylim([0,125]);
    yyaxis right; % sets right y axis as preference for upcoming plot
    line(x,Energy,'Linewidth',3); % creates a line graph for energy output per windspeed
    xlabel('Windspeed at 85 m Hub Height (m/s)');
    ylabel('Energy Output (Wh) ');
    title([month(i,:),' Windspeed and Energy Distribution']);
    grid on;
end
    
% CREATES THE RELATIVE DISTRIBUTION OF WINDSPEED AND ENERGY
% OUTPUT PLOT FOR FEBRUARY
lowlim = min(WS28(:)); %finds the lower limit of windspeed for the month with 28 days
uplim = max(WS28(:));  %finds the upper limit of windspeed for the month with 28 days
x = lowlim:uplim;      %sets x as a vector from the lowest wind speed of the month to the fastest windspeed of the month incremented by 1
hours = zeros(1,length(x)); %sets hours as a vector the same length of x
Energy = zeros(1,length(x)); %sets energy as a vector the same length of  x

for j = 1:length(hours) 
	hours(j) = sum(WS28(:) == x(j));%sets each value of hours to the number of hours in that month that the wind speed was observed
	Energy(j) = Power(j)*hours(j); %sets each value of Energy to the Power at that windspeed*#hours at that windspeed (E=P*t)
end
    
% PLOTS WINDSPEED DISTRIBUTIONS AND ENERGY OUTPUT
figure;
yyaxis left; %sets left y axis as preference for upcoming plot
bar(x,hours); %creates a bar graph for windspeed distribution
ylabel('Occurence (hours/year)');
ylim([0,125]);
yyaxis right; %sets right y axis as preference for upcoming plot
line(x,Energy,'Linewidth',3); %creates a line graph for energy output per windspeed
xlabel('Windspeed at 85 m Hub Height (m/s)');
ylabel('Energy Output (Wh) ');
title('Feb Windspeed and Energy Distribution');
grid on;


%% AIRFOIL PLOT

load 'YprofileCoord.dat' YprofileCoord; load 'XprofileCoord.dat' XprofileCoord; % loads x and y profile coordinates
figure;

for i = 1:length(r) % creates a plot at each radial position

    % ACCOUNTS FOR THE FACT THAT AIRFOIL GEOMETRY DATA IS GIVEN IN X/C and Y/C
	X = chord(i) * XprofileCoord; % multiplies x vector by chord length at that r
	Y = chord(i) * YprofileCoord; % multiplies y vector by chord length at that r
	axis([-1 5 -2 2.5]);

	poly = polyshape(X,Y,'Simplify',false); % creates a polygon in the shape outlined by the airfoil data given 
    
	% ROTATES THE POLYGON BASED ON TWIST AT EACH RADIAL POSITION
	airfoil = rotate(poly,rad2deg(twist(i)),[1/2 0]); 
	[xC,yC] = boundary(airfoil);
	R = ones(1,length(xC));
	R = R .* r(i);
    
    % CREATES AND FORMATS THE PLOT
    plot3(xC,yC,R);  %Plot/draw out the airfoil cross section
	title('Blade Geometry for a DU40 Airfoil');
	xlabel('x (m)'); ylabel('y (m)'); zlabel('Radial position along blade (m)');
	hold on; % keeps each of the previous plots
	grid on; % turns the grid on
end

end









