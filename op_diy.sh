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

find ./ | grep Makefile | grep v2ray-geodata | xargs rm -f
find ./ | grep Makefile | grep mosdns | xargs rm -f

# Rust编译错误-download-ci-llvm
sed -i 's/download-ci-llvm=true/download-ci-llvm=false/g' feeds/packages/lang/rust/Makefile
# 删除冲突软件和依赖
#rm -rf feeds/packages/lang/golang
rm -rf feeds/luci/applications/luci-app-adguardhome
rm -rf feeds/luci/applications/luci-app-dockerman
rm -rf feeds/luci/applications/luci-app-nlbwmon
rm -rf feeds/packages/utils/docker
rm -rf feeds/packages/utils/dockerd
rm -rf feeds/packages/utils/containerd
rm -rf feeds/packages/utils/runc
rm -rf feeds/packages/libs/libtorrent-rasterbar
rm -rf feeds/luci/themes/luci-theme-design
rm -rf feeds/packages/net/{xray-core,v2ray-core,v2ray-geodata,sing-box}
curl -sfL https://github.com/immortalwrt/luci/raw/master/modules/luci-base/root/usr/share/luci/menu.d/luci-base.json > feeds/luci/modules/luci-base/root/usr/share/luci/menu.d/luci-base.json

# 下载插件
git clone --depth 1 https://github.com/zyqfork/luci-app-pushbot package/luci-app-pushbot
git clone --depth 1 https://github.com/OldCoding/luci-app-kodexplorer package/luci-app-kodexplorer
git clone --depth 1 https://github.com/sbwml/luci-app-openlist2 package/openlist
git clone --depth 1 https://github.com/jerrykuku/luci-theme-argon package/luci-theme-argon
git clone --depth 1 https://github.com/jerrykuku/luci-app-argon-config package/luci-app-argon-config
git clone --depth 1 https://github.com/Openwrt-Passwall/openwrt-passwall-packages package/openwrt-passwall-packages
git clone --depth 1 https://github.com/fw876/helloworld package/helloworld
git clone --depth 1 https://github.com/OldCoding/luci-app-adguardhome package/adguardhome
git clone --depth 1 https://github.com/sbwml/v2ray-geodata package/v2ray-geodata
git clone --depth 1 https://github.com/OldCoding/luci-app-filebrowser package/luci-app-filebrowser
git clone --depth 1 https://github.com/OldCoding/netspeedtest package/netspeedtest
git clone --depth 1 https://github.com/papagaye744/luci-theme-design package/luci-theme-design
git clone --depth 1 https://github.com/OldCoding/luci-theme-glass package/luci-theme-glass
git clone --depth 1 https://github.com/immortalwrt/homeproxy package/luci-app-homeproxy
git clone --depth 1 https://github.com/nikkinikki-org/OpenWrt-nikki package/OpenWrt-nikki
git clone --depth 1 https://github.com/sbwml/luci-app-dockerman feeds/luci/applications/luci-app-dockerman
git clone --depth 1 https://github.com/OldCoding/OpenWrt-qBittorrent-Enhanced-Edition package/openwrt-qbee
git clone --depth 1 https://github.com/sbwml/packages_utils_docker feeds/packages/utils/docker
git clone --depth 1 https://github.com/sbwml/packages_utils_dockerd feeds/packages/utils/dockerd
git clone --depth 1 https://github.com/sbwml/packages_utils_containerd feeds/packages/utils/containerd
git clone --depth 1 https://github.com/sbwml/packages_utils_runc feeds/packages/utils/runc
svn_export "master" "luci-app-tailscale-community" "package/luci-app-tailscale" "https://github.com/Tokisaki-Galaxy/luci-app-tailscale-community"
svn_export "main" "luci-app-passwall" "package/luci-app-passwall" "https://github.com/Openwrt-Passwall/openwrt-passwall"
svn_export "main" "luci-app-passwall2" "package/luci-app-passwall2" "https://github.com/Openwrt-Passwall/openwrt-passwall2"
svn_export "main" "luci-app-amlogic" "package/luci-app-amlogic" "https://github.com/ophub/luci-app-amlogic"
svn_export "dev" "luci-app-openclash" "package/luci-app-openclash" "https://github.com/vernesong/OpenClash"
svn_export "master" "applications/luci-app-wechatpush" "feeds/luci/applications/luci-app-wechatpush" "https://github.com/immortalwrt/luci"
svn_export "master" "applications/luci-app-ramfree" "feeds/luci/applications/luci-app-ramfree" "https://github.com/immortalwrt/luci"
svn_export "master" "applications/luci-app-zerotier" "feeds/luci/applications/luci-app-zerotier" "https://github.com/immortalwrt/luci"
svn_export "master" "applications/luci-app-diskman" "feeds/luci/applications/luci-app-diskman" "https://github.com/immortalwrt/luci"
svn_export "master" "applications/luci-app-autoreboot" "feeds/luci/applications/luci-app-autoreboot" "https://github.com/immortalwrt/luci"
svn_export "main" "luci-app-bandix" "package/luci-app-bandix" "https://github.com/timsaya/luci-app-bandix"
svn_export "main" "openwrt-bandix" "package/openwrt-bandix" "https://github.com/timsaya/openwrt-bandix"
svn_export "master" "libs/qt6base" "feeds/packages/libs/qt6base" "https://github.com/immortalwrt/packages"
svn_export "master" "libs/libtorrent-rasterbar" "feeds/packages/libs/libtorrent-rasterbar" "https://github.com/immortalwrt/packages"
svn_export "master" "libs/libdouble-conversion" "feeds/packages/libs/libdouble-conversion" "https://github.com/immortalwrt/packages"
svn_export "master" "utils/qt6tools" "feeds/packages/utils/qt6tools" "https://github.com/immortalwrt/packages"
svn_export "main" "luci-app-ddns-go" "package/luci-app-ddns-go" "https://github.com/OldCoding/luci-app-ddns-go"
svn_export "main" "ddns-go" "package/ddns-go" "https://github.com/OldCoding/luci-app-ddns-go"



