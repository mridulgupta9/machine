

%%Copyright (C) 2013 Dhruv Kohli

%%Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

%%The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

%%THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NON-INFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

clear ; close all; clc

%% =============== Part 1 : Initializing CNN Variables and Other Stuff ===================================

total_num_layer = 3; %input("\nEnter the total number of layers in your CNN including input and output layers \n")
num_training_ex = 5000; % input("\nEnter the total number of training examples ( number of images you will be using to train CNN ) \n")
dim_input_layer_images = 20 %input("\nEnter the dimension ( ONLY SQUARE IMAGES ARE ALLOWED SO DIMENSION IS LENGTH = WIDTH OF IMAGE )\n")
total_num_labels = 10%  input("\nEnter the number of labels/classification of the input images\n")
sample_factor =  0% input("\nEnter the Sampling Factor you want to keep in your CNN\n")
num_kernel_layer = total_num_layer - 1 ; % Total Number of Kernel Layers

dim_subkernel_layer                = zeros(num_kernel_layer,1); % Allocating Space for dimensions of subkernels in each kernel layer
kernel_count_in_layer              = zeros(num_kernel_layer,1); 
num_subkernels_per_kernel_in_layer = zeros(num_kernel_layer,1);
num_feature_maps_in_layer          = zeros(total_num_layer,1);
dim_feature_maps_in_layer          = zeros(total_num_layer,1);
num_bias_in_layer                  = zeros(total_num_layer-1,1);
num_bias_per_kernel_in_layer       = zeros(num_kernel_layer,1) ;
num_bias_in_kernel_layer           = zeros(num_kernel_layer,1);
num_bias_per_subkernel             = 1;

for i1=1:num_kernel_layer,
printf("\nEnter the dimension of the subkernel of %dth kernel layer\n",i1);
dim_subkernel_layer(i1,1) = input("");
end

for i2=1:num_kernel_layer,
printf("\nEnter the number of kernels in %dth kernel layer\n",i2);      % NUMBER OF KERNELS IN FINAL LAYER = NUMBER OF LABELS
kernel_count_in_layer(i2,1) = input("");
end

printf("\nNumber of kernels in final kernel layer must match the number of labels\n");

num_feature_maps_in_layer(1,1)=1;

printf("\nBy default, number of feature maps in layer 1 ( input layer ) = 1\n");

dim_feature_maps_in_layer(1,1)=dim_input_layer_images;

for i3=2:total_num_layer,
num_feature_maps_in_layer(i3,1)            = kernel_count_in_layer(i3-1,1);
if sample_factor!=0,
dim_feature_maps_in_layer(i3,1)            = 1 + (dim_feature_maps_in_layer(i3-1,1)-dim_subkernel_layer(i3-1))/sample_factor;
end
if sample_factor==0,
dim_feature_maps_in_layer(i3,1)            = 1 ;
end
num_subkernels_per_kernel_in_layer(i3-1,1) = num_feature_maps_in_layer(i3-1,1);
num_bias_in_layer(i3-1,1)                  = dim_feature_maps_in_layer(i3,1)*dim_feature_maps_in_layer(i3,1);
num_bias_per_kernel_in_layer(i3-1,1)       = num_subkernels_per_kernel_in_layer(i3-1,1);
num_bias_in_kernel_layer(i3-1)             = kernel_count_in_layer(i3-1,1)*num_bias_per_kernel_in_layer(i3-1,1);
end



%% ====================  Part 2 : Loading And Visualising Data And Loading Weights ===============================================

printf("\nLoading and Visualizing Data ...\n");

load('ex4data1.mat');

x_modified = zeros(dim_feature_maps_in_layer(1,1),dim_feature_maps_in_layer(1,1),num_training_ex);
y_modified = zeros(total_num_labels,num_training_ex);

for i4=1:num_training_ex,
x_modified(:,:,i4) = reshape(X(i4,:),dim_feature_maps_in_layer(1,1),dim_feature_maps_in_layer(1,1));
y_modified(y(i4,1),i4)=1;
end

