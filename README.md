# HComP-Net: Hierarchy aligned Commonality through Prototypical Networks [ICLR'25]
This repository presents the PyTorch code for **HComP-Net** (**H**ierarchy aligned **Com**monality through **P**rototypical **Net**works) 

[Paper](https://arxiv.org/abs/2409.02335) | [Project Page](https://imageomics.github.io/HComPNet/)

**HComP-Net** is an hierarchical interpretable image classification framework that can be applied to discover potential evolutionary traits from images by making use of the Phylogenetic tree also called as Tree-Of-Life. HComPNet generates hypothesis for potential evolutionary traits by learning semantically meaningful non-over-specific prototypes at each internal node of the hierarchy.

**Paper: What Do You See in Common? Learning Hierarchical Prototypes over Tree-of-Life to Discover Evolutionary Traits**

> ***Abstract:*** 
>> *A grand challenge in biology is to discover evolutionary traits, which are features of organisms common to a group of species with a shared ancestor in the tree of life (also referred to as phylogenetic tree). With the growing availability of image repositories in biology, there is a tremendous opportunity to discover evolutionary traits directly from images in the form of a hierarchy of prototypes. However, current prototype-based methods are mostly designed to operate over a flat structure of classes and face several challenges in discovering hierarchical prototypes, including the issue of learning over-specific prototypes at internal nodes. To overcome these challenges, we introduce the framework of **H**ierarchy aligned **Com**monality through **P**rototypical **Net**works (**HComP-Net**). The key novelties in **HComP-Net** include a novel over-specificity loss to avoid learning over-specific prototypes,  a novel discriminative loss to ensure prototypes at an internal node are absent in the contrasting set of species with different ancestry, and a novel masking module to allow for the exclusion of over-specific prototypes at higher levels of the tree without hampering classification performance.  We empirically show that **HComP-Net** learns prototypes that are accurate, semantically consistent, and generalizable to unseen species in comparison to baselines.*

![Objective of HComP-Net](assets/HComPNet_teaser.png)

## Setting up environment
Run the following command to create and activate a new conda environment
```
conda create -n hcomp
conda activate hcomp
```
and run the following command to install the required packages
```
pip install -r requirements.txt
```

## Setting up datasets

#### CUB-190

Download CUB-200-2011 [1] dataset and save it in the ```/data``` path

Once downloaded the folder structure should look something like this  
```
data/
└── CUB_200_2011/
    ├── attributes/ # Not used
    ├── images/
    ├── parts/ 
    ├── image_class_labels.txt
    ├── train_test_split.txt
    ├── images.txt
    ├── bounding_boxes.txt
    ├── classes.txt
    └── README.md
```

Run the following command to create ```CUB-190``` dataset. Running the command creates ```dataset_cub190``` and ```images_cub190``` folders

```
python preprocess_data/prepare_cub190.py --segment
```

The folder structure should now look like this  
```
data/
└── CUB_200_2011/
    ├── attributes/ # Not used
    ├── dataset_cub190/ # Newly created
    ├── images/
    ├── images_cub190/ # Newly created
    ├── parts/ 
    ├── image_class_labels.txt
    ├── train_test_split.txt
    ├── images.txt
    ├── bounding_boxes.txt
    ├── classes.txt
    └── README.md
```

## Training HComP-Net
In order to train the model run the following command.
The following command is for running the model on ```cub190``` dataset. Running ```cub190``` with a ```batch_size``` of 256 required two a100 GPUs, therefore ```gpu_ids``` is set to ```0,1```. For running on single gpu remove the ```gpu_ids``` argument, as it assume single GPU by default.
```
python main.py --log_dir './runs/hcompnet_cub190_cnext26' --dataset CUB-190 --net convnext_tiny_26 --batch_size 256 --batch_size_pretrain 256 --epochs 75 --epochs_pretrain 10 --epochs_finetune_classifier 3 --epochs_finetune_mask 60 --freeze_epochs 10 --gpu_ids '0,1' --num_workers 8 --phylo_config ./configs/cub190_phylogeny.yaml --num_protos_per_child 10
```

## Visualizing the prototypes

We create Top-K Visualizations to analyze prototypes, where we visualize the Top-K nearest image patches for an hierarchical prototype from each leaf descendant. Follow the steps in the ```plot_topk_visualizations.ipynb```, to create Top-K visualization.

## Analyzing the semantic quality of prototypes

Follow instructions in ```part_purity_cub.ipynb``` to quantitatively analyze the semantic quality of prototypes


# References

- [1] Wah, Catherine, Steve Branson, Peter Welinder, Pietro Perona, and Serge Belongie. "The caltech-ucsd birds-200-2011 dataset." (2011).
