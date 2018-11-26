close all
clear
clc

%% Template 3D image
TPM_vol = spm_vol(fullfile('.', 'sources', 'TPM.nii'));
TPM_vol = TPM_vol(1);

T1_vol = spm_vol(fullfile('.', 'sources', 'canonical', 'avg152T1.nii'));

T2_vol = spm_vol(fullfile('.', 'sources', 'canonical', 'avg152T2.nii'));

TMP_3Dimg = spm_read_vols(T2_vol);
TMP_mat = T2_vol.mat;

%% functional 4D image
dir_name = fullfile('.', 'sources', 'target_dir');
target_dir = fullfile(dir_name, 'swf*.nii');
files = dir(target_dir);
num = length(files);
fnames = cell(num, 1);
for j = 1 : num
    fnames{j} = fullfile(dir_name, files(j).name);
end
vols = spm_vol(fnames);

fun_4Dimg = zeros([num, vols{1}.dim]);
fun_mat = vols{1}.mat;
wb = waitbar(0);
for j = 1 : num
    v = vols{j};
    [filepath, name, ext] = fileparts(v.fname);
    waitbar(j/num, wb, [name, ext])
    img_dim = v.dim;
    fun_4Dimg(j, :, :, :) = spm_read_vols(v);
end
close(wb)

%% overlap 3D image
over_mat = fun_mat;
over_3Dimg = squeeze(mean(fun_4Dimg, 1));

%% plot 2x2 grid
mm = [-20, -23, -13];
p_TMP = floor(mm2position(mm, TMP_mat));
p_over = floor(mm2position(mm, over_mat));
TMP_3Dimg = mark(TMP_3Dimg, p_TMP);
over_3Dimg = mark(over_3Dimg, p_over);
mm = [20, 23, 13];
p_TMP = floor(mm2position(mm, TMP_mat));
p_over = floor(mm2position(mm, over_mat));
TMP_3Dimg = mark(TMP_3Dimg, p_TMP);
over_3Dimg = mark(over_3Dimg, p_over);

load(fullfile('.', 'sources', 'cm.mat'))
image_plot(fun_4Dimg, fun_mat, mm, TMP_3Dimg, TMP_mat, cm, over_3Dimg, over_mat)

function a = mark(a, b)
for j = -2 : 2
    for k = -2 : 2
        for m = -2 : 2
            a(b(1)+j, b(2)+k, b(3)+m) = 0;
        end
    end
end
end
