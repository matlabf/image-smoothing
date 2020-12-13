clc;
clear;
close all;

% Cutoff
%! imgCutOff = 100;
%! imgCutOff = 200;
imgCutOff = 100;

% Load image
img = imread('cameraman.tif');
img = im2double(img);
yres = size(img, 1);
xres = size(img, 2);
figure;
imshow(img);
title('Original image');

% Pad image
xres2 = 2 * xres;
yres2 = 2 * yres;
imgPad = zeros(yres2, xres2);
imgPad(1:yres, 1:xres) = img;
figure;
imshow(imgPad);
title('Padded image');

% Multiply with (-1)^(x+y)
imgMul = imgPad;
for y = 1 : yres
  for x = 1 : xres
    imgMul(y, x) = imgMul(y, x) * (-1)^(x + y);
  end
end
title('Shifted image');

% Frequency domain image
imgFreq = fft2(imgMul);
figure;
imshow(real(imgFreq));
title('Image in frequency domain');

% Compute distance plot
imgDist = zeros(yres2, xres2);
for y = 1 : yres2
  for x = 1 : xres2
    xDist = xres - x;
    yDist = yres - y;
    imgDist(y, x) = sqrt(xDist^2 + yDist^2);
  end
end
figure;
imshow(imgDist / xres);
title('Distance image');

% Obtain impulse response
%! imgImpls = 1 ./ (1 + (imgDist / imgCutOff) .^ 2);  % Butterworth filter
%! imgImpls = exp(-(imgDist.^2) / (2*imgCutOff));     % Gaussian filter
%! imgImpls = (imgDist < imgCutOff) * 1.0;            % Ideal filter
imgImpls = 1 ./ (1 + (imgDist / imgCutOff) .^ 2);
%! imgImpls = imgImpls;                            % Low-pass filter
%! imgImpls = 1 - imgImpls;                        % High-pass filter
figure;
imshow(imgImpls);
title('Impulse response');

% Obtain frequency filtered image
imgFreqFilt = imgFreq .* imgImpls;
figure;
imshow(imgFreqFilt);
title('Freq. filtered image');

% Obtain filtered unshifted image
imgFiltUnshft = real(ifft2(imgFreqFilt));
figure;
imshow(imgFiltUnshft);
title('Filtered, but unshifted image');

% Obtain filtered, but unextracted image
imgFiltUnextrct = imgFiltUnshft;
for y = 1 : yres
  for x = 1 : xres
    imgFiltUnextrct(y, x) = imgFiltUnextrct(y, x) * (-1)^(x + y);
  end
end
figure;
imshow(imgFiltUnextrct);
title('Filtered, but unextracted image');

% Obtain filtered image
imgFilt = imgFiltUnextrct(1:yres, 1:xres);
figure;
imshow(imgFilt);
title('Filtered image');
