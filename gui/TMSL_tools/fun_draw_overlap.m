function fun_draw_overlap(mm, img_TMP, mat_TMP, img_over, mat_over,...
    axe1, axe2, axe3, threshold)
% after draw_TMP, overlap statistic map on TMP

p_TMP = floor(fun_mm2position(mm, mat_TMP));
sz = size(img_TMP);

p_over = floor(fun_mm2position(mm, mat_over));
activity = img_over(p_over(1), p_over(2), p_over(3));

% only plot positive
img_over(img_over < 0) = 0;
% scale into [0 1]
m = max(img_over(:));
threshold = threshold / m;
img_over = img_over / m;

% ¹Ú×´Î»
ud = get(axe1, 'UserData');
slice = get(ud.TMP);
TMP_ = slice.CData;
for j = 1 : sz(1)
    for k = 1 : sz(3)
        p = [j, p_TMP(2), k];
        mm = fun_position2mm(p, mat_TMP);
        v = get_v(mm, img_over, mat_over);
        if isnan(v)
            continue
        end
        if v <= threshold
            continue
        end
        TMP_(k, end-j+1) = uint8(128 + v*127);
    end
end
set(ud.TMP, 'CData', TMP_)

% Ê¸×´Î»
ud = get(axe2, 'UserData');
slice = get(ud.TMP);
TMP_ = slice.CData;
for j = 1 : sz(2)
    for k = 1 : sz(3)
        p = [p_TMP(1), j, k];
        mm = fun_position2mm(p, mat_TMP);
        v = get_v(mm, img_over, mat_over);
        if isnan(v)
            continue
        end
        if v <= threshold
            continue
        end
        TMP_(k, j) = uint8(128 + v*127);
    end
end
set(ud.TMP, 'CData', TMP_)

% ºá¶ÏÎ»
ud = get(axe3, 'UserData');
slice = get(ud.TMP);
TMP_ = slice.CData;
for j = 1 : sz(1)
    for k = 1 : sz(2)
        p = [k, j, p_TMP(3)];
        mm = fun_position2mm(p, mat_TMP);
        v = get_v(mm, img_over, mat_over);
        if isnan(v)
            continue
        end
        if v <= threshold
            continue
        end
        TMP_(j, end-k+1) = uint8(128 + v*127);
    end
end
set(ud.TMP, 'CData', TMP_)
end

function v = get_v(mm, img_over, mat_over)
% get value from overlap img on mm
v = nan;
p = floor(fun_mm2position(mm, mat_over));
if sum(p < 1)
    return
end
sz = size(img_over);
if sum(p > sz')
    return
end
v = img_over(p(1), p(2), p(3));
end

