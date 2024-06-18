% The code in this repository is derived from the work of Lindgren et al. in their work: 
% Lindgren, L.; Grauers, A.; Ranggård, J.; Mäki, R. Drive-Cycle Simulations of Battery-Electric Large Haul Trucks
% for Open-Pit Mining with Electric Roads. Energies 2022, 15, 4871. https://doi.org/10.3390/en15134871

function mp=machine_param_bat_fp()
    % SETTING MACHINE PARAMETERS
    mp.name="bat_fp";
    mp.equvivalent_inertia_drive=57; %ton
    mp.empty_mass=250;
    mp.max_load=320;
    mp.max_traction_power=@max_traction_power;
    mp.min_traction_power=@min_traction_power;
    mp.roling_recistance=0.014;
    mp.max_dv_ds=1; %(km/h)/m
    mp.loss_wheel_dc=0.14;
    mp.bat.capacity=1000; %kWh
    mp.bat.r_norm=0.03;
    mp.aux_power=50; %kW
    mp.diesel_consumption_no_load=50/3600; %liter/s
    mp.diesel_consumption=0.26*619/635; %liter/kWh
    mp.max_trolley_power=12000; %kW
    mp.max_battery_charging_power=6000; %kW
    mp.A=70;
    mp.Cd=1;

    % CHANGE IN FRICTION FOR EXPERIMENT 4
    mp.modified_roling_recistance=0.22;
end

% INTERPOLATIONS FOR TRACTION POWER (UNMODIFIED)
function p=max_traction_power(v, ~) %v in km/h p in kW
    v=abs(v)+0.1;
    p=interp1q([0;19;41;65],[0;3940;3940;3260],v);
end
function p=min_traction_power(v) %v in km/h p in kW
    v=abs(v)+0.1;
    p=interp1q([0;22;41;65],[0;-4750;-4750;-3900],v)*0.7;
end


