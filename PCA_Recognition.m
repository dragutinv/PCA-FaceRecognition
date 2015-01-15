function [] = PCA_Recognition( doNormalization,  doOptimisation)
%PCA_RECOGNITION Main function that performs face recognition and sex
%recognition
%Parameters:
%@doNormalization - (true or false) normalize input pictures and divide them into training
%and test set
%@doOptimisation - (true or false) optimise image (optimise intensity level, contrast etc.)
%before performing face recognition

close all;

features_dir = 'features_data';
faces_dir = 'faces_data';
train_dir = 'train_images';
test_dir = 'test_images';

if doNormalization == true
    %normalize images - adjust location of features of each image 
    NormalizeImages(features_dir, faces_dir, test_dir, train_dir, doOptimisation);
end

ShowPictures(train_dir, test_dir);

accuracies = [];
checkNsimilarFacesSet = [];
useTopEigenVectors = 50;

[PCA_database, Labels, TopEigenVectors, EigenValues, AvgFace] = EigenFaces(train_dir, useTopEigenVectors, doOptimisation);

% GET GLOBAL STATISTICS FOR FACE RECOGNITION

for checkNsimilarFaces = 1:5
        accuracy = AccuracyFaceRecognition(test_dir, PCA_database, Labels, TopEigenVectors, AvgFace, checkNsimilarFaces, doOptimisation);
        accuracies = [accuracies accuracy];
        checkNsimilarFacesSet = [checkNsimilarFacesSet checkNsimilarFaces];
end

ShowEigenValues(EigenValues);
ShowEigenFaces(PCA_database, TopEigenVectors);

%show relation between number of eigen vectors, number of similar faces and face recognition accuracy
figure('units','normalized','outerposition',[0 0 1 1], 'Name','Accuracy of face recognition');
scatter(checkNsimilarFacesSet, accuracies);
title('Relation between number of similar faces and accuracy')
xlabel('Nuber of smilar faces');
ylabel('Accuracy');
set(gca,'xtick',0:5);
grid on;

% GET GLOBAL STATISTICS FOR SEX RECOGNITION

sexAccuracy = AccuracySexRecognition(test_dir, PCA_database, Labels, TopEigenVectors, AvgFace, doOptimisation);

%show relation between number of eigen vectors and sex accuracy
figure('units','normalized','outerposition',[0 0 1 1], 'Name','Accuracy of sex recognition');
bar(useTopEigenVectors, sexAccuracy);

title('Accuracy of sex recognition');
xlabel('Number of Eigen vectors');
ylabel('Accuracy');
grid on;

clear all;

end

