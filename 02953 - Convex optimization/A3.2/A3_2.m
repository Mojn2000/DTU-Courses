clear all

%% a
cvx_begin
    variable x(2)
    minimize( x(1)+x(2) )
    subject to
        2*x(1) +   x(2) >= 1
          x(1) + 3*x(2) >= 1
          x >= 0
cvx_end

x

%% b
cvx_begin
    variable x(2)
    minimize( -x(1)-x(2) )
    subject to
        2*x(1) +   x(2) >= 1
          x(1) + 3*x(2) >= 1
          x >= 0
cvx_end

x

%% c
cvx_begin
    variable x(2)
    minimize( x(1) )
    subject to
        2*x(1) +   x(2) >= 1
          x(1) + 3*x(2) >= 1
          x >= 0
cvx_end

x

%% d
cvx_begin
    variable x(2)
    minimize( max(x(1),x(2)) )
    subject to
        2*x(1) +   x(2) >= 1
          x(1) + 3*x(2) >= 1
          x >= 0
cvx_end

x

%% e
cvx_begin
    variable x(2)
    minimize( x(1)^2+9*x(2)^2 )
    subject to
        2*x(1) +   x(2) >= 1
          x(1) + 3*x(2) >= 1
          x >= 0
cvx_end

x
