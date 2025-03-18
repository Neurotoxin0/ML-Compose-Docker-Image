# Stage 2: Build PyTorch with CUDA
FROM ghcr.io/neurotoxin0/opencv-gpu:cuda12.1.1

# Install PyTorch
RUN pip install --no-cache-dir torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu121

# Keep container alive
CMD ["sleep", "infinity"]