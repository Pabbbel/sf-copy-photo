#!/bin/bash

echo "Клонирование кастомных нод..."
mkdir -p /workspace/ComfyUI/custom_nodes
cd /workspace/ComfyUI/custom_nodes

if [ ! -d "sf-copy-photo-nodes" ]; then
    git clone https://${GITHUB_TOKEN}@github.com/Pabbbel/ComfyUI-SFRealCopy.git sf-copy-photo-nodes
fi

echo "Скачивание моделей..."
mkdir -p /workspace/ComfyUI/models/diffusion_models
mkdir -p /workspace/ComfyUI/models/text_encoders
mkdir -p /workspace/ComfyUI/models/vae
mkdir -p /workspace/ComfyUI/models/loras

if [ ! -f "/workspace/ComfyUI/models/diffusion_models/z_image_turbo_bf16.safetensors" ]; then
    wget -q --show-progress -O /workspace/ComfyUI/models/diffusion_models/z_image_turbo_bf16.safetensors \
    "https://huggingface.co/Comfy-Org/z_image_turbo/resolve/main/split_files/diffusion_models/z_image_turbo_bf16.safetensors"
fi

if [ ! -f "/workspace/ComfyUI/models/text_encoders/qwen_3_4b.safetensors" ]; then
    wget -q --show-progress -O /workspace/ComfyUI/models/text_encoders/qwen_3_4b.safetensors \
    "https://huggingface.co/Comfy-Org/z_image_turbo/resolve/main/split_files/text_encoders/qwen_3_4b.safetensors"
fi

if [ ! -f "/workspace/ComfyUI/models/vae/ae.safetensors" ]; then
    wget -q --show-progress -O /workspace/ComfyUI/models/vae/ae.safetensors \
    "https://huggingface.co/Comfy-Org/z_image_turbo/resolve/main/split_files/vae/ae.safetensors"
fi

if [ ! -f "/workspace/ComfyUI/models/diffusion_models/qwen_image_bf16.safetensors" ]; then
    wget -q --show-progress -O /workspace/ComfyUI/models/diffusion_models/qwen_image_bf16.safetensors \
    "https://huggingface.co/Comfy-Org/Qwen-Image_ComfyUI/resolve/main/split_files/diffusion_models/qwen_image_bf16.safetensors"
fi

if [ ! -f "/workspace/ComfyUI/models/text_encoders/qwen_2.5_vl_7b.safetensors" ]; then
    wget -q --show-progress -O /workspace/ComfyUI/models/text_encoders/qwen_2.5_vl_7b.safetensors \
    "https://huggingface.co/Comfy-Org/Qwen-Image_ComfyUI/resolve/main/split_files/text_encoders/qwen_2.5_vl_7b.safetensors"
fi

if [ ! -f "/workspace/ComfyUI/models/vae/qwen_image_vae.safetensors" ]; then
    wget -q --show-progress -O /workspace/ComfyUI/models/vae/qwen_image_vae.safetensors \
    "https://huggingface.co/Comfy-Org/Qwen-Image_ComfyUI/resolve/main/split_files/vae/qwen_image_vae.safetensors"
fi
