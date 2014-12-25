function [  ] = EigenFaces( )
% Calculate Eigen Faces for training set
% refference: http://www.doc.ic.ac.uk/~dfg/ProbabilisticInference/IDAPILecture15.pdf

files = dir('train_images');

FileName = {};

%each row of D corresponds to one training image
D = [];
Labels = [];

%get names of all image and store them in FileName array
for x = 1:length(files)
    file = files(x).name;
    
    if (isempty(strfind(file, 'jpg'))) == 0 || (isempty(strfind(file, 'png'))) == 0
        imageSrcName = fullfile('train_images',file);
        image = imread(imageSrcName);
        D = [D; image(:)'];
        Labels = [Labels; cellstr(file)]; 
    end
end

trainingSetSize = size(D);

Dmean = double(D) - repmat(mean(D), trainingSetSize(1), 1);

%covariance matrix - reduced form
sigmaPrim = (double(Dmean) * double(Dmean')).*(1 / (trainingSetSize(1)-1));

%Calculating eigenvectors
%E is a diagonal matrix containing the eigenvalues in ascending order. 
%V is a matrix whose columns are the corresponding right eigenvectors.
[V,E] = eig(sigmaPrim);

%transformation (projection) matrix. We use top k eigenvectors from covariance matrix
k = 30;
topV = V(:, end-k:end);
F = double(D') * topV;

PCA_database = double(D) * F;

%FIND SIMILAR IMAGE FROM TEST SET


imageSrcName = fullfile('test_images','roberto5.jpg');
test_image = imread(imageSrcName);
Dtest = double(test_image(:)') * F;

euclidianDistance = sqrt(sum((PCA_database' - repmat(Dtest, trainingSetSize(1), 1)') .^ 2));
indexOfFace = find(euclidianDistance == min(euclidianDistance(:)));

disp(Labels(indexOfFace));


%reconstruction = PCA_database * F';
%imshow(mat2gray(reshape(reconstruction(40, :), 64, 64)));



