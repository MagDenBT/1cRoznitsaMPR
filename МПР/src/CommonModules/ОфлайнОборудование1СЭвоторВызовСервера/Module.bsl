////////////////////////////////////////////////////////////////////////////////
// Подсистема "Офлайн-оборудование".
//
////////////////////////////////////////////////////////////////////////////////
#Область ПрограммныйИнтерфейс

// Возвращает массив с информацией о всех магазинах пользователя.
//
// Параметры:
//  Настройки - Структура - техническая информация об устройстве, поля:
//    Токен - Строка - токен интеграции Эвотор из личного кабинета.
//  СписокМагазинов - Массив - возвращаемый массив магазинов пользователя Эвотор.
//  ЕстьОшибки - Булево - флаг ошибки при обработке;
//  СообщениеОбОшибке - Строка - строка сообщения об ошибке;
//  ВестиЛог - Булево - флаг ведения записей в журнале регистрации;
//
Процедура ВыполнитьЗагрузкуМагазинов(Настройки, СписокМагазинов, ЕстьОшибки, СообщениеОбОшибке, ВестиЛог = Истина)Экспорт
	
	ОфлайнОборудование1СЭвоторСервер.ВыполнитьЗагрузкуМагазинов(Настройки, СписокМагазинов, ЕстьОшибки, СообщениеОбОшибке, ВестиЛог);
	
КонецПроцедуры

// Возвращает массив с информацией о всех терминалах пользователя.
//
// Параметры:
//  Настройки - Структура - техническая информация об устройстве, поля:
//    Токен - Строка - токен интеграции Эвотор из личного кабинета.
//  СписокТерминалов - Массив - возвращаемый массив магазинов пользователя Эвотор.
//  ЕстьОшибки - Булево - флаг ошибки при обработке;
//  СообщениеОбОшибке - Строка - строка сообщения об ошибке;
//  ВестиЛог - Булево - флаг ведения записей в журнале регистрации.
//
Процедура ВыполнитьЗагрузкуТерминалов(Настройки, СписокТерминалов, ЕстьОшибки, СообщениеОбОшибке, ВестиЛог = Истина)Экспорт
	
	ОфлайнОборудование1СЭвоторСервер.ВыполнитьЗагрузкуТерминалов(Настройки, СписокТерминалов, ЕстьОшибки, СообщениеОбОшибке, ВестиЛог);
	
КонецПроцедуры

// Возвращает массив с информацией о всех сотрудниках пользователя. Под сотрудниками понимаются пользователи смарт-терминалов, например, кассиры.
//
// Параметры:
//  Настройки - Структура - техническая информация об устройстве, поля:
//    Токен - Строка - токен интеграции Эвотор из личного кабинета.
//  СписокСотрудников - Массив - возвращаемый массив магазинов пользователя Эвотор.
//  ЕстьОшибки - Булево - флаг ошибки при обработке;
//  СообщениеОбОшибке - Строка - строка сообщения об ошибке;
//  ВестиЛог - Булево - флаг ведения записей в журнале регистрации.
//
Процедура ВыполнитьЗагрузкуСотрудников(Настройки, СписокСотрудников, ЕстьОшибки, СообщениеОбОшибке, ВестиЛог = Истина)Экспорт
	
	ОфлайнОборудование1СЭвоторСервер.ВыполнитьЗагрузкуСотрудников(Настройки, СписокСотрудников, ЕстьОшибки, СообщениеОбОшибке, ВестиЛог);
	
КонецПроцедуры

// Загружает информацию об одном или нескольких товарах в определенный магазин ({storeUuid}) пользователя платформы.
// При обновлении товара необходимо передавать полный набор полей описания товара. Облако удаляет старые и записывает новые поля.
//
// Параметры:
//  Настройки - Структура - техническая информация об устройстве, поля:
//    Токен - Строка - токен интеграции Эвотор из личного кабинета,
//    МагазинЗначение - Строка - УИД магазина из облака Эвотор для передачи товаров.
//  Товары - Массив - список товаров для отправки в магазин Эвотор;
//  ЕстьОшибки - Булево - флаг ошибки при обработке;
//  СообщениеОбОшибке - Строка - строка сообщения об ошибке;
//  ВестиЛог - Булево - флаг ведения записей в журнале регистрации;
//
Процедура ВыполнитьВыгрузкуТоваров(Настройки, Товары, ЕстьОшибки, СообщениеОбОшибке, ВестиЛог = Истина)Экспорт
	
	ОфлайнОборудование1СЭвоторСервер.ВыполнитьВыгрузкуТоваров(Настройки, Товары, ЕстьОшибки, СообщениеОбОшибке, ВестиЛог);
	
КонецПроцедуры

// Возвращает информацию обо всех товарах в определенном магазине ({storeUuid}) пользователя платформы.
//
// Параметры:
//  Настройки - Структура - техническая информация об устройстве, поля:
//    Токен - Строка - токен интеграции Эвотор из личного кабинета,
//    МагазинЗначение - Строка - УИД магазина из облака Эвотор для передачи товаров.
//  Товары - Массив - возвращаемый массив товаров из указанного магазина пользователя Эвотор.
//  ЕстьОшибки - Булево - флаг ошибки при обработке;
//  СообщениеОбОшибке - Строка - строка сообщения об ошибке;
//  ВестиЛог - Булево - флаг ведения записей в журнале регистрации;
//
Процедура ВыполнитьЗагрузкуТоваров(Настройки, Товары, ЕстьОшибки, СообщениеОбОшибке, ВестиЛог = Истина)Экспорт
	
	ОфлайнОборудование1СЭвоторСервер.ВыполнитьЗагрузкуТоваров(Настройки, Товары, ЕстьОшибки, СообщениеОбОшибке, ВестиЛог);
	
