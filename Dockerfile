FROM ashleykza/comfyui:cu128-py311-v0.3.76

COPY custom_setup.sh /custom_setup.sh
RUN chmod +x /custom_setup.sh

# Место: после синхронизации ComfyUI в /workspace, но ДО запуска Application Manager и ComfyUI
RUN sed -i '/^# Start application manager/i # === Custom setup: models + custom nodes ===\n/custom_setup.sh\n' /pre_start.sh
