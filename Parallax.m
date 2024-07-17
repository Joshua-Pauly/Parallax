I1_o = imread('Camera 1\5.jpg');
I2_o = imread("Camera 2\5.jpg");

%I1 = undistortImage(I1_o,stereoParams.CameraParameters1);
%I2 = undistortImage(I2_o,stereoParams.CameraParameters2);
I1 = I1_o;
I2 = I2_o;


if (size(I1,3)>1)
    I1 = rgb2gray(I1); % Convert to grayscale
end
if (size(I2,3)>1)
    I2 = rgb2gray(I2); % Convert to grayscale
end
 
%Detect SURF in both images.
points1 = detectSURFFeatures(I1);
[features1, points1] = extractFeatures(I1,points1);
points2 = detectSURFFeatures(I2);
[features2, points2] = extractFeatures(I2,points2);
% match points
indexPairs = matchFeatures(features1, features2, 'Method','Exhaustive', 'MaxRatio',0.02);
matchedPoints1 = points1(indexPairs(:,1), :);
matchedPoints2 = points2(indexPairs(:,2), :); 
 
for i=1:height(indexPairs)
    center1 = round(matchedPoints1.Location(i,:));
    center2 = round(matchedPoints2.Location(i,:));
    %define an area around the feature point
    area1 = [center1(1)-10,center1(2)-10,20,20];
    area2 = [center2(1)-10,center2(2)-10,20,20];
    %Compute the distance from camera to the point.
    point3d = triangulate(center1, center2, stereoParams);
    distanceInMeters = norm(point3d)/1000;
 
    %Display the detected point and distance.
    distanceAsString = sprintf('%0.1f meters', distanceInMeters);
    I1 = insertObjectAnnotation(I1,'rectangle',area1,distanceAsString,'FontSize',60,Color='black',TextColor='white');
    I2 = insertObjectAnnotation(I2,'rectangle',area2, distanceAsString,'FontSize',60,Color='black',TextColor='white');
end
 
imshowpair(I1, I2, 'montage');