#!/bin/bash
# 修改默认后台地址为 192.168.2.1
sed -i 's/192.168.1.1/192.168.2.1/g' package/base-files/files/bin/config_generate

# 添加 WiFi 配置脚本
mkdir -p files/etc/uci-defaults
cat <<EOF > files/etc/uci-defaults/99-wifi-enable-ssid
#!/bin/sh
uci set wireless.@wifi-device[0].disabled='0'
uci set wireless.@wifi-iface[0].disabled='0'
uci set wireless.@wifi-iface[0].ssid='MyNewifi_2.4G'
uci set wireless.@wifi-device[1].disabled='0'
uci set wireless.@wifi-iface[1].disabled='0'
uci set wireless.@wifi-iface[1].ssid='MyNewifi_5G'
uci commit wireless
EOF

chmod +x files/etc/uci-defaults/99-wifi-enable-ssid
