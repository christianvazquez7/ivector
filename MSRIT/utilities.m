function [score] = cosineScore(a,b)
        dotprod = dot(a,b);
        na = norm(a);
        nb = norm(b);
        score = dotprod/(a*b);


