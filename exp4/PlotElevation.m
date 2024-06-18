close all
figure()
hold off
axes1=gca;
yyaxis(axes1,'left')

% TOP PLOT (SEE PAPER)
subplot(3,1,1)
for i=3
    time = [1:9000];
    elevation = sr{1,i}.dc.elevation;
    plot(time,elevation,'-','DisplayName',sr{1,i}.dc.name,'LineWidth',2)
    hold on
end
ylabel('Elevation')

% MIDDLE PLOT (SEE PAPER)
subplot(3,1,2)
for i=3
    time = [1:9000];
    speed = sr{1,i}.speed;
    plot(time,speed,'-','DisplayName',sr{1,i}.dc.name,'LineWidth',2)
    hold on
end
ylabel('Speed')

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