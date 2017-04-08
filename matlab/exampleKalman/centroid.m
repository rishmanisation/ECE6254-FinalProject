function [ centroid_x, centroid_y ] = centroid( image )
%-----------------------------------------------------------------------%
% Centroid Block
%-----------------------------------------------------------------------%
% Inputs: image
% Outputs:  centroid_x - pixel for the centroid in the x direction
%           centroid_y - pixel for the centroid in the y direction
%
%
%   'X/Y' Centroid
%   centroid_x = summation[f(x)*x] / summation[f(x)]
%   centroid_y = summation[f(y)*y] / summation[f(y)]
% 
% Notes: The maximum number of bits needed on the image would result from a
% white image (255) for the entire image.
% 
% So.... accum_block_bits = round(log2(size_x*size_y*255)+0.5) = 25 bits

sum_fx_times_x = 0;
sum_fx = 0;

sum_fy_times_y = 0;
sum_fy = 0;

[img_size_y, img_size_x] = size(image);

for y = 1:img_size_y
    for x = 1:img_size_x
        sum_fx_times_x = sum_fx_times_x + image(y,x)*x;
        sum_fx = sum_fx + image(y,x);
        
        sum_fy_times_y = sum_fy_times_y + image(y,x)*y;
        sum_fy = sum_fy + image(y,x);    
    end 
end

centroid_x = sum_fx_times_x / sum_fx;
centroid_y = sum_fy_times_y / sum_fy;

end

