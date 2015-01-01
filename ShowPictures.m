function [ output_args ] = ShowPictures(train_dir, test_dir)
%SHOWPICTURES Function displays training and test images
%   Detailed explanation goes here

figure('units','normalized','outerposition',[0 0 1 1], 'Name','Training images');

files = dir(train_dir);

i = 1;
for x = 1:length(files)
    file = files(x).name;
    
    if (isempty(strfind(file, 'jpg'))) == 0 || (isempty(strfind(file, 'png'))) == 0
        subplot(5, round(length(files)/5), i);
        imageSrcName = fullfile(train_dir,file);
        image = imread(imageSrcName);
        imshow(image);
        i = i + 1;
    end
end

figure('units','normalized','outerposition',[0 0 1 1], 'Name','Testing images');

files = dir(test_dir);

i = 1;
for x = 1:length(files)
    file = files(x).name;
    
    if (isempty(strfind(file, 'jpg'))) == 0 || (isempty(strfind(file, 'png'))) == 0
        subplot(5, round(length(files)/5), i);
        imageSrcName = fullfile(test_dir,file);
        image = imread(imageSrcName);
        imshow(image);
        i = i + 1;
    end
end

end

