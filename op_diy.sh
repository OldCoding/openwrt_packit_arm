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

# 下载插件
git clone --depth 1 https://github.com/zzsj0928/luci-app-pushbot package/luci-app-pushbot
git clone --depth 1 https://github.com/sbwml/luci-app-alist package/luci-app-alist
git clone --depth 1 https://github.com/sirpdboy/netspeedtest package/netspeedtest
git clone --depth 1 https://github.com/jerrykuku/luci-theme-argon package/luci-theme-argon
git clone --depth 1 -b 18.06 https://github.com/jerrykuku/luci-app-argon-config package/luci-app-argon-config
git clone --depth 1 https://github.com/xiaorouji/openwrt-passwall-packages package/openwrt-passwall-packages
git clone -b openwrt-18.06 --depth 1 https://github.com/tty228/luci-app-wechatpush package/luci-app-wechatpush
git clone --depth 1 https://github.com/fw876/helloworld package/helloworld
git clone --depth 1 https://github.com/kenzok78/luci-app-adguardhome package/luci-app-adguardhome
git clone --depth 1 -b v5 https://github.com/sbwml/luci-app-mosdns package/mosdns
git clone --depth 1 https://github.com/sbwml/v2ray-geodata package/v2ray-geodata
svn_export "main" "luci-app-passwall" "package/luci-app-passwall" "https://github.com/xiaorouji/openwrt-passwall"
svn_export "main" "luci-app-passwall2" "package/luci-app-passwall2" "https://github.com/xiaorouji/openwrt-passwall2"
svn_export "master" "luci-app-diskman" "package/luci-app-diskman" "https://github.com/kiddin9/openwrt-packages"
svn_export "main" "luci-app-amlogic" "package/luci-app-amlogic" "https://github.com/ophub/luci-app-amlogic"
svn_export "main" "openwrt/luci-app-thunder" "package/luci-app-thunder" "https://github.com/gngpp/nas-xunlei"
svn_export "main" "openwrt/thunder" "package/thunder" "https://github.com/gngpp/nas-xunlei"
svn_export "dev" "luci-app-openclash" "package/luci-app-openclash" "https://github.com/vernesong/OpenClash"
svn_export "master" "package/emortal" "package/emortal" "https://github.com/immortalwrt/immortalwrt"
svn_export "master" "applications/luci-app-autoreboot" "package/luci-app-autoreboot" "https://github.com/coolsnowwolf/luci"
svn_export "master" "applications/luci-app-socat" "package/luci-app-socat" "https://github.com/immortalwrt/luci"
svn_export "master" "applications/luci-app-ramfree" "package/luci-app-ramfree" "https://github.com/coolsnowwolf/luci"
svn_export "master" "applications/luci-app-webadmin" "package/luci-app-webadmin" "https://github.com/coolsnowwolf/luci"
svn_export "master" "applications/luci-app-usb-printer" "package/luci-app-usb-printer" "https://github.com/coolsnowwolf/luci"
svn_export "master" "applications/luci-app-vsftpd" "package/luci-app-vsftpd" "https://github.com/coolsnowwolf/luci"
svn_export "master" "applications/luci-app-vlmcsd" "package/luci-app-vlmcsd" "https://github.com/coolsnowwolf/luci"
svn_export "master" "applications/luci-app-zerotier" "package/luci-app-zerotier" "https://github.com/coolsnowwolf/luci"
svn_export "master" "applications/luci-app-kodexplorer" "package/luci-app-kodexplorer" "https://github.com/coolsnowwolf/luci"
svn_export "master" "applications/luci-app-filebrowser" "package/luci-app-filebrowser" "https://github.com/immortalwrt/luci"
svn_export "master" "applications/luci-app-qbittorrent" "package/luci-app-qbittorrent" "https://github.com/immortalwrt/luci"
svn_export "master" "net/qBittorrent-Enhanced-Edition" "package/qBittorrent-Enhanced-Edition" "https://github.com/immortalwrt/packages"

# 编译 po2lmo (如果有po2lmo可跳过)
#pushd package/luci-app-openclash/tools/po2lmo
#make && sudo make install
#popd
# 删除冲突软件和依赖
rm -rf feeds/packages/lang/golang 
rm -rf feeds/luci/applications/luci-app-dockerman
rm -rf feeds/luci/applications/luci-app-dockerman
rm -rf feeds/luci/applications/luci-app-alist
curl -sfL https://github.com/immortalwrt/luci/raw/master/modules/luci-base/root/usr/share/luci/menu.d/luci-base.json > feeds/luci/modules/luci-base/root/usr/share/luci/menu.d/luci-base.json
git clone https://github.com/sbwml/packages_lang_golang -b 21.x feeds/packages/lang/golang
# 调整菜单位置
sed -i "s|services|nas|g" package/luci-app-filebrowser/root/usr/share/luci/menu.d/luci-app-filebrowser.json
sed -i "s|services|nas|g" feeds/luci/applications/luci-app-transmission/root/usr/share/luci/menu.d/luci-app-transmission.json
sed -i "s|services|nas|g" feeds/luci/applications/luci-app-aria2/root/usr/share/luci/menu.d/luci-app-aria2.json
sed -i "s|services|nas|g" feeds/luci/applications/luci-app-hd-idle/root/usr/share/luci/menu.d/luci-app-hd-idle.json
sed -i "s|services|nas|g" package/luci-app-qbittorrent/root/usr/share/luci/menu.d/luci-app-qbittorrent.json
sed -i "s|services|system|g" feeds/luci/applications/luci-app-ttyd/root/usr/share/luci/menu.d/luci-app-ttyd.json
sed -i "s|services|network|g" feeds/luci/applications/luci-app-nlbwmon/root/usr/share/luci/menu.d/luci-app-nlbwmon.json
# 微信推送&全能推送
sed -i "s|qidian|bilibili|g" package/luci-app-pushbot/root/usr/bin/pushbot/pushbot
sed -i "s|qidian|bilibili|g" package/luci-app-wechatpush/root/usr/share/serverchan/serverchan
# 汉化
curl -sfL https://github.com/immortalwrt/build-scripts/raw/master/convert_translation.sh | bash
# 个性化设置
cd package
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
