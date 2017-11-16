function id = getMatId(materials,objPly)
id = 1;
mat = objPly.getProperties();
for i=1:length(materials)
    if isequal(materials{i},mat)==1
        id = i;
        break
    end
end
end

