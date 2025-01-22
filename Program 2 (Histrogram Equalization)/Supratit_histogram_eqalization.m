% Histogram Equalization Implementation
% Created on: 18/01/25
% By Author: Supratit Datta, BT22ECE127

% Dynamic Input
[fileName, filePath] = uigetfile({'*.jpg;*.jpeg;*.png;*.bmp', 'Image Files (*.jpg, *.jpeg, *.png, *.bmp)'},'Select an Image File');

if isequal(fileName, 0)
    disp('No file selected. Exiting...');
    return;
end

% Extract File Name
fullFileName = fullfile(filePath, fileName);
% disp(['Selected file: ', fullFileName]);

if ~isfile(fullFileName)
    error('The selected file does not exist: %s', fullFileName);
end

try
    inputImage = imread(fullFileName); 
    
    % Check if image is RGB and convert to grayscale
    if size(inputImage, 3) == 3
        inputImage = rgb2gray(inputImage);
    end
catch ME
    disp('Error reading the image file:');
    disp(ME.message);
    return;
end

[rows, cols] = size(inputImage);

% Step 1: Compute the histogram of the original image
histogramOriginal = zeros(256, 1); % Initialize histogram
for i = 1:rows
    for j = 1:cols
        intensity = inputImage(i, j);
        histogramOriginal(intensity+1) = histogramOriginal(intensity+1)+1;
    end
end

% Step 2: Normalize the histogram to get the PDF
pdfOriginal = histogramOriginal / (rows * cols);

% Step 3: Compute the CDF
cdfOriginal = cumsum(pdfOriginal);

% Step 4: Map the intensities to equalized values
equalizedValues = round(cdfOriginal * 255);

% Step 5: Create the equalized image
equalizedImage = zeros(size(inputImage));
for i = 1:rows
    for j = 1:cols
        equalizedImage(i, j) = equalizedValues(inputImage(i, j) + 1);
    end
end

equalizedImage = uint8(equalizedImage); % Convert to uint8 for display

% Step 6: Compute the histogram for the equalized image
histogramEqualized = zeros(256, 1);
for i = 1:rows
    for j = 1:cols
        intensity = equalizedImage(i, j);
        histogramEqualized(intensity+1) = histogramEqualized(intensity+1)+1;
    end
end

% Normalize and compute CDF for the equalized image
pdfEqualized = histogramEqualized / (rows * cols);
cdfEqualized = cumsum(pdfEqualized);

figure;

% Original Image and its Histogram
subplot(2, 2, 1);
imshow(inputImage);
title('Original Image');

subplot(2, 2, 2);
imhist(inputImage);
hold on;
plot(cdfOriginal * max(histogramOriginal), 'r', 'LineWidth', 2);
legend('Histogram', 'CDF');
title('Histogram and CDF of Original Image');

% Equalized Image and its Histogram
subplot(2, 2, 3);
imshow(equalizedImage);
title('Equalized Image');

subplot(2, 2, 4);
imhist(equalizedImage);
hold on;
plot(cdfEqualized * max(histogramEqualized), 'r', 'LineWidth', 2);
legend('Histogram', 'CDF');
title('Histogram and CDF of Equalized Image');

% disp('Histogram equalization completed successfully.');