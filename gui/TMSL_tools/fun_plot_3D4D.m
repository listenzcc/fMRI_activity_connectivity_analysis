function fig = fun_plot_3D4D(TMP_fname, img_4D, v_4D, img_over, mat_over, mm, cond, cm, threshold, dummy)

if nargin < 9 || isempty(dummy)
    isdummy = false;
else
    isdummy = true;
end

v_TMP = spm_vol(TMP_fname);
mat_TMP = v_TMP.mat;
img_TMP = spm_read_vols(v_TMP);
mat_4D = v_4D.mat;

if nargin < 8 ||  isempty(threshold)
    p = floor(fun_mm2position(mm, mat_over));
    threshold = img_over(p(1), p(2), p(3)) / 2;
end

if isdummy
    fig = dummy.fig;
    axe1 = dummy.axe1;
    axe2 = dummy.axe2;
    axe3 = dummy.axe3;
    axe4 = dummy.axe4;
else
    fig = figure;
    axe1 = subplot(2, 2, 2);
    axe2 = subplot(2, 2, 1);
    axe3 = subplot(2, 2, 4);
    axe4 = subplot(2, 2, 3);
end

fun_draw_TMP(mm, img_TMP, mat_TMP, img_4D, mat_4D,...
    fig, axe1, axe2, axe3, axe4, cm, cond)
p_over = floor(fun_mm2position(mm, mat_over));
x = img_over(p_over(1), p_over(2), p_over(3));
set(get(axe4, 'Title'), 'String',...
    sprintf('%0.0f, %0.0f, %0.0f, %f',...
    mm(1), mm(2), mm(3), x))

fun_draw_overlap(mm, img_TMP, mat_TMP, img_over, mat_over,...
    axe1, axe2, axe3, threshold)

if isdummy
    return
end
set(fig, 'WindowButtonMotionFcn', @ButttonMotionFcn)
set(fig, 'WindowButtonUpFcn', @ButttonUpFcn)
user_data.axe1 = axe1;
user_data.axe2 = axe2;
user_data.axe3 = axe3;
user_data.axe4 = axe4;
user_data.mm = mm;
user_data.defaultmm = mm;
user_data.img_TMP = img_TMP;
user_data.mat_TMP = mat_TMP;
user_data.sz = size(img_TMP);
user_data.cm = cm;
user_data.cond = cond;
user_data.img_4D = img_4D;
user_data.mat_4D = mat_4D;
user_data.img_over = img_over;
user_data.mat_over = mat_over;
user_data.threshold = threshold;
set(fig, 'UserData', user_data)
end

%% handel Mouse Up
function ButttonUpFcn(src, event)
user_data = get(gcf, 'UserData');
axe1 = user_data.axe1;
axe2 = user_data.axe2;
axe3 = user_data.axe3;
axe4 = user_data.axe4;
sz = user_data.sz;
set(get(axe4, 'Title'), 'String', '')

is_in_axe123 = 0;
[in, cpa] = cpf_in_axe(gcf, axe1);
if in
    % disp('axe1')
    mm = user_data.mm;
    mat = user_data.mat_TMP;
    position = fun_mm2position(mm, mat);
    position(3) = cpa(1, 2);
    position(1) = sz(1) - cpa(1, 1) + 1;
    newmm = fun_position2mm(position, mat);
    is_in_axe123 = 1;
end

[in, cpa] = cpf_in_axe(gcf, axe2);
if in
    % disp('axe2')
    mm = user_data.mm;
    mat = user_data.mat_TMP;
    position = fun_mm2position(mm, mat);
    position(3) = cpa(1, 2);
    position(2) = cpa(1, 1);
    newmm = fun_position2mm(position, mat);
    is_in_axe123 = 2;
end

[in, cpa] = cpf_in_axe(gcf, axe3);
if in
    % disp('axe3')
    mm = user_data.mm;
    mat = user_data.mat_TMP;
    position = fun_mm2position(mm, mat);
    position(2) = cpa(1, 2);
    position(1) = sz(1) - cpa(1, 1) + 1;
    newmm = fun_position2mm(position, mat);
    is_in_axe123 = 3;
end

