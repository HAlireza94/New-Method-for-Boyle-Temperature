clc
clear
close all

Tc=150.86;Pc=48.98;w=0.000;Zc=0.291; % Argon

% Tc=190.56;Pc=45.99200;w=0.011;Zc=0.2863; %Methane

%         Tc=126.2;Pc=34.8;w=0.039;Zc=0.294; % Nitrogen

% Tc=305.3;Pc=49;w=0.099;Zc=0.279; % Ethane

% Tc=369.9;Pc=42.5;w=0.153;Zc=0.276; % Propane

% Tc=425.12;Pc=37.96;w=0.2;Zc=0.274; % Butane

% Tc=469.7;Pc=33.7;w=0.252;Zc=0.270; % Pentane

% Tc=507.6;Pc=30.25;w=0.301;Zc=0.266; % Hexane

% Tc=540.2;Pc=27.4;w=0.350;Zc=0.261; % Heptane1

% Tc=568.7;Pc=24.9;w=0.400;Zc=0.256; % Octane

% Tc=594.6;Pc=22.9;w=0.444;Zc=0.235; % Nonane1

%   Tc=617.7;Pc=21.1;w=0.492;Zc=0.231; % Decane1

% Tc=304.2;Pc=73.8;w=0.239;Zc=0.274; % Carbon dioxid

% Tc=562;Pc=48.9;w=0.212;Zc=0.268; % Benzene

% Tc=513;Pc=81;w=0.556;Zc=0.224; % Methanol

%     Tc=514;Pc=63;w=0.644;Zc=0.24; % Ethanol

%   Tc=536.78;Pc=51.68;w=0.62;Zc=0.254;  % Propanol

% Tc=647.13;Pc=220.55;w=0.34449;Zc=0.229; %Water
%         Tc=405.4;Pc=113;w=0.25;Zc=0.242; % Ammonia

% Tc=227.5;Pc=37.4;w=0.179;Zc=0.277; % R14

%  Tc=388.37;Pc=27.78;w=0.356;Zc=0.279; % R-C318

%     Tc=430.8;Pc=76.2;w=0.283;Zc=0.235; %methanamine

%     Tc=487.20;Pc=59.98;w=0.254;Zc=0.255; % Methyl methanoate

%     Tc=508;Pc=48;w=0.304;Zc=0.233; %Acetone

%     Tc=401;Pc=54;w=0.200;Zc=0.274; % Dimethyl ether
    
%         Tc=144.12;Pc=51.72;w=0.053;Zc=0.287; % Fluorine
        
%         Tc=405.4;Pc=113;w=0.25;Zc=0.242; % Ammonia


R=83.14472;P=1e-07;

   Oa=(0.66121-(0.76105*Zc));
 Ob=(0.02207+(0.20868*Zc));
   Oc=(0.57765-(1.87080*Zc));

    a=(((Oa*(R^2)*(Tc^2)))/Pc);
   b=((Ob*R*Tc)/Pc);
 c=(Oc*R*Tc)/Pc;
    F=0.46283+(3.58230*w*Zc)+(8.19417*(w^2)*(Zc^2));

    
x1=input('Enter lowe range of temperature, T1=');
x2=input('Enter uper range of temperature, T2=');


 T=linspace(x1,x2,3500)';n=numel(T);

 x0=zeros(n,1);
for i=1:n
    
    
    x0(i)=(R*T(i))/P;
    
    
end


OF=zeros(n,1);

    
for i=1:n
    
     f=@(x) ((R*T(i))/(x-b))-((a*((1+(F*(1-((T(i)/Tc)^0.5))))^2))/((x*(x+b))+(c*(x-b))))-P;
     
     OF(i)=fzero(f,x0(i));
%           OF(i)=fsolve(f,x0(i));
% OF(i)=fminsearch(f,x0(i))

end


DEI=zeros(n,1);C=zeros(n,1);RV=zeros(n,1);
A=zeros(n,1);alpha=zeros(n,1);B=zeros(n,1);Tr=zeros(n,1);
Delta_Gipss=zeros(n,1);Delta_Helmholtz_Energy=zeros(n,1);
Delta_Internal_Energy=zeros(n,1);Delta_Entropy=zeros(n,1);
Delta_Enthalpy=zeros(n,1);Z=zeros(n,1);F_B=zeros(n,1);

for i=1:n


    Tr(i)=T(i)/Tc;
    B(i)=(b*P)/(R*T(i));
    C(i)=(c*P)/(R*T(i));
    Z(i)=(P*OF(i))/(R*T(i));
    alpha(i)=((1+(F*(1-((T(i)/Tc)^0.5))))^2);
    
    A(i)=(a*alpha(i))/((R*T(i))^2);
     
    DEI(i)=(a*alpha(i)-(T(i)*(((-F*a)/T(i))*sqrt(Tr(i))*sqrt(alpha(i)))));
  
    Delta_Enthalpy(i)=(R*T(i)*(Z(i)-1))+...
        ((DEI(i)/(sqrt((c^2)+(6*b*c)+(b^2))))*(log((((2*OF(i))-...
        (sqrt((c^2)+(6*b*c)+(b^2)))+c+b)/((2*OF(i))+...
        (sqrt((c^2)+(6*b*c)+(b^2)))+c+b)))));
    
    Delta_Entropy(i)=(R*(log(Z(i)-B(i))))-...
        (((((-F*a)/T(i))*sqrt(Tr(i))*sqrt(alpha(i))/...
        (sqrt((c^2)+(6*b*c)+(b^2)))))*(log((((2*OF(i))-...
        (sqrt((c^2)+(6*b*c)+(b^2)))+c+b)/((2*OF(i))+...
        (sqrt((c^2)+(6*b*c)+(b^2)))+c+b)))));
    
    
    Delta_Internal_Energy(i)=Delta_Enthalpy(i)-(R*T(i)*(Z(i)-1));
    
    Delta_Helmholtz_Energy(i)=((R*T(i))*(log(1/(Z(i)-B(i)))))+...
        (((a*alpha(i))/(sqrt((c^2)+(6*b*c)+(b^2))))*(log((((2*OF(i))-...
        (sqrt((c^2)+(6*b*c)+(b^2)))+c+b)/((2*OF(i))+...
        (sqrt((c^2)+(6*b*c)+(b^2)))+c+b)))));
    
%     F_B(i)=Delta_Enthalpy(i)/Delta_Entropy(i);
%       F_B(i)=Delta_Internal_Energy(i)/Delta_Entropy(i);
% F_B(i)=Delta_Helmholtz_Energy(i)/Delta_Entropy(i);
    
    Delta_Gibbs_free_Energy(i)=Delta_Enthalpy(i)-(T(i)*Delta_Entropy(i));

    F_B(i)=Delta_Gibbs_free_Energy(i)/Delta_Entropy(i);

    
    RV(i)=x0(i)-OF(i);
    
end

I=max(F_B);
disp('maximum of Residual Enthalpy per Residual Entropy=');disp(I);

Andis=find(F_B==I);
% [row,colm]=find(OBV==I)

T_Final=T(Andis);
disp('The Boyle temperature, T');disp(T_Final)

RH=Delta_Enthalpy(Andis);
RS=Delta_Entropy(Andis);


plot(T_Final,I,'ok',T,F_B)

% legend({'Boyle Temperature','Ratio of Residual Enthalpy to Residual Entropy'})
