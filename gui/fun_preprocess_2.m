function fun_preprocess_2(pathname, hObject)
[fname_map, pre_map, ext_map, path_map] = fun_parse_files_in_path(pathname);
for j = 2 : 4
    if isKey(path_map, sprintf('_____preprocessed_%d', j))
        return
    end
end

rawstr = get(hObject, 'String');
set(hObject, 'String', '(2/4)功能像对齐中...')
pause(1)

workpath = fullfile(pathname, '_____preprocessed_1');
load('b_realign.mat', 'matlabbatch')

funcfiles = dir(fullfile(workpath, 'f*.nii'));
len = length(funcfiles);
data = {cell(len, 1)};
for j = 1 : len
    data{1}{j} = [fullfile(workpath, funcfiles(j).name), ',1'];
end
matlabbatch{1}.spm.spatial.realign.estwrite.data = data;

spm_jobman('initcfg')
spm_jobman('run', matlabbatch)

movefile(...
    fullfile(pathname, '_____preprocessed_1'),...
    fullfile(pathname, '_____preprocessed_2'));

set(hObject, 'String', rawstr)

end
