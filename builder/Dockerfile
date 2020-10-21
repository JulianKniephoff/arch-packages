from archlinux:latest

copy pacman.conf /tmp
run \
	useradd -m -G wheel builder && \
	mkdir /etc/sudoers.d && \
	chmod 0750 /etc/sudoers.d && \
	echo '%wheel ALL=(ALL) NOPASSWD: ALL' > /etc/sudoers.d/wheel && \
	echo 'Server = https://mirror.pkgbuild.com/$repo/os/$arch' > /etc/pacman.d/mirrorlist && \
	cat /tmp/pacman.conf >> /etc/pacman.conf && \
	rm /tmp/pacman.conf

run \
	pacman -Syu --noconfirm --needed sudo base-devel devtools && \
	pacman -Scc --noconfirm

user builder
workdir /home/builder
run \
	git clone https://aur.archlinux.org/aurutils.git && \
	pushd aurutils && \
	makepkg -sci --noconfirm --needed && \
	popd && \
	rm -rf aurutils && \
	sudo pacman -Scc --noconfirm

user root
workdir /
