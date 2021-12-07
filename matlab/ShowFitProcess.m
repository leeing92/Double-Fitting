function [ ] = ShowFitProcess( RenderedIm,x0,y0,r,X, Line2fit,result, Angle,fitresult,Method )
 %Display result
                figure(4);
                subplot(4,6,[1:4,7:10,13:16,19:22]);
                 imshow(RenderedIm,[]);
                colormap (gray);
                freezeColors;
                hold on
                rectangle('position',[y0-r,x0-r,2*r,2*r],'LineWidth',2, 'EdgeColo','y');
                hold off
               set(gca,'looseInset',[0 0 0 0])
                subplot(4,6,[17 18 23 24]);
                h=plot(fitresult, X', Line2fit' );
                a=get(gca);
                x=a.XLim;
                y=a.YLim;
                k=[0.5 0.65];
                textx=x(1)+k(1)*(x(2)-x(1));
                texty=y(1)+k(2)*(y(2)-y(1));
                set(h,'MarkerSize',16,'LineWidth',2);
                set(gca,'FontSize',16,'LineWidth',2);
                ylabel('Normalized Intensity','FontSize',16,'FontWeight','bold');
                xlabel('Distance (nm)','FontSize',16,'FontWeight','bold');
                text(textx,texty,[num2str(result),' nm'],'FontSize',16,'FontWeight','bold');
                subplot(4,6,[5 6 11 12]);
                MixPicLine(RenderedIm,-Angle, r, x0,y0,'w');

end