КонецПроцедуры

// Возвращает таблицу значений документов.
//
// Параметры:
//  Настройки - Структура - техническая информация об устройстве, поля:
//    Токен - Строка - токен интеграции Эвотор из личного кабинета,
//    МагазинЗначение - Строка - УИД магазина из облака Эвотор для загрузки документов,
//    ТерминалЗначение - Строка - УИД терминала из облака Эвотор для загрузки документов (необязательно),
//    ПериодНачалоВыгрузки - ДатаВремя - Желаемая дата начала загрузки документов из Облака Эвотор (необязательно),
//    ПериодОкончаниеВыгрузки - ДатаВремя - Желаемая дата окончания загрузки документов из Облака Эвотор (необязательно),
//    ТипыДокументов - Строка - Типы выгружаемых документов в формате облака Эвотор (необязательно).
//  КассовыеДокументы - ТаблицаЗначений - возвращаемая таблица кассовых документов.
//  ЕстьОшибки - Булево - флаг ошибки при обработке;
//  СообщениеОбОшибке - Строка - строка сообщения об ошибке;
//  ВестиЛог - Булево - флаг ведения записей в журнале регистрации;
//
Процедура ВыполнитьЗагрузкуСпискаДокументов(Настройки, КассовыеДокументы, ЕстьОшибки, СообщениеОбОшибке, ВестиЛог = Истина)Экспорт
	
	ОфлайнОборудование1СЭвоторСервер.ВыполнитьЗагрузкуСпискаДокументов(Настройки, КассовыеДокументы, ЕстьОшибки, СообщениеОбОшибке, ВестиЛог);
	
КонецПроцедуры

// HTTP-запрос с пустым массивом удалит все товары в магазине. Чтобы удалить определенный товар, в теле HTTP-запроса требуется указать его UUID.
//
// Параметры:
//  Настройки - Структура - техническая информация об устройстве, поля:
//    Токен - Строка - токен интеграции Эвотор из личного кабинета,
//    МагазинЗначение - Строка - УИД магазина из облака Эвотор для удаления товаров.
//  Товары - Массив - список товаров для удаления в магазине Эвотор;
//  ЕстьОшибки - Булево - флаг ошибки при обработке;
//  СообщениеОбОшибке - Строка - строка сообщения об ошибке;
//  ВестиЛог - Булево - флаг ведения записей в журнале регистрации;
//
Процедура ВыполнитьОчисткуТоваров(Настройки, Товары, ЕстьОшибки, СообщениеОбОшибке, ВестиЛог = Истина)Экспорт
	
	ОфлайнОборудование1СЭвоторСервер.ВыполнитьОчисткуТоваров(Настройки, Товары, ЕстьОшибки, СообщениеОбОшибке, ВестиЛог);
	
КонецПроцедуры

// Выполняет технический тест устройства.
//
// Параметры:
//  Настройки - Структура - техническая информация об устройстве, поля:
//    Токен - Строка - токен интеграции Эвотор из личного кабинета.
//  Результат - Булево - результат тестирования устройства.
//  ЕстьОшибки - Булево - флаг ошибки при обработке;
//  СообщениеОбОшибке - Строка - строка сообщения об ошибке;
//  ВестиЛог - Булево - флаг ведения записей в журнале регистрации.
//
Процедура ВыполнитьТестУстройства(Настройки, Результат, ЕстьОшибки, СообщениеОбОшибке, ВестиЛог = Истина)Экспорт
	
	ОфлайнОборудование1СЭвоторСервер.ВыполнитьТестУстройства(Настройки, Результат, ЕстьОшибки, СообщениеОбОшибке, ВестиЛог);
	
КонецПроцедуры

// Заполняет структуру Параметры датой последней загрузки
//
// Параметры:
//  Параметры - Структура - Параметры устройства.
//
Процедура ПолучитьДатуПоследнейЗагрузки(Параметры) Экспорт
	
	ОфлайнОборудование1СЭвоторСервер.ПолучитьДатуПоследнейЗагрузки(Параметры);
	
КонецПроцедуры

// Заполнить дату последней попытки загрузки.
// 
// Параметры:
//  Параметры - Структура - Параметры
//  ДатаОкончанияВыгрузки - Дата - Дата окончания выгрузки
// 
// Возвращаемое значение:
//  Булево - Заполнить дату последней попытки загрузки
Функция ЗаполнитьДатуПоследнейПопыткиЗагрузки(Параметры, ДатаОкончанияВыгрузки) Экспорт
	
	Возврат ОфлайнОборудование1СЭвоторСервер.ЗаполнитьДатуПоследнейПопыткиЗагрузки(Параметры, ДатаОкончанияВыгрузки);
	
КонецФункции

// Заполнить дату последней загрузки.
// 
// Параметры:
//  Параметры - Структура - Параметры
//  ВыходныеПараметры - Структура -Выходные параметры
// 
// Возвращаемое значение:
//  Булево - Заполнить дату последней загрузки
Функция ЗаполнитьДатуПоследнейЗагрузки(Параметры, ВыходныеПараметры) Экспорт
	
	Возврат ОфлайнОборудование1СЭвоторСервер.ЗаполнитьДатуПоследнейЗагрузки(Параметры, ВыходныеПараметры);
	
КонецФункции

#КонецОбласти