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
fig8 = figure;
biasedCap = integral(@(p) Psip(p), Tcapt(1), Tcapt(end));
plot(biasedCap);
