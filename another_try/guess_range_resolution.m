function [range_3D, resolution_3D] = guess_range_resolution(sz, mat)
resolution_3D = diag(mat(1:3, 1:3));
range_3D = nan(3, 2);
range_3D(:, 1) = position2mm([1 1 1], mat);
range_3D(:, 2) = position2mm(sz, mat);
end

