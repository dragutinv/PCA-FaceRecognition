function [  ] = ImageResize( faces_dir, test_dir, train_dir, doOptimisation, imageName, Ab)

imageSrcName = fullfile(faces_dir,imageName);

 %check if jpg file exist, if not use png file
if exist(imageSrcName, 'file') == 0
    imageSrcName = strrep(imageSrcName, '.jpg', '.png'); 
end

image = imread(imageSrcName);
image = rgb2gray(image);

if doOptimisation == true
    %adjust contrast to optimise face recognition
    image = imadjust(image);
end

out_image = zeros(64, 64);

A = Ab([1, 3; 2 4]);
b = Ab([5; 6]);

for x = 1:64
    for y = 1:64
        out_pixel = int32(A \ ([x ; y] - b));
        
        if (out_pixel(1) <= 0 || out_pixel(1) >= 240 || out_pixel(2) >= 320 || out_pixel(2) <= 0) 
            pixel_value = 254;
        else
            pixel_value = image(out_pixel(2), out_pixel(1));
        end
        
        out_image(x, y) = uint8(pixel_value);
    end
end

out_image = mat2gray(out_image');

if isempty(strfind(imageName, '4')) == 0 || isempty(strfind(imageName, '5')) == 0
    %put image in training set
    imageDestinationName = fullfile(test_dir,imageName);
else
    %put image in test set
    imageDestinationName = fullfile(train_dir,imageName);
end

imwrite(out_image, imageDestinationName);

end

