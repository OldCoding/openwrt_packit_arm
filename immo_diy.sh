#!/bin/bash
svn_export() {
	# 参数1是分支名, 参数2是子目录, 参数3是目标目录, 参数4仓库地址
 	echo -e "clone $4/$2 to $3"
	TMP_DIR="$(mktemp -d)" || exit 1
 	ORI_DIR="$PWD"
	[ -d "$3" ] || mkdir -p "$3"
	TGT_DIR="$(cd "$3"; pwd)"
	git clone --depth 1 -b "$1" "$4" "$TMP_DIR" >/dev/null 2>&1 && \
	cd "$TMP_DIR/$2" && rm -rf .git >/dev/null 2>&1 && \
	cp -af . "$TGT_DIR/" && cd "$ORI_DIR"
	rm -rf "$TMP_DIR"
}

#rm -rf package/libs/mbedtls

# 依赖和冲突
rm -rf feeds/packages/lang/golang
rm -rf feeds/luci/applications/luci-app-cloudflared
rm -rf feeds/luci/applications/luci-app-openclash
rm -rf feeds/luci/applications/luci-app-filebrowser
#rm -rf feeds/packages/utils/filebrowser
rm -rf feeds/luci/applications/luci-app-passwall
rm -rf feeds/packages/net/v2ray-geodata
rm -rf feeds/packages/net/mosdns
rm -rf feeds/packages/net/speedtest-cli
rm -rf feeds/packages/utils/docker-compose
rm -rf feeds/packages/utils/docker
rm -rf feeds/packages/utils/dockerd
rm -rf feeds/packages/utils/containerd
rm -rf feeds/packages/utils/runc
rm -rf feeds/luci/applications/luci-app-unblockneteasemusic
rm -rf feeds/packages/net/aria2
rm -rf feeds/luci/themes/luci-theme-argon
git clone --depth 1 https://github.com/jerrykuku/luci-theme-argon feeds/luci/themes/luci-theme-argon
git clone --depth 1 https://github.com/danchexiaoyang/luci-app-kodexplorer package/luci-app-kodexplorer
git clone --depth 1 https://github.com/sbwml/feeds_packages_net_aria2 feeds/packages/net/aria2
git clone --depth 1 https://github.com/sbwml/packages_lang_golang feeds/packages/lang/golang
git clone --depth 1 https://github.com/zyqfork/luci-app-pushbot package/luci-app-pushbot
git clone --depth 1 https://github.com/jerrykuku/luci-app-argon-config package/luci-app-argon-config
git clone --depth 1 https://github.com/sbwml/v2ray-geodata package/v2ray-geodata
git clone --depth 1 https://github.com/fw876/helloworld package/helloworld
git clone --depth 1 https://github.com/sirpdboy/luci-app-adguardhome package/adguardhome
git clone --depth 1 https://github.com/sbwml/luci-app-openlist2 package/openlist2
git clone --depth 1 https://github.com/xiaorouji/openwrt-passwall-packages package/openwrt-passwall-packages
git clone --depth 1 https://github.com/OldCoding/luci-app-filebrowser package/luci-app-filebrowser
git clone --depth 1 https://github.com/sirpdboy/netspeedtest package/netspeedtest
#git clone --depth 1 https://github.com/UnblockNeteaseMusic/luci-app-unblockneteasemusic package/luci-app-unblockneteasemusic
#git clone --depth 1 https://github.com/hudra0/luci-app-qosmate package/luci-app-qosmate
#git clone --depth 1 https://github.com/hudra0/qosmate package/qosmate
git clone --depth 1 https://github.com/kenzok78/luci-app-design-config package/luci-app-design-config
svn_export "master" "luci-app-tailscale-community" "package/luci-app-tailscale" "https://github.com/Tokisaki-Galaxy/luci-app-tailscale-community"
svn_export "master" "applications/luci-app-cloudflared" "feeds/luci/applications/luci-app-cloudflared" "https://github.com/openwrt/luci"
svn_export "main" "wrtbwmon" "package/wrtbwmon" "https://github.com/gitbruc/openwrt-wrtbwmon"
svn_export "main" "luci-app-wrtbwmon" "package/luci-app-wrtbwmon" "https://github.com/gitbruc/openwrt-wrtbwmon"
svn_export "main" "luci-app-passwall2" "package/luci-app-passwall2" "https://github.com/xiaorouji/openwrt-passwall2"
svn_export "main" "luci-app-passwall" "package/luci-app-passwall" "https://github.com/xiaorouji/openwrt-passwall"
svn_export "dev" "luci-app-openclash" "package/luci-app-openclash" "https://github.com/vernesong/OpenClash"
svn_export "main" "luci-app-amlogic" "package/luci-app-amlogic" "https://github.com/ophub/luci-app-amlogic"
svn_export "v5" "luci-app-mosdns" "package/luci-app-mosdns" "https://github.com/sbwml/luci-app-mosdns"
svn_export "v5" "mosdns" "package/mosdns" "https://github.com/sbwml/luci-app-mosdns"
svn_export "v5" "v2dat" "package/v2dat" "https://github.com/sbwml/luci-app-mosdns"
svn_export "main" "lucky" "package/lucky" "https://github.com/gdy666/luci-app-lucky"
svn_export "main" "luci-app-lucky" "package/luci-app-lucky" "https://github.com/gdy666/luci-app-lucky"
svn_export "openwrt-23.05" "themes/luci-theme-design" "package/luci-theme-design" "https://github.com/coolsnowwolf/luci"
svn_export "master" "utils/docker-compose" "feeds/packages/utils/docker-compose" "https://github.com/coolsnowwolf/packages"
svn_export "master" "utils/docker" "feeds/packages/utils/docker" "https://github.com/coolsnowwolf/packages"
svn_export "master" "utils/dockerd" "feeds/packages/utils/dockerd" "https://github.com/coolsnowwolf/packages"
svn_export "master" "utils/containerd" "feeds/packages/utils/containerd" "https://github.com/coolsnowwolf/packages"
svn_export "master" "utils/runc" "feeds/packages/utils/runc" "https://github.com/coolsnowwolf/packages"
svn_export "master" "net/cloudflared" "feeds/packages/net/cloudflared" "https://github.com/openwrt/packages"
svn_export "main" "easytier" "package/easytier" "https://github.com/EasyTier/luci-app-easytier"
svn_export "main" "luci-app-easytier" "package/luci-app-easytier" "https://github.com/EasyTier/luci-app-easytier"

