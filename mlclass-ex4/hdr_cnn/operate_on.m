function [temp0] = operate_on(nbrick_,kernel_,bias_,row,col,sample_factor,dim)
temp0=0;
for i19=sample_factor*(row-1)+1:sample_factor*(row-1)+dim,
for i20=sample_factor*(col-1)+1:sample_factor*(col-1)+dim,
temp0+=kernel_(i19-sample_factor*(row-1),i20-sample_factor*(col-1))*nbrick_(i19 ,i20 );  
end
end
temp0+=bias_(1,1);
end


