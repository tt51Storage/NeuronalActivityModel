%cellular automata neural network
clear all
global Act E E_up eps Noutputs Ninputs r_1 r_2 T;
Net=40; %net size one direcion net is Net X Net elements
n=Net*Net;

%Nc=3;
R=3; %radius - the longest link

pLink=0.5;%*rand();  %prob. of connection - link
pPlus=0.7;%rand()*0.5; %prob that the link is  exitatory (more exitatory than inhibitory
pMinus=1-pPlus;%prob that the link is  inhibitory

pSpont=0.01;
pFire=0.1;
T=15000; %time of simulation

E_up=4;
E_lo=2; % minimum energy level necessary for firing 

Act=zeros(n,T);
E=zeros(n,T);
E(:,1)=E_lo.*ones(n,1);


Gr=InitGraph(n,R,pLink,pPlus);
%load My_net Gr
figure(1);
image(Gr,'CDataMapping','scaled');
title('Graph');
colorbar;

Noutputs=(sum(Gr.*Gr,2));    % number of outputs; decrease due to transmission of exitation, column vector


r_1=2*(1/mean(Noutputs)); % coefficient of  decrease due to transmission of exitation, U1
r_2=1*(1/mean(sum(Gr.*Gr,1)));     % coefficient of  decrease due to over-exitation, U2

eps=0.002; % coefficient for energy increase
Grq=zeros(n,n);

for t=1:T-1
   Ready_ind=[];
   Spont_ind=[];
   Fire_ind=zeros(n,1);
   noFire_ind=zeros(n,1);
   
   % Determining the number of active inputs for each neuron
   Grq=Grq*0; 
   ind=find(Act(:,t)>0);
   Grq(ind,:)=Gr(ind,:).*Gr(ind,:);
   Ninputs=(sum(Grq,1)');  % number of active inputs; decrease due to over-exitation, column vector

   
   %Event 1: find neurons whos energy  is above threshold E_lo
   Ready_ind=find(E(:,t)>E_lo); % ready to fire neurons  
   
  
   %Event 2: select candidate neurons for spontaneous firing
   pr=rand(n,1);
   Spont_ind=find(pr(Ready_ind)<pSpont);
   
   %Event 3: select candidate neurons for evoked/induced firing
   %these neurons must receive an overall positive input
   
   S_t=Act(:,t)'*Gr(:,Ready_ind);
   ReadyF_ind=find(S_t>0);
   
   %From the set of neurons formed in Event 3, assign  neurons for evoked/induced firing
   pr=rand(n,1);
   Exite_ind=find(pr(Ready_ind(ReadyF_ind))<pFire);
   
   Fire_ind(Ready_ind(Spont_ind))=1;
   Fire_ind(Ready_ind(ReadyF_ind(Exite_ind)))=2;
   
   noFire_ind(Fire_ind(:)==0)=1;
   
   EventFire(t,Fire_ind);
   EventNoFire(t,noFire_ind);
   
   
end

figure(2); image(Act,'CDataMapping','scaled'); title('Act');
figure(3); image(E,'CDataMapping','scaled'); title('E'); colorbar;
figure(4); plot(sum(Act,1)); title('sum(Act)');

Avalanche_count;


