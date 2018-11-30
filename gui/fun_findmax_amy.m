function fun_findmax_amy(pathname, axe)

amyfile = fullfile('resources', 'ROIs', 'amy.nii');
v_amy = spm_vol(amyfile);
d_amy = spm_read_vols(v_amy);

set_mm = containers.Map;
ind = find(d_amy > 0);
sz = size(d_amy);
for j = ind'
    [x, y, z] = ind2sub(sz, j);
    p = [x, y, z];
    mm = fun_position2mm(p, v_amy.mat);
    set_mm(fun_arr2str(mm)) = 1;
end

spmTfile = fullfile(pathname, '_____GLM_1', 'spmT_0001.nii');
v_spmT = spm_vol(spmTfile);
d_spmT = spm_read_vols(v_spmT);
sz = size(d_spmT);

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

max_mm = fun_position2mm(max_p, v_spmT.mat);
% disp(max_p)
% disp(max_mm)

funpath = fullfile(pathname, '_____preprocessed_4');
load(fullfile(funpath, 'fun_filenames.mat'), 'fun_filenames')
len = length(fun_filenames);
for j = 1 : len
    fnames(j) = spm_vol(fullfile(funpath, ['sw', fun_filenames{j}]));
end
dd = spm_read_vols(fnames);
ts = squeeze(dd(max_p(1), max_p(2), max_p(3), :));

set(gcf, 'CurrentAxes', axe)

load(fullfile('resources', 'b_cond.mat'), 'cond')
len = size(ts, 1);
x = 1:len;
plot(ts, 'linewidth', 2)
yl = get(gca, 'YLim');
plot(x*0, 'color', 'w');

n = length(cond.onset);
for j = 1 : n
    rectangle('Position',...
        [cond.onset(j)/2, yl(1), cond.duration(j)/2, yl(2)-yl(1)],...
        'facecolor', 0.5+zeros(1, 4), 'edgecolor', 0.5+zeros(1, 4))
end

hold on
plot(x, ts, 'linewidth', 2);
hold off
set(gca, 'YLim', yl)
set(gca, 'YTick', [])
set(gca, 'XTick' ,[])
set(gca, 'XLim', [1, len])
set(gca, 'Box', 'Off')
title('杏仁核区域脑活动曲线')

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
