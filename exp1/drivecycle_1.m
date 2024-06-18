function dc=drivecycle_1(t_case,noise, VARIABLELOAD, VARIABLEVEL, charging_distance)

% SET DRIVE CYCLE CHARACTERISTICS (LENGTH, SLOPE, ETC.)
dc.name="noise="+int2str(noise*10);
dc.g=9.822;
dc.case=t_case;
dc.noise = noise;
dc.air_density=1.22;
dc.driving_distance=9000;
dc.variablevel= VARIABLEVEL;
dc.variableload= VARIABLELOAD;
dc.slope=zeros(dc.driving_distance,1);
dc.slope([1000:3500])=0.15;
dc.slope((dc.driving_distance/2+1):dc.driving_distance)=-dc.slope([dc.driving_distance/2:-1:1]);
dc.slope([1:dc.driving_distance]) = dc.slope([1:dc.driving_distance]);
dc.elevation=cumsum(dc.slope);

% ADD SMOOTH NOISE TO ELEVATION TO SIMULATE ROUGH TERRAIN
dc.elevation=dc.elevation + (rand([9000,1])-ones([9000,1])*0.5) * noise;
for i=3:length(dc.elevation)
    dc.elevation(i) = mean(dc.elevation(i-2:i));
end

% UNLOAD MHET IN THE CENTRE OF THE DRIVE CYCLE
dc.loaded=zeros(dc.driving_distance,1);
dc.loaded(1:dc.driving_distance/2)=VARIABLELOAD;
dc.v_max=zeros(dc.driving_distance,1)+VARIABLEVEL;

% SET THE CHARGING STRATEGY FOR EXPERIMENTS 2, 3, AND 4
dc.trolley_p_max=zeros(dc.driving_distance,1);
if t_case==2
    dc.name="load=0."+int2str(VARIABLELOAD*10);
    dc.trolley_p_max(charging_distance:charging_distance+2)=4000;
    dc.v_max(charging_distance:charging_distance+2)=0.02;
end
if t_case==3
    dc.name="load=0."+int2str(VARIABLELOAD*10);
    dc.trolley_p_max(charging_distance:charging_distance+2)=4000;
    dc.v_max(charging_distance:charging_distance+2)=0.02;
    dc.elevation(charging_distance:charging_distance+2)=dc.elevation(charging_distance);

     dc.trolley_p_max(charging_distance_1:charging_distance_1+2)=4000;
     dc.v_max(charging_distance_1:charging_distance_1+2)=0.02;
     dc.elevation(charging_distance_1:charging_distance_1+2)=dc.elevation(charging_distance_1);
end
if t_case==4
    dc.name="load=0."+int2str(VARIABLELOAD*10);
    dc.trolley_p_max(charging_distance:charging_distance+2)=4000;
    dc.v_max(charging_distance:charging_distance+2)=0.02;
    dc.elevation(charging_distance:charging_distance+2)=dc.elevation(charging_distance);

     dc.trolley_p_max(charging_distance_1:charging_distance_1+2)=4000;
     dc.v_max(charging_distance_1:charging_distance_1+2)=0.02;
     dc.elevation(charging_distance_1:charging_distance_1+2)=dc.elevation(charging_distance_1);
end

% SOC CONFIGURATION
dc.rel_massflow=0.50;
dc.trolley_speed_max=50;
dc.soc_init=1;
dc.soc_ref=5;
dc.soc_kp=10;
dc.soc_center=0.5;