function [P] = power_calculation(V0,B,w,twist,c,r,p,a_c)
% This function calculates the values of a and a' and then calculates the 
% power output of the windmill at speeds from 1-25 m/s

% LOADS FILES AND INITIALIZES VARIABLES
load 'DataFiles/DU40.dat' DU40;
profile = DU40;
M_i = zeros(1,length(r)-1); % initializes a vector of zeros of
P = zeros(25,1); % initializes a column of length 25

% LOOPS THAT CALCULATE VALUES OF A AND A' FOR EACH WIND SPEED AT EACH
% RADIUS AND CALCULATES POWER AT EACH WIND SPEED
for i = 3:length(V0) % iterates through each windspeed from 3 m/s to 25 m/s
    tan_load = zeros(17,1);
    
    for j = 1:length(r) % iterates through radius indexes 1 through 17
        a = 0;         % a values have to be reset each time so that we can enter the while loop for each iteration
        a_p = 0;
        a_new = 100;
        a_p_new = 100;
        
        while abs(a-a_new) >= 0.000001 || abs(a_p-a_p_new) >= 0.000001
            a = a_new;          % reset the original a and a' values before 
            a_p = a_p_new;      % operating on the current value
            phi_flow = atan((1-a)*V0(i)/((1+a_p)*w(i)*r(j))); % Computes the flow angle.
            alpha_attack = phi_flow - twist(j); % Computes local angle of attack

            Cl = interp1((pi/180)*profile(:,1),profile(:,2),alpha_attack); % Determine Cl(alpha) using interpolation according to given airfoil profile
            Cd = interp1((pi/180)*profile(:,1),profile(:,3),alpha_attack); % Determine Cd(alpha using interpolation according to given airfoil profile

            Cn = (Cl*cos(phi_flow))+(Cd*sin(phi_flow)); % computes normalized force for Cn
            Ct = (Cl*sin(phi_flow))-(Cd*cos(phi_flow)); % computes normalized force for Ct

            sigma_sol = c(j)*B/(2*pi*r(j)); % Calculation for sigma which is the local solidity for each 

            a_new = 1/(4*((sin(phi_flow))^2)/(sigma_sol*Cn)+1); % calculates a
            a_p_new = 1/((4*sin(phi_flow)*cos(phi_flow))/(sigma_sol*Ct)-1); % calculates a'
            
            % Check to see if correction factor is needed
            if a_new > a_c % If a_new is greater than 0.2, a correction factor is applied. 
                K = 4*(sin(phi_flow))^2/(sigma_sol*Cn); % Calculation for constant K
                a_new = 0.5*((2+K*(1-2*a_c))-sqrt(((K*(1-2*a_c)+2)^2)+(4*(K*a_c^2-1)))); % Applying correction factor for a
            end
            
        end
        
        V_rel = V0(i)*(1-a)/sin(phi_flow);  % Calculation of of relative velocity
        tan_load(j) = 0.5*Ct*p*V_rel^2*c(j); % Calculation of local tangental loads on the segment of the blade
        
    end
    
    for g = 1:length(r)-1
        A_i = (tan_load(g+1)-tan_load(g))/(r(g+1)-r(g)); % calculates value of Ai
        B_i = ((r(g+1)*tan_load(g))-(r(g)*tan_load(g+1)))/(r(g+1)-r(g)); % calculates value of Bi
        M_i(g) = ((1/3)*A_i*((r(g+1))^3 - (r(g))^3))+(0.5*B_i*((r(g+1))^2 - (r(g))^2)); % calculates shaft torque, for one blade
    end
       
    M_tot = B*sum(M_i); % calculates total shaft torque by summing all values of the shaft torque vector and multiplying by number of blades
    P(i) = M_tot * w(i); % calculation of power at each wind speed

    if P(i) > 5.e+6 % caps the power output at 5 MW
    	P(i) = 5.e+6;
    end   
    
end

% CREATES AND FORMATS PLOT
plot(V0,P,'Color','red','Linewidth',3); % plots the power output versus the windspeed from 1-25 m/s
ylabel('Rotor Power [W]'); % sets y-label
xlabel('Windspeed (m/s) at Hub Height of 85 meters'); % sets x-label
ylim([0 6.e+6]); % sets y-limit 
title('Power vs Windspeed at 85 meters'); % sets the title of the graph
legend('Power'); % sets the legend 

end

