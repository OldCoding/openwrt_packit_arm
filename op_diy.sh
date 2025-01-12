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
#rm -rf package/libs/ustream-ssl
#rm -rf package/libs/uclient

find ./ | grep Makefile | grep v2ray-geodata | xargs rm -f
find ./ | grep Makefile | grep mosdns | xargs rm -f

# 删除冲突软件和依赖
rm -rf feeds/packages/lang/golang 
rm -rf feeds/luci/applications/luci-app-dockerman
rm -rf feeds/luci/applications/luci-app-alist
rm -rf feeds/packages/net/aria2
rm -rf feeds/packages/libs/libtorrent-rasterbar
git clone --depth 1 https://github.com/sbwml/feeds_packages_net_aria2 feeds/packages/net/aria2
curl -sfL https://github.com/immortalwrt/luci/raw/master/modules/luci-base/root/usr/share/luci/menu.d/luci-base.json > feeds/luci/modules/luci-base/root/usr/share/luci/menu.d/luci-base.json
git clone https://github.com/sbwml/packages_lang_golang feeds/packages/lang/golang

# 下载插件
git clone --depth 1 https://github.com/zzsj0928/luci-app-pushbot package/luci-app-pushbot
git clone --depth 1 https://github.com/danchexiaoyang/luci-app-kodexplorer package/luci-app-kodexplorer
git clone --depth 1 https://github.com/sbwml/luci-app-alist package/luci-app-alist
git clone --depth 1 https://github.com/jerrykuku/luci-theme-argon package/luci-theme-argon
git clone --depth 1 https://github.com/jerrykuku/luci-app-argon-config package/luci-app-argon-config
git clone --depth 1 https://github.com/xiaorouji/openwrt-passwall-packages package/openwrt-passwall-packages
git clone --depth 1 https://github.com/fw876/helloworld package/helloworld
git clone --depth 1 https://github.com/chenmozhijin/luci-app-adguardhome package/luci-app-adguardhome
git clone --depth 1 https://github.com/sbwml/v2ray-geodata package/v2ray-geodata
git clone --depth 1 https://github.com/OldCoding/luci-app-filebrowser package/luci-app-filebrowser
#git clone --depth 1 https://github.com/UnblockNeteaseMusic/luci-app-unblockneteasemusic package/luci-app-unblockneteasemusic
git clone --depth 1 https://github.com/hudra0/luci-app-qosmate package/luci-app-qosmate
git clone --depth 1 https://github.com/hudra0/qosmate package/qosmate
svn_export "main" "luci-app-passwall" "package/luci-app-passwall" "https://github.com/xiaorouji/openwrt-passwall"
svn_export "main" "luci-app-passwall2" "package/luci-app-passwall2" "https://github.com/xiaorouji/openwrt-passwall2"
svn_export "main" "luci-app-amlogic" "package/luci-app-amlogic" "https://github.com/ophub/luci-app-amlogic"
svn_export "dev" "luci-app-openclash" "package/luci-app-openclash" "https://github.com/vernesong/OpenClash"
svn_export "master" "applications/luci-app-socat" "feeds/luci/applications/luci-app-socat" "https://github.com/immortalwrt/luci"
svn_export "master" "applications/luci-app-qbittorrent" "feeds/luci/applications/luci-app-qbittorrent" "https://github.com/immortalwrt/luci"
svn_export "master" "applications/luci-app-dockerman" "feeds/luci/applications/luci-app-dockerman" "https://github.com/immortalwrt/luci"
svn_export "master" "applications/luci-app-wechatpush" "feeds/luci/applications/luci-app-wechatpush" "https://github.com/immortalwrt/luci"
svn_export "master" "applications/luci-app-ramfree" "feeds/luci/applications/luci-app-ramfree" "https://github.com/immortalwrt/luci"
svn_export "master" "applications/luci-app-webadmin" "feeds/luci/applications/luci-app-webadmin" "https://github.com/immortalwrt/luci"
svn_export "master" "applications/luci-app-usb-printer" "feeds/luci/applications/luci-app-usb-printer" "https://github.com/immortalwrt/luci"
svn_export "master" "applications/luci-app-vsftpd" "feeds/luci/applications/luci-app-vsftpd" "https://github.com/immortalwrt/luci"
svn_export "master" "applications/luci-app-vlmcsd" "feeds/luci/applications/luci-app-vlmcsd" "https://github.com/immortalwrt/luci"
svn_export "master" "applications/luci-app-zerotier" "feeds/luci/applications/luci-app-zerotier" "https://github.com/immortalwrt/luci"
svn_export "master" "applications/luci-app-diskman" "feeds/luci/applications/luci-app-diskman" "https://github.com/immortalwrt/luci"
svn_export "master" "applications/luci-app-autoreboot" "feeds/luci/applications/luci-app-autoreboot" "https://github.com/immortalwrt/luci"
svn_export "master" "applications/luci-app-rclone" "feeds/luci/applications/luci-app-rclone" "https://github.com/immortalwrt/luci"
svn_export "master" "wrtbwmon" "package/wrtbwmon" "https://github.com/firker/luci-app-wrtbwmon-zh"
svn_export "master" "net/rclone" "feeds/packages/net/rclone" "https://github.com/immortalwrt/packages"
svn_export "master" "net/rclone-webui-react" "feeds/packages/net/rclone-webui-react" "https://github.com/immortalwrt/packages"
svn_export "master" "net/rclone-ng" "feeds/packages/net/rclone-ng" "https://github.com/immortalwrt/packages"
svn_export "master" "net/qBittorrent-Enhanced-Edition" "feeds/packages/net/qBittorrent-Enhanced-Edition" "https://github.com/immortalwrt/packages"
svn_export "master" "net/ddns-scripts_aliyun" "feeds/packages/net/ddns-scripts_aliyun" "https://github.com/immortalwrt/packages"
svn_export "master" "net/ddns-scripts_dnspod" "feeds/packages/net/ddns-scripts_dnspod" "https://github.com/immortalwrt/packages"
svn_export "master" "net/vlmcsd" "feeds/packages/net/vlmcsd" "https://github.com/immortalwrt/packages"
svn_export "master" "libs/qt6base" "feeds/packages/libs/qt6base" "https://github.com/immortalwrt/packages"
svn_export "master" "libs/libtorrent-rasterbar" "feeds/packages/libs/libtorrent-rasterbar" "https://github.com/immortalwrt/packages"
svn_export "master" "libs/libdouble-conversion" "feeds/packages/libs/libdouble-conversion" "https://github.com/immortalwrt/packages"
svn_export "master" "utils/qt6tools" "feeds/packages/utils/qt6tools" "https://github.com/immortalwrt/packages"
svn_export "v5" "luci-app-mosdns" "package/luci-app-mosdns" "https://github.com/sbwml/luci-app-mosdns"
svn_export "v5" "mosdns" "package/mosdns" "https://github.com/sbwml/luci-app-mosdns"
svn_export "v5" "v2dat" "package/v2dat" "https://github.com/sbwml/luci-app-mosdns"
svn_export "master" "package/emortal" "package/emortal" "https://github.com/immortalwrt/immortalwrt"
svn_export "master" "luci-app-netspeedtest" "package/luci-app-netspeedtest" "https://github.com/sirpdboy/netspeedtest"
svn_export "master" "homebox" "package/homebox" "https://github.com/sirpdboy/netspeedtest"

