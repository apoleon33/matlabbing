% Question 5
myFile = load('dataCapt.mat').dataCapt;
Tcapt  = myFile(:,1);  % Base de temps des mesures capteurs (s)
Vt     = myFile(:, 2); % Vitesse transversale du véhicule (m/s)
Vl     = myFile(:, 3); % Vitesse longitudinale du véhicule (m/s)
Psip   = myFile(:, 4); % Vitesse de lacet du véhicule (rad/s)

% Question 6
% https://stackoverflow.com/questions/54002845/octave-add-secondary-y-axis-to-existing-plot
newFig = figure;
plot(Tcapt, Vl);
hold on;
plot(unique(Tgps)(1:end-1), vitesses);

title('Comparaison de la vitesse via GPS vs vitesse via DR');
legend('Vitesse via DR', 'Vitesse via GPS');

% Question 7
% tracé du signal biaisé
fig7 = figure;
plot(Tcapt, Psip);

% On a une frequence de 50Hz, donc 10s -> les 500 premiers echantillons
moyenne = mean(Psip(1:500)); % 0.0258117906935513
UnbiasedPsip = Psip - moyenne;

hold on;
plot(Tcapt, UnbiasedPsip);

title('Évolution du Psip biaisé et non baisé');
legend('Signal biaisé', 'Signal compensé');

% Question 8
% cap biaise
Tech = 0.02;
psi0 = -2.18;
BiasedCap = zeros(length(Tcapt), 1);
UnbiasedCap = zeros(length(Tcapt), 1);

BiasedCap(1) = psi0;
UnbiasedCap(1) = psi0;

for n = 1:length(Tcapt)-1
    BiasedCap(n+1)      = BiasedCap(n)      + Tech * Psip(n);
    UnbiasedCap(n+1) = UnbiasedCap(n) + Tech * UnbiasedPsip(n);
end

fig8 = figure;
plot(Tcapt, BiasedCap);
hold on;
plot(Tcapt, UnbiasedCap); % accumulation d'erreur

title('Évolution du cap');
legend('Cap biaisé', 'cap non biaisé');

% Question 9
x0 = 0;
y0 = 0;

bX = zeros(length(Tcapt), 1); % x biaise
bY = zeros(length(Tcapt), 1); % y biaiser

nX = zeros(length(Tcapt), 1); % x non biaise
nY = zeros(length(Tcapt), 1); % y non biaiser

for n = 1:length(Tcapt)-1
  bX(n+1) = bX(n) + Tech*(Vl(n)*cos(BiasedCap(n)) - Vt(n)*sin(BiasedCap(n)));
  bY(n+1) = bY(n) + Tech*(Vl(n)*sin(BiasedCap(n)) + Vt(n)*cos(BiasedCap(n)));

  nX(n+1) = nX(n) + Tech*(Vl(n)*cos(UnbiasedCap(n)) - Vt(n)*sin(UnbiasedCap(n)));
  nY(n+1) = nY(n) + Tech*(Vl(n)*sin(UnbiasedCap(n)) + Vt(n)*cos(UnbiasedCap(n)));
end

fig8 = figure;
plot(bX, bY, 'b');
hold on;
plot(nX, nY, 'r');

title('Évolution des trajectoires biaisée et non-biaisée');
legend('trajectoire biaisée', 'trajectoire non-biaisée');

% Question 10

fig10 = figure;
grid on;
hold on                 %  Maintenir active la figure cr??e pour ajout de trac?s
plot(x1,y1,'m.')        % Tracé du bord droit du circuit non interpol? en jaune
plot(x2,y2,'c.')        % Tracé du bord gauche du circuit non interpol? en cyan
plot(Xgps, Ygps, 'r.');
plot(nX, nY, 'b.');
axis equal;             % Repère orthonormé
xlabel('x (m)')         % Abscisses en metre
ylabel('y (m)')         % Ordonnées en metre

title('Évolution des trajectoires sur le circuit') % Titre
legend('bord droit','bord gauche', 'Trajectoire GPS', 'Trajectoire DR corrigée') % Légende

% Question 11
ecartX = Xgps - nX;
ecartY = Ygps - nY;

fig11 = figure;
plot(ecartX);
hold on;
plot(ecartY);
ecartMoyen = [mean(ecartX) mean(ecartY)]
title('Évolution des ecarts GPS-DR');
legend('écart en X', 'Écart en Y');
