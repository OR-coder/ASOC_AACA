function [fit,total_travel_distance,P1,P2,P3,P4,P5,total_travel_cost,charging_num,average_charging_rate,charging_time]=Computer_fitness(path,Delivery_A,Delivery_B,Pickup_B,distance,Customer,Charging_index,Service_time,L,W,Q,jiasudu,g,Cr,Cd,A,p,v,h,n,w1,w2,pe,c1,c2,c3,c4,c5,c6,c7)

aij=jiasudu+Cr*g;
total_time=0;
serve_time=0;
total_car=3;
P4=0;  
P5=0;  
charging_time=0;   
charging_num=0;    
average_charging_rate=0;   
for a1=1:length(path)
    Q1=Q;
    Content_A1=W;
    Content_B1=0;
    path1=path{a1};
    index=find(path1<22);
    index=index(2:end);    
    nm=1;  
    for a2=1:length(path1)-1
        city_choose=path1(a2+1);
        Eij1=aij*(L+Content_A1+Content_B1)*distance(path1(a2),city_choose)+...
            (0.5*Cd*A*p)*v*v*distance(path1(a2),city_choose);
        Eij1=Eij1/(3600000);
                
        if city_choose>=6 && city_choose<=21
            charging_num=charging_num+1;
            Content_A2=Content_A1;
            Content_B2=Content_B1;
            Q1=Q1-Eij1;  

            if nm==length(index)-1   
                total_Eij=0;
                
                for b3=index(nm):index(nm+1)-1
                    Eij2=aij*(L+Content_A2+Content_B2)*distance(path1(b3),path1(b3+1))+...
                    (0.5*Cd*A*p)*v*v*distance(path1(b3),path1(b3+1));
                    Eij2=Eij2/(3600000);
                    city_choose1=path1(b3+1);
                     
                    if ismember(city_choose1,Customer{1})==1
                        Content_A2=Content_A2-Delivery_A(city_choose1);
                        Content_B2=Content_B2+Pickup_B(city_choose1);
                    elseif  ismember(city_choose1,Customer{2})==1
                        Content_A2=Content_A2-Delivery_A(city_choose1);
                    elseif  ismember(city_choose1,Customer{3})==1
                        Content_B2=Content_B2-Delivery_B(city_choose1);
                    end            
                    total_Eij=total_Eij+Eij2;
                end
            else
                total_Eij=Q;
            end
            cd=path1(index(nm));
            
            if ismember(cd,Charging_index{1,1})==1
                P4=P4+c4*(total_Eij-Q1);
                P5=P5+h*(total_Eij-Q1);
            elseif  ismember(cd,Charging_index{1,2})==1
                P4=P4+c5*(total_Eij-Q1);
                P5=P5+0;
            else
                P4=P4+c6*(total_Eij-Q1);
                P5=P5+0;
            end
            average_charging_rate=average_charging_rate+(total_Eij-Q1)/Q;
            nm=nm+1;
            charging_time=charging_time+(60*(total_Eij-Q1))/(n*pe);
            Q1=total_Eij;
            total_time=total_time+distance(path1(a2),city_choose)/v;               
        else
            total_time=total_time+distance(path1(a2),city_choose)/v; 
            serve_time=serve_time+Service_time(city_choose);
            Q1=Q1-Eij1;
            if ismember(city_choose,Customer{1})==1
                Content_A1=Content_A1-Delivery_A(city_choose);
                Content_B1=Content_B1+Pickup_B(city_choose);
            elseif  ismember(city_choose,Customer{2})==1
                Content_A1=Content_A1-Delivery_A(city_choose);
            elseif  ismember(city_choose,Customer{3})==1
                Content_B1=Content_B1-Delivery_B(city_choose);
            end
        end                
    end
end
total_travel_distance=(v*total_time)/1000;
P1=c1*total_time/60;
P2=c2*total_car;
P3=c3*serve_time;
P5=P5*c7;
total_travel_cost=P1+P2+P3+P4+P5;
fit=w1*(P1+P2+P3)+w2*(P4+P5);
average_charging_rate=average_charging_rate*100/charging_num;
end