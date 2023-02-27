function [x,y,horizontal_length,vertical_length] = ForegroundCalculation(image,control_pts,non_control_pts,point2,geo)
depth = geo(1);
width = geo(3);
y = floor(depth/((size(image,1) - point2(2)) / (point2(2) - control_pts(2, 3))+1));
x_left = control_pts(1, 4) + (point2(2) - control_pts(2, 4)) * (non_control_pts(1, 4) - control_pts(1, 4))...
    / (non_control_pts(2, 4) - control_pts(2, 4));
x_right = control_pts(1, 3) + (point2(2) - control_pts(2, 3)) * (non_control_pts(1, 3) - control_pts(1, 3))...
    / (non_control_pts(2, 3) - control_pts(2, 3));
x = floor(width/((x_right-point2(1))/(point2(1)-x_left)+1));
horizontal_length = x_right - x_left;
vertical_length = norm(control_pts(:,2) - control_pts(:,3)) + ((norm(non_control_pts(:,2) - non_control_pts(:,3))...
    - norm(control_pts(:,2) - control_pts(:,3))))*(point2(2) - control_pts(2, 3))/(non_control_pts(2, 3)-control_pts(2, 3));

end