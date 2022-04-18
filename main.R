#Подключение пакета
library(telegram.bot)
# Создаём экземпляр класса Updater
updater <- Updater("5235357559:AAHbJ3l18FN19_6oC6CM9d34QiTDVzpTqb0")
# Загрузка компонентов бота
source('functions.R',encoding = "UTF-8") # файл пользовательских функций
source('methods.R',encoding = "UTF-8") # файл обработчиков
source('filters.R',encoding = "UTF-8") # файл фильтров
# создаём обработчики
start_h         <- CommandHandler('start', menu)
menu_h          <- CommandHandler('menu', menu)
getPractice_txt_hnd <- MessageHandler(returnPracticeFile, filters = MessageFilters$getPractice)
query_handler_PWLIST                <- CallbackQueryHandler(PracticeWorkList,pattern = 'PWLIST')
query_handler_studentList           <- CallbackQueryHandler(StudentList,pattern = 'studentList')
query_handler_getStudentStatisctics <- CallbackQueryHandler(getStudentStatisctics_cb,pattern = 'getSS ')
# добавляем обработчики в диспетчер
updater <- updater + 
  start_h +
  menu_h +
  getPractice_txt_hnd+
  query_handler_PWLIST+
  query_handler_studentList +
  query_handler_getStudentStatisctics
# запускаем бота
updater$start_polling()