rm -rf package/luci-theme-design/root/etc/uci-defaults/30_luci-theme-design
mv ./package/netspeedtest/* ./package/ && rm -rf ./package/netspeedtest
mv ./package/openlist2/* ./package/ && rm -rf ./package/openlist2
mv ./package/luci-app-adguardhome/* ./package/ && rm -rf ./package/adguardhome


# turboacc 补丁
#curl -sSL https://raw.githubusercontent.com/chenmozhijin/turboacc/luci/add_turboacc.sh -o add_turboacc.sh && bash -x add_turboacc.sh

# adguardhome
#VER=$(grep PKG_VERSION package/luci-app-adguardhome/Makefile | sed 's/-/\./g')
#sed -i "s/PKG_VERSION:=.*/$VER/g" package/luci-app-adguardhome/Makefile

# 调整菜单位置
sed -i "s|services|nas|g" package/luci-app-openlist2/root/usr/share/luci/menu.d/luci-app-openlist2.json
sed -i "s|services|nas|g" feeds/luci/applications/luci-app-qbittorrent/root/usr/share/luci/menu.d/luci-app-qbittorrent.json
sed -i "s|services|network|g" feeds/luci/applications/luci-app-nlbwmon/root/usr/share/luci/menu.d/luci-app-nlbwmon.json
sed -i "s|services|vpn|g" package/luci-app-tailscale/root/usr/share/luci/menu.d/luci-app-tailscale-community.json
# 微信推送&全能推送
sed -i "s|qidian|bilibili|g" package/luci-app-pushbot/root/usr/bin/pushbot/pushbot
# DNS劫持
sed -i '/dns_redirect/d' package/network/services/dnsmasq/files/dhcp.conf
# 个性化设置
sed -i "s/(\(luciversion || ''\))/(\1) + (' \/ Wing build $(TZ=UTC-8 date "+%Y.%m.%d")')/g" $(find feeds/luci/modules/luci-mod-status/ -type f -name "10_system.js")
sed -i "s|breakings|OldCoding|g" package/luci-app-amlogic/root/etc/config/amlogic
sed -i "s|OpenWrt|openwrt_packit_arm|g" package/luci-app-amlogic/root/etc/config/amlogic
sed -i "s|ARMv8|ARMv8-im|g" package/luci-app-amlogic/root/etc/config/amlogic
rm -rf package/luci-app-netspeedtest/po/zh_Hans
cd package
# NTP服务器
sed -i "s|\'time1\.apple\.com\'|\'0\.openwrt\.pool\.ntp\.org\'|g" base-files/files/bin/config_generate
sed -i "s|\'time1\.google\.com\'|\'1\.openwrt\.pool\.ntp\.org\'|g" base-files/files/bin/config_generate
sed -i "s|\'time\.cloudflare\.com\'|\'2\.openwrt\.pool\.ntp\.org\'|g" base-files/files/bin/config_generate
sed -i "s|\'pool\.ntp\.org\'|\'3\.openwrt\.pool\.ntp\.org\'|g" base-files/files/bin/config_generate
# 汉化
curl -sfL -o ./convert_translation.sh https://github.com/kenzok8/small-package/raw/main/.github/diy/convert_translation.sh
chmod +x ./convert_translation.sh && bash ./convert_translation.sh
# OpenClash
cd ./luci-app-openclash/root/etc/openclash
#CORE_VER=https://github.com/vernesong/OpenClash/raw/refs/heads/core/dev/core_version
#CORE_TUN=https://github.com/vernesong/OpenClash/raw/refs/heads/core/dev/premium/clash-linux-arm64
#CORE_DEV=https://github.com/vernesong/OpenClash/raw/refs/heads/core/dev/dev/clash-linux-arm64.tar.gz
CORE_MATE=https://github.com/vernesong/OpenClash/raw/refs/heads/core/dev/smart/clash-linux-arm64.tar.gz
#TUN_VER=$(curl -sfL $CORE_VER | sed -n "2{s/\r$//;p;q}")
curl -sfL -o ./Country.mmdb https://github.com/alecthw/mmdb_china_ip_list/raw/release/Country.mmdb
curl -sfL -o ./GeoSite.dat https://github.com/Loyalsoldier/v2ray-rules-dat/raw/release/geosite.dat
curl -sfL -o ./GeoIP.dat https://github.com/Loyalsoldier/v2ray-rules-dat/raw/release/geoip.dat
mkdir ./core && cd ./core
#curl -sfL -o ./tun.gz "$CORE_TUN"-"$TUN_VER".gz && gzip -d ./tun.gz && mv ./tun ./clash_tun
curl -sfL -o ./meta.tar.gz "$CORE_MATE" && tar -zxf ./meta.tar.gz && mv ./clash ./clash_meta
#curl -sfL -o ./dev.tar.gz "$CORE_DEV" && tar -zxf ./dev.tar.gz
chmod +x ./clash* ; rm -rf ./*.gz
