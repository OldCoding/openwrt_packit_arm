#!/bin/bash

# 定义全局临时缓存根目录
DL_CACHE="/tmp/openwrt_pkg_cache"
[ -d "$DL_CACHE" ] || mkdir -p "$DL_CACHE"

svn_export() {
    # 参数说明: $1=分支, $2=子目录, $3=目标目录, $4=仓库地址
    local BRANCH=$1
    local SUB_DIR=$2
    local TARGET_DIR=$3
    local REPO_URL=$4

    # 提取作者名和仓库名 (例如从 https://github.com/immortalwrt/luci 提取 immortalwrt-luci)
    local REPO_IDENTIFIER=$(echo "$REPO_URL" | sed 's|https://github.com/||' | tr '/' '-')
    # 组合成：作者-仓库-分支
    local CACHE_NAME="${REPO_IDENTIFIER}-${BRANCH}"
    local LOCAL_REPO_DIR="$DL_CACHE/$CACHE_NAME"

    # 检查缓存是否存在，不存在则克隆
    if [ ! -d "$LOCAL_REPO_DIR" ]; then
        echo -e "Initial cloning $REPO_URL ($BRANCH) to cache..."
        git clone --depth 1 -b "$BRANCH" "$REPO_URL" "$LOCAL_REPO_DIR" >/dev/null 2>&1
    else
        echo -e "Using cached repo for $REPO_URL ($BRANCH)"
    fi

    # 确保目标目录存在
    [ -d "$TARGET_DIR" ] || mkdir -p "$TARGET_DIR"
    
    # 执行拷贝：只从缓存中提取需要的子目录
    if [ -d "$LOCAL_REPO_DIR/$SUB_DIR" ]; then
        echo -e "Exporting $SUB_DIR to $TARGET_DIR"
        cp -af "$LOCAL_REPO_DIR/$SUB_DIR/." "$TARGET_DIR/"
        # 清除可能带入的 .git 信息（如果有）
        rm -rf "$TARGET_DIR/.git"
    else
        echo -e "Error: Subdirectory $SUB_DIR not found in $REPO_URL"
        return 1
    fi
}

# 删除冲突软件和依赖
rm -rf tools/libdeflate
#rm -rf feeds/packages/lang/golang
rm -rf feeds/luci/applications/luci-app-aria2
rm -rf feeds/luci/applications/luci-app-cloudflared
rm -rf feeds/luci/applications/luci-app-pushbot 
rm -rf feeds/luci/applications/luci-app-serverchan
rm -rf feeds/luci/applications/luci-app-mosdns
rm -rf feeds/luci/applications/luci-app-ddns-go
rm -rf feeds/luci/applications/luci-app-smartdns
rm -rf feeds/luci/applications/luci-app-diskman
rm -rf feeds/luci/applications/luci-app-kodexplorer
rm -rf feeds/luci/applications/luci-app-qbittorrent
rm -rf feeds/luci/applications/luci-app-nlbwmon
rm -rf feeds/luci/applications/luci-app-passwall
rm -rf feeds/luci/applications/luci-app-passwall2
rm -rf feeds/luci/applications/luci-app-filebrowser
rm -rf feeds/luci/applications/luci-app-openclash
rm -rf feeds/luci/applications/luci-app-adguardhome
rm -rf feeds/luci/applications/luci-app-zerotier
rm -rf feeds/packages/net/smartdns
rm -rf feeds/packages/libs/libtorrent-rasterbar
rm -rf feeds/packages/net/mosdns
rm -rf feeds/packages/utils/btrfs-progs
rm -rf feeds/packages/utils/v2dat
rm -rf feeds/packages/net/v2ray-geodata
rm -rf feeds/packages/net/aria2
rm -rf feeds/packages/net/ddns-go
rm -rf feeds/packages/net/sing-box
rm -rf feeds/packages/net/wget
rm -rf feeds/packages/net/tailscale
rm -rf feeds/packages/net/zerotier
rm -rf feeds/packages/utils/ttyd
rm -rf feeds/packages/utils/coremark
rm -rf feeds/packages/utils/smartmontools
rm -rf feeds/packages/libs/tiff
rm -rf feeds/packages/libs/libdht
rm -rf feeds/packages/libs/libutp
rm -rf feeds/packages/libs/libb64
rm -rf feeds/luci/themes/luci-theme-argon
rm -rf feeds/luci/themes/luci-theme-design
curl -sfL https://github.com/immortalwrt/luci/raw/master/modules/luci-base/root/usr/share/luci/menu.d/luci-base.json > feeds/luci/modules/luci-base/root/usr/share/luci/menu.d/luci-base.json
git clone --depth 1 https://github.com/sbwml/feeds_packages_net_aria2 feeds/packages/net/aria2

