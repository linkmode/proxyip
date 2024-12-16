#!/bin/bash

# 获取脚本所在的目录的绝对路径
SCRIPT_DIR=$(dirname "$(readlink -f "$0")")

# 定义日志文件
LOG_FILE="$SCRIPT_DIR/run.log"

# 确保进入脚本所在的目录
cd "$SCRIPT_DIR" || { echo "无法进入脚本所在目录"; exit 1; }

# 清空日志文件
> "$LOG_FILE"

# 写入日志的函数
log() {
  local message=$1
  local timestamp
  timestamp=$(date "+%Y-%m-%d %H:%M:%S")
  echo "[$timestamp] $message" >> "$LOG_FILE"
}

# 初始化日志文件
log "脚本执行开始..."

# 关闭openclash
/etc/init.d/openclash stop

# 定义路径和文件名
cloudflarest_path="./CloudflareST"
output_file="./result.txt"
upload_file="./result_upload.txt"
github_repo_path="./" # 替换为你的 GitHub 项目本地路径
commit_message="Update result_upload.txt with new IPs"

# 检查 CloudflareST 工具是否存在
if [ ! -f "$cloudflarest_path" ]; then
  log "CloudflareST 工具未找到，请确认路径：$cloudflarest_path"
  echo "CloudflareST 工具未找到，请确认路径：$cloudflarest_path"
  exit 1
fi
log "CloudflareST 工具已找到：$cloudflarest_path"

# 检查 GitHub 项目路径是否存在
if [ ! -d "$github_repo_path" ]; then
  log "GitHub 项目路径未找到：$github_repo_path"
  echo "GitHub 项目路径未找到：$github_repo_path"
  exit 1
fi
log "GitHub 项目路径已找到：$github_repo_path"

# 运行 CloudflareST 工具
echo "正在运行 CloudflareST..."
log "正在运行 CloudflareST..."
"$cloudflarest_path" -o "$output_file" -sl 5 -dn 10 -tll 40 -tl 230 -tlr 0.2 -cfcolo ATL,LAX,ORD,JFK,SFO,MIA,DFW,SEA,EWR,PHX
#"$cloudflarest_path" -o "$output_file" -dn 10 -tll 40 -tl 230 -tlr 0.2

# 检查是否成功生成 result.txt
if [ ! -f "$output_file" ]; then
  log "CloudflareST 运行失败，未生成 $output_file。"
  echo "CloudflareST 运行失败，未生成 $output_file。"
  exit 1
fi
log "CloudflareST 运行完成，结果已保存到 $output_file。"

# 提取 IP 地址并保存到 result_upload.txt
echo "正在提取 IP 地址..."
log "正在提取 IP 地址..."
awk -F ',' 'NR > 1 {print $1 "#" "Best " NR-1}' "$output_file" > "$upload_file"

# 检查是否成功生成 result_upload.txt
if [ -f "$upload_file" ]; then
  log "IP 地址提取完成，结果已保存到 $upload_file。"
  echo "IP 地址提取完成，结果已保存到 $upload_file。"
else
  log "IP 地址提取失败，未生成 $upload_file。"
  echo "IP 地址提取失败，未生成 $upload_file。"
  exit 1
fi

# 提交文件到 GitHub
echo "正在提交文件到 GitHub..."
log "正在提交文件到 GitHub..."
git add result_upload.txt
git commit -m "$commit_message"
git push origin main # 确保远程分支名称为 'main'，如果是 'master'，请替换为 'master'

# 检查提交状态
if [ $? -eq 0 ]; then
  log "文件已成功上传到 GitHub！"
  echo "文件已成功上传到 GitHub！"
else
  log "上传到 GitHub 失败，请检查是否正确配置了远程仓库。"
  echo "上传到 GitHub 失败，请检查是否正确配置了远程仓库。"
fi

#更新openclash订阅
/usr/share/openclash/openclash.sh

#重启openclash
/etc/init.d/openclash restart



log "脚本执行结束。"
