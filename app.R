library(shiny)
library(bslib)
library(DT)
library(tools)
library(shinyjs)

Sys.setlocale("LC_TIME", "es_CO.UTF-8")

# Aumentar límite de carga a 200 MB
options(shiny.maxRequestSize = 200*1024^2)

ui <- page_fluid(
  title = "Te Hablo, Me Escuchas",
  
  useShinyjs(),
  
  theme = bs_theme(
    bootswatch = "minty",
    primary = "#78c2ad",
    secondary = "#f8b195",
    success = "#c8d5b9",
    info = "#83c5be",
    warning = "#f6bd60",
    danger = "#f28482",
    base_font = font_google("Nunito")
  ),
  
  tags$head(
    # Calendario en español
    tags$script(HTML(
      "$(function(){
          $.datepicker.regional['es'] = {
              closeText: 'Cerrar',
              prevText: '< Ant',
              nextText: 'Sig >',
              currentText: 'Hoy',
              monthNames: ['Enero','Febrero','Marzo','Abril','Mayo','Junio',
              'Julio','Agosto','Septiembre','Octubre','Noviembre','Diciembre'],
              monthNamesShort: ['Ene','Feb','Mar','Abr','May','Jun',
              'Jul','Ago','Sep','Oct','Nov','Dic'],
              dayNames: ['Domingo','Lunes','Martes','Miércoles','Jueves','Viernes','Sábado'],
              dayNamesShort: ['Dom','Lun','Mar','Mié','Juv','Vie','Sáb'],
              dayNamesMin: ['Do','Lu','Ma','Mi','Ju','Vi','Sá'],
              weekHeader: 'Sm',
              dateFormat: 'yy-mm-dd',
              firstDay: 1,
              isRTL: false,
              showMonthAfterYear: false,
              yearSuffix: ''
          };
          $.datepicker.setDefaults($.datepicker.regional['es']);
      });"
    )),
    
    # Estilo de las cards
    tags$style(HTML("
      .card {
        border-radius: 16px;
        box-shadow: 0 4px 10px rgba(0,0,0,0.05);
        margin-bottom: 20px;
      }
      .card-header {
        background-color: #78c2ad;
        color: white;
        font-weight: bold;
      }
      .btn {
        font-size: 16px;
        padding: 10px 20px;
        border-radius: 12px;
      }
    "))
  ),
  
  ## Header con logo
  card(
    card_body(
      div(
        class = "container mb-3",
        div(
          class = "row align-items-center",
          
          # Columna izquierda: Logo y nombre de la app
          div(
            class = "col-md-8 col-sm-12 text-center text-md-start",
            tags$img(src = "logo.svg", height = "200px", style = "margin-right: 10px;")
          ),
          
          # Columna derecha: Información del investigador
          div(
            class = "col-md-4 col-sm-12 text-center text-md-end",
            p(HTML(
              "<a href='https://jdleongomez.info/es/' target='_blank'>
          <img src='icon.png' height='18' style='vertical-align: middle; margin-right: 5px;'>
        </a>
        <a href='https://jdleongomez.info/es/' target='_blank' 
          style='color: #4fc4b1; text-decoration: none; font-weight: bold;'>
          Juan David Leongómez
        </a>, PhD · 2025<br>
        <a href='https://jdleongomez.info/es/team' target='_blank'>
          <img src='Logo_EvoCo.svg' height='30' style='vertical-align: middle; margin: 3px;'>
        </a>
        <a href='https://investigaciones.unbosque.edu.co/codec' target='_blank'>
          <img src='Logo_CODEC.svg' height='30' style='vertical-align: middle; margin: 3px;'>
        </a><br>
        Facultad de Psicología<br>Universidad El Bosque"
            ),
            style = "font-size: 0.85em; margin: 0;")
          )
        )
      ),
      hr(),
      HTML("
      <p>Estamos creando una colección de videos de mamás hablándole a sus bebés durante sus primeros meses de vida. Nuestro objetivo es entender cómo se comunican las mamás con sus bebés antes de que estos empiecen a hablar.</p>
      <p>Esto servirá como base para la planeación de un proyecto de investigación en sus fases preliminares.</p>
      <div class='row'>
        <div class='col-md-6'>
          <h5>En este formulario podrás:</h5>
          <ul>
            <li>Registrar la fecha de nacimiento de tu bebé.</li>
            <li>Subir hasta 10 videos en los que estés hablándole directamente a tu bebé (idealmente entre los 0 y 11 meses de edad).</li>
            <li>Indicar la fecha de grabación de cada video y agregar comentarios opcionales.</li>
          </ul>
          ¡Gracias por ser parte de este proyecto tan especial!
        </div>
        <div class='col-md-6'>
  <div class='alert alert-info'>
    <strong>Privacidad:</strong> Solo tú podrás acceder y cargar tus archivos. 
    Toda la información y los videos serán completamente confidenciales y 
    se utilizarán exclusivamente con fines de investigación académica.
  </div>
  <p class='small'>
  Si tienes dudas, puedes escribir a Juan David Leongómez: 
  <a href='mailto:jleongomez@unbosque.edu.co'>jleongomez@unbosque.edu.co</a>
</p>
</div>
      ")
    )
  ),
  
  # Registro del nombre de la mamá
  card(
    card_header("Identificación"),
    card_body(
      textInput("nombre_mama", "Por favor ingresa tu nombre:", placeholder = "Tu nombre"),
      actionButton("confirmar_mama", "Confirmar nombre", class = "btn-primary"),
      hr(),
      textOutput("texto_mama")
    )
  ),
  
  # Formulario hijos
  card(
    card_header("Registra la información de tu(s) hijo(s) o hija(s)"),
    card_body(
      textInput("nombre_hijo", "Nombre del hijo/a:", placeholder = "Nombre del bebé"),
      dateInput("fecha_nacimiento", "Fecha de nacimiento:", value = Sys.Date() - 365, max = Sys.Date()),
      actionButton("agregar_hijo", "Agregar hijo/a", class = "btn-success")
    )
  ),
  
  # Subida de videos
  conditionalPanel(
    condition = "output.hay_hijos",
    card(
      card_header("Subir Video"),
      card_body(
        selectInput("hijo_seleccionado", "Seleccionar hijo/a:", choices = NULL),
        fileInput("video_file", "Seleccionar video:",
                  accept = c(".mp4", ".avi", ".mov", ".wmv", ".mkv", ".flv", ".webm", ".m4v")),
        dateInput("fecha_grabacion", "Fecha de grabación:", value = Sys.Date()),
        textAreaInput("comentarios", "Comentarios (opcional):", 
                      placeholder = "Añade comentarios sobre el video...", rows = 3),
        actionButton("subir_video", "Subir Video", class = "btn-primary"),
        hr(),
        textOutput("contador_videos")
      )
    )
  ),
  
  # Tablas
  fluidRow(
    column(6,
           card(
             card_header("Hijos/as Registrados"),
             card_body(DTOutput("tabla_hijos"))
           )
    ),
    column(6,
           card(
             card_header("Videos Subidos"),
             card_body(DTOutput("tabla_videos"))
           )
    )
  )
)

server <- function(input, output, session) {
  # Crear carpetas
  if (!dir.exists("uploaded_videos")) dir.create("uploaded_videos")
  if (!dir.exists("data")) dir.create("data")
  
  archivo_hijos <- "data/hijos.csv"
  archivo_videos <- "data/videos.csv"
  
  cargar_hijos <- function() {
    if (file.exists(archivo_hijos)) {
      df <- read.csv(archivo_hijos, stringsAsFactors = FALSE)
      df$fecha_nacimiento <- as.Date(df$fecha_nacimiento)
      df
    } else {
      data.frame(nombre_mama=character(),
                 nombre_hijo=character(),
                 fecha_nacimiento=as.Date(character()),
                 stringsAsFactors=FALSE)
    }
  }
  
  cargar_videos <- function() {
    if (file.exists(archivo_videos)) {
      df <- read.csv(archivo_videos, stringsAsFactors = FALSE)
      df$fecha_grabacion <- as.Date(df$fecha_grabacion)
      df$fecha_subida <- as.POSIXct(df$fecha_subida)
      df
    } else {
      data.frame(
        nombre_mama=character(),
        nombre_hijo=character(),
        nombre_archivo=character(),
        archivo_guardado=character(),
        ruta_archivo=character(),
        fecha_grabacion=as.Date(character()),
        comentarios=character(),
        fecha_subida=as.POSIXct(character()),
        stringsAsFactors=FALSE)
    }
  }
  
  datos_hijos <- reactiveVal(cargar_hijos())
  datos_videos <- reactiveVal(cargar_videos())
  nombre_mama_fijo <- reactiveVal(NULL)
  
  # Confirmar nombre
  observeEvent(input$confirmar_mama, {
    req(input$nombre_mama)
    nombre_mama_fijo(input$nombre_mama)
    disable("nombre_mama")
    disable("confirmar_mama")
  })
  
  output$texto_mama <- renderText({
    if (is.null(nombre_mama_fijo())) {
      "Por favor ingresa tu nombre para comenzar."
    } else {
      paste("Estás registrando datos para:", nombre_mama_fijo())
    }
  })
  
  # Agregar hijo/a
  observeEvent(input$agregar_hijo, {
    req(nombre_mama_fijo(), input$nombre_hijo, input$fecha_nacimiento)
    
    hijos <- datos_hijos()
    ya_existe <- any(hijos$nombre_mama == nombre_mama_fijo() & 
                       hijos$nombre_hijo == input$nombre_hijo)
    
    if (ya_existe) {
      showNotification("Este hijo/a ya está registrado", type="warning")
    } else {
      nuevo <- data.frame(
        nombre_mama = nombre_mama_fijo(),
        nombre_hijo = input$nombre_hijo,
        fecha_nacimiento = input$fecha_nacimiento,
        stringsAsFactors = FALSE
      )
      hijos <- rbind(hijos, nuevo)
      datos_hijos(hijos)
      write.csv(hijos, archivo_hijos, row.names = FALSE)
      
      updateTextInput(session, "nombre_hijo", value = "")
      updateDateInput(session, "fecha_nacimiento", value = Sys.Date() - 365)
      
      showNotification("Hijo/a agregado exitosamente", type = "message")
    }
  })
  
  # Actualizar hijos
  observe({
    req(nombre_mama_fijo())
    hijos <- datos_hijos()
    hijos_mama <- hijos[hijos$nombre_mama == nombre_mama_fijo(), ]
    
    choices <- setNames(hijos_mama$nombre_hijo, hijos_mama$nombre_hijo)
    updateSelectInput(session, "hijo_seleccionado", choices = choices)
  })
  
  # Mostrar seccion de videos si hay hijos
  output$hay_hijos <- reactive({
    req(nombre_mama_fijo())
    hijos <- datos_hijos()
    sum(hijos$nombre_mama == nombre_mama_fijo()) > 0
  })
  outputOptions(output, "hay_hijos", suspendWhenHidden = FALSE)
  
  # Contador de videos
  output$contador_videos <- renderText({
    req(nombre_mama_fijo(), input$hijo_seleccionado)
    videos <- datos_videos()
    n <- sum(videos$nombre_mama == nombre_mama_fijo() &
               videos$nombre_hijo == input$hijo_seleccionado)
    paste0("Has subido ", n, " de 10 videos permitidos para ", input$hijo_seleccionado, ".")
  })
  
  # Subir video
  observeEvent(input$subir_video, {
    req(input$video_file, input$hijo_seleccionado, input$fecha_grabacion)
    
    archivo <- input$video_file
    extension <- tolower(file_ext(archivo$name))
    extensiones_validas <- c("mp4", "avi", "mov", "wmv", "mkv", "flv", "webm", "m4v")
    
    if (!extension %in% extensiones_validas) {
      showNotification("Por favor selecciona un archivo de video válido.", type="error")
      return()
    }
    
    videos <- datos_videos()
    videos_hijo <- videos[videos$nombre_mama == nombre_mama_fijo() &
                            videos$nombre_hijo == input$hijo_seleccionado, ]
    if (nrow(videos_hijo) >= 10) {
      showNotification("Ya has subido el máximo de 10 videos para este hijo/a", type="warning")
      return()
    }
    
    if (archivo$size > 200*1024^2) {
      showNotification("Archivo demasiado grande (máximo 200MB)", type="error")
      return()
    }
    
    timestamp <- format(Sys.time(), "%Y%m%d_%H%M%S")
    mama_clean <- gsub("[^A-Za-z0-9]", "_", nombre_mama_fijo())
    hijo_clean <- gsub("[^A-Za-z0-9]", "_", input$hijo_seleccionado)
    nombre_guardado <- paste0(mama_clean, "_", hijo_clean, "_", timestamp, ".", extension)
    ruta_destino <- file.path("uploaded_videos", nombre_guardado)
    
    file.copy(archivo$datapath, ruta_destino)
    
    nuevo <- data.frame(
      nombre_mama = nombre_mama_fijo(),
      nombre_hijo = input$hijo_seleccionado,
      nombre_archivo = archivo$name,
      archivo_guardado = nombre_guardado,
      ruta_archivo = ruta_destino,
      fecha_grabacion = input$fecha_grabacion,
      comentarios = ifelse(is.null(input$comentarios) | input$comentarios == "", 
                           "Sin comentarios", input$comentarios),
      fecha_subida = Sys.time(),
      stringsAsFactors = FALSE
    )
    
    videos <- rbind(videos, nuevo)
    datos_videos(videos)
    write.csv(videos, archivo_videos, row.names = FALSE)
    
    updateTextAreaInput(session, "comentarios", value = "")
    updateDateInput(session, "fecha_grabacion", value = Sys.Date())
    
    showNotification("Video subido exitosamente", type = "message")
  })
  
  # Tablas
  output$tabla_hijos <- renderDT({
    hijos <- datos_hijos()
    hijos <- hijos[hijos$nombre_mama == nombre_mama_fijo(), ]
    if (nrow(hijos) > 0) {
      hijos$edad_meses <- round(as.numeric(difftime(Sys.Date(), hijos$fecha_nacimiento, units = "days"))/30.44)
      hijos <- hijos[, c("nombre_hijo", "fecha_nacimiento", "edad_meses")]
      colnames(hijos) <- c("Hijo/a", "Fecha de Nacimiento", "Edad (meses)")
    }
    
    datatable(hijos, options=list(dom='t', paging=FALSE, searching=FALSE), rownames=FALSE)
  })
  
  output$tabla_videos <- renderDT({
    videos <- datos_videos()
    videos <- videos[videos$nombre_mama == nombre_mama_fijo(), ]
    if (nrow(videos) > 0) {
      videos_mostrar <- videos[, c("nombre_hijo", "nombre_archivo", "fecha_grabacion", "comentarios", "fecha_subida")]
      colnames(videos_mostrar) <- c("Hijo/a", "Archivo", "Fecha de Grabación", "Comentarios", "Fecha de Subida")
      videos_mostrar$`Fecha de Subida` <- format(videos_mostrar$`Fecha de Subida`, "%Y-%m-%d %H:%M")
    } else {
      videos_mostrar <- videos
    }
    
    datatable(videos_mostrar, options=list(dom='t', paging=FALSE, searching=FALSE, scrollX=TRUE), rownames=FALSE)
  })
}

shinyApp(ui = ui, server = server)
