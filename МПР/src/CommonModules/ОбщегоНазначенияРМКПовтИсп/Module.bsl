
///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2022, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Получает значение системы налогообложения по умолчанию для организации на выбранную дату.
//
// Параметры:
//  Организация - СправочникСсылка.Организации;
//  Дата - Дата - (необязательный).
//
// Возвращаемое значение:
//  ТипСистемыНалогообложения - ПеречислениеСсылка.ТипыСистемНалогообложенияККТ.
//
Функция СистемаНалогообложенияОрганизацииПоУмолчанию(Организация, Дата = '00010101') Экспорт
	
	Результат = Перечисления.ТипыСистемНалогообложенияККТ.ПустаяСсылка();
	
	Если ЗначениеЗаполнено(Организация) Тогда
		
		Если НЕ ЗначениеЗаполнено(Дата) Тогда
			Дата = ТекущаяДатаСеанса();
		КонецЕсли;
		
		Результат = ПродажиРМК.ПолучитьТипСистемыНалогообложенияККТ(Организация, Дата);
			
	КонецЕсли;
			
	Возврат Результат;
	
КонецФункции

// Получение значения константы.
//
// Параметры:
//  ИмяКонстанты - Строка - наименование константы.
//
// Возвращаемое значение:
//  Значение - значение константы.
Функция ПолучитьЗначениеКонстанты(ИмяКонстанты) Экспорт
	Возврат Константы[ИмяКонстанты].Получить();
КонецФункции

// Получает значение шаблона чека по виду операции из значения настроек РМК
//
// Параметры:
//	ВидОперации - ПеречислениеСсылка.ВидыОперацийЧекККМ - вид операции
//	ТекущаяНастройкаРМК - СправочникСсылка.НастройкиРМК - настройки, из которых будет получено значение шаблона
//
// Возвращаемое значение:
//  Результат - СправочникСсылка.ХранилищеШаблонов - ссылка на шаблон чека
Функция ПолучитьШаблонЧека(ВидОперации, ТекущаяНастройкаРМК) Экспорт
	
	Результат = Справочники.ХранилищеШаблонов.ПустаяСсылка();
	
	ОперацияПродажи = ОбщегоНазначенияРМКПереопределяемый.ВидОперацииЧекаККМ();
	ЭтоВозврат = Истина;
	ОперацияВозврата = ОбщегоНазначенияРМКПереопределяемый.ВидОперацииЧекаККМ(ЭтоВозврат);
	
	Если ВидОперации = ОперацияПродажи Тогда
		ИмяРеквизитаШаблона = НСтр("ru = 'ШаблонЧекаПродажи'");
	ИначеЕсли ВидОперации = ОперацияВозврата Тогда
		ИмяРеквизитаШаблона = НСтр("ru = 'ШаблонЧекаВозврата'");
	Иначе
		ИмяРеквизитаШаблона = НСтр("ru = ''");
	КонецЕсли;
	
	Если НЕ ПустаяСтрока(ИмяРеквизитаШаблона) Тогда 
		Результат = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ТекущаяНастройкаРМК, ИмяРеквизитаШаблона);
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

// Формирует коллекцию исходных данных для десериализации информации о существующих запретах продаж,
// полученных из сервиса лояльности по данным мастер - системы
//
// Возвращаемое значение:
//  НаборПравил - Структура - описание соответствия контекстов API и метаданных конфигурации
//
Функция НаборПравилДесериализацииЗапретовПродаж() Экспорт

	// общие составляющие правил десериализации
	НаборПравил = Новый Структура();
	ИмяИдентификатора = "Ref";
	ПоляПоискаПоНаименованию = Новый Структура();
	ПоляПоискаПоНаименованию.Вставить("Name", "Наименование");

	
	// частные составляющие правил десериализации
	НаборПравил.Вставить("StartDate", ПравилоДесериализации("Дата"));
	НаборПравил.Вставить("EndDate", ПравилоДесериализации("Дата"));
	НаборПравил.Вставить("StartTime", ПравилоДесериализации("Время"));
	НаборПравил.Вставить("EndTime", ПравилоДесериализации("Время"));
	НаборПравил.Вставить("SalesPromotionName", ПравилоДесериализации("Строка"));
	НаборПравил.Вставить("SalesPromotionID", ПравилоДесериализации("Строка"));

	ПоляПоискаОрганизации = Новый Структура();
	ПоляПоискаОрганизации.Вставить("TIN", "ИНН");
	ПоляПоискаОрганизации.Вставить("Name", "Наименование");
	НаборПравил.Вставить("Organisation", ПравилоДесериализации("СправочникСсылка.Организации", ИмяИдентификатора,
		ПоляПоискаОрганизации));
		
	НаборПравил.Вставить("TypeOfGoods", ПравилоДесериализации("СправочникСсылка.ВидыНоменклатуры", ИмяИдентификатора,
		ПоляПоискаПоНаименованию));
		
	НаборПравил.Вставить("Feature", ПравилоДесериализации("ПеречислениеСсылка.ОсобенностиУчетаНоменклатуры",
		ИмяИдентификатора));
	
	НаборПравил.Вставить("DayOfWeek", ПравилоДесериализации("ПеречислениеСсылка.ДниНедели",
		ИмяИдентификатора));
	
	Возврат НаборПравил;

