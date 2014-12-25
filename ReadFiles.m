function [ ] = ReadFiles( dirPath )
%Read every feature file and put data in the vector
%   Detailed explanation goes here
files = dir(dirPath);

FileName = {};

i =  1;

%locations of features (eyes, tip of nose, tips of mouth) 
Fpredetermined = [13 20;
    50 20;
    34 34;
    16 50;
    48 50;]';


%get names of all image and store them in FileName array
for x = 1:length(files)
    file = files(x).name;
    if isempty(strfind(file, 'txt')) == 0
        FileName{i} = char(files(x).name);
        i = i + 1;
    end
end

j = 0;

Favg = Fpredetermined;
doIteration = true;

%normalise pictures
while (doIteration == true)
    
    %temporary variable used to calculate average of Fip at the end of
    %cycle
    FAvgTmp = 0;
    
    for i =  1:length(FileName)
        tmpFile = FileName{i};
        tmpTxtFile = fullfile('features_data',tmpFile);
        data = importdata(tmpTxtFile);
        
        Fi = [data(1) data(6) 1; data(2) data(7) 1; data(3) data(8) 1; data(4) data(9) 1; data(5) data(10) 1]';
        
        %Ab - trasformation that aligns features of image Fi with Fpredetermined
        Ab =  Favg * pinv(Fi);
        
        %Fip - transformation of image Fi
        Fip = Ab * Fi;
        
        
        imgFile = strrep(tmpFile, '.txt', '.jpg'); 
        ImageResize(imgFile, Ab);
        
        if (i == 1 && j == 0)
            Favg = Fip;
        end
        
        FAvgTmp = FAvgTmp + Fip;
    end
    
    %find difference between current and previous average, if its small
    %stop
    diff = abs((FAvgTmp / length(FileName)) - Favg);
    maxDiff = max(diff(:));
    
    if maxDiff < 0.8
        doIteration = false;
    end
    
    Favg = FAvgTmp / length(FileName);
    j = j+1;
end

clear all;


end
