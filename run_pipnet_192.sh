#!/bin/bash

#SBATCH --account=imageomicswithanuj
#SBATCH --partition=dgx_normal_q
#SBATCH --time=9:00:00 
#SBATCH --gres=gpu:2
#SBATCH --nodes=1 --ntasks-per-node=1 --cpus-per-task=8
#SBATCH -o ./SLURM/slurm-%j.out


echo start load env and run python

# module reset
# module load Anaconda3/2020.11
# source activate hpnet1
# module reset
# source activate hpnet1
# which python

# module reset
# module load Anaconda3/2020.11
# source activate hpnet3
# module reset
# source activate hpnet3
# which python

module reset
module load Anaconda3/2020.11
source activate hpnet4
module reset
source activate hpnet4
which python

# # module reset
# # module load Anaconda3/2020.11
# # source activate maskclip2
# # module reset
# # source activate maskclip2
# # which python

# # module reset
# # module load Anaconda3/2020.11
# # source activate maskclip1
# # module reset
# # source activate maskclip1
# # which python

# module reset
# module load Anaconda3/2020.11
# source activate taming3
# module reset
# source activate taming3
# which python


# when coming out of training wheels
# set copy files to "y"
# comment memory usage logging
# set the epochs right

# 080-CUB-18-imgnet_with-equalize-aug_cnext7_img=224_nprotos=20_unit-sphere-protopool_finetune=5_align-pf-during-training_no-meanpool_with-softmax_no-addon-bias_AW=3-TW=2-UW=3-CW=2_weighted-ce_batch=20
# epoch to 60, pretrain to 60, freeze_epochs 10, finetune to 5, viz topk commented at all places, print weights commented, prototype purity commented
# pretraining-check-001-AL=3_UW=6
# dinov2_vits14_reg
# convnext_tiny_26
# convnext_tiny_13

# DO THIS AFTER TRAINING WHEELS -|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|
# set finetune back to 5, epochs_pretrain=30, epochs=60, freeze_epochs=10
# 152-ConciseProtoPNetNoProtoPoolWithKO=0.5WithTanhDescWithAntConc=0.1_Dinov2VitS4_CUB-29-imgnet-224_with-equalize-aug_img=224_nprotos=20
# 153-PruningNaiveHPIPNet_cnext13_CUB-29-imgnet-224_with-equalize-aug_img=224_nprotos=20
# 162-PruningNaiveHPIPNetMaskL1=0.5MaskTrainExtra=15epsEps=60_cnext13_CUB-18-imgnet-224_with-equalize-aug_img=224_nprotos=20
python main.py --log_dir './runs/192-PruningNaiveHPIPNetMaskL1=0.5MaskTrainExtra=05epsEps=85Cl=4.0TanhDesc=0.05MinCont=0.5_cnext26_CUB-190-imgnet-224_WeightedCE_with-equalize-aug_img=224_nprotos=20' \
               --training_wheels "n" \
               --copy_files "y" \
               --wandb "y" \
               --dataset CUB-190-imgnet-224 \
               --disable_transform2 'n' \
               --validation_size 0.0 \
               --net convnext_tiny_26 \
               --batch_size 256 \
               --batch_size_pretrain 256 \
               --epochs 75 \
               --epochs_pretrain 10 \
               --epochs_finetune 0 \
               --epochs_finetune_classifier 3 \
               --epochs_finetune_mask_prune 60 \
               --freeze_epochs 10 \
               --optimizer 'Adam' \
               --lr 0.05 \
               --lr_block 0.0005 \
               --lr_net 0.0005 \
               --weight_decay 0.0 \
               --image_size 224 \
               --state_dict_dir_net '' \
               --dir_for_saving_images 'Visualization_results' \
               --seed 1 \
               --gpu_ids '0,1' \
               --num_workers 8 \
               --phylo_config ./configs/cub190_phylogeny.yaml \
               --experiment_note "-. Removed focal loss. Fixed descendant count problem. Added softmax after cs. Base unit sphere model with 20 protos per node. Loading the pretrained backbone so setting epochs_pretrain 0. With bias in the addon layer. Protopool, no seperate classifiction layer for each child node. Not using softmax. Added finetune back this time it trains add-on along with classification. Using equalize aug as well, but keeping augment parameters to the new one. No meanpool. With 60 epochs of unit-sphere pretraining. Set meanpool kernel size to 2. Class loss doesnt affect convnext only AL+UNI does. Removed OOD again. first run after fixing all the memory issue. Pretrain->AL+UNI, finetune->CL, general training->AL+UNI+TANH_DESC+CL. fixed UW=0 now UW=2. unit sphere latent space. 4 per descendant. Saving every 30 epochs. Added csv logging for node wise losses. Added wandb for logging nodewise losses. Added OOD for 18species subset. Added kernel orthogonality on only relevant prototype kernels with loss-weight 0.5. Filtered imgs in vis_pipnet and fixed the previous issue. Separate add_on for each node. Using cropped images for projection. Removed scaling -> (len(node_y) / len(ys[ys != OOD_LABEL])). Set finetune to 0 and Set freeze_epochs to 30. Added OOD loss, removed pretrained backbone. 005 had incorrect data.py. Fixed it again. Reducing protos to 50 from 200 since there is a lot of meaningless prototypes in 004. Not Using backbone thats already trained with all 190 species. Limited protos to 200 bcoz of memory issue. Added wandb logging" \
               --kernel_orth "y" \
               --num_features 20 \
               --num_protos_per_descendant 0 \
               --align "n" \
               --uni "n" \
               --align_pf "y" \
               --tanh "y" \
               --tanh_desc "n" \
               --tanh_during_second_phase 'y' \
               --minmaximize "n" \
               --unitconv2d "n" \
               --projectconv2d "n" \
               --l2conv2d "n" \
               --softmax "y|1" \
               --gumbel_softmax "n" \
               --gs_tau 1.0 \
               --multiply_cs_softmax "n" \
               --focal "n" \
               --weighted_ce_loss "y" \
               --focal_loss "n" \
               --focal_loss_gamma 2.0 \
               --protopool "n" \
               --stage4_reducer_net "" \
               --state_dict_dir_backbone "" \
               --basic_cnext_gaussian_multiplier "" \
               --byol 'n' \
               --cluster_desc 'n' \
               --sep_desc 'n' \
               --subspace_sep 'n' \
               --viz_loader 'testloader,projectloader' \
               --sg_before_protos 'n' \
               --conc_log_ip 'n' \
               --conc_log_ip_peak_normalize 'n' \
               --ant_conc_log_ip 'n' \
               --act_l1 'n' \
               --softmax_over_channel 'n' \
               --classifier 'NonNegative' \
               --pipnet_sparsity 'y' \
               --mask_prune_overspecific 'y|0' \
               --minimize_contrasting_set 'y|1|0.1' \
               --leave_out_classes "" \
               --cl_weight 2.0 \
               # --leave_out_classes "./configs/leave_out_classes_CUB-190_10_set1.txt" \
               # --state_dict_dir_backbone "/home/harishbabu/projects/PIPNet/runs/082-CUB-18-imgnet_with-equalize-aug_cnext26_img=224_nprotos=4per-leaf-desc_unit-sphere_finetune=5_no-meanpool_with-softmax_no-addon-bias_AW=3-TW=2-MMW=2-UW=3-CW=2_mm-loss_batch=48/checkpoints/net_pretrained" \
               # --state_dict_dir_net '/home/harishbabu/projects/PIPNet/runs/068-CUB-18-imgnet_with-equalize-aug_cnext26_img=224_nprotos=4per-desc_unit-sphere-protopool_finetune=5_no-meanpool_no-softmax_AW=3-TW=2-UW=3-CW=2_batch=20/checkpoints/net_pretrained' \
            #    --add_on_bias \
               # --OOD_dataset 'CUB-172-OOD-imgnet-224' \
               # --state_dict_dir_backbone '/home/harishbabu/projects/PIPNet/runs/CUB-190-imgnet_cnext26_img=224/checkpoints/net_trained_last' \
               # --bias False \
               # --disable_cuda False \
               # --disable_pretrained False \
               # --weighted_loss False \

