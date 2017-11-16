function matchange = matToFem(layup)
%Return material in .fem file format
mat = layup.getMaterials();
for i = 1:length(materials)
    matchange = {matchange,formatMat(mat{i},i)};
end
end

