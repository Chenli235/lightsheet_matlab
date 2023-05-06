
xo = 0;
yo = 0;
xsigma = 0.05;
ysigma = 0.1;
particle_amount = 1000000;
xpoints = Gauss(xo,xsigma,particle_amount);
ypoints = Gauss(yo,ysigma,particle_amount);
%needs column vectors
coordinates_x_y = [xpoints ypoints];