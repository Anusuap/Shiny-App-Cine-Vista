# UI
ui <- fluidPage(
  
  tags$head(
    tags$style(HTML("
    /* General Body Styling */
    body {
      background-color: #e3f2fd; /* Light blue background */
      font-family: 'Arial', sans-serif;
    }
    
    /* Landing Page styling */
    .landing-page {
      background: linear-gradient(to right, #90caf9, #bbdefb); /* Gradient light blue */
      color: #ffffff;
      padding: 50px;
      border-radius: 12px;
      text-align: center;
    }
    
    .landing-page h3 {
      font-size: 38px;
      font-weight: bold;
    }
    
    .landing-page p {
      font-size: 18px;
      margin: 12px 0;
    }
    
    /* User Guide Section */
    .user-guide {
      background-color: #ffffff;
      color: #0d47a1; /* Dark blue */
      padding: 30px;
      border-radius: 10px;
      box-shadow: 0 4px 12px rgba(0, 0, 0, 0.2);
      font-size: 16px;
      text-align: left;
    }
    
    .user-guide h4 {
      font-size: 28px;
      color: #0d47a1;
      font-weight: bold;
    }
    
    .user-guide p {
      font-size: 16px;
      line-height: 1.6;
    }

    .thank-you-note {
      background-color: #bbdefb; /* Light blue background */
      color: #0d47a1;
      padding: 30px;
      text-align: center;
      border-radius: 10px;
      font-size: 18px;
      box-shadow: 0 4px 12px rgba(0, 0, 0, 0.2);
    }

    .thank-you-note h4 {
      font-size: 28px;
      font-weight: bold;
    }
    
    .thank-you-note p {
      font-size: 18px;
      margin: 10px 0;
      line-height: 1.5;
    }
    
    /* Sidebar Layout */
    .sidebar-panel {
      background-color: #bbdefb; /* Lighter blue */
      padding: 25px;
      border-radius: 12px;
      box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
    }
    
    /* Main Panel Layout */
    .main-panel {
      background-color: #ffffff;
      padding: 25px;
      border-radius: 12px;
      box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
    }
    
    /* Header styling */
    .card-header {
      background-color: #64b5f6;
      color: white;
      font-size: 22px;
      font-weight: bold;
      padding: 15px;
      border-radius: 6px;
    }
    
    /* Button and input styling */
    .action-button {
      background-color: #42a5f5;
      color: white;
      padding: 12px 28px;
      font-size: 17px;
      border-radius: 8px;
      border: none;
      transition: background-color 0.3s ease;
    }
    .action-button:hover {
      background-color: #2196f3;
    }
    
    /* Dropdown and selectize inputs */
    .selectize-input, .selectize-dropdown {
      background-color: #ffffff !important;  
      border: 1px solid #64b5f6 !important;  
    }

    .selectize-input {
      color: #2196f3;  
    }

    .selectize-dropdown {
      background-color: #ffffff !important; 
      border: 1px solid #64b5f6;  
    }

    .selectize-input input {
      color: #2196f3 !important;  
    }

    .selectize-dropdown-content {
      max-height: 150px;  
      overflow-y: auto;   
    }

    /* Table Styling */
    .dataTables_wrapper {
      font-size: 15px;
    }
    
    .dataTables_wrapper .dataTables_scroll {
      max-height: 450px; 
    }
    
    .dataTables_wrapper .dataTables_scrollBody {
      overflow-x: auto;
      overflow-y: hidden;
      max-height: 320px;
    }
    
    .dataTables_wrapper .dataTables_scrollHead {
      font-size: 15px;
    }

    /* Table header styling */
    .dataTables_wrapper .dataTables_scrollHead th {
      padding: 12px;
      background-color: #64b5f6;
      color: white;
      font-weight: bold;
    }
    
    /* Table body cell styling */
    .dataTables_wrapper .dataTables_scrollBody td {
      padding: 12px;
      text-align: center;
    }
    
    /* Adjust the appearance of pagination buttons */
    .dataTables_wrapper .dataTables_paginate .paginate_button {
      color: #2196f3;
      border-radius: 6px;
      border: none;
      padding: 6px 12px;
    }
    .dataTables_wrapper .dataTables_paginate .paginate_button:hover {
      background-color: #2196f3;
      color: white;
    }
    
    /* Styling for the white box containing tables */
    .white-box {
      background-color: white;
      padding: 15px;
      border-radius: 12px;
      box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
    }

    /* Styling for the horizontal scrolling of tables */
    .scrollable-table {
      overflow-x: auto;
      white-space: nowrap;
    }
  "))
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
               p("1. Explore Movies: You can filter movies based on your favorite director or genre using the sidebar. This allows you to find the perfect movie to watch."),
               p("2. Movie Analysis: You can compare various movie metrics such as Tomato Score, Popcorn Score, Average Rating, and more for selected movies."),
               p("3. Rate & Comment: After watching a movie, feel free to rate it from 1-5 and leave your comments to share your thoughts."),
               p("4. Rank Movies: Movies can be ranked by different criteria like Tomato Score, Popcorn Score, Number of Ratings, or Reviews."),
               p("5. Movie Genre Distribution: You can compare how different movie genres perform across the platform.")
           )
    )
  ),
  
  sidebarLayout(
    
    sidebarPanel(
      class = "sidebar-panel",
      h3("Search Filters"),
      
      conditionalPanel(
        condition = "input.tabs == 'Movie Details'",
        
        selectInput("director", "Choose Director:", 
                    choices = c("All", unique(df$Director)), 
                    selected = "All",
                    selectize = TRUE, 
                    multiple = FALSE),
        
        selectizeInput("genre", "Choose Genre:", 
                       choices = c("All", unique(unlist(str_split(df$Genre, ", ")))),
                       selected = "All",
                       multiple = FALSE)
      ),
      
      conditionalPanel(
        condition = "input.tabs == 'Movie Analysis'",
        selectizeInput("compare_movies", "Select Movies to Compare (Max 5):", 
                       choices = unique(df$Name), 
                       selected = NULL, 
                       multiple = TRUE, 
                       options = list(maxItems = 5))
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
                       selected = NULL, 
                       multiple = TRUE, 
                       options = list(maxItems = 10))
      )
    ),
    
    mainPanel(
      class = "main-panel",
      tabsetPanel(
        id = "tabs",
        
        tabPanel("Movie Details", 
                 div(class = "card",
                     div(class = "card-header", "Movie Details"),
                     div(class = "card-body white-box",
                         div(class = "scrollable-table", DTOutput("movie_table"))
                     )
                 )),
        
        tabPanel("Rank Movies",
                 div(class = "card",
                     div(class = "card-header", "Rank Movies"),
                     div(class = "card-body white-box", 
                         div(class = "scrollable-table", DTOutput("ranked_movie_table"))
                     )
                 )),
        
        tabPanel("Rate & Comment",
                 div(class = "card",
                     div(class = "card-header", "Rate & Comment"),
                     div(class = "card-body", 
                         selectizeInput("movie_select", "Select Movie to Rate:", 
                                        choices = df$Name, 
                                        options = list(placeholder = 'Search for a movie')),
                         
                         numericInput("movie_rating", "Rate Movie (1-5):", value = 1, min = 1, max = 5),
                         
                         textAreaInput("movie_comment", "Leave a Comment:", "", height = "100px"),
                         
                         actionButton("submit_rating", "Submit Rating & Comment"),
                         br(),
                         div(class = "ratings-section",
                             h4("Ratings & Comments for Selected Movie:"),
                             DTOutput("ratings_comments_table")
                         )
                     )
                 )),
        
        tabPanel("Movie Analysis",
                 fluidRow(
                   column(6, plotOutput("tomato_score_comparison")),
                   column(6, plotOutput("popcorn_score_comparison"))
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
               p("We hope you enjoyed exploring CineVista. Stay tuned for more movie recommendations, reviews, and ratings."),
               p("Feel free to visit again for new features and exciting movie details. Have a wonderful day!")
           )
    )
  )
)

