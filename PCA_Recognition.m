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
test_dir = 'test_images';
train_dir = 'train_images';

if doNormalization == true
    %normalize images - adjust location of features of each image 
    NormalizeImages(features_dir, faces_dir, test_dir, train_dir, doOptimisation);
end

ShowPictures(train_dir, test_dir);

accuracies = [];
sexAccuracies = [];
checkNsimilarFacesSet = [];
topEigenVectors = 50;

for checkNsimilarFaces = 1:5
        [PCA_database, transformationMatrix, EigenValues, accuracy, sexAccuracy] = EigenFaces(train_dir, test_dir, checkNsimilarFaces, topEigenVectors, doOptimisation);
        accuracies = [accuracies accuracy];
        sexAccuracies = [sexAccuracies sexAccuracy];
        checkNsimilarFacesSet = [checkNsimilarFacesSet checkNsimilarFaces];
end

ShowEigenValues(EigenValues);
ShowEigenFaces(PCA_database, transformationMatrix);

%show relation between number of eigen vectors, number of similar faces and face recognition accuracy
figure('units','normalized','outerposition',[0 0 1 1], 'Name','Accuracy of face recognition');
scatter(checkNsimilarFacesSet, accuracies);
title('Relation between number of similar faces and accuracy')
xlabel('Nuber of smilar faces');
ylabel('Accuracy');
set(gca,'xtick',0:5);
grid on;

%show relation between number of eigen vectors and sex accuracy
figure('units','normalized','outerposition',[0 0 1 1], 'Name','Accuracy of sex recognition');
bar(topEigenVectors, sexAccuracies(1));

title('Accuracy of sex recognition');
xlabel('Number of Eigen vectors');
ylabel('Accuracy');
grid on;

clear all;

end

