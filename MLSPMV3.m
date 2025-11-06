function L_MLSPM = MLSPMV3(VWC, C, Layer, dUG, f)

dAG = 1.5;      % vertical distance from receiver to ground surface (m)
ds = 2;         % horizonatal distance from receiver to burail location (m)
d0 = sqrt(dAG^2+ds^2);

layer_len = length(Layer)-1;

% Array initialization 
falpha = zeros(1, layer_len);
fbeta = zeros(1, layer_len);
C_avg = zeros(1, layer_len);
VWC_avg = zeros(1, layer_len);
er = zeros(1, layer_len);
ei = zeros(1, layer_len);

% calcuate average VWC, clay percentage, and parametrs for each layer
for i = 1:layer_len
    C_avg(i) = mean(C(Layer(i)*10+1 : Layer(i+1)*10));
    VWC_avg(i) = mean(VWC(Layer(i)*10+1 : Layer(i+1)*10));
    [falpha(i), fbeta(i), er(i), ei(i)] = MBSDM(C_avg(i), VWC_avg(i), f(1));
end


layer_cur = find(dUG > Layer, 1, 'last');

LR = zeros(1,layer_cur);
LS = zeros(1,layer_cur);

for i = 1:layer_cur
    % loss within soil
    if i == layer_cur
        d_cur = dUG - Layer(layer_cur);
        LS(i) = (f/1000000)^(VWC(layer_cur))*d_cur*falpha(layer_cur)+log10(fbeta(layer_cur));
    else
        LS(i) = (f/1000000)^(VWC(i))*(Layer(i+1)-Layer(i))*falpha(i)+log10(fbeta(i));
        
        % loss at boundaries 
        e1 = sqrt(er(i+1)+ei(i+1));
        e2 = sqrt(er(i)+ei(i));
        R = abs((e1-e2)/(e1+e2));
        LR(i+1)= -20*log(1-R);
    end
end
% Loss at soil-air boundary
LR(1) = 10*log10((sqrt(er(1))+1)^2/(4*sqrt(er(1)))); 
% Loss within soil and at boundaries
Lsoil = sum(LR)+sum(LS);
% Loss in the air
L0 = 20*log10(d0)+20*log10(f)-147.55;
% total loss
L_MLSPM = L0+Lsoil;

end