# 下载插件
git clone --depth 1 https://github.com/zyqfork/luci-app-pushbot feeds/luci/applications/luci-app-pushbot
git clone --depth 1 https://github.com/OldCoding/luci-app-kodexplorer package/luci-app-kodexplorer
git clone --depth 1 https://github.com/sbwml/luci-app-openlist2 package/openlist
git clone --depth 1 https://github.com/jerrykuku/luci-app-argon-config package/luci-app-argon-config
git clone --depth 1 https://github.com/Openwrt-Passwall/openwrt-passwall-packages package/openwrt-passwall-packages
git clone --depth 1 https://github.com/tty228/luci-app-wechatpush package/luci-app-wechatpush
git clone --depth 1 https://github.com/fw876/helloworld package/helloworld
git clone --depth 1 https://github.com/sirpdboy/luci-app-adguardhome package/adguardhome
git clone --depth 1 https://github.com/sbwml/v2ray-geodata package/v2ray-geodata
git clone --depth 1 https://github.com/jerrykuku/luci-theme-argon.git package/luci-theme-argon
git clone --depth 1 https://github.com/OldCoding/luci-app-filebrowser package/luci-app-filebrowser
git clone --depth 1 https://github.com/OldCoding/netspeedtest package/netspeedtest
git clone --depth 1 https://github.com/papagaye744/luci-theme-design package/luci-theme-design
git clone --depth 1 https://github.com/rchen14b/luci-theme-glass package/luci-theme-glass
svn_export "master" "luci-app-tailscale-community" "package/luci-app-tailscale" "https://github.com/Tokisaki-Galaxy/luci-app-tailscale-community"
svn_export "master" "tools/libdeflate" "tools/libdeflate" "https://github.com/immortalwrt/immortalwrt"
svn_export "master" "libs/libdeflate" "feeds/packages/libs/libdeflate" "https://github.com/immortalwrt/packages"
svn_export "main" "luci-app-passwall" "package/luci-app-passwall" "https://github.com/Openwrt-Passwall/openwrt-passwall"
svn_export "main" "luci-app-passwall2" "package/luci-app-passwall2" "https://github.com/Openwrt-Passwall/openwrt-passwall2"
svn_export "master" "applications/luci-app-diskman" "feeds/luci/applications/luci-app-diskman" "https://github.com/immortalwrt/luci"
svn_export "master" "applications/luci-app-smartdns" "feeds/luci/applications/luci-app-smartdns" "https://github.com/immortalwrt/luci"
svn_export "master" "applications/luci-app-aria2" "feeds/luci/applications/luci-app-aria2" "https://github.com/immortalwrt/luci"
svn_export "master" "applications/luci-app-cloudflared" "feeds/luci/applications/luci-app-cloudflared" "https://github.com/openwrt/luci"
svn_export "master" "applications/luci-app-qbittorrent" "feeds/luci/applications/luci-app-qbittorrent" "https://github.com/immortalwrt/luci"
svn_export "master" "applications/luci-app-zerotier" "feeds/luci/applications/luci-app-zerotier" "https://github.com/immortalwrt/luci"
svn_export "main" "luci-app-bandix" "package/luci-app-bandix" "https://github.com/timsaya/luci-app-bandix"
svn_export "main" "openwrt-bandix" "package/openwrt-bandix" "https://github.com/timsaya/openwrt-bandix"
svn_export "master" "net/qBittorrent-Enhanced-Edition" "feeds/packages/net/qBittorrent-Enhanced-Edition" "https://github.com/immortalwrt/packages"
svn_export "master" "utils/qt6tools" "feeds/packages/utils/qt6tools" "https://github.com/immortalwrt/packages"
svn_export "master" "libs/qt6base" "feeds/packages/libs/qt6base" "https://github.com/immortalwrt/packages"
svn_export "master" "libs/libdouble-conversion" "feeds/packages/libs/libdouble-conversion" "https://github.com/immortalwrt/packages"
svn_export "master" "libs/libtorrent-rasterbar" "feeds/packages/libs/libtorrent-rasterbar" "https://github.com/immortalwrt/packages"
svn_export "master" "net/smartdns" "feeds/packages/net/smartdns" "https://github.com/immortalwrt/packages"
svn_export "master" "libs/tiff" "feeds/packages/libs/tiff" "https://github.com/immortalwrt/packages"
svn_export "master" "libs/libdht" "feeds/packages/libs/libdht" "https://github.com/immortalwrt/packages"
svn_export "master" "libs/libutp" "feeds/packages/libs/libutp" "https://github.com/immortalwrt/packages"
svn_export "master" "libs/libb64" "feeds/packages/libs/libb64" "https://github.com/immortalwrt/packages"
svn_export "master" "net/wget" "feeds/packages/net/wget" "https://github.com/immortalwrt/packages"
svn_export "master" "net/cloudflared" "feeds/packages/net/cloudflared" "https://github.com/openwrt/packages"
svn_export "master" "net/tailscale" "feeds/packages/net/tailscale" "https://github.com/immortalwrt/packages"
svn_export "master" "net/zerotier" "feeds/packages/net/zerotier" "https://github.com/immortalwrt/packages"
svn_export "master" "utils/btrfs-progs" "feeds/packages/utils/btrfs-progs" "https://github.com/immortalwrt/packages"
svn_export "master" "utils/ttyd" "feeds/packages/utils/ttyd" "https://github.com/immortalwrt/packages"
svn_export "master" "utils/smartmontools" "feeds/packages/utils/smartmontools" "https://github.com/immortalwrt/packages"
svn_export "main" "luci-app-amlogic" "package/luci-app-amlogic" "https://github.com/ophub/luci-app-amlogic"
svn_export "v5" "luci-app-mosdns" "package/luci-app-mosdns" "https://github.com/sbwml/luci-app-mosdns"
svn_export "v5" "mosdns" "package/mosdns" "https://github.com/sbwml/luci-app-mosdns"
svn_export "v5" "v2dat" "package/v2dat" "https://github.com/sbwml/luci-app-mosdns"
svn_export "dev" "luci-app-openclash" "package/luci-app-openclash" "https://github.com/vernesong/OpenClash"
svn_export "main" "easytier" "package/easytier" "https://github.com/EasyTier/luci-app-easytier"
svn_export "main" "luci-app-easytier" "package/luci-app-easytier" "https://github.com/EasyTier/luci-app-easytier"
svn_export "main" "luci-app-ddns-go" "package/luci-app-ddns-go" "https://github.com/OldCoding/luci-app-ddns-go"
svn_export "main" "ddns-go" "package/ddns-go" "https://github.com/OldCoding/luci-app-ddns-go"

