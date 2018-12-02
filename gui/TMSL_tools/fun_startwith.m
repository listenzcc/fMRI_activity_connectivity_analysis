function out = fun_startwith(str, pre)
out = false;
if length(str) < length(pre)
    return
end
sf = strfind(str, pre);
if isempty(sf)
    return
end
if sf(1) == 1
    out = true;
end
end

