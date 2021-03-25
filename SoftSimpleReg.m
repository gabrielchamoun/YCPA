winstyle = 'docked';
% winstyle = 'normal';

close all
set(0,'DefaultFigureWindowStyle',winstyle)
set(0,'defaultaxesfontsize',18)
set(0,'defaultaxesfontname','Times New Roman')
% set(0,'defaultfigurecolor',[1 1 1])

% Question 2.a) ***********************************************************
%   SoftSimpleReg.m initializes a 2D FDFT simulation. A travelling wave's 
%   boundary conditions is set up along with RunYeeReg.m which then 
%   proceeds to solve the 2D region in TE mode using standard Yee cells.
% *************************************************************************

% Question 2.b) ***********************************************************
%   i)  Commenting out the line " epi{1}(125:150,55:95)= c_eps_0*11.3; "
%       will remove the region with a larger permittivity. The simulation
%       still works; however, without the region the wave is uninterrupted
%       until it hits the xmax boundary.
%
%   ii) The bc structure contains the boundary conditions for the region.
%       In addition it also holds the planewave properties and the function
%       call to PlaneWaveBC which creates the traveliing wave.
%
%   iii)bc{1}.s(1) is setting up the plane wave and its BC's. Changing the
%       bc{1}.s(1).type from 's' to  'p' changing the nature of the source.
%       Changing bc{1}.s(1).s from 0 to 1 creates positive feedback as
%       the source is constantly regenerated. Other properties will change
%       more about the location of the source, the magnitude etc.
%
%   iv) bc{1}.xm/xp/ym/yp affect the nature of the interfaces between 
%       permittivities. These boundary conditions will dictate if the wave
%       is reflected, dispersed or attenuated. Changing bc{1}.xp from 'a'
%       to 'e' causes the wave to reflect inside the inclusion area defined
% *************************************************************************

% Question 3 **************************************************************
%   a)  Adding more inclusions to create a slight grate int the waves path.
%   b)  Changing the s't' parameter added a periodic or pulsing of the wave
%   c)  Doubling the frequency completely changed the result. The wave was
%       being completely refelcted on the interface of the inclusions. This
%       created are very simple double slit problem with the current config
% *************************************************************************

% Question 4 **************************************************************
%   creates the shape of an H which was interesting at varying f values.   
%   epi{1}(50:75,55:95)= c_eps_0*11.3;
%   epi{1}(75:125,70:80)= c_eps_0*11.3;
%   epi{1}(125:150,55:95)= c_eps_0*11.3;
% *************************************************************************




% clear VARIABLES;
clear
global spatialFactor;
global c_eps_0 c_mu_0 c_c c_eta_0
global simulationStopTimes;
global AsymForcing
global dels
global SurfHxLeft SurfHyLeft SurfEzLeft SurfHxRight SurfHyRight SurfEzRight


% Setting up sim

dels = 0.75;
spatialFactor = 1;

c_c = 299792458;                  % speed of light
c_eps_0 = 8.8542149e-12;          % vacuum permittivity
c_mu_0 = 1.2566370614e-6;         % vacuum permeability
c_eta_0 = sqrt(c_mu_0/c_eps_0);


tSim = 200e-15
f = 460e12;
lambda = c_c/f;

xMax{1} = 20e-6;
nx{1} = 200;
ny{1} = 0.75*nx{1};

% Setting up region properties
Reg.n = 1;

mu{1} = ones(nx{1},ny{1})*c_mu_0;

epi{1} = ones(nx{1},ny{1})*c_eps_0;

% Added inclusions
epi{1}(90:110,35:55)= c_eps_0*11.3;
epi{1}(90:110,65:85)= c_eps_0*11.3;
epi{1}(90:110,95:115)= c_eps_0*11.3;

sigma{1} = zeros(nx{1},ny{1});
sigmaH{1} = zeros(nx{1},ny{1});

dx = xMax{1}/nx{1};
dt = 0.25*dx/c_c;
nSteps = round(tSim/dt*2);
yMax = ny{1}*dx;
nsteps_lamda = lambda/dx

% Setting up plot settings
movie = 1;
Plot.off = 0;
Plot.pl = 0;
Plot.ori = '13';
Plot.N = 100;
Plot.MaxEz = 1.1;
Plot.MaxH = Plot.MaxEz/c_eta_0;
Plot.pv = [0 0 90];
Plot.reglim = [0 xMax{1} 0 yMax];

% Boundary conditions initializing
bc{1}.NumS = 1;
bc{1}.s(1).xpos = nx{1}/(4) + 1;
bc{1}.s(1).type = 'ss';
bc{1}.s(1).fct = @PlaneWaveBC;
% mag = -1/c_eta_0;
mag = 1;
phi = 0;
omega = f*2*pi;
betap = 0;
t0 = 30e-15;
% st = 15e-15;
st = -0.05; % set to create periodic excitation of the magnitude.
s = 0;
y0 = yMax/2;
sty = 1.5*lambda;
bc{1}.s(1).paras = {mag,phi,omega,betap,t0,st,s,y0,sty,'s'};

Plot.y0 = round(y0/dx);

bc{1}.xm.type = 'a';
bc{1}.xp.type = 'e';
bc{1}.ym.type = 'a';
bc{1}.yp.type = 'a';

pml.width = 20 * spatialFactor;
pml.m = 3.5;

Reg.n  = 1;
Reg.xoff{1} = 0;
Reg.yoff{1} = 0;

RunYeeReg






