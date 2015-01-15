function [ accuracy ] = AccuracyFaceRecognition(test_dir, PCA_database, Labels, TopEigenVectors, AvgFace, checkNSimilarFaces, doOptimisation)
%ACCURACYRECOGNITION Provide face-recognition accuracy for given testing set

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
        Dtest = (double(test_image(:)') - AvgFace) * TopEigenVectors;

        %finding most similar image from training set
        euclidianDistance = sqrt(sum((PCA_database' - repmat(Dtest, size(PCA_database, 1), 1)') .^ 2));
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

accuracy = (1 - totalErrors/size(PCA_database, 1)) * 100;


end

