function loadgpx(fileName,varargin)
%LOADGPX Loads route points from a GPS interchange file
% ROUTE = LOADGPX(FILENAME) Loads route point information from a .GPX
%   GPS interchange file.  This utility is not a general-purpose
%   implementation of GPX reading and is intended mostly for reading the
%   files output by the "gmap pedometer" tool.  
% 
% ROUTE is a Nx6 array where each row is a route point.
%   Columns 1-3 are the X, Y, and Z coordinates.
%   Columns 4-5 are latitude and longitude
%   Column  6 is cumulative route length.
%
% Note that the mapping of latitude/longitude assumes an approximate spherical
% transformation to rectangular coordinates.  
%
% Additional property/value arguments:
%   LOADGPX(...,'ElevationUnits','meters',...) uses meters for elevation
%   LOADGPX(...,'Viz',true,...) displays the route and elevation map
%
%   For more information on the gmap pedometer and GPX output:
%     http://www.gmap-pedometer.com/
%     http://www.elsewhere.org/journal/gmaptogpx/
%
% See also xmlread

%Column identifiers
COL_X   = 1;
COL_Y   = 2;
COL_Z   = 3; 
COL_LAT = 4;
COL_LNG = 5;
COL_DST = 6;


elevationUnits = 'feet';
viz = false;
for i=1:2:length(varargin)-1
    switch lower(varargin{i})
        case 'elevationunits'
            elevationUnits = varargin{i+1};
        case 'viz'
            viz = varargin{i+1};
        otherwise
            error('loadgpx:unrecognized_input','Unrecognized argument "%s"',...
                varargin{i});
    end
end

d = xmlread(fileName);

if ~strcmp(d.getDocumentElement.getTagName,'gpx')
    warning('loadgpx:formaterror','file is not in GPX format');
end


ptList = d.getElementsByTagName('rtept');
ptCt = ptList.getLength;

route = nan(ptCt,5);
for i=1:ptCt
    pt = ptList.item(i-1);
    try
        route(i,COL_LAT) = str2double(pt.getAttribute('lat'));
    catch
        warning('loadgpx:bad_latitude','Malformed latitutude in point %i.  (%s)',i,lasterr);
    end
    try
        route(i,COL_LNG) = str2double(pt.getAttribute('lon'));
    catch
        warning('loadgpx:bad_longitude','Malformed longitude in point %i.  (%s)',i,lasterr);
    end
    
    ele = pt.getElementsByTagName('ele');
    if ele.getLength>0
        try
            route(i,COL_Z) = str2double(ele.item(0).getTextContent);
        catch
            warning('loadgpx:bad_elevation','Malformed elevation in point %i.  (%s)',i,lasterr);
        end
    end
    
end

route(:,[COL_Y,COL_X]) = route(:,[COL_LAT,COL_LNG]) - ones(ptCt,1)*route(1,COL_LAT:COL_LNG);


switch elevationUnits
    case 'feet'
        MILES_PER_ARCMINUTE = 1.15;
        route(:,COL_X:COL_Y) = MILES_PER_ARCMINUTE*5280*60*route(:,COL_X:COL_Y);
        distMult = 1/5280;
        %distName = 'miles';
    case 'meters'
        KM_PER_ARCMINUTE = 1.86;
        route(:,COL_X:COL_Y) = KM_PER_ARCMINUTE*5280*60*route(:,COL_X:COL_Y);
        distMult = 1/1000;
        %distName = 'km';
    otherwise
        error('loadgpx:bad_unit','unrecognized unit type "%s"',elevationUnits);
end


if viz
    %cumulative distance - calculate including the elevation hypotenuse
    route(1,COL_DST) = 0;
    route(2:end,COL_DST) = sqrt(sum((route(1:end-1,COL_X:COL_Z)-route(2:end,COL_X:COL_Z)).^2,2));
    route(:,COL_DST) = cumsum(route(:,COL_DST));
    
    %calculate total elevation gain
    deltaZ=route(2:end,COL_Z)-route(1:end-1,COL_Z);
    deltaZ=sum(deltaZ(deltaZ>0));
    
    minZ = min(route(:,COL_Z));
    
    clf
    set(gcf,'color','white','name',sprintf('loadgpx - %s',fileName));
    ax2=axes('outerposition',[0 0 1 .3],'nextplot','add');
    plot(distMult*route(:,COL_DST),route(:,COL_Z),...
        'k-','linewidth',2,...
        'parent',ax2)
    area(distMult*route(:,COL_DST),route(:,COL_Z),...
        'parent',ax2)
    
    set(ax2,...
        'box','on',...
        'color','none',...
        'xtickmode','auto',...
        'ylim',[.9*minZ,1.1*max(route(:,COL_Z))],...
        'xlim',distMult*[min(route(:,COL_DST)) max(route(:,COL_DST))]);
    ylabel(elevationUnits);
    title(sprintf('cumulative elevation gain = %i %s',round(deltaZ),elevationUnits))
    
    ax2=axes('outerposition',[0 .3 1 .7],'nextplot','add');
    
    
    plot3(distMult*route(:,1),distMult*route(:,2),route(:,3),'k-',...
        'linewidth',2);
    
    hr=trisurf(...
        [[(1:ptCt-1)',(2:ptCt)',(ptCt+1:ptCt+ptCt-1)'];[(ptCt+1:ptCt+ptCt-1)',1+(ptCt+1:ptCt+ptCt-1)',(2:ptCt)']],...
        distMult*[route(:,COL_X);route(:,COL_X)],...
        distMult*[route(:,COL_Y);route(:,COL_Y)],...
        [route(:,COL_Z);minZ*ones(size(route(:,COL_Z)))],...
        'facecolor','b',...
        'edgecolor','none',...
        'facealpha',.8);
    
    deltaXYZ = max(route(:,COL_X:COL_Z))-min(route(:,COL_X:COL_Z));
    
    set(ax2,...
        'box','on',...
        'dataaspectratio',[1 1 2*deltaXYZ(3)/(distMult*max(deltaXYZ(1:2)))]);
    axis(ax2,'tight');
end
    
    
    
