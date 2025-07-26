dat = load("cliff_egde_grad8_filter_mat_fixed.mat");
dat_fix = int32(dat.dat_fix);

% dat_fix = round(rand(9));

[y_size, x_size] = size(dat_fix);
[y_ind, x_ind] = find(dat_fix);


[X,Y] = meshgrid(1:x_size, 1:y_size);
fig = figure;
ax = axes(fig);
h = surf(X,Y,dat_fix);
view([0 0 1]);
axis equal;
set(h,'edgecolor','none');
hold on;

new_rect = [];
excesses = [];
while isempty(new_rect) || ~any(new_rect<0)
    new_rect = getrect(ax);
    excesses = [excesses; new_rect];
end
[cor_num, ~] = size(excesses);
cor_num = cor_num-1;
excesses = round(excesses);
dat_fix_new = dat_fix;
x_corr = [excesses(1:cor_num,1), excesses(1:cor_num,1)+excesses(1:cor_num,3)];
y_corr = [excesses(1:cor_num,2), excesses(1:cor_num,2)+excesses(1:cor_num,4)];
for i = 1:cor_num
    dat_fix_new(y_corr(i,1):y_corr(i,2), x_corr(i,1):x_corr(i,2)) = 0;
end

fig2 = figure;
h = surf(X,Y,dat_fix_new);
view([0 0 1]);
axis equal;
set(h,'edgecolor','none');