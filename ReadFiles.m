function [ featuresVector ] = ReadFiles( dirPath )
%Read every feature file and put data in the vector
%   Detailed explanation goes here
files = dir(dirPath);

FileName = {};

i =  1;

Fpredetermined = [13 20;
    50 20;
    34 34;
    16 50;
    48 50;];

for x = 1:length(files)
    file = files(x).name;
    if length(findstr('txt', file)) > 0
        FileName{i} = char(files(x).name);
        
        %         fileName = fullfile('features_data',FileName(i));
        %         data = importdata(fileName);
        %
        %         if i == 1
        %             Favg = [data(1); data(6); data(2); data(7); data(3); data(8); data(4); data(9); data(5); data(10)];
        %         else
        %             Fi = [data(1); data(6); data(2); data(7); data(3); data(8); data(4); data(9); data(5); data(10)];
        %             Favg = (Favg + Fi) / 2;
        %         end
        i = i + 1;
    end
end

j = 0;

Favg = Fpredetermined;

%normalise pictures
while (j < 8)
    
    %temporary variable used to calculate average of Fip at the end of
    %cycle
    FAvgTmp = 0;
    
    for i =  1:length(FileName)
        tmpFile = FileName{i};
        tmpFile = fullfile('features_data',tmpFile);
        data = importdata(tmpFile);
        
        Fi = [data(1) data(6) 1; data(2) data(7) 1; data(3) data(8) 1; data(4) data(9) 1; data(5) data(10) 1];
        
        %Ab - trasformation that aligns features of image Fi with Fpredetermined
        Ab = pinv(Fi) * Favg;
        
        %Fip - transformation of image Fi
        Fip = Fi * Ab;
        
        if (i == 1 && j == 0)
            Favg = Fip;
        end
        
        FAvgTmp = FAvgTmp + Fip;
    end
    
    if (j > 0) 
        (FAvgTmp / length(FileName)) - Favg
    end
    
    Favg = FAvgTmp / length(FileName);
    
    j = j+1;
end

clear all;


end
