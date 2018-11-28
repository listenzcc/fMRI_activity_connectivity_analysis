function str_fnames = select_dir_filename(dirname, pre, ext)

fnames = dir(dirname);

str_fnames = '';
for f = fnames'
    if f.isdir
        continue
    end
    fname = f.name;
    isp = 0;
    ise = 0;
    if strfind(fname, pre) == 1
        isp = 1;
    end
    if strfind(fname(end:-1:1), ext(end:-1:1)) == 1
        ise = 1;
    end
    if strcmp(pre, '--')
        isp = 1;
    end
    if strcmp(ext, '--')
        ise = 1;
    end
    if (isp+ise) == 2
        str_fnames = sprintf('%s\n%s', str_fnames, f.name);
    end
end
str_fnames = str_fnames(2:end);

end

