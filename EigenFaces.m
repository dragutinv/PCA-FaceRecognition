function [PCA_database, transformationMatrix, EigenValues, accuracy, accuracySexRecognition] = EigenFaces(train_dir, test_dir, checkNSimilarFaces, useKEigenVectors, doOptimisation)
% Calculate Eigen Faces for training set
% refference: http://www.doc.ic.ac.uk/~dfg/ProbabilisticInference/IDAPILecture15.pdf

files = dir(train_dir);

FileName = {};

%each row of D corresponds to one training image
D = [];
Labels = [];

%get all training images and store them in matrix D. Store names of images
%in matrix Labels
for x = 1:length(files)
    file = files(x).name;
    
    if (isempty(strfind(file, 'jpg'))) == 0 || (isempty(strfind(file, 'png'))) == 0
        imageSrcName = fullfile(train_dir,file);
        image = imread(imageSrcName);
        
        if doOptimisation == true
            %perform histogram equalisation to optimise recognition
            image = adapthisteq(image);
        end
        
        D = [D; image(:)'];
        Labels = [Labels; cellstr(file)]; 
    end
end

trainingSetSize = size(D);

%remove mean from training set
Dmean = double(D) - repmat(mean(D), trainingSetSize(1), 1);

%covariance matrix - reduced form
sigmaPrim = (double(Dmean) * double(Dmean')).*(1 / (trainingSetSize(1)-1));

%Calculating eigenvectors
%eigenValues is a diagonal matrix containing the eigenvalues in ascending order. 
%EigenVectors is a matrix whose columns are the corresponding right eigenvectors.
[EigenVectors, EigenValues] = eig(sigmaPrim);

%Eigen vectors of covariance matrix
EigenVectors = double(Dmean') * EigenVectors;

%normalize eigenvectors before projecting
for i = 1:size(EigenVectors, 2)
    EigenVectors(:, i) = EigenVectors(:, i)/norm(EigenVectors(:, i));
end

%transformation (projection) matrix. We use top useKEigenVectors eigenvectors from covariance matrix
TopEigenVectors = EigenVectors(:, 1:useKEigenVectors);

transformationMatrix = TopEigenVectors;

PCA_database = double(Dmean) * transformationMatrix;

%FIND SIMILAR IMAGE FROM TEST SET

files = dir(test_dir);

totalErrors = 0;

%get all testing images and test face recognition
for x = 1:length(files)
    file = files(x).name;
    
    if (isempty(strfind(file, 'jpg'))) == 0 || (isempty(strfind(file, 'png'))) == 0
        imageSrcName = fullfile(test_dir,file);
        test_image = imread(imageSrcName);
        
        if doOptimisation == true
            %perform histogram equalisation to optimise recognition
            test_image = adapthisteq(test_image);
        end
        
        %getting principal components of test image
        Dtest = (double(test_image(:)') - mean(D)) * transformationMatrix;

        %finding most similar image from training set
        euclidianDistance = sqrt(sum((PCA_database' - repmat(Dtest, trainingSetSize(1), 1)') .^ 2));
        sortedEuclidianDistance = sort(euclidianDistance);
        
        %find m most similar images to test one
        indexOfFace = find(euclidianDistance <= sortedEuclidianDistance(checkNSimilarFaces));
        
        recognisedImages = Labels(indexOfFace);
        
        pos1 = strfind(file, '.') - 2;
        
        matchedImage = 0;
        for i = 1:length(recognisedImages)
           recognisedImage = char(recognisedImages(i));
           pos2 = strfind(recognisedImage, '.') - 2;
           
           if strcmp(file(1:pos1),recognisedImage(1:pos2)) == 1
               matchedImage = 1;
           end
        end
        
        if matchedImage == 0
            totalErrors = totalErrors + 1;
        end
    end
end

accuracy = (1 - totalErrors/size(D, 1)) * 100;

%get all testing images and test sex recognition

female = {'Flavia', 'WINATA', 'Richa'};
femaleIndexes = [];

for i = 1:length(female)
    femaleIndexes = union(femaleIndexes, strmatch(char(female(i)), Labels));
end

PCA_female = PCA_database(femaleIndexes, :);
PCA_male = PCA_database(setdiff(1:size(PCA_database, 1), femaleIndexes), :);

totalErrors = 0;

%get all testing images and test sex recognition
for x = 1:length(files)
    file = files(x).name;
    
    if (isempty(strfind(file, 'jpg'))) == 0 || (isempty(strfind(file, 'png'))) == 0
        imageSrcName = fullfile(test_dir,file);
        test_image = imread(imageSrcName);
        
        if doOptimisation == true
            %perform histogram equalisation to optimise recognition
            test_image = adapthisteq(test_image);
        end
        
        %getting principal components of test image
        Dtest = (double(test_image(:)') - mean(D)) * transformationMatrix;

        %finding average distance between test image and male/female
        %training set
        
        euclidianDistanceFemale = sqrt(sum((PCA_female' - repmat(Dtest, size(PCA_female, 1), 1)') .^ 2));
        euclidianDistanceMale = sqrt(sum((PCA_male' - repmat(Dtest, size(PCA_male, 1), 1)') .^ 2));
        
        
        totalDistanceFemale = mean(mean(euclidianDistanceFemale));
        totalDistanceMale = mean(mean(euclidianDistanceMale));
        
        sex = 'male';
        if (isempty(strfind(file, 'Flavia'))) == 0 || (isempty(strfind(file, 'WINATA'))) == 0 || (isempty(strfind(file, 'Richa'))) == 0
            sex = 'female';
        end
        
        if (totalDistanceFemale < totalDistanceMale && strcmp(sex, 'male'))
            %detected female, test image is male
            totalErrors = totalErrors + 1;
        end
        
        if (totalDistanceFemale > totalDistanceMale && strcmp(sex, 'female'))
            %detected male, test image is female
            totalErrors = totalErrors + 1;
        end
    end
end

accuracySexRecognition = (1 - totalErrors/size(D, 1)) * 100;


