function plyFEM = formatPly(objPly,id,MID,side)
%Return one material into .fem file format
[~,theta,t] = objPly.getProperties();
id = num2str(id);
MID = num2str(MID);
theta = num2str(theta);
t = num2str(t);
side = num2str(side);
row1 = ['$HMNAME PLYS            ',id,'"ply',id,'" "MAT8"'];
row2 = ['$HWCOLOR PLY            ',id,'       5']; 
row3 = ['PLY,',id,',',MID,',',t,',',theta,',YES'];
row4 = ['+       ',side];
plyFEM = {row1,row2,row3,row4};
end

