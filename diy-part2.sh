#!/bin/bash
# 修改默认后台地址为 192.168.2.1
sed -i 's/192.168.1.1/192.168.2.1/g' package/base-files/files/bin/config_generate
sed -i 's/192.168.1.1/192.168.2.1/g' package/base-files/luci2/bin/config_generate

# 添加 WiFi 配置脚本
mkdir -p files/etc/uci-defaults
cat <<EOF > files/etc/uci-defaults/99-wifi-enable-ssid
#!/bin/sh

# 打开无线设备
ifconfig ra0 down
ifconfig rai0 down

# 设置第一个无线接口 SSID 和密码
iwpriv ra0 set SSID="PHICOMM"
iwpriv ra0 set AuthMode="WPA2PSK"
iwpriv ra0 set EncrypType="AES"
iwpriv ra0 set WPAPSK="ikommql45.."
iwpriv ra0 set RadioOn=1

# 设置第二个无线接口 SSID 和密码
iwpriv rai0 set SSID="PHICOMM"
iwpriv rai0 set AuthMode="WPA2PSK"
iwpriv rai0 set EncrypType="AES"
iwpriv rai0 set WPAPSK="ikommql45.."
iwpriv rai0 set RadioOn=1
ifconfig ra0 up
ifconfig rai0 up
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
