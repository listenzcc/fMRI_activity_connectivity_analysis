function fun_plot_3D_surface(fname, mm)
fid=fopen(fname);
data = textscan(fid,'%f','CommentStyle','#');
fclose(fid);

vertex_number = data{1}(1);
coord = reshape(data{1}(2:1+3*vertex_number), [3, vertex_number]);
ntri = data{1}(3*vertex_number+2);
tri = reshape(data{1}(3*vertex_number+3:end), [3, ntri])';

surf = struct;
surf.vertex_number = vertex_number;
surf.coord = coord;
surf.tri = tri;
surf.ntri = ntri;

mm_amy = mm.max_amy_mm;
mm_tms = mm.max_c_mm;
roisz = 100;

dist_amy = nan(1, surf.ntri);
dist_tms = nan(1, surf.ntri);
for j = 1 : surf.ntri
    tri = surf.tri(j, :);
    for k = 1 : 3
        coord = surf.coord(:, tri(1));
        d = norm(mm_amy-coord);
        dist_amy(j) = min(d, dist_amy(j));
        d = norm(mm_tms-coord);
        dist_tms(j) = min(d, dist_tms(j));
    end
end

figure,
set(gca, 'Position', [0, 0, 1, 1])
daspect([1, 1, 1])

volume = trisurf(surf.tri,...
    surf.coord(1, :), surf.coord(2, :), surf.coord(3, :),...
    'EdgeColor', 'none');

hold on

[a, b] = sort(dist_amy);
nearest_idx = b(1:roisz);
roi_amy = trisurf(surf.tri(nearest_idx, :),...
    surf.coord(1, :), surf.coord(2, :), surf.coord(3, :),...
    'EdgeColor', 'none');

[a, b] = sort(dist_tms);
nearest_idx = b(1:roisz);
roi_tms = trisurf(surf.tri(nearest_idx, :),...
    surf.coord(1, :), surf.coord(2, :), surf.coord(3, :),...
    'EdgeColor', 'none');

hold off

shading('interp')
lighting('phong')
camlight('right')
material('dull')

axis off;

set(volume, 'FaceColor', 0.95+zeros(1, 3));
set(volume, 'FaceAlpha', 0.3);

set(roi_amy, 'FaceColor', 'blue');
set(roi_amy, 'FaceAlpha', 1);

set(roi_tms, 'FaceColor', 'red');
set(roi_tms, 'FaceAlpha', 1);

axis tight;
axis vis3d off;

set(gca, 'View', [0, 90])

set(gcf, 'WindowButtonMotionFcn', @ButttonMotionFcn)

text(mm.max_amy_mm(1), mm.max_amy_mm(2), mm.max_amy_mm(3), 'EffectSpot')
text(mm.max_c_mm(1), mm.max_c_mm(2), mm.max_c_mm(3), 'TargetSpot')

set(gcf, 'NumberTitle', 'off', 'Name', '3DÆ¤²ãÄ£ÐÍ')

end

function ButttonMotionFcn(src, event)
cp = get_cp(gcf);
az = mod(720*cp(1), 360);
el = 180*(cp(2)-0.5);
set(gca, 'View', [az, el])
end

function cp = get_cp(fig)
unit_axe = get(fig, 'Units');
set(fig, 'Units', 'normalized')
cp = get(fig, 'CurrentPoint');
set(fig, 'Units', unit_axe)
end


