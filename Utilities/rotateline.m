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
figure
   % Plot of the original line
   plot(x,y,'r','linewidth',2)
   grid on
   hold on
theta = theta * pi / 180;
T = [cos(theta) -sin(theta)
     sin(theta)  cos(theta)
    ];

x1_y1 = T * [x - x_offset; y - y_offset];
x1 = x1_y1(1,:);
y1 = x1_y1(2,:);
plot(x1+x_offset,y1+y_offset,'b','linewidth',2);
end