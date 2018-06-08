function [Velocidad,Re]=calculoDeVelocidad(ro, mu,nodFisura,elemNew, bCorr, b, P,selectorLogico,num_nod, versorGravedad,g)
P=P-(versorGravedad(1)*nodFisura(:,1)+versorGravedad(2)*nodFisura(:,2)+versorGravedad(3)*nodFisura(:,3))*(ro*g);
    
nod_por_elem=4;
num_elem=length(elemNew(:,1));
RE=zeros(num_nod,2);
espesor=zeros(1,nod_por_elem);
bLocal=espesor;
presion=espesor';
coord=zeros(nod_por_elem,3);


%% Calculo de velocidades

conductividad=(ro)/(12*mu);

a   = 1;%/sqrt(3);
puntos_eval_velocidades=[-a  -a
                          a  -a
                          a   a
                         -a   a ];% puntos de gauss
count=0;
for elem_analizado=1:num_elem
    if selectorLogico(elem_analizado)==true
        count=count+1;
    nod_del_elem=elemNew(elem_analizado,:);
    
    
    for j=1:nod_por_elem
        coord(j,:)=nodFisura(nod_del_elem(j),:);
        bLocal(:,j)=bCorr(nod_del_elem(j),:);
        espesor(:,j)=b(nod_del_elem(j),:);
        presion(j,1)=P(nod_del_elem(j));%OJO NO ESTA EN EL PASTE!!
    end
    
    vector1=coord(2,:)-coord(1,:);
    vector2=coord(3,:)-coord(1,:);
    vector3=coord(4,:)-coord(1,:);
    
    angulo2=atan2(norm(cross(vector1,vector2)), dot(vector1,vector2));
    angulo3=atan2(norm(cross(vector1,vector3)), dot(vector1,vector3));
    
    v1loc=norm(vector1);
    v2loc=norm(vector2);
    v3loc=norm(vector3);
    
    coordLocal=[0 0
                v1loc 0
                v2loc*cos(angulo2) v2loc*sin(angulo2)
                v3loc*cos(angulo3) v3loc*sin(angulo3)];
    vector4=cross(vector1,vector3);
    vector4=vector4/norm(vector4);
    
        vector5=cross(vector4,vector1);
        vector5=vector5/norm(vector5);
    
    
    for i=1:length(puntos_eval_velocidades(:,1))
        r=puntos_eval_velocidades(i,1); %OJO!!! ASEGURARSE QUE SON PUNTOS DE EVAL!!!
        s=puntos_eval_velocidades(i,2);
        dN(1,:) =1/4*[-(1-s)   1-s   1+s  -(1+s)]; %copypastear Nx o Nr
        dN(2,:) =1/4*[-(1-r) -(1+r)   1+r    1-r ]; 
        J=dN*coordLocal;
        dNxy=J\dN;
        aux=length(dN(1,:));
        B=zeros(2,aux);
        B(1,:) = dNxy(1,:);
        B(2,:) = dNxy(2,:);
        
        velocidad(:,i,count)=((conductividad*eye(2))*B*(bLocal(i).^2)*presion)/ro;
        
        Velocidad(:,i,count)=velocidad(1,i,count)*(vector1/norm(vector1))+velocidad(2,i,count)*vector5;
        
        Velocidad(:,i,count)=-round(Velocidad(:,i,count),11);
        
%         b(i)
        
        re(i,:,count)=(ro*bLocal(i).*norm(Velocidad(:,i,count)))/mu;
        
        
        
    end
    
    RE(nod_del_elem,:)=RE(nod_del_elem,:)+[re(:,:,count) ones(4,1)];
    end
end

Re=RE(:,1)./(RE(:,2)+eps);
end