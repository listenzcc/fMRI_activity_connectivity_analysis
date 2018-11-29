function fun_preprocess_1(pathname, hObject)
[fname_map, pre_map, ext_map, path_map] = fun_parse_files_in_path(pathname);
for j = 1 : 4
    if isKey(path_map, sprintf('_____preprocessed_%d', j))
        return
    end
end
rawstr = get(hObject, 'String');
set(hObject, 'String', '(1/4)数据读取中...')
pause(1)

outdir = fullfile(pathname, '_____preprocessed_');
[a, b, c] = mkdir(outdir);

load('b_DICOM_import.mat', 'matlabbatch')
matlabbatch{1}.spm.util.import.dicom.outdir = {outdir};

IMAfiles = dir(fullfile(pathname, '*.IMA'));
len = length(IMAfiles);
data = cell(len, 1);
for j = 1 : len
    data{j} = fullfile(pathname, IMAfiles(j).name);
end
matlabbatch{1}.spm.util.import.dicom.data = data;

spm_jobman('initcfg')
spm_jobman('run', matlabbatch)

movefile(...
    fullfile(pathname, '_____preprocessed_'),...
    fullfile(pathname, '_____preprocessed_1'));

set(hObject, 'String', rawstr)

end
