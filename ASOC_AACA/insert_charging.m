function [Ant_Sol]=insert_charging(path,Charging_index,Customer,distance,Delivery_A,Delivery_B,Pickup_B,L,W,Q,jiasudu,g,Cr,Cd,A,p,v,h,n,pe,c1,c4,c5,c6,c7)

aij=jiasudu+Cr*g;  

Ant_Sol={};  

for b1=1:length(path)
    Q1=Q;
    Content_A1=W;
    Content_B1=0;
    alns_path=path{b1}(1);   
    flag=0;                  
    for b2=1:length(path{b1})-1
        zan_customer=path{b1}(b2);
        city_choose=path{b1}(b2+1);
        while true                    
                Eij1=aij*(L+Content_A1+Content_B1)*distance(zan_customer,city_choose)+...
                    (0.5*Cd*A*p)*v*v*distance(zan_customer,city_choose);
                Eij1=Eij1/(3600000);                                            
                    if flag==0
                        ui2=distance(city_choose,6:21);
                        index5=find(min(ui2)==ui2)+5; 
                        
                        temporary_Content_A1=Content_A1-Delivery_A(city_choose);
                        temporary_Content_B1=Content_B1-Delivery_B(city_choose)+Pickup_B(city_choose);
                        
                        Eij2=aij*(L+temporary_Content_A1+temporary_Content_B1)*distance(city_choose,index5)+...
                            (0.5*Cd*A*p)*v*v*distance(city_choose,index5);
                        Eij2=Eij2/(3600000);   
                        if Q1-Eij1-Eij2>=0   
                            alns_path(end+1)=city_choose;
                            Q1=Q1-Eij1;       
                            break
                        else                  
                            allow_charging=[]; 
                            Q2=[];  
                            for a0=6:21
                                Eij3=aij*(L+Content_A1+Content_B1)*distance(zan_customer,a0)+...
                                (0.5*Cd*A*p)*v*v*distance(zan_customer,a0);
                                Eij3=Eij3/(3600000);                                
                                if Q1-Eij3>=0
                                    allow_charging(end+1)=a0;
                                    Q2(end+1)=Eij3;
                                end
                            end
                            cost=[];
                            charging_cost=[];
                            carbon_cost=[];
                            flag1=[];
                            for b0=1:length(allow_charging)
                                Q3=Q1-Q2(b0);  
                                
                                Content_A2=Content_A1;
                                Content_B2=Content_B1;
                                total_Eij=0;
                                zan_customer1=allow_charging(b0);
                                for b3=b2+1:length(path{b1})                            
                                    Eij0=aij*(L+Content_A2+Content_B2)*distance(zan_customer1,path{b1}(b3))+...
                                    (0.5*Cd*A*p)*v*v*distance(zan_customer1,path{b1}(b3));
                                    Eij0=Eij0/(3600000);
                                    city_choose1=path{b1}(b3);
                                     
                                    if ismember(city_choose1,Customer{1,1})==1
                                        Content_A2=Content_A2-Delivery_A(city_choose1);
                                        Content_B2=Content_B2+Pickup_B(city_choose1);
                                    elseif  ismember(city_choose1,Customer{1,2})==1
                                        Content_A2=Content_A2-Delivery_A(city_choose1);
                                    else
                                        Content_B2=Content_B2-Delivery_B(city_choose1);
                                    end                
                                    total_Eij=total_Eij+Eij0;
                                    zan_customer1=path{b1}(b3);                      
                                end
                                 
                                if total_Eij<=Q                                                                                
                                   
                                    if ismember(allow_charging(b0),Charging_index{1})==1
                                        charging_cost(end+1)=c4*(total_Eij-Q3);
                                        carbon_cost(end+1)=c7*h*(total_Eij-Q3);
                                    elseif  ismember(allow_charging(b0),Charging_index{2})==1
                                        charging_cost(end+1)=c5*(total_Eij-Q3);
                                        carbon_cost(end+1)=0;
                                    else
                                        charging_cost(end+1)=c6*(total_Eij-Q3);
                                        carbon_cost(end+1)=0;
                                    end
                                    
                                    charging_time1=(60*(total_Eij-Q3))/(n*pe);
                                    
                                    travel_time=c1*distance(zan_customer,allow_charging(b0))/(v*60);
                                    flag1(end+1)=1;
                                   
                                    cost(end+1)=travel_time+charging_cost(b0)+carbon_cost(b0);                                    
                                else    
                                    
                                    if ismember(allow_charging(b0),Charging_index{1})==1
                                        charging_cost(end+1)=c4*(Q-Q3);
                                        carbon_cost(end+1)=c7*h*(Q-Q3);
                                    elseif  ismember(allow_charging(b0),Charging_index{2})==1
                                        charging_cost(end+1)=c5*(Q-Q3);
                                        carbon_cost(end+1)=0;
                                    else
                                        charging_cost(end+1)=c6*(Q-Q3);
                                        carbon_cost(end+1)=0;
                                    end
                                    charging_time1=(60*(Q-Q3))/(n*pe);
                                    
                                    travel_time=c1*distance(zan_customer,allow_charging(b0))/(v*60);
                                    
                                    cost(end+1)=travel_time+charging_cost(b0)+carbon_cost(b0);
                                    flag1(end+1)=0;
                                end                                
                            end
                            index0=find(min(cost)==cost);
                            index0=index0(randperm(length(index0),1));
                            flag=flag1(index0);
                            index0=allow_charging(index0);  
                            Eij6=aij*(L+Content_A1+Content_B1)*distance(zan_customer,index0)+...
                                (0.5*Cd*A*p)*v*v*distance(zan_customer,index0);
                            Eij6=Eij6/(3600000);
                            Q1=Q1-Eij6; 
                            alns_path(end+1)=index0;  
                            zan_customer=index0; 
                            if flag==0
                                Q1=Q;
                            else                                
                                Q1=total_Eij;
                            end

                        end
                    else
                        alns_path(end+1)=city_choose; 
                        Q1=Q1-Eij1;
                        break
                    end                                        
        end
       
        if ismember(city_choose,Customer{1,1})==1          
            Content_A1=Content_A1-Delivery_A(city_choose);
            Content_B1=Content_B1+Pickup_B(city_choose);
        elseif  ismember(city_choose,Customer{1,2})==1     
            Content_A1=Content_A1-Delivery_A(city_choose);
        elseif  ismember(city_choose,Customer{1,3})==1     
            Content_B1=Content_B1-Delivery_B(city_choose);          
        end      
    end  
    Ant_Sol{end+1}=alns_path;
end
end