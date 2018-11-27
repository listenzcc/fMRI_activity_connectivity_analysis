function [str_fnames, str_pres, str_exts] = parse_dir_filename(dirname)
fnames = dir(dirname);
str_fnames = '';
exts = containers.Map;
pres = containers.Map;
for f = fnames'
    if f.isdir
        continue
    end
    str_fnames = sprintf('%s\n%s', str_fnames, f.name);
    [filepath, name, ext] = fileparts(f.name);
    if length(name) < 4
        pre = name;
    else
        pre = name(1:4);
    end
    pres(pre) = 1;
    exts(ext) = 1;
end

keys_pres = keys(pres);
str_pres = '--';
for j = 1 : length(keys_pres)
    str_pres = sprintf('%s\n%s', str_pres, keys_pres{j});
end

keys_exts = keys(exts);
str_exts = '--';
for j = 1 : length(keys_exts)
    str_exts = sprintf('%s\n%s', str_exts, keys_exts{j});
end

end

