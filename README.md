# fnm_cuba

El Formulario Nacional de Medicamentos de Cuba, en Flutter.
Accede a la versión web en: https://plinkr.github.io/fnm

## Descripción

`fnm_cuba` es una interfaz de usuario para el Formulario Nacional de Medicamentos (FNM) de Cuba. Este proyecto tiene como objetivo proporcionar una herramienta accesible y fácil de usar tanto desde la web como como aplicación nativa en Linux.

La aplicación permite a los usuarios consultar información sobre medicamentos de manera eficiente, utilizando la base de datos oficial del FNM en su última versión, tal como se proporciona en la aplicación oficial.

Además, los usuarios de iPhone/iOS que no pueden utilizar la aplicación oficial, que está disponible solo para Android, podrán acceder a esta aplicación a través de la web, brindando así una solución inclusiva para todos los usuarios.

## Características

- **Interfaz Web**: Acceso a la aplicación a través de un navegador, lo que permite su uso en diferentes dispositivos sin necesidad de instalación.
- **Aplicación Nativa para Linux**: Una experiencia de usuario optimizada para usuarios de Linux.
- **Base de Datos Oficial**: Utiliza la base de datos oficial del FNM, asegurando que la información esté actualizada y sea precisa.

## Tecnologías Utilizadas

- **Flutter**: Framework utilizado para desarrollar la interfaz de usuario, permitiendo la creación de aplicaciones multiplataforma.
- **Dart**: Lenguaje de programación utilizado en el desarrollo de la aplicación.
## Clonar el Repositorio

Para obtener el código fuente de la aplicación, siga los siguientes pasos para clonar el repositorio desde GitHub:

1. Abra una terminal en su computadora.
2. Clone el repositorio ejecutando el siguiente comando:

```bash
git clone https://github.com/plinkr/fnm_cuba.git
```

3. Navegue al directorio del proyecto:

```bash
cd fnm_cuba
```

## Generación de archivos necesarios para trabajar con la BD SQLite para la versión Web

Antes de ejecutar la aplicación en la web, es necesario generar los archivos `fnm_cuba/web/sqflite_sw.js` y `fnm_cuba/web/sqlite3.wasm`. Estos archivos son necesarios para el manejo de la base de datos en el entorno web. Para generarlos, ejecute el siguiente comando:

```bash
dart run sqflite_common_ffi_web:setup
```
