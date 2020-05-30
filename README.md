# Convolución de imágenes en x86

El presente repositorio contiene los archivos necesarios para realizar _sharpening_ y _oversharpening_ a una imagen utilizando GNU Octave. **De momento este proyecto funciona solamente en Windows** y se recomienda que sea Windows 10 ya que ha sido el sistema operativo utilizado para las pruebas.

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
