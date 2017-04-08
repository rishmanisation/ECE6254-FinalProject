function [ image_out ] = ROI( image, ROI_x_size, ROI_y_size )
%-----------------------------------------------------------------------%
% ROI - Region of Interest Block
%-----------------------------------------------------------------------%
% Inputs: image
% Outputs:  ROI_x_size - number of pixels in x direction
%           ROI_y_size - number of pixels in y direction
%
%

[img_size_y, img_size_x] = size(image);

center_of_image_x = img_size_x/2;
center_of_image_y = img_size_y/2;

for y = 1:img_size_y
    for x = 1:img_size_x
        if((x > (center_of_image_x - ROI_x_size)) && (x < (center_of_image_x + ROI_x_size)))
            if((y > (center_of_image_y - ROI_y_size)) && (y < (center_of_image_y + ROI_y_size)))
                image_out(y,x) = image(y,x);
            else
                image_out(y,x) = 0;
            end
        else
            image_out(y,x) = 0;
        end
    end
end
    
%figure;imagesc(image_out);colorbar; title('ROI');

end

