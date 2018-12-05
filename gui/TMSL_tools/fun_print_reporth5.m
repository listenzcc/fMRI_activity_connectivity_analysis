function fun_print_reporth5(appPath, subPath, firstfile, handles)

di = dicominfo(firstfile);
name = sprintf('%s  %s',...
    di.PatientName.FamilyName, di.PatientName.GivenName);
sex = di.PatientSex;
age = di.PatientAge;
date = di.FileModDate;

tmp_report = fullfile(appPath, 'resources', 'report_tmp.html');

fid = fopen(tmp_report, 'r');
line_cell = {};
line = fgetl(fid);
line_cell = cell_add(line_cell, line);
while ischar(line)
%     fprintf('%d: %s\n', length(line_cell), line)
    line = fgetl(fid);
    line_cell = cell_add(line_cell, line);
end
fclose(fid);

new_report = fullfile(subPath, 'report.html');
fid = fopen(new_report, 'w');
for j = 1 : length(line_cell)
    line = line_cell{j};
    fprintf(fid, '%s\n', line);
    if ~isempty(strfind(line,...
            '<!--tobefilled: four column name, age, sex, date-->'))
        fprintf(fid, '<td>%s</td>\n', name);
        fprintf(fid, '<td>%s</td>\n', age);
        fprintf(fid, '<td>%s</td>\n', sex);
        fprintf(fid, '<td>%s</td>\n', strrep(date, 'ÔÂ', 'month'));
        continue
    end
    if ~isempty(strfind(line,...
            '<!--tobefilled: four column qualify, effect spot, target spot--'))
        fprintf(fid, '<td>%s</td>\n', get(handles.pushbutton9, 'UserData'));
        mm = get(handles.pushbutton10, 'UserData');
        str_amy = sprintf('%dmm, %dmm, %dmm',...
            mm.max_amy_mm(1), mm.max_amy_mm(2), mm.max_amy_mm(3));
        fprintf(fid, '<td>%s</td>\n', str_amy);
        str_c = sprintf('%dmm, %dmm, %dmm',...
            mm.max_c_mm(1), mm.max_c_mm(2), mm.max_c_mm(3));
        fprintf(fid, '<td>%s</td>\n', str_c);
        continue
    end
    if ~isempty(strfind(line,...
            '<!--tobefilled: id-->'))
        [a, b, c] = fileparts(subPath);
        fprintf(fid, 'id: %s', b);
        continue
    end
end
fclose(fid);

web(new_report)

end

function c = cell_add(c, a)
c{length(c)+1, 1} = a;
end