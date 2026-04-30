library(tools)

transform <- function(df_1, ...) {
    args <- list(...)
    
    # Debug: print what we're actually receiving
    print(class(df_1))
    print(dim(df_1))
    print(head(df_1))
    
    df_1$name <- toTitleCase(df_1$name)
    df_1$tier <- ifelse(df_1$revenue > 200, 'premium', 'standard')
    df_1$active <- as.logical(df_1$active)
    df_1
}
