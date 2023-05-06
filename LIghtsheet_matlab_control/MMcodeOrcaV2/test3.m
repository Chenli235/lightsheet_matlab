fprintf(controlParameters.sDetLens,'1TP?');
pos = fscanf(controlParameters.sDetLens);
pos = getpos(pos);
current_detection_pos = str2num(pos);
% before move
disp(['before move: ',num2str(current_detection_pos)]);
detect_pos = [0,0.008,0.016];
for j = 1:3
      fprintf(controlParameters.sDetLens,['1PR',num2str(detect_pos(j))]);
      pause(1);
      if j == 1
         fprintf(controlParameters.sDetLens,['1PR',num2str(detect_pos(j))]);
         pause(1);
      end
         %img = requestoneimagefromcamera(app);
         %img(:,:,j) = img;
end
fprintf(controlParameters.sDetLens,'1TP?');
pos = fscanf(controlParameters.sDetLens);
pos = getpos(pos);
current_detection_pos = str2num(pos);
% before move
disp(['after move: ',num2str(current_detection_pos)]);
detect_pos = [0,0.008,0.016];
for j = 1:3
      fprintf(controlParameters.sDetLens,['1PR-',num2str(detect_pos(j))]);
      pause(1);
      if j == 1
         fprintf(controlParameters.sDetLens,['1PR-',num2str(detect_pos(j))]);
         pause(1);
      end
         %img = requestoneimagefromcamera(app);
         %img(:,:,j) = img;
end
fprintf(controlParameters.sDetLens,'1TP?');
pos = fscanf(controlParameters.sDetLens);
pos = getpos(pos);
current_detection_pos = str2num(pos);
% before move
disp(['move back: ',num2str(current_detection_pos)]);