rm -rf ./package/emortal/autocore

git clone --depth 1 https://github.com/sbwml/autocore-arm package/emortal/autocore

#svn_export "master" "package/libs/mbedtls" "package/libs/mbedtls" "https://github.com/coolsnowwolf/lede"
#svn_export "master" "package/libs/ustream-ssl" "package/libs/ustream-ssl" "https://github.com/coolsnowwolf/lede"
#svn_export "master" "package/libs/uclient" "package/libs/uclient" "https://github.com/coolsnowwolf/lede"

# turboacc 补丁
#curl -sSL https://raw.githubusercontent.com/chenmozhijin/turboacc/luci/add_turboacc.sh -o add_turboacc.sh && bash -x add_turboacc.sh

# 安装插件
./scripts/feeds update -i
./scripts/feeds install -a

# 编译 po2lmo (如果有po2lmo可跳过)
#pushd package/luci-app-openclash/tools/po2lmo
#make && sudo make install
#popd

# homebox
#latest_ver=$(curl -sfL https://api.github.com/repos/XGHeaven/homebox/releases/latest |grep -E 'tag_name'|head -n1|cut -d '"' -f4|sed 's/\./\\\./g')
#sed -i "s/PKG_VERSION:=.*/PKG_VERSION:=$latest_ver/" package/homebox/Makefile
sed -i 's/2023102203/2024101306/g' package/homebox/Makefile

