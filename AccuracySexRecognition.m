function [ accuracySexRecognition ] = AccuracySexRecognition(test_dir, PCA_database, Labels, TopEigenVectors, AvgFace, doOptimisation)
%ACCURACYSEXRECOGNITION Provide sex-recognition accuracy for given testing
%set

%get all testing images and test sex recognition

female = {'Flavia', 'WINATA', 'Richa'};
femaleIndexes = [];

for i = 1:length(female)
    femaleIndexes = union(femaleIndexes, strmatch(char(female(i)), Labels));
end

PCA_female = PCA_database(femaleIndexes, :);
PCA_male = PCA_database(setdiff(1:size(PCA_database, 1), femaleIndexes), :);

totalErrors = 0;

files = dir(test_dir);

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
        Dtest = (double(test_image(:)') - AvgFace) * TopEigenVectors;

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

accuracySexRecognition = (1 - totalErrors/size(PCA_database, 1)) * 100;
end

