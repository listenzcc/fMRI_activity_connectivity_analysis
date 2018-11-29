function fun_preprocess_3(pathname, hObject)
[fname_map, pre_map, ext_map, path_map] = fun_parse_files_in_path(pathname);
for j = 3 : 4
    if isKey(path_map, sprintf('_____preprocessed_%d', j))
        return
    end
end

rawstr = get(hObject, 'String');
set(hObject, 'String', '(3/4)功能结构配准中...')
pause(1)

workpath = fullfile(pathname, '_____preprocessed_2');
load('b_normalise.mat', 'matlabbatch')

matlabbatch{1}.spm.spatial.normalise.estwrite.eoptions.tpm = {'b_TPM.nii'};

meanfile = dir(fullfile(workpath, 'meanf*.nii'));
vol = [fullfile(workpath, meanfile.name), ',1'];
matlabbatch{1}.spm.spatial.normalise.estwrite.subj.vol = {vol};

funcfiles = dir(fullfile(workpath, 'f*.nii'));
len = length(funcfiles);
resample = cell(len, 1);
for j = 1 : len
    resample{j} = [fullfile(workpath, funcfiles(j).name), ',1'];
end
matlabbatch{1}.spm.spatial.normalise.estwrite.subj.resample = resample;

spm_jobman('initcfg')
spm_jobman('run', matlabbatch)

movefile(...
    fullfile(pathname, '_____preprocessed_2'),...
    fullfile(pathname, '_____preprocessed_3'));

set(hObject, 'String', rawstr)

end
