% LOCALISATION D'UN VEHICULE PAR GPS ET CAPTEURS EMBARQUES.
% Nom: 

%IMPORTANT !!!!! LE PRESENT SCRIPT devrait appeller la fonction "fusion"
% ainsi que les fichier de donn�es capteurs "Circuit_layout_map.mat", "dataGps.mat", et "dataCapt.mat". 

%BIEN VOULOIR VERIFIER QUE CES QUATRE (04) FICHIERS SONT PRESENT DANS LE REPERTOIRE
%COURANT AVANT D'EXECUTER CE SCRIPT "Localization_and_Data_Fusion.m"



%DECLARATIONS DES CONSTANTES ET DES VARIABLES (D�finitions)

Fgps=10;              % Fr�quence du GPS en Hz
Tech=0.02;            % P�riode l�acquisition (50Hz)

x(1)=0;                % Abscisse initial du v�hicule (signal non biais�)
y(1)=0;                % Ordonn�e initiale du v�hicule (signal non biais�)
phi(1)=-2.18;          % Cap initial du v�hicule (signal non biais�) en rad 
x_b(1)=0;              % Abscisse initial du v�hicule (signal biais�)
y_b(1)=0;              % Ordonn�e initiale du v�hicule (signal biais�)
phi_b(1)=-2.18;        % Cap initial du v�hicule (signal biais�) en rad




         % ACQUISITION DES SIGNAUX
         
load Circuit_layout_map.mat % Chargement du fichier Circuit_layout_map.mat


%  Coordonn�es des accotements droit et gauche du trac� du circuit de Rixheim
x1=map_bd(:,1); % Abscisses bord droit
y1=map_bd(:,2); % Ordonn�es bord droit
x2=map_bg(:,1); % Abscisses bord gauche
y2=map_bg(:,2); % Ordonn�es bord gauche



         % AFFICHAGE GRAPHIQUE

% Afficharge FIGURE 1: Trac� du circuit
fig001=figure;  % Cr�ation figure 001
hold on         %  Maintenir active la figure cr��e pour ajout de trac�s
plot(x1,y1,'y.')% Trac� du bord droit du circuit non interpol� en jaune
plot(x2,y2,'c.')% Trac� du bord gauche du circuit non interpol� en cyan
axis equal;     % Rep�re orthonorm� 
xlabel('x (m)') % Abscisses en metre
ylabel('y (m)') % Ordonn�es en metre
title('FIGURE 1: trac� du circuit (Piste de test)') % Titre
legend('bord droit','bord gauche') % L�gende

 



