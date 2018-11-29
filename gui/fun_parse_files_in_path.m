function [fname_map, pre_map, ext_map] = fun_parse_files_in_path(pathname)
fname_map = containers.Map;
pre_map = containers.Map;
pre_map('*') = 1;
ext_map = containers.Map;
ext_map('.*') = 1;
for f = dir(pathname)'
    if f.isdir
        continue
    end
    fname_map(f.name) = 1;
    [p, name, ext] = fileparts(f.name);
    if length(name) < 4
        pre = name;
    else
        pre = name(1:4);
    end
    pre_map(pre) = 1;
    ext_map(ext) = 1;
end
end