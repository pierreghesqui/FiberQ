function [withBlue, h,RedL,x] = BuildRedLengthHisto (infoStrand)

withBlue =0;
[h,RedL,x] = globalHist(infoStrand);
% fig =figure('visible','off');
% bar(x(1:end-1),h),title({'histogram of the Red strand length',...
%     ['Mean : ' num2str(mean(RedL),2) 'pixels'],...
%     ['Mean without Zeros : ' num2str(mean(RedL(RedL~=0)),2) 'pixels'],['nb of Strands = ' num2str(numel(infoStrand)) ]});
% ylabel('number of strands');

end