clearvars;
myFile = load('dataGps.mat').dataGps;

grid_dimensions = [2 3]; % dimensions de la grille des plots

% Exercice 1
% Question 1
Tgps = myFile(:, 1);
Xgps = myFile(:, 2);
Ygps = myFile(:, 3);
Qgps = myFile(:, 4);
DataOk = myFile(:, 5);


clearedTgps = diff(Tgps); % Tgps sans les doublons
clearedTgps(clearedTgps == 0) = []; % on supprime toutes
nbElem = numel(clearedTgps); % nb de mesures uniques
maxMin = max(Tgps)-min(Tgps);
freq = nbElem / maxMin

% Question 2
% LOCALISATION D'UN VEHICULE PAR GPS ET CAPTEURS EMBARQUES.

% Interpolation
Tnouveaux = linspace(Tgps(1), Tgps(end), 1000);

Xint_lin = interp1(Tgps, Xgps, Tnouveaux, 'linear');
Yint_lin = interp1(Tgps, Ygps, Tnouveaux, 'linear');


%DECLARATIONS DES CONSTANTES ET DES VARIABLES (D?finitions)

Fgps=10;              % Fréquence du GPS en Hz
Tech=0.02;            % Période l?acquisition (50Hz)

x(1)=0;                % Abscisse initial du v?hicule (signal non biais?)
y(1)=0;                % Ordonn?e initiale du v?hicule (signal non biais?)
phi(1)=-2.18;          % Cap initial du v?hicule (signal non biais?) en rad
x_b(1)=0;              % Abscisse initial du v?hicule (signal biais?)
y_b(1)=0;              % Ordonn?e initiale du v?hicule (signal biais?)
phi_b(1)=-2.18;        % Cap initial du v?hicule (signal biais?) en rad

% ACQUISITION DES SIGNAUX

load Circuit_layout_map.mat % Chargement du fichier Circuit_layout_map.mat


%  Coordonnées des accotements droit et gauche du trac? du circuit de Rixheim
x1=map_bd(:,1); % Abscisses bord droit
y1=map_bd(:,2); % Ordonn?es bord droit
x2=map_bg(:,1); % Abscisses bord gauche
y2=map_bg(:,2); % Ordonn?es bord gauche




% AFFICHAGE GRAPHIQUE

% Afficharge FIGURE 1: Trac? du circuit
fig001=figure;  % Cr?ation figure 001
grid on;
subplot(grid_dimensions(1),grid_dimensions(2), [1 2]);
hold on         %  Maintenir active la figure cr??e pour ajout de trac?s
plot(x1,y1,'y.')% Tracé du bord droit du circuit non interpol? en jaune
plot(x2,y2,'c.')% Tracé du bord gauche du circuit non interpol? en cyan
plot(Xgps, Ygps, 'r.');
plot(Xint_lin, Yint_lin, 'm');
axis equal;     % Repère orthonormé
xlabel('x (m)') % Abscisses en metre
ylabel('y (m)') % Ordonn?es en metre
title('FIGURE 1: tracé du circuit (Piste de test)') % Titre
legend('bord droit','bord gauche', 'GPS non interpolée', 'GPS interpolée') % Légende



% Question 3
% calcul de l'évolution de la résolution
deltaX = diff(Xgps);
deltaX(deltaX == 0) = [];
deltaY = diff(Ygps);
deltaY(deltaY == 0) = [];

subplot(grid_dimensions(1),grid_dimensions(2), [4 6]);
plot(deltaX);
hold on;
plot(deltaY);

title("FIGURE 2: Évolution de la résolution de la trajectoire");
legend('résolution en x', 'résolution en y');

% calcul de l'évolution de la vitesse du véhicule
distances = sqrt(deltaX.^2 + deltaY.^2);
vitesses = distances ./ unique(Tgps)(1:end-1);

subplot(grid_dimensions(1), grid_dimensions(2), 3);
plot(vitesses);

title("FIGURE 3: Évolution de la vitesse");
legend('vitesse du robot');

% Question 4
hold on;
%plot(Qgps)





