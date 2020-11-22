from archlinux/archlinux:base-devel

copy pacman.conf /tmp
run \
	useradd -m builder && \
	echo 'builder ALL=(ALL) NOPASSWD: ALL' > /etc/sudoers.d/wheel && \
	echo 'Server = https://mirror.pkgbuild.com/$repo/os/$arch' > /etc/pacman.d/mirrorlist && \
	cat /tmp/pacman.conf >> /etc/pacman.conf && \
	rm /tmp/pacman.conf

run \
	pacman -Syu --noconfirm --needed devtools && \
	pacman -Scc --noconfirm

run cp -a /usr/share/devtools/pacman-extra.conf /usr/share/devtools/pacman-aur.conf

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

copy init.sh /
entrypoint ["/init.sh"]
cmd ["/usr/bin/bash"]
