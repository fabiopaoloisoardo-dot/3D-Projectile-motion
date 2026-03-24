% === SIMULATORE TRAIETTORIA 3D ===
disp('=== SIMULATORE TRAIETTORIA 3D ===');
v0        = input('Velocità iniziale [m/s]: ');
theta     = input('Angolo verticale [°]: ');
phi       = input('Direzione orizzontale [°]: ');
massa     = input('Massa [kg]: ');
volume    = input('Volume [m³]: ');
disp('Forme: sfera | cubo | cilindro | cilindro_sbieco | cono | cono_base | piramide | piramide_base');
forma     = input('Forma: ', 's');
v_vento   = input('Velocità vento [m/s]: ');
dir_vento = input('Direzione vento (perp/par): ', 's');

switch forma
    case 'sfera',          Cd = 0.47; kA = pi*(3/(4*pi))^(2/3);
    case 'cubo',           Cd = 1.05; kA = 1.0;
    case 'cilindro',       Cd = 0.82; kA = pi*(1/(2*pi))^(2/3);
    case 'cilindro_sbieco',Cd = 1.17; kA = 4*(1/(2*pi))^(2/3);
    case 'cono',           Cd = 0.50; kA = pi*(3/pi)^(2/3);
    case 'cono_base',      Cd = 1.15; kA = pi*(3/pi)^(2/3);
    case 'piramide',       Cd = 0.60; kA = 3^(2/3);
    case 'piramide_base',  Cd = 1.30; kA = 3^(2/3);
    otherwise, error('Forma non valida.');
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
    rho  = 1.225 * exp(-max(pos(3),0) / 8500);
    vrel = vel - vento;
    acc  = (-0.5*rho*Cd*A*norm(vrel)/massa) * vrel + [0;0;-9.81];
    vel  = vel + acc*dt;
    pos  = pos + vel*dt;
    if pos(3) > hmax, hmax = pos(3); end
    if pos(3) < 0, break; end
end

gittata = hypot(pos(1), pos(2));
gamma   = rad2deg(atan2(abs(pos(2)), abs(pos(1))));
fprintf('\nQuota massima  : %.2f m\n', hmax);
fprintf('Gittata (XY)   : %.2f m\n', gittata);
fprintf('Deriva laterale: %.2f m\n', pos(2));
fprintf('Angolo γ       : %.2f°\n', gamma);
