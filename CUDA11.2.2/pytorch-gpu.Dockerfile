# Stage 2: Build PyTorch with CUDA
FROM ghcr.io/neurotoxin0/opencv-gpu:cuda11.2.2

# Install PyTorch
RUN pip install --no-cache-dir torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu113

# Keep container alive
CMD ["sleep", "infinity"]