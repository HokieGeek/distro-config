here=$(cd `dirname $0`; pwd)

. ${here}/config.prop

# echo "=====> Startup options"

echo "======> Kernel modules"
echo "loop" >> /etc/modules-load.d/modules.conf
echo "vboxdrv" >> /etc/modules-load.d/virtualbox.conf