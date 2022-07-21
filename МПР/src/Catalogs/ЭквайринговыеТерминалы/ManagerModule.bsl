#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Возвращает организацию, кассу и валюту выбранного эквайрингового терминала.
//
// Параметры:
//  ЭквайринговыйТерминал - СправочникСсылка.ЭквайринговыеТерминалы - Ссылка на эквайринговый терминал.
//
// Возвращаемое значение:
//	Структура - Организация, Касса и Валюта эквайрингового терминала.
//
Функция РеквизитыЭквайринговогоТерминала(ЭквайринговыйТерминал) Экспорт
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ЭквайринговыеТерминалы.Организация КАК Организация,
	|	ЭквайринговыеТерминалы.Касса КАК Касса,
	|	ЭквайринговыеТерминалы.Магазин КАК Магазин,
	|	ЭквайринговыеТерминалы.ИспользоватьБезПодключенияОборудования КАК ИспользоватьБезПодключенияОборудования,
	|	ЭквайринговыеТерминалы.Эквайрер
	|ИЗ
	|	Справочник.ЭквайринговыеТерминалы КАК ЭквайринговыеТерминалы
	|ГДЕ
	|	ЭквайринговыеТерминалы.Ссылка = &ЭквайринговыйТерминал");
	
	Запрос.УстановитьПараметр("ЭквайринговыйТерминал", ЭквайринговыйТерминал);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		Организация = Выборка.Организация;
		Касса = Выборка.Касса;
		Эквайрер = Выборка.Эквайрер;
		Магазин = Выборка.Магазин;
		ИспользоватьБезПодключенияОборудования = Выборка.ИспользоватьБезПодключенияОборудования;
	Иначе
		Организация = Неопределено;
		Касса = Неопределено;
		Эквайрер = Неопределено;
		Магазин = Неопределено;
		ИспользоватьБезПодключенияОборудования = Неопределено;
	КонецЕсли;
	
	СтруктураРеквизитов = Новый Структура;
	СтруктураРеквизитов.Вставить("Организация", Организация);
	СтруктураРеквизитов.Вставить("Касса", Касса);
	СтруктураРеквизитов.Вставить("Эквайрер", Эквайрер);
	СтруктураРеквизитов.Вставить("Магазин", Магазин);
	СтруктураРеквизитов.Вставить("ИспользоватьБезПодключенияОборудования", ИспользоватьБезПодключенияОборудования);
	
	Возврат СтруктураРеквизитов;
	
КонецФункции

// Возвращает эквайринговый терминал, если найден один эквайринговый терминал по выбранной кассе или организации.
// Возвращает Неопределено, если эквайринговый терминал не найден или эквайринговых терминалов больше одного.
//
// Параметры:
//  Касса - СправочникСсылка.Кассы, СправочникСсылка.КассыККМ - Выбранная касса.
//  Организация - СправочникСсылка.Организации - Выбранная организация.
//  Магазин - СправочникСсылка.Магазины - магазин организации.
//  ВидОплаты - СправочникСсылка.ВидыОплаты - виды оплаты.
//
// Возвращаемое значение:
//	СправочникСсылка.ЭквайринговыеТерминалы - Найденный эквайринговый терминал.
//
Функция ЭквайринговыйТерминалПоУмолчанию(Касса, Организация = Неопределено, Магазин = Неопределено, ВидОплаты = Неопределено, ВключаяБезПодключенияОборудования = Истина) Экспорт
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ РАЗЛИЧНЫЕ ПЕРВЫЕ 2
	|	ЭквайринговыеТерминалы.Ссылка КАК ЭквайринговыйТерминал
	|ИЗ
	|	Справочник.ЭквайринговыеТерминалы.ТарифыЗаРасчетноеОбслуживание КАК ЭквайринговыеТерминалы
	|ГДЕ
	|	НЕ ЭквайринговыеТерминалы.Ссылка.ПометкаУдаления
	|	И (ЭквайринговыеТерминалы.Ссылка.Касса = &Касса
	|			ИЛИ &Касса = НЕОПРЕДЕЛЕНО
	|				И ЭквайринговыеТерминалы.Ссылка.Касса ССЫЛКА Справочник.Кассы)
	|	И (ЭквайринговыеТерминалы.Ссылка.Организация = &Организация
	|			ИЛИ &Организация = НЕОПРЕДЕЛЕНО)
	|	И (ЭквайринговыеТерминалы.ВидОплаты = &ВидОплаты
	|			ИЛИ &ВидОплаты = НЕОПРЕДЕЛЕНО)
	|	И (ЭквайринговыеТерминалы.Ссылка.Магазин = &Магазин
	|			ИЛИ &Магазин = НЕОПРЕДЕЛЕНО)
	|	И НЕ ЭквайринговыеТерминалы.Ссылка.НеДействителен
	|	И ВЫБОР
	|			КОГДА &ВключаяБезПодключенияОборудования = ИСТИНА
	|				ТОГДА ИСТИНА
	|			ИНАЧЕ ЭквайринговыеТерминалы.Ссылка.ИспользоватьБезПодключенияОборудования = ЛОЖЬ
	|		КОНЕЦ");
	Если НЕ ЗначениеЗаполнено(Магазин) Тогда
		Магазин = ПараметрыСеанса.ТекущийМагазин;
	КонецЕсли;
	Запрос.УстановитьПараметр("Касса", ?(ЗначениеЗаполнено(Касса), Касса, Неопределено));
	Запрос.УстановитьПараметр("Организация", ?(ЗначениеЗаполнено(Организация), Организация, Неопределено));
	Запрос.УстановитьПараметр("Магазин", ?(ЗначениеЗаполнено(Магазин), Магазин, Неопределено));
	Запрос.УстановитьПараметр("ВидОплаты", ?(ЗначениеЗаполнено(ВидОплаты), ВидОплаты, Неопределено));
	Запрос.УстановитьПараметр("ВключаяБезПодключенияОборудования", ВключаяБезПодключенияОборудования);
	
	Выборка = Запрос.Выполнить().Выбрать();

	Если Выборка.Количество() = 1
		И Выборка.Следующий() Тогда
		ЭквайринговыйТерминал = Выборка.ЭквайринговыйТерминал;
	Иначе
		ЭквайринговыйТерминал = Справочники.ЭквайринговыеТерминалы.ПустаяСсылка();
	КонецЕсли;
	
	Возврат ЭквайринговыйТерминал;

