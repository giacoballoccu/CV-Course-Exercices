h = figure;
hold on
axis equal
xlim([-1.5 3.5])
ylim([-1.5 3.5])
zlim([0 2])
xlabel('x')
xticks(-1.5:0.5:3.5)
ylabel('y')
zlabel('z')

quiver3(0,0,0,1,0,0,'Color', 'c', 'autoscale', 'off', 'LineWidth', 3);
quiver3(0,0,0,0,1,0,'Color', 'm', 'autoscale', 'off', 'LineWidth', 3);
quiver3(0,0,0,0,0,1,'Color', 'y', 'autoscale', 'off', 'LineWidth', 3);
xplane = -1.5:4;
yplane = -2:4;
[X,Y] = meshgrid(xplane, yplane);
Z=ones(size(X));
surf(X,Y,Z,'FaceAlpha',0.1,'EdgeColor','none', 'FaceColor','g');

radius = 1;
zIncrement = (0:0.2:2.2); %Da qua definisco il n di cerchi che è dato dalla sue colonne e di quanto si distanzioni i cerchi in questo caso 0.2
theta = (0:pi/50:2*pi);
%creo x e y dei cerchi
xunit = radius * cos(theta);
yunit = radius * sin(theta);

%creo la z che porta con se l'incremento
z = zeros(size(xunit))' + zIncrement;
z = z(:); %trasformo in vettore

%Aggiusto le size in maniera che siano uguali
x = repmat(xunit', 12, 1);
y = repmat(yunit', 12, 1);
one = ones(1,1212,'double'); % Fattore costante per fare la moltiplicazioni con matrici di affinità 3d che sono 4x4, https://www.youtube.com/watch?v=UvevHXITVG4

xyz1 = [x y z one'];
translationM = [1 0 0 0; 0 1 0 0; 0 0 1 0; 0 0 0.2 1]; %https://www.mathworks.com/help/images/matrix-representation-of-geometric-transformations.html
vcircles = xyz*translationM;
plot3(vcircles(:,1),vcircles(:,2),vcircles(:,3), '.b', 'LineWidth', 2); %L'ultimo valore è l'1 ottenuto dalla moltiplicazione tra l'array di uni e la matrice di affinità

shearM = [1 0 0 0; 0 1 0 0; 1.5 0 1 0; 0 0 0 1]; 
dcircles = xyz*shearM;
plot3(dcircles(:,1),dcircles(:,2),dcircles(:,3), '.r', 'LineWidth', 2);
