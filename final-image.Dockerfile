# Stage 4: Final Image with OpenCV, PyTorch (and TensorFlow if using CUDA 11.2.2)
FROM ghcr.io/neurotoxin0/opencv-pytorch-tensorflow-gpu:cuda11.2.2
#FROM ghcr.io/neurotoxin0/opencv-pytorch-gpu:cuda12.1.1

# Set working directory
WORKDIR /app

# Copy your scripts
COPY ./my-project /app/

# Backup OpenCV CUDA-enabled version before installing dependencies
RUN cp -r $(python3 -c "import cv2; print(cv2.__path__[0])") /cv2_backup

# Install dependencies
RUN pip3 install --no-cache-dir -r requirements.txt

# Empty the cv2 folder before restoring the backup
RUN rm -rf $(python3 -c "import cv2; print(cv2.__path__[0])")/*

# Restore the OpenCV CUDA backup to prevent losing CUDA support
RUN cp -r /cv2_backup/* $(python3 -c "import cv2; print(cv2.__path__[0])")

# Set Python3 as default
RUN ln -s /usr/bin/python3 /usr/bin/python

# Keep container alive
#CMD ["sleep", "infinity"]
CMD ["python", "main.py"]
