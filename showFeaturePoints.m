function [ ] = ShowFeaturePoints( )
%SHOWFEATUREPOINTS Mark feature points on each image

features_dir = 'features_data';
faces_dir = 'faces_data';

files = dir(faces_dir);

shapeInserter = vision.ShapeInserter('BorderColor','Custom','CustomBorderColor', uint8([255 0 0]));

%get names of all image and store them in FileName array
for x = 1:length(files)
    file = files(x).name;
    if isempty(strfind(file, 'jpg')) == 0 || isempty(strfind(file, 'png')) == 0
        tmpImgFile = file;
        tmpImgFile = fullfile(faces_dir,tmpImgFile);
        
        tmpFile = strrep(tmpImgFile,'faces_data\','');
        tmpFile = strrep(tmpFile,'.jpg','.txt');
        tmpFile = strrep(tmpFile,'.png','.txt');  
        
        tmpTxtFile = fullfile(features_dir,tmpFile);
        data = importdata(tmpTxtFile);
        
        I = imread(tmpImgFile);
       
        rectangle = int32([data(1)-5 data(6)-5 10 10]);
        J = step(shapeInserter, I, rectangle);
        
        rectangle = int32([data(2)-5 data(7)-5 10 10]);
        J = step(shapeInserter, J, rectangle);
        
        rectangle = int32([data(3)-5 data(8)-5 10 10]);
        J = step(shapeInserter, J, rectangle);
        
        rectangle = int32([data(4)-5 data(9)-5 10 10]);
        J = step(shapeInserter, J, rectangle);
        
        rectangle = int32([data(5)-5 data(10)-5 10 10]);
        J = step(shapeInserter, J, rectangle);
        
        imshow(J);
        pause();
    end
end

end

