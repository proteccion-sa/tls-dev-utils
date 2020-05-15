#!/bin/sh

rm ./root-ca/ca*
rm ./server/server*

export STORE_PASSWD=secr3t
export KEY_PASSWD=secr3t
export SERVER_NAME=localhost
export ROOT_CN="CN=MY COMPANY ROOT CA,OU=MY DEV TEAM,O=ACME,C=CO"
export CERT_CN="CN=${SERVER_NAME},OU=MY DEV TEAM CERTIFICATE,O=ACME,C=CO"

# crea el root-ca
keytool -genkeypair -keyalg RSA -keysize 3072 -alias root-ca \
  -dname "$ROOT_CN" \
  -ext BC:c=ca:true -ext KU=keyCertSign -validity 825 -keystore ./root-ca/ca.p12 \
  -storepass $STORE_PASSWD -keypass $KEY_PASSWD -deststoretype pkcs12

# exporta el root-ca
keytool -exportcert -keystore ./root-ca/ca.p12 -storepass $STORE_PASSWD -alias root-ca -rfc -file ./root-ca/ca.pem

# genera certificado para servidor 'localhost'
keytool -genkeypair -keyalg RSA -keysize 3072 -alias $SERVER_NAME \
  -dname "$CERT_CN" \
  -ext BC:c=ca:false -ext EKU:c=serverAuth -ext "SAN:c=DNS:${SERVER_NAME},IP:127.0.0.1" \
  -validity 720 -keystore ./server/server.p12 -storepass $STORE_PASSWD -keypass $KEY_PASSWD \
  -deststoretype pkcs12

keytool -certreq -keystore ./server/server.p12 -storepass $STORE_PASSWD -alias $SERVER_NAME \
  -keypass $KEY_PASSWD -file ./server/server.csr

keytool -gencert -keystore ./root-ca/ca.p12 -storepass $STORE_PASSWD -infile ./server/server.csr \
  -alias root-ca -keypass $KEY_PASSWD -ext BC:c=ca:false -ext EKU:c=serverAuth -ext "SAN:c=DNS:${SERVER_NAME},IP:127.0.0.1" \
  -validity 720 -rfc -outfile ./server/server.pem

# mete certificados en un keystore
keytool -importcert -noprompt -keystore ./server/server.p12 -storepass $STORE_PASSWD -alias root-ca \
  -keypass $KEY_PASSWD -file ./root-ca/ca.pem
keytool -importcert -noprompt -keystore ./server/server.p12 -storepass $STORE_PASSWD -alias $SERVER_NAME \
  -keypass $KEY_PASSWD -file ./server/server.pem
