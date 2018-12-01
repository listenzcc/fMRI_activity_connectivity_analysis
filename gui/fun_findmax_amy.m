function max_p = fun_findmax_amy(pathname, gg, hh, axe)

%% get all voxels in ROI as mm
amyfile = fullfile('resources', 'ROIs', 'amy.nii');
set_mm = fun_get_mmgrid_ROI(amyfile);

%% find all voxels in ROI as p
spmTfile = fullfile(pathname, '_____GLM_1',...
    sprintf('g%dh%d', gg, hh), 'spmT_0001.nii');
v_spmT = spm_vol(spmTfile);
d_spmT = spm_read_vols(v_spmT);
set_p = containers.Map;
for k = keys(set_mm)
    mm = fun_str2arr(k{1});
    p = fun_mm2position(mm, v_spmT.mat);
    p = floor(p);
    if ~check(p, size(d_spmT))
        continue
    end
    set_p(fun_arr2str(p)) = 1;
end

%% find max
max_ = -inf;
max_p = nan;
for pp = keys(set_p)
    p = fun_str2arr(pp{1});
    d = d_spmT(p(1), p(2), p(3));
    if max_ < d
        max_ = d;
        max_p = p;
    end
end
mp = max_p;
% expand one voxel
k = 1;
for a = -k : k
    for b = -k : k
        for c = -k : k
            p = mp + [a, b, c];
            if ~check(p, size(d_spmT))
                continue
            end
            d = d_spmT(p(1), p(2), p(3));
            if max_ < d
                max_ = d;
                max_p = p;
            end
        end
    end
end
max_mm = fun_position2mm(max_p, v_spmT.mat);

%% plot activity time series
funpath = fullfile(pathname, '_____preprocessed_4');
load(fullfile(funpath, 'fun_filenames.mat'), 'fun_filenames')
len = length(fun_filenames);
for j = 1 : len
    fvols(j) = spm_vol(fullfile(funpath, ['sw', fun_filenames{j}]));
end
dd = spm_read_vols(fvols);
ts = squeeze(dd(max_p(1), max_p(2), max_p(3), :));
set(gcf, 'CurrentAxes', axe)
len = size(ts, 1);
x = 1:len;
plot(ts, 'linewidth', 2)
yl = get(gca, 'YLim');
plot(x*0, 'color', 'w');
load(fullfile(pathname, 'TR.mat'), 'TR')
load(fullfile('resources', 'b_cond.mat'), 'cond')
n = length(cond.onset);
for j = 1 : n
    rectangle('Position',...
        [cond.onset(j)/TR, yl(1), cond.duration(j)/TR, yl(2)-yl(1)],...
        'facecolor', 0.5+zeros(1, 4), 'edgecolor', 0.5+zeros(1, 4))
end

%% plot 3D volume
hold on
plot(x, ts, 'linewidth', 2);
hold off
set(gca, 'YLim', yl)
set(gca, 'YTick', [])
set(gca, 'XTick' ,[])
set(gca, 'XLim', [1, len])
set(gca, 'Box', 'Off')
title('杏仁核区域脑活动曲线')

TMP_fname = fullfile(pwd, 'resources', 'canonical', 'avg152T1.nii');
cond.TR = TR;
fig = fun_plot_3D4D(TMP_fname, dd, d_spmT, v_spmT, max_mm, cond);
set(fig, 'NumberTitle', 'Off', 'Name', '杏仁核中的最强激活位置')

end

function isgood = check(p, sz)
sz = reshape(sz, size(p));
isgood = false;
if sum(p < 1) > 0
    return
end
if sum(p > sz) > 0
    return
end
isgood = true;
end
