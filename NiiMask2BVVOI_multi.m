%% Transform Nifti masks to BV VOIs
% By Ke Jia 2019-08-21 11:48
% modified by Ke Jia 2024-03-03 10:54
% modified by Yuan Gao 2024-03-03 11:00

%% Notes
% 1 ensure the nifti mask is aligned to the anatomical data
% 2 line 43 may need to change. always double check the results

%% parameters
DataDir = 'E:\2024WMPFC_7T\V2\Wang_VOI\045\';
NumVOI = 25;
Subj_Name = 'JK24_7T_045';
VOIName = {'V1v','V1d', 'V2v', 'V2d', 'V3v', 'V3d', 'hV4', 'VO1', 'VO2', 'PHC1', 'PHC2',...
    'TO2', 'TO1', 'LO2', 'LO1', 'V3B', 'V3A', 'IPS0', 'IPS1', 'IPS2', 'IPS3', 'IPS4',...
    'IPS5', 'SPL', 'FEF'};
ColorName = {[179,57,47],[115,86,177],[194,158,100],[76,117,67],[139,175,86],...
    [225,196,187],[227,111,133],[165,204,220],[132,187,159],[85,255,255],...
    [255,170,255],[255,0,127],[1,128,129],[244,146,39],[0,85,255],...
    [32,187,161],[92,0,41],[255,119,16],[142,164,202],[254,193,63],...
    [218,89,23],[105,102,182],[175,255,127],[155,155,0],[170,255,0]};

%% gen voi file
fout = fopen([DataDir '\' Subj_Name '.voi'],'wt');
fprintf(fout, '\n');
fprintf(fout, 'FileVersion:        4\n');
fprintf(fout, '\n');
fprintf(fout, 'ReferenceSpace:   BV\n');
fprintf(fout, '\n');

curr_voi = load_untouch_nii([DataDir 'roi_1.nii']);
fprintf(fout, 'OriginalVMRResolutionX:     %d\n', curr_voi.hdr.dime.pixdim(2));
fprintf(fout, 'OriginalVMRResolutionY:     %d\n', curr_voi.hdr.dime.pixdim(3));
fprintf(fout, 'OriginalVMRResolutionZ:     %d\n', curr_voi.hdr.dime.pixdim(4));
fprintf(fout, 'OriginalVMROffsetX:     0\n');
fprintf(fout, 'OriginalVMROffsetY:     0\n');
fprintf(fout, 'OriginalVMROffsetZ:     0\n');
fprintf(fout, 'OriginalVMRFramingCubeDim:  %d\n', max(size(curr_voi.img)));
fprintf(fout, '\n');
fprintf(fout, 'LeftRightConvention:        1\n');
fprintf(fout, '\n');
fprintf(fout, 'SubjectVOINamingConvention: <VOI>_<SUBJ>\n');
fprintf(fout, '\n');
fprintf(fout, 'NrOfVOIs:  %d\n',NumVOI);
fprintf(fout, '\n');

for voii = 1:NumVOI
    %% load nifti mask
    curr_voi = load_untouch_nii([DataDir 'roi_' num2str(voii) '.nii']);
    fprintf(fout, 'NameOfVOI:  %s\n', VOIName{voii});
    % fprintf(fout, 'ColorOfVOI: %d %d %d\n', ColorName{voii}(1), ColorName{voii}(2), ColorName{voii}(3));
    fprintf(fout, 'ColorOfVOI: %d %d %d\n', ColorName{voii});
    Voxel_Num = length(find(curr_voi.img==1));
    fprintf(fout, 'NrOfVoxels:  %d\n',Voxel_Num);            

    temp = find(curr_voi.img==1);
    for voxel_i = Voxel_Num:-1:1   
        [xx,yy,zz] = ind2sub(size(curr_voi.img),temp(voxel_i));
        fprintf(fout,'%d %d %d\n', xx-1,size(curr_voi.img,2)-yy,size(curr_voi.img,3)-zz);
    end
end

fprintf(fout, '\n');           
fprintf(fout,'NrOfVOIVTCs: 0\n');
    
delete *.asv