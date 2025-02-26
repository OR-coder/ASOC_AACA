clc;
clear;
close all;
start_time=cputime;
filepath=['Test Data\C' num2str(101) '.xls'];
data=xlsread(filepath,['C' num2str(2) ':' 'I' num2str(122)]); 
Coordinate_x=data(:,1)';  
Coordinate_y=data(:,2)';  
Pickup_B=data(:,3)';      
Delivery_A=data(:,4)';    
Delivery_B=data(:,5)';    
Service_time=data(:,6)';  
Charging_cost=data(:,7)'; 
Charging_cost=Charging_cost(Charging_cost>0);
Charging_cost1=unique(Charging_cost);  
customer_num=length(Coordinate_x(22:end));

L=3000;     
W=500;     
Q=45;       
jiasudu=0;  
g=9.8;      
Oij=0;      
Cr=0.01;    
Cd=0.7;     
A=6.71;     
p=1.29;    
v=16.7;     
h=0.69;     
n=0.9;      
w1=0.5;     
w2=0.5;     
pe=60;      
c1=0.5;     
c2=100;     
c3=0.3;     
c4=0.449;   
c5=0.19;    
c6=0.223;   
c7=0.05422; 

maxIter_Ant=600;  
antNum=35;        
beta1=1;          
beta2=3;          
rand0=0.5;        
a=0.2;            
t_max=2.5;          
t_min=0.02;       
t_o=0.5;         
ning=0;           
n_limit=10;       
rho=0.2;          
pheromone=ones(length(Coordinate_x),length(Coordinate_x));  
pheromone(:,:)=t_max; 

inspire=[];   
distance=[];  
for i=1:length(Coordinate_x)
    for j=1:length(Coordinate_x)
        if i==j
            distance(i,j)=10000000000;
            inspire(i,j)=0;
        else
            distance(i,j)=sqrt(power(Coordinate_x(i)*1000-Coordinate_x(j)*1000,2)+power(Coordinate_y(i)*1000-Coordinate_y(j)*1000,2));
            inspire(i,j)=1/distance(i,j);
        end
    end
end

Charging_index=cell(1,3);
Charging_index{1,1}=6:13;    
Charging_index{1,2}=14:17;   
Charging_index{1,3}=18:21;   

Customer=cell(1,3);
for a1=22:length(Pickup_B)
    if Pickup_B(a1)~=0 && Delivery_A(a1)~=0  
        Customer{1,1}=[Customer{1,1} a1];    
    elseif Delivery_A(a1)~=0 && Delivery_B(a1)==0
        Customer{1,2}=[Customer{1,2} a1];    
    else
        Customer{1,3}=[Customer{1,3} a1];    
    end
end