# adguardhome
#VER=$(grep PKG_VERSION package/luci-app-adguardhome/Makefile | sed 's/-/\./g')
#sed -i "s/PKG_VERSION:=.*/$VER/g" package/luci-app-adguardhome/Makefile

# 调整菜单位置
sed -i "s|services|nas|g" feeds/luci/applications/luci-app-transmission/root/usr/share/luci/menu.d/luci-app-transmission.json
sed -i "s|services|nas|g" feeds/luci/applications/luci-app-qbittorrent/root/usr/share/luci/menu.d/luci-app-qbittorrent.json
sed -i "s|services|nas|g" feeds/luci/applications/luci-app-aria2/root/usr/share/luci/menu.d/luci-app-aria2.json
sed -i "s|services|nas|g" feeds/luci/applications/luci-app-hd-idle/root/usr/share/luci/menu.d/luci-app-hd-idle.json
sed -i "s|services|nas|g" feeds/luci/applications/luci-app-samba4/root/usr/share/luci/menu.d/luci-app-samba4.json
sed -i "s|services|system|g" feeds/luci/applications/luci-app-ttyd/root/usr/share/luci/menu.d/luci-app-ttyd.json
sed -i "s|services|network|g" feeds/luci/applications/luci-app-nlbwmon/root/usr/share/luci/menu.d/luci-app-nlbwmon.json
# 微信推送&全能推送
sed -i "s|qidian|bilibili|g" package/luci-app-pushbot/root/usr/bin/pushbot/pushbot
# 个性化设置
cd package
sed -i "s|breakings|OldCoding|g" luci-app-amlogic/root/etc/config/amlogic
sed -i "s|OpenWrt|openwrt_packit_arm|g" luci-app-amlogic/root/etc/config/amlogic
sed -i "s|ARMv8|ARMv8-op|g" luci-app-amlogic/root/etc/config/amlogic
# 汉化
curl -sfL -o ./convert_translation.sh https://github.com/kenzok8/small-package/raw/main/.github/diy/convert_translation.sh
chmod +x ./convert_translation.sh && bash ./convert_translation.sh
# 更新passwall规则
curl -sfL -o ./luci-app-passwall/root/usr/share/passwall/rules/gfwlist https://raw.githubusercontent.com/Loyalsoldier/v2ray-rules-dat/release/gfw.txt
# OpenClash
cd ./luci-app-openclash/root/etc/openclash
#CORE_VER=https://github.com/vernesong/OpenClash/raw/refs/heads/core/dev/core_version
#CORE_TUN=https://github.com/vernesong/OpenClash/raw/refs/heads/core/dev/premium/clash-linux-arm64
#CORE_DEV=https://github.com/vernesong/OpenClash/raw/refs/heads/core/dev/dev/clash-linux-arm64.tar.gz
CORE_MATE=https://github.com/vernesong/OpenClash/raw/refs/heads/core/dev/meta/clash-linux-arm64.tar.gz
#TUN_VER=$(curl -sfL $CORE_VER | sed -n "2{s/\r$//;p;q}")
curl -sfL -o ./Country.mmdb https://github.com/alecthw/mmdb_china_ip_list/raw/release/Country.mmdb
curl -sfL -o ./GeoSite.dat https://github.com/Loyalsoldier/v2ray-rules-dat/raw/release/geosite.dat
curl -sfL -o ./GeoIP.dat https://github.com/Loyalsoldier/v2ray-rules-dat/raw/release/geoip.dat
mkdir ./core && cd ./core
#curl -sfL -o ./tun.gz "$CORE_TUN"-"$TUN_VER".gz && gzip -d ./tun.gz && mv ./tun ./clash_tun
curl -sfL -o ./meta.tar.gz "$CORE_MATE" && tar -zxf ./meta.tar.gz && mv ./clash ./clash_meta
#curl -sfL -o ./dev.tar.gz "$CORE_DEV" && tar -zxf ./dev.tar.gz
chmod +x ./clash* ; rm -rf ./*.gz
