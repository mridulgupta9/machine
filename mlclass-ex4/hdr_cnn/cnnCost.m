function [ J grad_kernel grad_bias ] = cnnCost(kernel,bias, nbrick, num_training_ex, dim_feature_maps_in_layer, num_kernel_layer, total_num_labels,num_subkernels_per_kernel_in_layer,kernel_count_in_layer, x_modified, y_modified, lambda, sample_factor, dim_subkernel_layer, total_num_layer, num_feature_maps_in_layer)

J = 0;
temp = 0;
delta_brick = nbrick;
grad_kernel = kernel;
grad_bias = bias;



sum_weights=sum_op_weights(kernel,kernel_count_in_layer,num_kernel_layer,num_subkernels_per_kernel_in_layer);


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
J+= (-1/num_training_ex)*((y_modified(:,i10)')*(log(final)) +((1-y_modified(:,i10))'*log(1-final))) + (lambda/(2*num_training_ex))*sum_weights;

for t1=1:total_num_labels,
delta_brick{total_num_layer}{t1,1}(1,1) = final(t1,1) - y_modified(t1,i10);
end

for t2=total_num_layer-1:2,
for t3=1:num_feature_maps_in_layer(t2+1,1),
for t4=1:dim_feature_maps_in_layer(t2+1,1),
for t5=1:dim_feature_maps_in_layer(t2+1,1),
for t6=1:num_subkernels_per_kernel_in_layer(t2,1),
for t7=1:dim_subkernel_layer(t2,1),
for t8=1:dim_subkernel_layer(t2,1),
delta_brick{t2,1}{t6,1}(sample_factor*(t4-1)+t7,sample_factor*(t5-1)+t8) = delta_brick{t2+1,1}{t3,1}(t4,t5)*kernel{t2,1}{t3,1}{t6,1}(t7,t8);
end
end
end
end
end
end
end

for t9=num_kernel_layer:1,
for t10=1:num_feature_maps_in_layer(t9+1,1),
for t11=1:num_feature_maps_in_layer(t9,1),
for t12=1:dim_subkernel_layer(t9,1),
for t13=1:dim_subkernel_layer(t9,1),
grad_kernel{t9,1}{t10,1}{t11,1}(t12,t13)+=(lambda/num_training_ex)*kernel{t9,1}{t10,1}{t11,1}(t12,t13);
for t14=1:dim_feature_maps_in_layer(t9+1,1),
for t15=1:dim_feature_maps_in_layer(t9+1,1),
grad_kernel{t9,1}{t10,1}{t11,1}(t12,t13)+=(1/(num_training_ex*dim_feature_maps_in_layer(t9+1,1)*dim_feature_maps_in_layer(t9+1,1)))*delta_brick{t9+1,1}{t10,1}(t14,t15)*nbrick{t9,1}{t11,1}((t14-1)*sample_factor+t12,(t15-1)*sample_factor+t13);

if t12==dim_subkernel_layer(t9,1)&&t13==dim_subkernel_layer(t9,1),
grad_bias{t9,1}{t10,1}{t11,1}(1,1)+=(1/(num_training_ex*dim_feature_maps_in_layer(t9+1,1)*dim_feature_maps_in_layer(t9+1,1)))*delta_brick{t9+1,1}{t10,1}(t14,t15);
end

end
end
end
end
end
end
end


end




end
