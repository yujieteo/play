clear all;

% Desired maximum score of rating system From 0 to max.
max = 10;

% Number of points for plot.
n_p = 11;       % Actuals
n_k = 11;       % Scores, keep as 11 for easy conversion

% Population number of ratings IMPORTANT: Set as 0 if unused.
N_pop = 0;

% Number of perfect scores; Useful if N_pop is set.
top = 3;

% Consider that I gave something a perfect score. I also want to account
% for the tolerance considering that I may not have reviewed everything in
% existence.

% Desired value threshold of perfect score IF N_pop = 0; Values from 0 - 1.
% Example: d = 0.99 means a perfect score puts it in the top 1%
if N_pop == 0
    p_0 = 0.999;
else
    % Estimated probability
    p_0 = 1 - (top/(N_pop));
end

% Consider that I bothered rating something. This means I have secretly
% already put it above works that are not worth rating. This gives a
% minimum value for existence.

% Desired value threshold for existence Values from 0 - 1. Example: d =
% 0.99 means its it existing puts it in the top 1%
d = 0.625 - 0.5;

% Alternatively you can use average/max - 0.5 as an estimate of the
% existence rating.



%=====================================%
% Correction for number of points
ratio_p = n_p - 1;
ratio_k = n_k - 1;

% Length of interval
gap_p = (p_0 - d)/ratio_p;
gap_k = 10/ratio_k;

% Score array
p   = d:gap_p:p_0;

% Axis correction for rated score
p10 = p .* 10;

% Logarithmic curve
K   = log(1-d)./log(((1-d)/(1-p_0)).^(1/max)) ...
    - log(1-p)./log(((1-d)/(1-p_0)).^(1/max));

% Linear
K_l = ((max/(max - (10 .* d))) .* (p10 - (10 .* d))) ;

% Inverse hyperbolic cosine with scaling.
K_h =  ((max)./(acosh(p_0) - acosh(d))) .* ...
    (acosh(p) - acosh(d));

% Plotting of the relevant curves.
hold off;
hold on;

plot(K,     p10);  % Logarithmic
plot(K_l,   p10);  % Linear
plot(K_h,   p10);  % Inverse hyperbolic

legend('Logarithmic', ...
    'Linear', ...
    'Inverse hyperbolic cosine, scaled')

% Graph title
title_str   = sprintf('Actual score against rated score');
sub_str     = sprintf('Max score of %.0f', max);
title(title_str, sub_str);

% Graph x-axis labels, and y-axis labels.
xlabel(sprintf('Rated  score out of %.0f', max));
ylabel(sprintf('Actual score out of %.0f', max));

% Write table

K_arr   = 0:gap_k:max;

p_out   = (cosh((K_arr ...
    .* (((acosh(p_0) - acosh(d))/max))...
    + acosh(d)))) .* 10;

T       = table(transpose(K_arr), ...
    transpose(p_out), ...
    'VariableNames', ...
    ["Rating","Actual"]);

T_2     = table(transpose(p10), ...
    transpose(K_h), ...
    'VariableNames', ...
    ["Actual","Rating"]);

writetable(T, 'inv-hyp-rating.xlsx', ...
    'Sheet', 'rating-to-actual', ...
    'WriteMode', 'replacefile');

writetable(T_2, 'inv-hyp-rating.xlsx', ...
    'Sheet', 'actual-to-rating');

hold off;

