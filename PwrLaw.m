function [v0] = PwrLaw(h,v)
%This function uses the power law to calculate the wind speed at the
%hub height with inputs of wind speed at some given height
H=15; %all of our windspeed data is at 15m
v0=round(v*(h/H)^(1/7)); % rounds the power law to nearest integer
end

