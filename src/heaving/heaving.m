clear;
c = 1;          
k1 = 700;      
k2 = 2200;      
K = [k1 0; 0 k2];

m = 150;  
p_max = 0.5;     
mp_max = 50;     

% Number of nodes in mesh in 1D
r = 100;        

i = 1;         
for p = -p_max:(p_max/r):p_max
    j = 1;
    for mp = 0:(mp_max/r):mp_max
        M = [(m+mp) (-mp*p); (-mp*p) ((m*c^2)/12 + (mp*p^2))];
        [~,D] = eig(K,M);
        D = sqrt(D);
        D1_store(i,j) = D(1,1); 
        D2_store(i,j) = D(2,2);
        p_store(i,j) = p;
        mp_store(i,j) = mp;
        j = j+1;
    end
    i = i+1;
end
figure
% mesh(p_store,mp_store,D1_store);
% title('Mesh plot for heave')   
mesh(p_store,mp_store,D2_store);
title('Mesh-plot for pitch')
zlabel('Natural frequency');
xlabel('Distance p from origin');
ylabel('Mass mp of point mass');
