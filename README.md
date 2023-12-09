# LERF

## 复现过程

前两步参见 [nerfstudio 安装教程](https://docs.nerf.studio/quickstart/installation.html)。

1. 首先拉取 nerfstudio 所需的 Docker 镜像。

   ```pwsh
   docker pull dromni/nerfstudio:0.1.18
   ```

2. 启动需要的 Docker 容器。

   ```pwsh
   docker run --gpus all -u lerf -v D:/lerf-repro/workspace:/workspace/ -v D:/lerf-repro/.cache/:/home/user/.cache/ -p 7007:7007 --name lerf -it --shm-size=12gb dromni/nerfstudio:0.1.18
   ```

3. 启动 Docker 容器并且进行初始化。

   ```sh
   cd /workspace/ && \
   sudo apt update && \
   git clone https://github.com/kerrj/lerf && \
   cd /workspace/lerf && \
   python3 -m pip install -e . && \
   ns-install-cli && \
   ns-train -h
   ```

4. 下载 lerf 使用的图像数据并解压。
5. 复现。

  ```sh
  ns-train lerf --data /workspace/data/<data_folder> --out-dir /workspace/output
  ```
