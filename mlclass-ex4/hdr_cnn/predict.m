function p = predict(num_training_ex, nbrick, x_modified,num_kernel_layer,kernel_count_in_layer,dim_feature_maps_in_layer, num_subkernels_per_kernel_in_layer, kernel, bias, dim_subkernel_layer, sample_factor )

p = zeros(num_training_ex, 1);

for i10=1:num_training_ex,
nbrick{1}{1}(:,:) = x_modified(:,:,i10);
temp0=0;temp=0;
for i11=1:num_kernel_layer,
for i12=1:kernel_count_in_layer(i11,1),
for i13=1:dim_feature_maps_in_layer(i11+1,1),
for i14=1:dim_feature_maps_in_layer(i11+1,1),
for i15=1:num_subkernels_per_kernel_in_layer(i11,1),
temp0=operate_on(nbrick{i11}{i15},kernel{i11}{i12}{i15},bias{i11}{i12}{i15},i13,i14,sample_factor,dim_subkernel_layer(i11,1));
temp+=temp0;
end
nbrick{i11+1}{i12}(i13,i14)=sigmoid(temp);
end
end
end
end
final=cell2mat(cell2mat(nbrick(num_kernel_layer+1)));

[dummy, p(i10,1)] = max(final);


end

% =========================================================================


end