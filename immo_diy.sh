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
cp -f $GITHUB_WORKSPACE/patches/101-fix-mbedtls3.6-build.patch package/libs/mbedtls/patches/101-fix-mbedtls3.6-build.patch

# 依赖和冲突
rm -rf ./feeds/packages/lang/golang
rm -rf ./feeds/luci/applications/luci-app-openclash
#rm -rf ./feeds/luci/applications/luci-app-filebrowser
#rm -rf ./feeds/packages/utils/filebrowser
rm -rf ./feeds/luci/applications/luci-app-passwall
rm -rf ./feeds/luci/applications/luci-app-alist
rm -rf ./feeds/packages/net/alist
rm -rf ./feeds/packages/net/v2ray-geodata
rm -rf ./feeds/packages/net/mosdns
rm -rf ./package/network/utils/fullconenat-nft
git clone https://github.com/sbwml/packages_lang_golang feeds/packages/lang/golang

git clone --depth 1 https://github.com/zzsj0928/luci-app-pushbot package/luci-app-pushbot
git clone --depth 1 https://github.com/jerrykuku/luci-app-argon-config package/luci-app-argon-config
git clone https://github.com/sbwml/v2ray-geodata package/v2ray-geodata
git clone --depth 1 https://github.com/fw876/helloworld package/helloworld
git clone --depth 1 https://github.com/chenmozhijin/luci-app-adguardhome package/luci-app-adguardhome
git clone --depth 1 https://github.com/sbwml/luci-app-alist package/luci-app-alist
git clone --depth 1 https://github.com/xiaorouji/openwrt-passwall-packages package/openwrt-passwall-packages
svn_export "master" "applications/luci-app-wrtbwmon" "package/luci-app-wrtbwmon" "https://github.com/coolsnowwolf/luci"
svn_export "main" "luci-app-passwall2" "package/luci-app-passwall2" "https://github.com/xiaorouji/openwrt-passwall2"
svn_export "main" "luci-app-passwall" "package/luci-app-passwall" "https://github.com/xiaorouji/openwrt-passwall"
svn_export "dev" "luci-app-openclash" "package/luci-app-openclash" "https://github.com/vernesong/OpenClash"
svn_export "main" "luci-app-amlogic" "package/luci-app-amlogic" "https://github.com/ophub/luci-app-amlogic"
svn_export "v5" "luci-app-mosdns" "package/luci-app-mosdns" "https://github.com/sbwml/luci-app-mosdns"
svn_export "v5" "mosdns" "package/mosdns" "https://github.com/sbwml/luci-app-mosdns"
svn_export "v5" "v2dat" "package/v2dat" "https://github.com/sbwml/luci-app-mosdns"
#svn_export "main" "openwrt/luci-app-thunder" "package/luci-app-thunder" "https://github.com/gngpp/nas-xunlei"
#svn_export "main" "openwrt/thunder" "package/thunder" "https://github.com/gngpp/nas-xunlei"
svn_export "master" "luci-app-netspeedtest" "package/luci-app-netspeedtest" "https://github.com/sirpdboy/netspeedtest"
svn_export "master" "homebox" "package/homebox" "https://github.com/sirpdboy/netspeedtest"

#svn_export "master" "package/libs/mbedtls" "package/libs/mbedtls" "https://github.com/coolsnowwolf/lede"
#svn_export "master" "package/libs/ustream-ssl" "package/libs/ustream-ssl" "https://github.com/coolsnowwolf/lede"
#svn_export "master" "package/libs/uclient" "package/libs/uclient" "https://github.com/coolsnowwolf/lede"