minLen=inf;      
optimalCost=inf;  
optimalSol={};    
best_fitness=[];  
for Iter_Ant=1:maxIter_Ant
    sum_path=cell(antNum,3);
    sum_len=[];  
    AntCost=[];  
    choose_customer=randperm(5,1);   
    for i=1:antNum
        leng=0;      
        ant_path={};  
        path=choose_customer;   
        Unvisit=22:length(Coordinate_x);  
        Content_A=W;  
        Content_B=0;  
        for a2=1:length(Unvisit)
            while true
                allow=[];
                for a3=1:length(Unvisit)
                    if Content_A-Delivery_A(Unvisit(a3))>=0 && Content_B-Delivery_B(Unvisit(a3))>=0 && (Content_A-Delivery_A(Unvisit(a3)))+(Content_B-Delivery_B(Unvisit(a3)))+Pickup_B(Unvisit(a3))<=W
                        allow(end+1)=Unvisit(a3);
                    end
                end
                if ~isempty(allow)
                    customer_prob=[];
                    customer_prob1=[];
                    for d=1:length(allow)
                        customer_prob(end+1)=power(pheromone(choose_customer,allow(d)),beta1)*power(inspire(choose_customer,allow(d)),beta2);                  
                    end
                    
                    if rand(1)<=rand0   
                           index_max=find(max(customer_prob)==customer_prob);
                           city_choose=allow(index_max(1));  
                    else                
                           customer_prob1=customer_prob/sum(customer_prob);
                           prob_add=[];
                            aq=0;
                            for j1=1:length(customer_prob)
                                aq=aq+customer_prob1(j1);
                                prob_add(end+1)=aq;
                            end
                            ran=rand(1);
                            for k1=1:length(prob_add)
                                if  ran-prob_add(k1)<0
                                    city_choose = allow(k1);
                                    break
                                end
                            end 
                    end
                    path(end+1)=city_choose; 
                    leng=leng+distance(choose_customer,city_choose);  
                    choose_customer=city_choose;             
                    index1=find(city_choose==Unvisit);
                    Unvisit(index1)=[];  
                            
                    if ismember(city_choose,Customer{1,1})==1          
                        Content_A=Content_A-Delivery_A(city_choose);
                        Content_B=Content_B+Pickup_B(city_choose);
                    elseif  ismember(city_choose,Customer{1,2})==1     
                        Content_A=Content_A-Delivery_A(city_choose);
                    else
                        Content_B=Content_B-Delivery_B(city_choose);   
                    end
                    break
                else
                    ui=distance(choose_customer,1:5);
                    index2=find(min(ui)==ui);
                    path(end+1)=index2;
                    leng=leng+distance(choose_customer,index2);
                    ant_path{end+1}=path;  
                    
                    Content_A=W;
                    Content_B=0;
                    
                    choose_customer=index2;
                    path=choose_customer;
                end
            end
        end
       
        ui1=distance(city_choose,1:5);
        index3=find(min(ui1)==ui1);
        path(end+1)=index3(1);
        ant_path{end+1}=path;        
        leng=leng+distance(choose_customer,index3(1));
        choose_customer=index3(1);
        sum_len(end+1)=leng;
       
        [Ant_Sol]=insert_charging(ant_path,Charging_index,Customer,distance,Delivery_A,Delivery_B,Pickup_B,L,W,Q,jiasudu,g,Cr,Cd,A,p,v,h,n,pe,c1,c4,c5,c6,c7);
        [fit,total_travel_distance,P1,P2,P3,P4,P5,total_travel_cost,charging_num,average_charging_rate,charging_time]=Computer_fitness(Ant_Sol,Delivery_A,Delivery_B,Pickup_B,distance,Customer,Charging_index,Service_time,L,W,Q,jiasudu,g,Cr,Cd,A,p,v,h,n,w1,w2,pe,c1,c2,c3,c4,c5,c6,c7);
        AntCost(end+1)=fit;
        sum_path(i,:)=Ant_Sol;

    end
    
    index4=find(min(AntCost)==AntCost);
    bestCost=min(AntCost);
    bestSol=sum_path(index4(1),:);
    
    if bestCost<optimalCost
        optimalCost=bestCost;
        optimalSol=bestSol;
        minLen=sum_len(index4(1));
        ning=0;
    elseif bestCost==optimalCost
        ning=ning+1;
    end
    best_fitness(end+1)=optimalCost;
    
    %rho=power(a,Iter_Ant/maxIter_Ant); 
    pheromone=pheromone*(1-rho);
    
   
    if ning < n_limit   
        for a7=1:3
            for a8=1:length(sum_path{index4(1),a7})-1
                pheromone(sum_path{index4(1),a7}(a8),sum_path{index4(1),a7}(a8+1))=pheromone(sum_path{index4(1),a7}(a8),sum_path{index4(1),a7}(a8+1))+1/bestCost;
            end
        end
    else              
        for a7=1:3
            for a8=1:length(sum_path{index4(1),a7})-1
                
                pheromone(sum_path{index4(1),a7}(a8),sum_path{index4(1),a7}(a8+1))=pheromone(sum_path{index4(1),a7}(a8),sum_path{index4(1),a7}(a8+1))+1/bestCost;
                
                pheromone(sum_path{index4(1),a7}(a8),sum_path{index4(1),a7}(a8+1))=pheromone(sum_path{index4(1),a7}(a8),sum_path{index4(1),a7}(a8+1))-t_o*(t_max-pheromone(sum_path{index4(1),a7}(a8),sum_path{index4(1),a7}(a8+1)));
            end
        end
       
        pheromone=pheromone+t_o*(t_max-pheromone);
    end
    
    pheromone(pheromone(:,:)<=t_min)=t_min;
    pheromone(pheromone(:,:)>=t_min)=t_max;
    disp(['Iteration.',num2str(Iter_Ant),' The best objective function value:',num2str(optimalCost)])
end

[fit,total_travel_distance,P1,P2,P3,P4,P5,total_travel_cost,charging_num,average_charging_rate,charging_time]=Computer_fitness(optimalSol,Delivery_A,Delivery_B,Pickup_B,distance,Customer,Charging_index,Service_time,L,W,Q,jiasudu,g,Cr,Cd,A,p,v,h,n,w1,w2,pe,c1,c2,c3,c4,c5,c6,c7);
[ok]=plot1(optimalSol,Charging_index,Customer,Coordinate_x,Coordinate_y,maxIter_Ant,best_fitness);
disp(['Total vehicle distance traveled:',num2str(total_travel_distance)])
disp(['Total vehicle logistics costs:',num2str(total_travel_cost)])
disp(['EV travel costs:',num2str(P1)])
disp(['Fixed usage costs:',num2str(P2)])
disp(['Customer service costs:',num2str(P3)])
disp(['Charging costs:',num2str(P4)])
disp(['Carbon emission costs:',num2str(P5)])
disp(['The number of EVs enabled:',num2str(length(optimalSol))])
disp(['Total charging times:',num2str(charging_num)])
disp(['Average charging rates:',num2str(average_charging_rate)])
final_time=cputime-start_time;
disp(['AACA runtime:',num2str(final_time)])
