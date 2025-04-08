% Edge Detection
% Created on: 02/04/25
% By Author: Supratit Datta, BT22ECE127

clc; 
clear; 
close all;

% Read the input image
img = imread('input.jpeg');

% Convert to grayscale (if the image is RGB)
gray_img = rgb2gray(img);

% Define Sobel filters manually
Gx = [-1 0 1; -2 0 2; -1 0 1];   % Sobel operator for X direction
Gy = [-1 -2 -1; 0 0 0; 1 2 1];    % Sobel operator for Y direction

% Perform convolution with the Sobel operators
Ix = conv2(double(gray_img), Gx, 'same');  % Convolution with Gx
Iy = conv2(double(gray_img), Gy, 'same');  % Convolution with Gy

% Compute Gradient Magnitude
Gradient_Mag = sqrt(Ix.^2 + Iy.^2);  % Magnitude of the gradient

% Normalize the gradient magnitude to the range 0-255
Gradient_Mag = uint8(255 * (Gradient_Mag / max(Gradient_Mag(:))));

% Apply thresholding for edge detection
threshold = 50;              % Adjust this value as needed
Edge_Image = Gradient_Mag > threshold;  % Logical image (edge map)

% Display the results in a 3-row subplot
figure;

subplot(2,2,1);
imshow(img);
title('Original Image');

subplot(2,2,2);
imshow(gray_img);
title('Grayscale Image');

subplot(2,2,3);
imshow(Gradient_Mag);
title('Gradient Magnitude');

subplot(2,2,4);
imshow(Edge_Image);
title('Edge Detected Image');