% ENME 337, Final Project 
% Due Dec 3, 2018
% Given city: Calgary, hub height: 85m, air foil: DU40

clc; clear; close all;

% PRELIMINARY DATA
HH=85; % Hub height given in metres 
cvn=1000/3600; % conversion factor to multiply by to convert from km/h to m/s
pop = 1237656; % population of Calgary in 2016
  
% WIND SPEED DATA
fileData(cvn); % initializes function the sets up all the wind data

% LOADS WIND SPEED DATA
load 'WindSpeeds/Jan_WS.dat';load 'WindSpeeds/Feb_WS.dat';load 'WindSpeeds/Mar_WS.dat';
load 'WindSpeeds/Apr_WS.dat';load 'WindSpeeds/May_WS.dat';load 'WindSpeeds/June_WS.dat';
load 'WindSpeeds/July_WS.dat';load 'WindSpeeds/Aug_WS.dat';load 'WindSpeeds/Sept_WS.dat';
load 'WindSpeeds/Oct_WS.dat';load 'WindSpeeds/Nov_WS.dat';load 'WindSpeeds/Dec_WS.dat';

% LOADS WIND DIRECTION DATA FOR EACH MONTH 
load 'WindDirection/Jan_WD.dat';load 'WindDirection/Feb_WD.dat';load 'WindDirection/Mar_WD.dat';
load 'WindDirection/Apr_WD.dat';load 'WindDirection/May_WD.dat';load 'WindDirection/June_WD.dat';
load 'WindDirection/July_WD.dat';load 'WindDirection/Aug_WD.dat';load 'WindDirection/Sept_WD.dat';
load 'WindDirection/Oct_WD.dat';load 'WindDirection/Nov_WD.dat';load 'WindDirection/Dec_WD.dat';

% WIND SPEED AT HUB HEIGHT - Using the power law function
PwrLaw=@(h,v) round(v.*(h/15).^(1/7)); % defines power law function

% CONVERTS WIND SPEED VALUES TO THOSE AT OUR HUB HIGHT 85M
JanWS = PwrLaw(HH,Jan_WS); FebWS = PwrLaw(HH,Feb_WS); MarWS = PwrLaw(HH,Mar_WS);
AprWS = PwrLaw(HH,Apr_WS); MayWS = PwrLaw(HH,May_WS); JuneWS = PwrLaw(HH,June_WS);
JulyWS = PwrLaw(HH,July_WS); AugWS = PwrLaw(HH,Aug_WS); SeptWS = PwrLaw(HH,Sept_WS); 
OctWS = PwrLaw(HH,Oct_WS); NovWS = PwrLaw(HH,Nov_WS); DecWS = PwrLaw(HH,Dec_WS);

% INITIALIZES VECTOR WITH ALL WIND SPEED VALUES FOR THE YEAR 
WS = [JanWS,FebWS,MarWS,AprWS,MayWS,JuneWS,JulyWS,...
        AugWS,SeptWS,OctWS,NovWS,DecWS];

% INITIALIZES VARIOUS VECTORS/VALUES USED IN A & A' CALCULATIONS 
p = 1.23; % 
a_c = 0.2; % intializes critical value of a, used in calculation of a and a'
cut_in = 3; % initializes the wind speed value at which the windmill will start 
cut_off = 25; % initializes the wind speed value at which the windmill will stop 

% LOADS OTHER DATA FILES
load('DataFiles/radius.dat'); load('DataFiles/omega.dat'); load('DataFiles/twist.dat');
load('DataFiles/chord.dat'); load('DataFiles/DU21.dat'); load('DataFiles/DU30.dat');
load('DataFiles/DU35.dat'); load('DataFiles/DU40.dat'); load('DataFiles/NACA64.dat');

% INITIALIZES 
r = radius;     % creates a vector of the various radial positions along the blade r 
c = chord;      % creates vector of the values of the chord of the blade at different radial positions
twist = (pi/180).*twist; % converts twist of the blade at different radial positions to degrees 
w = (2*pi/60).*omega;    % converts rotational speed for different wind speeds to rad/s
B = 3;          % sets blade count to 3 blades
V0 = 1:1:25;    % initial V0 vector containing wind speeds from 1-25 m/s

% COMPUTES POWER PRODUCED BY ONE TURBINE
power  = power_calculation(V0,B,w,twist,c,r,p,a_c);

% CALCULATES THE NUMBER OF TURBINES NEEDED
[numberOfTurbines, turbinePower, powerNeeded] = calcNumTurbines(power,pop,WS);

% OUTPUTS THE NUMBER OF TURBINES NEEDED
fprintf('The population of the City of Calgary in 2016 was %d. Assuming the electricity consumption per capita is 16.5 MWh,\nthe power needed for the city per year is %.2f MWh.\n',pop,powerNeeded);
fprintf('A single turbine produced %.2f MWh in 2017, therefore the number of turbines required to power the City of Calgary\nin 2017 would have been %d.\n',turbinePower,numberOfTurbines);

% INITIALIZES MATRICIES FOR WIND SPEED BASED ON # OF DAYS IN THE MONTH
WS31 = [JanWS;MarWS;MayWS;JulyWS;AugWS;OctWS;DecWS]; 
WS30 = [AprWS;JuneWS;SeptWS;NovWS];
WS28 = FebWS;

% INITIALIZES VECTOR WITH ALL WIND SPEED DIRECTION VALUES FOR THE YEAR
WD = [Jan_WD,Feb_WD,Mar_WD,Apr_WD,May_WD,June_WD,July_WD,...
        Aug_WD,Sept_WD,Oct_WD,Nov_WD,Dec_WD];
    
% CALLS FUNCTION THAT PLOTS THE VARIOUS VALUES AS NEEDED
WindPlot(WD,WS,WS31,WS30,WS28,chord,twist,r,power);
   
        
        


