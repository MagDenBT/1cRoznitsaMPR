#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Получает склад, если склад один в справочнике.
//
// Параметры:
//  Магазин - СправочникСсылка.Магазины - магазин для получения склада.
//  ТипСклада - ПеречислениеСсылка.ТипыСкладов - типы склада магазина.
//
// Возвращаемое значение:
//  СправочникСсылка.Склады - Найденный склад
//  Неопределено - если складов нет или больше одного.
//
Функция ПолучитьСкладПоУмолчанию(Магазин, ТипСклада) Экспорт
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ ПЕРВЫЕ 2
	|	Склады.Ссылка КАК Склад
	|ИЗ
	|	Справочник.Склады КАК Склады
	|ГДЕ
	|	(НЕ Склады.ПометкаУдаления)
	|	И (Склады.Магазин = &Магазин
	|			ИЛИ &Магазин = НЕОПРЕДЕЛЕНО)
	|	И (Склады.ТипСклада = &ТипСклада
	|			ИЛИ &ТипСклада = НЕОПРЕДЕЛЕНО)");
	
	Запрос.УстановитьПараметр("Магазин", ?(ЗначениеЗаполнено(Магазин), Магазин, Неопределено));
	Запрос.УстановитьПараметр("ТипСклада", ?(ЗначениеЗаполнено(ТипСклада), ТипСклада, Неопределено));
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() И Выборка.Количество() = 1 Тогда
		Склад = Выборка.Склад;
	Иначе
		Склад = Справочники.Склады.ПустаяСсылка();
	КонецЕсли;
	
	Возврат Склад;

КонецФункции

// Получает склад поступления по умолчанию.
//
// Параметры:
//  Магазин - СправочникСсылка.Магазины - магазин для получения склада.
//  ТипСклада - ПеречислениеСсылка.ТипыСкладов - типы склада магазина.
//
// Возвращаемое значение:
//  СправочникСсылка.Склады - Найденный склад
//  Неопределено - если склад не найден.
//
Функция ПолучитьСкладПоступленияПоУмолчанию(Магазин, ТипСклада) Экспорт
	
	Возврат ПолучитьСкладПоУмолчанию(Магазин, ТипСклада);

КонецФункции

// Получает склад поступления по умолчанию.
//
// Параметры:
//  Магазин - СправочникСсылка.Магазины - магазин для получения склада.
//  ТипСклада - ПеречислениеСсылка.ТипыСкладов - типы склада магазина.
//
// Возвращаемое значение:
//  СправочникСсылка.Склады - Найденный склад
//  Неопределено - если склад не найден.
//
Функция ПолучитьСкладПродажиПоУмолчанию(Магазин, ТипСклада) Экспорт
	
	Возврат ПолучитьСкладПоУмолчанию(Магазин, ТипСклада);

КонецФункции

// Проверяет принадлежность склада магазину.
//
// Параметры:
//  Магазин - СправочникСсылка.Магазины - магазин для проверки принадлежности склада.
//  Склад - СправочникСсылка.Склады - склад для проверки.
//
// Возвращаемое значение:
//  Булево - результат проверки.
//
Функция ПроверитьПринадлежностьСкладаМагазину(Магазин, Склад) Экспорт
	
	Запрос = Новый Запрос("ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	Склады.Ссылка
	|ИЗ
	|	Справочник.Склады КАК Склады
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Магазины КАК Магазины
	|		ПО Склады.Магазин = Магазины.Ссылка
	|ГДЕ
	|	Склады.Магазин = &Магазин
	|	И Склады.Ссылка = &Склад
	|	И (НЕ Магазины.СкладУправляющейСистемы)");
	Запрос.УстановитьПараметр("Магазин", Магазин);
	Запрос.УстановитьПараметр("Склад", Склад);
	РезультатЗапроса = Запрос.Выполнить();
	Возврат НЕ РезультатЗапроса.Пустой();
	
КонецФункции

// Получает реквизиты объекта, которые необходимо блокировать от изменения.
//
// Возвращаемое значение:
//  Массив - блокируемые реквизиты объекта.
//
Функция ПолучитьБлокируемыеРеквизитыОбъекта() Экспорт

	Результат = Новый Массив;
	Результат.Добавить("Организация");
	Результат.Добавить("Магазин");
	Результат.Добавить("ТипСклада");
		
	Возврат Результат;

КонецФункции

// Определяет настройки объекта для подсистемы ВерсионированиеОбъектов.
//
// Параметры:
//  Настройки - Структура - настройки подсистемы.
//
Процедура ПриОпределенииНастроекВерсионированияОбъектов(Настройки) Экспорт
	
КонецПроцедуры

// Определяет использование нескольких складов у Магазина. Если Магазин не указан, 
// тогда во всей базе.
//
// Параметры:
//  Магазин - СправочникСсылка.Магазины - необязательный.
// 
// Возвращаемое значение:
//  Булево - признак использование нескольких складов.
//
Функция ИспользуетсяНесколькоСкладов(Магазин = Неопределено) Экспорт
	
	СхемаЗапроса 		= Новый СхемаЗапроса;
	ПакетЗапросов 		= СхемаЗапроса.ПакетЗапросов[0];
	Операторы 			= ПакетЗапросов.Операторы[0];
	ИсточникДокумент 	= Операторы.Источники.Добавить("Справочник.Склады","Склады");
	Операторы.ВыбираемыеПоля.Добавить("Склады.Ссылка");
	
	Операторы.Отбор.Добавить("НЕ Склады.ПометкаУдаления");
	
	Если ЗначениеЗаполнено(Магазин) Тогда
		Операторы.Отбор.Добавить("Склады.Магазин = &Магазин");
	КонецЕсли; 
	
	ТекстЗапроса = СхемаЗапроса.ПолучитьТекстЗапроса();
	
	Запрос = Новый Запрос;
	Запрос.Текст = ТекстЗапроса;
	
	Если ЗначениеЗаполнено(Магазин) Тогда
		Запрос.УстановитьПараметр("Магазин", Магазин);;
	КонецЕсли;
	
	РезультатЗапроса = Запрос.Выполнить();
	
	КоличествоСкладов = РезультатЗапроса.Выбрать().Количество();
	
	Возврат КоличествоСкладов > 1
	
КонецФункции

#КонецОбласти

#КонецЕсли
