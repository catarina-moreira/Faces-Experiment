function [ attack ] = find_parameters( )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

t = 0 : 0.01 : 2*pi;

attack = zeros(length(t), 4);

cnt = 1;
for i = 1 : length( t )
    for j = 1 : length( t )
        probability_attack = 0.42 + 0.12 + 2*sqrt(0.42)*sqrt(0.12)*cos( t(i) - t(j) );
        probability_withdraw = 0.18 + 0.28 + 2*sqrt(0.18)*sqrt(0.28)*cos( t(i) - t(j) );
    
        norm_prob = probability_attack + probability_withdraw;
    
        probability_attack = probability_attack / norm_prob;
        
        attack(cnt,:) = [ t(i), t(j), t(i) - t(j), probability_attack  ];
        cnt = cnt + 1;
    end

end

end

