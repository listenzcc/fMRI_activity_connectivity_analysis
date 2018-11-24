function image_plot(img_4D, mat, mm)

img_mean = squeeze(mean(img_4D, 1));
img2show = img_mean;

position = mm2position(mm, mat);
p = floor(position);

img2show(p(1), p(2), p(3)) = 0;

fig = figure;
axe1 = subplot(2, 2, 1);
axe2 = subplot(2, 2, 2);
axe3 = subplot(2, 2, 3);
axe4 = subplot(2, 2, 4);

fill_fig(img2show, p, mm, img_4D, fig, axe1, axe2, axe3, axe4)

set(fig, 'WindowButtonMotionFcn', @ButttonDownFcn)
end

function ButttonDownFcn(src, event)
pt = get(gca, 'CurrentPoint');
gca
x = pt(1, 1);
y = pt(1, 2);
fprintf('x=%f, y=%f\n', x, y);
end

function fill_fig(img2show, p, mm, img_4D, fig, axe1, axe2, axe3, axe4)

sz = size(img2show);

% 冠状位
set(fig, 'CurrentAxes', axe1)
img_ = squeeze(img2show(:, p(2), :));
img_slice = img_(:, end:-1:1)';
imagesc(img_slice)
title(sprintf('冠状位, %d mm', mm(2)))

set(gca, 'xlim', [1, sz(1)]);
set(gca, 'ylim', [1, sz(3)]);
x = p(1);
y = sz(3) - p(3) + 1;
hold on
line([1, sz(1)], [y, y], 'color', 'blue')
line([x, x], [1, sz(3)], 'color', 'blue')
hold off

% 矢状位
set(fig, 'CurrentAxes', axe2)
img_ = squeeze(img2show(p(1), :, :));
img_slice = img_(:, end:-1:1)';
imagesc(img_slice)
title(sprintf('矢状位 %d mm', mm(1)))

set(gca, 'xlim', [1, sz(2)]);
set(gca, 'ylim', [1, sz(3)]);
x = p(2);
y = sz(3) - p(3) + 1;
hold on
line([1, sz(2)], [y, y], 'color', 'blue')
line([x, x], [1, sz(3)], 'color', 'blue')
hold off

% 横断位
set(fig, 'CurrentAxes', axe3)
img_ = squeeze(img2show(:, :, p(3)));
img_slice = img_(:, end:-1:1)';
imagesc(img_slice)
title(sprintf('横断位, %d mm', mm(3)))

set(gca, 'xlim', [1, sz(1)]);
set(gca, 'ylim', [1, sz(2)]);
x = p(1);
y = sz(2) - p(2) + 1;
hold on
line([0, sz(1)], [y, y], 'color', 'blue')
line([x, x], [0, sz(2)], 'color', 'blue')
hold off

% 时间序列
set(fig, 'CurrentAxes', axe4)
plot(squeeze(img_4D(:, p(1), p(2), p(3))))

colormap('gray')
end

