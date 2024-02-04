#!/bin/bash
svn_export() {
	# 参数1是分支名, 参数2是子目录, 参数3是目标目录, 参数4仓库地址
	TMP_DIR="$(mktemp -d)" || exit 1
 	ORI_DIR="$PWD"
	[ -d "$3" ] || mkdir -p "$3"
	TGT_DIR="$(cd "$3"; pwd)"
	git clone --depth 1 -b "$1" "$4" "$TMP_DIR" >/dev/null 2>&1 && \
	cd "$TMP_DIR/$2" && rm -rf .git >/dev/null 2>&1 && \
	cp -af . "$TGT_DIR/" && cd "$ORI_DIR"
	rm -rf "$TMP_DIR"
}


# 删除冲突软件和依赖
rm -rf feeds/packages/lang/golang 
rm -rf feeds/luci/applications/luci-app-pushbot feeds/luci/applications/luci-app-serverchan
git clone https://github.com/sbwml/packages_lang_golang -b 21.x feeds/packages/lang/golang
# 下载插件
git clone --depth 1 https://github.com/zzsj0928/luci-app-pushbot feeds/luci/applications/luci-app-pushbot
git clone --depth 1 https://github.com/gngpp/luci-theme-design package/luci-theme-design
git clone --depth 1 https://github.com/sbwml/luci-app-alist package/luci-app-alist
git clone --depth 1 https://github.com/sirpdboy/netspeedtest package/netspeedtest
git clone --depth 1 https://github.com/lxl6125/openwrt-qbittorrent-enhanced package/openwrt-qbittorrent-enhanced
git clone --depth 1 -b 18.06 https://github.com/jerrykuku/luci-app-argon-config package/luci-app-argon-config
git clone --depth 1 https://github.com/xiaorouji/openwrt-passwall-packages package/openwrt-passwall-packages
git clone -b openwrt-18.06 --depth 1 https://github.com/tty228/luci-app-wechatpush feeds/luci/applications/luci-app-serverchan
git clone --depth 1 https://github.com/fw876/helloworld package/helloworld
git clone --depth 1 https://github.com/kenzok78/luci-app-adguardhome package/luci-app-adguardhome
git clone --depth 1 https://github.com/wangqn/luci-app-filebrowser package/luci-app-filebrowser
svn_export "main" "luci-app-passwall" "package/luci-app-passwall" "https://github.com/xiaorouji/openwrt-passwall"
svn_export "main" "luci-app-passwall2" "package/luci-app-passwall2" "https://github.com/xiaorouji/openwrt-passwall2"
svn_export "master" "luci-app-diskman" "package/luci-app-diskman" "https://github.com/kiddin9/openwrt-packages"
svn_export "main" "luci-app-amlogic" "package/luci-app-amlogic" "https://github.com/ophub/luci-app-amlogic"
svn_export "main" "openwrt/luci-app-thunder" "package/luci-app-thunder" "https://github.com/gngpp/nas-xunlei"
svn_export "main" "openwrt/thunder" "package/thunder" "https://github.com/gngpp/nas-xunlei"
svn_export "dev" "luci-app-openclash" "package/luci-app-openclash" "https://github.com/vernesong/OpenClash"

# 编译 po2lmo (如果有po2lmo可跳过)
#pushd package/luci-app-openclash/tools/po2lmo
#make && sudo make install
#popd
# 微信推送&全能推送
sed -i "s|qidian|bilibili|g" feeds/luci/applications/luci-app-pushbot/root/usr/bin/pushbot/pushbot
sed -i "s|qidian|bilibili|g" feeds/luci/applications/luci-app-serverchan/root/usr/share/serverchan/serverchan
# xfsprogs修复
sed -i 's/-DHAVE_MAP_SYNC/-DHAVE_MAP_SYNC -D_LARGEFILE64_SOURCE/' feeds/packages/utils/xfsprogs/Makefile
cat utils/xfsprogs/Makefile
# 替换argon主题
rm -rf feeds/luci/themes/luci-theme-argon
git clone -b 18.06 https://github.com/jerrykuku/luci-theme-argon.git ./feeds/luci/themes/luci-theme-argon
find ./ | grep Makefile | grep v2ray-geodata | xargs rm -f
git clone https://github.com/sbwml/v2ray-geodata package/v2ray-geodata
# 个性化设置
cd package
sed -i "s/OpenWrt /Wing build $(TZ=UTC-8 date "+%Y.%m.%d") @ OpenWrt /g" lean/default-settings/files/zzz-default-settings
sed -i "/firewall\.user/d" lean/default-settings/files/zzz-default-settings
sed -i "s|https.*/amlogic-s9xxx-openwrt|https://github.com/OldCoding/openwrt_packit_arm|g" luci-app-amlogic/root/etc/config/amlogic
sed -i "s|s9xxx_lede|ARMv8-le|g" luci-app-amlogic/root/etc/config/amlogic
# 更新passwall规则
curl -sfL -o ./luci-app-passwall/root/usr/share/passwall/rules/gfwlist https://raw.githubusercontent.com/Loyalsoldier/v2ray-rules-dat/release/gfw.txt
# OpenClash
cd ./luci-app-openclash/root/etc/openclash
CORE_VER=https://github.com/vernesong/OpenClash/raw/core/dev/core_version
CORE_TUN=https://github.com/vernesong/OpenClash/raw/core/dev/premium/clash-linux-arm64
CORE_DEV=https://github.com/vernesong/OpenClash/raw/core/dev/dev/clash-linux-arm64.tar.gz
CORE_MATE=https://github.com/vernesong/OpenClash/raw/core/dev/meta/clash-linux-arm64.tar.gz
TUN_VER=$(curl -sfL $CORE_VER | sed -n "2{s/\r$//;p;q}")
curl -sfL -o ./Country.mmdb https://github.com/alecthw/mmdb_china_ip_list/raw/release/Country.mmdb
curl -sfL -o ./GeoSite.dat https://github.com/Loyalsoldier/v2ray-rules-dat/raw/release/geosite.dat
curl -sfL -o ./GeoIP.dat https://github.com/Loyalsoldier/v2ray-rules-dat/raw/release/geoip.dat
mkdir ./core && cd ./core
curl -sfL -o ./tun.gz "$CORE_TUN"-"$TUN_VER".gz && gzip -d ./tun.gz && mv ./tun ./clash_tun
curl -sfL -o ./meta.tar.gz "$CORE_MATE" && tar -zxf ./meta.tar.gz && mv ./clash ./clash_meta
curl -sfL -o ./dev.tar.gz "$CORE_DEV" && tar -zxf ./dev.tar.gz
chmod +x ./clash* ; rm -rf ./*.gz
cd $GITHUB_WORKSPACE/openwrt && cd feeds/luci/applications/luci-app-wrtbwmon
sed -i 's/ selected=\"selected\"//g' ./luasrc/view/wrtbwmon/wrtbwmon.htm && sed -i 's/\"1\"/\"1\" selected=\"selected\"/g' ./luasrc/view/wrtbwmon/wrtbwmon.htm
sed -i 's/interval: 5/interval: 1/g' ./htdocs/luci-static/wrtbwmon/wrtbwmon.js
