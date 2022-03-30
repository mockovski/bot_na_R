#Подключаем библиотеку для работы с xlsx файлами
library(xlsx)
# метод для отправки InLine клавиатуры
menu<- function(bot, update) {  
  
  # создаём InLine клавиатуру
  IKM <- InlineKeyboardMarkup(
    inline_keyboard = list(
      list(
        InlineKeyboardButton("Практические работы", callback_data = 'PWLIST')),
      list(InlineKeyboardButton("Успеваемость", callback_data = 'studentList')
      )
    )
  )
  
  # Отправляем клавиатуру в чат
  bot$sendMessage(update$message$chat_id, 
                  text = "Что вас интересует?", 
                  reply_markup = IKM)
}

StudentList <- function(bot, update) {  
  
  # Считываем файл
  data<-read.xlsx("students.xlsx", 1)
  # Получаем список имён учеников
  studentNames <- data[,1]
  
  # Создаём кнопки с именами учеников
  buttons<-list()
  
  for(i in 1:length(studentNames))
  {
    buttons[i]<-list(list(InlineKeyboardButton(studentNames[i], callback_data = paste('getSS ',i))))
  }
  
  
  # создаём InLine клавиатуру
  
  IKM <- InlineKeyboardMarkup(
    inline_keyboard = 
      buttons
    
  )
  # Отправляем клавиатуру в чат
  bot$sendMessage(chat_id = update$from_chat_id(),
                  text = "Какой ученик вас интересует?",
                  reply_markup = IKM)
  # сообщаем боту, что запрос с кнопки принят
  bot$answerCallbackQuery(callback_query_id = update$callback_query$id)
}

PracticeWorkList <- function(bot, update) {
  
  path <- "Practice_work/"
  files <- gsub(".pdf","",dir(path))
  # Сортируем полученные имена файлов в правильном порядке
  numbers = as.numeric(regmatches(files, regexpr("[0-9]+", files)))
  files <- files[order(numbers)]
  # Создаём список кнопок.
  keyboardList <- list()
  for(i in 1:length(files)){
    keyboardList[i]<-list(list(KeyboardButton(files[i])))
  }
  
  # создаём клавиатуру
  RKM <- ReplyKeyboardMarkup(
    keyboard = keyboardList,
    resize_keyboard = FALSE,
    one_time_keyboard = TRUE
  )
  
  # отправляем клавиатуру
  bot$sendMessage( update$from_chat_id(),
                   text = 'Выберите команду', 
                   reply_markup = RKM)
}

returnPracticeFile<- function(bot, update) {
  path <- "Practice_work/"
  # Сортируем полученные имена файлов в правильном порядке
  text <- update$message$text
  numbers <- gsub("[^0-9.]", "",  text)
  
  document_url <- paste0(
    path,
    "Practice_work_",
    numbers,
    ".pdf"
  )
  if( file.exists(document_url))
  {
    bot$sendDocument(
      chat_id = update$message$chat_id,
      document = document_url
    )
  }else{
    bot$sendMessage(update$message$chat_id,
                    text = 'Извените, файл не найден')
  }
  
  #возвращаем меню на экран
  # создаём InLine клавиатуру
  IKM <- InlineKeyboardMarkup(
    inline_keyboard = list(
      list(
        InlineKeyboardButton("Практические работы", callback_data = 'PWLIST')),
      list(InlineKeyboardButton("Успеваемость", callback_data = 'studentList')
      )
    )
  )
  
  # Отправляем клавиатуру в чат
  bot$sendMessage(update$message$chat_id, 
                  text = "Что вас интересует?", 
                  reply_markup = IKM)
}

getStudentStatisctics_cb <- function(bot, update) {
  student <- update$callback_query$data
  student <- as.numeric(gsub("getSS ","",student))
  # Считываем файл
  data<-read.xlsx("students.xlsx", 1)
  student<- data[,1][student]
  # Используем имена учеников, как имена строк
  rownames(data)<-data[,1]
  data <-data[,-1]
  # Удаляем все столбцы с NA
  data <- data[ , colSums(is.na(data)) == 0]
  # сообщаем боту, что запрос с кнопки принят
  bot$answerCallbackQuery(callback_query_id = update$callback_query$id)
  
  if(sum(is.na(data[student,])) >= 1)
  {
    bot$sendMessage(chat_id = update$from_chat_id(),
                    text = "Извените, ученик не найден")
  }else
  {
    # Формируем итоговый текст ответа.
    data<-data[student,]
    subj <- names(data)
    #Оценки ученика
    vec <- c()
    for(i in 1:ncol(data)){
      emoji <- "\U000274C"
      if(data[1,i] == "да"){
        emoji <- "\U0002705"
      }
      str <- paste0(gsub("\\."," ", subj[i]), ":   ",emoji)
      vec<- c(vec, c(str))
    }
    vec<- c(c(student), vec)
    str <- paste(vec, collapse = '\n')
    bot$sendMessage(chat_id = update$from_chat_id(),
                    text = str)
  }
  #возвращаем меню на экран
  # создаём InLine клавиатуру
  IKM <- InlineKeyboardMarkup(
    inline_keyboard = list(
      list(
        InlineKeyboardButton("Практические работы", callback_data = 'PWLIST')),
      list(InlineKeyboardButton("Успеваемость", callback_data = 'studentList')
      )
    )
  )
  # Отправляем клавиатуру в чат
  bot$sendMessage(chat_id = update$from_chat_id(), text = "Что вас интересует?", reply_markup = IKM)
}
