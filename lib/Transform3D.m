function Transform3D(x,y,img_target,img_front, img_left, img_right, img_top, img_bottom)
hold off
f = figure('Color','w');
    [height, width, ~] = size(img_front);
    [height2, width2, ~] = size(img_bottom);
    [height3, width3, ~] = size(img_left);
    [height_t, width_t, ~] = size(img_target);
    pos = [0,0,0];
    angle = [10,20];
    set (gcf,'WindowKeyPressFcn',@KeyDown);
    set (gcf, 'WindowScrollWheelFcn', @ScrollWheel);
    Axes =axes (gcf,'Position',[0.1, 0.1,0.8,0.8]);
    range = 1000;
    
    target_x = x-width2/2-0.5*width_t;      %Determine the x-coordinate of the target 
    target_y = y;                           %Determine the y-coordinate of the target
   
    %Target put into 3D scene
    [X, Z] = meshgrid(-(width_t-1)/2 +target_x: (width_t-1)/2+target_x, (height_t-1)-(height3-1)/2: -1 : -(height3-1)/2);
    Y = ones(height_t,width_t)* target_y;
    warp(X, Y, Z, img_target); hold on          
    %The right side put into the 3D scene
    [Y, Z] = meshgrid(0 : width3-1, (height3-1)/2 : -1 : -(height3-1)/2);
    X = ones(height3, width3) * width / 2;
    f1 = warp(X, Y, Z, img_right); hold on
    %The left side put into the 3D scene
    [Y, Z] = meshgrid(width3-1 : -1 : 0, (height3-1)/2  : -1 :-(height3-1)/2 );
    X = - ones(height3, width3) * width / 2;
    f2 = warp(X, Y, Z, img_left); hold on
    %The bottom side put into the 3D scene
    [X, Y] = meshgrid(-(width2-1)/2 : (width2-1)/2, 0 : (height2-1));
    Z = -ones(height2, width2) * height / 2;
    f3 = warp(X, Y, Z, img_bottom); hold on
    %The top side put into the 3D scene
    [X, Y] = meshgrid(-(width2-1)/2 : (width2-1)/2, 0: (height2-1) );
    Z = ones(height2, width2)* height/2;
    f4 = warp(X, Y, Z, img_top); hold on
    %The front side put into the 3D scene
    [X, Z] = meshgrid(-(width-1)/2 : (width-1)/2,  (height-1)/2 : -1 : -(height-1)/2);
    Y = zeros(height, width);
    f5 = warp(X, Y, Z, img_front); hold off
    axis(Axes,'equal')
    grid(Axes,'on')
    xlabel('x');
    ylabel('y');
    zlabel('z');
    update(Axes,pos)
    ax = gca;              
    ax.Clipping = 'off'; 
%     xlim([-inf height])
%     ylim([-inf +inf])
%     zlim([-inf height])

    axis off
    cameratoolbar(f);

function KeyDown(~, event)
    dD= 5;
    dA= 10;
        switch event.Key
            case 'e'
            pos(3)= pos(3)+dD;
            case 'd'
            pos(3)= pos(3)-dD;
            case 'w'
            pos(2)= pos(2)+dD;
            case 's'
            pos(2) = pos(2)-dD;
            case 'q'
            pos(1) = pos(1)+dD;
            case 'a'
            pos(1) = pos(1)-dD;
            case 'k'
                if f1.FaceAlpha==0
            f1.FaceAlpha=1;
                else
            f1.FaceAlpha=0;
                end
            case 'o'
                if f2.FaceAlpha==0
            f2.FaceAlpha=1;
                else
            f2.FaceAlpha=0;
                end
            case 'l'
                if f3.FaceAlpha==0
            f3.FaceAlpha=1;
                else
            f3.FaceAlpha=0;
                end            
            case 'p'
                if f4.FaceAlpha==0
            f4.FaceAlpha=1;
                else
            f4.FaceAlpha=0;
                end
            case 'downarrow'
            angle(2) = angle(2)+dA;
            case 'uparrow'
            angle(2) = angle(2)-dA;
            case 'leftarrow'
            angle(1) = angle(1)+dA;
            case 'rightarrow'
            angle(1) = angle(1)-dA;
        end
    update()
    end
    %% mouse
    function ScrollWheel(~, event)
        value = event.VerticalScrollCount*10; %key
        range = max(1,range+value);
        update()
    end
    %%update
    function update(~,~)
        axis(Axes,[-range+pos(1) , range+pos(1), -range+pos(2) , range+pos(2), -range+pos(3) , range+pos(3)])
        view(Axes, angle)
        drawnow
    end
end

