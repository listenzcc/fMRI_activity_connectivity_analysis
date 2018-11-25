function image_plot(img_4D, mat_4D, mm, img_TMP, mat_TMP)

position = mm2position(mm, mat_TMP);
p = floor(position);
img_TMP(p(1), p(2), p(3)) = 0;

fig = figure;
axe1 = subplot(2, 2, 1);
axe2 = subplot(2, 2, 2);
axe3 = subplot(2, 2, 3);
axe4 = subplot(2, 2, 4);

fill_fig(mm, img_TMP, mat_TMP, img_4D, mat_4D,...
    fig, axe1, axe2, axe3, axe4)

set(fig, 'WindowButtonMotionFcn', @ButttonMotionFcn)
set(fig, 'WindowButtonUpFcn', @ButttonUpFcn)
user_data.axe1 = axe1;
user_data.axe2 = axe2;
user_data.axe3 = axe3;
user_data.axe4 = axe4;
user_data.mm = mm;
user_data.img_4D = img_4D;
user_data.mat_4D = mat_4D;
user_data.img_TMP = img_TMP;
user_data.mat_TMP = mat_TMP;
user_data.sz = size(img_TMP);

set(fig, 'UserData', user_data)
end

%% handel Mouse Up
function ButttonUpFcn(src, event)
user_data = get(gcf, 'UserData');
axe1 = user_data.axe1;
axe2 = user_data.axe2;
axe3 = user_data.axe3;
axe4 = user_data.axe4;
set(get(axe4, 'Title'), 'String', '')

is_in_axe123 = 0;
[in, cpa] = cpf_in_axe(gcf, axe1);
if in
    % disp('axe1')
    mm = user_data.mm;
    mat = user_data.mat_TMP;
    sz = user_data.sz;
    position = mm2position(mm, mat);
    position(2) = cpa(1);
    position(3) = sz(3) - cpa(1, 2) + 1;
    newmm = position2mm(position, mat);
    is_in_axe123 = 1;
end

[in, cpa] = cpf_in_axe(gcf, axe2);
if in
    % disp('axe2')
    mm = user_data.mm;
    mat = user_data.mat_TMP;
    sz = user_data.sz;
    position = mm2position(mm, mat);
    position(1) = cpa(1);
    position(3) = sz(3) - cpa(1, 2) + 1;
    newmm = position2mm(position, mat);
    is_in_axe123 = 2;
end

[in, cpa] = cpf_in_axe(gcf, axe3);
if in
    % disp('axe3')
    mm = user_data.mm;
    mat = user_data.mat_TMP;
    sz = user_data.sz;
    position = mm2position(mm, mat);
    position(1) = cpa(1, 2);
    position(2) = cpa(1);
    newmm = position2mm(position, mat);
    is_in_axe123 = 3;
end