sed -i "/mediaurlbase/d" package/luci-theme-design/root/etc/uci-defaults/30_luci-theme-design
mv ./package/netspeedtest/* ./package/ && rm -rf ./package/netspeedtest
mv ./package/openlist/* ./package/ && rm -rf ./package/openlist
mv ./package/adguardhome/* ./package/ && rm -rf ./package/adguardhome

# 编译 po2lmo (如果有po2lmo可跳过)
#pushd package/luci-app-openclash/tools/po2lmo
#make && sudo make install
#popd

# 安装插件
#./scripts/feeds update -i
#./scripts/feeds install -a

# 调整菜单位置
sed -i "s|services|nas|g" package/luci-app-openlist2/root/usr/share/luci/menu.d/luci-app-openlist2.json
sed -i "s|services|nas|g" feeds/luci/applications/luci-app-aria2/root/usr/share/luci/menu.d/luci-app-aria2.json
sed -i "s|services|nas|g" feeds/luci/applications/luci-app-samba4/root/usr/share/luci/menu.d/luci-app-samba4.json
sed -i "s|services|nas|g" feeds/luci/applications/luci-app-hd-idle/root/usr/share/luci/menu.d/luci-app-hd-idle.json
sed -i "s|services|nas|g" feeds/luci/applications/luci-app-minidlna/root/usr/share/luci/menu.d/luci-app-minidlna.json
sed -i "s|services|nas|g" feeds/luci/applications/luci-app-qbittorrent/root/usr/share/luci/menu.d/luci-app-qbittorrent.json
sed -i "s|services|system|g" feeds/luci/applications/luci-app-ttyd/root/usr/share/luci/menu.d/luci-app-ttyd.json
sed -i "s|services|vpn|g" package/luci-app-tailscale/root/usr/share/luci/menu.d/luci-app-tailscale-community.json

# 微信推送&全能推送
sed -i "s|qidian|bilibili|g" feeds/luci/applications/luci-app-pushbot/root/usr/bin/pushbot/pushbot
# 个性化设置
sed -i "s/(\(luciversion || ''\))/(\1) + (' \/ Wing build $(TZ=UTC-8 date "+%Y.%m.%d")')/g" $(find ./feeds/luci/modules/luci-mod-status/ -type f -name "10_system.js")
sed -i "s|\/\/||g" $(find ./feeds/luci/modules/luci-mod-status/ -type f -name "20_memory.js")
sed -i "/firewall\.user/d" package/lean/default-settings/files/zzz-default-settings
sed -i "/ntp/d" package/lean/default-settings/files/zzz-default-settings
sed -i "s|breakingbadboy|OldCoding|g" package/luci-app-amlogic/root/etc/config/amlogic
sed -i "s|OpenWrt|openwrt_packit_arm|g" package/luci-app-amlogic/root/etc/config/amlogic
sed -i "s|ARMv8|ARMv8-le|g" package/luci-app-amlogic/root/etc/config/amlogic
sed -i "s|breakingbadboy|OldCoding|g" package/luci-app-amlogic/luasrc/model/cbi/amlogic/amlogic_config.lua
sed -i "s|OpenWrt|openwrt_packit_arm|g" package/luci-app-amlogic/luasrc/model/cbi/amlogic/amlogic_config.lua
sed -i "s|ARMv8|ARMv8-le|g" package/luci-app-amlogic/luasrc/model/cbi/amlogic/amlogic_config.lua
sed -i "s|openwrt_luci|openwrt_core|g" package/lean/default-settings/files/zzz-default-settings
sed -i "s|snapshots|armvirt\\\/64|g"  package/lean/default-settings/files/zzz-default-settings
sed -i "s|releases\\\/18.06.9|armsr\\\/armv8|g"  package/lean/default-settings/files/zzz-default-settings
sed -i "/openwrt_release/d" package/lean/default-settings/files/zzz-default-settings
sed -i "s|99-default-settings|99-default-settings-chinese|g" package/lean/default-settings/Makefile
cd package
# 汉化
curl -sfL -o ./convert_translation.sh https://github.com/kenzok8/small-package/raw/main/.github/diy/convert_translation.sh
chmod +x ./convert_translation.sh && bash ./convert_translation.sh
# 更新passwall规则
curl -sfL -o ./luci-app-passwall/root/usr/share/passwall/rules/gfwlist https://raw.githubusercontent.com/Loyalsoldier/v2ray-rules-dat/release/gfw.txt
# OpenClash
cd ./luci-app-openclash/root/etc/openclash
CORE_MATE=https://github.com/vernesong/OpenClash/raw/refs/heads/core/dev/smart/clash-linux-arm64.tar.gz
curl -sfL -o ./Country.mmdb https://github.com/alecthw/mmdb_china_ip_list/raw/release/Country.mmdb
curl -sfL -o ./GeoSite.dat https://github.com/Loyalsoldier/v2ray-rules-dat/raw/release/geosite.dat
curl -sfL -o ./GeoIP.dat https://github.com/Loyalsoldier/v2ray-rules-dat/raw/release/geoip.dat
mkdir ./core && cd ./core
curl -sfL -o ./meta.tar.gz "$CORE_MATE" && tar -zxf ./meta.tar.gz && mv ./clash ./clash_meta
chmod +x ./clash* ; rm -rf ./*.gz