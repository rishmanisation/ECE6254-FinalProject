function [nu,Pf] = raPsd2d(img,res)
% function raPsd2d(img,res)
%
% Computes radially averaged power spectral density (power
% spectrum) of image IMG with spatial resolution RES.
%
% (C) E. Ruzanski, RCG, 2009

%% Process image size information
[N M] = size(img);

%% Compute power spectrum
imgf = fftshift(fft2(img));
imgfp = 4*abs(imgf).^2/(N*M); 

%% Adjust PSD size
dimDiff = abs(N-M);
dimMax = max(N,M);
% Make square
if N > M                                                                    % More rows than columns
  if ~mod(dimDiff,2)                                                      % Even difference
    imgfp = [NaN(N,dimDiff/2) imgfp NaN(N,dimDiff/2)];                  % Pad columns to match dimensions
  else                                                                    % Odd difference
    imgfp = [NaN(N,floor(dimDiff/2)) imgfp NaN(N,floor(dimDiff/2)+1)];
  end
elseif N < M                                                                % More columns than rows
  if ~mod(dimDiff,2)                                                      % Even difference
    imgfp = [NaN(dimDiff/2,M); imgfp; NaN(dimDiff/2,M)];                % Pad rows to match dimensions
  else
    imgfp = [NaN(floor(dimDiff/2),M); imgfp; NaN(floor(dimDiff/2)+1,M)];% Pad rows to match dimensions
  end
end

halfDim = floor(dimMax/2) + 1;                                              % Only consider one half of spectrum (due to symmetry)

%% Compute radially average power spectrum
[X Y] = meshgrid(-dimMax/2:dimMax/2-1, -dimMax/2:dimMax/2-1);               % Make Cartesian grid
[theta rho] = cart2pol(X, Y);                                               % Convert to polar coordinate axes
rho = round(rho);
i = cell(floor(dimMax/2) + 1, 1);
for r = 0:floor(dimMax/2)
  i{r + 1} = find(rho == r);
end
Pf = zeros(1, floor(dimMax/2)+1);
for r = 0:floor(dimMax/2)
  Pf(1, r + 1) = nanmean( imgfp( i{r+1} ) );
end

f1 = [1:floor(dimMax/2)+1];
nu = (1/(res*(floor(dimMax/2)+1)))*f1;

a = std(img(:))^2/trapz(nu(2:end),Pf(2:end));
Pf = a*Pf;

return;