#!/bin/bash

echo "=== Custom setup: начало ==="

if [ ! -d "/workspace/ComfyUI" ]; then
    echo "ОШИБКА: /workspace/ComfyUI не найден!"
    exit 1
fi

cd /workspace/ComfyUI/custom_nodes

# ============================================================
# 1. Приватный репозиторий
# ============================================================
if [ ! -d "sf-copy-photo-nodes" ]; then
    if [ -z "$GITHUB_TOKEN" ]; then
        echo "ОШИБКА: GITHUB_TOKEN не задан!"
    else
        echo "  -> Клонирование sf-copy-photo-nodes (приватный)..."
        git clone --depth 1 https://${GITHUB_TOKEN}@github.com/Pabbbel/ComfyUI-SFRealCopy.git sf-copy-photo-nodes

        if [ -f "sf-copy-photo-nodes/requirements.txt" ]; then
            source /workspace/ComfyUI/venv/bin/activate
            pip install -r sf-copy-photo-nodes/requirements.txt --quiet
            deactivate
        fi
    fi
fi

# ============================================================
# 2. Скачивание моделей 
# ============================================================
echo "Скачивание моделей (aria2, параллельно)..."

mkdir -p /workspace/ComfyUI/models/diffusion_models
mkdir -p /workspace/ComfyUI/models/text_encoders
mkdir -p /workspace/ComfyUI/models/vae
mkdir -p /workspace/ComfyUI/models/loras

download() {
    local url="$1"
    local dir="$2"
    local filename="$3"

    if [ ! -f "${dir}/${filename}" ]; then
        echo "  -> ${filename}"
        aria2c -x 16 -s 16 -k 1M \
            --file-allocation=none \
            --console-log-level=error \
            --summary-interval=0 \
            -d "$dir" -o "$filename" \
            "$url"
    else
        echo "  -> ${filename} (уже есть, пропуск)"
    fi
}

MODELS_DIR="/workspace/ComfyUI/models"

download \
    "https://huggingface.co/Comfy-Org/z_image_turbo/resolve/main/split_files/diffusion_models/z_image_turbo_bf16.safetensors" \
    "${MODELS_DIR}/diffusion_models" \
    "z_image_turbo_bf16.safetensors" &

download \
    "https://huggingface.co/Comfy-Org/z_image_turbo/resolve/main/split_files/text_encoders/qwen_3_4b.safetensors" \
    "${MODELS_DIR}/text_encoders" \
    "qwen_3_4b.safetensors" &

download \
    "https://huggingface.co/Comfy-Org/z_image_turbo/resolve/main/split_files/vae/ae.safetensors" \
    "${MODELS_DIR}/vae" \
    "ae.safetensors" &

download \
    "https://huggingface.co/Comfy-Org/Qwen-Image_ComfyUI/resolve/main/split_files/diffusion_models/qwen_image_bf16.safetensors" \
    "${MODELS_DIR}/diffusion_models" \
    "qwen_image_bf16.safetensors" &

download \
    "https://huggingface.co/Comfy-Org/Qwen-Image_ComfyUI/resolve/main/split_files/text_encoders/qwen_2.5_vl_7b.safetensors" \
    "${MODELS_DIR}/text_encoders" \
    "qwen_2.5_vl_7b.safetensors" &

download \
    "https://huggingface.co/Comfy-Org/Qwen-Image_ComfyUI/resolve/main/split_files/vae/qwen_image_vae.safetensors" \
    "${MODELS_DIR}/vae" \
    "qwen_image_vae.safetensors" &

echo "Ожидание завершения всех загрузок..."
wait

echo "=== Custom setup: завершено ==="
