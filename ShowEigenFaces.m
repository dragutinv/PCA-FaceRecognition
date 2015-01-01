function [ ] = ShowEigenFaces( PCA_database, transformationMatrix)
%SHOWEIGENFACES Display in figure all eigen faces from training set

eigenFaces = PCA_database * transformationMatrix';
eigenFacesSize = size(eigenFaces);

figure('units','normalized','outerposition',[0 0 1 1], 'Name','Eigen faces');

i = 1;

colormap gray;
%reconstruction of test face from PCA database
for i=1:eigenFacesSize(1)
    subplot(5, ceil(eigenFacesSize(1)/5), i);
    imshow(mat2gray(reshape(eigenFaces(i, :), 64, 64)));
    i = i + 1;
end

end

