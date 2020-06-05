cameraParams = load('Desktop/cameraParams.mat').cameraParams;

imageFileNames = {'Desktop/Img1.jpg', ...
    'Desktop/Img2.jpg'
    };
k = 2;
imOrigin = imread(imageFileNames{k});
%Convert to HSV
imHSV = rgb2hsv(imOrigin);

% Get the saturation channel.
saturation = imHSV(:, :, 2);

% Threshold the image
t = graythresh(saturation);
coins = (saturation > t);
coins = imclearborder(coins);
%figure; imshow(coins);

%NOTE: Sensibility of SEh and SEv  is crucial because if the prospective make the
%coins too flat after the first opening they can be horizontal line and can
%be swipped by the second opening.This values work well with both image, for be more reliable we could
%do a morphological restruction to recover the coins that get eventually lost 
SEv = strel('rectangle', [1 10]);
SEh = strel('rectangle', [6 1]); 

% Remove vertical lines
coins = imopen(coins, SEv);
%figure, imshow(coins);
% Remove horizontal lines
coins = imopen(coins, SEh);

% Dilate to better visualize the coins, doesn't change the centroids
coins = imdilate(coins, strel('disk', 5));
figure, imshow(coins)
title('Coins inside checkboard');


%Centroids extraction from region props
stats = regionprops('table',coins,'Centroid');
centers = stats.Centroid;

%Calculation of missing parameters of cameraparams
[M, N] = size(imOrigin);
intrinsics = cameraIntrinsics(cameraParams.FocalLength,cameraParams.PrincipalPoint, [M N]);

[imagePoints, boardSize, imagesUsed] = detectCheckerboardPoints(imOrigin);

[R,t] = extrinsics(imagePoints,cameraParams.WorldPoints, cameraParams);

centroidsImage = pointsToWorld(intrinsics, R, t,centers);
% Size of the single square
squareSize = cameraParams.WorldPoints(2,2);

%Max values in worldpoints for both coordinates
maxCbRow = max(cameraParams.WorldPoints(:,1));
maxCbColumn = max(cameraParams.WorldPoints(:,2));

%Checkboard rows values
cbRows = (0:squareSize:maxCbRow);
%Checkboard columns values
cbColumns = (0:squareSize:maxCbColumn);


%Preparing index for interate, given by the number of objects (coins) found
nCoins = size(centroidsImage);
nCoins = nCoins(1);

figure, imshow(imOrigin);
hold on
%For each coin found calculate where is located in the checkboard (x,y) and
%draw the square of the square when the coin is contained
for k = 1:nCoins
    %Retrive the indices of the row and column that are greater in position
    %that the centroid. The centroid will be between the first two indexes
    %obtained thanks to the -1
    xIdx = find(centroidsImage(k,1) <= cbRows) -1;
    yIdx = find(centroidsImage(k,2) <= cbColumns) -1;
    
    % I need the nearest two points for both coordinate
    cbX = [cbRows(xIdx(1)) cbRows(xIdx(2))];
    cbY = [cbColumns(yIdx(1)) cbColumns(yIdx(2))];
    
    %Indices in order to print the (cbX,cbY) in the board starting from 0
    centroids = [xIdx(1) yIdx(1)];
    
    % Shall I have the skew to make the quad perfectly in the checkboard
    % (?)
    quad = [[cbX(1) cbY(1) 0]; [cbX(2) cbY(1) 0]; [cbX(2) cbY(2) 0]; [cbX(1) cbY(2) 0]];

    imgPoints = worldToImage(intrinsics, R, t, quad);
    
    %Print of text with cokumn and row + quad
    string = "( "+ (centroids(1)+1) + "," + (centroids(2)+1) + ")";
    plot([imgPoints(1,1) imgPoints(2,1)  imgPoints(3,1) imgPoints(4,1) imgPoints(1,1)], [imgPoints(1,2) imgPoints(2,2)  imgPoints(3,2) imgPoints(4,2) imgPoints(1,2)],  'Color', 'Red','LineWidth', 2);
    text(imgPoints(1,1), imgPoints(1,2) + squareSize, string, 'FontSize', 15,  'Color', 'w');
    title('Coin Position');
end
hold off


