function ext_map = fun_parse_filenames(filenames)
ext_map = containers.Map;
for e = filenames'
    s = e{1};
    [p, n, ext] = fileparts(s);
    ext_map(ext) = 1;
end
end