#-------------------DEBUGGING PURPOSE ONLY------------------------#

# python main.py --log_dir './runs/checking6' \
#                --dataset CUB-27-imgnet-224 \
#                --validation_size 0.0 \
#                --net convnext_tiny_26 \
#                --batch_size 64 \
#                --batch_size_pretrain 128 \
#                --epochs 8 \
#                --epochs_pretrain 1 \
#                --optimizer 'Adam' \
#                --lr 0.05 \
#                --lr_block 0.0005 \
#                --lr_net 0.0005 \
#                --weight_decay 0.0 \
#                --num_features 20 \
#                --image_size 224 \
#                --state_dict_dir_net '' \
#                --freeze_epochs 10 \
#                --dir_for_saving_images 'Visualization_results' \
#                --seed 1 \
#                --gpu_ids '' \
#                --num_workers 8 \
#                --phylo_config ./configs/cub27_phylogeny.yaml \
#                --experiment_note "Added OOD loss. Reducing protos to 50 from 200 since there is a lot of meaningless prototypes in 004. Using backbone thats already trained with all 190 species. Limited protos to 200 bcoz of memory issue. Added wandb logging" \
#                --OOD_dataset 'CUB-163-OOD-imgnet-224' \
#                --state_dict_dir_backbone '/home/harishbabu/projects/PIPNet/runs/CUB-190-imgnet_cnext26_img=224/checkpoints/net_trained_last' \
#                # --bias False \
#                # --disable_cuda False \
#                # --disable_pretrained False \
#                # --weighted_loss False \


# python main.py --log_dir ./runs/checking --dataset CUB-27-imgnet-224 --validation_size 0.0 --net convnext_tiny_26 --batch_size 64 --batch_size_pretrain 128 --epochs 2 --epochs_pretrain 2 --optimizer 'Adam' --lr 0.05 --lr_block 0.0005 --lr_net 0.0005 --weight_decay 0.0 --num_features 200 --image_size 224 --state_dict_dir_net '' --freeze_epochs 10 --dir_for_saving_images 'Visualization_results' --seed 1 --gpu_ids '' --num_workers 8 --phylo_config ./configs/cub27_phylogeny.yaml --state_dict_dir_backbone '/home/harishbabu/projects/PIPNet/runs/CUB-190-imgnet_cnext26_img=224/checkpoints/net_trained_last'

exit;
# [print(xs1.shape) for i, (xs1, xs2, ys) in train_loader]

# [print(xs1.shape) for xs1, xs2, ys in train_loader]