% Question 12
dataGps = load('dataGps.mat').dataGps;
dataCapt = load('dataCapt.mat').dataCapt;

[Xest, Yest]=fusionKF(dataGps, dataCapt);

fig12 = figure;
grid on;
hold on                 %  Maintenir active la figure cr??e pour ajout de trac?s
plot(x1,y1,'m.')        % Tracé du bord droit du circuit non interpol? en jaune
plot(x2,y2,'c.')        % Tracé du bord gauche du circuit non interpol? en cyan
plot(Xgps, Ygps, 'r');
plot(nX, nY, 'b');
plot(Xest, Yest, 'g.');
axis equal;             % Repère orthonormé
xlabel('x (m)')         % Abscisses en metre
ylabel('y (m)')         % Ordonnées en metre

title('Évolution des trajectoires sur le circuit') % Titre
legend('bord droit','bord gauche', 'Trajectoire GPS', 'Trajectoire DR corrigée', 'Trajectoire fusionnée') % Légende

% Question 13
Xest = reshape(Xest, 2386, 1); % on passe de 1x2386 à 2386x1
Yest = reshape(Yest, 2386, 1);
ecart_x_fusion = Xgps - Xest;
ecart_y_fusion = Ygps - Yest;

fig13 = figure;
plot(ecart_x_fusion);
hold on;
plot(ecart_y_fusion);

title('Évolution des écarts GPS-fusion');
legend('Écart en X', 'Écart en Y');

% Question 14
function [Mx, My] = new_fusion(gps, capt)
  % 1 chance sur deux ça overwrite les variables originelles
  Tgps   = gps(:, 1);
  Xgps   = gps(:, 2);
  Ygps   = gps(:, 3);
  Qgps   = gps(:, 4);
  DataOk = gps(:, 5);

  Tcapt  = capt(:,1);  % Base de temps des mesures capteurs (s)
  Vt     = capt(:, 2); % Vitesse transversale du véhicule (m/s)
  Vl     = capt(:, 3); % Vitesse longitudinale du véhicule (m/s)
  Psip   = capt(:, 4); % Vitesse de lacet du véhicule (rad/s)

  % On a une frequence de 50Hz, donc 10s -> les 500 premiers echantillons
  moyenne = mean(Psip(1:500)); % 0.0258117906935513
  UnbiasedPsip = Psip - moyenne;

  % on trouve le Xcapt et Ycapt
  x0 = 0;
  y0 = 0;

  Tech = 0.02;
  psi0 = -2.18;
  UnbiasedCap = zeros(length(Tcapt), 1);
  UnbiasedCap(1) = psi0;
  nX = zeros(length(Tcapt), 1); % x non biaise
  nY = zeros(length(Tcapt), 1); % y non biaiser

  for n = 1:length(Tcapt)-1
    UnbiasedCap(n+1) = UnbiasedCap(n) + Tech * UnbiasedPsip(n);
    nX(n+1) = nX(n) + Tech*(Vl(n)*cos(UnbiasedCap(n)) - Vt(n)*sin(UnbiasedCap(n)));
    nY(n+1) = nY(n) + Tech*(Vl(n)*sin(UnbiasedCap(n)) + Vt(n)*cos(UnbiasedCap(n)));
  end

  Mx = Xgps;
  Mx(Qgps < 10) = nX;

  My = Ygps;
  My(Qgps < 10) = nY;
end

[new_Xest, new_Yest] = new_fusion(dataGps, dataCapt);

fig14 = figure;
plot(new_Xest, new_Yest);
