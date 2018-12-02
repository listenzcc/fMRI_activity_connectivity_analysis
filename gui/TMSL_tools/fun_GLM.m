function fun_GLM(appPath, pathname, hObject)
[fname_map, pre_map, ext_map, path_map] = fun_parse_files_in_path(pathname);
if isKey(path_map, sprintf('_____GLM_1'))
    return
end

outdir_GLM = fullfile(pathname, '_____GLM_');
[a, b, c] = mkdir(outdir_GLM);

%% global, headmotion
for gg = [0, 1]
    for hh = [0, 1]
        outdir = fullfile(outdir_GLM, sprintf('g%dh%d', gg, hh));
        [a, b, c] = mkdir(outdir);
        
        load(fullfile(pathname, 'TR.mat'), 'TR')
        funpath = fullfile(pathname, '_____preprocessed_4');
        load(fullfile(funpath, 'fun_filenames.mat'), 'fun_filenames')
        d = dir(fullfile(funpath, 'rp_*.txt'));
        hmtxt = fullfile(funpath, d(1).name);
        load(fullfile(appPath, 'resources', 'b_GLM.mat'), 'matlabbatch')
        load(fullfile(appPath, 'resources', 'b_cond.mat'), 'cond')
        matlabbatch{1}.spm.stats.fmri_spec.dir = {outdir};
        if gg == 1
            matlabbatch{1}.spm.stats.fmri_spec.global = 'Scaling'; % global
        else
            matlabbatch{1}.spm.stats.fmri_spec.global = 'None'; % global
        end
        matlabbatch{1}.spm.stats.fmri_spec.timing.RT = TR; % TR
        if hh == 1
            matlabbatch{1}.spm.stats.fmri_spec.sess.multi_reg = {hmtxt}; % head motion txt
        else
            matlabbatch{1}.spm.stats.fmri_spec.sess.multi_reg = {''}; % head motion txt
        end
        matlabbatch{1}.spm.stats.fmri_spec.sess.hpf = 60;
        matlabbatch{1}.spm.stats.fmri_spec.sess.cond = cond;
        
        len = length(fun_filenames);
        scans = cell(len, 1);
        for j = 1 : len
            scans{j} = [fullfile(funpath, ['sw', fun_filenames{j}]), ',1'];
        end
        matlabbatch{1}.spm.stats.fmri_spec.sess.scans = scans;
        
        spm_jobman('initcfg')
        spm_jobman('run', matlabbatch)
    end
end

movefile(...
    fullfile(pathname, '_____GLM_'),...
    fullfile(pathname, '_____GLM_1'));

end

