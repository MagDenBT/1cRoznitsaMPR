#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Инициализирует таблицы значений, содержащие данные документа.
// Таблицы значений сохраняет в свойствах структуры "ДополнительныеСвойства".
//
// Параметры:
//  ДокументСсылка - ДокументСсылка.ВводОстатковРасчетовСПоставщиками - документ начальных остатков.
//  ДополнительныеСвойства - Структура - дополнительные свойства выполнения операции.
//
Процедура ИнициализироватьДанныеДокумента(ДокументСсылка, ДополнительныеСвойства) Экспорт

	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	ВводОстатковПрослеживаемыхИмпортныхТоваровТовары.НомерСтроки КАК НомерСтроки,
	|	ВводОстатковПрослеживаемыхИмпортныхТоваровТовары.Ссылка.Дата КАК Период,
	|	ВводОстатковПрослеживаемыхИмпортныхТоваровТовары.Номенклатура КАК Номенклатура,
	|	ВводОстатковПрослеживаемыхИмпортныхТоваровТовары.Характеристика КАК Характеристика,
	|	ВводОстатковПрослеживаемыхИмпортныхТоваровТовары.Склад КАК Склад,
	|	ВводОстатковПрослеживаемыхИмпортныхТоваровТовары.Ссылка.Организация КАК Организация,
	|	ВводОстатковПрослеживаемыхИмпортныхТоваровТовары.Поставщик КАК Поставщик,
	|	ВводОстатковПрослеживаемыхИмпортныхТоваровТовары.Договор КАК Договор
	|ПОМЕСТИТЬ ВТНомераГТДКСписанию
	|ИЗ
	|	Документ.ВводОстатковПрослеживаемыхИмпортныхТоваров.Товары КАК ВводОстатковПрослеживаемыхИмпортныхТоваровТовары
	|ГДЕ
	|	ВводОстатковПрослеживаемыхИмпортныхТоваровТовары.Ссылка = &Ссылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВводОстатковПрослеживаемыхИмпортныхТоваровТовары.НомерСтроки КАК НомерСтроки,
	|	ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход) КАК ВидДвижения,
	|	ВводОстатковПрослеживаемыхИмпортныхТоваровТовары.Ссылка.Дата КАК Период,
	|	ВводОстатковПрослеживаемыхИмпортныхТоваровТовары.Номенклатура КАК Номенклатура,
	|	ВводОстатковПрослеживаемыхИмпортныхТоваровТовары.Характеристика КАК Характеристика,
	|	ВводОстатковПрослеживаемыхИмпортныхТоваровТовары.Склад КАК Склад,
	|	ВводОстатковПрослеживаемыхИмпортныхТоваровТовары.Ссылка.Организация КАК Организация,
	|	ВводОстатковПрослеживаемыхИмпортныхТоваровТовары.Поставщик КАК Поставщик,
	|	ВводОстатковПрослеживаемыхИмпортныхТоваровТовары.Договор КАК Договор,
	|	ВводОстатковПрослеживаемыхИмпортныхТоваровТовары.НомерГТД КАК НомерГТД,
	|	ВводОстатковПрослеживаемыхИмпортныхТоваровТовары.Количество КАК Количество,
	|	ВводОстатковПрослеживаемыхИмпортныхТоваровТовары.КоличествоПоРНПТ КАК КоличествоПоРНПТ
	|ИЗ
	|	Документ.ВводОстатковПрослеживаемыхИмпортныхТоваров.Товары КАК ВводОстатковПрослеживаемыхИмпортныхТоваровТовары
	|ГДЕ
	|	ВводОстатковПрослеживаемыхИмпортныхТоваровТовары.Ссылка = &Ссылка
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	МИНИМУМ(ВТНомераГТДКСписанию.НомерСтроки),
	|	ЗНАЧЕНИЕ(ВидДвиженияНакопления.Расход),
	|	ВТНомераГТДКСписанию.Период,
	|	ВТНомераГТДКСписанию.Номенклатура,
	|	ВТНомераГТДКСписанию.Характеристика,
	|	ВТНомераГТДКСписанию.Склад,
	|	ВТНомераГТДКСписанию.Организация,
	|	ВТНомераГТДКСписанию.Поставщик,
	|	ВТНомераГТДКСписанию.Договор,
	|	ТоварыОрганизацийОстатки.НомерГТД,
	|	ТоварыОрганизацийОстатки.КоличествоОстаток,
	|	0
	|ИЗ
	|	ВТНомераГТДКСписанию КАК ВТНомераГТДКСписанию
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрНакопления.ТоварыОрганизаций.Остатки(
	|				&Период,
	|				(Номенклатура, Характеристика, Склад, Организация, Поставщик, Договор) В
	|					(ВЫБРАТЬ
	|						ВТНомераГТДКСписанию.Номенклатура,
	|						ВТНомераГТДКСписанию.Характеристика,
	|						ВТНомераГТДКСписанию.Склад,
	|						ВТНомераГТДКСписанию.Организация,
	|						ВТНомераГТДКСписанию.Поставщик,
	|						ВТНомераГТДКСписанию.Договор
	|					ИЗ
	|						ВТНомераГТДКСписанию)) КАК ТоварыОрганизацийОстатки
	|		ПО ВТНомераГТДКСписанию.Номенклатура = ТоварыОрганизацийОстатки.Номенклатура
	|			И ВТНомераГТДКСписанию.Характеристика = ТоварыОрганизацийОстатки.Характеристика
	|			И ВТНомераГТДКСписанию.Склад = ТоварыОрганизацийОстатки.Склад
	|			И ВТНомераГТДКСписанию.Организация = ТоварыОрганизацийОстатки.Организация
	|			И ВТНомераГТДКСписанию.Поставщик = ТоварыОрганизацийОстатки.Поставщик
	|			И ВТНомераГТДКСписанию.Договор = ТоварыОрганизацийОстатки.Договор
	|ГДЕ
	|	ТоварыОрганизацийОстатки.КоличествоПоРНПТОстаток = 0
	|
	|СГРУППИРОВАТЬ ПО
	|	ВТНомераГТДКСписанию.Период,
	|	ВТНомераГТДКСписанию.Номенклатура,
	|	ВТНомераГТДКСписанию.Характеристика,
	|	ВТНомераГТДКСписанию.Склад,
	|	ВТНомераГТДКСписанию.Организация,
	|	ВТНомераГТДКСписанию.Поставщик,
	|	ВТНомераГТДКСписанию.Договор,
	|	ТоварыОрганизацийОстатки.НомерГТД,
	|	ТоварыОрганизацийОстатки.КоличествоОстаток");
	
	Запрос.УстановитьПараметр("Период", Новый Граница(ДокументСсылка.Дата, ВидГраницы.Исключая));
	Запрос.УстановитьПараметр("Ссылка", ДокументСсылка);
	
	Результат = Запрос.ВыполнитьПакет();
	
	ДополнительныеСвойства.ТаблицыДляДвижений.Вставить("ТаблицаТоварыОрганизаций", Результат[1].Выгрузить());
	
КонецПроцедуры

// Определяет настройки объекта для подсистемы ВерсионированиеОбъектов.
//
// Параметры:
//  Настройки - Структура - настройки подсистемы.
Процедура ПриОпределенииНастроекВерсионированияОбъектов(Настройки) Экспорт
	
КонецПроцедуры

// СтандартныеПодсистемы.УправлениеДоступом

// См. УправлениеДоступомПереопределяемый.ПриЗаполненииСписковСОграничениемДоступа.
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт

	Ограничение.Текст =
	"РазрешитьЧтениеИзменение
	|ГДЕ
	|	ЗначениеРазрешено(Магазин)";

КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

#КонецОбласти

#КонецЕсли