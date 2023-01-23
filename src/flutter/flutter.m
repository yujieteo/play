clear all;

U_max       = 80;   % Maximum speed.
U_ratio     = 1000; % Indicates how many dots to draw.
plotf_bool  = 1;    % Change to 1 for frequency plot.
ca4_bool    = 1;    % Change to 1 to use CA4 values.

if ca4_bool == 1
    mu          = 2200;
    c           = 1;
    t           = 0.02;
    x_f         = 0.4 .* c;
    b           = 0.5 .* c;
    a           = x_f - b;
    e           = (x_f ./ c) - 0.25;
    l           = 2;
    f_h         = 2;
    f_alpha     = 5;
    omega_h     = 2 .* pi .* f_h;
    omega_alpha = 2 .* pi .* f_alpha;
    rho         = 1.225;
else
    mu          = 2700;
    c           = 0.25;
    t           = 0.02;
    x_f         = 0.4 .* c;
    b           = 0.5 .* c;
    a           = x_f - b;
    e           = (x_f ./ c) - 0.25;
    l           = 1;
    f_h         = 2;
    f_alpha     = 8;
    omega_h     = 2 .* pi .* f_h;
    omega_alpha = 2 .* pi .* f_alpha;
    rho         = 1.225;
end

Psi_1       = 0.165;
Psi_2       = 0.335;
eps_1       = 0.0455;
eps_2       = 0.30;

Phi_0       = 0.5;
Phidot_0    = @(U) (Psi_1 .* U .* eps_1 ./ b) + ...
              + (Psi_2 .* U .* eps_2 ./ b);

m           = mu .* c .* t .* l;
I_alpha     = ((1/12) .* m .* (c .^ 2)) ...
              + (m .* (a .^ 2));
S           = - m .* a;

K_h         = m .* ((omega_h) .^ 2);
K_alpha     = I_alpha .* (omega_alpha .^ 2);        

A           = [ m   S       ; ...
                S   I_alpha ];

B           = (pi .* (b .^ 2)) .* ...
              [1        (b - x_f)  ; ... 
              (b - x_f) ((b - x_f).^2 + (b .^ 2)./8)];

C           = zeros(2,2);

D           = (pi .* c) .* ...
              [1        ((0.75 .* c) - x_f + 0.25 .* c)  ; ... 
              (-e .* c)     ...
              (((b - x_f).^2) + ((0.75 .* c) - x_f) .* 0.25 .* c)];

E           = [K_h 0 ; 0 K_alpha];

F           = pi .* c .* ...
              [0 1; 0 -e.* c];

I           = eye(2,2);

M_wag       = [m + rho .* pi .* (b.^2) ...
               (S - rho .* pi .* (b.^2) .* ...
               (x_f - b)); ...
               (S - rho .* pi .* (b.^2) .* ...
               (x_f - b)) ...
               I_alpha + rho .* pi .* (b.^2) .* ...
               ((x_f - b).^2 + b.^2 ./ 8)...
              ];

B_wag       = [1 0; 1 0; 0 1; 0 1];

U_axis      = 0:U_max/U_ratio:U_max;
flt_bool    = 0;
div_bool    = 0;
flt_wbool   = 0;
div_wbool   = 0;
U_flutter   = nan;
U_div       = nan;
U_wflutter  = nan;
U_wdiv      = nan;

h_freq      = zeros(1,U_ratio);
alpha_freq  = zeros(1,U_ratio);
h_damp      = zeros(1,U_ratio);
alpha_damp  = zeros(1,U_ratio);

h_wfreq      = zeros(1,U_ratio);
alpha_wfreq  = zeros(1,U_ratio);
h_wdamp      = zeros(1,U_ratio);
alpha_wdamp  = zeros(1,U_ratio);

j           = 1;

res = get(0,'screensize');
fig = figure;
set(fig, 'position', res);

subplot(1,2,1);
title('Root locus');
xlabel('Real part of root');
ylabel('Imaginary part of root');

hold on;

