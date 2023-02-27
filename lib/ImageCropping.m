function img_cropped = ImageCropping(image, polygon)
    row1 = polygon(1, :);
    row2 = polygon(2, :);
    BW=roipoly(image, row1, row2);
    g=double(image) .* double(BW);
    img_cropped = uint8(g);
end