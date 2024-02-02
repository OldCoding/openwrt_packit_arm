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

find ./ | grep Makefile | grep v2ray-geodata | xargs rm -f
find ./ | grep Makefile | grep mosdns | xargs rm -f

git clone --depth 1 https://github.com/zzsj0928/luci-app-pushbot package/luci-app-pushbot
git clone --depth 1 https://github.com/sirpdboy/netspeedtest package/custom/netspeedtest
git clone --depth 1 https://github.com/jerrykuku/luci-app-argon-config package/luci-app-argon-config
git clone --depth 1 https://github.com/sbwml/luci-app-xunlei packageluci-app-xunlei
git clone -b v5 --depth 1 https://github.com/sbwml/luci-app-mosdns package/luci-app-mosdns
git clone https://github.com/sbwml/v2ray-geodata package/v2ray-geodata
git clone --depth 1 https://github.com/fw876/helloworld package/helloworld
git clone --depth 1 https://github.com/kenzok78/luci-app-adguardhome package/luci-app-adguardhome
svn_export "main" "luci-app-passwall2" "package/luci-app-passwall2" "https://github.com/xiaorouji/openwrt-passwall2"
svn_export "dev" "luci-app-openclash" "package/custom/luci-app-openclash" "https://github.com/vernesong/OpenClash"
svn_export "main" "luci-app-amlogic" "package/luci-app-amlogic" "https://github.com/ophub/luci-app-amlogic"

# 调整菜单位置
sed -i "s|services|nas|g" feeds/luci/applications/luci-app-alist/root/usr/share/luci/menu.d/luci-app-alist.json
sed -i "s|services|nas|g" feeds/luci/applications/luci-app-filebrowser/root/usr/share/luci/menu.d/luci-app-filebrowser.json
sed -i "s|services|nas|g" feeds/luci/applications/luci-app-transmission/root/usr/share/luci/menu.d/luci-app-transmission.json
sed -i "s|services|nas|g" feeds/luci/applications/luci-app-qbittorrent/root/usr/share/luci/menu.d/luci-app-qbittorrent.json
sed -i "s|services|network|g" feeds/luci/applications/luci-app-nlbwmon/root/usr/share/luci/menu.d/luci-app-nlbwmon.json
# 微信推送&全能推送
sed -i "s|qidian|bilibili|g" package/luci-app-pushbot/root/usr/bin/pushbot/pushbot
sed -i "s|qidian|bilibili|g" feeds/luci/applications/luci-app-wechatpush/root/usr/share/wechatpush/wechatpush
# 依赖和冲突
#rm -rf ./feeds/packages/lang/golang
#git clone https://github.com/sbwml/packages_lang_golang -b 21.x feeds/packages/lang/golang
rm -rf ./feeds/luci/applications/luci-app-openclash
cd package
# 个性化设置
sed -i "s|amlogic_firmware_repo.*|amlogic_firmware_repo 'https://github.com/OldCoding/openwrt_packit_arm'|g" luci-app-amlogic/root/etc/config/amlogic
sed -i "s|ARMv8|ARMv8-im|g" luci-app-amlogic/root/etc/config/amlogic
# 汉化
cd custom
curl -sfL -o ./convert_translation.sh https://github.com/immortalwrt/build-scripts/raw/master/convert_translation.sh 
chmod +x ./convert_translation.sh && sh ./convert_translation.sh && cd ..
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
