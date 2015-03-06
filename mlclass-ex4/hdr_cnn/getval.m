function [num_kernel_layer kernel_count_in_layer num_subkernels_per_kernel_in_layer dim_subkernel_layer ] = getval()


num_kernel_layer = 2;
kernel_count_in_layer(1,1)=25;
kernel_count_in_layer(2,1)=10;
num_subkernels_per_kernel_in_layer(1,1)=1;
num_subkernels_per_kernel_in_layer(2,1)=25;
dim_subkernel_layer(1,1)=20;
dim_subkernel_layer(2,1)=1;


end