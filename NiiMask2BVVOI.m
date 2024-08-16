%% Transform Nifti masks to BV VOIs
% By Ke Jia 2019-08-21 11:48
% modified by Yuan Gao 2024-03-03 10:54

%% Notes
% 1 ensure the nifti mask is aligned to the anatomical data
% 2 line 43 may need to change. always double check the results

function NiiMask2BVVOI(voifile)
    %% load nifti mask
    [voipath,voiname] = fileparts(voifile);
    curr_voi = load_untouch_nii(voifile);
    
    %% gen voi file
    fout = fopen([voipath '\' voiname '.voi'],'wt');
    fprintf(fout, '\n');
    fprintf(fout, 'FileVersion:        4\n');
    fprintf(fout, '\n');
    fprintf(fout, 'ReferenceSpace:   BV\n');
    fprintf(fout, '\n');
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
    
    fprintf(fout, 'NrOfVOIs:  %d\n',1);
    fprintf(fout, '\n');
    fprintf(fout, 'NameOfVOI:  %s\n', voiname);
    fprintf(fout, 'ColorOfVOI: %d %d %d\n',[255 0 0]);
    
    Voxel_Num = length(find(curr_voi.img==1));
    fprintf(fout, 'NrOfVoxels:  %d\n',Voxel_Num);            

    temp = find(curr_voi.img==1);
    for voxel_i = Voxel_Num:-1:1   
        [xx,yy,zz] = ind2sub(size(curr_voi.img),temp(voxel_i));
        fprintf(fout,'%d %d %d\n', xx-1,size(curr_voi.img,2)-yy,size(curr_voi.img,3)-zz);
    end
    fprintf(fout, '\n');           
    fprintf(fout,'NrOfVOIVTCs: 0\n');
end