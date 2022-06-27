function [Y] = Y_admi(line,bus,nbuses)
%% Y_BUS Building
orden=zeros(1,nbuses);
Y=zeros(nbuses);
for k=1:nbuses
    orden(k)=k; % vector which contains the order of building according to the bus information
end
for p=1:length(line(:,1));
    BusP=find(orden==line(p,1));
    BusQ=find(orden==line(p,2));
    a=line(p,6); %Tap value for the  p iteration
    if a>0 % for transformers out of nominal position
    yl=(1/((line(p,3)+j*line(p,4)))); % line admittance
    Ad=(j*line(p,5)/2); % line charging
    Y(BusP,BusQ)=Y(BusP,BusQ)-yl/a; % a non diagonal element
    Y(BusQ,BusP)=Y(BusP,BusQ); % symmetry is  declared for elements out of the diagonal
    Y(BusP,BusP)=Y(BusP,BusP)+(yl/a)+((1/a)*(1/a-1)*yl)+Ad; %Equivalent admittance at the P-terminal plus line charging
    Y(BusQ,BusQ)=Y(BusQ,BusQ)+(yl/a)+(1-1/a)*yl+Ad; %Equivalent admittance at the Q-terminal plus line charging
    else % for lines
         yl=(1/((line(p,3)+j*line(p,4)))); % line admittance
         Ad=(j*line(p,5)/2);  % line charging
         Y(BusP,BusQ)=Y(BusP,BusQ)-yl; % a non diagonal element
         Y(BusQ,BusP)=Y(BusP,BusQ); % symmetry is  declared for elements out of the diagonal
         Y(BusP,BusP)=Y(BusP,BusP)+yl; % diagonal element
         Y(BusQ,BusQ)=Y(BusQ,BusQ)+yl; % diagonal element
         c=line(p,5); % line charging for the whole line
         if c>0
             Y(BusP,BusP)= Y(BusP,BusP)+Ad; %add value of line charging to the diagonal element
             Y(BusQ,BusQ)= Y(BusQ,BusQ)+Ad; %add value of line charging to the diagonal element
         end

    end
end
% Susceptance and conductance
for m=1:nbuses
    dir=find(orden==bus(m,1));
    Y(dir,dir)=Y(dir,dir)+bus(m,8)+j*bus(m,9); % add the shunt admittance 
end
end

