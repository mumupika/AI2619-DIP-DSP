%   Define filter as:
%%  Ideal,Batwose,Gauss.
%------------------------------
function H=myfilter(type1,type2,M,N,D0,n,w)
    % define the ideal low filter.
    u=single(1:M);
    v=single(1:N);
        %indices for use.
    idx=find(u>M/2);
    u(idx)=u(idx)-M;
    idy=find(v>N/2);
    v(idy)=v(idy)-N;
    [V,U]=meshgrid(v,u);
    D=hypot(U,V);
    switch type1
        case 'low_pass'
            switch type2
                case 'ideal'
                    H=single(D<=D0);
                case 'btw'
                    if nargin==4
                        n=1;
                    end
                    H=1./(1+(D./D0).^(2*n));
                case 'gaussian'
                    H=exp(-(D.^2)./(2*D0^2));
                otherwise
                    error('Filter type not defined');
            end
        
        case 'band_pass'
            switch type2
                case 'ideal'
                    RI=D<=D0-(w/2);
                    RO=D>=D0+(w/2);
                    H=single(RI | RO);
                case 'btw'
                    H=1./(1+(((D.*w)./(D.^2-D0.^2)).^(2*n)));
                case 'gaussian'
                    H=1-exp(-((D.^2-D0.^2)./(D.*w+eps)).^2);
                otherwise
                    error('Filter type not defined');
            end
            H=1-H;
    end
    H=complex(H);