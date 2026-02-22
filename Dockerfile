FROM ashleykza/comfyui:cu128-py311-v0.3.76

RUN apt-get update && apt-get install -y --no-install-recommends aria2 && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

RUN cd /ComfyUI/custom_nodes && \
    git clone --depth 1 https://github.com/rgthree/rgthree-comfy.git && \
    git clone --depth 1 https://github.com/kijai/ComfyUI-KJNodes.git && \
    git clone --depth 1 https://github.com/cubiq/ComfyUI_essentials.git && \
    git clone --depth 1 https://github.com/ClownsharkBatwing/RES4LYF.git && \
    git clone --depth 1 https://github.com/chflame163/ComfyUI_LayerStyle_Advance.git && \
    git clone --depth 1 https://github.com/M1kep/ComfyLiterals.git && \
    git clone --depth 1 https://github.com/JPS-GER/ComfyUI_JPS-Nodes.git

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
