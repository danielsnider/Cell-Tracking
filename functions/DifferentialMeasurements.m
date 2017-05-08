function [raw_differences, normalized_differences, composite_differences] = DifferentialMeasurements(SubsetTable)
  %% Calc Differetial Measurements between T and T+1 
  % 
  %
  % EXPLAINATION OF THE DIFFERENCES DATA STRUCTURE
  %
  % Example:
  %
  %    raw_differences =
  %    
  %      1×4 cell array
  %    
  %        [3×2 double]    [3×3 double]    [3×3 double]    [3×3 double]
  %
  % Example Explained:
  %
  %    raw_differences =
  %    
  %      1×4 cell array
  %     
  %      -In this example there are 5 timepoints, T1 to T5.
  %      -Differences between timepoints are stored as a matrix in the cell array.
  %      -The matrix size is large enough to compare all cells at timepoint T to all cells at T+1.
  %      -Each value in the matrix contains the difference between one cell at timepoint T and one cell at T+1.
  %      -Each cell at timepoint T is represented as a has a column in the matrix and each value 
  %       in the cell's column is the observed difference to a cell at timepoint T+1.
  %
  %           T1-->T2        T2-->T3         T3-->T4         T4-->T5
  %        [3×2 double]    [3×3 double]    [3×3 double]    [3×3 double]
  %        /  \                            /  \
  %       /   number of cells at T1       /   number of cells at T3
  %    number of cells at T2           number of cells at T4

  %% RAW DIFFERENCES
  raw_differences = {};

  for t=1:max(SubsetTable.Ti)-1
    T1 = SubsetTable(SubsetTable.Ti==t,:);
    T2 = SubsetTable(SubsetTable.Ti==t+1,:);

    % Tranlation distances between T and T+1
    X_translation = squareform(pdist([T1.Xcoord;T2.Xcoord]));
    X_translation=X_translation(height(T1)+1:end,1:height(T1)); % produces matrix of size lenT1 x lenT2 containing translation
    Y_translation = squareform(pdist([T1.Ycoord;T2.Ycoord]));
    Y_translation=Y_translation(height(T1)+1:end,1:height(T1)); % produces matrix of size lenT1 x lenT2 containing translation
    [theta,rho] = cart2pol(X_translation,Y_translation);
    raw_differences{t}.Translation = rho;

    % Eccentricity differences
    eccentricity_diff = squareform(pdist([T1.Eccentricity;T2.Eccentricity]));
    raw_differences{t}.Eccentricity = eccentricity_diff(height(T1)+1:end,1:height(T1)); % produces matrix of size lenT1 x lenT2 containing differences

    % Nuclear area differences
    area_diff = squareform(pdist([T1.N_Area;T2.N_Area]));
    raw_differences{t}.Area = area_diff(height(T1)+1:end,1:height(T1)); % produces matrix of size lenT1 x lenT2 containing differences

    % MajorAxisLength differences
    MajorAxisLength_diff = squareform(pdist([T1.MajorAxisLength;T2.MajorAxisLength]));
    raw_differences{t}.MajorAxisLength = MajorAxisLength_diff(height(T1)+1:end,1:height(T1)); % produces matrix of size lenT1 x lenT2 containing differences

    % MinorAxisLength differences
    MinorAxisLength_diff = squareform(pdist([T1.MinorAxisLength;T2.MinorAxisLength]));
    raw_differences{t}.MinorAxisLength = MinorAxisLength_diff(height(T1)+1:end,1:height(T1)); % produces matrix of size lenT1 x lenT2 containing differences

    % Solidity differences
    Solidity_diff = squareform(pdist([T1.Solidity;T2.Solidity]));
    raw_differences{t}.Solidity = Solidity_diff(height(T1)+1:end,1:height(T1)); % produces matrix of size lenT1 x lenT2 containing differences

    % Orientation differences
    Orientation_diff = squareform(pdist([T1.Orientation;T2.Orientation]));
    raw_differences{t}.Orientation = Orientation_diff(height(T1)+1:end,1:height(T1)); % produces matrix of size lenT1 x lenT2 containing differences

    % Nuclear intensity differences
    nuc_intensity_diff = squareform(pdist([T1.N_Int3;T2.N_Int3]));
    raw_differences{t}.Nuc_intensity = nuc_intensity_diff(height(T1)+1:end,1:height(T1)); % produces matrix of size lenT1 x lenT2 containing differences
  end

  %% NORMALIZED DIFFERENCES
  normalized_differences = {};
  for t=1:length(raw_differences)
    normalized_differences{t}.Translation = normalize0to1(raw_differences{t}.Translation);
    normalized_differences{t}.Eccentricity = normalize0to1(raw_differences{t}.Eccentricity);
    normalized_differences{t}.Area = normalize0to1(raw_differences{t}.Area);
    normalized_differences{t}.MajorAxisLength = normalize0to1(raw_differences{t}.MajorAxisLength);
    normalized_differences{t}.MinorAxisLength = normalize0to1(raw_differences{t}.MinorAxisLength);
    normalized_differences{t}.Solidity = normalize0to1(raw_differences{t}.Solidity);
    normalized_differences{t}.Orientation = normalize0to1(raw_differences{t}.Orientation);
    normalized_differences{t}.Nuc_intensity = normalize0to1(raw_differences{t}.Nuc_intensity);
  end

  % Importance of each metric for when calculating composite distances
  weights = {};
  weights.Translation = 3;
  weights.Eccentricity = 1;
  weights.Area = 1;
  weights.MajorAxisLength = 1;
  weights.MinorAxisLength = 1;
  weights.Solidity = 1;
  weights.Orientation = 1;
  weights.Nuc_intensity = 2;

  %% COMPOSITE DIFFERENCES
  composite_differences = {};
  for t=1:length(normalized_differences)
    % composite_differences{t} = normalized_differences{t}.Translation .* weights.Translation;
    composite_differences{t} = normalized_differences{t}.Translation .* weights.Translation ...
                          + normalized_differences{t}.Eccentricity .* weights.Eccentricity ...
                          + normalized_differences{t}.Area .* weights.Area ...
                          + normalized_differences{t}.MajorAxisLength .* weights.MajorAxisLength ...
                          + normalized_differences{t}.MinorAxisLength .* weights.MinorAxisLength ...
                          + normalized_differences{t}.Solidity .* weights.Solidity ...
                          + normalized_differences{t}.Orientation .* weights.Orientation ...
                          + normalized_differences{t}.Nuc_intensity .* weights.Nuc_intensity;
  end
end