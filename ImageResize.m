function [  ] = ImageResize( imageName, Ab)

imageSrcName = fullfile('faces_data',imageName);
image = imread(imageSrcName);
image = rgb2gray(image);

out_image = zeros(64, 64);

A = [Ab(1, :); Ab(2, :)];
b = Ab(3, :)';

for x = 1:64
    for y = 1:64
        out_pixel = int32(pinv(A) * ( [x ; y] - b));
        
        if (out_pixel(1) <= 0) out_pixel(1) = 1;
        end
        if (out_pixel(1) >= 240) out_pixel(1) = 239;
        end
        if (out_pixel(2) <= 0) out_pixel(2) = 1;
        end
        if (out_pixel(2) >= 320) out_pixel(2) = 319;
        end
        
        out_image(x, y) = uint8(image(out_pixel(2), out_pixel(1)));
    end
end

imageDestinationName = fullfile('tmp_faces',imageName);
imwrite(out_image, imageDestinationName);

end

