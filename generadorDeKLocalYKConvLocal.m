function [k,kTemporal,kAlmacenamiento, kConv]=generadorDeKLocalYKConvLocal(ro,mu,nodFisura,elemNew,bCorr,porosidad,e,b,S,delta_t,Re,beta)
%% inicializador de variables para mejorar velocidad

nod_por_elem=4;
% num_elem=length(elemNew(:,1));
k=zeros(nod_por_elem,nod_por_elem);
% kConv=k;
kTemporal=k;
% kAlmacenamiento=k;
area=0;
ReLocal=zeros(1,nod_por_elem);
espesor=ReLocal;
bLocal=ReLocal;
coord=zeros(nod_por_elem,3);



conductividad=(ro)/(12*mu);

    a   = 1/sqrt(3);
    pg = [ -a  -a
         a  -a
         a   a
        -a   a ];% puntos de gauss
    wpg=ones(4,1);

elem_analizado=e;
    nod_del_elem=elemNew(elem_analizado,:);
    
    for j=1:nod_por_elem
        coord(j,:)=nodFisura(nod_del_elem(j),:);
        bLocal(:,j)=bCorr(nod_del_elem(j),:);
        espesor(:,j)=b(nod_del_elem(j),:);
        ReLocal(:,j)=Re(nod_del_elem(j),:);
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
                v3loc*cos(angulo3) v3loc*sin(angulo3)];%El tema es que los nodos estan en un espacio 3D y hay que pasarlo a un 2D equivalente, este es el transpaso al dominio 2D equivalente
            
                
for i=1:length(pg(:,1))
    r=pg(i,1);
    s=pg(i,2);
%     N(1,:)=1/4*[(1-r)*(1-s) (1+r)*(1-s) (1+r)*(1+s) (1-r)*(1+s)];
    dN(2,:) =1/4*[-(1-r) -(1+r)   1+r    1-r ]; 
    dN(1,:) =1/4*[-(1-s)   1-s   1+s  -(1+s)]; %copypastear Nx o Nr
    
    J=dN*coordLocal;
    dNxy=J\dN;
%     aux=length(dN(1,:));
    
%     B=zeros(2,aux);
    B(2,:) = dNxy(2,:);
    B(1,:) = dNxy(1,:);
    

    k=k+B'*(conductividad*eye(2))*B*det(J)*(bLocal(i).^3)*wpg(i)*(1/(1+beta*ReLocal(i))); %El Reynolds abajo es para corregir con Reynolds altos, desp es flujo entre dos caras paralelas
    
%     kConv(:,:,elem_analizado)=kConv(:,:,elem_analizado)+eye(4)*porosidad*det(J)*wpg(i)*2*0.25;% El *2 es porque el elemento tiene dos caras
    
%     ord=[1 4 3 2];% reordena por los puntos de gauss
    area=area+det(J);
%     
%     if 1>2
%     
%     
% %     ord=[1 2 3 4];% reordena por los puntos de gauss
%     
% %     kTemporal(ord(i),ord(i))=kTemporal(ord(i),ord(i))+(S/delta_t)*det(J)*wpg(i)*espesor(ord(i));
% 
% %     kConv(ord(i),ord(i))=kConv(ord(i),ord(i))+porosidad*det(J)*wpg(i)*2;
%     
%     else
%     
% %     kTemporal=kTemporal+N'*N*(S/delta_t)*det(J)*wpg(i)*espesor(ord(i));
% 
% %     kConv=kConv+N'*N*porosidad*det(J)*wpg(i)*2;%
% %     kConv=kConv+B'*B*porosidad*det(J)*wpg(i)*2;
%     
%     end
    
end
% disp(['Area del elemento:' num2str(area)])
% kTemporal=kTemporal+N'*N*(S/delta_t)*det(J)*wpg(i)*espesor(ord(i));
% kConv
for i=1:4
kTemporal(i,i)=kTemporal(i,i)+(S/delta_t)*area*0.25;%*espesor(i);
end
kConv=eye(4)*porosidad*area*0.25*2;%Si tinene un por 2 es porque tiene en cuenta las dos caras, por esa razon se multiplica el area
kAlmacenamiento=eye(4)*area*0.25*(ro/delta_t);
end