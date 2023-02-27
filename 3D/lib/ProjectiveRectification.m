function [img_front_rectified, img_left_rectified, img_right_rectified,...
    img_top_rectified, img_bottom_rectified,geo] = ProjectiveRectification( ...
    control_pts, non_control_pts, img_front, img_left, img_right, img_top, img_bottom,f)
% calculate 2d-projective transformation
    
    m1 = (control_pts(2,4)+control_pts(2,3))/2-control_pts(2,5);
    m2 = control_pts(2,5)-(control_pts(2,1)+control_pts(2,2))/2;
    vh = (non_control_pts(2,4)+ non_control_pts(2,3))/2 -control_pts(2,5);
    %calculate the depth, height, width of the 3D image
    depth = floor(m1*f/(vh-m1));
    height = floor(vh+m2*(f+depth)/f);
    width = floor((control_pts(1,3)-control_pts(1,4))*(f+depth)/f);
    geo = [depth, height, width];
    
    
    quad_front = [control_pts(:, 1)'; control_pts(:, 2)'; ...
              control_pts(:, 3)'; control_pts(:, 4)'];
    quad_left = [non_control_pts(:, 5)'; control_pts(:, 1)'; ...
             control_pts(:, 4)'; non_control_pts(:, 8)'];
    quad_right = [control_pts(:, 2)'; non_control_pts(:, 6)'; ...
             non_control_pts(:, 7)'; control_pts(:, 3)'];
    quad_top = [control_pts(:, 1)'; control_pts(:, 2)';...
             non_control_pts(:, 2)'; non_control_pts(:, 1)'];
    quad_bottom = [control_pts(:, 4)'; control_pts(:, 3)'; ...
               non_control_pts(:, 7)'; non_control_pts(:, 8)'];

    fixed_points_horizontal = [1 1; 1 depth; height, depth; height, 1];
    fixed_points_vertical = [1 1; 1 width; depth, width; depth, 1];
    fixed_points_front = [1 1; 1 width; height, width; height, 1];


    trf_front = fitgeotrans(quad_front, fixed_points_front, 'projective');
    trf_left = fitgeotrans(quad_left, fixed_points_horizontal, 'projective');
    trf_right = fitgeotrans(quad_right, fixed_points_horizontal, 'projective');
    trf_top = fitgeotrans(quad_top, fixed_points_vertical, 'projective');
    trf_bottom = fitgeotrans(quad_bottom, fixed_points_vertical, 'projective');
    
    img_front_rectified = fliplr(imrotate(imwarp(img_front, trf_front, 'OutputView', imref2d([width,height])), -90));
    img_left_rectified = fliplr(imrotate(imwarp(img_left, trf_left, 'OutputView', imref2d([depth,height])), -90));
    img_right_rectified = fliplr(imrotate(imwarp(img_right, trf_right, 'OutputView', imref2d([depth, height])), -90));
    img_top_rectified = fliplr(imrotate(imwarp(img_top, trf_top, 'OutputView', imref2d([width, depth])), -90));
    img_bottom_rectified = fliplr(imrotate(imwarp(img_bottom, trf_bottom, 'OutputView', imref2d([width,depth])), -90));

end