function [P] = power_calculation(V0,B,w,twist,c,r,p,a_c)
% This function calculates the power output of the configuration described

load('DataFiles/DU40.dat');
profile = DU40;
M_i = zeros(1,length(r)-1);
%sum_t = 0;
P = zeros(25,1);
for i = 3:25 % iterates through each windspeed from 3 m/s to 5 m/s
    tan_load = zeros(17,1);
    for j = 1:17 % iterates through radius indexes 1 through 17
        a = 0;         % a values have to be reset each time so that we can enter the while loop for each iteration
        a_p = 0;
        a_new = 100;
        a_p_new = 100;
        while abs(a-a_new) >= 0.000001 || abs(a_p-a_p_new) >= 0.000001
            a = a_new;          % reset the original a and a' values before 
            a_p = a_p_new;      % operating on the current value
            % Compute the flow angle.
            phi_flow = atan((1-a)*V0(i)/((1+a_p)*w(i)*r(j))); 
            % Compute local angle of attack
            alpha_attack = phi_flow - twist(j);
            % Determine Cl(alpha) and Cd(alpha) according to the given
            % airfoil profile by interpolation
            Cl = interp1((pi/180)*profile(:,1),profile(:,2),alpha_attack);
            Cd = interp1((pi/180)*profile(:,1),profile(:,3),alpha_attack);
            % (5) Compute normalized force Cn and Ct
            Cn = (Cl*cos(phi_flow))+(Cd*sin(phi_flow));
            Ct = (Cl*sin(phi_flow))-(Cd*cos(phi_flow));
            % Calculation for sigma which is the local solidity for each 
            sigma_sol = c(j)*B/(2*pi*r(j));
            % (6) Calculate a' and a
            a_new = 1/(4*((sin(phi_flow))^2)/(sigma_sol*Cn)+1);
            a_p_new = 1/((4*sin(phi_flow)*cos(phi_flow))/(sigma_sol*Ct)-1);
            % Check to see if correction factor is needed
            if a_new > a_c % If a_new is greater than 0.2, a correction factor is applied. 
                % Claculation for constant K
                K = 4*(sin(phi_flow))^2/(sigma_sol*Cn);
                % Applying correction factor for a
                a_new = 0.5*((2+K*(1-2*a_c))-sqrt(((K*(1-2*a_c)+2)^2)+(4*(K*a_c^2-1))));
            end
        end
        
        % Calculation of of relative velocity
        V_rel = V0(i)*(1-a)/sin(phi_flow);
        % Calculation of local tangental loads on the segment of the blade
        tan_load(j) = 0.5*Ct*p*V_rel^2*c(j);
    end
    for g = 1:length(r)-1
        A_i = (tan_load(g+1)-tan_load(g))/(r(g+1)-r(g));
        B_i = ((r(g+1)*tan_load(g))-(r(g)*tan_load(g+1)))/(r(g+1)-r(g));
        M_i(g) = ((1/3)*A_i*((r(g+1))^3 - (r(g))^3))+(0.5*B_i*((r(g+1))^2 - (r(g))^2));
    end
     % calculating the total shaft torque by suming each contributing 
     %  shaft torque and multiplying that by the number of blades    
    M_tot = B*sum(M_i);
    P(i) = M_tot * w(i); % Calculation of power at each wind speed
    % Correction for any values that are higher than the nominal power
    % production
     if P(i) > 5.e+6
         P(i) = 5.e+6;
     end   
end
plot(V0,P,'Color','red','Linewidth',3);
ylabel('Rotor Power [W]');
xlabel('Windspeed (m/s) at Hub Height of 85 meters');
ylim([0 6.e+6]);
title('Power vs Windspeed at 85 meters');
legend('Power');





end

