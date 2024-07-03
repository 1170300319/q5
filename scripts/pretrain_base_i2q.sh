# Run with $ bash scripts/pretrain_P5_base_beauty.sh 4

#!/bin/bash
export CUDA_VISIBLE_DEVICES=0,1,2,3

name=icbu-base-i2q

output=snap/$name

PYTHONPATH=$PYTHONPATH:./src \
python -m torch.distributed.launch \
    --nproc_per_node=$1 \
    --master_port 12321 \
    src/pretrain_icbu.py \
        --distributed --multiGPU \
        --seed 2022 \
        --train I2Q \
        --valid I2Q \
        --batch_size 32 \
        --optim adamw \
        --warmup_ratio 0.05 \
        --lr 1e-3 \
        --num_workers 4 \
        --clip_grad_norm 1.0 \
        --losses 'I2Q' \
        --backbone 't5-base' \
        --output $output ${@:2} \
        --epoch 5 \
        --max_text_length 512 \
        --gen_max_length 64 \
        --whole_word_embed > logs/$name.log
