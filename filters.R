MessageFilters$getPractice <- BaseFilter(
  function(message) {
    # проверяем, встречается ли в тексте сообщения нужные слова
    grepl(x           = message$text, 
          pattern     = 'Практическая  [0-9]|практика  [0-9]|Работа  [0-9]|дай [0-9]|Practice_work',
          ignore.case = TRUE)
  }
)
