h = figure;
hold on
axis equal
xlim([-3 6])
ylim([-3 6])
zlim([-3 6])
xlabel('x')
ylabel('y')
zlabel('z')

quiver3(0,0,0,1,0,0,'Color', 'c', 'autoscale', 'off', 'LineWidth', 3);
quiver3(0,0,0,0,1,0,'Color', 'm', 'autoscale', 'off', 'LineWidth', 3);
quiver3(0,0,0,0,0,1,'Color', 'y', 'autoscale', 'off', 'LineWidth', 3);

L=[3 2 5]'; %sorgente luminosa coord
%Vertici del triangolo
V1 = [2 2 2.5]';
V2 = [1 2 3]';
V3 = [2 1 2.5]';

%Punto
plot3(L(1), L(2), L(3), '.r', 'MarkerSize', 20);
text(L(1), L(2), L(3) + 0.5, 'L', 'FontSize', 12);

pause

plot3([V1(1) V2(1) V3(1) V1(1)], [V1(2) V2(2) V3(2) V1(2)], [V1(3) V2(3) V3(3) V1(3)],'-*b', 'LineWidth', 3);

pause

n = [1 1 1]'./norm([1 1 1]); %Vettore normale al piano stesso
S = [1 1 -1]'; %Punto appartenente al piano

%eq piano ax + bx + cx + d
a = n(1);
b = n(2);
c = n(3);
d =-(a*S(1)+b*S(2)+c*S(3)); %definisce i piani che non passno per l'origine

[X,Y] = meshgrid(-2:.2:6, -2:.2:6);
Z=-1/c*(a*X+b*Y+d);
surf(X,Y,Z,'FaceAlpha', 0.1, 'EdgeColor', 'none', 'FaceColor', 'g');

pause

%Dobbiamo trovare l'equazione della retta che passa per due punti
%P=L+t*d      L PUNTO T SCALARE REALE D DIREZIONE RETTA (eq del fascio)


%Come ottenere D se non lo conosciamo? Effettuare la differenza tra due punti appartenenti alla stessa retta(L-V1)
%Se ho un punto nella retta e un altro punto nella retta e ne faccio la
%differenza identifico un vettore che deve essere parallelo alla direzione
%della retta stessa ovvero al vettore che indica la direzione a meno dsi un
%valore scalare
d1 = (L-V1);
d2= (L-V2);
d3 = (L-V3);

%Dobbiamo tirare fuori tutti i punti appartenti alla retta
t_r = [-5:0.1:5];
%Replico il vettore lungo le 3 direzioni (guarda con t_r_rep(:,1:5))
t_r_rep = repmat(t_r,3,1);
%L+t_r.*d1 devo trasformare L e d1 in matrici visto che t_r è matrice
%L,1,length(t_r) ho replicato L n volte per fare la matrice
P_r1= repmat(L,1,length(t_r))+t_r_rep.*repmat(d1,1,length(t_r));
P_r2= repmat(L,1,length(t_r))+t_r_rep.*repmat(d2,1,length(t_r));
P_r3= repmat(L,1,length(t_r))+t_r_rep.*repmat(d3,1,length(t_r));

plot3(P_r1(1,:), P_r1(2,:), P_r1(3,:), '--', 'LineWidth', 1);
plot3(P_r2(1,:), P_r2(2,:), P_r2(3,:), '--', 'LineWidth', 1);
plot3(P_r3(1,:), P_r3(2,:), P_r3(3,:), '--', 'LineWidth', 1);

pause

%line equation
%P = L +td
% plane equation
%n*(P-S)=0 i.e., dot(n, (P-S)) = 0
%n*(L+td-S) =0
%n*(L-S)*tn*d=0

num = dot(n, (S-L));
t1 = num/dot(n,d1);
t2 = num/dot(n,d2);
t3 = num/dot(n,d3);

P1 = L + t1 *d1;
P2 = L + t2 *d2;
P3 = L + t3 *d3;

plot3([P1(1) P2(1) P3(1) P1(1)], [P1(2) P2(2) P3(2) P1(2)], [P1(3) P2(3) P3(3) P1(3)], '-*r', 'LineWidth',3);