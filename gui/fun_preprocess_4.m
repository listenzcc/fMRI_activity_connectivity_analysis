function fun_preprocess_4(pathname, hObject)
[fname_map, pre_map, ext_map, path_map] = fun_parse_files_in_path(pathname);
for j = 4
    if isKey(path_map, sprintf('_____preprocessed_%d', j))
        return
    end
end

rawstr = get(hObject, 'String');
set(hObject, 'String', '(4/4)功能像平滑中...')
pause(1)

workpath = fullfile(pathname, '_____preprocessed_3');
load('b_smooth.mat', 'matlabbatch')

wfuncfiles = dir(fullfile(workpath, 'wf*.nii'));
len = length(wfuncfiles);
data = cell(len, 1);
for j = 1 : len
    data{j} = [fullfile(workpath, wfuncfiles(j).name), ',1'];
end
matlabbatch{1}.spm.spatial.smooth.data = data;

spm_jobman('initcfg')
spm_jobman('run', matlabbatch)

movefile(...
    fullfile(pathname, '_____preprocessed_3'),...
    fullfile(pathname, '_____preprocessed_4'));

set(hObject, 'String', rawstr)

end
