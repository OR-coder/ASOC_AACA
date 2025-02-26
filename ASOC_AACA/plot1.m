function [ok]=plot1(ALNS_path,Charging_index,Customer,Coordinate_x,Coordinate_y,maxIter_Ant,best_fitness)

figure
box on
r=38.1789;
colors=[205 155 155];
centers=[40,50];
viscircles(centers,r,'color',colors/255,'LineStyle','--','LineWidth',1.6);  
color1=['b','g','r'];
hold on
for ok=1:3
    Customer1=[];
    Customer2=[];
    Customer3=[];
    Charging1=Charging_index{1};
    Charging2=Charging_index{2};
    Charging3=Charging_index{3};
    depot=1:5;
    for ok1=2:length(ALNS_path{ok})
        city_choose=ALNS_path{ok}(ok1);
        if city_choose~=ALNS_path{ok}(length(ALNS_path{ok}))
            if ismember(city_choose,Customer{1})==1
                Customer1(end+1)=city_choose; 
                route=[ALNS_path{ok}(ok1-1) ALNS_path{ok}(ok1)];
                route_x=Coordinate_x(route)';  
                route_y=Coordinate_y(route)';  
                plot(route_x,route_y,'Color',color1(ok),'LineStyle','-.','LineWidth',2)     
                grid on;  
                hold on
            elseif  ismember(city_choose,Customer{2})==1
                Customer2(end+1)=city_choose;
                route=[ALNS_path{ok}(ok1-1) ALNS_path{ok}(ok1)];
                route_x=Coordinate_x(route)';  
                route_y=Coordinate_y(route)';  
                plot(route_x,route_y,'Color',color1(ok),'LineStyle','-','LineWidth',2)
                grid on;  
                hold on
            elseif  ismember(city_choose,Customer{3})==1
                Customer3(end+1)=city_choose;
                route=[ALNS_path{ok}(ok1-1) ALNS_path{ok}(ok1)];
                route_x=Coordinate_x(route)';  
                route_y=Coordinate_y(route)';  
                plot(route_x,route_y,'Color',color1(ok),'LineStyle','-','LineWidth',2)
                grid on; 
                hold on
            elseif ismember(ALNS_path{ok}(ok1+1),Customer{1})==1
                route=[ALNS_path{ok}(ok1-1) ALNS_path{ok}(ok1)];
                route_x=Coordinate_x(route)';  
                route_y=Coordinate_y(route)';  
                plot(route_x,route_y,'Color',color1(ok),'LineStyle','-.','LineWidth',2)
                grid on;  
                hold on
            elseif ismember(ALNS_path{ok}(ok1+1),Customer{2})==1
                route=[ALNS_path{ok}(ok1-1) ALNS_path{ok}(ok1)];
                route_x=Coordinate_x(route)';  
                route_y=Coordinate_y(route)';  
                plot(route_x,route_y,'Color',color1(ok),'LineStyle','-','LineWidth',2)
                grid on;  
                hold on
            elseif ismember(ALNS_path{ok}(ok1+1),Customer{3})==1
                route=[ALNS_path{ok}(ok1-1) ALNS_path{ok}(ok1)];
                route_x=Coordinate_x(route)';  
                route_y=Coordinate_y(route)';  
                plot(route_x,route_y,'Color',color1(ok),'LineStyle','-','LineWidth',2)
                grid on;  
                hold on    
            end
        else
            if ismember(ALNS_path{ok}(ok1-1),Customer{1})==1
                route=[ALNS_path{ok}(ok1-1) ALNS_path{ok}(ok1)];
                route_x=Coordinate_x(route)';  
                route_y=Coordinate_y(route)';  
                plot(route_x,route_y,'Color',color1(ok),'LineStyle','-.','LineWidth',2)                 
                grid on;  
                hold on   
            elseif  ismember(ALNS_path{ok}(ok1-1),Customer{2})==1 
                route=[ALNS_path{ok}(ok1-1) ALNS_path{ok}(ok1)];
                route_x=Coordinate_x(route)';  
                route_y=Coordinate_y(route)';  
                plot(route_x,route_y,'Color',color1(ok),'LineStyle','-','LineWidth',2)
                grid on;  
                hold on
            elseif  ismember(ALNS_path{ok}(ok1-1),Customer{3})==1
                route=[ALNS_path{ok}(ok1-1) ALNS_path{ok}(ok1)];
                route_x=Coordinate_x(route)';  
                route_y=Coordinate_y(route)';  
                plot(route_x,route_y,'Color',color1(ok),'LineStyle','-','LineWidth',2)
                grid on;  
                hold on
            end
        end
    end
    
    hold on
    colors2=[112 48 160];
    m1=Charging1;
    m2=Coordinate_x(m1);
    m3=Coordinate_y(m1);
    w1=plot(m2,m3,'^','MarkerEdgeColor',colors2/255,'MarkerFaceColor',colors2/255,'MarkerSize',12); 

    hold on
    colors3=[0 176 240];
    m1=Charging2;
    m2=Coordinate_x(m1);
    m3=Coordinate_y(m1);
    w2=plot(m2,m3,'^','MarkerEdgeColor', colors3/255,'MarkerFaceColor', colors3/255,'MarkerSize',12); 

    hold on
    colors4=[39 139 34];
    m1=Charging3;
    m2=Coordinate_x(m1);
    m3=Coordinate_y(m1);
    w3=plot(m2,m3,'^','MarkerEdgeColor',colors4/255,'MarkerFaceColor',colors4/255,'MarkerSize',12); 

    hold on
    colors5=[255 130 71];
    m1=Customer1;
    m2=Coordinate_x(m1);
    m3=Coordinate_y(m1);
    w4=plot(m2,m3,'o','MarkerEdgeColor',colors5/255,'MarkerFaceColor',colors5/255,'MarkerSize',8);

    hold on
    m1=Customer2;
    m2=Coordinate_x(m1);
    m3=Coordinate_y(m1);
    w5=plot(m2,m3,'o','MarkerEdgeColor','k','MarkerFaceColor','k','MarkerSize',8);

    hold on
    m1=Customer3;
    m2=Coordinate_x(m1);
    m3=Coordinate_y(m1);
    w6=plot(m2,m3,'o','MarkerEdgeColor','m','MarkerFaceColor','m','MarkerSize',8);

    hold on
    colors6=[255 192 0];
    m1=depot;
    m2=Coordinate_x(m1);
    m3=Coordinate_y(m1);
    w7=plot(m2,m3,'s','MarkerEdgeColor',colors6/255,'MarkerFaceColor',colors6/255,'MarkerSize',16); 

end
figure 
it=1:maxIter_Ant;
plot(it,best_fitness)
title('Fitness value curve of total distribution costs','FontName','Times New Roman')
xlabel('Iterations', 'FontSize', 10.5, 'FontName', 'Times New Roman')
ylabel('Objective function value', 'FontSize', 10.5, 'FontName', 'Times New Roman')
end