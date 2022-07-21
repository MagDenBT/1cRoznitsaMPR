///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2021, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// Подсистема "Сообщения в службу технической поддержки".
// ОбщийМодуль.СообщенияВСлужбуТехническойПоддержкиКлиентСервер.
//
// Клиент-серверные процедуры и функции отправки сообщений в 
// службу технической поддержки:
//  - проверка параметров сообщений;
//  - общие процедуры и функции подсистемы.
//
////////////////////////////////////////////////////////////////////////////////

#Область СлужебныеПроцедурыИФункции

// Создает новый результат операции отправки сообщения
// в службу технической поддержки.
//
// Возвращаемое значение:
//
//  Структура - результат отправки сообщения:
//   *КодОшибки - Строка - идентификатор ошибки при отправки:
//   *СообщениеОбОшибке - Строка, ФорматированнаяСтрока - сообщение об ошибке для пользователя.
//
Функция НовыйРезультатОперации() Экспорт
	
	Результат = Новый Структура;
	Результат.Вставить("КодОшибки",         "");
	Результат.Вставить("СообщениеОбОшибке", "");
	
	Возврат Результат;
	
КонецФункции

// Возвращает код ошибки "НеверныйФорматЗапроса".
//
// Возвращаемое значение:
//  Строка - код ошибки.
//
Функция КодОшибкиНеверныйФорматЗапроса() Экспорт
	
	Возврат "НеверныйФорматЗапроса";
	
КонецФункции

