function [sum_weights] = sum_op_weights(kernel,kernel_count_in_layer,num_kernel_layer,num_subkernels_per_kernel_in_layer)
sum_weights=0;
for i16=1:num_kernel_layer,
for i17=1:kernel_count_in_layer(i16,1),
for i18=1:num_subkernels_per_kernel_in_layer(i16,1),
sum_weights += sum(sum(kernel{i16}{i17}{i18}.*kernel{i16}{i17}{i18}));
end
end
end
end

