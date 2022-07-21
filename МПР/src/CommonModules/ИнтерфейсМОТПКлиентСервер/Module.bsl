#Область ПрограммныйИнтерфейс

// Инициализировать структуру параметров запроса в ИС МОТП (ИС МП) для получения ключа сессии.
// 
// Параметры:
// 	Организация - ОпределяемыйТип.Организация, Неопределено - Организация.
// Возвращаемое значение:
// 	Структура - Параметры запроса ключа сессии См. ИнтерфейсАвторизацииИСМПКлиентСервер.ПараметрыЗапросаКлючаСессии.
//
Функция ПараметрыЗапросаКлючаСессии(Организация = Неопределено) Экспорт
	
	ПараметрыОтправкиHTTPЗапросов = ПараметрыОтправкиHTTPЗапросов("", Истина);
	
	ПараметрыЗапроса = ИнтерфейсАвторизацииИСМПКлиентСервер.ПараметрыЗапросаКлючаСессии();
	ПараметрыЗапроса.Организация = Организация;
	
	ПараметрыЗапроса.ПредставлениеСервиса             = ПараметрыОтправкиHTTPЗапросов.ПредставлениеСервиса;
	ПараметрыЗапроса.Сервер                           = ПараметрыОтправкиHTTPЗапросов.Сервер;
	ПараметрыЗапроса.Порт                             = ПараметрыОтправкиHTTPЗапросов.Порт;
	ПараметрыЗапроса.Таймаут                          = ПараметрыОтправкиHTTPЗапросов.Таймаут;
	ПараметрыЗапроса.ИспользоватьЗащищенноеСоединение = ПараметрыОтправкиHTTPЗапросов.ИспользоватьЗащищенноеСоединение;
	
	ПараметрыЗапроса.ИмяПараметраСеанса                = "ДанныеКлючаСессииИСМП";
	ПараметрыЗапроса.АдресЗапросаПараметровАвторизации = "api/v3/true-api/auth/key";
	ПараметрыЗапроса.АдресЗапросаКлючаСессии           = "api/v3/true-api/auth/simpleSignIn";
	
	Возврат ПараметрыЗапроса;
	
КонецФункции

// Возвращает адрес сервера ИС МОТП.
// 
// Возвращаемое значение:
// 	Строка - адрес сервера ИС МОТП.
//
Функция АдресСервера(Авторизация = Ложь) Экспорт
	
	РежимРаботыСТестовымКонтуромИСМП = ИнтеграцияИСМПКлиентСерверПовтИсп.РежимРаботыСТестовымКонтуромИСМП();
	
	Если РежимРаботыСТестовымКонтуромИСМП Тогда
		Возврат "markirovka.sandbox.crptech.ru";
	Иначе
		Возврат "ismotp.crptech.ru";
	КонецЕсли;
	
КонецФункции

// Возвращает параметры для отправки HTTP запросов МОТП.
// 
// Возвращаемое значение:
// 	Структура - Описание:
// * ИспользоватьЗащищенноеСоединение - Булево - Признак использования SSL.
// * Таймаут - Число - Таймаут соединения.
// * Порт - Число - Порт соединения.
// * Сервер - Строка - Адрес сервера.
// * ПредставлениеСервиса - Строка - Представления сервиса.
//
Функция ПараметрыОтправкиHTTPЗапросов(Поддомен = "api", Авторизация = Ложь) Экспорт
	
	Если ЗначениеЗаполнено(Поддомен) Тогда
		АдресСервера = СтрШаблон("%1.%2", Поддомен, АдресСервера(Авторизация));
	Иначе
		АдресСервера = АдресСервера(Авторизация);
	КонецЕсли;
	
	ПараметрыОтправкиHTTPЗапросов = Новый Структура;
	ПараметрыОтправкиHTTPЗапросов.Вставить("Сервер",                           АдресСервера);
	ПараметрыОтправкиHTTPЗапросов.Вставить("Порт",                             443);
	ПараметрыОтправкиHTTPЗапросов.Вставить("Таймаут",                          60);
	ПараметрыОтправкиHTTPЗапросов.Вставить("ИспользоватьЗащищенноеСоединение", Истина);
	ПараметрыОтправкиHTTPЗапросов.Вставить("ПредставлениеСервиса",             НСтр("ru = 'ГИС МТ'"));
	
	Возврат ПараметрыОтправкиHTTPЗапросов;
	
КонецФункции

#КонецОбласти