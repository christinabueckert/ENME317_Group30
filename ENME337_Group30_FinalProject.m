%{
% ENME 337, Final Project 
% Due Dec 3, 2018 WOOOOOO WOOOOO #2
%}
close all; clear; clc;
% Due Dec 3, 2018 WOOOOOO WOOOOO #2
% given city: calgary, hub height: 85m, air foil: DU40
clc;clear;close all;

%preliminary data
HH=85; %Hub height given in metres 
Pop=1237656; %from wikipedia page for 2016
cvn=1000/3600; %conversion factor to multiply by to convert from km/h to m/s
 %WIND SPEED DATA
fileData(cvn); %initializes function the sets up all the wind data
% sets up each months vector
JanWS=zeros(31); FebWS=zeros(28); MarWS=zeros(31); AprWS=zeros(30); MayWS=zeros(31); JuneWS=zeros(30);
JulyWS=zeros(31); AugWS=zeros(31); SeptWS=zeros(30); OctWS=zeros(31); NovWS=zeros(30); DecWS=zeros(31);
load 'WindSpeeds/Jan_WS.dat';load 'WindSpeeds/Feb_WS.dat';load 'WindSpeeds/Mar_WS.dat';
load 'WindSpeeds/Apr_WS.dat';load 'WindSpeeds/May_WS.dat';load 'WindSpeeds/June_WS.dat';
load 'WindSpeeds/July_WS.dat';load 'WindSpeeds/Aug_WS.dat';load 'WindSpeeds/Sept_WS.dat';
load 'WindSpeeds/Oct_WS.dat';load 'WindSpeeds/Nov_WS.dat';load 'WindSpeeds/Dec_WS.dat';

%WIND SPEED AT HUB HEIGHT// Power Law
PwrLaw=@(h,v) round(v*(h/15)^(1/7));
%the subsequent for loops use the defined power law function to set every
%wind speed value to that at our hub height of 85m; there are 3 loops bc
%months are either 28, 30, or 31 days long
for i=1:length(Jan_WS) %31 day loop
    JanWS(i)=PwrLaw(HH,Jan_WS(i));
    MarWS(i)=PwrLaw(HH,Mar_WS(i));
    MayWS(i)=PwrLaw(HH,May_WS(i));
    JulyWS(i)=PwrLaw(HH,July_WS(i));
    AugWS(i)=PwrLaw(HH,Aug_WS(i));
    OctWS(i)=PwrLaw(HH,Oct_WS(i));
    DecWS(i)=PwrLaw(HH,Dec_WS(i));
end
for i=1:length(June_WS)%30day loop
    AprWS(i)=PwrLaw(HH,Apr_WS(i));
    JuneWS(i)=PwrLaw(HH,June_WS(i));
    SeptWS(i)=PwrLaw(HH,Sept_WS(i));
    NovWS(i)=PwrLaw(HH,Nov_WS(i));
end
for i=1:length(FebWS) %28 day loop
    FebWS(i)=PwrLaw(HH,Feb_WS(i));
end

p = 1.23;
a_c = 0.2; 
cut_in = 3;
cut_off = 25; 

load('DataFiles/radius.dat'); load('DataFiles/omega.dat'); load('DataFiles/twist.dat');
load('DataFiles/chord.dat'); load('DataFiles/DU21.dat'); load('DataFiles/DU30.dat');
load('DataFiles/DU35.dat'); load('DataFiles/DU40.dat'); load('DataFiles/NACA64.dat');
%Sets of functions wrt r
r = radius'   ; % radial positions along the blade r 
chord = chord'; % chord of the blade at different radial positions
twist = twist'; % twist angle of the blade in degrees at different radial positions 

w = omega';    % rotational speed for different wind speeds
B = 3;
%just plot this for the hell of it (you can get rid of this later)
%plot(r,chord,r,twist);

%% Computation of Power Production
% (1)  -  Initialize a? and a.
a = 100;
a_p = 100;

% (2)  -  Compute the flow angle.
tan_psi = @(A, Ap, V0, Omega, R) ((1-A)*V0)/((1+Ap)*Omega*R); %adds function for tan(psi)
psi = @(A, Ap, V0, Omega, R) arctan(tan_psi(A, Ap, V0, Omega, R)); %inverse tans to find psi

% (3)  -  Compute local angle of attack
alpha = @(Psi,Theta) Psi - Theta;

% (4)  -  Determine C1(alpha) and C2(alpha) according to the given airfoil profile

% (5)  -  Compute normalized force Cn and Ct
Cn = @(Cl,Cd,Psi) (Cl*cos(Psi))+(Cd*sin(Psi));
Ct = @(Cl,Cd,Psi) (Cl*sin(Psi))-(Cd*cos(Psi));

% (6)  -  Calculate a' and a
% c = @(R) local chord at position r => I think you need to do the
% interpolation but who knows
% sigma = @(R,B)  


% (7)  -  Apply the following correction (called Glauert correction) for
                %large values of a
                
% (8)  -  If a? and a has changed more than a certain tolerance (use 1e-6), go to step (2) or
                %else proceed to the next step

        
        


