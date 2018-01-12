function [move_counter, mov_P] = Heuristica_Caserta_2012(P)
N=max(max(P));
mov_P=cell(1,N);
move_counter=0;
    for n=1:N
        mov_P{n}=P;
        [row_n,col_n] = find(P==n); % linha e coluna onde est� o cont�iner objetivo n
       if ((row_n-1 == 0) || (P(row_n-1,col_n) == 0)) % se n est� no topo ou se a posi��o acima � vazia.
           
       else
            R = quem_acima_Heuristica_Caserta(P,n); % Definindo a quantidade de blocos acima de n.
            for j=1:length(R) % come�ando a movita��o dos blocos que devem ser remanejados.
                r=R(j); % bloco a ser movido de acordo com a pol�tica LIFO.
                [linha_r,coluna_r]=find(P==r);
                % Para determinar onde r deve ser realocado, � feita uma medida de
                % atratividade de cada coluna
                prioridade=zeros(1,size(P,2));
                for k=1:size(P,2) %Para k de 1 at� o n�mero de colunas.
                    TF=isempty(find(P(:,k)==0, 1));
                    if TF==0 && k~=col_n % s� me�o a prioridade das colunas n�o cheias e das colunas diferentes da coluna onde o bloco n est�.
                        X=P(:,k);    
                        x=min(X(X>0));
                        if  isempty(x) % se a coluna est� vazia, min(i)=N+1
                            prioridade(1,k)=N+1;
                           % prioridade(2,k)=k;
                        else
                            prioridade(1,k)=x; % valor do menor cont�iner da coluna k
                          %  prioridade(2,k)=k;
                        end
                    end
                end
                for h=1:size(prioridade,2)
                    min_i=min(prioridade(prioridade>0));
                    max_i=max(prioridade);
                    if min_i>r % se satisfeita a condi��o, ent�o colocar r nessa coluna n�o vai gerar nenhum movimento adicional.
                       [~,col] = find(prioridade==min_i);
                       col=col(1);
                       [P] = trocar_Heuristica_Caserta(P,col,r,linha_r,coluna_r); % Remanejar r
                       move_counter=move_counter+1;
                       break
                    else    
                       [~,col] = find(prioridade==max_i);
                       col=col(1);
                       [P] = trocar_Heuristica_Caserta(P,col,r,linha_r,coluna_r); % Remanejar r
                        move_counter=move_counter+1;
                        break
                    end
                    
                end
            end   
        end
        % Depois de realocar todos os cont�ineres que estavam acima do
        % cont�iner n, n pode ser retirado.
        P(row_n,col_n)=0;   
    end
end