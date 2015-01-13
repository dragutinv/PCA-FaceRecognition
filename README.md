Face recognition project for Applied Math

List of functions:

- PCA_Recognition: main function, calls all operations and gives accuracy statistics for face and sex recognition
- NormalizeImages: normalize all images, in order to prepare them for PCA
- ImageResize: performs given transformation on input image
- EigenFaces: compute PCA from testing images, and performs face recognition with each image in testing set
- ShowEigenFaces: shows Eigen faces from training and testing set
- ShowPictures: shows normalized images from training and testing set
- ShowEigenValues: shows Eigen values from training set
- ShowFeaturePoints: shows marked feature points (eyes, nose, mouth) for each image