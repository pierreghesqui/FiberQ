function im = imReadDv(path)

data = bfopen(path);
channels = data{1}(:,1);
nbChannels =size(channels,1);

if nbChannels == 1
    Channel1 = channels{1};
    Channel2 = zeros(size(Channel1));
    Channel3 = zeros(size(Channel1));
    
elseif nbChannels == 2
    Channel1 = channels{1};
    Channel2 = channels{2};
    Channel3 = zeros(size(Channel1));
    %figure; imshow(cat(3,redCldU,greenIdU,blue));
    
elseif nbChannels ==3
    Channel1 = channels{1};
    Channel2 = channels{2};
    Channel3 = channels{3};
    %figure; imshow(cat(3,redCldU,greenIdU,blue));

end

    im = cat(3,Channel1,Channel2,Channel3);%figure; imshow(double(im),[])
    
end