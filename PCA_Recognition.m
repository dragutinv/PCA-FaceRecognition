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
topEigenVectorsSet = [];

for checkNsimilarFaces = 1:5
    for topEigenVectors = 45:50
        [PCA_database, transformationMatrix, EigenValues, accuracy, sexAccuracy] = EigenFaces(train_dir, test_dir, checkNsimilarFaces, topEigenVectors, doOptimisation);
        accuracies = [accuracies accuracy];
        sexAccuracies = [sexAccuracies sexAccuracy];
        checkNsimilarFacesSet = [checkNsimilarFacesSet checkNsimilarFaces];
        topEigenVectorsSet = [topEigenVectorsSet topEigenVectors];
    end
end

ShowEigenValues(EigenValues);
ShowEigenFaces(PCA_database, transformationMatrix);

%show relation between number of eigen vectors, number of similar faces and face recognition accuracy
figure('units','normalized','outerposition',[0 0 1 1], 'Name','Accuracy of face recognition');
mesh(checkNsimilarFacesSet, topEigenVectorsSet, accuracies);

title('Relation between number of eigen faces, similar faces and accuracy')
xlabel('Number of similar faces');
ylabel('Number of Eigen vectors');
zlabel('Accuracy');

%show relation between number of eigen vectors and sex accuracy
figure('units','normalized','outerposition',[0 0 1 1], 'Name','Accuracy of sex recognition');
scatter(topEigenVectorsSet, accuracies);

title('Relation between number of eigen faces and sex recognition accuracy')
xlabel('Number of Eigen vectors');
ylabel('Accuracy');

clear all;

end

