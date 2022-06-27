%% Topology of the power system (IEEE 5 bus system)
% Information about the bus matrix
  % nd   V    Ang.    Pg      Qg      PL      QL      Gs       jBs    Type
  % (1) (2)   (3)     (4)     (5)     (6)     (7)     (8)      (9)    (10)
  % Colum 11: if the bus has shunt element =1, if it hasnt shunt element =0
bus=[1  1.06  0.000   0.00    0.00    0.00    0.00    0.000    0.000  1  0.0;
     2  1.00  0.000   0.40    0.00    0.20    0.10    0.000    0.000  2  0.0;
     3  1.00  0.000   0.00    0.00    0.45    0.15    0.000    0.000  3  0.0;
     4  1.00  0.000   0.00    0.00    0.40    0.05    0.000    0.000  3  0.0 ;
     5  1.00  0.000   0.00    0.00    0.60    0.10    0.000    0.000  3  0.0];
 
 %Information about the line matrix
%COL 1.-  From bus
%COL 2.-  to bus
%COL 3.-  R P.U.
%COL 4.-  Xl P.U.
%COL 5.-  Xc (parallel) P.U.
%COL 6.-  Type of line: 0==Line ; 1==Transformer
%COL 7.- phase shifter angle
line=[1  2   0.02   0.06   0.0150   0.00   0.00;
      1  3   0.08   0.24   0.0125   0.00   0.00;
      2  3   0.06   0.18   0.0100   0.00   0.00;
      2  4   0.06   0.18   0.0100   0.00   0.00;
      2  5   0.04   0.12   0.0075   0.00   0.00;
      3  4   0.01   0.03   0.0050   0.00   0.00;
      4  5   0.08   0.24   0.0125   0.00   0.00]; 


