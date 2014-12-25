function [  ] = ImageResize( imageName, Ab)

imageSrcName = fullfile('faces_data',imageName);

 %check if jpg file exist, if not use png file
if exist(imageSrcName, 'file') == 0
    imageSrcName = strrep(imageSrcName, '.jpg', '.png'); 
end

image = imread(imageSrcName);
image = rgb2gray(image);

out_image = zeros(64, 64);

A = Ab([1, 3; 2 4]);
b = Ab([5; 6]);

for x = 1:64
    for y = 1:64
        out_pixel = int32(A \ ([x ; y] - b));
        
        if (out_pixel(1) <= 0) 
            out_pixel(1) = 1;
        end
        if (out_pixel(1) >= 240) 
            out_pixel(1) = 239;
        end
        if (out_pixel(2) <= 0) 
            out_pixel(2) = 1;
        end
        if (out_pixel(2) >= 320) 
            out_pixel(2) = 319;
        end
        
        out_image(x, y) = uint8(image(out_pixel(2), out_pixel(1)));
    end
end

if isempty(strfind(imageName, '4')) == 0 || isempty(strfind(imageName, '5')) == 0
    %put image in training set
    imageDestinationName = fullfile('test_images',imageName);
else
    %put image in test set
    imageDestinationName = fullfile('train_images',imageName);
end

imwrite(mat2gray(out_image'), imageDestinationName);

end

