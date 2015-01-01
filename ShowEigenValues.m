function [ output_args ] = ShowEigenValues( EigenValues )
%SHOWEIGENVALUES Show eigen values on plot

%show Eigen values on plot
figure('units','normalized','outerposition',[0 0 1 1], 'Name','Eigen values');
semilogy(diag(EigenValues), '.');

end

