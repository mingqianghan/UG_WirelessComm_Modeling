function L_MFM = MFM(er, falpha, fbeta, dUG, f)
dAG = 1.5;      % vertical distance from receiver to ground surface (m)
ds = 2;         % horizonatal distance from receiver to burail location (m)
d0 = sqrt(dAG^2+ds^2);
L0 = 20*log10(d0)+20*log10(f)-147.55; % Loss in the air
Ls = 6.4 + 20*log10(dUG)+20*log10(fbeta)+8.69*falpha*dUG; % Loss in soil
Lsa = 10*log10((sqrt(er)+1)^2/(4*sqrt(er))); % Loss at soil-air boundary
L_MFM = L0+Ls+Lsa;                           % total loss

end
