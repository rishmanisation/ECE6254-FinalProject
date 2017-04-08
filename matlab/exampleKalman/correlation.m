function [ correlation_factor, matlab_corr ] = correlation( reference_image, search_image )

% We first need the reference image, which will be the ROI of the first
% image. The search image will be the ROI of the next image following.
%
%                       summation[summation[R(x,y)*S(i,j)(x,y)]]
%  C(ij) = ------------------------------------------------------------------
%          summation[summation[R(x,y)^2]]*summation[summation[S(i,j)(x,y)^2]]
%

%figure;subplot(2,1,1);imagesc(reference_image);colorbar; title('Correlation - Reference Image');
%subplot(2,1,2);imagesc(search_image);colorbar; title('Correlation - Search Image');

matlab_corr = corr2(reference_image,search_image);

[img_size_y, img_size_x] = size(reference_image);
sum_sum_R_times_S = 0;
sum_sum_R_squared = 0;
sum_sum_S_squared = 0;

for y = 1:img_size_y
    for x = 1:img_size_x
        sum_sum_R_times_S =  sum_sum_R_times_S + reference_image(y,x)*search_image(y,x);
        sum_sum_R_squared = sum_sum_R_squared + (reference_image(y,x))^2;
        sum_sum_S_squared = sum_sum_S_squared + (search_image(y,x))^2;
    end 
end

correlation_factor = sum_sum_R_times_S / (sum_sum_R_squared*sum_sum_S_squared)^(1/2);

end

