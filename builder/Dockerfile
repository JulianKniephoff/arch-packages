from archlinux

run echo 'Server = https://mirror.pkgbuild.com/$repo/os/$arch' > /etc/pacman.d/mirrorlist

run pacman -Syu --noconfirm --needed sudo base-devel devtools

run useradd -m -G wheel builder
run echo "%wheel ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/wheel

user builder
workdir /home/builder
run \
	git clone https://aur.archlinux.org/aurutils.git && \
	pushd aurutils && \
	makepkg -sci --noconfirm --needed && \
	popd && \
	rm -rf aurutils

user root

run pacman -Scc --noconfirm

workdir /
