function [fig, axe1, axe2, axe3, axe4] = draw_2x2frame(range_3D, resolution_3D, mm_ruler, img_TMP, mat_TMP, cm)

fig = figure;
axe1 = subplot(2, 2, 1);
axe2 = subplot(2, 2, 2);
axe3 = subplot(2, 2, 3);
axe4 = subplot(2, 2, 4);

p_ruler = floor(mm2position(mm_ruler, mat_TMP));

x = 1;
y = 3;
[grid_x, grid_y] = meshgrid(range_3D(x, 1): resolution_3D(x): range_3D(x, 2),...
    range_3D(y, 1): resolution_3D(y): range_3D(y, 2));
img_slice = grid_x;
for x = 1 : size(grid_x, 1)
    for y = 1 : size(grid_y, 2)
        mm = [grid_x(x, y), mm_ruler(2), grid_y(x, y)];
        p = floor(mm2position(mm, mat_TMP));
        img_slice(x, y) = img_TMP(p(1), p(2), p(3));
    end
end
set(fig, 'CurrentAxes', axe1)
imshow(uint8(img_slice*128), 'Colormap', cm)
p1 = p_ruler(1);
p2 = p_ruler(3);
line([p1, p1], get(gca, 'ylim'), 'color', 'blue');
line(get(gca, 'xlim'), [p2, p2], 'color', 'blue');
set(gca, 'YDir', 'normal')

x = 2;
y = 3;
[grid_x, grid_y] = meshgrid(range_3D(x, 1): resolution_3D(x): range_3D(x, 2),...
    range_3D(y, 1): resolution_3D(y): range_3D(y, 2));
img_slice = grid_x;
for x = 1 : size(grid_x, 1)
    for y = 1 : size(grid_y, 2)
        mm = [mm_ruler(1), grid_x(x, y), grid_y(x, y)];
        p = floor(mm2position(mm, mat_TMP));
        img_slice(x, y) = img_TMP(p(1), p(2), p(3));
    end
end
set(fig, 'CurrentAxes', axe2)
imshow(uint8(img_slice*128), 'Colormap', cm)
p1 = p_ruler(2);
p2 = p_ruler(3);
line([p1, p1], get(gca, 'ylim'), 'color', 'blue');
line(get(gca, 'xlim'), [p2, p2], 'color', 'blue');
set(gca, 'YDir', 'normal')

x = 1;
y = 2;
[grid_x, grid_y] = meshgrid(range_3D(x, 1): resolution_3D(x): range_3D(x, 2),...
    range_3D(y, 1): resolution_3D(y): range_3D(y, 2));
img_slice = grid_x;
for x = 1 : size(grid_x, 1)
    for y = 1 : size(grid_y, 2)
        mm = [grid_x(x, y), grid_y(x, y), mm_ruler(3)];
        p = floor(mm2position(mm, mat_TMP));
        img_slice(x, y) = img_TMP(p(1), p(2), p(3));
    end
end
set(fig, 'CurrentAxes', axe3)
imshow(uint8(img_slice*128), 'Colormap', cm)
p1 = p_ruler(1);
p2 = p_ruler(2);
line([p1, p1], get(gca, 'ylim'), 'color', 'blue');
line(get(gca, 'xlim'), [p2, p2], 'color', 'blue');
set(gca, 'YDir', 'normal')

end

