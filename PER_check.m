function PER = PER_check(receive_data)

transmit_data = importdata("data\data_sent.txt");
PER = 0;

for i = 1:300
    Pe = isequal(receive_data(i,2:12),transmit_data(mod(receive_data(i),50)+1,2:12));
    if(Pe==0)
        disp(i)
    end
    PER = PER + Pe;
end

% PER = PER / 3;  % in  percentage

end