svn_export "v5" "luci-app-mosdns" "package/luci-app-mosdns" "https://github.com/sbwml/luci-app-mosdns"
svn_export "v5" "mosdns" "package/mosdns" "https://github.com/sbwml/luci-app-mosdns"
svn_export "v5" "v2dat" "package/v2dat" "https://github.com/sbwml/luci-app-mosdns"
svn_export "master" "package/emortal" "package/emortal" "https://github.com/immortalwrt/immortalwrt"
svn_export "main" "easytier" "package/easytier" "https://github.com/EasyTier/luci-app-easytier"
svn_export "main" "luci-app-easytier" "package/luci-app-easytier" "https://github.com/EasyTier/luci-app-easytier"

sed -i "/mediaurlbase/d" package/luci-theme-design/root/etc/uci-defaults/30_luci-theme-design
mv ./package/netspeedtest/* ./package/ && rm -rf ./package/netspeedtest
mv ./package/openlist/* ./package/ && rm -rf ./package/openlist
mv ./package/adguardhome/* ./package/ && rm -rf ./package/adguardhome
mv ./package/openwrt-qbee/* ./package/ && rm -rf ./package/openwrt-qbee

# aria2补丁
curl --create-dirs -o feeds/packages/net/aria2/patches/010-increase-max-connections-and-reduce-split-size.patch https://raw.githubusercontent.com/OldCoding/aria2-patch/main/010-increase-max-connections-and-reduce-split-size.patch
curl -o feeds/packages/net/ariang/Makefile https://raw.githubusercontent.com/OldCoding/aria2-patch/main/Makefile

# turboacc 补丁
curl -sSL https://raw.githubusercontent.com/chenmozhijin/turboacc/luci/add_turboacc.sh -o add_turboacc.sh && bash add_turboacc.sh

# 安装插件
./scripts/feeds update -i
./scripts/feeds install -a

# 编译 po2lmo (如果有po2lmo可跳过)
#pushd package/luci-app-openclash/tools/po2lmo
#make && sudo make install
#popd

# adguardhome
#VER=$(grep PKG_VERSION package/luci-app-adguardhome/Makefile | sed 's/-/\./g')
#sed -i "s/PKG_VERSION:=.*/$VER/g" package/luci-app-adguardhome/Makefile

# 调整菜单位置
sed -i "s|services|nas|g" package/luci-app-openlist2/root/usr/share/luci/menu.d/luci-app-openlist2.json
sed -i "s|services|nas|g" feeds/luci/applications/luci-app-aria2/root/usr/share/luci/menu.d/luci-app-aria2.json
sed -i "s|services|nas|g" feeds/luci/applications/luci-app-hd-idle/root/usr/share/luci/menu.d/luci-app-hd-idle.json
sed -i "s|services|nas|g" feeds/luci/applications/luci-app-samba4/root/usr/share/luci/menu.d/luci-app-samba4.json
sed -i "s|services|system|g" feeds/luci/applications/luci-app-ttyd/root/usr/share/luci/menu.d/luci-app-ttyd.json
sed -i "s|services|vpn|g" package/luci-app-tailscale/root/usr/share/luci/menu.d/luci-app-tailscale-community.json
# 微信推送&全能推送
sed -i "s|qidian|bilibili|g" package/luci-app-pushbot/root/usr/bin/pushbot/pushbot
# 个性化设置
sed -i "s/(\(luciversion || ''\))/(\1) + (' \/ Wing build $(TZ=UTC-8 date "+%Y.%m.%d")')/g" $(find ./feeds/luci/modules/luci-mod-status/ -type f -name "10_system.js")
sed -i "s|breakingbadboy|OldCoding|g" package/luci-app-amlogic/root/etc/config/amlogic
sed -i "s|OpenWrt|openwrt_packit_arm|g" package/luci-app-amlogic/root/etc/config/amlogic
sed -i "s|ARMv8|ARMv8-op|g" package/luci-app-amlogic/root/etc/config/amlogic
sed -i "s|breakingbadboy|OldCoding|g" package/luci-app-amlogic/luasrc/model/cbi/amlogic/amlogic_config.lua
sed -i "s|OpenWrt|openwrt_packit_arm|g" package/luci-app-amlogic/luasrc/model/cbi/amlogic/amlogic_config.lua
sed -i "s|ARMv8|ARMv8-op|g" package/luci-app-amlogic/luasrc/model/cbi/amlogic/amlogic_config.lua
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
