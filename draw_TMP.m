function draw_TMP(mm, img_TMP, mat_TMP, img_4D, mat_4D,...
    fig, axe1, axe2, axe3, axe4, cm)

% initial 2x2 split plots, using TMP and 4D img
p_TMP = floor(mm2position(mm, mat_TMP));
sz = size(img_TMP);
p_4D = floor(mm2position(mm, mat_4D));

% ��״λ
ud = struct;
set(fig, 'CurrentAxes', axe1)
img_ = squeeze(img_TMP(:, p_TMP(2), :));
img_slice = img_';
ud.TMP = imshow(uint8(img_slice*128), 'Colormap', cm);
set(gca, 'YDir', 'normal')
title(sprintf('��״λ, %0.1f mm', mm(2)))
p1 = p_TMP(1);
p2 = p_TMP(3);
hold on
ruler.ruler_x = line([p1, p1], get(gca, 'ylim'), 'color', 'red');
ruler.ruler_y = line(get(gca, 'xlim'), [p2, p2], 'color', 'red');
line([p1, p1], get(gca, 'ylim'), 'color', 'blue');
line(get(gca, 'xlim'), [p2, p2], 'color', 'blue');
hold off
ud.ruler = ruler;
set(gca, 'UserData', ud)

% ʸ״λ
ud = struct;
set(fig, 'CurrentAxes', axe2)
img_ = squeeze(img_TMP(p_TMP(1), :, :));
img_slice = img_';
ud.TMP = imshow(uint8(img_slice*128), 'Colormap', cm);
set(gca, 'YDir', 'normal')
title(sprintf('ʸ״λ %0.1f mm', mm(1)))
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

% ���λ
ud = struct;
set(fig, 'CurrentAxes', axe3)
img_ = squeeze(img_TMP(:, :, p_TMP(3)));
img_slice = img_';
ud.TMP = imshow(uint8(img_slice*128), 'Colormap', cm);
set(gca, 'YDir', 'normal')
title(sprintf('���λ, %0.1f mm', mm(3)))
p1 = p_TMP(1);
p2 = p_TMP(2);
hold on
ruler.ruler_x = line([p1, p1], get(gca, 'ylim'), 'color', 'red');
ruler.ruler_y = line(get(gca, 'xlim'), [p2, p2], 'color', 'red');
line([p1, p1], get(gca, 'ylim'), 'color', 'blue');
line(get(gca, 'xlim'), [p2, p2], 'color', 'blue');
hold off
ud.ruler = ruler;
set(gca, 'UserData', ud)

% ʱ������
ud = struct;
set(fig, 'CurrentAxes', axe4)
plot(squeeze(img_4D(:, p_4D(1), p_4D(2), p_4D(3))), 'color', 'white')
hold on
ts = squeeze(img_4D(:, p_4D(1), p_4D(2), p_4D(3)));
curve_new = plot(ts, 'color', 'red');
plot(ts, 'color', 'blue');
hold off
set(get(axe4, 'Title'), 'String',...
        sprintf('%0.0f, %0.0f, %0.0f', mm(2), mm(1), mm(3)))
ud.curve_new = curve_new;
ud.ts = ts;
set(gca, 'UserData', ud)
end
