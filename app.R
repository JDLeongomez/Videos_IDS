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
    tags$style(HTML("
  .btn-success {
    background-color: #ff9f1c !important;
    border-color: #ff9f1c !important;
    color: white !important;
    font-size: 18px;
    padding: 12px 24px;
    border-radius: 12px;
    box-shadow: 0 4px 8px rgba(0,0,0,0.2);
  }
  .btn-success:hover {
    background-color: #ff8500 !important;
    border-color: #ff8500 !important;
  }
")),
    tags$script(HTML("
      $(function(){
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
      });
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
      <p>No importa si tus hijos o hijas ya no son bebés. Lo importante es que los videos que subas sean de cuando sí lo eran.</p>
      <div class='row'>
        <div class='col-md-6'>
          <h5>En este formulario podrás:</h5>
          <ul>
            <li>Registrar la fecha de nacimiento de tu(s) hijo(s) o hija(s) de quienes quieras subir videos.</li>
            <li>Subir videos en los que estés hablándoles directamente cuando eran bebés (idealmente entre los 0 y 11 meses de edad).</li>
            <li>Indicar la fecha de grabación de cada video y agregar comentarios opcionales.</li>
          </ul>
          ¡Gracias por ser parte de este proyecto tan especial!
        </div>
        <div class='col-md-6'>
        <div class='alert alert-warning' role='alert'>
        🧡 <strong>Importante:</strong> Puedes subir videos de uno o más de tus hijos o hijas, siempre que los videos sean de cuando tenían entre 0 y 11 meses. Por cada uno/a, puedes subir hasta 10 videos.
        </div>
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
  
  # Nombre de la mamá
  card(
    card_header("Identificación"),
    card_body(
      textOutput("texto_mama"),
      hr(),
      textInput("nombre_mama", "Por favor ingresa tu nombre:", placeholder = "Tu nombre"),
      actionButton("confirmar_mama", "Confirmar nombre", class = "btn-primary")
    )
  ),
  
  # Información de hijos/as
  card(
    card_header("Registra la información de tu(s) hijo(s) o hija(s)"),
    card_body(
      fluidRow(
        column(6, textInput("nombre_hijo", "Nombre del hijo/a:", placeholder = "Nombre (sin apellidos)")),
        column(6, dateInput("fecha_nacimiento", "Fecha de nacimiento:", value = Sys.Date(), max = Sys.Date()))
      ),
      actionButton("agregar_hijo", "Agregar hijo/a", class = "btn-primary")
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
        actionButton("agregar_video", "Agregar video a la lista", class = "btn-primary"),
        hr(),
        textOutput("contador_videos")
      )
    )
  ),
  
  # Recordatorio enviar respuestas
  div(
    class = "alert alert-warning",
    HTML("<strong>⚠️ Recuerda:</strong> No olvides hacer clic en <strong>'Enviar respuestas'</strong> cuando termines de agregar todos los videos que quieras enviar (al final de la página). 
       Solo así se guardarán tus datos y videos.")
  ),
  
  # Tablas
  fluidRow(
    column(6,
           card(
             card_header("Hijos/as Registrados"),
             card_body(
               DTOutput("tabla_hijos")
             ),
             max_height = "200px"
           )
    ),
    column(6,
           card(
             card_header("Videos en Lista"),
             card_body(
               DTOutput("tabla_videos")
             ),
             max_height = "200px"
           )
    )
  ),
  
  # Botón de enviar
  card(
    card_body(
      div(
        class = "text-center",
        tags$h4("🧡 ¡Importante!"),
        tags$p("Cuando hayas terminado de registrar a tus hijos/as y subir los videos, recuerda hacer clic en el botón:"),
        actionButton("enviar_respuestas", "✅ Enviar respuestas", 
                     class = "btn-success btn-lg"),
        tags$p(tags$small("Hasta que no envíes, tus videos y datos no quedarán registrados definitivamente."))
      )
    )
  ),
  
  tags$p(textOutput("texto_envio"), style = "color: green; font-weight: bold;")
)

server <- function(input, output, session) {
  if (!dir.exists("uploaded_videos")) dir.create("uploaded_videos")
  if (!dir.exists("data")) dir.create("data")
  
  archivo_hijos <- "data/hijos.csv"
  archivo_videos <- "data/videos.csv"
  
  # Cargar datos previos
  cargar_hijos <- function() {
    if (file.exists(archivo_hijos)) {
      df <- read.csv(archivo_hijos, stringsAsFactors = FALSE)
      df$fecha_nacimiento <- as.Date(df$fecha_nacimiento)
      df
    } else {
      data.frame(
        nombre_mama = character(),
        nombre_hijo = character(),
        fecha_nacimiento = as.Date(character()),
        stringsAsFactors = FALSE
      )
    }
  }
  
  cargar_videos <- function() {
    if (file.exists(archivo_videos)) {
      df <- read.csv(archivo_videos, stringsAsFactors = FALSE)
      df$fecha_grabacion <- as.Date(df$fecha_grabacion)
      df$fecha_subida <- as.POSIXct(df$fecha_subida, origin = "1970-01-01")
      df
    } else {
      data.frame(
        nombre_mama = character(),
        nombre_hijo = character(),
        nombre_archivo = character(),
        archivo_guardado = character(),
        ruta_archivo = character(),
        fecha_grabacion = as.Date(character()),
        comentarios = character(),
        fecha_subida = as.POSIXct(character()),
        stringsAsFactors = FALSE
      )
    }
  }
  
  # Estados temporales
  nombre_mama_fijo <- reactiveVal(NULL)
  datos_hijos_temp <- reactiveVal(data.frame())
  datos_videos_temp <- reactiveVal(data.frame())
  
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
    req(input$nombre_hijo, input$fecha_nacimiento)
    hijos <- datos_hijos_temp()
    
    nuevo <- data.frame(
      nombre_mama = nombre_mama_fijo(),
      nombre_hijo = input$nombre_hijo,
      fecha_nacimiento = as.character(input$fecha_nacimiento),
      stringsAsFactors = FALSE
    )
    
    hijos <- rbind(hijos, nuevo)
    datos_hijos_temp(hijos)
    
    updateTextInput(session, "nombre_hijo", value = "")
    updateDateInput(session, "fecha_nacimiento", value = Sys.Date())
  })
  
  # Actualizar selectInput hijo
  observe({
    hijos <- datos_hijos_temp()
    choices <- unique(hijos$nombre_hijo)
    updateSelectInput(session, "hijo_seleccionado", choices = choices)
  })
  
  # Mostrar seccion de videos si hay hijos
  output$hay_hijos <- reactive({
    nrow(datos_hijos_temp()) > 0
  })
  outputOptions(output, "hay_hijos", suspendWhenHidden = FALSE)
  
  # Agregar video (temporal)
  observeEvent(input$agregar_video, {
    req(input$video_file, input$hijo_seleccionado, input$fecha_grabacion)
    
    videos <- datos_videos_temp()
    videos_hijo <- videos[videos$nombre_hijo == input$hijo_seleccionado, ]
    
    if (nrow(videos_hijo) >= 10) {
      showNotification("Ya has agregado 10 videos para este hijo/a", type = "warning")
      return()
    }
    
    archivo <- input$video_file
    nuevo <- data.frame(
      nombre_mama = nombre_mama_fijo(),
      nombre_hijo = input$hijo_seleccionado,
      nombre_archivo = archivo$name,
      datapath = archivo$datapath,
      fecha_grabacion = as.character(input$fecha_grabacion),
      comentarios = ifelse(input$comentarios == "", "Sin comentarios", input$comentarios),
      stringsAsFactors = FALSE
    )
    
    videos <- rbind(videos, nuevo)
    datos_videos_temp(videos)
    
    updateTextAreaInput(session, "comentarios", value = "")
    updateDateInput(session, "fecha_grabacion", value = Sys.Date())
  })
  
  # Contador de videos
  output$contador_videos <- renderText({
    n <- sum(datos_videos_temp()$nombre_hijo == input$hijo_seleccionado)
    paste0("Has agregado ", n, " de 10 videos permitidos para ", input$hijo_seleccionado, ".")
  })
  
  # Enviar respuestas
  observeEvent(input$enviar_respuestas, {
    hijos_final <- datos_hijos_temp()
    videos_final <- datos_videos_temp()
    
    if (nrow(hijos_final) == 0) {
      showNotification("Debes registrar al menos un hijo/a antes de enviar.", type = "error")
      return()
    }
    
    # Guardar hijos
    if (file.exists(archivo_hijos)) {
      hijos_existentes <- read.csv(archivo_hijos, stringsAsFactors = FALSE)
      hijos_final <- rbind(hijos_existentes, hijos_final)
    }
    write.csv(
      transform(hijos_final, fecha_nacimiento = as.character(fecha_nacimiento)),
      archivo_hijos,
      row.names = FALSE
    )
    
    # Guardar videos y mover archivos
    if (nrow(videos_final) > 0) {
      if (file.exists(archivo_videos)) {
        videos_existentes <- read.csv(archivo_videos, stringsAsFactors = FALSE)
      } else {
        videos_existentes <- data.frame()
      }
      
      for (i in seq_len(nrow(videos_final))) {
        fila <- videos_final[i, ]
        timestamp <- format(Sys.time(), "%Y%m%d_%H%M%S")
        mama_clean <- gsub("[^A-Za-z0-9]", "_", fila$nombre_mama)
        hijo_clean <- gsub("[^A-Za-z0-9]", "_", fila$nombre_hijo)
        extension <- tolower(file_ext(fila$nombre_archivo))
        nombre_guardado <- paste0(mama_clean, "_", hijo_clean, "_", timestamp, "_", i, ".", extension)
        ruta_destino <- file.path("uploaded_videos", nombre_guardado)
        
        file.copy(fila$datapath, ruta_destino)
        
        fila_final <- data.frame(
          nombre_mama = fila$nombre_mama,
          nombre_hijo = fila$nombre_hijo,
          nombre_archivo = fila$nombre_archivo,
          archivo_guardado = nombre_guardado,
          ruta_archivo = ruta_destino,
          fecha_grabacion = fila$fecha_grabacion,
          comentarios = fila$comentarios,
          fecha_subida = as.character(Sys.time()),
          stringsAsFactors = FALSE
        )
        videos_existentes <- rbind(videos_existentes, fila_final)
      }
      write.csv(
        transform(videos_existentes,
                  fecha_grabacion = as.character(fecha_grabacion),
                  fecha_subida = as.character(fecha_subida)),
        archivo_videos,
        row.names = FALSE
      )
    }
    
    datos_hijos_temp(data.frame())
    datos_videos_temp(data.frame())
    nombre_mama_fijo(NULL)
    enable("nombre_mama")
    enable("confirmar_mama")
    output$texto_envio <- renderText("✔️ Respuestas enviadas correctamente.")
  })
  
  # Tablas
  output$tabla_hijos <- renderDT({
    datatable(datos_hijos_temp(), options = list(dom = 't', paging = FALSE), rownames = FALSE)
  })
  
  output$tabla_videos <- renderDT({
    datos <- datos_videos_temp()
    if (nrow(datos) == 0) {
      datatable(
        data.frame(Mensaje = "Por favor agrega videos."),
        options = list(dom = 't', paging = FALSE),
        rownames = FALSE,
        colnames = ""
      )
    } else {
      datatable(
        datos[, c("nombre_hijo", "nombre_archivo", "fecha_grabacion", "comentarios")],
        options = list(dom = 't', paging = FALSE),
        rownames = FALSE,
        colnames = c("Hijo/a", "Archivo", "Fecha de Grabación", "Comentarios")
      )
    }
  })
}

shinyApp(ui = ui, server = server)
