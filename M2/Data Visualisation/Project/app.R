# Chargement des bibliothèques
library(shiny)
library(shinydashboard)
library(leaflet)
library(plotly)
library(dplyr)
library(sf)
library(RColorBrewer)
library(DT)
library(rnaturalearth)
library(rnaturalearthdata)

# Chargement des données
load("data/TB_analysis_ready.RData")

# Définition des labels pour les clusters
labels <- c("1. Faible Impact", "2. Impact Modéré", "3. Impact Critique")

# Application des labels aux données
tb_clustered$label <- factor(tb_clustered$label)
levels(tb_clustered$label) <- labels

# Création de la carte du monde
world_map <- ne_countries(scale = "medium", returnclass = "sf")

# Définition des couleurs pour les clusters
green <- "#66bd63"
orange <- "#f48a43"
red <- "#d73027"

# Interface utilisateur
ui <- shinydashboard::dashboardPage(
  skin = "black",

  # Header
  dashboardHeader(title = "Tuberculose"),

  # Sidebar
  dashboardSidebar(
    sidebarMenu(
      menuItem(
        "Méthodologie & Définitions",
        tabName = "methodo",
        icon = icon("info-circle")
      ),

      menuItem(
        "Vue d'Ensemble",
        tabName = "dashboard",
        icon = icon("dashboard")
      ),

      menuItem("Données Brutes", tabName = "data", icon = icon("table")),

      # Footer - Informations et crédits
      div(
        style = "position: absolute; bottom: 10px; width: 100%; text-align: center; font-size: 12px; color: #b8c7ce;",
        p("© 2026 Arthur Danjou"),
        p("M2 ISF - Dauphine PSL"),
        p(
          a(
            "Code Source",
            href = "https://go.arthurdanjou.fr/datavis",
            target = "_blank",
            style = "color: #3c8dbc;"
          )
        )
      ),

      hr(),

      # Filtre par Région
      selectInput(
        "region_select",
        "Filtrer par Région :",
        choices = c("Toutes", unique(tb_clustered$g_whoregion)),
        selected = "Toutes"
      ),

      # Sélecteur d'année
      sliderInput(
        "year_select",
        "Année :",
        min = min(tb_clustered$year),
        max = max(tb_clustered$year),
        value = max(tb_clustered$year),
        step = 1,
        sep = "",
        animate = animationOptions(interval = 3000, loop = FALSE)
      )
    )
  ),

  # Body
  dashboardBody(
    tabItems(
      # Page 1 - Vue d'Ensemble
      tabItem(
        tabName = "dashboard",

        # KPI - Total des cas
        fluidRow(
          valueBoxOutput("kpi_total_cases", width = 4),
          valueBoxOutput("kpi_worst_country", width = 4),
          valueBoxOutput("kpi_critical_count", width = 4)
        ),

        # Carte Épidémiologique
        fluidRow(
          box(
            width = 7,
            title = "Carte Épidémiologique",
            status = "primary",
            solidHeader = TRUE,
            radioButtons(
              "metric_select",
              "Indicateur :",
              choices = c(
                "Incidence" = "e_inc_100k",
                "Mortalité" = "e_mort_exc_tbhiv_100k",
                "Clusters K-Means" = "label"
              ),
              inline = TRUE
            ),
            p(
              class = "text-muted",
              "Cliquer sur un point pour filtrer par pays."
            ),
            leafletOutput("map_plot", height = "500px")
          ),

          # Scatter Plot des Clusters
          box(
            width = 5,
            title = "Analyse des Clusters (Incidence vs Mortalité)",
            status = "success",
            solidHeader = TRUE,
            p(
              class = "text-muted",
              style = "font-size:0.9em",
              "Chaque point est un pays. Les couleurs correspondent aux groupes de risque identifiés par l'algorithme K-Means."
            ),
            p(
              class = "text-muted",
              "Cliquer sur un point pour filtrer par pays."
            ),
            plotlyOutput("cluster_scatter", height = "530px")
          )
        ),

        fluidRow(
          # Plot des tendances
          box(
            width = 7,
            title = "Comparaison : Pays vs Moyenne Régionale vs Moyenne Mondiale",
            status = "warning",
            solidHeader = TRUE,
            plotlyOutput("trend_plot", height = "400px")
          ),

          # Distribution des Clusters
          box(
            width = 5,
            title = "Distribution des Clusters",
            status = "info",
            solidHeader = TRUE,
            p(
              class = "text-muted",
              "Cliquer sur un point du rug pour filtrer par pays."
            ),
            plotlyOutput("density_plot", height = "400px")
          )
        )
      ),

      # Page 2 - Données Brutes
      tabItem(
        tabName = "data",
        fluidRow(
          box(
            width = 12,
            title = "Explorateur de Données",
            status = "primary",
            p("Tableau filtrable et exportable des données utilisées."),
            DTOutput("raw_table")
          )
        )
      ),

      # Page 3 - Méthodologie
      tabItem(
        tabName = "methodo",

        fluidRow(
          # Indicateurs OMS
          box(
            width = 12,
            title = "Définitions des Indicateurs OMS",
            status = "info",
            solidHeader = TRUE,
            column(
              width = 6,
              h4(icon("lungs"), "Incidence de la Tuberculose"),
              p(
                "Correspond à la variable ",
                code("e_inc_100k"),
                " dans le jeu de données de l'OMS."
              ),
              p(
                "Il s'agit du nombre estimé de ",
                strong("nouveaux cas"),
                " de tuberculose (toutes formes confondues) survenus au cours d'une année donnée, rapporté pour 100 000 habitants."
              ),
              p(
                "Cet indicateur mesure la ",
                em("propagation"),
                " de la maladie dans la population."
              ),
            ),
            column(
              width = 6,
              h4(icon("skull"), "Mortalité (hors VIH)"),
              p(
                "Correspond à la variable ",
                code("e_mort_exc_tbhiv_100k"),
                "."
              ),
              p(
                "Il s'agit du nombre estimé de décès dus à la tuberculose chez les personnes non infectées par le VIH, rapporté pour 100 000 habitants."
              ),
              p(
                "Cet indicateur mesure la ",
                em("sévérité"),
                " et l'efficacité de l'accès aux soins (un taux élevé signale souvent un système de santé défaillant)."
              )
            ),
          ),
        ),

        # Choix des Variables
        fluidRow(
          column(
            width = 6,
            box(
              width = 12,
              title = "Pourquoi seulement 2 variables actives ?",
              status = "warning",
              solidHeader = TRUE,
              p(
                "Le modèle de clustering repose uniquement sur l'Incidence et la Mortalité. Ce choix de parcimonie est justifié par 4 contraintes techniques :"
              ),
              br(),
              column(
                width = 6,
                h4(
                  icon("ruler-combined"),
                  "1. Robustesse Mathématique",
                  class = "text-warning"
                ),
                p(
                  "Évite le 'fléau de la dimension'. Avec trop de variables, les distances euclidiennes perdent leur sens et les groupes deviennent flous."
                ),
                br(),
                h4(
                  icon("project-diagram"),
                  "2. Non-Colinéarité",
                  class = "text-warning"
                ),
                p(
                  "Évite de compter deux fois la même information (ex: Incidence vs Nombre de cas) qui fausserait le poids des indicateurs."
                ),
              ),
              column(
                width = 6,
                h4(
                  icon("filter"),
                  "3. Qualité des Données",
                  class = "text-warning"
                ),
                p(
                  "Le K-Means ne tolère pas les données manquantes. Ajouter des variables socio-économiques aurait réduit la taille de l'échantillon de 30% à 50%."
                ),
                br(),
                h4(icon("eye"), "4. Lisibilité", class = "text-warning"),
                p(
                  "Permet une visualisation directe en 2D (Scatterplot) sans déformation, rendant l'outil accessible aux non-statisticiens."
                )
              )
            ),

            # Source des Données
            box(
              width = 12,
              title = "Source des Données",
              status = "danger",
              solidHeader = TRUE,
              p(
                icon("database"),
                "Les données sont issues du ",
                a(
                  "Global Tuberculosis Report",
                  href = "https://www.who.int/teams/global-programme-on-tuberculosis-and-lung-health/data",
                  target = "_blank"
                ),
                " de l'Organisation Mondiale de la Santé (OMS)."
              ),
              p("Dernière mise à jour du dataset : Octobre 2024.")
            ),
          ),

          column(
            width = 6,
            box(
              width = 12,
              title = "Algorithme de Classification (Clustering)",
              status = "success",
              solidHeader = TRUE,
              h4("Pourquoi un Clustering K-Means ?"),
              p(
                "Afin de synthétiser l'information et de faciliter la prise de décision, j'ai appliqué un algorithme d'apprentissage non supervisé (K-Means) pour regrouper les pays ayant des profils épidémiques similaires sous 4 clusters."
              ),

              h4("Méthodologie"),
              tags$ul(
                tags$li(
                  strong("Variables :"),
                  " Incidence et Mortalité (centrées et réduites pour assurer un poids équivalent)."
                ),
                tags$li(
                  strong("Nombre de Clusters (k) :"),
                  " Fixé à 3 pour obtenir une segmentation tricolore lisible (Faible, Modéré, Critique)."
                ),
                tags$li(
                  strong("Stabilité :"),
                  "Utilisation de `set.seed(123)` pour garantir la reproductibilité des résultats."
                )
              ),

              h4("Interprétation des 3 Groupes"),

              # Tableau des Groupes
              tags$table(
                class = "table table-striped",
                tags$thead(
                  tags$tr(
                    tags$th("Cluster"),
                    tags$th("Description"),
                    tags$th("Profil Type")
                  )
                ),
                tags$tbody(
                  tags$tr(
                    tags$td(span(
                      style = paste0(
                        "background-color:",
                        green,
                        "; color: black; font-weight: bold; padding: 5px; border-radius: 5px;"
                      ),
                      labels[1]
                    )),
                    tags$td("Incidence et mortalité très basses."),
                    tags$td("Europe de l'Ouest, Amérique du Nord")
                  ),
                  tags$tr(
                    tags$td(span(
                      style = paste0(
                        "background-color:",
                        orange,
                        "; color: black; font-weight: bold; padding: 5px; border-radius: 5px;"
                      ),
                      labels[2]
                    )),
                    tags$td("Incidence significative mais mortalité contenue."),
                    tags$td("Amérique Latine, Maghreb, Europe de l'Est")
                  ),
                  tags$tr(
                    tags$td(span(
                      style = paste0(
                        "background-color:",
                        red,
                        "; color: black; font-weight: bold; padding: 5px; border-radius: 5px;"
                      ),
                      labels[3]
                    )),
                    tags$td("Incidence massive et forte létalité."),
                    tags$td("Afrique Subsaharienne, Zones de conflit")
                  )
                )
              )
            ),

            # Code & Documentation
            box(
              title = "Code & Documentation",
              status = "primary",
              solidHeader = TRUE,
              width = 12,

              tags$p(
                "Ce projet suit une approche Open Science.",
                style = "font-style: italic;"
              ),
              tags$p(
                "L'intégralité du code source (Rmd, App) ainsi que la notice technique (PDF) sont disponibles en libre accès sur le dépôt GitHub."
              ),

              tags$a(
                href = "https://go.arthurdanjou.fr/datavis-code",
                target = "_blank",
                class = "btn btn-block btn-social btn-github",
                style = "color: white; background-color: #333; border-color: #333;",
                icon("github"),
                " Accéder au Code"
              )
            )
          ),
        ),
      )
    )
  )
)

