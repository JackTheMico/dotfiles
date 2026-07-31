#!/bin/bash

echo "========================================="
echo "  Vial 键盘权限修复脚本"
echo "========================================="
echo ""

# 获取用户信息
USER_NAME=$(whoami)
USER_GID=$(id -g)
USER_UID=$(id -u)

echo "用户: $USER_NAME"
echo "UID: $USER_UID"
echo "GID: $USER_GID"
echo ""

# 删除所有旧的 vial 规则
echo "【1】清理旧的 udev 规则..."
sudo rm -f /etc/udev/rules.d/*vial*.rules
sudo rm -f /etc/udev/rules.d/*jezail*.rules
sudo rm -f /etc/udev/rules.d/*cornix*.rules

# 创建新的完整规则
echo "【2】创建新的 udev 规则..."
sudo tee /etc/udev/rules.d/59-vial.rules >/dev/null <<'EOF'
# Vial 键盘 - 通过 serial 标识
KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{serial}=="*vial:f64c2b3c*", MODE="0666", GROUP="users", TAG+="uaccess", TAG+="udev-acl"

# Vial 键盘 - 通过 VID/PID 标识（双重保险）
KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="e118", ATTRS{idProduct}=="0001", MODE="0666", GROUP="users", TAG+="uaccess", TAG+="udev-acl"

# USB 设备节点权限（重要！）
SUBSYSTEM=="usb", ATTRS{idVendor}=="e118", ATTRS{idProduct}=="0001", MODE="0666", GROUP="users", TAG+="uaccess"
EOF

echo "✓ 规则文件已创建"
echo ""

# 显示规则内容
echo "【3】规则内容："
cat /etc/udev/rules.d/59-vial.rules
echo ""

# 重新加载规则
echo "【4】重新加载 udev 规则..."
sudo udevadm control --reload-rules
sudo udevadm trigger
echo "✓ 规则已重新加载"
echo ""

# 立即应用权限到现有设备
echo "【5】立即应用权限到现有设备..."
for i in /dev/hidraw*; do
  if [ -e "$i" ]; then
    INFO=$(udevadm info -a -n "$i" 2>/dev/null)
    if echo "$INFO" | grep -q "vial:f64c2b3c\|e118"; then
      echo "  设置权限: $i"
      sudo chmod 666 "$i"
      sudo chown root:users "$i" 2>/dev/null
    fi
  fi
done

# USB 设备节点
for usb_dev in /dev/bus/usb/001/*; do
  if [ -e "$usb_dev" ]; then
    INFO=$(udevadm info -a -n "$usb_dev" 2>/dev/null)
    if echo "$INFO" | grep -q "e118"; then
      echo "  设置 USB 权限: $usb_dev"
      sudo chmod 666 "$usb_dev"
    fi
  fi
done

echo ""
echo "========================================="
echo "✓ 修复完成！"
echo "========================================="
echo ""
echo "下一步："
echo "1. 在浏览器中刷新 vial.rocks 页面"
echo "2. 如果还不行，拔掉键盘 USB 重新插上"
echo "3. 如果还不行，重启电脑"

======================================================================
