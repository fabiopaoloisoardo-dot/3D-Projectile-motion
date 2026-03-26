% SIMULATORE TRAIETTORIA 3D 
disp('3D TRAJECTORY SIMULATOR');
v0 = input('Initial speed [m/s]: ');
theta = input('Vertical angle [°]: ');
phi = input('Horizontal direction [°]: ');
massa = input('Mass [kg]: ');
volume = input('Volume [m³]: ');
disp('Shapes: sphere | cube | cylinder | oblique_cylinder | cone | cone_base | pyramid | pyramid_base');
forma = input('Shape: ', 's');
v_vento = input('Wind speed [m/s]: ');
dir_vento = input('Wind direction (perp/par): ', 's');

switch forma
    case 'sphere',          
        Cd = 0.47; kA = pi*(3/(4*pi))^(2/3);
    case 'cube',           
        Cd = 1.05; kA = 1.0;
    case 'cylinder',       
        Cd = 0.82; kA = pi*(1/(2*pi))^(2/3);
    case 'oblique_cylinder',
        Cd = 1.17; kA = 4*(1/(2*pi))^(2/3);
    case 'cone',           
        Cd = 0.50; kA = pi*(3/pi)^(2/3);
    case 'cone_base',      
        Cd = 1.15; kA = pi*(3/pi)^(2/3);
    case 'pyramid',       
        Cd = 0.60; kA = 3^(2/3);
    case 'pyramid_base',  
        Cd = 1.30; kA = 3^(2/3);
    otherwise, error('Shape not valid.');
end
A = kA * volume^(2/3);

th = deg2rad(theta); ph = deg2rad(phi);
vel = [v0*cos(th)*cos(ph); v0*cos(th)*sin(ph); v0*sin(th)];
if strcmp(dir_vento,'perp')
    wdir = [-sin(ph); cos(ph); 0];
else
    wdir = [ cos(ph); sin(ph); 0];
end
vento = v_vento * wdir;
pos = [0;0;0]; dt = 0.005; hmax = 0;

while true
    rho = 1.225 * exp(-max(pos(3),0) / 8500);
    vrel = vel - vento;
    acc = (-0.5*rho*Cd*A*norm(vrel)/massa) * vrel + [0;0;-9.81];
    vel = vel + acc*dt;
    pos = pos + vel*dt;
    if pos(3) > hmax, hmax = pos(3); end
    if pos(3) < 0, break; end
end

gittata = hypot(pos(1), pos(2));
gamma   = rad2deg(atan2(abs(pos(2)), abs(pos(1))));
fprintf('\nQuota massima: %.2f m\n', hmax);
fprintf('Gittata (XY): %.2f m\n', gittata);
fprintf('Deriva laterale: %.2f m\n', pos(2));
fprintf('Angolo γ: %.2f°\n', gamma);