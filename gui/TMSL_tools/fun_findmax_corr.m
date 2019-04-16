function max_c_mm = fun_findmax_corr(appPath, pathname, max_p, cm, handles)

%% get all voxels in ROI as mm
ROIfile = fullfile(appPath, 'resources', 'ROIs', 'roi_ba_46.nii');
set_mm = fun_get_mmgrid_ROI(ROIfile);
v_ROIfile = spm_vol(ROIfile);

%% load 4D functional image
funpath = fullfile(pathname, '_____preprocessed_4');
load(fullfile(funpath, 'fun_filenames.mat'), 'fun_filenames')
len = length(fun_filenames);
for j = 1 : len
    fvols(j) = spm_vol(fullfile(funpath, ['sw', fun_filenames{j}]));
end
v_4D = fvols(1);
% v_ROIfile = v_4D;
% mat_4D = v_4D.mat;
img_4D = spm_read_vols(fvols);

%% load inbrain mask
maskpath = fullfile(pathname, '_____GLM_1', 'g1h0');
v_mask = spm_vol(fullfile(maskpath, 'mask.nii'));
inbrain_mask = spm_read_vols(v_mask);
kernel = ones(3, 3, 3);
brain_mask_conv = convn(double(inbrain_mask), kernel, 'same');
brainedge_mask = brain_mask_conv;
brainedge_mask(brain_mask_conv==sum(kernel(:))) = 0;

%% max GLM time series
max_ts = get_ts(img_4D, max_p);
mt = max_ts;
sz = v_4D.dim;
c = inbrain_mask;
global_ts = get_global(img_4D);
if get(handles.checkbox3, 'Value')
    mt = fun_regout(mt, global_ts);
end
mt = myfilter(mt);

%% debug starts
% % calculate mt as mean value of amy ROI
% amyfile = fullfile(appPath, 'resources', 'ROIs', 'amy.nii');
% set_mm_amy = fun_get_mmgrid_ROI(amyfile);
% set_p = containers.Map;
% for k = keys(set_mm_amy)
%     mm = fun_str2arr(k{1});
%     p = fun_mm2position(mm, v_4D.mat);
%     p = floor(p);
%     if ~check(p, v_4D.dim)
%         continue
%     end
%     set_p(fun_arr2str(p)) = 1;
% end
% mt = mt - mt;
% for k = keys(set_p)
%     mt = mt + get_ts(img_4D, fun_str2arr(k{1}));
% end
% if get(handles.checkbox3, 'Value')
%     mt = fun_regout(mt, global_ts);
% end
% mt = myfilter(mt);

% % calculate FC map
% for d1 = 1 : sz(1)
%     for d2 = 1 : sz(2)
%         for d3 = 1 : sz(3)
%             if inbrain_mask(d1, d2, d3) == 0
%                 continue
%             end
%             ts = squeeze(img_4D(d1, d2, d3, :));
%             if get(handles.checkbox3, 'Value')
%                 ts = fun_regout(ts, global_ts);
%             end
%             ts = myfilter(ts);
%             c(d1, d2, d3) = fun_corr(mt, ts);
%         end
%     end
% end
% v_tmp = v_4D;
% v_tmp.fname = 'FCmap.nii';
% v_tmp.dt(1) = 16;
% spm_write_vol(v_tmp, c);

% % show FC map in xjview
% f = gcf;
% xjview(v_tmp.fname)
% figure(f)
% debug ends

%% time series in ROI
% set_p = containers.Map;
ROI_ts = [];
ROI_p = [];
for k = keys(set_mm)
    mm = fun_str2arr(k{1});
    if mm(3) < 15
        continue
    end
    
    p = fun_mm2position(mm, v_mask.mat);
    p = floor(p);
    if brainedge_mask(p(1), p(2), p(3)) == 0
        continue
    end
    
    p = fun_mm2position(mm, v_4D.mat);
    p = floor(p);
    if ~check(p, v_4D.dim)
        continue
    end
    
    ts = get_ts(img_4D, p);
    if get(handles.checkbox3, 'Value')
        ts = fun_regout(ts, global_ts);
    end
    ROI_ts = [ROI_ts, ts];
    p = fun_mm2position(mm, v_ROIfile.mat);
    p = floor(p);
    ROI_p = [ROI_p, p];
    %     set_p(fun_arr2str(p)) = 1;
end

% ROI_ts = [];
% ROI_p = [];
% for pp = keys(set_p)
%     p = fun_str2arr(pp{1});
%     ts = get_ts(img_4D, p);
%     ROI_ts = [ROI_ts, ts];
%     ROI_p = [ROI_p, p'];
% end

if get(handles.checkbox3, 'Value')
    ROI_ts = fun_regout(ROI_ts, global_ts);
end

% ROI_p_ = ROI_p;
% ROI_p_(1, :) = ROI_p_(1, :) * 3;
% ROI_p_(2, :) = ROI_p_(2, :) * 3;
% ROI_p_(3, :) = ROI_p_(3, :) * 4;
c = fun_corr(mt, myfilter(ROI_ts));
% [a, b] = max(abs(c) .* (diag(ROI_p_'*ROI_p_)').^0.5);
[a, b] = max(abs(c));
max_c_p = ROI_p(:, b);

%% plot corr values
img_over = zeros(v_ROIfile.dim);
mat_over = v_ROIfile.mat;
len = size(ROI_p, 2);
for j = 1 : len
    p = ROI_p(:, j);
    img_over(p(1), p(2), p(3)) = abs(c(j));
end

TMP_fname = fullfile(appPath, 'resources', 'canonical', 'single_subj_T1.nii');
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

f = gcf;
fun_plot_3D4D(TMP_fname, img_4D, v_4D, img_over, mat_over, max_c_mm, cond, cm, 0, dummy);
if get(handles.checkbox4, 'Value')
    fig = fun_plot_3D4D(TMP_fname, img_4D, v_4D, img_over, mat_over, max_c_mm, cond, cm, 0, []);
    set(fig, 'NumberTitle', 'Off', 'Name', 'MPFC中最强功能连接位置，即TMS靶点')
end
figure(f)
end

function new_ts = myfilter(ts)
ts = spm_detrend(ts, 1);
new_ts = ts;

% design = zeros(90, 1);
% design(15+1:30) = 1;
% design(45+1:60) = 1;
% design(75+1:90) = 1;
% design = conv(design, spm_hrf(2), 'same');
% df = fft(design);
% f = fft(ts);
% % f = f .* (df~=0);
% f = f .* abs(df);
% new_ts = ifft(f);

% freqs = linspace(0, 0.5, length(ts));
% x = 1;
% while freqs(x) < 1/30
%     x = x + 1;
% end
% f = fft(ts);
% f(1:x+1, :) = 0;
% f(end-x+1:end, :) = 0;
% new_ts = ifft(f);

% freqs = linspace(0, 0.5, length(ts));
% freqs(freqs<0.01) = 0;
% freqs(freqs>0.08) = 0;
% freqs = freqs + freqs(end:-1:1);
% f = fft(ts);
% f(freqs==0) = 0;
% new_ts = ifft(f);
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
