function [numbered_str_fnames, len] = number_filenames(str_fnames, v)
if nargin < 2
    v = 1;
end

numbered_str_fnames = '';
if isempty(str_fnames)
    return
end
cs = compose(str_fnames);
cell_fnames = strsplit(cs{1});

len = length(cell_fnames);
% listing 5 files at least
m = floor((1-v)*(len-5));
m = max(m, 1);

for j = m : len
    numbered_str_fnames = sprintf('%s\n%4d: %s', numbered_str_fnames, j, cell_fnames{j});
end
numbered_str_fnames = numbered_str_fnames(2:end);
end

