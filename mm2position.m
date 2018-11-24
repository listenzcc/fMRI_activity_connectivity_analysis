function position = mm2position(mm, mat)
if isrow(mm)
    mm = mm';
end

r = mat(1:3, 1:3);
b = mat(1:3, 4);

position = r \ (mm - b);
end

