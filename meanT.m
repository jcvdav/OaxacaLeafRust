clear, close, clc
files = ls('.\Data\tmp\*.csv');

min_date = datenum(2000,1,1);
ignored = zeros(length(files),1);

j = 1;

tic
for i = 1:length(files)
    disp(i)
    
    file = fullfile('.','Data','tmp',char(string(files(i,:))));
    
    % Load the files
    fileID = fopen(file);
    Meta = textscan(fileID, '%s %s %s %s',8,'Delimiter',',');
    
    end_date_i = datenum(char(Meta{2}{6}));
    id_i = str2double(string(Meta{2}{1}));
    station_i = Meta{2}{2};
    
    if(end_date_i > min_date)
        disp('empezando a sacar datos...')
        position_i = strsplit(Meta{2}{3}, 'N ');
        latitude_i = str2double(string(position_i{1}));
        longitude_i = strsplit(position_i{2}, 'W');
        longitude_i = str2double(strsplit(string(longitude_i{1})));
        
        Data = textscan(fileID, '%s %s %s %s','Delimiter',',');
            month_i = str2double(string(Data{1}));
            day_i = str2double(string(Data{2}));
            year_i = str2double(string(Data{3}));
            date_num_i = datenum(year_i, month_i, day_i);
            date_i = datestr(date_num_i);
            var_i = str2double(string(Data{4}));
        
        %Concatenate data
%         id = [id; id_1];
%         station = [station; station_i];
%         latitude = [latitude; latitude_i];
%         longitude = [; ];
%         month = [; ];
%         day = [; ];
%         year = [; ];
%         date = [; ];
%         date_num = [; ];
%         var = [; ];
    else
        ignored(j) = id_i;
        j = j+1;
    end
    
    fclose(fileID);
end
toc