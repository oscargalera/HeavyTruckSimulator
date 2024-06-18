% CLEAR PREVIOUS DATA
clear mpl
mpl(1) = machine_param();
clear dcl

% INITIALISE SIMULATION PARAMETERS
Trolley_power = 8000;
VARIABLELOAD = [];
VARIABLEVEL = [];
numsim = 0;
charging_distance=1350:1950;
noise = 0.5;
prev_noise = -1;
prev_v_max = 15.0;

% TEST DIFFERENT CONDITIONS
for VARIABLEVEL=15:5:35
    for VARIABLELOAD=0.8:0.05:1
         numsim=numsim+1;
         dcl(numsim) = drivecycle_1(1,noise, VARIABLELOAD, VARIABLEVEL, charging_distance);
    end
end

% TRANSFER DATA INTO SR STRUCT
clear sr
srv = cell(numsim,1);
sr = cell(1,numsim);
[iv,jv]=meshgrid(1:1,1:numsim);

% COMPUTE POSITIONS OF CHARGERS
Xpositions=[];
for k=1:numel(iv)
    srv{k}=simulator(dcl(jv(k)), mpl(iv(k)), 0);
    noise = dcl(jv(k)).noise;
    v_max_pin = dcl(jv(k)).variablevel;
    if  v_max_pin ~= prev_v_max
        fprintf("Average position=%.2f, Standard deviation=%.2f\n~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n\n", mean(Xpositions(end-4:end)), std(Xpositions(end-4:end)) ); % Imprimir el mensaje del ruido actual
        prev_v_max = v_max_pin;
    end

    % PRINT INFORMATION ON DRIVE CYCLE
    fprintf("noise=%.2f, v_max=%.1f, load=%.2f, soc_diff=%.4f, timespent=%.4f, pmax@2000=%.4f, v@2000=%.4f\n", ...
        noise, dcl(jv(k)).variablevel, dcl(jv(k)).variableload, srv{k}.SOC(end)-srv{k}.SOC(1), ...
        srv{k}.t_1(end), srv{k}.p_mech(2000), srv{k}.speed(2000));

    % STATE CHARGER POSITION
    for i = 1:length(srv{k}.SOC)
        if srv{k}.SOC(i) < 0.3
            fprintf("Xposition=%.1f\n\n", i);
            Xpositions = [Xpositions,i];
            break;
        end
    end

end

% TRANSFER DATA INTO SR STRUCT
sr=cell(1,numsim);
for k=1:numel(iv)
    sr{iv(k),jv(k)}=srv{k};
end