function fun_preprocess_1(new_pathname, raw_pathname, DICOMfiles, hObject)
[fname_map, pre_map, ext_map, path_map] = fun_parse_files_in_path(new_pathname);
for j = 1 : 4
    if isKey(path_map, sprintf('_____preprocessed_%d', j))
        return
    end
end

outdir = fullfile(new_pathname, '_____preprocessed_');
[a, b, c] = mkdir(outdir);

load(fullfile('resources', 'b_DICOM_import.mat'), 'matlabbatch')
matlabbatch{1}.spm.util.import.dicom.outdir = {outdir};

len = length(DICOMfiles);
data = cell(len, 1);
for j = 1 : len
    data{j} = fullfile(raw_pathname, DICOMfiles{j});
end
matlabbatch{1}.spm.util.import.dicom.data = data;

spm_jobman('initcfg')
spm_jobman('run', matlabbatch)

fun_filenames =...
    fun_all_files_in_path(fullfile(new_pathname, '_____preprocessed_'));
save(fullfile(new_pathname, '_____preprocessed_', 'fun_filenames.mat'),...
    'fun_filenames')

movefile(...
    fullfile(new_pathname, '_____preprocessed_'),...
    fullfile(new_pathname, '_____preprocessed_1'));

end
