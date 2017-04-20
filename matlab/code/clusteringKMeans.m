function [ clusteredImage, clusterID ] = clusteringKMeans( image )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

% Reference:
% https://www.mathworks.com/help/images/examples/color-based-segmentation-using-k-means-clustering.html

% Get the size of the input image
[ nrows, ncols ] = size( image );

% Convert to doubles for Kmeans algorithm
clusterInput = double( image );

% Reshape the image for Kmeans algorithm
clusterInput = reshape( clusterInput, nrows*ncols, 1 );

% We specify that there should only be 2 clusters within the image (target
% and background)
nClusters = 2;

% Compute the Kmeans clusters
% nClusters  - number of expected clusters
% distance   - distance measurement
% Replicates -  number of times to repeate (error mitigation)
[cluster_idx, cluster_center] = kmeans( clusterInput, nClusters,     ...
                                        'distance',   'sqEuclidean', ...
                                        'Replicates', 3);
                                    
                                    
% Need to reshape the image back to the original size
clusteredImage = reshape( cluster_idx, nrows, ncols );

% The output clusteredImage has values which determine which is the target
% and the background. Unfortunently these can change from run to run. This
% code below returns the cluster number assosciated with the target. The
% expectation is that the target will be the largest thing in the frame,
% so the mean of it's centers will be the larger of the two clusters.
% This simply selects the larger of the two.
mean_cluster_value  = mean(cluster_center,2);
[tmp, idx]          = sort(mean_cluster_value);
clusterID           = idx(2);

% For debugging purpose only
% figure('Name','Clustered Image');
% subplot(2,1,1); imshow( image,          [] ); title('Original Image');
% subplot(2,1,2); imshow( clusteredImage, [] ); title('Clusterd Image');

end

