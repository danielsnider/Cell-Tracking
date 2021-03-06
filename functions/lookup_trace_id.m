function [trace global_cell_index] = find_trace(ResultsTable, timepoint, cell_index_within_timepoint)
  % Find the trace and global index for a cell in a ResultsTable at an index within a timepoint
  SubsetTable = ResultsTable.Time==timepoint;
  % Ugly matlab approach to getting the n'th element (ie. cell_index_within_timepoint) that is matching a search condition (ie. timepoint). Maybe there is a better way!!
  global_cell_index = find(SubsetTable==1,cell_index_within_timepoint,'first');
  global_cell_index = global_cell_index(end);
  trace = ResultsTable{global_cell_index,{'Trace'}};
end
