# x86 Assembly Image Convultion Algorithm
This algorithm sharpens and oversharpens an image using x86 MASM Assembly . The user interface is developed in GNU Octave.

## Results
### Original image
![image](https://user-images.githubusercontent.com/31488944/142752860-2b84314c-e7d9-460f-9144-006924cfee7f.png)

### Sharpened
![image](https://user-images.githubusercontent.com/31488944/142752864-51ab8925-d442-4891-a982-646f34da6ce5.png)

### Oversharpened
![image](https://user-images.githubusercontent.com/31488944/142752862-02c6e767-1f97-4af0-8038-f4676ed89d0e.png)

## Run instructions (in Spanish)
El presente repositorio contiene los archivos necesarios para realizar _sharpening_ y _oversharpening_ a una imagen utilizando ensamblador (x86 con MASM) y GNU Octave. **De momento este proyecto funciona solamente en Windows** y se recomienda que sea Windows 10 ya que ha sido el sistema operativo utilizado para las pruebas.

## ¿Cómo ejecutar el programa?

### Si todavía no tiene GNU Octave instalado

1. Descargar GNU Octave el cual se encuentra disponible en su [página oficial](https://www.gnu.org/software/octave/download.html). Luego [verifique si su computador es de 32 o 64 bits](https://support.microsoft.com/en-us/help/13443/windows-which-version-am-i-running) y descargue el instalador correspondiente.
2. Ejecute el instalador de Octave y siga todos los pasos de instalación.
3. Pase al paso 4.

### Si ya tiene GNU Octave instalado

4. Abra GNU Octave.
5. Descargue el presente repositorio en su computadora en formato `.zip` .
6. Descomprima el `.zip` en la carpeta de su preferencia.
7. Note que hay una carpeta llamada `InputImages`. Ahí debe poner todas las imágenes que guste, siempre y cuando estén en blanco y negro y tengan una dimensión menor que 3900x2200.
8. Ejecute el script `imageSharpener.m`.
9. Siga los pasos de la consola de Octave. Si tiene algún software de antivirus, es normal que reaccione ante un ejecutable desconocido. En caso de que se presente este problema, bríndele permisos al archivo desde el antivirus y finalice la ejecución.

## Enlaces de interés

- [Vídeo explicativo de la solución](https://www.youtube.com/watch?v=ST7ne5CjO6Y).
- [Documentación del proyecto](https://www.dropbox.com/sh/qogz2rib8603tdh/AACHI31MQfCQ6p9d55bkkJ1qa?dl=0).
