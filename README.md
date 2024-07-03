
# Aplicación Móvil en Flutter - Mi Tribu

## Copiar el repositorio de la aplicación móvil en el computador
#### En GitHub
* Entrar a github, al link del repositorio: https://github.com/iic2154-uc-cl/2024-1-S2-Grupo5-Movil/tree/main
* Seleccionar en la parte derecha el botón: <>Code
* Verificar que esté marcada la opción HTTPS.
* Copiar el vínculo que aparece ahí. En este caso: https://github.com/iic2154-uc-cl/2024-1-S2-Grupo5-Movil.git

#### En el computador
* Abrir la carpeta o el lugar donde se quiera clonar el repositorio
* Hacer click derecho -> Mostrar más opciones
* Seleccionar "Open Git Bash Here"
* Una vez abierta la terminal de git, escribir lo siguiente "git clone" + link del repositorio. En este caso, el comando quedaría como: git clone https://github.com/iic2154-uc-cl/2024-1-S2-Grupo5-Movil.git.
* Una vez hecho aquello, se puede abrir la carpeta directamente arrastrándola a Visual Studio Code.

## Descargar e instalar flutter en el computador
Dependiendo del tipo de dispositivo (Windows, iOS, Linux), se tendrán distintas configuraciones y pasos a seguir para utilizar Flutter y Dart. A continuación, se encuentra el vínculo donde se pueden encontrar las instrucciones de instalación para cada tipo de dispositivo: https://docs.flutter.dev/get-started/install

Si se quiere trabajar el código en un dispositivo **iOS**:
* **Instalar Xcode:** emulador de celulares con iOS.
* **Instalar AndroidStudio:** emulador de celulares con Android.

Si se quiere trabajar el código en un dispositivo **Windows**:
* **Xcode:** no disponible.
* **Instalar AndroidStudio:** emulador de celulares con Android.

Si se quiere trabajar el código en un dispositivo **Linux**:
* **Xcode:** no disponible.
* **Instalar AndroidStudio:** emulador de celulares con Android.

Las instrucciones para instalar cada emulador y sus configuraciones correspondientes están en el mismo link que se adjuntó para instalar Flutter. 

## Definición del archivo .env

Se debe crear el archivo de manera local en el computador (.env) y pegar la información que está a continuación para las credenciales:

#### #Ruta del Backend
API_URL= https://two024-1-s2-grupo5-backend.onrender.com

#### #Auth0 Domain
AUTH0_DOMAIN= dev-063pxjuasg8ozybk.us.auth0.com

#### #Client Id de Auth0
AUTH0_CLIENT_ID= Vc6EbiCOnVPRetYK8x1xqodqZxDL4gQW

#### #The custom scheme for the Android callback and logout URLs
AUTH0_CUSTOM_SCHEME=flutterdemo

## Correr la aplicación en Visual Studio Code

Una vez abierta la carpeta y creado el archivo .env, se deben llevar a cabo los siguientes pasos:
* Instalar las extensiones de Flutter y Dart.
* Correr en la terminal: ***flutter pub get***
* Abrir el emulador: abajo a la derecha en VSCode donde sale "No Device" o tal vez "Chrome (web-javascript)", pinchar y seleccionar el emulador que se quiere usar.
* Luego correr:
* * Modo Debug: con el teclado hacer ***Fn + F5***, o entrar en VSCode a "Run and Debug" y ponerle play arriba.
* * Aplicación de forma normal: ***flutter run***

## Hacer un APK para Android

Para crear un nuevo APK, se deben llevar a cabo los siguientes pasos:
* Correr en la terminal: ***flutter build apk***
* Una vez termine aquello, entrar al repositorio público donde se quiere hacer el realese en github y en el menú de la derecha seleccionar *Releases*.
* Dentro de *Releases*, presionar el botón *Draft a new release*. 
* Se deben completar el nombre del release y el tag. 
* Por otro lado, se debe subir el archivo apk que se creó. Se debe navegar hasta la ruta *buil/app/outputs/flutter-apk/app-release.apk*, y seleccionar el archivo *app-release.apk*.
* Finalmente, se debe presionar el botón *Publish release*, y a través del link que se genere del release, se puede descargar el apk en cualquier teléfono Android.

## Información Adicional

### ¿Problemas ingresando con Auth0 en Android Studio?
Si la pantalla se pone negra o aparecen imágenes borrosas de fondo cuando se intenta entrar a la aplicación utilizando Auth0, como un _glitch_, se debe revisar la configuración dentro de Android Studio. Seguir los siguientes pasos:

* Abrir Android Studio
* Ir Device Manager
* Tocar los 3 puntos en el lado derecho del dispositivo que se está utilizando
* Apretar "Edit"
* Bajar hasta encontrar Emulated Performance
* En el campo de Graphics, seleccionar Software

