function mesh=mesh_gen(type,M,N)
    mesh=zeros(M,N);
    switch type
        case 'sine'
            % genernate sine mesh.
            for i=1:M
                for j=1:N
                    mesh(i,j)=-200+400*sin(pi/4*j+pi/4);
                    if mesh(i,j)<0
                        mesh(i,j)=0;
                    end
                end
            end

        
        case 'rect'
            % generate rectangle mesh.
            for i=1:M
                for j=1:N
                    if mod(j,10)<=3
                        mesh(i,j)=700; %T=10, duty of 3.
                    else
                        mesh(i,j)=0;
                    end
                end
            end
    end
