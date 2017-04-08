function [ image_out ] = wavelet_filter( image )
% Implement a 2D Wavelet filter
% The filter is broken into an x and y 1D filter to save hardware in the
% design. The kernel is a 5x5 and is repeated 3 times to improve the
% 'smearing' of the noise on the image. This filter's primary purpose is to
% rid any noise speckles and average.

kernel_x = [1/16 1/4 3/8 1/4 1/16];
kernel_y = kernel_x';
image_out = image;
for y = 1:1
    % Smear in x direction
    image_out = conv2(double(image_out),double(kernel_x),'same');
    % Smear in y direction
    image_out = conv2(double(image_out),double(kernel_y),'same');
    %Print image and measure SNR
    figure;imagesc(image_out);colorbar; title('Convolution');
end

clear kernel_x kernel_y

end

