% ENME 337, Final Project 
% Due Dec 3, 2018 WOOOOOO WOOOOO #2

close all; clear; clc;

p = 1.23;
a_c = 0.2; 
cut_in = 3;
cut_off = 25; 

load('radius.dat');
load('omega.dat');
load('twist.dat');
load('chord.dat');
load('DU21.dat');
load('DU30.dat');
load('DU35.dat');
load('DU40.dat');
load('NACA64.dat');

w = (load('omega.dat'))';     % rotational speed for different wind speeds
r = (load('radius.dat'))';    % radial positions along the blade r 
chord = (load('chord.dat'))'; % chord of the blade at different radial positions
twist = (load('twist.dat'))'; % twist angle of the blade in degrees at different radial positions 

a = 100;
a_p = 100;

