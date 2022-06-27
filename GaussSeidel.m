%% Gauss Seidel Load Flow analysis
clear all; close all; clc
ch = input('Enter the IEEE power system to analyze.: (5, 6 or 9): '); % choose between 5, 6 or 9
while ch ~= 5 && ch ~= 6 && ch ~= 9
    fprintf('Invalid Input, try again\n');
    ch = input('Enter the IEEE system to analyze.: (5, 6 or 9): ');
end
switch ch
    case 5
        data5; disp('IEEE 5 bus system')
    case 6
        data6; disp('IEEE 6 bus system')
    case 9
        data9; disp('IEEE 9 bus system')
end
% Data of the power system is stored in the bus and line matrix of the
% following file
nbuses=length(bus(:,1)); % number of buses of the electric power system
V=bus(:,2); Vprev=V; % Initial bus voltages
The=bus(:,3); % Initial bus angles
% Net power (Generation - Load)
P=bus(:,4)-bus(:,6);     
Q=bus(:,5)-bus(:,7); 
% ++++++++++++++ First, compute the addmitance matrix Ybus ++++++++++++++++
[Y] = Y_admi(line,bus,nbuses); % function to get the admittance matrix 

% +++++++++++++++++++++++ Start iterative process +++++++++++++++++++++++++
tolerance=1; 
iteration=0;
st=clock; % start the iteration time clock
while (tolerance > 1e-8)
    for k=2:nbuses
        PYV=0;
        for i=1:nbuses
            if k ~= i
                PYV = PYV + Y(k,i)* V(i);  % Vk * Yik
            end
        end
        if bus(k,10)==2 % PV bus
            % Estimate Qi at each iteration for the PV buses
            Q(k)=-imag(conj(V(k))*(PYV + Y(k,k)*V(k)));
        end
        V(k) = (1/Y(k,k))*((P(k)-j*Q(k))/conj(V(k))-PYV); % Compute bus voltages
        if bus(k,10) == 2 % For PV buses, the voltage magnitude remains same, but the angle changes
            V(k)=abs(Vprev(k))*(cos(angle(V(k)))+j*sin(angle(V(k))));
        end
    end
    iteration=iteration+1; % Increment iteration count
    tolerance = max(abs(abs(V) - abs(Vprev))); % Tolerance at the current iteration
    Vprev=V;
end
ste=clock; % end the iteration time clock

% Now, we have found V and Theta, then, we can compute the power flows

% +++++++++++++++++++++++++++++ Power flow ++++++++++++++++++++++++++++++++
% currents at each node
I=Y*V;
% Power at each node
S=V.*conj(I); % Complex power
for k=1:nbuses
    if bus(k,10)==1
        % Real and reactive generation at the Slack bus
        Pgen(k)=real(S(k));
        Qgen(k)=imag(S(k));
    end
    if bus(k,10)==2
        % Real and reactive generation at the PV buses
        Pgen(k)=real(S(k))+bus(k,6);
        Qgen(k)=imag(S(k))+bus(k,7);
    end
    if bus(k,10)==3
        Pgen(k)=0;
        Qgen(k)=0;
    end
end
% calculate the line flows and power losses
FromNode=line(:,1);
ToNode=line(:,2);
nbranch = length(line(:,1)); % number of branches
for k=1:nbranch
    a=line(k,6);   % Find out if is a line or a transformer, a=0 -> line, a=1 -> transformer, 0<a<1 -> Transformer
    switch a    % for both cases use the pi model
        case 0  %if its a line a=0
            b=1i*line(k,5);
            suceptancia(k,1)=b/2; 
            suceptancia(k,2)=b/2;
        otherwise %if its a transformer
            Zpq=line(k,3)+1i*line(k,4);
            Ypq=Zpq^-1;
            suceptancia(k,1)=(Ypq/a)*((1/a)-1); 
            suceptancia(k,2)=Ypq*(1-(1/a));
    end
end
% Define admmitance of lines
r = line(:,3);
rx = line(:,4);
z = r + j*rx;
y = ones(nbranch,1)./z;
% Define complex power flows
Ss = V(FromNode).*conj((V(FromNode) - V(ToNode)).*y ...
   + V(FromNode).*suceptancia(:,1)); % complex flow of the sending buses
Sr = V(ToNode).*conj((V(ToNode) - V(FromNode)).*y ...
   + V(ToNode).*suceptancia(:,2)); % complex low of the receiving buses

% Define active and reactive power flows
Pij=real(Ss);
Qij=imag(Ss);
Pji=real(Sr);
Qji=imag(Sr);

% Active power lossess
P_loss=sum(Pij+Pji);

% Reactive power lossess
Q_loss=sum(Qij+Qji);

% +++++++++++++++++++++++++++ Print results +++++++++++++++++++++++++++++++
disp('                      Gauss Seidel Load-Flow Study')
disp('                    Report of Power Flow Calculations ')
disp(' ')
disp(date)
fprintf('Number of iterations       : %g \n', iteration)
fprintf('Solution time              : %g sec.\n',etime(ste,st))
fprintf('Total real power losses    : %g.\n',P_loss)
fprintf('Total reactive power losses: %g.\n\n',Q_loss)
disp('                                      Generation             Load')
disp('      Bus      Volts     Angle      Real  Reactive      Real  Reactive ')
ywz=[  bus(:,1)    abs(V)  (180/pi)*angle(V)  Pgen'  Qgen'  bus(:,6)  bus(:,7)];
disp(ywz)

disp('                      Line Flows                     ')
disp('    #Line    From Bus   To Bus     Real    Reactive   ')
l=1:1:length(line(:,1));
xy=[l' FromNode ToNode Pij Qij];
yx=[l' ToNode  FromNode Pji Qji];
disp(xy)
disp(yx)
