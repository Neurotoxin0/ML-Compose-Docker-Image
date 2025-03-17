# Compose Docker Image for Python with OpenCV, PyTorch, and TensorFlow (CUDA Support)

This project provides **multi-stage Docker builds** for:
- **Python 3.8** or **Python 3.9**
- **OpenCV with CUDA support** (`opencv-gpu`)
- **PyTorch with GPU acceleration** (`pytorch-gpu`)
- **TensorFlow with GPU support** (`tensorflow-gpu`) *(Only available for CUDA 11)*
- **A final minimal image** (`final-image`) that merges all components and includes user scripts.

This approach ensures **modular, lightweight, and efficient** deep learning containerization.

---

## 🛠 CUDA Version

| Component   | CUDA 11.2.2 | CUDA 12.1.1 |
|------------|------------|------------|
| **OpenCV** | ✅ Supported | ✅ Supported |
| **PyTorch** | ✅ Supported | ✅ Supported |
| **TensorFlow** | ✅ Supported (TF 2.10.1) | ❌ Not Supported |
| **Final Merged Image** | ✅ Includes all components | ✅ Includes OpenCV & PyTorch |

Each CUDA version has **its own folder**:
- **`CUDA 11.2.2/`** → Includes OpenCV, PyTorch, and TensorFlow
- **`CUDA 12.1.1/`** → Includes OpenCV and PyTorch (No TensorFlow support)

---

## Multi-Stage Build Process

This project uses **multi-stage builds** to:
- **Reduce final image size** by removing unnecessary build dependencies.
- **Modularize components**, making updates and debugging easier.
- **Allow separate testing** of OpenCV, PyTorch, and TensorFlow before merging.

### Pre-Compiled Images Available on GHCR

For convenience, **pre-compiled** Docker images built from this project are available on **GHCR** (**GitHub Container Registry**). These images are quite large (~20GB for OpenCV and ~28GB for OpenCV+PyTorch), but they are ready to use without requiring local compilation.

You can pull them directly using:

#### 🔹 **Pre-Compiled OpenCV-GPU**
- **CUDA 11.2.2**: `ghcr.io/neurotoxin0/opencv-gpu:cuda11.2.2`
- **CUDA 12.1.1**: `ghcr.io/neurotoxin0/opencv-gpu:cuda12.1.1`

#### 🔹 **Pre-Compiled PyTorch-GPU**
- **CUDA 11.2.2**: `ghcr.io/neurotoxin0/opencv-pytorch-gpu:cuda11.2.2`
- **CUDA 12.1.1**: `ghcr.io/neurotoxin0/opencv-pytorch-gpu:cuda12.1.1`

#### 🔹 **Pre-Compiled TensorFlow-GPU (Only CUDA 11.2.2)**
- **CUDA 11.2.2**: `ghcr.io/neurotoxin0/opencv-pytorch-tensorflow-gpu:cuda11.2.2`

These images are directly usable and can be run with:
```
docker run --gpus all -itd --rm ghcr.io/neurotoxin0/ml-combined:cuda12.1.1 sleep infinity
```

If you prefer to **build locally**, follow the instructions below.


### **1️⃣ Build OpenCV-GPU Image**
#### 🔹 **For CUDA 11.2.2**
```
docker build -t opencv-gpu:cuda11.2.2 -f CUDA\ 11.2.2/opencv-gpu.Dockerfile .
```

#### 🔹 **For CUDA 12.1.1**
```
docker build -t opencv-gpu:cuda12.1.1 -f CUDA\ 12.1.1/opencv-gpu.Dockerfile .
```

### **2️⃣ Build PyTorch-GPU Image**
#### 🔹 **For CUDA 11.2.2**
```
docker build -t opencv-pytorch-gpu:cuda11.2.2 -f CUDA\ 11.2.2/pytorch-gpu.Dockerfile .
```

#### 🔹 **For CUDA 12.1.1**
```
docker build -t opencv-pytorch-gpu:cuda12.1.1 -f CUDA\ 12.1.1/pytorch-gpu.Dockerfile .
```

