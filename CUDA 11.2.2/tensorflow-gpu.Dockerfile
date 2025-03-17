# Stage 3: Build TensorFlow with CUDA
FROM ghcr.io/neurotoxin0/opencv-pytorch-gpu:cuda11.2.2

# Install TensorFlow 2.10.1
RUN pip install --no-cache-dir tensorflow==2.10.1

# Keep container alive
CMD ["sleep", "infinity"]