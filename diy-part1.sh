#!/bin/bash

# 修改默认后台地址为 192.168.2.1
sed -i 's/192.168.1.1/192.168.2.1/g' package/base-files/files/bin/config_generate
sed -i 's/192.168.1.1/192.168.2.1/g' package/base-files/luci2/bin/config_generate
# 1. 更新 OpenWrt feeds 配置
echo "更新 OpenWrt feeds 配置..."
echo "src-git helloworld https://github.com/fw876/helloworld" >> feeds.conf.default
echo "更新 feeds 完成"

# 2. 添加必要的软件包
echo "安装额外的软件包（如 SSR Plus）..."
./scripts/feeds update -a
./scripts/feeds install -a

# 3. 安装 WiFi 闭源驱动（MTK 驱动）
echo "安装 MTK 闭源驱动..."
./scripts/feeds install kmod-mt7603e
./scripts/feeds install kmod-mt7615e

# 4. 安装其他依赖
echo "安装其他依赖包..."
./scripts/feeds install libustream-openssl
./scripts/feeds install ipset
./scripts/feeds install iptables-mod-tproxy

# 完成
echo "diy-part1.sh 配置完成"
