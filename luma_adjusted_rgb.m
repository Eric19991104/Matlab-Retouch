function output_rgb = luma_adjusted_rgb( rgb, gamma )
    [Luma,U,V] = rgb2yuv(rgb(:,:,1), rgb(:,:,2), rgb(:,:,3));
    mapping = gamma_serial(gamma);
    [rows columns] = size(Luma);    
    adjusted_luma = Luma;
    for i = 1:1:rows
       for j = 1:1:columns
           adjusted_luma(i,j) = mapping(Luma(i,j)+1);
       end
    end
    output_rgb = yuv2rgb(adjusted_luma, U, V);    
end