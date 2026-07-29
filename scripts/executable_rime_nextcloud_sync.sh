#!/bin/bash

# --- 配置区域 ---
# 源文件路径（数组，可以写多个）
SOURCE_FILES=(
  "/home/jackwy/.local/share/fcitx5/rime/kongmingma.schema.yaml"
  "/home/jackwy/.local/share/fcitx5/rime/kongmingma.dict.yaml"
)

# Nextcloud 同步目录
NEXTCLOUD_DIR="/home/jackwy/Nextcloud/kmrime/"

# 日志文件路径 (可选，方便排查问题)
LOG_FILE="/tmp/rime_nextcloud_sync.log"
# ----------------

echo "开始监控文件..." >>"$LOG_FILE"

# 所有源文件必须位于同一目录下（否则需要起多个 inotifywait）
WATCH_DIR=$(dirname "${SOURCE_FILES[0]}")

echo "监控目录: $WATCH_DIR" >>"$LOG_FILE"
echo "监控文件: ${SOURCE_FILES[*]}" >>"$LOG_FILE"

# 使用 inotifywait 监控目录而非具体文件
# 原因：nvim 保存文件采用"写临时文件→删除原文件→重命名"策略，会导致 inode 改变。
# 如果 inotifywait 直接监控文件路径，原 inode 被删除后就不再触发事件。
# 改为监控目录，在 bash 层按文件名过滤，即使文件被重建也能捕获。
inotifywait -m -e close_write,moved_to,create --format '%w%f' "$WATCH_DIR" | while read FILE; do
  # 只处理我们关注的文件名
  base=$(basename "$FILE")
  should_process=false
  for f in "${SOURCE_FILES[@]}"; do
    if [ "$(basename "$f")" = "$base" ]; then
      should_process=true
      break
    fi
  done
  $should_process || continue
  echo "$(date): 检测到 $FILE 发生变化，正在复制..." >>"$LOG_FILE"

  cp -f --preserve=mode,timestamps "$FILE" "$NEXTCLOUD_DIR/"

  if [ $? -eq 0 ]; then
    echo "$(date): 复制成功，Nextcloud 客户端将自动检测上传。" >>"$LOG_FILE"
  else
    echo "$(date): 复制失败！" >>"$LOG_FILE"
  fi
done