for U = 0:U_max/U_ratio:U_max
    evc_sort         = zeros([4 4]);
    ev_damp          = zeros([4 1]);
    evc_wsort        = zeros([8 8]);
    ev_wdamp         = zeros([8 1]);

    M                = A + rho .* B;
    H                = C + rho .*  U       .* D;
    K                = E + rho .* (U .^ 2) .* F;
    Q                = [I C ; C M]^(-1) * [C I ; -K -H];
    
    C_wag       = rho .* pi .* U .* c .* [ ...
                  Phi_0 ...
                  (0.25 .* c + Phi_0 .* (0.75 .* c - x_f)) ; ...
                  - e .* c .* Phi_0 ...
                  (0.75 .* c - x_f) .* (0.25 .* c - e .* c .* Phi_0)];
    
    K_wag       = [K_h + rho .* pi .* U .* c .* Phidot_0(U) ...
                  (rho .* pi .* U .* c .* ( ...
                   U .* Phi_0 + (0.75 .* c - x_f) .* Phidot_0(U))) ; ...
                   - rho .* pi .* U .* e .* c .^ 2 .* Phidot_0(U) ...
                   K_alpha - rho .* pi .* U .* e .* c .^ 2 .* ( ...
                   U .* Phi_0 + (0.75 .* c - x_f) .* Phidot_0(U))];

    W_wag       = zeros(2,4);
    W_wag(1,1)  = -Psi_1 .* eps_1 .^2 ./ b;
    W_wag(1,2)  = -Psi_2 .* eps_2 .^2 ./ b;
    W_wag(1,3)  = Psi_1 .* eps_1 .* (1 - eps_1 .* (1 - 2 .* e));
    W_wag(1,4)  = Psi_2 .* eps_2 .* (1 - eps_2 .* (1 - 2 .* e));
    W_wag(2,1)  = e .* c .* Psi_1 .* eps_1 .^2 ./ b;
    W_wag(2,2)  = e .* c .* Psi_2 .* eps_2 .^2 ./ b;
    W_wag(2,3)  = - e .* c .* Psi_1 .* eps_1 .* (1 - eps_1 .* (1 - 2 .* e));
    W_wag(2,4)  = - e .* c .* Psi_2 .* eps_2 .* (1 - eps_2 .* (1 - 2 .* e));
    W_wag       = 2 .* rho .* pi .* U .^ 3 .* W_wag;
    
    G_wag       = zeros(4,4);
    G_wag(1,1)  = - eps_1 .* U ./ b;
    G_wag(2,2)  = - eps_2 .* U ./ b;
    G_wag(3,3)  = - eps_1 .* U ./ b;
    G_wag(4,4)  = - eps_2 .* U ./ b;

    Q_wag       = zeros(8,8);

    Q_wag([1:2],[1:2])  = - M_wag^(-1) * C_wag;
    Q_wag([1:2],[3:4])  = - M_wag^(-1) * K_wag;
    Q_wag([1:2],[5:8])  = - M_wag^(-1) * W_wag;
    Q_wag([3:4],[1:2])  = I;
    Q_wag([3:4],[3:8])  = zeros(2,6);
    Q_wag([5:8],[1:2])  = zeros(4,2);
    Q_wag([5:8],[3:4])  = [1 0; 1 0; 0 1; 0 1];
    Q_wag([5:8],[5:8])  = G_wag;
                    
    [evc, ev]        = eig(Q); 
    [evc_wag,ev_wag] = eig(Q_wag); 

    ev               = diag(ev);
    ev_wag           = diag(ev_wag);

    [ev,Index]       = sort(ev,'ascend');
    [ev_ws,Index_w]  = sort(imag(ev_wag),'ascend');
    ev_wag           = ev_wag(Index_w);


    if real(ev(3,:)) < -0.10 
        if flt_bool == 0
            flt_bool = 1;
        end
    end

    if real(ev(3,:)) > 0
        if flt_bool == 1
            U_flutter = U;
            flt_bool = 2;
        end
    end 

    if (imag(ev(1,:)) == 0) && (real(ev(1,:)) > 0)
        if div_bool == 0
            div_bool    = 1;
            U_div       = U;
        end
    end

    if flt_bool ~= 2
        plot(ev,'K*');
    else
        if div_bool == 1
            plot(ev,'B*');
        else
            plot(ev,'R*');
        end
    end
    
    ev_sq            = abs(ev);
    ev_omega         = ev_sq ./ (2 .* pi);
    ev_real          = real(ev);
    
    for i = 1:1:4
        ev_damp(i,1) = - ev_real(i,:) ./ (ev_omega(i,:) .* 2 .* pi);
    end
    
    for i = 1:1:4
        evc_sort(:,i) = evc(:,Index(i));
    end
    
    if (ev_damp(1,1) < 1) 
        h_freq(:,j)     = ev_omega(1,1);
    else
        h_freq(:,j)     = 0;
    end
      
    if (ev_damp(3,1) < 1)
        alpha_freq(:,j) = ev_omega(3,1);
    else
        alpha_freq(:,j) = 0;
    end
    
    h_damp(:,j)     = ev_damp(1,1);
    alpha_damp(:,j) = ev_damp(3,1);
    
    if real(ev_wag(1,:)) < -0.10 
        if flt_wbool == 0
            flt_wbool = 1;
        end
    end

    if real(ev_wag(1,:)) > 0
        if flt_wbool == 1
            U_wflutter = U;
            flt_wbool = 2;
        end
    end 

    if (imag(ev_wag(7,:)) == 0) && (real(ev_wag(7,:)) > 0)
        if div_wbool == 0
            div_wbool    = 1;
            U_wdiv       = U;
        end
    end

    if flt_wbool ~= 2
        plot(ev_wag([1:2,7:8],:),'K.');
    else
        if div_wbool == 1
            plot(ev_wag([1:2,7:8],:),'B.');
        else
            plot(ev_wag([1:2,7:8],:),'R.');
        end
    end
    
    ev_wsq            = abs(ev_wag);
    ev_womega         = ev_wsq ./ (2 .* pi);
    ev_wreal          = real(ev_wag);
    
    for i = 1:1:8
        ev_wdamp(i,1) = - ev_wreal(i,:) ./ (ev_womega(i,:) .* 2 .* pi);
    end
    
    for i = 1:1:8
        evc_wsort(:,i) = evc_wag(:,Index_w(i));
    end
    
    if (ev_wdamp(2,1) < 1)
        h_wfreq(:,j)     = ev_womega(2,1);
    else
        h_wfreq(:,j)     = 0;
    end
    
    if (ev_wdamp(1,1) < 1) 
        alpha_wfreq(:,j) = ev_womega(1,1);
    else
        alpha_wfreq(:,j) = 0;
    end
    
    h_wdamp(:,j)     = ev_wdamp(2,1);
    alpha_wdamp(:,j) = ev_wdamp(1,1);

    j                = j + 1;
