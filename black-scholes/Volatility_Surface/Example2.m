%   EXAMPLE 2
% The purpose of this example is to illustrate how to use VolSurface
% The "localvol" used below will actually be the implied volatility
% So the VolSurface.m here is not used as a way to recover the implied vol 
% from the market prices but rather as a plotting tool.
clc
clear all
close all

% Inputs:
S0=100;
r=5/100;
T=[.25 .25 .25 .25 .25 .5 .5 .5 .5 .5 .75 .75 .75 .75 .75];
K=[90 95 100 105 110 90 95 100 105 110 90 95 100 105 110];

% Compute some arbitrary option prices as a function of strike and 
% Time to maturity :
localvol = inline('min(0.2+5*log(100./K).^2+0.1*exp(-(T)), 0.6)','K','T');
Volatility=localvol(K,T);
CallPrice=blsprice(S0, K, r, T, Volatility);

% Use the VolSurface function:
surface=VolSurface(S0, r, T, K, CallPrice);

 

