#!/bin/sh

cd $(dirname "$0")
cd ..

# Decrypt the file
[[ -d $HOME/secrets ]] || mkdir $HOME/secrets

gpg --quiet --batch --yes --decrypt --passphrase="$SIGNING_KEY_DECRPTION_PASSPHRASE" \
--output $HOME/secrets/key.jks ../.secrets/key.jks.gpg

cat > android/key.properties <<EOF
storePassword=$KEY_PASSPHRASE
keyPassword=$KEY_PASSPHRASE
keyAlias=key
storeFile=$HOME/secrets/key.jks
EOF