### **3️⃣ Build TensorFlow-GPU Image (Only for CUDA 11.2.2)**
```
docker build -t opencv-pytorch-tensorflow-gpu:cuda11.2.2 -f CUDA\ 11.2.2/tensorflow-gpu.Dockerfile .
```

### **4️⃣ Build the Final Combined Image**
Modify ***final-image.Dockerfile*** to specify which base image to use (CUDA 11.2.2 or CUDA 12.1.1).
Ensure your project folder is structured according to the [**Project Structure**](#project-structure) section for seamless integration.

#### 🔹 **For CUDA 11.2.2 (Includes OpenCV, PyTorch, TensorFlow)**
```
docker build -t ml-combined:cuda11.2.2 -f final-image.Dockerfile .
```

#### 🔹 **For CUDA 12.1.1 (Includes OpenCV, PyTorch)**
```
docker build -t ml-combined:cuda12.1.1 -f final-image.Dockerfile .
```

---

## Running the Final Image

To start a container with **GPU support** and keep it running:
#### 🔹 **For CUDA 11.2.2**
```
docker run --gpus all -itd --rm ml-combined:cuda11.2.2 sleep infinity
```

#### 🔹 **For CUDA 12.1.1**
```
docker run --gpus all -itd --rm ml-combined:cuda12.1.1 sleep infinity
```

### **Verify GPU Availability**
Inside the running container:
```
python3 -c "import cv2; print(cv2.cuda.getCudaEnabledDeviceCount())"

python3 -c "import torch; print(torch.cuda.is_available(), torch.cuda.get_device_name(0))"

python3 -c "import tensorflow as tf; print(tf.config.list_physical_devices('GPU'))"
```
*(Note: TensorFlow test will fail in CUDA 12.1.1 since it's not supported.)*

---

## Project Structure

```
/docker-project
│── CUDA 11.2.2/
│   │── opencv-gpu.Dockerfile
│   │── pytorch-gpu.Dockerfile
│   │── tensorflow-gpu.Dockerfile
│── CUDA 12.1.1/
│   │── opencv-gpu.Dockerfile
│   │── pytorch-gpu.Dockerfile
│── final-image.Dockerfile  # Works with both CUDA versions
│── README.md
│── my_project/
│   │── requirements.txt
│   │── script1.py
│   │── script2.py
│   └── ...
```

---

## Customization

### Modify CUDA Version
- Change **nvidia/cuda:<version>** in the Dockerfiles to your required CUDA version.

### Add Additional Python Packages
- Modify ***requirements.txt*** in your project and rebuild:
```
docker build -t ml-combined:cuda11.2.2 -f final-image.Dockerfile .
```
```
docker build -t ml-combined:cuda12.1.1 -f final-image.Dockerfile .
```

---

## Why Multi-Stage Builds?

✅ **Reduces final image size**  
✅ **Speeds up builds** by reusing pre-built images  
✅ **Improves maintainability** by keeping components separate  
✅ **Optimized for cloud deployments** (Kubernetes, OpenShift, Argo Workflows)

---

## Troubleshooting

### OpenCV Doesn't Detect CUDA
Try running:
```
python3 -c "import cv2; print(cv2.cuda.getCudaEnabledDeviceCount())"
```
If it prints `0`, OpenCV was **not built with CUDA support**. Rebuild the `opencv-gpu` image and **check the CMake flags**.

### TensorFlow Not Using GPU
Ensure:
```
python3 -c "import tensorflow as tf; print(tf.config.list_physical_devices('GPU'))"
```
If this returns `[]`, check:
- **CUDA version compatibility with TensorFlow**
- **NVIDIA drivers installed on the host machine**
- **TensorFlow is installed with GPU support (`tensorflow==2.10.1 or BELOW`)**
  - Newer versions (TensorFlow 2.11 and above) only support CPU; official GPU support has been discontinued. To use GPU support, you need to build from source or obtain it through third-party sources (Anaconda or Docker).

---
