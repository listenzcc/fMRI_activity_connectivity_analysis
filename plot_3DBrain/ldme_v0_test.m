close all
clear
clc

fpath = fullfile('SurfTemplate', 'BrainMesh_Ch2.nv');
fpath = fullfile('SurfTemplate', 'BrainMesh_ICBM152_smoothed.nv');


fid=fopen(fpath);
data = textscan(fid,'%f','CommentStyle','#');

vertex_number = data{1}(1);
coord = reshape(data{1}(2:1+3*vertex_number), [3, vertex_number]);
ntri = data{1}(3*vertex_number+2);
tri = reshape(data{1}(3*vertex_number+3:end), [3, ntri])';
fclose(fid);

surf = struct;
surf.vertex_number = vertex_number;
surf.coord = coord;
surf.tri = tri;
surf.ntri = ntri;
surf

mm_amy = [-18, 2, -16]';
mm_tms = [51, 14, 50]';
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
axe = axes;
set(gca, 'Position', [0, 0, 1, 1])

volume = trisurf(surf.tri,...
    surf.coord(1, :), surf.coord(2, :), surf.coord(3, :),...
    'EdgeColor', 'none');

% hold on
% 
% [a, b] = sort(dist_amy);
% nearest_idx = b(1:roisz);
% roi_amy = trisurf(surf.tri(nearest_idx, :),...
%     surf.coord(1, :), surf.coord(2, :), surf.coord(3, :),...
%     'EdgeColor', 'none');
% 
% [a, b] = sort(dist_tms);
% nearest_idx = b(1:roisz);
% roi_tms = trisurf(surf.tri(nearest_idx, :),...
%     surf.coord(1, :), surf.coord(2, :), surf.coord(3, :),...
%     'EdgeColor', 'none');
% 
% hold off

shading('interp')
lighting('phong')
camlight('right')
material('dull')
daspect([1, 1, 1])
% axis off;

set(volume, 'FaceColor', 0.95+zeros(1, 3));
set(volume, 'FaceAlpha', 0.8);

% set(roi_amy, 'FaceColor', 'blue');
% set(roi_amy, 'FaceAlpha', 1);
% 
% set(roi_tms, 'FaceColor', 'red');
% set(roi_tms, 'FaceAlpha', 1);

axis tight;
axis vis3d off;

set(gca, 'View', [0, 90])

set(gcf, 'WindowButtonMotionFcn', @ButttonMotionFcn)
set(gcf, 'WindowButtonDownFcn', @ButttonDownFcn)
% rot = [0.3, 0.2];
% while true
%     [az, el] = view;
%     az = az + rot(1);
%     az = mod(az, 360);
%     el = el + rot(2);
%     if el > 90 || el < -90
%         rot(2) = - rot(2);
%     end
%     set(gca, 'View', [az, el])
%     drawnow
% end

function ButttonMotionFcn(src, event)
cp = get_cp(gcf);
% disp(cp)
az = mod(720*cp(1), 360);
el = 180*(cp(2)-0.5);
% disp([az, el])
set(gca, 'View', [az, el])
end

function ButttonDownFcn(src, event)
azel = get(gca, 'View');
c = get(gca, 'Children');
delete(findobj(c, 'Type', 'light'))
if azel(1)>90 && azel(1) <270
    azel(1) = azel(1) + 180;
end
camlight(azel(1), azel(2));
% c = get(gca, 'Children');
% set(findobj(c, 'Type', 'light'), 'Color', rand(1, 3))
end

function cp = get_cp(fig)
unit_axe = get(fig, 'Units');
set(fig, 'Units', 'normalized')
cp = get(fig, 'CurrentPoint');
set(fig, 'Units', unit_axe)
end
