FROM ashleykza/comfyui:cu128-py311-v0.3.76

COPY pre_start.sh /pre_start.sh
RUN chmod +x /pre_start.sh
