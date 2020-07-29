function [allSubFolders] = fun_getAllSubFolders(fd)

junk = dir(fd);
junk(ismember( {junk.name}, {'.', '..'})) = [];
allSubFolders = junk([junk.isdir]);
