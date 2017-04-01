function [ xlimits, ylimits ] = plot_radial_psd(nu1, Pf1, nu2, Pf2)
% function raPsd2d(img,res)
%
% Plots radially averaged power spectral density (power
% spectrum) of image with spatial resolution RES.
%s
% (C) E. Ruzanski, RCG, 2009

% Compute the limits for additional plotting needs. The limits are solely
% for the input image and not the synthetic.
xlimits = [ min(nu1), max(nu1) ];
ylimits = [ min(Pf1), max(Pf1) ];

% Generate plot
%if ~isempty(figure_number),
  
    % Open a new figure.
  % figure;% (figure_number);
  fontSize = 14;
  % set(gcf, 'Position', [36 676 560 420], 'Color', [1 1 1]);
  
  % Multi Plot for Input Image and Clutter
  loglog(nu1,Pf1,'k-','LineWidth',2.0,'DisplayName','Original');
  hold on;
  loglog(nu2,Pf2,'r-','LineWidth',2.0,'DisplayName','Synthetic');
  hold off;
  
  legend('show');
  
  % Other plotting
  set(gcf,'color','white');
  set(gca,'FontSize',fontSize,'FontWeight','bold');
  set(gca,'xlim',xlimits,'ylim',ylimits);
  grid on;
  xlabel('Cycles/km','FontSize',fontSize,'FontWeight','Bold');
  ylabel('Power','FontSize',fontSize,'FontWeight','Bold');
  title('Radially averaged power spectrum','FontSize',fontSize,'FontWeight','Bold')
%end;

return;