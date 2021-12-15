%Image filtering
clear all; clc;close all
image_title_list = {'gray.jpg','blurry.png'};
filter_name={'LPF1','LPF2','Spatial','HPEnhanced1','sharpning','ShiftLeft','LaplacianScaled','LPHPEnhanced2'};
filter{1} = [1 1 1; 1 1 1; 1 1 1]/9;% Low Pass Filter 1
filter{2} = [1 2 1; 2 4 2; 1 2 1]/16;% Low Pass Filter 2
filter{3} = [1 1 1; 1 -8 1; 1 1 1];% Spatial Filter
filter{4} = [-1 -1 -1; -1 8 -1; -1 -1 -1];% High Pass Filter1
filter{5} = [0 -1 0; -1 5 -1; 0 -1 0];% sharpning
filter{6} = [0 0 0; 0 0 1; 0 0 0];% shift left
filter{7} = [-1 -1 -1; -1 8 -1; -1 -1 -1];% Laplacian for LaplacianScaled
filter{8} = [-1 -1 -1; -1 8 -1; -1 -1 -1];% High Pass Filter 2 for LPHPEnhanced2
for imgfls = 1:length(image_title_list)%loop for every image
     %read the contents of each image into original_image_content
     %original_image_content is the content of each image file
     %image_title_list is a list of the title of each image file
     original_image_content = im2double(imread(image_title_list{imgfls}));
     fsf(imgfls)=figure(imgfls);%create a full screen page for every image and its filtered versions
     set(fsf(imgfls), 'Units', 'Normalized', 'OuterPosition', [0 0 1 1]);
     subplot(3,3,1)%each figure has 3 rows and 3 columns with
     %top row = original and two low pass filtered
     %middle row = Spatial and two high pass filtered enhanced
     %lower row = Shifted left, Laplacian 0.9 scaled and High pass filtered
     %enhanced after low pass filtered
     imshow(original_image_content)%display the original image with no filter
     set(gcf, 'color', 'white');
     title('originl image');
     for fltr = 1:length(filter_name)%process the original image using different filter methods like
     %enhanced, scaled, low pass then high pass enhanced
     filtered_image = imfilter(original_image_content,filter{fltr},'replicate');
     %First filter the original image with one of the filter matrices listed above
     %Then every if statement will generate a processed image using the original and/or filtered images
     if strcmp(filter_name{fltr}, 'LPF1') | strcmp(filter_name{fltr}, 'LPF2')
     processed_image = filtered_image;
     elseif strcmp(filter_name{fltr}, 'Spatial')
     processed_image = original_image_content-filtered_image;
     elseif strcmp(filter_name{fltr}, 'HPEnhanced1') | strcmp(filter_name{fltr},'sharpning')
     processed_image = original_image_content+filtered_image;
     elseif strcmp(filter_name{fltr}, 'ShiftLeft')
     for i=1:200 % number of pixels the image is shifted left
     filtered_image = imfilter(filtered_image,filter{fltr},'replicate');
     end
     processed_image=filtered_image;
     elseif strcmp(filter_name{fltr}, 'LaplacianScaled')
     processed_image = 0.9*(original_image_content+filtered_image);
     elseif strcmp(filter_name{fltr}, 'LPHPEnhanced2')
     processed_image = original_image_content+imfilter(imfilter(original_image_content,filter{1},'replicate'),filter{fltr},'replicate');
     else
     processed_image = filtered_image;
     end
     subplot(3,3,fltr+1)%fltr+1 as the first image is the original outside of this fltr loop
     imshow(processed_image)
     set(gcf, 'color', 'white');
     title([filter_name{fltr},' ',image_title_list{imgfls}]);
 end
end