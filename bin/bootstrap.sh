#!/bin/bash

echo "creating distribution at $(pwd)"
DIR=saltstack

for d in $DIR $DIR/etc $DIR/pillar $DIR/salt; do
    if [ ! -d $d ] ; then
       mkdir $d
       touch $d/.KEEPME
    fi
done

for p in salt pillar; do
    if [ ! -f $DIR/$p/top.sls ] ; then
       cat <<EOF > $DIR/$p/top.sls
base: 
  '*':   
    - common
EOF
    fi
done

if [ ! -f $DIR/salt/common.sls ] ; then
   cat <<EOF > $DIR/salt/common.sls
salt-minion:
  service.running:
    - enable: true
EOF

fi

if [ ! -f $DIR/pillar/common.sls ] ; then
   cat <<EOF > $DIR/pillar/common.sls
foo: bar
EOF

fi   
   
