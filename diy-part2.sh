#!/bin/bash
#
# Copyright (c) 2019-2020 P3TERX <https://p3terx.com>
#
# This is free software, licensed under the MIT License.
# See /LICENSE for more information.
#
# https://github.com/P3TERX/Actions-OpenWrt
# File name: diy-part2.sh
# Description: OpenWrt DIY script part 2 (After Update feeds)
#

# Modify default IP
#sed -i 's/192.168.1.1/192.168.50.5/g' package/base-files/files/bin/config_generate

# 修改IP项的EOF于EOF之间请不要插入其他扩展代码，可以删除或注释里面原本的代码
# 如果你的OP是当主路由的话，网关、DNS、广播都不需要，代码前面加 # 注释掉，只保留后台地址和子网掩码就可以
# 如果你有编译ipv6的话，‘去掉LAN口使用内置的 IPv6 管理’代码前面也加 # 注释掉

cat >$NETIP <<-EOF
uci set network.lan.ipaddr='10.10.10.1'                                    # IPv4 地址(openwrt后台地址)
uci set network.lan.netmask='255.255.255.0'                                 # IPv4 子网掩码
#uci set network.lan.gateway='192.168.2.1'                                   # IPv4 网关
#uci set network.lan.broadcast='192.168.2.255'                               # IPv4 广播
#uci set network.lan.dns='114.114.114.114 223.5.5.5'                         # DNS(多个DNS要用空格分开)
#uci set network.lan.delegate='0'                                            # 去掉LAN口使用内置的 IPv6 管理
uci commit network                                                          # 不要删除跟注释,除非上面全部删除或注释掉了
#uci set dhcp.lan.ignore='1'                                                 # 关闭DHCP功能
#uci commit dhcp                                                             # 跟‘关闭DHCP功能’联动,同时启用或者删除跟注释
uci set system.@system[0].hostname='OpenWrt-N1'                             # 修改主机名称为Phicomm-N1
sed -i 's/\/bin\/login/\/bin\/login -f root/' /etc/config/ttyd             # 设置ttyd免帐号登录，如若开启，进入OPENWRT后可能要重启一次才生效
EOF


sed -i 's/luci-theme-bootstrap/luci-theme-argon/g' feeds/luci/collections/luci/Makefile           # 选择argon为默认主题

sed -i "s/OpenWrt /Deng Compiled in $(TZ=UTC-8 date "+%Y.%m.%d") @ OpenWrt /g" $ZZZ          # 增加个性名字${Author}默认为你的github账号

sed -i '/CYXluq4wUazHjmCDBCqXF/d' $ZZZ                                                            # 设置密码为空


# 拉取软件包
git clone -b luci https://github.com/pexcn/openwrt-chinadns-ng.git package/luci-app-chinadns-ng