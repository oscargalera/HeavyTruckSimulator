 % clear previous data
clear mpl %mpl machine parameter list
mpl(1) = machine_param();
clear dcl %dcl drive cycle parameter list

% initialise simulation parameters
Trolley_power = 8000;
VARIABLELOAD = [];
VARIABLEVEL = [];
numsim = 0;
charging_distance=0:1;

for noise=0.7
    for VARIABLEVEL=30
        for VARIABLELOAD=[0.333,0.5,1]
             numsim=numsim+1;
             dcl(numsim) = drivecycle_1(1,noise, VARIABLELOAD, VARIABLEVEL, charging_distance);
        end
    end
end

tic
clear sr
srv = cell(numsim,1);
sr = cell(1,numsim);
[iv,jv]=meshgrid(1:1,1:numsim);

prev_noise = -1; 
prev_v_max = 15.0;
Xpositions=[];

% Create a regular for loop to iterate over the values of iv and jv
for k=1:numel(iv)
    srv{k}=simulator(dcl(jv(k)), mpl(iv(k)), 0);

    noise = dcl(jv(k)).noise; % Obtener el valor actual del ruido
    v_max_pin = dcl(jv(k)).variablevel;

    fprintf("noise=%.2f, v_max=%.1f, load=%.2f, soc_diff=%.4f, timespent=%.4f, pmax@2000=%.4f, v@2000=%.4f\n", ...
        noise, dcl(jv(k)).variablevel, dcl(jv(k)).variableload, srv{k}.SOC(end)-srv{k}.SOC(1), ...
        srv{k}.t_1(end), srv{k}.p_mech(2000), srv{k}.speed(2000));
    
     enalgunmomenthabaixatde30 = false;
     for i = 1:length(srv{k}.SOC)
        if srv{k}.SOC(i) < 0.3
            fprintf("Xposition=%.1f\n\n", i);
            Xpositions = [Xpositions,i];
            enalgunmomenthabaixatde30 = true;
            break;
        end
    
     end
     if enalgunmomenthabaixatde30 == false
         Xpositions = [Xpositions,0];
     end

end

sr=cell(1,numsim);
for k=1:numel(iv)    
    sr{iv(k),jv(k)}=srv{k};
end

disp("PART 2 - CHARGING TIME");

charging_distance = Xpositions;

numsim = 0;

for noise=0.7
    for VARIABLEVEL=30
        for VARIABLELOAD=[0.333,0.5,1]
         numsim=numsim+1;
         if charging_distance(numsim)==0
            dcl(numsim) = drivecycle_1(1,noise, VARIABLELOAD, VARIABLEVEL, charging_distance(numsim));
         else
            dcl(numsim) = drivecycle_1(2,noise, VARIABLELOAD, VARIABLEVEL, charging_distance(numsim));
         end
        end
    end
end

% Create a regular for loop to iterate over the values of iv and jv
for k=1:numel(iv)
    srv{k}=simulator(dcl(jv(k)), mpl(iv(k)), 0);

    noise = dcl(jv(k)).noise; % Obtener el valor actual del ruido
    v_max_pin = dcl(jv(k)).variablevel;

    fprintf("noise=%.2f, v_max=%.1f, load=%.2f, soc_diff=%.4f, timespent=%.4f, pmax@2000=%.4f, v@2000=%.4f\n", ...
        noise, dcl(jv(k)).variablevel, dcl(jv(k)).variableload, srv{k}.SOC(end)-srv{k}.SOC(1), ...
        srv{k}.t_1(end), srv{k}.p_mech(2000), srv{k}.speed(2000));
end

sr=cell(1,numsim);
for k=1:numel(iv)    
    sr{iv(k),jv(k)}=srv{k};
end



clear srv
toc % print elapsed time