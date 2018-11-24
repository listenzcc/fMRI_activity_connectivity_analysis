close all
clear
clc

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

% for a = 1 : v_sample.dim(1)
%     for b = 1 : v_sample.dim(2)
%         for c = 1 : v_sample.dim(3)
%             img_4D(:, a, b, c) = spm_detrend(squeeze(img_4D(:, a, b, c)), 1);
%         end
%     end
% end

scale = @(x) ((x - min(x(:)))/(max(x(:)) - min(x(:))));

img_4D = scale(img_4D);

mm = [0, 0, 0];
mm = [10, 13, 3];

image_plot(img_4D, v_sample.mat, mm)
