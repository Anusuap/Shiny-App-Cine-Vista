# Server
server <- function(input, output, session) {
  
  filtered_movies <- reactive({
    req(input$director, input$genre)  
    filtered_df <- df
    
    if (input$director != "All") {
      filtered_df <- filtered_df %>% filter(Director == input$director)
    }
    
    if (input$genre != "All") {
      filtered_df <- filtered_df %>% filter(sapply(str_split(Genre, ", "), function(x) any(x %in% input$genre)))
    }
    
    filtered_df
  })
  
  ratings_comments <- reactiveVal(data.frame(Movie = character(), Rating = numeric(), Comment = character(), stringsAsFactors = FALSE))
  
  observeEvent(input$submit_rating, {
    new_rating <- data.frame(Movie = input$movie_select,
                             Rating = input$movie_rating,
                             Comment = input$movie_comment,
                             stringsAsFactors = FALSE)
    updated_data <- rbind(ratings_comments(), new_rating)
    ratings_comments(updated_data)
  })
  
  output$ratings_comments_table <- renderDT({
    ratings_comments() %>% filter(Movie == input$movie_select)
  })
  
  output$movie_table <- renderDT({
    datatable(filtered_movies(), options = list(pageLength = 5, scrollX = TRUE))
  })
  
  output$ranked_movie_table <- renderDT({
    req(input$ranking_criteria)
    sorted_df <- df %>% arrange(desc(!!sym(input$ranking_criteria)))
    datatable(sorted_df, options = list(pageLength = 5, scrollX = TRUE))
  })
  
  # COMBINED Tomato Score and Popcorn Score Comparison
  output$score_comparison <- renderPlot({
    req(input$compare_movies)
    selected_movies <- df %>% filter(Name %in% input$compare_movies)
    
    long_df <- selected_movies %>%
      select(Name, Tomato.Score, Popcorn.Score) %>%
      pivot_longer(cols = c(Tomato.Score, Popcorn.Score),
                   names_to = "Score.Type",
                   values_to = "Score")
    
    ggplot(long_df, aes(x = Name, y = Score, fill = Score.Type)) +
      geom_bar(stat = "identity", position = "dodge") +
      labs(title = "Tomato vs Popcorn Score Comparison", x = "Movie", y = "Score") +
      theme_minimal() +
      scale_fill_brewer(palette = "Pastel1") +
      theme(axis.text.x = element_text(angle = 45, hjust = 1))
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
  
  output$genre_distribution_bar <- renderPlot({
    req(input$genre_comparison)
    genre_data <- df %>%
      filter(sapply(str_split(Genre, ", "), function(x) any(x %in% input$genre_comparison))) %>%
      mutate(Genres = str_split(Genre, ", ")) %>%
      unnest(Genres) %>%
      filter(Genres %in% input$genre_comparison) %>%
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
