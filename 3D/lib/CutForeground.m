function [img_background, img_target, point2,check] = CutForeground(I)
check = 0;
[height_img, width_img, ~] = size(I);
% Get the point where the mouse was pressed and the point where the mouse was released.
waitforbuttonpress;
point1 = get(gca,'CurrentPoint');
rbbox;
%draw a block diagram
point2 = get(gca,'CurrentPoint');
point1 = point1(1, 1:2);
point2 = point2(1, 1:2);

%The size of the foreground cannot exceed the size of the entire image.
if point1(1)<0||point1(1)>width_img||point1(2)<0||point1(2)>height_img ...
        ||point2(2)<0||point2(2)>height_img||point2(1)<0||point2(1)>width_img
     img_target = [];
     img_background = [];
     point2 = 0;
     check = 1;
else
    p1 = min(floor(point1),floor(point2));
    offset = abs(floor(point1)-floor(point2));
    x = [p1(1) p1(1)+offset(1) p1(1)+offset(1) p1(1) p1(1)];
    y = [p1(2) p1(2) p1(2)+offset(2) p1(2)+offset(2) p1(2)];
    hold on
    plot(x,y,'r');
    %Cut out the foreground from the original image
    img_target = imcrop(I,[p1(1) p1(2) offset(1) offset(2)]);
    %After deducting the foreground, set the foreground position to black in the original image.

% m=size(img_target,1);
% n=size(img_target,2);
% Im=rgb2gray(img_target);
% Zsoble=edge(Im,'Sobel');
% mask  = boundarymask(Zsoble,8);
% 
% figure(1)
% imshow(mask)



    R = I(:,:,1);
    G = I(:,:,2);
    B = I(:,:,3);
    
    for j = 0:offset(1)
        for i = 0:offset(2)
            R(p1(2)+i,p1(1)+j) = 0;
            G(p1(2)+i,p1(1)+j) = 0;
            B(p1(2)+i,p1(1)+j) = 0;
        end
    end
    img_background(:,:,1) = R(:,:);
    img_background(:,:,2) = G(:,:);
    img_background(:,:,3) = B(:,:);
    
    %Fill the part of the original image that has been set to black with the surrounding color through Gaussian filtering.

    x_min = floor(point1(1)); x_max = floor(point2(1));
    y_min = floor(point1(2)); y_max = floor(point2(2));
    
    width = floor(x_max - x_min);
    height = floor(y_max - y_min);
    
    if x_min - width >= 0
        img_background(y_min:y_max, x_min:x_max, :) = ...
            img_background(y_min:y_max, x_min-width:x_min, :);
    elseif x_max + width <= size(img_background, 2)
        img_background(y_min:y_max, x_min:x_max, :) = ...
            img_background(y_min:y_max, x_max:x_max+width, :);
    elseif y_min - height >= 0
        img_background(y_min:y_max, x_min:x_max, :) = ...
            img_background(y_min-height:y_min, x_min:x_max, :);
    elseif y_max + height <= size(img_background, 1)
        img_background(y_min:y_max, x_min:x_max, :) = ...
            img_background(y_max:y_max+height, x_min:x_max, :);
    end
    img_background(y_min:y_max, x_min:x_max, :) = ...
    imgaussfilt(img_background(y_min:y_max, x_min:x_max, :), 2);
end
end
