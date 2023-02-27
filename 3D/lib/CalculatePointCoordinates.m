function pts = CalculatePointCoordinates(image, control_pts)
% This function caculates 8 non-control points, which can be used to
%   slice the given image later
% input: image: rgb or gray image
% output: 8 caculated non-control points
%--------------------------------------------------------------------------
% ncpt_1-----------------------------------------------------------ncpt_2
%     -------------------------------------------------------------
%     ncpt_5-------------------------------------------------ncpt_6  
%     -------------------------------------------------------------
%     -------------------------------------------------------------
%     -------------------------------------------------------------
%     ---------cpt_1-------------------------cpt_2-----------------
%     -------------------------------------------------------------
%     -------------------------------------------------------------
%     --------------------------vp---------------------------------
%     -------------------------------------------------------------
%     -------------------------------------------------------------
%     -------------------------------------------------------------
%     -------------------------------------------------------------
%     ----------cpt_4-------------------------cpt_3----------------
%     -------------------------------------------------------------
%     -------------------------------------------------------------
%     ncpt_8-------------------------------------------------ncpt_7
%     -------------------------------------------------------------
% ncpt_4-----------------------------------------------------------ncpt_3

    [max_row, max_colomn, ~] = size(image);
    % cpt_1: control point on top left
    % cpt_2: control point on top right
    % cpt_3: control point on bottom right
    % cpt_4: control point on bottom left
    % vp: vanishing point in the middle
    cpt_1 = control_pts(:, 1);
    cpt_2 = control_pts(:, 2);
    cpt_3 = control_pts(:, 3);
    cpt_4 = control_pts(:, 4);
    vp = control_pts(:, 5);
    
    % ncpt_1: non-control point on top left, whose y_coordinate is zero
    % ncpt_2: non-control point on top right, whose y_coordinate is zero
    % ncpt_3: non-control point on bottom right, whose y_coordinate is max
    % ncpt_4: non-control point on bottom left, whose y_coordinate is max
    ncpt_1 = [0; 0]; ncpt_1(1) = (ncpt_1(2) - vp(2)) * (cpt_1(1) - vp(1)) / (cpt_1(2) - vp(2)) + vp(1);
    ncpt_2 = [0; 0]; ncpt_2(1) = (ncpt_2(2) - vp(2)) * (cpt_2(1) - vp(1)) / (cpt_2(2) - vp(2)) + vp(1);
    ncpt_3 = [0; max_row]; ncpt_3(1) = (ncpt_3(2) - vp(2)) * (cpt_3(1) - vp(1)) / (cpt_3(2) - vp(2)) + vp(1);
    ncpt_4 = [0; max_row]; ncpt_4(1) = (ncpt_4(2) - vp(2)) * (cpt_4(1) - vp(1)) / (cpt_4(2) - vp(2)) + vp(1);
    
    % ncpt_5: non-control point on top left, whose x_coordinate is zero
    % ncpt_6: non-control point on top right, whose x_coordinate is max
    % ncpt_7: non-control point on bottom right, whose x_coordinate is max
    % ncpt_8: non-control point on bottom left, whose x_coordinate is zero
    ncpt_5 = [0; 0]; ncpt_5(2) = (ncpt_5(1) - vp(1)) * (cpt_1(2) - vp(2)) / (cpt_1(1) - vp(1)) + vp(2);
    ncpt_6 = [max_colomn; 0]; ncpt_6(2) = (ncpt_6(1) - vp(1)) * (cpt_2(2) - vp(2)) / (cpt_2(1) - vp(1)) + vp(2);
    ncpt_7 = [max_colomn; 0]; ncpt_7(2) = (ncpt_7(1) - vp(1)) * (cpt_3(2) - vp(2)) / (cpt_3(1) - vp(1)) + vp(2);
    ncpt_8 = [0; 0]; ncpt_8(2) = (ncpt_8(1) - vp(1)) * (cpt_4(2) - vp(2)) / (cpt_4(1) - vp(1)) + vp(2);
    
    pts = [ncpt_1, ncpt_2, ncpt_3, ncpt_4, ncpt_5, ncpt_6, ncpt_7, ncpt_8];
      
end