КонецФункции

// Получить блокируемые реквизиты объекта.
// 
// Возвращаемое значение:
//  Структура - массив реквизитов.
//
Функция ПолучитьБлокируемыеРеквизитыОбъекта() Экспорт

	Результат = Новый Массив;
	Результат.Добавить("Касса; ВидКассы");
	Результат.Добавить("Организация");
	Результат.Добавить("Магазин");
	Результат.Добавить("ИспользоватьБезПодключенияОборудования");
	Результат.Добавить("ПодключаемоеОборудование");
	Результат.Добавить("Эквайрер");
	Результат.Добавить("ТарифыЗаРасчетноеОбслуживание; ТарифыЗаРасчетноеОбслуживаниеЗаполнитьВсемиВидамиОплат");
	Результат.Добавить("НеДействителен");
	
	Возврат Результат;

КонецФункции

// Возвращает вид оплаты, если найден один вид оплаты в договоре эквайринга.
// 
// Параметры:
//	ДоговорыЭквайринга - СправочникСсылка.ДоговорыЭквайринга - Ссылка на договор эквайринга.
//
// Возвращаемое значение:
//	Структура - Вид оплаты договора эквайринга.
//
Функция ВидОплатыПоУмолчанию(ЭквайринговыйТерминал) Экспорт
	
	СтруктураПараметровПоУмолчанию = Новый Структура();
	Запрос = Новый Запрос();
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ЭквайринговыеТерминалыТарифыЗаРасчетноеОбслуживание.ВидОплаты КАК ВидОплаты
	|ИЗ
	|	Справочник.ЭквайринговыеТерминалы.ТарифыЗаРасчетноеОбслуживание КАК ЭквайринговыеТерминалыТарифыЗаРасчетноеОбслуживание
	|ГДЕ
	|	ЭквайринговыеТерминалыТарифыЗаРасчетноеОбслуживание.Ссылка = &ЭквайринговыйТерминал
	|	И НЕ ЭквайринговыеТерминалыТарифыЗаРасчетноеОбслуживание.Ссылка.ПометкаУдаления";
	Запрос.УстановитьПараметр("ЭквайринговыйТерминал", ЭквайринговыйТерминал);
	ВыборкаПараметрыПоУмолчанию = Запрос.Выполнить().Выбрать();
	Если ВыборкаПараметрыПоУмолчанию.Количество() = 1 И ВыборкаПараметрыПоУмолчанию.Следующий() Тогда
		СтруктураПараметровПоУмолчанию.Вставить("ВидОплаты", ВыборкаПараметрыПоУмолчанию.ВидОплаты);
	Иначе
		СтруктураПараметровПоУмолчанию.Вставить("ВидОплаты", Справочники.ВидыОплатЧекаККМ.ПустаяСсылка());
	КонецЕсли;
	
	Возврат СтруктураПараметровПоУмолчанию;
	
КонецФункции

#КонецОбласти

#КонецЕсли
