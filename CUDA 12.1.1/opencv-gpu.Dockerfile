# Stage 1: Build OpenCV with CUDA
FROM nvidia/cuda:12.1.1-cudnn8-devel-ubuntu22.04

# Ensure non-interactive installation
ENV DEBIAN_FRONTEND=noninteractive

# Install Python 3.10 and required dependencies
RUN apt-get update && apt-get install -y \
    python3.10 python3.10-dev python3.10-distutils python3.10-venv python3-pip \
    cmake git curl build-essential pkg-config \
    libtbb2 libtbb-dev libgtk2.0-dev \
    libjpeg-dev libpng-dev libtiff-dev \
    libavcodec-dev libavformat-dev libswscale-dev \
    ffmpeg libv4l-dev gstreamer1.0-tools gstreamer1.0-libav gstreamer1.0-plugins-good libx264-dev \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Install numpy 1.23.5
RUN python3.10 -m pip install --no-cache-dir numpy==1.23.5

# Clone OpenCV source and build with CUDA
RUN git clone --depth=1 https://github.com/opencv/opencv.git && \
    git clone --depth=1 https://github.com/opencv/opencv_contrib.git && \
    mkdir -p opencv/build && cd opencv/build && \
    cmake -D CMAKE_BUILD_TYPE=Release \
          -D CMAKE_INSTALL_PREFIX=/usr/local \
          -D OPENCV_EXTRA_MODULES_PATH=../../opencv_contrib/modules \
          -D WITH_CUDA=ON \
          -D ENABLE_FAST_MATH=1 \
          -D CUDA_FAST_MATH=1 \
          -D WITH_CUBLAS=1 \
          -D WITH_TBB=ON \
          -D WITH_V4L=ON \
          -D WITH_OPENGL=ON \
          -D WITH_FFMPEG=ON \
          -D WITH_GSTREAMER=ON \
          -D BUILD_opencv_python3=ON \
          -D CUDA_ARCH_BIN="8.6" \
          -D PYTHON_EXECUTABLE=/usr/bin/python3.10 \
          -D OPENCV_GENERATE_PKGCONFIG=ON \
          -D PYTHON3_PACKAGES_PATH=/usr/lib/python3.10/dist-packages \
          -D PYTHON3_NUMPY_INCLUDE_DIRS=/usr/local/lib/python3.10/dist-packages/numpy/core/include \
          -D BUILD_SHARED_LIBS=ON \
          -D OPENCV_ENABLE_NONFREE=OFF .. && \
    make -j$(nproc) && make install && ldconfig

# Keep container alive
CMD ["sleep", "infinity"]