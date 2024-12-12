#!/bin/bash

# 获取脚本所在的目录的绝对路径
SCRIPT_DIR=$(dirname "$(readlink -f "$0")")

# 确保进入脚本所在的目录
cd "$SCRIPT_DIR" || { echo "无法进入脚本所在目录"; exit 1; }

# 下载 CloudflareST 工具的压缩包到当前目录
wget -N wget -N https://ghp.ci/https://github.com/XIU2/CloudflareSpeedTest/releases/download/v2.2.5/CloudflareST_linux_amd64.tar.gz

# 解压缩 tar.gz 文件到当前目录
tar -zxf CloudflareST_linux_amd64.tar.gz

# 给解压后的 CloudflareST 可执行文件添加执行权限
chmod +x CloudflareST

# 提示用户下载并解压完成
echo "CloudflareST 已下载并解压到当前目录，已授予执行权限"
