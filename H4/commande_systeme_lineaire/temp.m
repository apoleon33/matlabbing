% on clean un paquet
clc, clear all, close all;

% Exercice 1
A = [0 1; 1 2];
B = [0 ; 1];
C = [1 0];
D = 0;

system = ss(A, B, C, D);

% Exercice 2
valeurs_propres = eig(A);

% Exercice 3
[uuuuh_idk, t] = step(system); % ça continue de croitre -> système instable

%plot(t, uuuuh_idk);

% Exercice 4
Qo = [C; C*A];
Qc = [B A*B];

det(Qo) % renvoie -1 -> système commandable
det(Qc) % renvoie 1 -> système non
