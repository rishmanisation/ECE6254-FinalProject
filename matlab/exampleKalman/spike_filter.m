function [ image ] = spike_filter( image, Spike_Threshold )
% Implements a Noise Spike filter
% This filter is used to suppress hot glint spikes (non-gaussian noise). The spiked pixel is
% averaged between the two pixels near it.
% Future: Add a gaussian weight distribution

[img_size_y, img_size_x] = size(image);

for y = 1:img_size_y - 2
    for x = 3:img_size_x - 2
    
        spike_side1 = 0;
        spike_side2 = 0;

        %Side by side pixels x [x] X [x] x
        if(abs(img(y+1,x) - img(y,x)) > Spike_Threshold)
            if(abs(img(y-1,x) - img(y,x)) > Spike_Threshold)
                spike_side1 = (img(y+1,x)+img(y-1,x))*1/2;
            end
        end

        %Far side by side pixels [x] x X x [x]
        if(abs(img(y+2,x) - img(y,x)) > Spike_Threshold)
            if(abs(img(y-2,x) - img(y,x)) > Spike_Threshold)
                spike_side2 = (img(y+2)+img(y-2))*1/4;
            end
        end

        %Now average the spiked values and modify the center pixel
        image(y,x) = spike_side1 + spike_side2;
    end
end

%figure;imagesc(img);colorbar; title('Spike Reduction');


end

