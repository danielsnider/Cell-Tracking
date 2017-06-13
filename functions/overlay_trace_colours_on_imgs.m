function coloured_imgs = overlay_trace_colours_on_imgs(CellsTable, imgs)
  %labelled_by_trace = zeros(size(imgs,1), size(imgs,2), size(imgs,3), 4);  
  imgs = imgs(:,:,1);
  
  boundaries = CellsTable.nuc_boundaries(CellsTable.Time == 1); %boundaries of cells in one timepoint
  
  
  %for t=min(CellsTable.Time):max(CellsTable.Time)
    
    ObjectsInFrame = CellsTable(CellsTable.Time==1,:); %ResultTable for cells in frame
    %boundaries = CellsTable.nuc_boundaries(CellsTable.Time == t);
    NumberOfCells = size(boundaries, 1);
    labelled_by_trace_id_this = zeros(size(imgs,1), size(imgs,2), 3);
    
    for i=1:NumberOfCells
      Object = ObjectsInFrame(i,:);
      trace = Object.Trace{:};
      trace = strsplit(trace,'-');
      
      %calculate RGB values
      red = mod(sum(uint8(trace{1})),255);
      green = mod(sum(uint8(trace{2})),255);
      blue = mod(sum(uint8(trace{3})),255);
      
      %colour edges
      %a = [0 1 0 ; 1 0 1 ; 0 1 0];
      %figure; imshow(a, [])
%       b = cat(3,a,a,a);
%       c = cat(3,a,a,a);
%       d = cat(3,a,a,a);
      
      labelled_by_trace_id_this(boundaries{i}) = red;
      labelled_by_trace_id_this(boundaries{i}+prod(size(imgs))) = green;
      labelled_by_trace_id_this(boundaries{i}+prod(size(imgs))*2) = blue;
      
      %image looks grayscale after add colour; using this to debug
%       b(:,:,1) = red;
%       b(:,:,2) = green;
%       b(:,:,3) = blue;
%       c(:,:,1) = 0;
%       c(:,:,2) = green;
%       c(:,:,3) = 0;
%       d(:,:,1) = 0;
%       d(:,:,2) = 0;
%       d(:,:,3) = blue;
      
      labelled_by_trace_id_this = uint8(labelled_by_trace_id_this);
      
      %fill in perimeter
      labelled_by_trace_id_this(:,:,1) = imfill(labelled_by_trace_id_this(:,:,1),'holes');
      labelled_by_trace_id_this(:,:,2) = imfill(labelled_by_trace_id_this(:,:,2),'holes');
      labelled_by_trace_id_this(:,:,3) = imfill(labelled_by_trace_id_this(:,:,3),'holes');
    end
    
    
  %end
  labelled_by_trace_id_this = uint8(labelled_by_trace_id_this);
  figure; imshow(b, []);
  figure; imshow(c, []);
  figure; imshow(d, []);
  figure; imshow3D(imgs,[]);
  figure; imshow3D(labelled_by_trace_id_this,[]);
  
end 
  
  
%       %% 1) RGB segmentation overlay BY SIZE (useful for seeing size)
%     boundries_rgb = zeros(size(cyto, 1), size(cyto, 2), size(cyto, 3), 3);
%     %for i = 1:size(cyto, 3)
%     for t=min(CellsTable.Time):max(CellsTable.Time)
%       labelled_by_size_color_fix=labelled_by_size(:,:,i);
%       labelled_by_size_color_fix(1)=min(ResultsTable.CellSize);
%       labelled_by_size_color_fix(2)=COLOR_LIMIT;
%       boundries_rgb(:,:,i,:) = label2rgb(round(labelled_by_size_color_fix),'jet', 'k');
%     end
%     mod(sum(uint8('19oueiueoif')), 255); % calculate a colour value between 0 and 255
%     cyto_rgb = cat(4, cyto, cyto, cyto);
%     cyto_overlay = uint8(boundries_rgb./6) ... % segmented boundries
%                  + uint8(cyto_rgb);           % original cyto
%     % figure('name','cyto_overlay', 'NumberTitle','off');imshow3Dfull(uint8(cyto_overlay),[]);
% end