bias    = cell(num_kernel_layer,1);
kernel  = cell(num_kernel_layer,1);



for i5=1:num_kernel_layer,
bias{i5}   = cell(kernel_count_in_layer(i5,1),1);
kernel{i5} = cell(kernel_count_in_layer(i5,1),1);
for i6=1:kernel_count_in_layer(i5,1),
kernel{i5}{i6} =cell(num_subkernels_per_kernel_in_layer(i5,1),1);
bias{i5}{i6}   =cell(num_subkernels_per_kernel_in_layer(i5,1),1);
for i7=1:num_subkernels_per_kernel_in_layer(i5,1),
kernel{i5}{i6}{i7} = mod(rand(dim_subkernel_layer(i5,1),dim_subkernel_layer(i5,1)),0.12) - 0.12;
bias{i5}{i6}{i7}   = mod(rand(dim_subkernel_layer(i5,1),dim_subkernel_layer(i5,1)),0.12) - 0.12;
end
end
end



grad_kernel = kernel;
grad_bias   = bias;

nbrick = cell(total_num_layer,1);
nbrick{1} = cell(1,1);
nbrick{1}{1} = zeros(size(x_modified(:,:,1)));

for i8=2:total_num_layer,
nbrick{i8} = cell(kernel_count_in_layer(i8-1,1),1);
for i9=1:kernel_count_in_layer(i8-1,1),
nbrick{i8}{i9} = zeros(dim_feature_maps_in_layer(i8,1),dim_feature_maps_in_layer(i8,1));
end
end

delta_brick = nbrick;

% Randomly select 100 data points to display
sel = randperm(size(X, 1));
sel = sel(1:100);
displayData(X(sel, :));

fprintf('Program paused. Press enter to continue.\n');
pause;



%% =========== Part 3.1 : Computing Cost With Regularization And Simultaneously Implementing Backpropagation to get Gradient =============
%% =========== Part 3.2 : Computing Optimal Kernel Weights To Be Used Later To Predict H-W-D ======================================
fprintf("\nFeedforward and Backpropagating Convoltuion Neural Network ... \n")
lambda = 0.01;
alpha = 3.85;
for s1=1:10,
if s1%5==0,
	alpha=alpha/2;
end


[J grad_kernel grad_bias]= cnnCost(kernel, bias, nbrick, num_training_ex, dim_feature_maps_in_layer, num_kernel_layer,                    total_num_labels,num_subkernels_per_kernel_in_layer,kernel_count_in_layer, x_modified, y_modified, lambda, sample_factor, dim_subkernel_layer, total_num_layer, num_feature_maps_in_layer);

s1
fprintf("\nCost : %f\n", J);

if J<0.5,
	break ;
end

for s2=1:num_kernel_layer, 
for s3=1:kernel_count_in_layer(s2,1),
for s4=1:num_subkernels_per_kernel_in_layer(s2,1),
for s5=1:dim_subkernel_layer(s2,1),
for s6=1:dim_subkernel_layer(s2,1),
kernel{s2,1}{s3,1}{s4,1}(s5,s6) -= alpha*grad_kernel{s2,1}{s3,1}{s4,1}(s5,s6);
if s5==dim_subkernel_layer&&s6==dim_subkernel_layer,
bias{s2,1}{s3,1}{s4,1}(1,1) -= alpha*grad_bias{s2,1}{s3,1}{s4,1}(1,1);
end

end
end
end
end
end

end



fprintf('Program paused. Press enter to continue.\n');
pause;



%% ======================= Part 4: Predicting On Training Examples And Obtaining Accuracy ==========================

pred = predict(num_training_ex, nbrick, x_modified,num_kernel_layer,kernel_count_in_layer,dim_feature_maps_in_layer, num_subkernels_per_kernel_in_layer, kernel, bias, dim_subkernel_layer, sample_factor );

fprintf('\nTraining Set Accuracy: %f\n', mean(double(pred == y)) * 100);