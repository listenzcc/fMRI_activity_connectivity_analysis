close all
clear
clc

TPM_vol = spm_vol(fullfile('.', 'sources', 'TPM.nii'));
TPM_vol = TPM_vol(1);
TPM_3Dimg = spm_read_vols(TPM_vol);
TPM_mat = TPM_vol.mat;

dir_name = fullfile('.', 'sources', 'target_dir')

target_dir = fullfile(dir_name, 'swf*.nii')

files = dir(target_dir);

num = length(files);
fnames = cell(num, 1);
for j = 1 : num
    fnames{j} = fullfile(dir_name, files(j).name);
end

vols = spm_vol(fnames);
v_sample = vols{1};

img_4D = zeros([num, v_sample.dim]);
fig = waitbar(0);
for j = 1 : num
    waitbar(j/num)
    v = vols{j};
    img_dim = v.dim;
    img_4D(j, :, :, :) = spm_read_vols(v);
end
close(fig)

scale = @(x) ((x - min(x(:)))/(max(x(:)) - min(x(:))));

img_4D = scale(img_4D);

mm = [0, 0, 0];
mm = [10, 13, 3];

image_plot(img_4D, v_sample.mat, mm, TPM_3Dimg, TPM_mat)