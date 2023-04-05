# Openwrt For ARMv8

自动编译ARM盒子固件，点击右上角Star开始编译  
使用Lede源码构建  
默认IP：192.168.1.1  
默认密码：password  
默认编译S905X3盒子固件  
如需其他CPU型号请修改`Package Armvirt as OpenWrt`节点中的`PACKAGE_SOC`变量，详细使用说明：[README.ACTION.md](https://github.com/unifreq/openwrt_packit/blob/master/README.ACTION.md)
```    - name: Package Armvirt as OpenWrt
      if: steps.organize.outputs.status == 'success' && !cancelled()
      uses: ophub/flippy-openwrt-actions@main
      env:
        OPENWRT_ARMVIRT: openwrt/bin/targets/armvirt/64/openwrt-armvirt-64-default-rootfs.tar.gz
        PACKAGE_SOC: s905x3
        WHOAMI: Wing
        KERNEL_AUTO_LATEST: true
        OPENWRT_VER: ${{ env.VER }}
        DISTRIB_DESCRIPTION: Wing build $(TZ=UTC-8 date "+%Y.%m.%d")
        DISTRIB_REVISION: \@ OpenWrt ${{ env.VER }}
        GZIP_IMGS: .gz
        GH_TOKEN: ${{ secrets.GITHUB_TOKEN }}```
