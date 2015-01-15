function [PCA_database, Labels, TopEigenVectors, EigenValues, AvgFace] = EigenFaces(train_dir, useKEigenVectors, doOptimisation)
% Calculate Eigen Faces for training set
% reference: http://www.doc.ic.ac.uk/~dfg/ProbabilisticInference/IDAPILecture15.pdf

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

AvgFace = mean(D);

%remove mean from training set
Dmean = double(D) - repmat(AvgFace, trainingSetSize(1), 1);

%covariance matrix - reduced form
sigmaPrim = (double(Dmean) * double(Dmean')).*(1 / (trainingSetSize(1)-1));

%Calculating eigenvectors
%eigenValues contains the eigenvalues in ascending order. 
%EigenVectors is a matrix whose columns are the corresponding eigenvectors.
%we can use our function Eigen instead build-in function eig to calculate
%eigen vectors
[EigenVectors, EigenValues] = eig(sigmaPrim); %Eigen(sigmaPrim);%very slow

%Eigen vectors of covariance matrix
EigenVectors = double(Dmean') * EigenVectors;

%normalize eigenvectors before projecting
for i = 1:size(EigenVectors, 2)
    EigenVectors(:, i) = EigenVectors(:, i)/norm(EigenVectors(:, i));
end

%transformation (projection) matrix. We use top useKEigenVectors eigenvectors from covariance matrix
TopEigenVectors = EigenVectors(:, 1:useKEigenVectors);

PCA_database = double(Dmean) * TopEigenVectors;