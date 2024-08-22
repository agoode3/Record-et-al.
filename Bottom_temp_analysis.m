%% Use GLORYS12 to Characterize Benthic Temperatures Across the NW Atlantic

% Created 16 August 2024 by Andrew Goode

%% Below are the links to GLORYS12 on COPERNICUS

% https://data.marine.copernicus.eu/product/GLOBAL_MULTIYEAR_PHY_001_030/description
% https://data.marine.copernicus.eu/product/GLOBAL_MULTIYEAR_PHY_001_030/download?dataset=cmems_mod_glo_phy_my_0.083deg_P1M-m_202311
    % Sea water potential temperature at sea floor

%% Below are the links to MOM6 on CEFI

% https://psl.noaa.gov/cefi_portal/

%% Load Model Data

% GLORYS12 Monthly
load('C:\Users\agood\Documents\MATLAB\Everything\Record et al\GLORYS12_M_1993to2020.mat')

% GLORYS12 Daily
load('C:\Users\agood\Documents\MATLAB\Everything\Record et al\GLORYS12_D_1993to2020.mat')

% MOM6
% load('C:\Users\agood\Documents\MATLAB\Everything\Record et al\MOM6_1993to2019.mat')

%% Load Geographic Coordinates

load('C:\Users\agood\Documents\MATLAB\Everything\Record et al\Boundaries.mat')

%% Map Zone Boundaries

m_proj('lambert','long',[-81 -53],'lat',[34.99 65.01],'rectbox','on');

figure
hold on
box on

for i=1:13

    m_plot(Boundaries.Lon{i,:},Boundaries.Lat{i,:})

end

m_gshhs_f('patch',[0.8,0.8,0.8])
m_grid('linestyle','none','fontsize',12,'fontweight','Bold','ytick',40:10:60,'xtick',-80:10:-50)

clear i

%% Find Model Locations Within Each Geographic Regions

for i=1:13

    OUT(i).region=Boundaries.name(i); %#ok<SAGROW>

    OUT(i).loc=find(inpolygon(DATA.LON,DATA.LAT,cell2mat(Boundaries.Lon(i)),cell2mat(Boundaries.Lat(i)))==1 & DATA.temp(:,:,1)>-9999); %#ok<SAGROW>

end

clear i

%% Plot Model Locations Within Each Geographic Region

m_proj('lambert','long',[-81 -53],'lat',[34.99 65.01],'rectbox','on');

figure
hold on
box on

for i=1:13

    [x,y]=m_ll2xy(DATA.LON(OUT(i).loc),DATA.LAT(OUT(i).loc));
    scatter(x,y,8,'o','filled')

end


m_gshhs_f('patch',[0.8,0.8,0.8])
m_grid('linestyle','none','fontsize',12,'fontweight','Bold','ytick',40:10:60,'xtick',-80:10:-60)

clear i x y

%% Calculate Average Temperature Per Region 

for i=1:13

    for m=1:length(DATA.temp(1,1,:))

        temp=DATA.temp(:,:,m);

        OUT(i).avg(m,1)=nanmean(temp(OUT(i).loc)); %#ok<NANMEAN>

    end

end

clear i m temp

%% MONTHLY DATA 

%% Calculate Annual Min, Avg, and Max for Each Region

l=length(DATA.temp(1,1,:));

ll=1:12:l;
ul=12:12:l;

ll_summer=7:12:l;
ul_summer=9:12:l;

for i=1:13
    for y=1:length(ul)
    
        OUT(i).m_min(y,1)=min(OUT(i).avg(ll(y):ul(y)));
        OUT(i).m_avg(y,1)=mean(OUT(i).avg(ll(y):ul(y)));
        OUT(i).m_max(y,1)=max(OUT(i).avg(ll(y):ul(y)));

        OUT(i).m_summer_avg(y,1)=mean(OUT(i).avg(ll_summer(y):ul_summer(y)));
    
    end
end

clear i y ll ul

%% Plot Results

% Load Region Labels
load('C:\Users\agood\Documents\MATLAB\Everything\Record et al\region_labels.mat')

for i=1:13

    test(i,:)=OUT(i).avg'; %#ok<SAGROW>

    test_min(i,:)=OUT(i).m_min'; %#ok<SAGROW>
    test_avg(i,:)=OUT(i).m_avg'; %#ok<SAGROW>
    test_max(i,:)=OUT(i).m_max'; %#ok<SAGROW>

    test_summer(i,:)=OUT(i).m_summer_avg'; %#ok<SAGROW>

end


figure
title('Annual Average')
hold on
box on
contourf(test_avg(1:12,:),0:2:15)
axis ij
c=colorbar;
set(c,'YTick',0:2:12)
y=ylabel(c,'Temperature ^oC');
set(y,'FontWeight','bold')
xlim([-2 28])
set(gca,'XTick',-2:5:28,'XTickLabel',1990:5:2020)
set(gca,'FontWeight','bold','FontSize',12)
set(gca,'YTick',1:13,'YTickLabel',labels(:,2))

