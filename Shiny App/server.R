# SERVER
server <- function(input, output, session) {
  
  # Reactive expression for filtered movies based on director and genre
  filtered_movies <- reactive({
    req(input$director, input$genre)  
    filtered_df <- df
    
    if(input$director != "All") {
      filtered_df <- filtered_df %>%
        filter(Director == input$director)
    }
    
    if(input$genre != "All") {
      filtered_df <- filtered_df %>%
        filter(sapply(str_split(Genre, ", "), function(x) any(x %in% input$genre)))
    }
    
    filtered_df
  })
  
  # Reactive value to store ratings and comments
  ratings_comments <- reactiveVal(data.frame(Movie = character(), Rating = numeric(), Comment = character(), stringsAsFactors = FALSE))
  
  # Handle rating and comment submission
  observeEvent(input$submit_rating, {
    new_rating <- data.frame(
      Movie = input$movie_select,
      Rating = input$movie_rating,
      Comment = input$movie_comment,
      stringsAsFactors = FALSE
    )
    
    updated_data <- rbind(ratings_comments(), new_rating)
    ratings_comments(updated_data)
  })
  
  # Display ratings and comments for selected movie
  output$ratings_comments_table <- renderDT({
    ratings_comments_data <- ratings_comments()
    selected_movie <- input$movie_select
    ratings_comments_data %>% filter(Movie == selected_movie)
  })
  
  # Output for the movie table based on filtered movies
  output$movie_table <- renderDT({
    datatable(filtered_movies(), options = list(pageLength = 5, scrollX = TRUE))
  })
  
  # Output for the ranked movie table with the sorting based on ranking criteria
  output$ranked_movie_table <- renderDT({
    req(input$ranking_criteria)  # Ensure ranking criteria is selected
    ranking_column <- input$ranking_criteria
    
    # Sort the dataframe based on the selected ranking criteria
    sorted_df <- df %>%
      arrange(desc(!!sym(ranking_column)))  # Sorting based on selected ranking column
    
    # Create the table with sorted data
    datatable(sorted_df, options = list(pageLength = 5, scrollX = TRUE))
  })
  
  # Plotting functionality for movie analysis
  output$tomato_score_comparison <- renderPlot({
    req(input$compare_movies)
    selected_movies <- df %>% filter(Name %in% input$compare_movies)
    ggplot(selected_movies, aes(x = Name, y = Tomato.Score, fill = Name)) +
      geom_bar(stat = "identity") +
      theme_minimal() +
      labs(title = "Tomato Score Comparison", x = "Movie", y = "Tomato Score") +
      scale_fill_brewer(palette = "Set3")
  })
  
  output$popcorn_score_comparison <- renderPlot({
    req(input$compare_movies)
    selected_movies <- df %>% filter(Name %in% input$compare_movies)
    ggplot(selected_movies, aes(x = Name, y = Popcorn.Score, fill = Name)) +
      geom_bar(stat = "identity") +
      theme_minimal() +
      labs(title = "Popcorn Score Comparison", x = "Movie", y = "Popcorn Score") +
      scale_fill_brewer(palette = "Set3")
  })
  
  output$avg_rating_comparison <- renderPlot({
    req(input$compare_movies)
    selected_movies <- df %>% filter(Name %in% input$compare_movies)
    ggplot(selected_movies, aes(x = Name, y = No.of.Ratings, fill = Name)) +
      geom_bar(stat = "identity") +
      theme_minimal() +
      labs(title = "Average Rating Comparison", x = "Movie", y = "Average Rating") +
      scale_fill_brewer(palette = "Set3")
  })
  
  output$avg_reviews_comparison <- renderPlot({
    req(input$compare_movies)
    selected_movies <- df %>% filter(Name %in% input$compare_movies)
    ggplot(selected_movies, aes(x = Name, y = No.of.Reviews, fill = Name)) +
      geom_bar(stat = "identity") +
      theme_minimal() +
      labs(title = "Reviews Count Comparison", x = "Movie", y = "Number of Reviews") +
      scale_fill_brewer(palette = "Set3")
  })
  
  # Movie genre distribution bar plot
  output$genre_distribution_bar <- renderPlot({
    req(input$genre_comparison)
    selected_genres <- input$genre_comparison
    
    genre_data <- df %>%
      filter(sapply(str_split(Genre, ", "), function(x) any(x %in% selected_genres))) %>%
      mutate(Genres = str_split(Genre, ", ")) %>%
      unnest(Genres) %>%
      filter(Genres %in% selected_genres) %>%
      count(Genres) %>%
      arrange(desc(n))
    
    ggplot(genre_data, aes(x = reorder(Genres, n), y = n, fill = Genres)) +
      geom_bar(stat = "identity", show.legend = FALSE) +
      coord_flip() +
      theme_minimal() +
      labs(title = "Movie Genre Distribution Comparison", x = "Genre", y = "Count") +
      scale_fill_brewer(palette = "Set3")
  })
}
