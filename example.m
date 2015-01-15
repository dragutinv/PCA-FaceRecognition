%get similar faces and sex for given image
close all;

%PARAMETERS
train_dir = 'train_images';
test_dir = 'test_images';
useTopEigenVectors = 40;
doOptimisation = false; %perform histogram equalisation to optimise recognition
showNSimilarFaces = 5;

file = fullfile(test_dir,'Dragutin_4.jpg');
test_image = imread(file);


% GET PCA DATABASE FOR TRAINING IMAGES
[PCA_database, Labels, TopEigenVectors, EigenValues, AvgFace] = EigenFaces(train_dir, useTopEigenVectors, doOptimisation);

if doOptimisation == true
    test_image = adapthisteq(test_image);
end

% SIMILAR FACES

%getting principal components of test image
Dtest = (double(test_image(:)') - AvgFace) * TopEigenVectors;

%finding most similar image from training set
euclidianDistance = sqrt(sum((PCA_database' - repmat(Dtest, size(PCA_database, 1), 1)') .^ 2));
sortedEuclidianDistance = sort(euclidianDistance);
        
%find m most similar images to test one
indexOfFace = find(euclidianDistance <= sortedEuclidianDistance(showNSimilarFaces));
recognisedImages = Labels(indexOfFace);

similarImgs = [];

for i = 1:length(recognisedImages)
    recognisedImage = char(recognisedImages(i));
    similarImg = fullfile(train_dir,recognisedImage);
    similarImgs = [similarImgs imread(similarImg)];
end

% SEX RECOGNITION
female = {'Flavia', 'WINATA', 'Richa'};
femaleIndexes = [];

for i = 1:length(female)
    femaleIndexes = union(femaleIndexes, strmatch(char(female(i)), Labels));
end

PCA_female = PCA_database(femaleIndexes, :);
PCA_male = PCA_database(setdiff(1:size(PCA_database, 1), femaleIndexes), :);

%finding average distance between test image and male/female
%training set
        
euclidianDistanceFemale = sqrt(sum((PCA_female' - repmat(Dtest, size(PCA_female, 1), 1)') .^ 2));
euclidianDistanceMale = sqrt(sum((PCA_male' - repmat(Dtest, size(PCA_male, 1), 1)') .^ 2));
                
totalDistanceFemale = mean(mean(euclidianDistanceFemale));
totalDistanceMale = mean(mean(euclidianDistanceMale));

sex = 'male';
if (totalDistanceFemale < totalDistanceMale)
    sex = 'female';
end

figure('units','normalized','outerposition',[0 0 1 1]);
subplot(3, 1, 1);
imshow(test_image);
title('Original image');

subplot(3, 1, 2);
imshow(similarImgs);
title('Similar images');

subplot(3, 1, 3);
imshow(imread(strcat(char(sex),'.png'), 'BackgroundColor', [1 1 1]));
title('Recognised sex');







