% The code in this repository is derived from the work of Lindgren et al. in their work: 
% Lindgren, L.; Grauers, A.; Ranggård, J.; Mäki, R. Drive-Cycle Simulations of Battery-Electric Large Haul Trucks
% for Open-Pit Mining with Electric Roads. Energies 2022, 15, 4871. https://doi.org/10.3390/en15134871

close all
figure()
hold off
axes1=gca;
yyaxis(axes1,'left')

% TOP PLOT (SEE PAPER)
subplot(3,1,1)
for i=1:3
    time = [1:9000];
    time = sr{1,i}.t_1;
    elevation = sr{1,i}.dc.elevation;
    plot(time,elevation,'-','DisplayName',sr{1,i}.dc.name,'LineWidth',2)
    hold on
end
ylabel('Elevation')

% MIDDLE PLOT (SEE PAPER)
subplot(3,1,2)
for i=1:3
    time = [1:9000];
    time = sr{1,i}.t_1;
    speed = sr{1,i}.speed;
    plot(time,speed,'-','DisplayName',sr{1,i}.dc.name,'LineWidth',2)
    hold on
end
ylabel('Speed')
legend('Load=0.3','Load=0.5','Load=1')

% BOTTOM PLOT (SEE PAPER)
subplot(3,1,3)
for i=1:3
    time = [1:9000];
    time = sr{1,i}.t_1;
    speed = sr{1,i}.speed;
    SOC = sr{1,i}.SOC;
    slope = diff(elevation);
    plot(time,SOC,'-','DisplayName',sr{1,i}.dc.name,'LineWidth',2)
    hold on
end

% DRAW THRESHOLD (SEE PAPER) AND SAVE
yline(0.3, '--r', 'LineWidth', 1.5);
hold off
ylabel('SOC')
xlabel('X-position (m)')
saveas(gcf,"chargingtwoloads.png")
