function MooringLinePosition(Ptfm_lambda,Line_lambda, theta)

% 
% 
%                               / 
%                              /  
%                             /________   
%                            1       y
%                          * *       ^
%                        *   *       |
% --> WIND & WAVE      2     *       0--> X
%                        *   *
%                          * *
%                            3


    load('OC4Mooring.mat');
    Nlines = 6;
    % define line type
    linetype(1) = OC4Mooring.LineType(1) * Line_lambda;
    linetype(2) = OC4Mooring.LineType(2) * Line_lambda^2;
    linetype(3) = OC4Mooring.LineType(3) * Line_lambda^2;
    
    % calculate vessel node position:
    vessel      = OC4Mooring.Node{2} * Ptfm_lambda;
 
    for i = 1 : 2
        [x_new, y_new] = rotateline([0 0],vessel(i, 1 : 2), 120);
        vessel(i + 1,1) = x_new(2);
        vessel(i + 1,2) = y_new(2);
        vessel(i + 1,3) = vessel(i, 3);
    end
    
    % calculate fix point/ anchor node position
    % step 1: calculate three lines layout as OC4
    % step 2: rotate each line by theta / 2 to get adjacent lines
    fix         = OC4Mooring.Node{1};
    for i = 1 : 2
        [x_new, y_new]  = rotateline(vessel(i, 1: 2),fix(i, 1 : 2), 120, [0 0]);
        fix(i + 1, 1)   = x_new(2);
        fix(i + 1, 2)   = y_new(2);
        fix(i + 1, 3)   = fix(i, 3);        
    end
    new_fix = zeros(Nlines, 3);
%     vessel
%     fix
    for i = 1:3 
        [x_new, y_new]  = rotateline(vessel(i, 1: 2),fix(i, 1 : 2), -theta /2);
        new_fix(2 *i - 1, 1) = x_new(2);
        new_fix(2 *i - 1, 2) = y_new(2);
        new_fix(2 *i - 1, 3) = fix(i, 3);
        [x_new, y_new]  = rotateline(vessel(i, 1: 2),fix(i, 1 : 2),  theta /2);
        new_fix(2 *i, 1) = x_new(2);
        new_fix(2 *i, 2) = y_new(2);
        new_fix(2 *i, 3) = fix(i, 3);         
    end
    
    %% print 
    fprintf('LineType parameters for new model with scaling lambda = %4.2f: \n\n', Line_lambda)
    fprintf('Diam(m)     MassDenInAir(kg/m)    EA(KN) \n')
    fprintf('%6.4f       %6.1f              %10.4G \n\n', linetype(1), linetype(2), linetype(3))
    
    disp('************Vessel Node positions*************')
    fprintf('Node  #     X      Y       Z\n')
    for i = 1 : 3
        fprintf('Node %2d %6.2f %6.2f %6.2f \n', i, vessel(i, 1), vessel(i, 2), vessel(i, 3));
    end
    disp('************Fix Node positions*************')
    fprintf('Node  #     X      Y       Z\n')
    for i = 1 : 6
        fprintf('Node %2d %6.2f %6.2f %6.2f \n', i, new_fix(i, 1), new_fix(i, 2), new_fix(i, 3));
    end
    
    
    


function[x1, y1] = rotateline(A, B, theta, varargin)

% only want 1 optional inputs at most
% numvarargs = length(varargin);
if length(varargin) > 1
    error('myfuns:somefun2Alt:TooManyInputs', ...
        'requires only one optional inputs');
end

% set defaults for optional inputs
rotatepoint = {A};

% now put these defaults into the valuesToUse cell array, 
% and overwrite the ones specified in varargin.
rotatepoint(1 : length(varargin)) = varargin;

% Place optional args in memorable variable names
rotatepoint = rotatepoint{1};

x=[A(1) B(1)];
y=[A(2) B(2)];
% Definition of the offset
x_offset= rotatepoint(1);
y_offset= rotatepoint(2);
% figure
%    % Plot of the original line
%    plot(x,y,'r','linewidth',2)
%    grid on
%    hold on
theta = theta * pi / 180;
T = [cos(theta) -sin(theta)
     sin(theta)  cos(theta)
    ];

x1_y1 = T * [x - x_offset; y - y_offset];
x1 = x1_y1(1,:) + x_offset;
y1 = x1_y1(2,:) + y_offset;
% plot(x1+x_offset,y1+y_offset,'b','linewidth',2);

        
    
    