end

grid on;

hold off;

subplot(1,2,2);

hold on;

if plotf_bool == 1
    plot(U_axis, h_freq, 'R-');
    plot(U_axis, h_wfreq,'R--');
    plot(U_axis, alpha_freq, 'B-');
    plot(U_axis, alpha_wfreq, 'B--');

    xlabel('Airspeed U_\infty (m/s)');
    ylabel('Natural frequency \omega (Hz)');
    title('Frequency plot');
else
    plot(U_axis, h_damp, 'R-');
    plot(U_axis, h_wdamp,'R--');
    plot(U_axis, alpha_damp, 'B-');
    plot(U_axis, alpha_wdamp, 'B--');

    xlabel('Airspeed U_\infty (m/s)');
    ylabel('Damping ratio \zeta (dimensionless)');
    title('Damping ratio plot');
end

legend('Plunge (QS)','Plunge (US)','Pitch (QS)','Pitch (US)');

if ~isnan(U_flutter)
    annotation('textbox', [0.575, 0.85, 0.135, 0.03], 'String', ...
    "Flutter speed (QS): " + U_flutter + " m/s")
end

if ~isnan(U_wflutter) 
    annotation('textbox', [0.575, 0.82, 0.135, 0.03], 'String', ...
    "Flutter speed (US): " + U_wflutter + " m/s" )
end

if ~isnan(U_div) 
    annotation('textbox', [0.575, 0.79, 0.135, 0.03], 'String', ...
    "Divergence speed (QS): " + U_div + " m/s" )
end

if ~isnan(U_wdiv) 
    annotation('textbox', [0.575, 0.76, 0.135, 0.03], 'String', ...
    "Divergence speed (US): " + U_wdiv + " m/s")
end

grid on;
hold off;
