# LERF

## 可视化

- Hide Scene
- rgb/relevancy/composited

## 关键词

## 论文

- Waldo Kitchen
  - Multi-Scale Semantics
    - Utensils
    - Wooden spoon
  - Abstract Queries
    - Electricity
  - Text Reading
    - Boops
  - Long-Tail Objects
    - Blue dish soap
    - Waldo
    - Paper Towel Roll
  - Visual Properties
    - Yellow
  - Fig. 5
    - Wooden spoon
  - Fig. 6
    - ?
  - Fig. 7
    - Sink
    - Mug
  - FIg. 9
    - Cookbooks
    - Olive oil
- Teatime
  - Fig. 5
    - stuffed bear
- Bookstore
  - Fig. 3
    - embroidery
    - the cookie bible
    - marie kondo
- Ramen
  - Fig. 3 & Fig. 5
    - eggs
    - nori
    - glass of water
- Figurines
  - cartoon
  - bath toy
  - toy elephant
  - jake from adventure time
  - waldo
  - leaf (failures)
  - table (failures)
- Bouquet
  - lily
  - vase

## 严佬

- Waldo Kitchen
  - pot

### teatime

两只玩偶的下午茶时间。

复现部分：

整活部分：

- bear
- dish
- desk
- table
- edge
- air
- human
- leg
- bag
- cup
- nose
- chair
- tile
- sitting human
- woman

### book_store

- book
- ground
- floor
- ground
- bookcover
- bookstand
- bookstand third
- bookshelf
- piano
- recipe
- cook
- cookbook
- wooden
- dark
- yellow

### Wadlo Kitchen

整活：

- Holder
- Handle

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
   while (true)
   do
   {
      git clone https://github.com/kerrj/lerf
      if [ $? -eq 0 ]; then
          break
      fi
   }
   done && \
   cd /workspace/lerf && \
   python3 -m pip install -e . && \
   ns-install-cli && \
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
scp -r -P 17766 ~/Downloads/models--laion--CLIP-ViT-B-16-laion2B-s34B-b88K.zip root@connect.westc.gpuhub.com:/root
```

```sh
x11vnc -display 127.0.0.1:0 -create -rfbport 6006
x11vnc -display localhost:0 -create -rfbport 6006
uAVdJPAQqkTv

ssh -p 11650 root@connect.westb.seetacloud.com
ssh -CNg -L 6006:127.0.0.1:6006 root@123.125.240.150 -p 42151 # https://www.autodl.com/docs/ssh_proxy/
ssh -CNg -L 6006:127.0.0.1:6006 root@connect.westb.seetacloud.com -p 11650
```

```sh
#!/bin/bash
set -eux
model=$1

CKPT="/root/autodl-tmp/output/$model/lerf/latest/nerfstudio_models"
LOAD=""
if [ -d $CKPT ]; then
    LOAD="--load-dir $CKPT"
fi

STEP=""
if [ $# -gt 1 ]; then
    STEP="--optimizers.fields.scheduler.max-steps $2"
fi

ns-train lerf --data /root/autodl-tmp/data/Datasets/$model --output-dir /root/autodl-tmp/output --timestamp latest $LOAD $STEP --viewer.websocket-port 7007 --viewer.websocket-port-default 7007 --vis viewer | tee -a /root/autodl-tmp/logs/$model.log
```

```sh
# 这个被前面的脚本替代了
set -eux
model=book_store
ns-train lerf --data /root/autodl-tmp/data/Datasets/$model --output-dir /root/autodl-tmp/output --viewer.websocket-port 6006 --viewer.websocket-port-default 6006 --vis viewer | tee -a /root/autodl-tmp/logs/$model.log; /usr/bin/shutdown
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
# https://viewer.nerf.studio/versions/23-05-15-1/?websocket_url=wss://lu284056-9dfc-50b47bb3.westb.seetacloud.com:8443
```

```sh
rsync -auv -e "ssh -p $port" ~/.cache/huggingface/hub/$model_name $user@$host:~/.cache/huggingface/hub/

rsync -auv -e 'ssh -p $port' --exclude .git $user@$host:~/sirui-workspace/lerf ~/Projects/lerf-repro/lerf

# Don't commit the line below.
rsync -auv -e 'ssh -p 6380' ~/.cache/huggingface/hub/models--timm--ViT-B-16-SigLIP-512 miyan@58.214.239.10:/home/miyan/.cache/huggingface/hub/

rsync -auv -e 'ssh -p 31654' ~/.cache/huggingface/hub/models--timm--eva02_large_patch14_clip_224.merged2b_s4b_b131k root@connect.westb.seetacloud.com:/root/.cache/huggingface/hub

python -m pip uninstall -y lerf && python -m pip install ./lerf

ssh -p 31654 root@connect.westb.seetacloud.com

rsync -auv -e 'ssh -p 31654' /Users/huangboyi/Projects/lerf-repro/lerf root@connect.westb.seetacloud.com:/root/autodl-tmp/try

# Don't commit the line below.
rsync -auv -e 'ssh -p 6380' miyan@58.214.239.10:/home/miyan/sirui-workspace/lerf /Users/huangboyi/Projects/lerf-repro
rsync -auv -e 'ssh -p 6380' /Users/huangboyi/Projects/lerf-repro/lerf miyan@58.214.239.10:/home/miyan/sirui-workspace
```

## 改进的尝试

我们尝试了很多最近的新工作，并尝试将其整合在一起。

最终我们选择了，将原先模型中的 OpenCLIP 实现替换为 EVA02，并向 LeRF 使用的 NeRF 模型中添加了 SAM 场。

### SigLIP

我们尝试了一下 SigLIP（`ViT-SO400M-14-SigLIP`），但发现表现有所下降。

我们猜测是因为 Sigmoid 函数并不适合该问题。

### DINOv2

我们尝试将 LERF 中使用的 DINO 替换为 DINO v2，但是没有明显的改善，并且 DINO v2 只支持 size 为 14 的 patch，替换后会引入修改输入图片尺寸等很多麻烦。

### NeRRF

我们推测，复现过程中 hand_hand 和 ramen 场景出现了扭曲现象，是因为这两个场景中存在具有反射和折射效果的物体。

我们调研了相关的工作，发现 NeRRF，但由于 NeRRF 的输入中需要深度信息，无法直接用于 LERF 使用的数据集，我们最终没能在本次大作业中使用该模型。

### Instant NGP

虽然 NeRF Studio 中包含了 Instant NGP，但是两个模型的输出不完全相同，所以无法直接采用，最后作罢。

### Segment Anything Model
