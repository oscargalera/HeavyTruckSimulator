function sr=simulator(drive_cycle, machine_param, mode)
    dc=drive_cycle;
    mp=machine_param;
    mass=dc.loaded*mp.max_load+mp.empty_mass;
    mass_d=mass+mp.equvivalent_inertia_drive;
    wp=dc.g.*dc.elevation.*mass./3600;
    dwpm=dc.g.*dc.elevation.*[0;diff(mass)]./3600;
    dwpe=dc.g.*[0;diff(dc.elevation)].*mass./3600;
    trolley_p_max=min(dc.trolley_p_max,mp.max_trolley_power);
    v=dc.v_max;
    if mp.bat.capacity>100
        v(trolley_p_max>10)=min(v(trolley_p_max>10),dc.trolley_speed_max);
    end
    wk=mass_d.*(v./3.6).^2/2/3600; %kWh
    for i=2:dc.driving_distance
        if mp.bat.capacity>100
            diesel=0;
        elseif trolley_p_max(i)>3000
            diesel=0;
        else
            diesel=1;
        end
        p_max=mp.max_traction_power(v(i-1),diesel);
        p_max=3940;
        tr_dw_max=p_max*(3.6/v(i-1))/3600;
        air_resistance_force=dc.air_density*mp.A*mp.Cd*(v(i-1)/3.6)^2/2;
        wk_new=min(wk(i),...
            max(0.01, wk(i-1)...
                -dwpe(i)...
                -mass(i).*(dc.g.*mp.roling_recistance./3600)...
                -1/3600/1000*air_resistance_force...
                +tr_dw_max));
        v(i)=min(v(i-1)+mp.max_dv_ds,3.6*sqrt((wk_new*3600)*2/mass_d(i)));
        wk(i)=mass_d(i)*(v(i)/3.6)^2/2/3600;
    end
    for i=dc.driving_distance-1:-1:1
        p_min=mp.min_traction_power(v(i+1));
        tr_dw_min=p_min*(3.6/v(i+1))/3600;
        air_resistance_force=dc.air_density*mp.A*mp.Cd*(v(i+1)/3.6)^2/2;
        wk_new=min(wk(i),...
            max(0.01,wk(i+1)...
            +dwpe(i)...
            +mass(i).*(dc.g.*mp.roling_recistance./3600)...
            +1/3600/1000*air_resistance_force...
            -tr_dw_min));
        v(i)=min(v(i+1)+mp.max_dv_ds,3.6*sqrt((wk_new*3600)*2/mass_d(i)));
        wk(i)=mass_d(i)*(v(i)/3.6)^2/2/3600;
    end
    dt=3.6./v;
    t_1=cumsum(dt);
    dwk=[0;diff(wk)];
    dw=dwpe+dwk;
    air_resistance_force=dc.air_density.*mp.A.*mp.Cd.*(v./3.6).^2./2/1000;
    air_resistance_power=air_resistance_force.*v;
    p_mech=dw./dt.*3600+...
           mass.*v./3.6.*mp.roling_recistance.*dc.g+...
           air_resistance_power;
    p_traction_dc=p_mech./(1-mp.loss_wheel_dc);
    p_traction_dc(p_mech<0)=p_mech(p_mech<0)./(1+mp.loss_wheel_dc);

    % MAIN SIMULATION LOOP
    trolley_power=zeros(size(dc.slope));
    SOC=zeros(size(dc.slope))+dc.soc_init;
    battery_power=zeros(size(dc.slope));
    battery_loss=zeros(size(dc.slope));
    diesel_consumption=zeros(size(dc.slope));
    for i=2:dc.driving_distance
        if mp.bat.capacity<100 && trolley_p_max(i)<2000
           diesel_consumption(i)=dt(i)*(...
               max(0,p_traction_dc(i))*mp.diesel_consumption/3600+...
               mp.diesel_consumption_no_load);
            SOC(i)=SOC(i-1);
        elseif mp.bat.capacity<100
            diesel_consumption(i)=dt(i)*mp.diesel_consumption_no_load;
            trolley_power(i)=p_traction_dc(i);
            SOC(i)=SOC(i-1);
       else
            trolley_power(i)=max(0,min(trolley_p_max(i),...
                p_traction_dc(i)+min(mp.max_battery_charging_power,...
                dc.soc_kp*mp.bat.capacity*(dc.soc_ref-SOC(i-1)))));
            battery_power(i)=trolley_power(i)-p_traction_dc(i)-mp.aux_power;
            battery_loss(i)=battery_power(i)^2/mp.bat.capacity*mp.bat.r_norm;
            SOC(i)=SOC(i-1)+(battery_power(i)-battery_loss(i))*dt(i)/3600/mp.bat.capacity;
        end
    end

    trolley_energy=sum(trolley_power.*dt)/3600;
    diff_bat_energy=(SOC(1)-SOC(end))*mp.bat.capacity;

    function W_error=energy_gain_vmax(v)
        ddt=max(0,3.6/v-3.6./v_trolley_sorted);
        W_gain=sum(ddt.*trolley_power_trolley(vti))/3600;
        W_error=W_gain-diff_bat_energy;
    end

    sr.speed=v;
    sr.p_mech=p_mech;
    sr.air_resistance_power=air_resistance_power;
    sr.p_traction_dc=p_traction_dc;
    sr.dt=dt;
    sr.t_1=t_1;
    sr.trolley_power=trolley_power;
    sr.SOC=SOC;
    sr.battery_power=battery_power;
    sr.battery_loss=battery_loss;
    sr.diesel_consumption=diesel_consumption;
    sr.dc=dc;
    sr.mp=mp;
    sr.diff_bat_energy=diff_bat_energy;
    sr.trolley_energy=trolley_energy;
end