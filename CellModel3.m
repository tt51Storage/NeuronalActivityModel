%cellular automata neural network
clear all
global Act E E_up eps Noutputs Ninputs r_1 r_2 Tk Net;
Net=25; %net size one direcion net is Net X Net elements
n=Net*Net;

%Nc=3;
R=4; %radius - the longest link

pLink=0.5;%*rand();  %prob. of connection - link
pPlus=0.7;%rand()*0.5; %prob that the link is  exitatory (more exitatory than inhibitory
pMinus=1-pPlus;%prob that the link is  inhibitory

%pSpont=0.01;
%pFire=0.1;
Tk=1000000; %time of simulation

E_up=4;
E_lo=2; % minimum energy level necessary for firing 
w=1.5;

Act=zeros(n,Tk);
E=zeros(n,Tk);
E(:,1)=0.5*E_lo.*rand(n,1);


%Gr=InitGraph(Net,R,pLink,pPlus);
ClustR=2;
pClustLink=0.9;
pClustPlus=0.7;
%Gr=InitClusters(Net,R,pLink,pPlus,ClustR,pClustLink,pClustPlus);
Gr=ones(n)-eye(n);
%Gr=Gr-triu(ones(n),10)-tril(ones(n),-10);
figure(1);
image(Gr,'CDataMapping','scaled');
title('Graph');
colorbar;

Noutputs=(sum(Gr.*Gr,2));    % number of outputs; decrease due to transmission of exitation, column vector


r_1=1.1*(1/mean(Noutputs)); % coefficient of  decrease due to transmission of exitation, U1
r_2=5.5*(1/mean(sum(Gr.*Gr,1)));     % coefficient of  decrease due to over-exitation, U2

eps=0.0025; % coefficient for energy increase
Grq=zeros(n,n);
%load My_net1 

for k=1:Tk-1
   Ready_ind=[];
   Spont_ind=[];
   Fire_ind=zeros(n,1);
   noFire_ind=zeros(n,1);
   
   % Determining the number of active inputs for each neuron
   Grq=Grq*0; 
   ind=find(Act(:,k)>0);
   Grq(ind,:)=Gr(ind,:).*Gr(ind,:);
   Ninputs=(sum(Grq,1)');  % number of active inputs; decrease due to over-exitation, column vector
% 
%    
%    %Event 1: find neurons whos energy  is above threshold E_lo
%    Ready_ind=find(E(:,k)>E_lo); % ready to fire neurons  
%    
%   
%    %Event 2: select candidate neurons for spontaneous firing
%    pr=rand(n,1);
%    Spont_ind=find(pr(Ready_ind)<pSpont);
%    
%    %Event 3: select candidate neurons for evoked/induced firing
%    %these neurons must receive an overall positive input
%    
%    S_k=Act(:,k)'*Gr(:,Ready_ind);
%    ReadyF_ind=find(S_k>0);
%    
%    %From the set of neurons formed in Event 3, assign  neurons for evoked/induced firing
%    pr=rand(n,1);
%    Exite_ind=find(pr(Ready_ind(ReadyF_ind))<pFire);
%     Fire_ind(Ready_ind(Spont_ind))=1;

%    Fire_ind(Ready_ind(ReadyF_ind(Exite_ind)))=2;
%    
%    noFire_ind(Fire_ind(:)==0)=1;
   
    pr=rand(n,1);
    ps=0.01;
    p=0.5*(tanh(w.*E(k)-E_lo)+1);
    S_k=Act(:,k)'*Gr(:,:);
    p_E=(1-(1-p*ps).^(S_k+1))';
   Fire_ind(pr<p_E)=1;
    
   noFire_ind(Fire_ind(:)==0)=1;
   
   EventFire(k,Fire_ind);
   EventNoFire(k,noFire_ind);
   
   
end

figure(2); image(Act,'CDataMapping','scaled'); title('Act');
figure(3); image(E,'CDataMapping','scaled'); title('E'); colorbar;
figure(4); plot(sum(Act,1)); title('sum(Act)'); %axis([0 Tk 0 300])

%Avalanche_count;
%%
Activity_count
%%
save( 'today.mat','Act','E', 'Tk','-v7.3');




