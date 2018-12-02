function fnames = fun_all_files_in_path(pathname)

d = dir(pathname);
fnames = {};
for j = 1 : length(d)
    if d(j).isdir
        continue
    end
    fnames{length(fnames)+1, 1} = d(j).name;
end

end

