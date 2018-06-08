function graficadorMalladorH8(nodFisura, elemNew, P)
    % elements(1,:)=[1 2 4 3 5 6 8 7]
    % elements(1,:)=[1 2 3 4 5 6 7 8]
    %
    %       Z
    %       [
    %       [
    %       3----------2
    %      /[         /[
    %     / [        / [
    %    /  [       /  [
    %   4----------1   [
    %   [   [      [   [
    %   [   7------[---6---Y
    %   [  /       [  /
    %   [ /        [ /
    %   [/         [/
    %   8----------5
    %  /
    % X
ploter1=[1 2 3 4];
ploter2=[5 6 7 8];
ploter3=[1 4 8 5];
ploter4=[2 3 7 6];
ploter5=[1 2 6 5];
ploter6=[4 3 7 8];

num_elem=length(elemNew(:,1));

linea=[':'];%['none'];%

for i=1:num_elem
%         axis equal
        fill3([nodFisura(elemNew(i,ploter1),1)], ...
            [nodFisura(elemNew(i,ploter1),2)],[nodFisura(elemNew(i,ploter1),3)],P(elemNew(i,ploter1)),'LineStyle',linea)
        hold on
        fill3([nodFisura(elemNew(i,ploter2),1)], ...
            [nodFisura(elemNew(i,ploter2),2)],[nodFisura(elemNew(i,ploter2),3)],P(elemNew(i,ploter2)),'LineStyle',linea)
        
        fill3([nodFisura(elemNew(i,ploter3),1)], ...
            [nodFisura(elemNew(i,ploter3),2)],[nodFisura(elemNew(i,ploter3),3)],P(elemNew(i,ploter3)),'LineStyle',linea)
        
        fill3([nodFisura(elemNew(i,ploter4),1)], ...
            [nodFisura(elemNew(i,ploter4),2)],[nodFisura(elemNew(i,ploter4),3)],P(elemNew(i,ploter4)),'LineStyle',linea)
        
        fill3([nodFisura(elemNew(i,ploter5),1)], ...
            [nodFisura(elemNew(i,ploter5),2)],[nodFisura(elemNew(i,ploter5),3)],P(elemNew(i,ploter5)),'LineStyle',linea)
        
        fill3([nodFisura(elemNew(i,ploter6),1)], ...
            [nodFisura(elemNew(i,ploter6),2)],[nodFisura(elemNew(i,ploter6),3)],P(elemNew(i,ploter6)),'LineStyle',linea)
end

colorbar

set(gcf,'color','w');

axis off

drawnow

end