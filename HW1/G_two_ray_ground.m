
% two-ray-ground-model
function G_d = G_two_ray_ground(H_t, H_r, d)
G_d = (H_t * H_r)^2 ./ (d .^ 4);
end