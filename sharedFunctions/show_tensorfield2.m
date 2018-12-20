function show_tensorfield2( T,im,mult )
%SHOW_TENSORFIELD displays in a new figure the tensor field
%   supplied.
%
%   T is a MxMx2x2 tensor field, the field is displayed in a
%   new figure.
%
%   Returns nothing
%
if nargin<3
    mult=1;
end
    [e1,e2,l1,l2] = convert_tensor_ev(T);
    s= size(im);
    [x,y] = meshgrid(1:s(2),1:s(1));
    figure; imshow(im);hold on,
    quiver(x,y,mult.*e1(:,:,1).*l1,mult.*e1(:,:,2).*l1,'LineWidth',1,'AutoScale','off');
end