figure
title('Annual Max')
hold on
box on
contourf(test_max(1:12,:),0:3:21)
axis ij
c=colorbar;
set(c,'YTick',0:3:21)
y=ylabel(c,'Temperature ^oC');
set(y,'FontWeight','bold')
xlim([-2 28])
set(gca,'XTick',-2:5:28,'XTickLabel',1990:5:2020)
set(gca,'FontWeight','bold','FontSize',12)
set(gca,'YTick',1:13,'YTickLabel',labels(:,2))


%% DAILY DATA

%% Calculate Annual Min, Avg, and Max for Each Region

l=length(DATA.temp(1,1,:));

ll=1:365:l;
ul=365:365:l;

ll_summer=183:365:l;
ul_summer=274:365:l;

for i=1:13
    for y=1:length(ul)
    
        OUT(i).m_min(y,1)=min(OUT(i).avg(ll(y):ul(y)));
        OUT(i).m_avg(y,1)=mean(OUT(i).avg(ll(y):ul(y)));
        OUT(i).m_max(y,1)=max(OUT(i).avg(ll(y):ul(y)));

        OUT(i).m_summer_avg(y,1)=mean(OUT(i).avg(ll_summer(y):ul_summer(y)));

        OUT(i).days12(y,1)=length(find(OUT(i).avg(ll(y):ul(y))>12));
        OUT(i).days20(y,1)=length(find(OUT(i).avg(ll(y):ul(y))>20));
    
    end
end

clear i y ll ul

%% Plot Results

% Load Region Labels
load('C:\Users\agood\Documents\MATLAB\Everything\Record et al\region_labels.mat')

for i=1:13

    test(i,:)=OUT(i).avg'; 

    test_min(i,:)=OUT(i).m_min'; 
    test_avg(i,:)=OUT(i).m_avg'; 
    test_max(i,:)=OUT(i).m_max'; 

    test_summer(i,:)=OUT(i).m_summer_avg'; 

    test_days12(i,:)=OUT(i).days12'; %#ok<SAGROW>
    test_days20(i,:)=OUT(i).days20'; %#ok<SAGROW>

end


figure
title('Annual Average')
hold on
box on
contourf(test_avg(1:12,:),0:2:15)
axis ij
c=colorbar;
set(c,'YTick',0:2:12)
y=ylabel(c,'Temperature ^oC');
set(y,'FontWeight','bold')
xlim([-2 28])
set(gca,'XTick',-2:5:28,'XTickLabel',1990:5:2020)
set(gca,'FontWeight','bold','FontSize',12)
set(gca,'YTick',1:13,'YTickLabel',labels(:,2))

figure
title('Annual Max')
hold on
box on
contourf(test_max(1:12,:),0:3:21)
axis ij
c=colorbar;
set(c,'YTick',0:3:21)
y=ylabel(c,'Temperature ^oC');
set(y,'FontWeight','bold')
xlim([-2 28])
set(gca,'XTick',-2:5:28,'XTickLabel',1990:5:2020)
set(gca,'FontWeight','bold','FontSize',12)
set(gca,'YTick',1:13,'YTickLabel',labels(:,2))

figure
title('Summer Average')
hold on
box on
contourf(test_summer(1:12,:),0:3:21)
axis ij
c=colorbar;
set(c,'YTick',0:3:21)
y=ylabel(c,'Temperature ^oC');
set(y,'FontWeight','bold')
xlim([-2 28])
set(gca,'XTick',-2:5:28,'XTickLabel',1990:5:2020)
set(gca,'FontWeight','bold','FontSize',12)
set(gca,'YTick',1:13,'YTickLabel',labels(:,2))

figure
title('Days >12 ^oC')
hold on
box on
contourf(test_days12,0:30:360)
axis ij
c=colorbar;
set(c,'YTick',0:30:360)
y=ylabel(c,'Days >12 ^oC');
set(y,'FontWeight','bold')
xlim([-2 28])
set(gca,'XTick',-2:5:28,'XTickLabel',1990:5:2020)
set(gca,'FontWeight','bold','FontSize',12)
set(gca,'YTick',1:13,'YTickLabel',labels(:,2))

figure
title('Days >20 ^oC')
hold on
box on
contourf(test_days20,0:30:360)
axis ij
c=colorbar;
set(c,'YTick',0:30:360)
y=ylabel(c,'Days >20 ^oC');
set(y,'FontWeight','bold')
xlim([-2 28])
set(gca,'XTick',-2:5:28,'XTickLabel',1990:5:2020)
set(gca,'FontWeight','bold','FontSize',12)
set(gca,'YTick',1:13,'YTickLabel',labels(:,2))



