% Discrete Wavelet Transform 
% Created on: 19/03/25
% By Author: Supratit Datta, BT22ECE127

clc;
clear;
close all;

% Read the image
i = imread('input.jpeg');

% Check if image loaded
if isempty(i)
    disp('Image not found. Please check the path!');
    return;
end

% Convert to grayscale if RGB
if size(i, 3) == 3
    i_gray = rgb2gray(i);
else
    i_gray = i;
end

% Haar Wavelet filters
Lo = [1 1]/sqrt(2);  % Low Pass Filter
Hi = [1 -1]/sqrt(2); % High Pass Filter

% Row-wise filtering
L = conv2(double(i_gray), Lo', 'same');  
H = conv2(double(i_gray), Hi', 'same');

% Column-wise filtering
LL = conv2(L, Lo, 'same');
LH = conv2(L, Hi, 'same');
HL = conv2(H, Lo, 'same');
HH = conv2(H, Hi, 'same');

% Plotting the Sub-bands
figure;
subplot(2,2,1); imshow(mat2gray(LL)); title('Approximation (LL)');
subplot(2,2,2); imshow(mat2gray(LH)); title('Horizontal Detail (LH)');
subplot(2,2,3); imshow(mat2gray(HL)); title('Vertical Detail (HL)');
subplot(2,2,4); imshow(mat2gray(HH)); title('Diagonal Detail (HH)');

% Reconstructed Image (Just adding all components)
x = LL + LH + HL + HH;
figure;
subplot(1,2,1); imshow(i_gray); title('Original Image');
subplot(1,2,2); imshow(mat2gray(x)); title('Decomposed Image');