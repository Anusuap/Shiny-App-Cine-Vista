# UI
ui <- fluidPage(
  tags$head(
    tags$style(HTML("/* ... (Your existing CSS styles remain unchanged) ... */"))
  ),
  
  fluidRow(
    column(12, 
           div(class = "landing-page",
               h3("Welcome to the CineVista"),
               p("Discover a world of movies at your fingertips! Explore films by director, genre, and various ranking criteria."),
               p("Use the sidebar to explore and find your favorite films!")
           )
    )
  ),
  
  fluidRow(
    column(12,
           div(class = "user-guide",
               h4("User Guide:"),
               p("1. Explore Movies: You can filter movies based on your favorite director or genre using the sidebar."),
               p("2. Movie Analysis: Compare Tomato Score & Popcorn Score side-by-side for selected movies."),
               p("3. Rate & Comment: After watching a movie, rate and leave comments."),
               p("4. Rank Movies: Rank by Tomato Score, Popcorn Score, Ratings, or Reviews."),
               p("5. Genre Distribution: Visualize genre frequency.")
           )
    )
  ),
  
  sidebarLayout(
    sidebarPanel(
      class = "sidebar-panel",
      h3("Search Filters"),
      
      conditionalPanel(
        condition = "input.tabs == 'Movie Details'",
        selectInput("director", "Choose Director:", choices = c("All", unique(df$Director)), selected = "All"),
        selectizeInput("genre", "Choose Genre:", choices = c("All", unique(unlist(str_split(df$Genre, ", ")))), selected = "All")
      ),
      
      conditionalPanel(
        condition = "input.tabs == 'Movie Analysis'",
        selectizeInput("compare_movies", "Select Movies to Compare (Max 5):", 
                       choices = unique(df$Name), multiple = TRUE, options = list(maxItems = 5))
      ),
      
      conditionalPanel(
        condition = "input.tabs == 'Rank Movies'",
        selectInput("ranking_criteria", "Select Ranking Criteria:", 
                    choices = c("Tomato.Score", "Popcorn.Score", "No.of.Ratings", "No.of.Reviews"))
      ),
      
      conditionalPanel(
        condition = "input.tabs == 'Movie Genre Distribution'",
        selectizeInput("genre_comparison", "Select Genres to Compare (Max 10):", 
                       choices = unique(unlist(str_split(df$Genre, ", "))),
                       multiple = TRUE, options = list(maxItems = 10))
      )
    ),
    
    mainPanel(
      class = "main-panel",
      tabsetPanel(
        id = "tabs",
        
        tabPanel("Movie Details", 
                 div(class = "card",
                     div(class = "card-header", "Movie Details"),
                     div(class = "card-body white-box", DTOutput("movie_table"))
                 )),
        
        tabPanel("Rank Movies",
                 div(class = "card",
                     div(class = "card-header", "Rank Movies"),
                     div(class = "card-body white-box", DTOutput("ranked_movie_table"))
                 )),
        
        tabPanel("Rate & Comment",
                 div(class = "card",
                     div(class = "card-header", "Rate & Comment"),
                     div(class = "card-body", 
                         selectizeInput("movie_select", "Select Movie to Rate:", 
                                        choices = df$Name),
                         numericInput("movie_rating", "Rate Movie (1-5):", value = 1, min = 1, max = 5),
                         textAreaInput("movie_comment", "Leave a Comment:", "", height = "100px"),
                         actionButton("submit_rating", "Submit Rating & Comment"),
                         br(),
                         h4("Ratings & Comments for Selected Movie:"),
                         DTOutput("ratings_comments_table")
                     )
                 )),
        
        tabPanel("Movie Analysis",
                 div(class = "card",
                     div(class = "card-header", "Score Comparison"),
                     div(class = "card-body",
                         plotOutput("score_comparison")
                     )
                 ),
                 fluidRow(
                   column(6, plotOutput("avg_rating_comparison")),
                   column(6, plotOutput("avg_reviews_comparison"))
                 )
        ),
        
        tabPanel("Movie Genre Distribution",
                 div(class = "card",
                     div(class = "card-header", "Movie Genre Distribution"),
                     div(class = "card-body", 
                         plotOutput("genre_distribution_bar")
                     )
                 ))
      )
    )
  ),
  
  fluidRow(
    column(12,
           div(class = "thank-you-note",
               h4("Thank You for Visiting!"),
               p("We hope you enjoyed exploring CineVista."),
               p("Stay tuned for more movie recommendations.")
           )
    )
  )
)
