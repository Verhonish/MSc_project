clc;
clear all;
ax_ext=readmatrix(['/Users/vaishnavipatil/Library/CloudStorage/' ...
    'OneDrive-UniversityCollegeLondon/Individual_project/' ...
    'ls_d_validation/water_impact_loads']);
t1=ax_ext(:,1);
ax1=ax_ext(:,2);
ax1=9810*ax1(ax1~= 0);
t2=ax_ext(:,7);
t2=t2(~isnan(t2));
ax2=ax_ext(:,8);
ax2=9810*ax2(~isnan(ax2));
t3=ax_ext(:,9);
t3=t3(~isnan(t3));
ax3=ax_ext(:,10);
ax3=9810*ax3(~isnan(ax3));
t4=ax_ext(:,17);
t4=t4(~isnan(t4));
ax4=ax_ext(:,18);
ax4=9810*ax4(~isnan(ax4));
dt=0.25*(1/999);
t=[0:dt:0.25]';
%ax_0deg=interp1(t1,ax1,t);
%ax_20deg=interp1(t2,ax2,t);
%ax_30deg=interp1(t3,ax3,t);
ax_40deg=interp1(t4,ax4,t);