function hm_max = fun_plot_artificial(appPath, pathname, axe1, axe2)

funpath = fullfile(pathname, '_____preprocessed_4');
d = dir(fullfile(funpath, 'rp_*.txt'));
hmtxt = fullfile(funpath, d(1).name);
hm = load(hmtxt);
len = size(hm, 1);
x = 1:len;

load(fullfile(pathname, 'TR.mat'), 'TR')

load(fullfile(appPath, 'resources', 'b_cond.mat'), 'cond')
n = length(cond.onset);

set(gcf, 'CurrentAxes', axe1)
plot(hm(:, 1:3), 'linewidth', 2)
yl = get(gca, 'ylim')*3;
for j = 1 : n
    rectangle('Position',...
        [cond.onset(j)/TR, yl(1), cond.duration(j)/TR, yl(2)-yl(1)],...
        'facecolor', 0.7+zeros(1, 3), 'edgecolor', 0.7+zeros(1, 3))
end
hold on
as = plot(x, hm(:, 1:3), 'linewidth', 2);
hold off
legend(as, {'x-', 'y-', 'z-'})
set(gca, 'XTick' ,[])
set(gca, 'XLim', [1, len])
set(gca, 'YLim', yl/3)
set(gca, 'Box', 'Off')
title('头动曲线（毫米）')

set(gcf, 'CurrentAxes', axe2)
plot(hm(:, 4:6), 'linewidth', 2)
yl = get(gca, 'ylim')*3;
for j = 1 : n
    rectangle('Position',...
        [cond.onset(j)/TR, yl(1), cond.duration(j)/TR, yl(2)-yl(1)],...
        'facecolor', 0.7+zeros(1, 3), 'edgecolor', 0.7+zeros(1, 3))
end
hold on
as = plot(x, hm(:, 4:6), 'linewidth', 2);
hold off
legend(as, {'点头', '歪头', '摇头'})
set(gca, 'XTick' ,[])
set(gca, 'XLim', [1, len])
set(gca, 'YLim', yl/3)
set(gca, 'Box', 'Off')
title('头动曲线（角度）')

hm_max = max(abs(hm));

end

