# Отправка сообщения
bot$sendMessage(chat_id = update$from_chat_id(), text = msg)

# сообщаем боту, что запрос с кнопки принят
bot$answerCallbackQuery(callback_query_id = update$callback_query$id) 

# метод остановки бота
admin_stop<- function(bot, update) {
  # Имя пользователя с которым надо поздароваться
  user_name <- update$message$from$first_name
  # Отправка приветственного сообщения
  bot$sendMessage(update$message$chat_id, 
                  text = paste0("Завершаем выполнение, ", user_name, "!"), 
                  parse_mode = "Markdown")
  updater$stop_polling()
  
}
