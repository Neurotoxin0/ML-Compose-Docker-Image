# Stage 4: Final Image with OpenCV, PyTorch (and TensorFlow if using CUDA 11.2.2)
FROM opencv-pytorch-tensorflow-gpu:cuda11.2.2
#FROM opencv-pytorch-gpu:cuda12.1.1


# Set working directory
WORKDIR /app

# Copy your scripts
COPY ./my-project /app/

# Install dependencies
RUN pip3 install --no-cache-dir -r requirements.txt

# Set Python3 as default
RUN ln -s /usr/bin/python3 /usr/bin/python

# Keep container alive
#CMD ["sleep", "infinity"]
CMD ["python", "main.py"]
