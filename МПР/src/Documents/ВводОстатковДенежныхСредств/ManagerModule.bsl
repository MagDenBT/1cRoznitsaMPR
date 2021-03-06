#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Инициализирует таблицы значений, содержащие данные документа.
// Таблицы значений сохраняет в свойствах структуры "ДополнительныеСвойства".
//
// Параметры:
//  ДокументСсылка - ДокументСсылка.ВводОстатковДенежныхСредств - документ начальных остатков.
//  ДополнительныеСвойства - Структура - дополнительные свойства выполнения операции.
//
Процедура ИнициализироватьДанныеДокумента(ДокументСсылка, ДополнительныеСвойства) Экспорт
	
	Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	ТаблицаДенежныхСредств.БанковскийСчетКасса КАК Касса,
		|	ТаблицаДенежныхСредств.БанковскийСчетКасса.Владелец КАК Организация,
		|	ТаблицаДенежныхСредств.БанковскийСчетКасса.Магазин КАК Магазин,
		|	ТаблицаДенежныхСредств.ДоговорКонтрагента КАК ДоговорКонтрагента,
		|	ТаблицаДенежныхСредств.Сумма КАК Сумма,
		|	ТаблицаДенежныхСредств.Дата КАК Период
		|ИЗ
		|	Документ.ВводОстатковДенежныхСредств КАК ТаблицаДенежныхСредств
		|ГДЕ
		|	ТаблицаДенежныхСредств.Ссылка = &Ссылка
		|	И НЕ ТаблицаДенежныхСредств.БанковскийСчетКасса.КассаУправляющейСистемы
		|	И ТаблицаДенежныхСредств.БанковскийСчетКасса ССЫЛКА Справочник.Кассы
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ТаблицаДенежныхСредств.БанковскийСчетКасса КАК БанковскийСчет,
		|	ТаблицаДенежныхСредств.БанковскийСчетКасса.Владелец КАК Организация,
		|	ТаблицаДенежныхСредств.Сумма КАК Сумма,
		|	ТаблицаДенежныхСредств.Дата КАК Период
		|ИЗ
		|	Документ.ВводОстатковДенежныхСредств КАК ТаблицаДенежныхСредств
		|ГДЕ
		|	&УчетБезналичныхДС
		|	И &ДатаНачалаУчетаБезналичныхДС <= ТаблицаДенежныхСредств.Дата
		|	И ТаблицаДенежныхСредств.Ссылка = &Ссылка
		|	И ТаблицаДенежныхСредств.БанковскийСчетКасса ССЫЛКА Справочник.БанковскиеСчета");
	
	Запрос.УстановитьПараметр("Ссылка", ДокументСсылка);
	Запрос.УстановитьПараметр("УчетБезналичныхДС", ПолучитьФункциональнуюОпцию("ВестиУчетБезналичныхДенежныхСредств"));
	Запрос.УстановитьПараметр("ДатаНачалаУчетаБезналичныхДС", Константы.ДатаНачалаУчетаБезналичныхДенежныхСредств.Получить());
	
	Результат = Запрос.ВыполнитьПакет();
	
	ДополнительныеСвойства.ТаблицыДляДвижений.Вставить("ТаблицаДенежныеСредстваНаличные", Результат[0].Выгрузить());
	ДополнительныеСвойства.ТаблицыДляДвижений.Вставить("ТаблицаДенежныеСредстваБезналичные", Результат[1].Выгрузить());
	
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
	"ПрисоединитьДополнительныеТаблицы
	|ЭтотСписок КАК ЭтотСписок
	|
	|ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Кассы КАК Кассы 
	|	ПО Кассы.Ссылка = ЭтотСписок.БанковскийСчетКасса
	|
	|ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Магазины КАК Магазины
	|	ПО Магазины.Ссылка = Кассы.Магазин
	|;
	|РазрешитьЧтениеИзменение
	|ГДЕ
	|	ЗначениеРазрешено(Магазины.Ссылка) ИЛИ ТипЗначения(БанковскийСчетКасса) = Тип(Справочник.БанковскиеСчета)";

КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

#КонецОбласти

#Область ОбновлениеИнформационнойБазы

Процедура ПерезаполнитьБанковскийСчетОрганизации(Параметры) Экспорт
	
	МетаданныеДокумента = Метаданные.Документы.ВводОстатковДенежныхСредств;
	ПолноеИмяОбъекта = МетаданныеДокумента.ПолноеИмя();
	
	#Если НЕ ТолстыйКлиентУправляемоеПриложение Тогда
		
		Выборка = ОбновлениеИнформационнойБазы.ВыбратьСсылкиДляОбработки(Параметры.Очередь, ПолноеИмяОбъекта);
		МодульОбновлениеИнформационнойБазыРТ = ОбщегоНазначения.ОбщийМодуль("ОбновлениеИнформационнойБазыРТ");
		МодульОбновлениеИнформационнойБазыРТ.ЗаполнитьБанковскийСчетОрганизацииОбъектов(ПолноеИмяОбъекта, "БанковскийСчетКасса", Выборка, Параметры);
		
	#КонецЕсли
	
КонецПроцедуры

Процедура ЗарегистрироватьДанныеКЗаполнениюБСО(Параметры) Экспорт
	
	МетаданныеДокумента = Метаданные.Документы.ВводОстатковДенежныхСредств;
	ПолноеИмяОбъекта = МетаданныеДокумента.ПолноеИмя();
	
	#Если НЕ ТолстыйКлиентУправляемоеПриложение Тогда
		
		МодульОбновлениеИнформационнойБазыРТ = ОбщегоНазначения.ОбщийМодуль("ОбновлениеИнформационнойБазыРТ");
		ДокументыДляОбработки = МодульОбновлениеИнформационнойБазыРТ.ОбъектыДляЗаполненияБанковскогоСчетаОрганизации(ПолноеИмяОбъекта, "БанковскийСчетКасса");
		ОбновлениеИнформационнойБазы.ОтметитьКОбработке(Параметры, ДокументыДляОбработки);
		
	#КонецЕсли
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли

