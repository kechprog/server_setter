#!/bin/bash

for f in ./*; do
	echo "Uploading $f file..."
	sshpass -p "0" scp $f emperor@$1:/home/emperor/$f
done
