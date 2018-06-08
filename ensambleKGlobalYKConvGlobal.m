function [K,KTemporal, KAlmacenamiento, KConv]=ensambleKGlobalYKConvGlobal(ro,mu,nodFisura,elemNew,bCorr,porosidad,selectorLogico,num_nod,b,S,delta_t,Re,beta)

num_elem=length(elemNew(:,1));
nod_por_elem=4;


K=sparse(num_nod,num_nod);

KConv=sparse(num_nod,num_nod);

KTemporal=sparse(num_nod,num_nod);

KAlmacenamiento=sparse(num_nod,num_nod);

for e=1:num_elem
    if selectorLogico(e)==true
        %% Obtencion de k y kConv local
        
        [k,kTemporal, kAlmacenamiento, kConv]=generadorDeKLocalYKConvLocal(ro,mu,nodFisura,elemNew,bCorr,porosidad,e,b,S,delta_t,Re,beta);
        
        %% Ensamble de K
        
        node_el=zeros(1,nod_por_elem);
        node_el(1:nod_por_elem)=elemNew(e,:);
        K(node_el,node_el)=K(node_el,node_el)+k;

        %% Ensamble de K_conv

        node_el=zeros(1,nod_por_elem);
        node_el(1:nod_por_elem)=elemNew(e,:);
        KConv(node_el,node_el)=KConv(node_el,node_el)+kConv;
        
        %% Ensamble de K Temporal y K Almacenamiento

        node_el=zeros(1,nod_por_elem);
        node_el(1:nod_por_elem)=elemNew(e,:);
        KTemporal(node_el,node_el)=KTemporal(node_el,node_el)+kTemporal;
        KAlmacenamiento(node_el,node_el)=KAlmacenamiento(node_el,node_el)+kAlmacenamiento;
        
    end
end
end