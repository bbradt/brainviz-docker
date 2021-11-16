clear
clc;
diary ccmat.txt
gift_root='/DATA/236/sgao/BPUP/gica/op2/';%enter your gift_root%
gift_name='op2';%enter your gift_name%
gift_info=load([gift_root gift_name '_ica_parameter_info.mat']);
num_comp=gift_info.sesInfo.numComp;
num_voxel=size(gift_info.sesInfo.mask_ind,1);
clear gift_info
comp_to_be_removed=[];
p_num=37;%number of BD patients%
n_num=36;%number of MDD patients%
[com,label]=get_ica_comp(gift_root, gift_name, comp_to_be_removed, num_comp, num_voxel, p_num, n_num);
com([17 20 22 23 24 53 60],:,:)=[];%remove unused data%
label(:,[17 20 22 23 24 53 60])=[];%remove unused label%
[n,m,v]=size(com);

giftd_root='/DATA/236/sgao/BPUP/gica/op3/';%enter your gift_root of UNK%
giftd_name='op3';%enter your gift_name of UNK%
num_uk=12;%number of UNK%
[com_d,label_d]=get_ica_comp_validation(giftd_root, giftd_name, comp_to_be_removed, num_comp, num_voxel, num_uk);
[n_d,m_d,v_d]=size(com_d);
com_all=[com;com_d];

save('cmat.mat','com','label','n','com_all','n_d');

diary off