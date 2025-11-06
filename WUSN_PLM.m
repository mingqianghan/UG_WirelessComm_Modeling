function L_PLM = WUSN_PLM(er, falpha, fbeta, dUG, f)

d1 = 0.1;    % distance signal travels within the transmistter box
d2 = 1.5;    % vertical distance from receiver to ground surface (m)
ds = 2;      % horizonatal distance from receiver to burail location (m)
d0 = sqrt(d2^2+ds^2);

% calcualte crital angle and distance traveled in soil
ac = asin(1/sqrt(er));
d = dUG/cos(ac);

R = ((1-sqrt(er))/(1+sqrt(er)))^2;   % reflection coefficient

phi = -288.8+20*log10(d1*d0*d*fbeta)+8.69*falpha*d;

if (dUG<=0.3)                       % for top soil
    L_PLM = phi+20*log10(sqrt(2*R/(1+R)))+40*log10(f);
else                                % for sub soil
    L_PLM = phi+40*log10(f);
end

end