if is_in_axe123
    set(get(axe4, 'Title'), 'String',...
        sprintf('%0.0f, %0.0f, %0.0f', newmm(2), newmm(1), newmm(3)))
    mat_4D = user_data.mat_4D;
    p_4D = floor(mm2position(newmm, mat_4D));
    img_4D = user_data.img_4D;
    sz_4D = size(img_4D);
    if sum(p_4D<=0)
        disp('sorry, no data on this point.')
        return
    end
    if sum(p_4D>sz_4D(2:4)')
        disp('sorry, no data on this point.')
        return
    end
    img_TMP = user_data.img_TMP;
    mat_TMP = user_data.mat_TMP;
    fill_fig(newmm, img_TMP, mat_TMP, img_4D, mat_4D,...
        gcf, axe1, axe2, axe3, axe4)
end

end

%% handel Mouse Motion
function ButttonMotionFcn(src, event)
user_data = get(gcf, 'UserData');
axe1 = user_data.axe1;
axe2 = user_data.axe2;
axe3 = user_data.axe3;
axe4 = user_data.axe4;
set(get(axe4, 'Title'), 'String', '')

is_in_axe123 = 0;
[in, cpa] = cpf_in_axe(gcf, axe1);
if in
    % disp('axe1')
    mm = user_data.mm;
    mat = user_data.mat_TMP;
    sz = user_data.sz;
    position = mm2position(mm, mat);
    position(2) = cpa(1);
    position(3) = sz(3) - cpa(1, 2) + 1;
    newmm = position2mm(position, mat);
    is_in_axe123 = 1;
end

[in, cpa] = cpf_in_axe(gcf, axe2);
if in
    % disp('axe2')
    mm = user_data.mm;
    mat = user_data.mat_TMP;
    sz = user_data.sz;
    position = mm2position(mm, mat);
    position(1) = cpa(1);
    position(3) = sz(3) - cpa(1, 2) + 1;
    newmm = position2mm(position, mat);
    is_in_axe123 = 2;
end

[in, cpa] = cpf_in_axe(gcf, axe3);
if in
    % disp('axe3')
    mm = user_data.mm;
    mat = user_data.mat_TMP;
    sz = user_data.sz;
    position = mm2position(mm, mat);
    position(1) = cpa(1, 2);
    position(2) = cpa(1);
    newmm = position2mm(position, mat);
    is_in_axe123 = 3;
end

if is_in_axe123
    set(get(axe4, 'Title'), 'String',...
        sprintf('%0.0f, %0.0f, %0.0f', newmm(2), newmm(1), newmm(3)))
    mat_4D = user_data.mat_4D;
    p_4D = floor(mm2position(newmm, mat_4D));
    img_4D = user_data.img_4D;
    sz_4D = size(img_4D);
    if sum(p_4D<=0)
        return
    end
    if sum(p_4D>sz_4D(2:4)')
        return
    end
    
    curve_new = get(axe4, 'UserData');
    
    set(curve_new, 'YData',...
        squeeze(img_4D(:, p_4D(1), p_4D(2), p_4D(3))))
    
    p = floor(position);
    ruler = get(axe2, 'UserData');
    x = p(1);
    y = sz(3) - p(3) + 1;
    set(ruler.ruler_x, 'XData', [x, x])
    set(ruler.ruler_y, 'YData', [y, y])
    
    ruler = get(axe1, 'UserData');
    x = p(2);
    y = sz(3) - p(3) + 1;
    set(ruler.ruler_x, 'XData', [x, x])
    set(ruler.ruler_y, 'YData', [y, y])
    
    ruler = get(axe3, 'UserData');
    y = p(1);
    x = p(2);
    set(ruler.ruler_x, 'XData', [x, x])
    set(ruler.ruler_y, 'YData', [y, y])
end

end

%% initial 2x2 split plots
function fill_fig(mm, img_TMP, mat_TMP, img_4D, mat_4D,...
    fig, axe1, axe2, axe3, axe4)
p_TMP = floor(mm2position(mm, mat_TMP));
sz = size(img_TMP);
p_4D = floor(mm2position(mm, mat_4D));
% 冠状位
set(fig, 'CurrentAxes', axe2)
img_ = squeeze(img_TMP(:, p_TMP(2), :));
img_slice = img_(:, end:-1:1)';
imagesc(img_slice)
title(sprintf('冠状位, %0.1f mm', mm(2)))

set(gca, 'xlim', [1, sz(1)]);
set(gca, 'ylim', [1, sz(3)]);
x = p_TMP(1);
y = sz(3) - p_TMP(3) + 1;
hold on
ruler.ruler_y = line([1, sz(1)], [y, y], 'color', 'red');
ruler.ruler_x = line([x, x], [1, sz(3)], 'color', 'red');
line([1, sz(1)], [y, y], 'color', 'blue')
line([x, x], [1, sz(3)], 'color', 'blue')
hold off
set(gca, 'UserData', ruler)

% 矢状位
set(fig, 'CurrentAxes', axe1)
img_ = squeeze(img_TMP(p_TMP(1), :, :));
img_slice = img_(:, end:-1:1)';
imagesc(img_slice)
title(sprintf('矢状位 %0.1f mm', mm(1)))

set(gca, 'xlim', [1, sz(2)]);
set(gca, 'ylim', [1, sz(3)]);
x = p_TMP(2);
y = sz(3) - p_TMP(3) + 1;
hold on
ruler.ruler_y = line([1, sz(2)], [y, y], 'color', 'red');
ruler.ruler_x = line([x, x], [1, sz(3)], 'color', 'red');
line([1, sz(2)], [y, y], 'color', 'blue')
line([x, x], [1, sz(3)], 'color', 'blue')
hold off
set(gca, 'UserData', ruler)

% 横断位
set(fig, 'CurrentAxes', axe3)
img_ = squeeze(img_TMP(:, :, p_TMP(3)));
img_slice = img_; %(:, end:-1:1);
imagesc(img_slice)
title(sprintf('横断位, %0.1f mm', mm(3)))

set(gca, 'xlim', [1, sz(2)]);
set(gca, 'ylim', [1, sz(1)]);
y = p_TMP(1);
x = p_TMP(2);
hold on
ruler.ruler_y = line([0, sz(2)], [y, y], 'color', 'red');
ruler.ruler_x = line([x, x], [0, sz(1)], 'color', 'red');
line([0, sz(2)], [y, y], 'color', 'blue')
line([x, x], [0, sz(1)], 'color', 'blue')
hold off
set(gca, 'UserData', ruler)

% 时间序列
set(fig, 'CurrentAxes', axe4)
plot(squeeze(img_4D(:, p_4D(1), p_4D(2), p_4D(3))), 'color', 'blue')
hold on
curve_new = plot(squeeze(img_4D(:, p_4D(1), p_4D(2), p_4D(3))), 'color', 'red');
plot(squeeze(img_4D(:, p_4D(1), p_4D(2), p_4D(3))), 'color', 'blue')
hold off
set(get(axe4, 'Title'), 'String',...
        sprintf('%0.0f, %0.0f, %0.0f', mm(2), mm(1), mm(3)))
set(gca, 'UserData', curve_new)

colormap('gray')
end

%% tools, tell if current point in axe 1, 2 or 3
function [in, cpa] = cpf_in_axe(fig, axe)

unit_fig = get(fig, 'Units');
set(fig, 'Units', 'points')
cpf = get(fig, 'CurrentPoint');

unit_axe = get(axe, 'Units');
set(axe, 'Units', 'points')
cpa = get(axe, 'CurrentPoint');
cpa = cpa(1, 1:2);

in = a_in_b(cpf, axe.Position);

set(fig, 'Units', unit_fig)
set(axe, 'Units', unit_axe)

end

function in = a_in_b(p, position)
px_min = position(1);
px_max = position(1) + position(3);
py_min = position(2);
py_max = position(2) + position(4);
in = 0;
if p(1) >= px_min
    if p(1) <= px_max
        if p(2) >= py_min
            if p(2) <= py_max
                in = 1;
            end
        end
    end
end
end