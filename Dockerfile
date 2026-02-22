FROM ashleykza/comfyui:cu128-py311-v0.3.76

RUN cd /ComfyUI/custom_nodes && \
    git clone https://github.com/rgthree/rgthree-comfy.git && \
    git clone https://github.com/kijai/ComfyUI-KJNodes.git && \
    git clone https://github.com/cubiq/ComfyUI_essentials.git && \
    git clone https://github.com/ClownsharkBatwing/RES4LYF.git && \
    git clone https://github.com/chflame163/ComfyUI_LayerStyle_Advance.git && \
    git clone https://github.com/M1kep/ComfyLiterals.git && \
    git clone https://github.com/JPS-GER/ComfyUI_JPS-Nodes.git

# Устанавливаем pip-зависимости всех нод в venv ComfyUI
RUN . /ComfyUI/venv/bin/activate && \
    for dir in /ComfyUI/custom_nodes/*/; do \
        if [ -f "${dir}requirements.txt" ]; then \
            echo "Installing deps for $(basename $dir)..." && \
            pip install -r "${dir}requirements.txt" --quiet; \
        fi; \
    done && \
    deactivate

COPY custom_setup.sh /custom_setup.sh
RUN chmod +x /custom_setup.sh

RUN sed -i '/^# Start application manager/i # === Custom setup: private nodes + models ===\n/custom_setup.sh\n' /pre_start.sh
