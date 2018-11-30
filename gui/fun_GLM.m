function fun_GLM(pathname, hObject)
[fname_map, pre_map, ext_map, path_map] = fun_parse_files_in_path(pathname);
if isKey(path_map, sprintf('_____GLM_1'))
    return
end

rawstr = get(hObject, 'String');
set(hObject, 'String', '(5/5)º§ªÓ∑÷Œˆ÷–...')
pause(1)

outdir = fullfile(pathname, '_____GLM_');
[a, b, c] = mkdir(outdir);

funpath = fullfile(pathname, '_____preprocessed_4');
load(fullfile(funpath, 'fun_filenames.mat'), 'fun_filenames')
d = dir(fullfile(funpath, 'rp_*.txt'));
hmtxt = fullfile(funpath, d(1).name);
load(fullfile('resources', 'b_GLM.mat'), 'matlabbatch')
load(fullfile('resources', 'b_cond.mat'), 'cond')
matlabbatch{1}.spm.stats.fmri_spec.dir = {outdir};
matlabbatch{1}.spm.stats.fmri_spec.global = 'Scaling'; % global
matlabbatch{1}.spm.stats.fmri_spec.timing.RT = 2; % TR
matlabbatch{1}.spm.stats.fmri_spec.sess.multi_reg = {hmtxt}; % head motion txt
matlabbatch{1}.spm.stats.fmri_spec.sess.cond = cond;

len = length(fun_filenames);
scans = cell(len, 1);
for j = 1 : len
    scans{j} = [fullfile(funpath, ['sw', fun_filenames{j}]), ',1'];
end
matlabbatch{1}.spm.stats.fmri_spec.sess.scans = scans;

spm_jobman('initcfg')
spm_jobman('run', matlabbatch)

movefile(...
    fullfile(pathname, '_____GLM_'),...
    fullfile(pathname, '_____GLM_1'));

set(hObject, 'String', rawstr)
end

