#!/bin/bash

echo "=== Custom setup: начало ==="


if [ ! -d "/workspace/ComfyUI" ]; then
    echo "ОШИБКА: /workspace/ComfyUI не найден! Что-то пошло не так с синхронизацией."
    exit 1
fi

# ============================================================
# 1. Клонирование кастомных нод из приватного репозитория
# ============================================================
echo "Клонирование кастомных нод..."
mkdir -p /workspace/ComfyUI/custom_nodes
cd /workspace/ComfyUI/custom_nodes

if [ ! -d "sf-copy-photo-nodes" ]; then
    if [ -z "$GITHUB_TOKEN" ]; then
        echo "ОШИБКА: переменная GITHUB_TOKEN не задана! Приватный репозиторий не будет склонирован."
    else
        git clone https://${GITHUB_TOKEN}@github.com/Pabbbel/ComfyUI-SFRealCopy.git sf-copy-photo-nodes

        # Установка зависимостей кастомных нод (если есть)
        if [ -f "sf-copy-photo-nodes/requirements.txt" ]; then
            echo "Установка зависимостей кастомных нод..."
            source /workspace/ComfyUI/venv/bin/activate
            pip install -r /workspace/ComfyUI/custom_nodes/sf-copy-photo-nodes/requirements.txt
            deactivate
        fi
    fi
else
    echo "Кастомные ноды уже существуют, пропуск."
fi

# ============================================================
# 2. Скачивание моделей
# ============================================================
echo "Скачивание моделей..."
mkdir -p /workspace/ComfyUI/models/diffusion_models
mkdir -p /workspace/ComfyUI/models/text_encoders
mkdir -p /workspace/ComfyUI/models/vae
mkdir -p /workspace/ComfyUI/models/loras

# --- z_image_turbo ---
if [ ! -f "/workspace/ComfyUI/models/diffusion_models/z_image_turbo_bf16.safetensors" ]; then
    echo "  -> z_image_turbo_bf16.safetensors"
    wget -q --show-progress -O /workspace/ComfyUI/models/diffusion_models/z_image_turbo_bf16.safetensors \
        "https://huggingface.co/Comfy-Org/z_image_turbo/resolve/main/split_files/diffusion_models/z_image_turbo_bf16.safetensors"
fi

if [ ! -f "/workspace/ComfyUI/models/text_encoders/qwen_3_4b.safetensors" ]; then
    echo "  -> qwen_3_4b.safetensors"
    wget -q --show-progress -O /workspace/ComfyUI/models/text_encoders/qwen_3_4b.safetensors \
        "https://huggingface.co/Comfy-Org/z_image_turbo/resolve/main/split_files/text_encoders/qwen_3_4b.safetensors"
fi

if [ ! -f "/workspace/ComfyUI/models/vae/ae.safetensors" ]; then
    echo "  -> ae.safetensors"
    wget -q --show-progress -O /workspace/ComfyUI/models/vae/ae.safetensors \
        "https://huggingface.co/Comfy-Org/z_image_turbo/resolve/main/split_files/vae/ae.safetensors"
fi

# --- Qwen-Image ---
if [ ! -f "/workspace/ComfyUI/models/diffusion_models/qwen_image_bf16.safetensors" ]; then
    echo "  -> qwen_image_bf16.safetensors"
    wget -q --show-progress -O /workspace/ComfyUI/models/diffusion_models/qwen_image_bf16.safetensors \
        "https://huggingface.co/Comfy-Org/Qwen-Image_ComfyUI/resolve/main/split_files/diffusion_models/qwen_image_bf16.safetensors"
fi

if [ ! -f "/workspace/ComfyUI/models/text_encoders/qwen_2.5_vl_7b.safetensors" ]; then
    echo "  -> qwen_2.5_vl_7b.safetensors"
    wget -q --show-progress -O /workspace/ComfyUI/models/text_encoders/qwen_2.5_vl_7b.safetensors \
        "https://huggingface.co/Comfy-Org/Qwen-Image_ComfyUI/resolve/main/split_files/text_encoders/qwen_2.5_vl_7b.safetensors"
fi

if [ ! -f "/workspace/ComfyUI/models/vae/qwen_image_vae.safetensors" ]; then
    echo "  -> qwen_image_vae.safetensors"
    wget -q --show-progress -O /workspace/ComfyUI/models/vae/qwen_image_vae.safetensors \
        "https://huggingface.co/Comfy-Org/Qwen-Image_ComfyUI/resolve/main/split_files/vae/qwen_image_vae.safetensors"
fi

echo "=== Custom setup: завершено ==="
