function [P] = power_calculation(V0,B,w,twist,c,r,p,a_c)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

load('DataFiles/DU40.dat');
counter = 1;
M_i = zeros(1,length(r)-1);
sum_t = 0;


for i = 3:25
    for j = 1:17 % goes from 1 to 17 because thqt is the length of r
        a = 0;
        a_p = 0;
        a_new = 100;
        a_p_new = 100;
        while abs(a-a_new) >= 0.000001 || abs(a_p-a_p_new) >= 0.000001
            a = a_new;
            a_p = a_p_new;
% (2)  -  Compute the flow angle.
            phi_flow = atan((1-a)*V0(i)/((1+a_p)*w(i)*r(j)));
% (3)  -  Compute local angle of attack
            alpha_attack = phi_flow - twist(j);
% (4)  -  Determine C1(alpha) and C2(alpha) according to the given airfoil profile
            Cl= interp1((pi/180)*DU40(:,1),DU40(:,2),alpha_attack);
            Cd= interp1((pi/180)*DU40(:,1),DU40(:,3),alpha_attack);
% (5)  -  Compute normalized force Cn and Ct
            Cn = (Cl*cos(phi_flow))+(Cd*sin(phi_flow));
            Ct = (Cl*sin(phi_flow))-(Cd*cos(phi_flow));
% Calculation for sigma which is the local solidity
            sigma_sol = c(j)*B/(2*pi*r(j));
% (6)  -  Calculate a' and a
            a_new = 1/(4*((sin(phi_flow))^2)/(sigma_sol*Cn)+1);
            a_p_new = 1/((4*sin(phi_flow)*cos(phi_flow))/(sigma_sol*Ct)-1);
% Check to see if correction factor is needed
            if a_new > a_c 
                % Claculation for constant K
                K = 4*(sin(phi_flow))^2/(sigma_sol*Cn);
                % Applying correction factor for a
                a_new = 0.5*((2+K*(1-2*a_c))-sqrt(((K*(1-2*a_c)+2)^2)+(4*(K*a_c^2-1))));
            end
        end
        
        % Calculation of of relative velocity
        V_rel = V0(i)*(1-a)/sin(phi_flow);
        % Calculation of local tangental loads on thje segment of the blade
        tan_load(j) = 0.5*Ct*p*V_rel^2*c(j);
    end
    for g = 1:length(r)-1
    A_i = (tan_load(g+1)-tan_load(g))/(r(g+1)-r(g));
    B_i = ((r(g+1)*tan_load(g))-(r(g)*tan_load(g+1)))/(r(g+1)-r(g));
    M_i(g) = ((1/3)*A_i*((r(g+1))^3 - (r(g))^3))+(0.5*B_i*((r(g+1))^2 - (r(g))^2));
    end
     % calculating the total shaft torque buy suming each contributing shaft torque and multiplying that by the number of blades    
    M_tot = B*sum(M_i);
    P(i) = M_tot * w(i); % Calculation of power at each wind speed
    % Correction for any values that are higher than the nominal power
    % production
     if P(i) > 5.e+6
         P(i) = 5.e+6;
     end   
end
plot(V0,P);
ylim([0 6.e+6]);

end

