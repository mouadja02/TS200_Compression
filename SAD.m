function c = SAD(A,B)
    c = sum(abs(A(:)-B(:)));
end