#!/bin/bash

# 设置仓库目录（根据你的实际情况修改）
REPO_DIR="./"
cd "$REPO_DIR" || { echo "无法进入仓库目录"; exit 1; }

# 检查是否有任何未提交的更改
if git diff-index --quiet HEAD --; then
    echo "没有更改需要提交"
else
    # 添加所有更改的文件
    git add .

    # 提交更改
    git commit -m "Update files"  # 你可以根据需要修改提交信息

    # 推送更改到 GitHub
    git push origin main  # 如果你的默认分支是 main，使用 main；如果是 master，请改为 master
    echo "更新已推送到 GitHub"
fi
