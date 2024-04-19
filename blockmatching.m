function [Vx,Vy]= blockmatching(I1,I2,bw,bh,fw,fh)
    [hI,wI] = size(I1);
    wV = wI / bw;
    hV = hI / bh;
    Vx = zeros(hV,wV);
    Vy = zeros(hV,wV);
    tw = (0:bw-1);
    th = (0:bh-1);
    for i=1:wV
        for j=1:hV
            x2 = (i-1)*bw+1;
            y2 = (j-1)*bh+1;
            B2 = I2(y2+th,x2+tw);
            crit_min = inf;
            flag = 0;
            u_min = inf;
            v_min = inf;
            for u = (-fw+1)/2:(fw-1)/2
                for v = (-fh+1)/2:(fh-1)/2
                    if (x2+u)>=1 && x2+u+bw-1<=wI && y2+v>=1 && y2+v+bh-1<=hI
                        B1 = I1(y2+v+th,x2+u+tw);
                        crit = SAD(B1,B2);
                        if flag==0 || crit<crit_min
                            flag=1;
                            crit_min = crit;
                            u_min=u;
                            v_min=v;
                    end
                end 
                
                Vx(j,i) = u_min;
                Vy(j,i) = v_min;

            end
        end
    end


end