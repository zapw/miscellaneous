#!/bin/bash

if (( EUID != 0 )); then
	{ echo "Run $0 as root" ; exit 1 ;}
fi

rsnap_package='/net/foobar/data/things/packages/rsnapshot/rsnapshot-1.4.2-3.fc20.noarch.rpm'
blockdev='/dev/sdb1'

uuid=$(blkid "$blockdev" -s UUID -o value)

if ! [[ $uuid ]]; then
	echo "$blockdev not found"
	exit 1
fi

printf -v string "%s\t%s\t%s\t%s\t%s" "UUID=$uuid" "/data" "ext4" "defaults" "0 0"

#Add /data mount point to /etc/fstab, if one already exists, replace it with $string else append to end of file.
sed -ri 's@^\S+\s+/data/?\s+.+$@'"$string"'@;t jump; ${ a'$'\\\n'"$string"$'\n'';q };b; :jump $q; N;b jump' /etc/fstab || exit 1

if [[ ! -e '/data' ]]; then
	mkdir '/data' || exit 1
fi

pushd / >/dev/null
mount |awk -v blockdev="$blockdev" -F" on | type "  '$1 == blockdev {print $2}' | 
	while IFS= read -r mntpoint ; do umount -f "$mntpoint" &>/dev/null; done

umount -f /data &>/dev/null
mount /data || exit 1
popd >/dev/null

if ! rpm -q rsnapshot &>/dev/null; then
	rpm -hUv "$rsnap_package" || exit 1
fi

for i in /etc/rsnapshot.{conf,conf-1}; do 
	if [[ -e $i ]]; then
		mv -f "$i" "${i}.orig" || exit 1
	fi
done

for i in /net/foobar/data/things/packages/rsnapshot/rsnapshot.{conf,conf-1}; do
	cp "$i" /etc/ || exit 1
done

cp /net/foobar/data/things/packages/rsnapshot/rsnapshot.cron /etc/cron.d/rsnapshot || exit 1
chown root.root /etc/cron.d/rsnapshot || exit 1
chmod 0644 /etc/cron.d/rsnapshot || exit 1
