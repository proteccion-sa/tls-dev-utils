# Utilidad para Generaci&oacute;n de certificados SSL

En este repo encontrara un script para generar:
 
 - Un certificado raiz 
 - Un certificado para 'localhost'. 

Importante: Estos certificados son autofirmados. Solo son utiles para armar un escenario local con aseguramiento TLS. Como tal no son recomendados para desplegar en ambientes de tipo productivo.


## Generar Root CA y certificado para localhost 

Solo debe ejecutar el script `generate-certs.sh`

### Artefactos generados

El script genera:

- Un certificado raiz en `./root-ca/ca.pem`
- Una clave privada en `./server/private_key.pem`
- Un certificado publico en `./server/server.pem`

Los cuales puede usar en su servidor web para exponer sus servicios en modo HTTPS en ambiente de desarrollo.

Opcional:

- Se genera un almacen de certificados llamado `server/server.p12`, el cual puede utilizar para incluir en sus servicios de backend.

### Personalizacion de los artefactos

El script incluye variables para personalizar los siguientes elementos:

```bash
export STORE_PASSWD=secr3t
export KEY_PASSWD=secr3t
export SERVER_NAME=localhost
export ROOT_CN="CN=MY COMPANY ROOT CA,OU=MY DEV TEAM,O=ACME,C=CO"
export CERT_CN="CN=${SERVER_NAME},OU=MY DEV TEAM CERTIFICATE,O=ACME,C=CO"
```

## Configurar su browser para que acepte los certificados autofirmados

Siga estos pasos para importar el Certificado Raiz, con el que se firma el certificado de `localhost`. De esta manera su navegador no estara alertandolo de un certificado
no confiable.

**Google Chrome**

1. Abrir la `configuracion` > `Avanzado` > `Administrar Certificados`
2. Importar el archivo `<tls-dev-utils>/root-ca/ca.pem`
3. Marcar la casilla `Confiar en certificado para identificar sitios web`. 

**Firefox**

1. Abrir la `Preferencias` > `Privacidad & seguridad` > Seccion Certificados: `Ver Certificados`
2. Ficha `Autoridad` > `Importar`
3. Importar `<tls-dev-utils>/root-ca/ca.pem`
3. Click en OK. 

**Safari (MacOS)**

1. Agregar el `<tls-dev-utils>/root-ca/ca.pem` en el 
`KeyChain Access` de tipo `login` y categoría `certificados`.

2. Abrir el certificado agregado, que tenga el nombre que se haya configurado en `ROOT_CN` del bash script y expanda la lista `trust`

3. En la opcion `Cuando se use este certificado` > seleccionar `Siempre Confiar`

4. Salir y guardar.

## Licencia

Apache License 2.0

---

Protecci&oacute;n S.A. 2020
