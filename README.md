<p align="center">
  <img src="https://raw.githubusercontent.com/JDLeongomez/Videos_IDS/refs/heads/master/www/logo_preview.svg" alt="logo" height="200">
</p>

**Una aplicación Shiny para recolectar videos de mamás hablándole a sus bebés durante sus primeros meses de vida.**

## 🎯 Propósito del proyecto

Este proyecto tiene como objetivo crear una colección de videos que documenten cómo las mamás se comunican vocalmente con sus bebés antes de que comiencen a hablar. Esta información servirá como insumo preliminar para el diseño de un estudio académico en ciencias del comportamiento, la comunicación y el desarrollo humano.

## 🔧 Descripción de la aplicación

La aplicación permite a cada mamá:

- Registrar su nombre.
- Registrar la información de uno o varios hijos o hijas (nombre y fecha de nacimiento).
- Subir hasta **10 videos por hijo o hija**, en los que esté hablándole directamente (idealmente cuando tenía entre 0 y 11 meses de edad).
- Añadir la fecha de grabación y comentarios opcionales sobre cada video.

Toda la información es **privada y confidencial**, y será utilizada únicamente con fines de investigación académica.

## 🚀 Tecnologías utilizadas

- [R](https://www.r-project.org/) + [Shiny](https://shiny.rstudio.com/)
- [bslib](https://rstudio.github.io/bslib/) para personalización del tema visual.
- [DT](https://rstudio.github.io/DT/) para visualización de tablas.
- Sistema de almacenamiento local con archivos `.csv` para la información y carpeta estructurada para los videos.

## 💻 Instalación y despliegue

### 🔥 Requisitos

- R (versión 4.0 o superior recomendada)
- Paquetes R:

```r
install.packages(c("shiny", "bslib", "DT", "tools", "shinyjs"))
```
## 🔐 Privacidad y ética

- Los datos y videos son almacenados de manera **local y privada** en el servidor donde se ejecuta la aplicación.
- El acceso a los archivos es restringido al equipo de investigación.
- Toda participación es voluntaria y los datos serán utilizados exclusivamente con fines académicos y científicos.

## 🧠 Créditos y autoría

Desarrollado por **Juan David Leongómez**,  
Líder del Grupo de Investigación en Ciencias Cognitivas y del Comportamiento (CODEC)  
Facultad de Psicología, Universidad El Bosque — Bogotá, Colombia.

📧 Contacto: [jleongomez@unbosque.edu.co](mailto:jleongomez@unbosque.edu.co)

## 📜 Licencia

Este proyecto es de uso académico.  
Los derechos sobre los datos y videos recolectados están protegidos y restringidos a los fines del proyecto.  
El código de la aplicación puede ser adaptado o reutilizado con fines académicos, mencionando la autoría correspondiente.

---
