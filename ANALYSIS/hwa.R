hwa_f <- function(){
  icd_pattern <- "\\b[A-TV-Z][0-9]{2}(?:[0-9A-Z]{1,2})?\\b"
  hwa_raw <- read_xlsx("hwa_codes.xlsx", col_names = F) |>
      rename(comb = 1) |> 
      mutate(
          comb = str_replace_all(comb, "[:punct:]", "  "),
          part1 = map(comb, ~str_extract_all(.x, icd_pattern)),
          n_codes <- map_int(part1, ~length(.x[[1]])),
          first_code = map_chr(part1, ~ .x[[1]][1]),
          last_code = map_chr(part1, ~ {
              codes <- .x[[1]]
              n <- length(codes)
              if (n %in% c(2, 3)) {
                  codes[n]
              } else if (n >= 4) {
                  codes[n - 1]
              } else {
                  NA_character_
              }
          }),
          last_code_loc = map2(comb, last_code, ~ str_locate(.x, str_c("\\b", .y, "\\b"))[,1]),
          before_last_code = map2_chr(comb, last_code_loc, ~ if (!is.na(.y)) str_sub(.x, 1, .y - 1) else NA_character_),
          from_last_code   = map2_chr(comb, last_code_loc, ~ if (!is.na(.y)) str_sub(.x, .y) else NA_character_),
          first_desc = map2_chr(before_last_code, first_code, ~ str_remove(.x, fixed(.y))),
          second_desc = map2_chr(from_last_code, last_code, ~ str_remove(.x, fixed(.y)))
      ) |> 
      select(-last_code_loc) |> 
      drop_na()
  #Need to remove the last row as uneven number of codes
  last_row <-  hwa_raw |> 
      slice_tail(n = 1) |>
      mutate(
          hwa_code = first_code, 
          hwa_desc = str_remove_all(comb, first_code)
      ) |> 
      select(hwa_code, hwa_desc)
  hwa_raw_code<-  hwa_raw |> 
      select(first_code, last_code) |> 
      pivot_longer(cols = c(first_code, last_code), names_to = "names", values_to = "hwa_code") |> 
      select(hwa_code)
  hwa_raw_desc<-  hwa_raw |> 
      select(first_desc, second_desc) |> 
      pivot_longer(cols = c(first_desc, second_desc), names_to = "names", values_to = "hwa_desc") |>
      select(hwa_desc)
  hwa_join <- hwa_raw_code |> 
      bind_cols(hwa_raw_desc) |> 
      bind_rows(last_row) |> 
      drop_na() |> 
      distinct(hwa_code,.keep_all = T) |> 
      mutate(hwa_desc = str_squish(hwa_desc))
  return(hwa_join)
}