if is_in_axe123 > 0
    mat_4D = user_data.mat_4D;
    p_4D = floor(fun_mm2position(newmm, mat_4D));
    img_4D = user_data.img_4D;
    sz_4D = size(img_4D);
    if sum(p_4D<=0)
        disp('sorry, no data on this point.')
        return
    end
    if sum(p_4D>sz_4D(1:3)')
        disp('sorry, no data on this point.')
        return
    end
    img_TMP = user_data.img_TMP;
    mat_TMP = user_data.mat_TMP;
    cm = user_data.cm;
    cond = user_data.cond;
    fun_draw_TMP(newmm, img_TMP, mat_TMP, img_4D, mat_4D,...
        gcf, axe1, axe2, axe3, axe4, cm, cond)
    
    img_over = user_data.img_over;
    mat_over = user_data.mat_over;
    p_over = floor(fun_mm2position(newmm, mat_over));
    x = img_over(p_over(1), p_over(2), p_over(3));
    set(get(axe4, 'Title'), 'String',...
        sprintf('%0.0f, %0.0f, %0.0f, %f',...
        newmm(1), newmm(2), newmm(3), x))
    threshold = user_data.threshold;
    fun_draw_overlap(newmm, img_TMP, mat_TMP, img_over, mat_over,...
        axe1, axe2, axe3, threshold)
    
    user_data.mm = newmm;
    set(gcf, 'UserData', user_data)
else
    [in, cpa] = cpf_in_axe(gcf, axe4);
    if in
        return
    end
    img_TMP = user_data.img_TMP;
    mat_TMP = user_data.mat_TMP;
    img_4D = user_data.img_4D;
    mat_4D = user_data.mat_4D;
    img_over = user_data.img_over;
    mat_over = user_data.mat_over;
    cm = user_data.cm;
    cond = user_data.cond;
    defaultmm = user_data.defaultmm;
    fun_draw_TMP(defaultmm, img_TMP, mat_TMP, img_4D, mat_4D,...
        gcf, axe1, axe2, axe3, axe4, cm, cond)
    
    p_over = floor(fun_mm2position(defaultmm, mat_over));
    x = img_over(p_over(1), p_over(2), p_over(3));
    set(get(axe4, 'Title'), 'String',...
        sprintf('%0.0f, %0.0f, %0.0f, %f',...
        defaultmm(1), defaultmm(2), defaultmm(3), x))
    
    img_over = user_data.img_over;
    mat_over = user_data.mat_over;
    threshold = user_data.threshold;
    fun_draw_overlap(defaultmm, img_TMP, mat_TMP, img_over, mat_over,...
        axe1, axe2, axe3, threshold)
end

end

%% handel Mouse Motion
function ButttonMotionFcn(src, event)
user_data = get(gcf, 'UserData');
try
    axe1 = user_data.axe1;
catch
    return
end
axe2 = user_data.axe2;
axe3 = user_data.axe3;
axe4 = user_data.axe4;
sz = user_data.sz;
set(get(axe4, 'Title'), 'String', '--')
ud_axe4 = get(axe4, 'UserData');
set(ud_axe4.curve_new, 'YData', ud_axe4.ts)

is_in_axe123 = 0;
[in, cpa] = cpf_in_axe(gcf, axe1);
if in
    % disp('axe1')
    mm = user_data.mm;
    mat = user_data.mat_TMP;
    position = fun_mm2position(mm, mat);
    position(3) = cpa(1, 2);
    position(1) = sz(1) - cpa(1, 1) + 1;
    newmm = fun_position2mm(position, mat);
    is_in_axe123 = 1;
end

[in, cpa] = cpf_in_axe(gcf, axe2);
if in
    % disp('axe2')
    mm = user_data.mm;
    mat = user_data.mat_TMP;
    position = fun_mm2position(mm, mat);
    position(3) = cpa(1, 2);
    position(2) = cpa(1, 1);
    newmm = fun_position2mm(position, mat);
    is_in_axe123 = 2;
end

[in, cpa] = cpf_in_axe(gcf, axe3);
if in
    % disp('axe3')
    mm = user_data.mm;
    mat = user_data.mat_TMP;
    position = fun_mm2position(mm, mat);
    position(2) = cpa(1, 2);
    position(1) = sz(1) - cpa(1, 1) + 1;
    newmm = fun_position2mm(position, mat);
    is_in_axe123 = 3;
end

if is_in_axe123
    mat_4D = user_data.mat_4D;
    p_4D = floor(fun_mm2position(newmm, mat_4D));
    img_4D = user_data.img_4D;
    sz_4D = size(img_4D);
    if sum(p_4D<=0)
        % if idx out mat
        return
    end
    if sum(p_4D>sz_4D(1:3)')
        % if idx out mat
        return
    end
    
    img_over = user_data.img_over;
    mat_over = user_data.mat_over;
    p_over = floor(fun_mm2position(newmm, mat_over));
    x = img_over(p_over(1), p_over(2), p_over(3));
    set(get(axe4, 'Title'), 'String',...
        sprintf('%0.0f, %0.0f, %0.0f, %f',...
        newmm(1), newmm(2), newmm(3), x))
    
    %     set(get(axe4, 'Title'), 'String',...
    %         sprintf('%0.0f, %0.0f, %0.0f', newmm(1), newmm(2), newmm(3)))
    set(ud_axe4.curve_new, 'YData',...
        squeeze(img_4D(p_4D(1), p_4D(2), p_4D(3), :)))
    m = mean(img_4D(p_4D(1), p_4D(2), p_4D(3), :));
    for r = ud_axe4.rect
        p = get(r, 'Position');
        set(r, 'Position', [p(1), m, p(3), 1])
    end
    yl = get(axe4, 'YLim');
    for r = ud_axe4.rect
        p = get(r, 'Position');
        set(r, 'Position', [p(1), yl(1), p(3), yl(2)-yl(1)])
    end
    
    p = floor(position);
    ud = get(axe1, 'UserData');
    ruler = ud.ruler;
    p1 = sz(1) - p(1) + 1;
    p2 = p(3);
    set(ruler.ruler_x, 'XData', [p1, p1])
    set(ruler.ruler_y, 'YData', [p2, p2])
    
    ud = get(axe2, 'UserData');
    ruler = ud.ruler;
    p1 = p(2);
    p2 = p(3);
    set(ruler.ruler_x, 'XData', [p1, p1])
    set(ruler.ruler_y, 'YData', [p2, p2])
    
    ud = get(axe3, 'UserData');
    ruler = ud.ruler;
    p1 = sz(1) - p(1) + 1;
    p2 = p(2);
    set(ruler.ruler_x, 'XData', [p1, p1])
    set(ruler.ruler_y, 'YData', [p2, p2])
end

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

