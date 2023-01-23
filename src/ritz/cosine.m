clear; close all; clc;

n           = 3;
E           = 8 * ((10)^(11));
rho         = 150;
L           = 6;
m_E         = 211;
L_E         = L/8;
x_axis      = 0:0.01:L;

A           = @(y) 0.1.*(1 - (y./L));
I           = @(y) 0.0005.*(1 - (5/6).*(y./L) + (1/3).*((y./L).^2));

omega_4     = 0;
diff        = 100;
acc         = 0.01;
omega_4M    = zeros(20,2);
V           = zeros(n,n);
recpow      = 14    ;

while (diff >= acc)
    omega_4p    = omega_4;
    n           = n + 1;
    M           = zeros(n,n);
    M_engine    = zeros(n,n);
    M_wing      = zeros(n,n);
    K           = zeros(n,n);
    V_sort      = zeros(n,n);

    for i = 1:n
        for j = 1:n
            phii            = @(y) ((y-L).*sin((pi.*i.*y)./L))./(pi.^3.*L.*i.^3)+(3.*cos((pi.*i.*y)./L))/(pi.^4.*i.^4)+(-(((-1).^i)./(pi.^2 .* L.^2 .* i.^2)).*y.^2)./2+((1)./(pi.^2 .* L .* i.^2)).*y + ((-3)./(pi.^4 .* i.^4));
            phij            = @(y) ((y-L).*sin((pi.*j.*y)./L))./(pi.^3.*L.*j.^3)+(3.*cos((pi.*j.*y)./L))/(pi.^4.*j.^4)+(-(((-1).^j)./(pi.^2 .* L.^2 .* j.^2)).*y.^2)./2+((1)./(pi.^2 .* L .* j.^2)).*y + ((-3)./(pi.^4 .* j.^4));
            M_engine(i,j)   = phii(L_E) .* phij(L_E) .* m_E;
            k_preint        = @(y) rho * A(y) .* phii(y) .* phij(y);
            M_wing(i,j)     = integral(k_preint,0,L);
            M(i,j)          = M_wing(i,j) + M_engine(i,j);
    
            phi_ppi         = @(y) (-pi.*i.*(y-L).*sin((pi.*i.*y)./L)-L.*cos((pi.*i.*y)./L))./(pi.^2.*L.^3.*i.^2)+-(((-1).^i)./(pi.^2 .* L.^2 .* i.^2));
            phi_ppj         = @(y) (-pi.*j.*(y-L).*sin((pi.*j.*y)./L)-L.*cos((pi.*j.*y)./L))./(pi.^2.*L.^3.*j.^2)+-(((-1)^j)./(pi.^2 .* L.^2 .* j.^2));
            p_preint        = @(y) E .* I(y) .* phi_ppi(y) .* phi_ppj(y);
            K(i,j)          = integral(p_preint,0,L);
        end
    end
    
    [V,d]           = eig(M\K);

    d               = diag(d);
    [d,Index]       = sort(d,'ascend');
    
    for i = 1:n
        V_sort(:,i) = V(:,Index(i));
    end
    
    omega_4         = sqrt(d(4,1));
    diff            = (abs(omega_4 - omega_4p)/omega_4) * 100;
    freq        = sqrt(d)./(2*pi);

    omega_4M(n-3,1) = n;
    omega_4M(n-3,2) = omega_4;
    
    if (rcond(M) < (10^(-recpow)))
        fprintf('%d',rcond(M));
        break;
    end
end

omega_4M = omega_4M(1:n-3,:); 

res = get(0,'screensize');
fig = figure;
set(fig, 'position', res);

subplot(1,2,1);
plot(omega_4M(:,1),omega_4M(:,2),'-sk');
title(sprintf('Convergence plot of fourth natural frequency with accuracy %-6.4f %%',diff));
xlabel('Number of mode shapes (n)');
ylabel('Fourth natural frequency \omega_4 (rad/s)');

subplot(1,2,2);
hold on

txt = cell(1,4);

for j = 1:1:4
    v_init      = zeros(1,length(x_axis));
    for i = 1:1:n
        phii    = @(y) ((y-L).*sin((pi.*i.*y)./L))./(pi.^3.*L.*i.^3)+(3.*cos((pi.*i.*y)./L))/(pi.^4.*i.^4)+(-(((-1).^i)./(pi.^2 .* L.^2 .* i.^2)).*y.^2)./2+((1)./(pi.^2 .* L .* i.^2)).*y + ((-3)./(pi.^4 .* i.^4));
        v_prod  = phii(x_axis) .* V_sort(i,j);
        v_init  = v_init + v_prod;
    end
    v_init      = v_init / v_init(end); 
    plot(x_axis,v_init);
    txt{j}      = sprintf('Mode shape %i, frequency %-6.2f Hz',j,freq(j,1));
end

legend(txt)
title(sprintf('Normalised mode shape with %i iterations', n));
xlabel('Distance from wing datum to wing tip in y-axis (m)');
ylabel('Mode shape (dimensionless)');