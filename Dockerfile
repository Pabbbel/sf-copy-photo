FROM ashleykza/comfyui:cu128-py311-v0.3.76

COPY start.sh /start.sh
RUN chmod +x /start.sh

CMD ["/start.sh"]