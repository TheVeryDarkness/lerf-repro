# LERF

## 复现过程

前两步参见 [nerfstudio 安装教程](https://docs.nerf.studio/quickstart/installation.html)。

1. 首先拉取 nerfstudio 所需的 Docker 镜像。

   ```sh
   docker pull dromni/nerfstudio:0.1.18
   ```

2. 启动需要的 Docker 容器。

   ```sh
   docker run --gpus all -u lerf -v D:/lerf-repro/workspace:/workspace/ -v D:/lerf-repro/.cache/:/home/user/.cache/ -p 7007:7007 --name lerf -it --shm-size=12gb dromni/nerfstudio:0.1.18
   ```

3. 启动 Docker 容器并且进行初始化。

   ```sh
   cd /workspace/
   sudo apt update
   git clone https://github.com/kerrj/lerf
   cd /workspace/lerf
   python -m pip install -e .
   ns-install-cli
   ns-train -h
   ```

4. 下载 lerf 使用的图像数据并解压。
5. 复现。

```sh
ns-train lerf --data /workspace/data/book_store --output-dir /workspace/output
```

### 预训练数据集的下载

模型中用到的预训练数据集为 laion/CLIP-ViT-B-16-laion2B-s34B-b88K。

### AutoDL

最后还是选择了租显卡的方式。

### 一些杂乱的脚本

```sh
# 很好用
unzip /workspace/models--laion--CLIP-ViT-B-16-laion2B-s34B-b88K.zip -d /home/user/.cache/huggingface/hub/
```

```sh
# 很好用
scp -r -P 17766 ~/Downloads/Datasets-20231209T150610Z-001.zip root@connect.westc.gpuhub.com:/root
```

```sh
# 很好用
scp -r -P 17766 ~/Downloads/Datasets-20231209T150610Z-001.zip root@connect.westc.gpuhub.com:/root
```

```sh
#!/bin/bash
set -eux
model=$1
ns-train lerf --data /root/autodl-tmp/data/Datasets/$model --output-dir /root/autodl-tmp/output --viewer.websocket-port 6006 --vis viewer_beta --viewer.make-share-url True | tee -a /root/autodl-tmp/logs/$model.log
```

```sh
# 这个被前面的脚本替代了
model=book_store
ns-train lerf --data /root/autodl-tmp/data/Datasets/$model --output-dir /root/autodl-tmp/output --viewer.websocket-port 6006 --vis viewer_beta --viewer.make-share-url True | tee -a /root/autodl-tmp/logs/$model.log; /usr/bin/shutdown
```

```sh
# 这个没用上
# ssh -p 11650 root@connect.westb.seetacloud.com
# https://u284056-9dfc-50b47bb3.westb.seetacloud.com:8443/
user=root
host=u284056-9dfc-50b47bb3.westb.seetacloud.com
port=8443
ssh -L 7007:$host:$port $user@$host
# https://viewer.nerf.studio/versions/23-05-15-1/?websocket_url=ws://localhost:6006
# https://viewer.nerf.studio/versions/23-05-15-1/?websocket_url=ws://lu284056-9dfc-50b47bb3.westb.seetacloud.com:8443
```
