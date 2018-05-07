permitivity = 8.854*10^-14;

mu = 1500; %mobility of electrons

e = 1.6*10^-19; 

rel_sil = 11.9; %relative permitivity of Silicon

workfunction_metal = 4.6;

elec_affinity = 4.05; %electron affinity in eV



%properties of oxide layer

rel_ox = 4; %relative permitivity of oxide

t_ox = 10*10^-7; %thickness of oxide layer

c_ox = rel_ox * permitivity / t_ox; %capacitance of oxide layer



%assuming a channel width

channel_width = 50*10^-4;

%given channel length

channel_length = 5*10^-4;



Na = 10^15; 

Ni = 1.5*10^10; %both calculated per cm^3



phi_f = 0.026 * log(Na / Ni);

Eg = 1.1; %band gap of Si



% We assume the small element length to be 10nm

dy = 5* 10^-7;



%calculating threshold and flatband voltage

workfunction_silicon = elec_affinity + Eg/2 + phi_f ; %in eV

Vfb = workfunction_metal - workfunction_silicon;

Qd = (2 * phi_f * 2 * e * permitivity * rel_sil * Na)^0.5;

Vth = (2 * phi_f) + Vfb + Qd / c_ox ;



%calculating Vgs, Vth, Vsat

Vgs = 4*Vth ;

Vds = 3*Vth;

Vsat = Vgs - Vth;



%defining the array of Vy, Qi, Qd, Ex, Ey, dVy

dVy = zeros(1, 1000);

Vy = zeros(1, 1001);

Qi = zeros(1, 1000);

Qd = zeros(1, 1000);

Ex = zeros(1, 1000);

Ey = zeros(1, 1000);



%calculating drain current Id

if (Vds>Vsat)

    Id = mu * c_ox * channel_width * ((Vgs - Vth)^2) / channel_length ;

else

    Id = mu * c_ox * channel_width * ((Vgs - Vth)*Vds - (Vds^2 / 2)) / channel_length ;

end





%calculating Vy

i = 1;

y = 0;

Vy(1)=0;

while ((Vy(i)<Vsat)&&(y<channel_length))

    dVy(i)= (Id * dy)/(mu*c_ox*(Vgs-Vth-Vy(i))*channel_width);

    Vy(i+1)= Vy(i)+ dVy(i);

    y = y+dy;

    i = i+1;

end



%values of Vy after Vsat

i=1;

while (i<1002)

    if((Vy(i)>Vsat)||(Vy(i)==0))

        Vy(i)=Vsat;

    end

    i=i+1;

end

    

%calculating Qi

i=1;

y=0;

while (y<channel_length)

    Qi(i) = c_ox * (Vgs-Vth-Vy(i));

    y = y+dy;

    i = i+1;

end



%calculating Qd

y=0;

i=1;

while (y<channel_length)

    Qd(i) =(2 * permitivity * rel_sil * e * Na * (2 * phi_f + Vy(i)))^0.5 ;

    y=y+dy;

    i=i+1;

end



%calculating Ex

y=0;

i=1;

while (y<channel_length)

    Ex(i)= (Qi(i)+Qd(i))/(rel_sil*permitivity);

    y=y+dy;

    i=i+1;

end



%calculating Ey

y=0;

i=1;

while (y<channel_length)

    Ey(i)= Id/Qi(i)*(rel_sil*permitivity); 

    y=y+dy;

    i=i+1;

end

%calculating Id

% y=0;
% 
% i=0;
% 
% while (

r= 1:1000;

figure(1)

%plot(r,Qi);

plot(r,Qd);

%plot(r,Ex);

%plot(r,Ey);

%plot(r,Vy);