# Serveur
server <- function(input, output, session) {
  # Filtrage des données
  filtered_data <- shiny::reactive({
    req(input$year_select)
    data <- tb_clustered |> filter(year == input$year_select)

    if (input$region_select != "Toutes") {
      data <- data |> filter(g_whoregion == input$region_select)
    }
    return(data)
  })

  # Données pour la carte
  map_data_reactive <- shiny::reactive({
    req(filtered_data())
    world_map |> inner_join(filtered_data(), by = c("adm0_a3" = "iso3"))
  })

  # Définition des couleurs pour les clusters
  cluster_colors <- setNames(
    c(green, orange, red),
    labels
  )

  # Fonction pour dessiner les polygones sur la carte
  dessiner_polygones <- function(map_object, data, metric) {
    if (metric == "label") {
      values_vec <- data$label
      pal_fun <- leaflet::colorFactor(
        as.character(cluster_colors),
        domain = names(cluster_colors)
      )
      fill_vals <- pal_fun(values_vec)
      legend_title <- "Cluster"
      label_txt <- paste0(data$name, " - ", data$label)
      legend_vals <- names(cluster_colors)
    } else {
      values_vec <- data[[metric]]
      pal_fun <- leaflet::colorNumeric(
        palette = c(green, orange, red),
        domain = values_vec
      )
      fill_vals <- pal_fun(values_vec)
      legend_title <- "Taux / 100k"
      label_txt <- paste0(data$name, ": ", round(values_vec, 1))
      legend_vals <- values_vec
    }

    map_object |>
      leaflet::addPolygons(
        data = data,
        fillColor = ~fill_vals,
        weight = 1,
        color = ifelse(metric == "label", "gray", "black"),
        fillOpacity = 0.7,
        layerId = ~adm0_a3,
        label = ~label_txt,
        highlightOptions = highlightOptions(
          weight = 3,
          color = "#666",
          bringToFront = TRUE
        )
      ) |>
      leaflet::addLegend(
        pal = pal_fun,
        values = legend_vals,
        title = legend_title,
        position = "bottomright"
      )
  }

  # Carte
  output$map_plot <- leaflet::renderLeaflet({
    isolate({
      data <- map_data_reactive()
      metric <- input$metric_select

      leaflet(options = leafletOptions(minZoom = 2, maxZoom = 6)) |>
        addProviderTiles(
          providers$CartoDB.Positron,
          options = providerTileOptions(noWrap = TRUE)
        ) |>
        setMaxBounds(lng1 = -180, lat1 = -90, lng2 = 180, lat2 = 90) |>
        setView(lat = 20, lng = 0, zoom = 2) |>
        dessiner_polygones(data, metric)
    })
  })

  # KPI - Total des cas
  output$kpi_total_cases <- shinydashboard::renderValueBox({
    data <- filtered_data()
    val <- round(mean(data$e_inc_100k, na.rm = TRUE))
    valueBox(
      val,
      "Incidence Moyenne (cas/100k)",
      icon = icon("chart-area"),
      color = "green"
    )
  })

  # KPI - Pire pays
  output$kpi_worst_country <- shinydashboard::renderValueBox({
    data <- filtered_data()
    worst <- data |> arrange(desc(e_inc_100k)) |> slice(1)

    if (nrow(worst) > 0) {
      valueBox(
        worst$country,
        paste("Max Incidence :", round(worst$e_inc_100k)),
        icon = icon("exclamation-triangle"),
        color = "red"
      )
    } else {
      valueBox("N/A", "Pas de données", icon = icon("ban"), color = "red")
    }
  })

  # KPI - Pays en phase 'Critique'
  output$kpi_critical_count <- shinydashboard::renderValueBox({
    data <- filtered_data()
    count <- sum(data$label == labels[3], na.rm = TRUE)
    valueBox(
      count,
      "Pays en phase 'Critique'",
      icon = icon("hospital"),
      color = "orange"
    )
  })

  # Plot des tendances
  output$trend_plot <- plotly::renderPlotly({
    req(selected_country())
    country_hist <- tb_clustered |> filter(iso3 == selected_country())
    if (nrow(country_hist) == 0) {
      return(NULL)
    }

    nom_pays <- unique(country_hist$country)[1]
    region_du_pays <- unique(country_hist$g_whoregion)[1]

    region_benchmark <- tb_clustered |>
      filter(g_whoregion == region_du_pays) |>
      group_by(year) |>
      summarise(mean_inc = mean(e_inc_100k, na.rm = TRUE))

    global_benchmark <- tb_clustered |>
      group_by(year) |>
      summarise(mean_inc = mean(e_inc_100k, na.rm = TRUE))

    p <- ggplot() +
      geom_area(
        data = country_hist,
        aes(
          x = year,
          y = e_inc_100k,
          group = 1,
          text = paste0("<b>Pays : ", nom_pays, "</b>")
        ),
        fill = red,
        alpha = 0.1
      ) +
      geom_line(
        data = region_benchmark,
        aes(
          x = year,
          y = mean_inc,
          group = 1,
          color = "Moyenne Régionale",
          text = paste0(
            "<b>Moyenne ",
            region_du_pays,
            "</b><br>Année : ",
            year,
            "<br>Incidence : ",
            round(mean_inc, 1)
          )
        ),
        size = 0.5,
        linetype = "dashed"
      ) +
      geom_line(
        data = global_benchmark,
        aes(
          x = year,
          y = mean_inc,
          group = 1,
          color = "Moyenne Mondiale",
          text = paste0(
            "<b>Moyenne Mondiale</b><br>Année : ",
            year,
            "<br>Incidence : ",
            round(mean_inc, 1)
          )
        ),
        size = 0.75,
        linetype = "dashed"
      ) +
      geom_line(
        data = country_hist,
        aes(
          x = year,
          y = e_inc_100k,
          group = 1,
          color = "Pays Sélectionné",
          text = paste0(
            "<b>Pays : ",
            nom_pays,
            "</b><br>Incidence : ",
            round(e_inc_100k, 1),
            "<br>Mortalité : ",
            round(e_mort_exc_tbhiv_100k, 1)
          )
        ),
        size = 1
      ) +
      geom_vline(
        xintercept = as.numeric(input$year_select),
        linetype = "dotted",
        color = "black",
        alpha = 0.6
      ) +
      scale_color_manual(
        name = "",
        values = c(
          "Moyenne Régionale" = "grey30",
          "Pays Sélectionné" = red,
          "Moyenne Mondiale" = "orange"
        )
      ) +
      labs(
        title = paste(
          "Trajectoire :",
          nom_pays,
          "vs",
          region_du_pays,
          "vs Monde"
        ),
        x = "Année",
        y = "Incidence (pour 100k)"
      ) +
      theme_minimal() +
      theme(legend.position = "bottom")

    ggplotly(p, tooltip = "text") |>
      layout(
        legend = list(orientation = "h", x = 0.1, y = -0.2),
        hovermode = "x unified"
      )
  })

  # Densité des cas
  output$density_plot <- plotly::renderPlotly({
    data <- filtered_data()
    sel_iso <- selected_country()
    highlight_data <- data |> filter(iso3 == sel_iso)

    p <- ggplot(data, aes(x = e_inc_100k, fill = label)) +
      geom_density(
        aes(text = paste0("<b>Cluster : </b>", label)),
        alpha = 0.6,
        color = NA
      ) +
      geom_rug(
        aes(
          color = label,
          customdata = iso3,
          text = paste0(
            "<b>Pays : </b>",
            country,
            "<br><b>Incidence : </b>",
            round(e_inc_100k),
            " (cas/100k)<br><b>Cluster : </b>",
            label
          )
        ),
        sides = "b",
        length = unit(0.2, "npc"),
        size = 1.2,
        alpha = 0.9
      ) +
      geom_point(
        data = highlight_data,
        aes(
          x = e_inc_100k,
          y = 0,
          text = paste0(
            "<b>PAYS SÉLECTIONNÉ</b><br><b>",
            country,
            "</b><br>Incidence : ",
            round(e_inc_100k)
          )
        ),
        color = "black",
        fill = "white",
        shape = 21,
        size = 4
      ) +
      scale_fill_manual(values = cluster_colors) +
      scale_color_manual(values = cluster_colors) +
      scale_x_log10() +
      labs(
        title = "Distribution des Risques",
        x = "Incidence (Échelle Log)",
        y = NULL
      ) +
      theme_minimal() +
      theme(
        legend.position = "none",
        axis.text.y = element_blank(),
        axis.ticks.y = element_blank(),
        panel.grid.major.y = element_blank(),
        panel.grid.minor.y = element_blank()
      )

    ggplotly(p, tooltip = "text", source = "density_click") |>
      layout(hovermode = "closest")
  })

  # Nuage de points des clusters
  output$cluster_scatter <- plotly::renderPlotly({
    data <- filtered_data()
    sel_iso <- selected_country()
    highlight_data <- data %>% filter(iso3 == sel_iso)

    p <- ggplot(data, aes(x = e_inc_100k, y = e_mort_exc_tbhiv_100k)) +
      geom_point(
        aes(
          color = label,
          customdata = iso3,
          text = paste(
            "Pays:",
            country,
            "<br>Cluster:",
            label,
            "<br>Pop:",
            round(e_pop_num / 1e6, 1),
            "M",
            "<br>Incidence:",
            round(e_inc_100k),
            "<br>Mortalité:",
            round(e_mort_exc_tbhiv_100k)
          )
        ),
        size = 3,
        alpha = 0.6
      ) +
      geom_point(
        data = highlight_data,
        aes(
          fill = label,
          text = paste(
            "<b>PAYS SÉLECTIONNÉ</b>",
            "<br>Pays:",
            country,
            "<br>Cluster:",
            label,
            "<br>Incidence:",
            round(e_inc_100k),
            "<br>Mortalité:",
            round(e_mort_exc_tbhiv_100k)
          )
        ),
        shape = 21,
        color = "black",
        stroke = 1,
        size = 5,
        alpha = 1,
        show.legend = FALSE
      ) +
      scale_x_log10() +
      scale_y_log10() +
      scale_color_manual(values = cluster_colors) +
      scale_fill_manual(values = cluster_colors) +
      labs(title = "Incidence vs Mortalité", x = "Incidence", y = "Mortalité") +
      theme_minimal() +
      theme(legend.position = "bottom")

    ggplotly(p, tooltip = "text", source = "scatter_click")
  })

  # Tableau des données brutes
  output$raw_table <- DT::renderDT({
    data <- filtered_data() |>
      select(
        country,
        year,
        g_whoregion,
        e_inc_100k,
        e_mort_exc_tbhiv_100k,
        label
      )

    datatable(
      data,
      rownames = FALSE,
      options = list(pageLength = 15, scrollX = TRUE),
      colnames = c(
        "Pays",
        "Année",
        "Région",
        "Incidence",
        "Mortalité",
        "Cluster"
      )
    )
  })

  # Mise à jour de la carte
  shiny::observe({
    data <- map_data_reactive()
    metric <- input$metric_select

    leafletProxy("map_plot", data = data) |>
      clearShapes() |>
      clearControls() |>
      dessiner_polygones(data, metric)
  })

  # Sélection du pays
  selected_country <- shiny::reactiveVal("FRA")

  # Sélection du pays sur la carte
  shiny::observeEvent(input$map_plot_shape_click, {
    click <- input$map_plot_shape_click
    if (!is.null(click$id)) {
      selected_country(click$id)
    }
  })

  # Sélection du pays dans le nuage de points
  shiny::observeEvent(event_data("plotly_click", source = "scatter_click"), {
    click_info <- event_data("plotly_click", source = "scatter_click")
    if (!is.null(click_info$customdata)) {
      selected_country(click_info$customdata)
    }
  })

  # Sélection du pays dans la densité
  shiny::observeEvent(event_data("plotly_click", source = "density_click"), {
    click_info <- event_data("plotly_click", source = "density_click")
    if (!is.null(click_info$customdata)) {
      selected_country(click_info$customdata)
    }
  })
}

# Lancement de l'application Shiny
shiny::shinyApp(ui, server)
