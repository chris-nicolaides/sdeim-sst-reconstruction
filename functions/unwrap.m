function u_water_uw = unwrap(ind_water, u_water)
% unwrap reinserts NaN values into a shrunken vector
%
% INPUTS:
% ind_water: vector of water indices
% u_water: shrunken u vector
%
% OUTPUTS:
% u_water_uw: unwrapped u vector

u_water_uw = NaN(size(ind_water,1), size(u_water,2));
u_water_uw(ind_water,:) = u_water;

end