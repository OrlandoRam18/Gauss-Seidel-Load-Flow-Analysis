%% Topology of the power system
% Information about the bus matrix
  % nd   V    Ang.    Pg      Qg      PL      QL      Gs       jBs    Type
  % (1) (2)   (3)     (4)     (5)     (6)     (7)     (8)      (9)    (10)
  % Colum 11: if the bus has shunt element =1, if it hasnt shunt element =0
bus = [ 1      1.05      0.0      0.0      0.0      0.0     0.0      0.0     0.0       1      0.0;           
        2      1.05      0.0      0.5      0.0      0.0     0.0      0.0     0.0       2      0.0;
        3      1.07      0.0      0.6      0.0      0.0     0.0      0.0     0.0       2      0.0;
        4      1.0       0.0      0.0      0.0      0.7     0.7      0.0     0.0       3      0.0;
        5      1.0       0.0      0.0      0.0      0.7     0.7      0.0     0.0       3      0.0;
        6      1.0       0.0      0.0      0.0      0.7     0.7      0.0     0.0       3      0.0];

%Information about the line matrix
%COL 1.-  From bus
%COL 2.-  to bus
%COL 3.-  R P.U.
%COL 4.-  Xl P.U.
%COL 5.-  Xc (parallel) P.U.
%COL 6.-  Type of line: 0==Line ; 1==Transformer
%COL 7.- phase shifter angle
line = [ 1      2       0.10    0.20     0.02       0.0  0.0;
         1      4       0.05    0.20     0.02       0.0  0.0;
         1      5       0.08    0.30     0.03       0.0  0.0;
         2      3       0.05    0.25     0.03       0.0  0.0;
         2      4       0.05    0.10     0.01       0.0  0.0;
         2      5       0.10    0.30     0.02       0.0  0.0;
         2      6       0.07    0.20     0.025      0.0  0.0;
         3      5       0.12    0.26     0.025      0.0  0.0;
         3      6       0.02    0.10     0.01       0.0  0.0;
         4      5       0.20    0.40     0.04       0.0  0.0;
         5      6       0.10    0.30     0.03       0.0  0.0];
     