# turboacc 补丁
curl -sSL https://raw.githubusercontent.com/chenmozhijin/turboacc/luci/add_turboacc.sh -o add_turboacc.sh && bash -x add_turboacc.sh
#TMPDIR=$(mktemp -d) || exit 1
#git clone --depth=1 --single-branch https://github.com/fullcone-nat-nftables/nft-fullcone "$TMPDIR/turboacc/nft-fullcone" || exit 1
#git clone --depth=1 --single-branch https://github.com/chenmozhijin/turboacc "$TMPDIR/turboacc/turboacc" || exit 1
#git clone --depth=1 --single-branch --branch "package" https://github.com/chenmozhijin/turboacc "$TMPDIR/package" || exit 1
#cp -r "$TMPDIR/turboacc/turboacc/luci-app-turboacc" "$TMPDIR/turboacc/luci-app-turboacc"
#rm -rf "$TMPDIR/turboacc/turboacc"
#cp -r "$TMPDIR/package/shortcut-fe" "$TMPDIR/turboacc/shortcut-fe"
##5.15
#cp -f "$TMPDIR/package/hack-5.15/952-add-net-conntrack-events-support-multiple-registrant.patch" "./target/linux/generic/hack-5.15/952-add-net-conntrack-events-support-multiple-registrant.patch"
#cp -f "$TMPDIR/package/hack-5.15/953-net-patch-linux-kernel-to-support-shortcut-fe.patch" "./target/linux/generic/hack-5.15/953-net-patch-linux-kernel-to-support-shortcut-fe.patch"
#cp -f "$TMPDIR/package/pending-5.15/613-netfilter_optional_tcp_window_check.patch" "./target/linux/generic/pending-5.15/613-netfilter_optional_tcp_window_check.patch"
##6.1
#cp -f "$TMPDIR/package/hack-6.1/952-add-net-conntrack-events-support-multiple-registrant.patch" "./target/linux/generic/hack-6.1/952-add-net-conntrack-events-support-multiple-registrant.patch"
#cp -f "$TMPDIR/package/hack-6.1/953-net-patch-linux-kernel-to-support-shortcut-fe.patch" "./target/linux/generic/hack-6.1/953-net-patch-linux-kernel-to-support-shortcut-fe.patch"
#cp -f "$TMPDIR/package/pending-6.1/613-netfilter_optional_tcp_window_check.patch" "./target/linux/generic/pending-6.1/613-netfilter_optional_tcp_window_check.patch"
##6.6
#cp -f "$TMPDIR/package/hack-6.6/952-add-net-conntrack-events-support-multiple-registrant.patch" "./target/linux/generic/hack-6.6/952-add-net-conntrack-events-support-multiple-registrant.patch"
#cp -f "$TMPDIR/package/hack-6.6/953-net-patch-linux-kernel-to-support-shortcut-fe.patch" "./target/linux/generic/hack-6.6/953-net-patch-linux-kernel-to-support-shortcut-fe.patch"
#cp -f "$TMPDIR/package/pending-6.6/613-netfilter_optional_tcp_window_check.patch" "./target/linux/generic/pending-6.6/613-netfilter_optional_tcp_window_check.patch"
#cp -r "$TMPDIR/turboacc" "./package/turboacc"
#rm -rf ./package/libs/libnftnl ./package/network/config/firewall4 ./package/network/utils/nftables
#FIREWALL4_VERSION=$(grep -o 'FIREWALL4_VERSION=.*' "$TMPDIR/package/version" | cut -d '=' -f 2)
#LIBNFTNL_VERSION=$(grep -o 'LIBNFTNL_VERSION=.*' "$TMPDIR/package/version" | cut -d '=' -f 2)
#NFTABLES_VERSION=$(grep -o 'NFTABLES_VERSION=.*' "$TMPDIR/package/version" | cut -d '=' -f 2)
#cp -RT "$TMPDIR/package/firewall4-$FIREWALL4_VERSION/firewall4" ./package/network/config/firewall4
#cp -RT "$TMPDIR/package/libnftnl-$LIBNFTNL_VERSION/libnftnl" ./package/libs/libnftnl
#cp -RT "$TMPDIR/package/nftables-$NFTABLES_VERSION/nftables" ./package/network/utils/nftables


# 调整菜单位置
sed -i "s|services|nas|g" feeds/luci/applications/luci-app-filebrowser/root/usr/share/luci/menu.d/luci-app-filebrowser.json
sed -i "s|services|nas|g" feeds/luci/applications/luci-app-transmission/root/usr/share/luci/menu.d/luci-app-transmission.json
sed -i "s|services|nas|g" feeds/luci/applications/luci-app-qbittorrent/root/usr/share/luci/menu.d/luci-app-qbittorrent.json
sed -i "s|services|network|g" feeds/luci/applications/luci-app-nlbwmon/root/usr/share/luci/menu.d/luci-app-nlbwmon.json
# 微信推送&全能推送
sed -i "s|qidian|bilibili|g" package/luci-app-pushbot/root/usr/bin/pushbot/pushbot
sed -i "s|qidian|bilibili|g" feeds/luci/applications/luci-app-wechatpush/root/usr/share/wechatpush/wechatpush
# DNS劫持
sed -i '/dns_redirect/d' package/network/services/dnsmasq/files/dhcp.conf
# MosDNS
#sed -i "s|CGO_ENABLED=0|CGO_ENABLED=1|g" feeds/packages/net/mosdns/Makefile
cd package
# 个性化设置
sed -i "s|amlogic_firmware_repo.*|amlogic_firmware_repo 'https://github.com/OldCoding/openwrt_packit_arm'|g" luci-app-amlogic/root/etc/config/amlogic
sed -i "s|ARMv8|ARMv8-im|g" luci-app-amlogic/root/etc/config/amlogic
rm -rf luci-app-netspeedtest/po/zh_Hans
# 汉化
curl -sfL -o ./convert_translation.sh https://github.com/kenzok8/small-package/raw/main/.github/diy/convert_translation.sh
chmod +x ./convert_translation.sh && bash ./convert_translation.sh
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
