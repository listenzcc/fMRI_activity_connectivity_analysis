function max_c_mm = fun_findmax_corr(appPath, pathname, max_p, cm, handles)

%% get all voxels in ROI as mm
ROIfile = fullfile(appPath, 'resources', 'ROIs', 'roi_ba_9_46.nii');
set_mm = fun_get_mmgrid_ROI(ROIfile);

%% load 4D functional image
funpath = fullfile(pathname, '_____preprocessed_4');
load(fullfile(funpath, 'fun_filenames.mat'), 'fun_filenames')
len = length(fun_filenames);
for j = 1 : len
    fvols(j) = spm_vol(fullfile(funpath, ['sw', fun_filenames{j}]));
end
v_4D = fvols(1);
mat_4D = v_4D.mat;
img_4D = spm_read_vols(fvols);
sz = size(img_4D);
sz = sz(1:3);

%% max GLM time series
max_ts = get_ts(img_4D, max_p);

%% time series in ROI
set_p = containers.Map;
for k = keys(set_mm)
    mm = fun_str2arr(k{1});
    p = fun_mm2position(mm, mat_4D);
    p = floor(p);
    if ~check(p, sz)
        continue
    end
    set_p(fun_arr2str(p)) = 1;
end

ROI_ts = [];
ROI_p = [];
for pp = keys(set_p)
    p = fun_str2arr(pp{1});
    ts = get_ts(img_4D, p);
    ROI_ts = [ROI_ts, ts];
    ROI_p = [ROI_p, p'];
end

if get(handles.checkbox3, 'Value')
    global_ts = get_global(img_4D);
    max_ts = fun_regout(max_ts, global_ts);
    ROI_ts = fun_regout(ROI_ts, global_ts);
end

c = fun_corr(max_ts, ROI_ts);
[a, b] = max(c);
max_c_p = ROI_p(:, b);

%% plot corr values
img_over = zeros(sz);
mat_over = mat_4D;
len = size(ROI_p, 2);
for j = 1 : len
    p = ROI_p(:, j);
    img_over(p(1), p(2), p(3)) = c(j);
end

TMP_fname = fullfile(appPath, 'resources', 'canonical', 'avg152T1.nii');
load(fullfile(pathname, 'TR.mat'), 'TR')
load(fullfile(appPath, 'resources', 'b_cond.mat'), 'cond')
cond.TR = TR;
max_c_mm = fun_position2mm(max_c_p, mat_over);

dummy = struct;
dummy.fig = handles.figure1;
dummy.axe1 = handles.axes_5;
dummy.axe2 = handles.axes_6;
dummy.axe3 = handles.axes_7;
dummy.axe4 = []; % handles.axes_8;

fig = fun_plot_3D4D(TMP_fname, img_4D, img_over, v_4D, max_c_mm, cond, cm, 0, dummy);
% set(fig, 'NumberTitle', 'Off', 'Name', 'MPFC中最强功能连接位置，即TMS靶点')
end

function c = get_ts(a, b)
c = squeeze(a(b(1), b(2), b(3), :));
end

function c = get_global(a)
for j = 1 : 3
    a = squeeze(mean(a, 1));
end
c = a';
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
