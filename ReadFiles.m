function [ featuresVector ] = ReadFiles( dirPath )
%Read every feature file and put data in the vector
%   Detailed explanation goes here
files = dir(dirPath);

FileName = {};

i =  1;

Fpredetermined = [91; 153;
    154; 155;
    119; 186;
    96; 219;
    146; 220;];

for x = 1:length(files)
    file = files(x).name;
    if length(findstr('txt', file)) > 0
        FileName{i} = files(x).name;
        
        x = fullfile('features_data',char(FileName(i)));
        data = importdata(x);
        
        if i == 1
            Favg = [data(1); data(6); data(2); data(7); data(3); data(8); data(4); data(9); data(5); data(10)];
        else
            Fi = [data(1); data(6); data(2); data(7); data(3); data(8); data(4); data(9); data(5); data(10)];
            Favg = (Favg + Fi) / 2;
        end
        
        i = i + 1;
    end
    
end

end
