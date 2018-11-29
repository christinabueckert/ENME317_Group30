function [numTurbines, turbinePower, powerNeeded] = calcNumTurbines(P,pop)
%This funtion calculates the total power and thus the number of turbines
%needed

% from wikipedia page for 2016 population = 1237656

% converts the units of power to Wh
convertedPower = P*8760;

% calculates the sum of the vector containing all the power values to
% determine the total power produced by one windmill in a year, then
% divides by 1E6 to convert to MWh
turbinePower = sum(convertedPower)/1.e+6;

% calculates the power needed for the city in a year, by mulitplying
% population by the amount of power used per capita in MWh
powerNeeded = pop*16.5;

% calculates the number of turbines needed by dividing the total power
% needed by the city by the power produced by one turbine in a year
numTurbines = ceil(powerNeeded/turbinePower);


end