// Проверяет правильность заполнения параметров запроса на отправку сообщений
// в службу технической поддержки.
//
// Параметры:
//  ДанныеСообщения - Структура - данные для формирования сообщения:
//   *Тема - Строка - тема сообщения;
//   *Сообщение  - Строка - тело текст сообщения для отправки;
//   *Получатель - Строка - условное имя получателя сообщения. Возможные значения:
//        - "v8" - соответствует адресу "v8@1c.ru";
//        - "webIts" - соответствует адресам "webits-info@1c.ru" и "webits-info@1c.ua",
//          необходимый адрес выбирается в соответствии с настройками доменной зоны
//          серверов Интернет-поддержки;
//        - "taxcom" - соответствует адресу "taxcom@1c.ru";
//        - "backup" - соответствует адресу "support.backup@1c.ru";
//  Вложения - Массив Из Структура, Неопределено - файлы вложений.  Важно: допускаются только
//              текстовые вложения (*.txt). Поля структуры элемента вложения:
//               *Представление - Строка - представление вложения. Например, "Вложение 1.txt";
//               *ВидДанных - Строка - определяет преобразование переданных данных.
//                            Возможна передача одного из значений:
//                             - ИмяФайла - Строка - полное имя файла вложения;
//                             - Адрес - Строка - адрес во временном хранилище значения типа ДвоичныеДанные;
//                             - Текст - Строка - текст вложения;
//               *Данные - Строка - данные для формирования вложения;
//  ЖурналРегистрации - Структура, Неопределено - настройки выгрузки журнала регистрации:
//    *ДатаНачала    - Дата - начало периода журнала;
//    *ДатаОкончания - Дата - конец периода журнала;
//    *События       - Массив - список событий;
//    *Метаданные    - Массив, Неопределено - массив метаданных для отбора;
//    *Уровень       - Строка - уровень важности событий журнала регистрации. Возможные значения:
//       - "Ошибка" - будет выполнен отбор по событиям с УровеньЖурналаРегистрации.Ошибка;
//       - "Предупреждение" - будет выполнен отбор по событиям с УровеньЖурналаРегистрации.Предупреждение;
//       - "Информация" - будет выполнен отбор по событиям с УровеньЖурналаРегистрации.Информация;
//       - "Примечание" - будет выполнен отбор по событиям с УровеньЖурналаРегистрации.Примечание.
//
// Возвращаемое значение:
//  Структура - см. НовыйРезультатОперации.
//
Функция РезультатПроверкиПараметровОтправки(
		ДанныеСообщения,
		Вложения,
		ЖурналРегистрации) Экспорт
	
	Результат = НовыйРезультатОперации();
	
	Если Не ЗначениеЗаполнено(ДанныеСообщения.Получатель) Тогда
		ДанныеСообщения.Получатель = "webIts";
	КонецЕсли;
	
	Если ДанныеСообщения.Получатель <> "v8"
		И ДанныеСообщения.Получатель <> "webIts"
		И ДанныеСообщения.Получатель <> "taxcom"
		И ДанныеСообщения.Получатель <> "backup" Тогда
		Результат.КодОшибки         = КодОшибкиНеверныйФорматЗапроса();
		Результат.СообщениеОбОшибке = НСтр("ru = 'Неизвестный получатель сообщения.'");
		Возврат Результат;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(ДанныеСообщения.Тема) Тогда
		Результат.КодОшибки         = КодОшибкиНеверныйФорматЗапроса();
		Результат.СообщениеОбОшибке = НСтр("ru = 'Не заполнена тема сообщения.'");
		Возврат Результат;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(ДанныеСообщения.Сообщение) Тогда
		Результат.КодОшибки         = КодОшибкиНеверныйФорматЗапроса();
		Результат.СообщениеОбОшибке = НСтр("ru = 'Не заполнен текст сообщения.'");
		Возврат Результат;
	КонецЕсли;
	
	Если Вложения <> Неопределено Тогда
		
		Для Каждого ОписаниеФайла Из Вложения Цикл
			
			Если Не ЗначениеЗаполнено(ОписаниеФайла.Представление) Тогда
				Результат.КодОшибки         = КодОшибкиНеверныйФорматЗапроса();
				Результат.СообщениеОбОшибке = НСтр("ru = 'Не заполнено представление вложения.'");
				Возврат Результат;
			КонецЕсли;
			
			Если Не ЗначениеЗаполнено(ОписаниеФайла.ВидДанных) Тогда
				Результат.КодОшибки         = КодОшибкиНеверныйФорматЗапроса();
				Результат.СообщениеОбОшибке = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru = 'Не заполнен вид данных вложения %1.'"),
					ОписаниеФайла.Представление);
				Возврат Результат;
			КонецЕсли;
			
			Если Не ЗначениеЗаполнено(ОписаниеФайла.Данные) Тогда
				Результат.КодОшибки         = КодОшибкиНеверныйФорматЗапроса();
				Результат.СообщениеОбОшибке = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru = 'Не заполнены данные вложения %1.'"),
					ОписаниеФайла.Представление);
				Возврат Результат;
			КонецЕсли;
			
			Если ОписаниеФайла.ВидДанных <> "Адрес"
				И ОписаниеФайла.ВидДанных <> "ИмяФайла"
				И ОписаниеФайла.ВидДанных <> "Текст" Тогда
				Результат.КодОшибки         = КодОшибкиНеверныйФорматЗапроса();
				Результат.СообщениеОбОшибке = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru = 'Передан не верный вид данных вложения %1.'"),
					ОписаниеФайла.ВидДанных);
				Возврат Результат;
			КонецЕсли;
			
			НедопустимыеСимволы = ОбщегоНазначенияКлиентСервер.НайтиНедопустимыеСимволыВИмениФайла(
				ОписаниеФайла.Представление);
			Если СтрНайти(ОписаниеФайла.Представление, "@") <> 0 Тогда
				НедопустимыеСимволы.Добавить("@");
			КонецЕсли;
			
			Если НедопустимыеСимволы.Количество() > 0 Тогда
				Результат.КодОшибки         = КодОшибкиНеверныйФорматЗапроса();
				Результат.СообщениеОбОшибке = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru = 'В представлении обнаружены не допустимые символы:%1.'"),
					СтрСоединить(НедопустимыеСимволы, ","));
				Возврат Результат;
			КонецЕсли;
			
		КонецЦикла;
		
	КонецЕсли;
	
	Если ЖурналРегистрации <> Неопределено Тогда
		Если ЖурналРегистрации.ДатаНачала > ЖурналРегистрации.ДатаОкончания Тогда
			Результат.КодОшибки         = КодОшибкиНеверныйФорматЗапроса();
			Результат.СообщениеОбОшибке =
				НСтр("ru = 'Некорректный отбор данных журнала регистрации. Дата начала отбора меньше даты окончания.'");
			Возврат Результат;
		КонецЕсли;
		Если ЗначениеЗаполнено(ЖурналРегистрации.Уровень)
			И ЖурналРегистрации.Уровень <> "Ошибка"
			И ЖурналРегистрации.Уровень <> "Предупреждение"
			И ЖурналРегистрации.Уровень <> "Информация"
			И ЖурналРегистрации.Уровень <> "Примечание" Тогда
			Результат.КодОшибки         = КодОшибкиНеверныйФорматЗапроса();
			Результат.СообщениеОбОшибке =
				НСтр("ru = 'Не допустимый отбор данных журнала регистрации. Некорректный уровень событий журнала регистрации.'");
			Возврат Результат;
		КонецЕсли;

	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти
