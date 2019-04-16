function fun_draw_TMP(mm, img_TMP, mat_TMP, img_4D, mat_4D,...
    fig, axe1, axe2, axe3, axe4, cm, cond)

% initial 2x2 split plots, using TMP and 4D img
p_TMP = floor(fun_mm2position(mm, mat_TMP));
p_4D = floor(fun_mm2position(mm, mat_4D));

% sz = size(img_TMP);
% ms = max(size(img_TMP));
% img_TMP_e = zeros(ms, ms, ms) + img_TMP(1, 1, 1);
% img_TMP_e(1:sz(1), 1:sz(2), 1:sz(3)) = img_TMP;
% img_TMP = img_TMP_e;

% 冠状位
ud = struct;
set(fig, 'CurrentAxes', axe1)
img_ = squeeze(img_TMP(:, p_TMP(2), :));
img_ = img_(end:-1:1, :);
img_slice = img_';
ud.TMP = imshow(uint8(img_slice*128), 'Colormap', cm);
set(gca, 'YDir', 'normal')
title(sprintf('冠状位, %0.1f mm', mm(2)))
p1 = size(img_, 1) - p_TMP(1) +1;
p2 = p_TMP(3);
hold on
ruler.ruler_x = line([p1, p1], get(gca, 'ylim'), 'color', 'red');
ruler.ruler_y = line(get(gca, 'xlim'), [p2, p2], 'color', 'red');
line([p1, p1], get(gca, 'ylim'), 'color', 'blue');
line(get(gca, 'xlim'), [p2, p2], 'color', 'blue');
hold off
ud.ruler = ruler;
set(gca, 'UserData', ud)

% 矢状位
ud = struct;
set(fig, 'CurrentAxes', axe2)
img_ = squeeze(img_TMP(p_TMP(1), :, :));
img_slice = img_';
ud.TMP = imshow(uint8(img_slice*128), 'Colormap', cm);
set(gca, 'YDir', 'normal')
title(sprintf('矢状位 %0.1f mm', mm(1)))
p1 = p_TMP(2);
p2 = p_TMP(3);
hold on
ruler.ruler_x = line([p1, p1], get(gca, 'ylim'), 'color', 'red');
ruler.ruler_y = line(get(gca, 'xlim'), [p2, p2], 'color', 'red');
line([p1, p1], get(gca, 'ylim'), 'color', 'blue');
line(get(gca, 'xlim'), [p2, p2], 'color', 'blue');
hold off
ud.ruler = ruler;
set(gca, 'UserData', ud)

% 横断位
ud = struct;
set(fig, 'CurrentAxes', axe3)
img_ = squeeze(img_TMP(:, :, p_TMP(3)));
img_ = img_(end:-1:1, :);
img_slice = img_';
ud.TMP = imshow(uint8(img_slice*128), 'Colormap', cm);
set(gca, 'YDir', 'normal')
title(sprintf('横断位, %0.1f mm', mm(3)))
p1 = size(img_, 1) - p_TMP(1) +1;
p2 = p_TMP(2);
hold on
ruler.ruler_x = line([p1, p1], get(gca, 'ylim'), 'color', 'red');
ruler.ruler_y = line(get(gca, 'xlim'), [p2, p2], 'color', 'red');
line([p1, p1], get(gca, 'ylim'), 'color', 'blue');
line(get(gca, 'xlim'), [p2, p2], 'color', 'blue');
hold off
ud.ruler = ruler;
set(gca, 'UserData', ud)

% 时间序列
ud = struct;
if isempty(axe4)
    return
end
set(fig, 'CurrentAxes', axe4)

plot(squeeze(img_4D(p_4D(1), p_4D(2), p_4D(3), :)), 'color', 'white')
hold on
ts = squeeze(img_4D(p_4D(1), p_4D(2), p_4D(3), :));
curve_new = plot(ts, 'color', 'red');
plot(ts, 'color', 'blue');
hold off
set(get(axe4, 'Title'), 'String',...
        sprintf('%0.0f, %0.0f, %0.0f', mm(1), mm(2), mm(3)))
ud.curve_new = curve_new;
ud.ts = ts;

yl = get(axe4, 'YLim');
TR = cond.TR;
n = length(cond.onset);
rect = nan(1, n);
for j = 1 : n
    rect(j) = rectangle('Position',...
        [cond.onset(j)/TR, yl(1), cond.duration(j)/TR, yl(2)-yl(1)],...
        'facecolor', 0.5+zeros(1, 4), 'edgecolor', 0.5+zeros(1, 4));
end

set(gca, 'XLim', [1, length(ts)])
set(gca, 'Box', 'Off')
set(gca, 'XTick', [])
set(gca, 'YTick', [])

ud.rect = rect;

set(gca, 'UserData', ud)
end
