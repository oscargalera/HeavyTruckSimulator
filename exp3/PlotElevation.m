close all
figure()
hold off
axes1=gca;
yyaxis(axes1,'left')

% TOP PLOT (SEE PAPER)
subplot(3,1,1)
for i=3
    time = [1:9000];
    %time = sr{1,i}.t_1(1:8999);
    elevation = sr{1,i}.dc.elevation(1:9000);
    plot(time,elevation,'-','DisplayName',sr{1,i}.dc.name,'LineWidth',2)
    hold on
end
 ylabel('Elevation')

% MIDDLE PLOT (SEE PAPER)
subplot(3,1,2)
for i=3
    time = [1:9000];
    %time = sr{1,i}.t_1(1:8999);
    speed = sr{1,i}.speed(1:9000);
    plot(time,speed,'-','DisplayName',sr{1,i}.dc.name,'LineWidth',2)
    hold on
end
 ylabel('Speed')
 legend('Load=0.3','Load=0.5','Load=1')

% BOTTOM PLOT (SEE PAPER)
subplot(3,1,3)
for i=3
    time = [1:9000];
    speed = sr{1,i}.speed;
    SOC = sr{1,i}.SOC;
    slope = diff(elevation);

    plot(time,SOC,'-','DisplayName',sr{1,i}.dc.name,'LineWidth',2)
    hold on
end

% DRAW THRESHOLD (SEE PAPER) AND SAVE
yline(0.3, '--r', 'LineWidth', 1.5);
ylim([0 1]);
hold off
ylabel('SOC')
xlabel('X-position (m)')
saveas(gcf,"chargingtwoloads.png")