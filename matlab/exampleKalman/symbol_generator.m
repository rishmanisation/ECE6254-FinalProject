function [ image_out ] = symbol_generator( image, track_enable, roi_x_size, roi_y_size )
%-----------------------------------------------------------------------%
% Symbol Generator
%-----------------------------------------------------------------------%

% Need a flag that designates if the user as activated the 'track' mode.
% The color is blue when not tracking and red when tracking. The output to
% the VGA display will need to be controlled.
if(strcmp(track_enable, 'track_enabled'))
    ROI_color = 255;
else
    ROI_color = 175;
end

% Parameters that define the ROI symbols
ROI_thickness = 2;

[img_size_y, img_size_x] = size(image);

image_out = image;

center_of_image_x = img_size_x/2;
center_of_image_y = img_size_y/2;

for y = 1:img_size_y
    for x = 1:img_size_x
        % Top and bottom bar of ROI box
        if((x > (center_of_image_x - roi_x_size - ROI_thickness)) && (x < (center_of_image_x + roi_x_size + ROI_thickness)))
            if((y > (center_of_image_y - roi_y_size - ROI_thickness)) && (y < (center_of_image_y - roi_y_size + ROI_thickness)))
                image_out(y,x) = ROI_color;
            elseif((y > (center_of_image_y + roi_y_size - ROI_thickness)) && (y < (center_of_image_y + roi_y_size + ROI_thickness)))
                image_out(y,x) = ROI_color;
            end
        end
        
        % Left and Right bar of ROI box
        if((y > (center_of_image_y - roi_y_size - ROI_thickness)) && (y < (center_of_image_y + roi_y_size + ROI_thickness)))
            if((x > (center_of_image_x - roi_x_size - ROI_thickness)) && (x < (center_of_image_x - roi_x_size + ROI_thickness)))
                image_out(y,x) = ROI_color;
            elseif((x > (center_of_image_x + roi_x_size - ROI_thickness)) && (x < (center_of_image_x + roi_x_size + ROI_thickness)))
                image_out(y,x) = ROI_color;
            end
        end
        
    end 
end

figure;imagesc(image_out);colorbar; title('Symbol Generator');

end