КонецФункции

//  Возвращает соответствие имен сущностей контекста сервера лояльности и текущего приложения
//
// Возвращаемое значение:
//  СоответствиеКонтекстов - Соответствие
//
Функция СоответствиеИменСущностейЗапретовПродаж() Экспорт
	
	СоответствиеКонтекстов = Новый Структура();
	
	СоответствиеКонтекстов.Вставить("DayOfWeek", "ДеньНедели");
	СоответствиеКонтекстов.Вставить("DaysOfWeek", "ДниНедели");
	СоответствиеКонтекстов.Вставить("SalesPromotionID", "ИдентификаторЗапрета");
	СоответствиеКонтекстов.Вставить("SalesPromotionName", "ИмяЗапрещающегоДокументаМастерСистемы");
	СоответствиеКонтекстов.Вставить("TypesOfGoods", "ДополнительныеУсловия");
	
	// поля, значение которых может быть пустым
	СоответствиеКонтекстов.Вставить("EndDate", "ДатаОкончанияДействия");
	СоответствиеКонтекстов.Вставить("EndTime", "ВремяОкончания");
	СоответствиеКонтекстов.Вставить("Feature", "ОсобенностьУчета");
	СоответствиеКонтекстов.Вставить("Organisation", "Организация");
	СоответствиеКонтекстов.Вставить("StartDate", "ДатаНачалаДействия");
	СоответствиеКонтекстов.Вставить("StartTime", "ВремяНачала");
	СоответствиеКонтекстов.Вставить("Store", "ТорговыйОбъект");
	СоответствиеКонтекстов.Вставить("TypeOfGoods", "ВидНоменклатуры");
	
	Возврат СоответствиеКонтекстов;
	
КонецФункции

// Возвращает информацию о возможности использования пустых десериализованных значений
//
//
// Возвращаемое значение:
//  СхемаПроверки - Структура -
// 	(содержит:
//		ИмяПоля - Строка - имя поля контекста сервиса лояльности;
//		ДопускаетсяПустоеЗначение - Булево )
//
Функция СхемаПроверкиКорректнойДесериализацииОтветаОтСервисаЛояльности() Экспорт

	СхемаПроверки = Новый Структура();
	
	// поля, значение которых не может быть пустым
	СхемаПроверки.Вставить("ДеньНедели", Ложь);
	СхемаПроверки.Вставить("ДниНедели", Ложь);
	СхемаПроверки.Вставить("ИдентификаторЗапрета", Ложь);
	СхемаПроверки.Вставить("ДополнительныеУсловия", Ложь);
	
	// поля, значение которых может быть пустым
	СхемаПроверки.Вставить("ДатаОкончанияДействия", Истина);
	СхемаПроверки.Вставить("ВремяОкончания", Истина);
	СхемаПроверки.Вставить("ОсобенностьУчета", Истина);
	СхемаПроверки.Вставить("ИмяЗапрещающегоДокументаМастерСистемы", Истина);
	СхемаПроверки.Вставить("Организация", Истина);
	СхемаПроверки.Вставить("ДатаНачалаДействия", Истина);
	СхемаПроверки.Вставить("ВремяНачала", Истина);
	СхемаПроверки.Вставить("ТорговыйОбъект", Истина);
	СхемаПроверки.Вставить("ВидНоменклатуры", Истина);
	
	Возврат СхемаПроверки;

КонецФункции

// Получает значение настройки плана обмена ЭтоПланОбменаXDTO.
//
// Параметры:
//	ИмяПланаОбмена - Строка - Имя плана обмена.
//
// Возвращаемое значение:
//  Булево - если Истина, то это обмен XDTO.
//
Функция ЭтоПланОбменаXDTO(ИмяПланаОбмена) Экспорт
	Возврат ОбменДаннымиСервер.ЗначениеНастройкиПланаОбмена(ИмяПланаОбмена, "ЭтоПланОбменаXDTO");
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ПравилоДесериализации(ТипДесериализации, УникальныйИдентификатор = Неопределено,
	ИменаПолейПоиска = Неопределено)
	
	Возврат Новый Структура("ТипДанных,Идентификатор,ПоляПоиска", ТипДесериализации,
		УникальныйИдентификатор, ИменаПолейПоиска);
		
КонецФункции

#КонецОбласти
