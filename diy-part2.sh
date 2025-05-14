#!/bin/bash
# 修改默认后台地址为 192.168.2.1
sed -i 's/192.168.1.1/192.168.2.1/g' package/base-files/files/bin/config_generate
sed -i 's/192.168.1.1/192.168.2.1/g' package/base-files/luci2/bin/config_generate

# 添加 WiFi 配置脚本
mkdir -p files/etc/uci-defaults
cat <<EOF > files/etc/uci-defaults/99-wifi-enable-ssid
#!/bin/sh
uci set wireless.@wifi-device[0].disabled='0'
uci set wireless.@wifi-iface[0].disabled='0'
uci set wireless.@wifi-iface[0].ssid='PHICOMM'
uci set wireless.@wifi-iface[0].key='ikommql45..'
uci set wireless.@wifi-device[1].disabled='0'
uci set wireless.@wifi-iface[1].disabled='0'
uci set wireless.@wifi-iface[1].ssid='PHICOMM'
uci set wireless.@wifi-iface[1].key='ikommql45..'
uci commit wireless
EOF

chmod +x files/etc/uci-defaults/99-wifi-enable-ssid

# 创建 xray 脚本放入文件系统的 /bin 目录
mkdir -p files/bin
cat <<EOF > files/bin/xray
#!/bin/sh

# 检查 /tmp/xray 是否存在，如果不存在则下载
if [ ! -f /tmp/xray ]; then
    while ! (curl -sfL -o /tmp/xray http://47.240.47.94/xray); do
        sleep 1  # 每次下载失败后等待 1 秒
    done
fi

# 给 xray 文件添加执行权限
chmod +x /tmp/xray

# 运行 xray，传递所有参数
/tmp/xray "\$@"

# 退出脚本
exit 0
EOF

# 给 xray 脚本添加执行权限
chmod +x files/bin/xray
