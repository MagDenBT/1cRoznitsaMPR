#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати.
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
	// ИНВ-22 (Приказ о проведении инвентаризации).
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Идентификатор = "ИНВ22";
	КомандаПечати.Представление = НСтр("ru = 'ИНВ-22 (Приказ о проведении инвентаризации)'");
	КомандаПечати.ПроверкаПроведенияПередПечатью = Истина;
	КомандаПечати.Порядок = 55;
	
	// ИНВ-3 (Инвентаризационная опись товаров).
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Идентификатор = "ИНВ3";
	КомандаПечати.Представление = НСтр("ru = 'ИНВ-3 (Инвентаризационная опись товаров)'");
	КомандаПечати.ПроверкаПроведенияПередПечатью = Истина;
	КомандаПечати.ДополнительныеПараметры.Вставить("Пустографка", Ложь);
	КомандаПечати.Порядок = 60;
	
	// ИНВ-19 (Сличительная ведомость).
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Идентификатор = "ИНВ19";
	КомандаПечати.Представление = НСтр("ru = 'ИНВ-19 (Сличительная ведомость)'");
	КомандаПечати.ПроверкаПроведенияПередПечатью = Истина;
	КомандаПечати.Порядок = 65;
	
КонецПроцедуры

// Возвращает строковое описание правил отбора товаров, параметров и отбора СКД.
//
// Параметры: 
//  ДокументСсылка - Документ.ПриказНаПроведениеИнвентаризацииТоваров - документ по которому возвращаемся описание.
//
// Возвращаемое значение:
//  Строка
//
Функция ОписаниеПравилОтбораТоваров(ДокументСсылка) Экспорт
	
	ОписаниеПравил = "";
	
	ПравилаОтбораТоваровИнвентаризации = ДокументСсылка.ПравилаОтбораТоваровИнвентаризации;
	
	Если НЕ ЗначениеЗаполнено(ПравилаОтбораТоваровИнвентаризации) Тогда
		Возврат НСтр("ru = '<Произвольный список товаров>'");
	ИначеЕсли ПравилаОтбораТоваровИнвентаризации = Справочники.ПравилаОтбораТоваров.ПолнаяИнвентаризация Тогда
		СхемаИНастройки = Справочники.ПравилаОтбораТоваров.ОписаниеИСхемаКомпоновкиДанныхПоИмениМакета(ПравилаОтбораТоваровИнвентаризации, "ПолнаяИнвентаризация");
	ИначеЕсли ПравилаОтбораТоваровИнвентаризации = Справочники.ПравилаОтбораТоваров.ИнвентаризацияЗапрещенныхКПродаже Тогда
		СхемаИНастройки = Справочники.ПравилаОтбораТоваров.ОписаниеИСхемаКомпоновкиДанныхПоИмениМакета(ПравилаОтбораТоваровИнвентаризации, "ИнвентаризацияЗапрещенныхКПродаже");
	ИначеЕсли ПравилаОтбораТоваровИнвентаризации = Справочники.ПравилаОтбораТоваров.ИнвентаризацияАлкогольнойПродукции Тогда
		СхемаИНастройки = Справочники.ПравилаОтбораТоваров.ОписаниеИСхемаКомпоновкиДанныхПоИмениМакета(ПравилаОтбораТоваровИнвентаризации, "ИнвентаризацияАлкогольнойПродукции");
	Иначе
		СхемаИНастройки = Справочники.ПравилаОтбораТоваров.ОписаниеИСхемаКомпоновкиДанныхПоИмениМакета(ПравилаОтбораТоваровИнвентаризации, ПравилаОтбораТоваровИнвентаризации.СхемаКомпоновкиДанных);
	КонецЕсли;
	
	СхемаКомпоновкиДанных = СхемаИНастройки.СхемаКомпоновкиДанных;
	
	ОписаниеСхемыКомпоновки = СхемаИНастройки.Описание;
	
	НастройкиКомпоновкиДанных = ДокументСсылка.НастройкиКомпоновкиДанных.Получить();
	
	Если НЕ ЗначениеЗаполнено(НастройкиКомпоновкиДанных) Тогда
		Если Не ЗначениеЗаполнено(СхемаИНастройки.НастройкиКомпоновкиДанных) Тогда
			КомпоновщикНастроек = Новый КомпоновщикНастроекКомпоновкиДанных;
			УстановитьПривилегированныйРежим(Истина);
			КомпоновщикНастроек.Инициализировать(Новый ИсточникДоступныхНастроекКомпоновкиДанных(СхемаКомпоновкиДанных));
			УстановитьПривилегированныйРежим(Ложь);
			КомпоновщикНастроек.ЗагрузитьНастройки(СхемаКомпоновкиДанных.НастройкиПоУмолчанию);
			
			НастройкиКомпоновкиДанных = КомпоновщикНастроек.ПолучитьНастройки();
		Иначе
			НастройкиКомпоновкиДанных = СхемаИНастройки.НастройкиКомпоновкиДанных;
		КонецЕсли;
	КонецЕсли;
	
	ОписаниеПравил = ПравилаОтбораТоваровИнвентаризации.Наименование;
	ОписаниеПравил = ОписаниеПравил + ?(ЗначениеЗаполнено(ПравилаОтбораТоваровИнвентаризации.СхемаКомпоновкиДанных), " (" + ОписаниеСхемыКомпоновки + ")", "");
	ОписаниеПараметровНастройки = КомпоновкаДанныхСервер.ОписаниеПараметровНастройки(СхемаКомпоновкиДанных, НастройкиКомпоновкиДанных);
	ОписаниеПравил = ОписаниеПравил + ?(ЗначениеЗаполнено(ОписаниеПараметровНастройки)," " + ОписаниеПараметровНастройки,"");
	
	Возврат ОписаниеПравил;
	
КонецФункции // ОписаниеПравилОтбораТоваров()

// Инициализирует таблицы значений, содержащие данные документа.
// Таблицы значений сохраняет в свойствах структуры "ДополнительныеСвойства".
//
// Параметры:
//  ДокументСсылка - ДокументСсылка.АктОРасхожденияхПриПриемкеТоваров - документ для инициализации данных.
//  ДополнительныеСвойства - Структура - структура дополнительных свойств.
//
Процедура ИнициализироватьДанныеДокумента(ДокументСсылка, ДополнительныеСвойства) Экспорт

КонецПроцедуры

// Сформировать печатные формы объектов.
//
// Параметры:
//  МассивОбъектов - Массив - список объектов, для которых была выполнена процедура Печать;
//  ПараметрыПечати - Структура - произвольные параметры, переданные при вызове команды печати;
//  КоллекцияПечатныхФорм - ТаблицаЗначений - содержит сформированные табличные документы и дополнительную информацию;
//  ОбъектыПечати - СписокЗначений - соответствие между объектами и именами областей в табличных документах, где
//                                   значение - Объект, представление - имя области с объектом в табличных документах;
//  ПараметрыВывода - Структура - параметры, связанные с выводом табличных документов:
//   * ПараметрыОтправки - Структура - для заполнения письма при отправке печатной формы по электронной почте.
//                    см. РаботаСПочтовымиСообщениямиКлиент.РаботаСПочтовымиСообщениямиКлиент.ПараметрыОтправкиПисьма.
//
Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт
	
	
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "ИНВ3") Тогда
		
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(КоллекцияПечатныхФорм,"ИНВ3",
			НСтр("ru = 'ИНВ-3 (Инвентаризационная опись товаров'") + ?(ПараметрыПечати["Пустографка"], " " + НСтр("ru = 'пустая'"), "") + ")",
			ПечатьИНВ3(МассивОбъектов, ОбъектыПечати, ПараметрыПечати["Пустографка"]));
		
	КонецЕсли;
	
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "ИНВ19") Тогда
		
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(КоллекцияПечатныхФорм,"ИНВ19",
			НСтр("ru = 'ИНВ-19 (Сличительная ведомость)'"),
			ПечатьИНВ19(МассивОбъектов, ОбъектыПечати));
		
	КонецЕсли;
		
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "ИНВ22") Тогда
		
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(КоллекцияПечатныхФорм,"ИНВ22",
			НСтр("ru = 'ИНВ-22 (Приказ о проведении инвентаризации)'"),
			ПечатьИНВ22(МассивОбъектов, ОбъектыПечати));
		
		КонецЕсли;
		
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

// Определяет список команд отчетов.
//
// Параметры:
//   КомандыОтчетов - ТаблицаЗначений - Таблица с командами отчетов. Для изменения.
//       См. описание 1 параметра процедуры ВариантыОтчетовПереопределяемый.ПередДобавлениемКомандОтчетов().
//   Параметры - Структура - Вспомогательные параметры. Для чтения.
//       См. описание 2 параметра процедуры ВариантыОтчетовПереопределяемый.ПередДобавлениемКомандОтчетов().
//
Процедура ДобавитьКомандыОтчетов(КомандыОтчетов, Параметры) Экспорт
	
	КомандаОтчет = Отчеты.ОформлениеИзлишковНедостачТоваров.ДобавитьКомандуОтчета(КомандыОтчетов);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

///////////////////////////////////////////////////////////////////////////////
// Печать

// Сформировать печатные формы объектов.
//
// ВХОДЯЩИЕ:
//   ИменаМакетов    - Строка    - Имена макетов, перечисленные через запятую.
//   МассивОбъектов  - Массив    - Массив ссылок на объекты которые нужно распечатать.
//   ПараметрыПечати - Структура - Структура дополнительных параметров печати.
//
// ИСХОДЯЩИЕ:
//   КоллекцияПечатныхФорм - Таблица значений - Сформированные табличные документы.
//   ПараметрыВывода       - Структура        - Параметры сформированных табличных документов.
//
Функция ПечатьИНВ3(МассивОбъектов, ОбъектыПечати, Пустографка = Ложь)
	
	КолонкаКодов = ФормированиеПечатныхФормСервер.ИмяДополнительнойКолонки();
	
	Если ПустаяСтрока(КолонкаКодов) Тогда
		
		КолонкаКодов = "Код";
		
	КонецЕсли;
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	Документ.Ссылка                                       КАК Ссылка,
	|	Документ.Номер                                        КАК Номер,
	|	Документ.Дата                                         КАК Дата,
	|	Документ.Дата                                         КАК ДатаДокумента,
	|	Документ.Дата                                         КАК ДатаСнятияОстатков,
	|	Документ.ДатаНачала                                   КАК ДатаНачала,
	|	Документ.ДатаОкончания                                КАК ДатаОкончания,
	|	Документ.Организация                                  КАК Организация,
	|	Документ.Организация.Префикс                          КАК Префикс,
	|	ПРЕДСТАВЛЕНИЕ(Документ.Магазин)                       КАК Подразделение,
	|	ПРЕДСТАВЛЕНИЕ(Документ.Склад)                         КАК СкладПредставление,
	|	ПРЕДСТАВЛЕНИЕ(Документ.Организация)                   КАК ОрганизацияПредставление
	|ИЗ
	|	Документ.ПриказНаПроведениеИнвентаризацииТоваров КАК Документ
	|
	|ГДЕ
	|	Документ.Ссылка В (&МассивДокументов)
	|	И Документ.Проведен
	|
	|УПОРЯДОЧИТЬ ПО
	|	Ссылка
	|;
	|
	|
	|ВЫБРАТЬ
	|	ВложенныйЗапрос.Ссылка                                                     КАК Ссылка,
	|	ВложенныйЗапрос.Номенклатура                                               КАК Номенклатура,
	|	ПРЕДСТАВЛЕНИЕ(ВложенныйЗапрос.Номенклатура)                                КАК НоменклатураПредставление,
	|	ПРЕДСТАВЛЕНИЕ(ВложенныйЗапрос.Характеристика)                              КАК ХарактеристикаПредставление,
	|	ВложенныйЗапрос.Номенклатура.НаименованиеПолное                            КАК ТоварНаименование,
	|	ВложенныйЗапрос.Номенклатура." + КолонкаКодов + "                          КАК ТоварКод,
	|	ВложенныйЗапрос.ЕдиницаИзмерения.Представление                             КАК ЕдиницаИзмеренияПредставление,
	|	ВложенныйЗапрос.ЕдиницаИзмерения.Код                                       КАК ЕдиницаИзмеренияКодПоОКЕИ,
	|	ВЫБОР
	|			КОГДА &БезФактическихДанных ТОГДА 0
	|			ИНАЧЕ ВложенныйЗапрос.Количество
	|	КОНЕЦ                                                                      КАК Количество,
	|	ВЫБОР
	|			КОГДА &БезФактическихДанных ТОГДА 0
	|			ИНАЧЕ ВложенныйЗапрос.Сумма
	|	КОНЕЦ                                                                      КАК Сумма,
	|	ВложенныйЗапрос.КоличествоУчет                                             КАК КоличествоУчет,
	|	ВложенныйЗапрос.Характеристика                                             КАК Характеристика,
	|	ВложенныйЗапрос.Цена                                                       КАК Цена,
	|	ВложенныйЗапрос.СуммаУчет                                                  КАК СуммаУчет,
	|	ВложенныйЗапрос.НомерСтроки                                                КАК НомерСтроки
	|ИЗ (
	|	ВЫБРАТЬ
	|		Документ.Ссылка.ДокументОснование                                      КАК Ссылка,
	|		Документ.Номенклатура                                                  КАК Номенклатура,
	|		ВЫБОР КОГДА Документ.Упаковка = ЗНАЧЕНИЕ(Справочник.УпаковкиНоменклатуры.ПустаяСсылка) ТОГДА
	|			Документ.Номенклатура.ЕдиницаИзмерения
	|		ИНАЧЕ
	|			Документ.Упаковка.ЕдиницаИзмерения
	|		КОНЕЦ                                                                  КАК ЕдиницаИзмерения,
	|		Документ.Характеристика                                                КАК Характеристика,
	|		ВЫБОР
	|			КОГДА
	|				Документ.КоличествоУпаковок = 0
	|			ТОГДА
	|				Документ.Цена
	|			ИНАЧЕ
	|				Документ.Сумма / Документ.КоличествоУпаковок
	|		КОНЕЦ                                                                  КАК Цена,
	|		Документ.КоличествоФакт                                                КАК Количество,
	|		Документ.Количество                                                    КАК КоличествоУчет,
	|		Документ.СуммаФакт                                                     КАК Сумма,
	|		Документ.Сумма                                                         КАК СуммаУчет,
	|		Документ.НомерСтроки                                                   КАК НомерСтроки
	|	ИЗ
	|		Документ.ПересчетТоваров.Товары КАК Документ
	|	ГДЕ
	|		Документ.Ссылка.ДокументОснование В (&МассивДокументов)
	|		И Документ.Ссылка.Проведен
	|		И Документ.Ссылка.ДокументОснование.Проведен
	|		И Документ.Номенклатура.ТипНоменклатуры <> ЗНАЧЕНИЕ(Перечисление.ТипыНоменклатуры.Услуга)
	|
	|	) КАК ВложенныйЗапрос
	|
	|УПОРЯДОЧИТЬ ПО
	|	Ссылка,
	|	НомерСтроки
	|
	|ИТОГИ ПО
	|	Ссылка
	|");
	
	Запрос.УстановитьПараметр("МассивДокументов", 		МассивОбъектов);
	Запрос.УстановитьПараметр("БезФактическихДанных", 	Пустографка);
	
	ТабличныйДокумент = Новый ТабличныйДокумент;
	ТабличныйДокумент.ИмяПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_ПересчетТоваров_ИНВ3";
	
	//ТабличныйДокумент = Новый ТабличныйДокумент;
	//
	//// Зададим параметры макета
	//ТабличныйДокумент.ОриентацияСтраницы = ОриентацияСтраницы.Ландшафт;
	
	МассивРезультатов = Запрос.ВыполнитьПакет();
	ДанныеПечати      = МассивРезультатов[0].Выбрать();
	ВыборкаПоДокументам = МассивРезультатов[1].Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	
	Макет = УправлениеПечатью.МакетПечатнойФормы("ОбщийМакет.ПФ_MXL_ИНВ3");
	
	ПервыйДокумент = Истина;
	
	Пока ДанныеПечати.Следующий() Цикл
		
		Если Не ПервыйДокумент Тогда
			ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;
		
		ПервыйДокумент = Ложь;
		НомерСтрокиНачало = ТабличныйДокумент.ВысотаТаблицы + 1;
		
		// Выводим общие реквизиты шапки.
		ОбластьМакета = Макет.ПолучитьОбласть("Шапка");
		
		СведенияОбОрганизации    = ФормированиеПечатныхФормСервер.СведенияОЮрФизЛице(ДанныеПечати.Организация,      ДанныеПечати.ДатаДокумента);
		
		ОбластьМакета.Параметры.Заполнить(ДанныеПечати);
		ОбластьМакета.Параметры.НомерДокумента           = ПрефиксацияОбъектовКлиентСервер.НомерНаПечать(ДанныеПечати.Номер, Ложь, Истина);
		ОбластьМакета.Параметры.ПредставлениеОрганизации = ФормированиеПечатныхФормСервер.ОписаниеОрганизации(СведенияОбОрганизации);
		ОбластьМакета.Параметры.ОрганизацияПоОКПО        = СведенияОбОрганизации.КодПоОКПО;
		
		ТабличныйДокумент.Вывести(ОбластьМакета);
		
		ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		
		НомерСтраницы = 2;
		
		ИтоговыеСуммы = Новый Структура;
		
		// Инициализация итогов по странице.
		
		ИтоговыеСуммы.Вставить("ИтогоКоличествоНаСтранице", 0);
		ИтоговыеСуммы.Вставить("ИтогоКоличествоУчетНаСтранице", 0);
		ИтоговыеСуммы.Вставить("ИтогоСуммаНаСтранице", 0);
		ИтоговыеСуммы.Вставить("ИтогоСуммаУчетНаСтранице", 0);
		ИтоговыеСуммы.Вставить("КоличествоПорядковыхНомеровНаСтранице",0);
		
		// Инициализация итогов по документу.
		ИтоговыеСуммы.Вставить("ИтогоКоличество", 0);
		ИтоговыеСуммы.Вставить("ИтогоКоличествоУчет", 0);
		ИтоговыеСуммы.Вставить("ИтогоСумма", 0);
		ИтоговыеСуммы.Вставить("ИтогоСуммаУчет", 0);
		ИтоговыеСуммы.Вставить("КоличествоПорядковыхНомеровЗаписейПрописью", 0);
		ИтоговыеСуммы.Вставить("СуммаПрописью", "");
		
		ДанныеСтроки = Новый Структура;
		ДанныеСтроки.Вставить("Номер", 0);
		ДанныеСтроки.Вставить("КоличествоУчет", 0);
		ДанныеСтроки.Вставить("Количество", 0);
		ДанныеСтроки.Вставить("Цена", 0);
		ДанныеСтроки.Вставить("Сумма", 0);
		ДанныеСтроки.Вставить("СуммаУчет", 0);
		
		// Создаем массив для проверки вывода.
		МассивВыводимыхОбластей = Новый Массив;
		
		// Выводим многострочную часть документа.
		ОбластьЗаголовокТаблицы = Макет.ПолучитьОбласть("ЗаголовокТаблицы");
		ОбластьМакета           = Макет.ПолучитьОбласть("Строка");
		ОбластьИтоговПоСтранице = Макет.ПолучитьОбласть("ПодвалСтраницы");
		ОбластьПодвала          = Макет.ПолучитьОбласть("ПодвалОписи");
		
		СтруктураПоиска = Новый Структура("Ссылка", ДанныеПечати.Ссылка);
		ВыборкаПоДокументам.НайтиСледующий(СтруктураПоиска);
		
		КоличествоСтрок = ВыборкаПоДокументам.Количество();
		
		СтрокаТовары = ВыборкаПоДокументам.Выбрать();
		Пока СтрокаТовары.Следующий() Цикл
			
			ДанныеСтроки.Номер = ДанныеСтроки.Номер + 1;
			
			ОбластьМакета.Параметры.Заполнить(СтрокаТовары);
			ОбластьМакета.Параметры.ТоварНаименование = ФормированиеПечатныхФормСервер.ПолучитьПредставлениеНоменклатурыДляПечати(
			СтрокаТовары.ТоварНаименование,
			СтрокаТовары.Характеристика);
			
			ДанныеСтроки.КоличествоУчет = СтрокаТовары.КоличествоУчет;
			ДанныеСтроки.Количество     = СтрокаТовары.Количество;
			ДанныеСтроки.Сумма          = СтрокаТовары.Сумма;
			ДанныеСтроки.СуммаУчет      = СтрокаТовары.СуммаУчет;
			ДанныеСтроки.Цена           = СтрокаТовары.Цена;
			
			ОбластьМакета.Параметры.Заполнить(ДанныеСтроки);
			
			Если ДанныеСтроки.Номер = 1 Тогда // первая строка
				
				ОбластьЗаголовокТаблицы.Параметры.НомерСтраницы = "Страница " + НомерСтраницы; 
				ТабличныйДокумент.Вывести(ОбластьЗаголовокТаблицы);
				
			Иначе
				
				МассивВыводимыхОбластей.Очистить();
				МассивВыводимыхОбластей.Добавить(ОбластьМакета);
				МассивВыводимыхОбластей.Добавить(ОбластьИтоговПоСтранице);
				
				Если ДанныеСтроки.Номер = КоличествоСтрок Тогда
					
					МассивВыводимыхОбластей.Добавить(ОбластьПодвала);
					
				КонецЕсли;
				
				Если ДанныеСтроки.Номер <> 1 И Не ТабличныйДокумент.ПроверитьВывод(МассивВыводимыхОбластей) Тогда
					
					ОбластьИтоговПоСтранице.Параметры.Заполнить(ИтоговыеСуммы);
					
					ОбластьИтоговПоСтранице.Параметры.КоличествоПорядковыхНомеровНаСтраницеПрописью = ЧислоПрописью(ИтоговыеСуммы.КоличествоПорядковыхНомеровНаСтранице, ,",,,,,,,,0");
					
					Если НЕ Пустографка Тогда
						
						ОбластьИтоговПоСтранице.Параметры.КоличествоНаСтраницеПрописью = ФормированиеПечатныхФормСервер.КоличествоПрописью(ИтоговыеСуммы.ИтогоКоличествоНаСтранице);
						ОбластьИтоговПоСтранице.Параметры.СуммаНаСтраницеПрописью = ФормированиеПечатныхФормСервер.СформироватьСуммуПрописью(ИтоговыеСуммы.ИтогоСуммаНаСтранице);
						
					КонецЕсли;
					
					ТабличныйДокумент.Вывести(ОбластьИтоговПоСтранице);
					
					// Очистим итоги по странице.
					ИтоговыеСуммы.ИтогоКоличествоНаСтранице             = 0;
					ИтоговыеСуммы.ИтогоКоличествоУчетНаСтранице         = 0;
					ИтоговыеСуммы.ИтогоСуммаУчетНаСтранице              = 0;
					ИтоговыеСуммы.ИтогоСуммаНаСтранице                  = 0;
					ИтоговыеСуммы.КоличествоПорядковыхНомеровНаСтранице = 0;
					
					НомерСтраницы = НомерСтраницы + 1;
					ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
					ОбластьЗаголовокТаблицы.Параметры.НомерСтраницы = "Страница " + НомерСтраницы;
					ТабличныйДокумент.Вывести(ОбластьЗаголовокТаблицы);
					
				КонецЕсли;
				
			КонецЕсли;
			
			ТабличныйДокумент.Вывести(ОбластьМакета);
			
			// Увеличим итоги по странице.
			
			ИтоговыеСуммы.ИтогоКоличествоНаСтранице      = ИтоговыеСуммы.ИтогоКоличествоНаСтранице + ДанныеСтроки.Количество;
			ИтоговыеСуммы.ИтогоКоличествоУчетНаСтранице  = ИтоговыеСуммы.ИтогоКоличествоУчетНаСтранице  + ДанныеСтроки.КоличествоУчет;
			ИтоговыеСуммы.ИтогоСуммаНаСтранице           = ИтоговыеСуммы.ИтогоСуммаНаСтранице  + ДанныеСтроки.Сумма;
			ИтоговыеСуммы.ИтогоСуммаУчетНаСтранице       = ИтоговыеСуммы.ИтогоСуммаУчетНаСтранице  + ДанныеСтроки.СуммаУчет;
			ИтоговыеСуммы.КоличествоПорядковыхНомеровНаСтранице = ИтоговыеСуммы.КоличествоПорядковыхНомеровНаСтранице + 1;
			
			// Увеличим итоги по документу.
			
			ИтоговыеСуммы.ИтогоКоличество      = ИтоговыеСуммы.ИтогоКоличество  + ДанныеСтроки.Количество;
			ИтоговыеСуммы.ИтогоКоличествоУчет  = ИтоговыеСуммы.ИтогоКоличествоУчет  + ДанныеСтроки.КоличествоУчет;
			ИтоговыеСуммы.ИтогоСумма           = ИтоговыеСуммы.ИтогоСумма + ДанныеСтроки.Сумма;
			ИтоговыеСуммы.ИтогоСуммаУчет       = ИтоговыеСуммы.ИтогоСуммаУчет + ДанныеСтроки.СуммаУчет;
			ИтоговыеСуммы.КоличествоПорядковыхНомеровЗаписейПрописью = ИтоговыеСуммы.КоличествоПорядковыхНомеровЗаписейПрописью  + 1;
			
		КонецЦикла;
		
		// Выводим итоги по последней странице.
		ОбластьИтоговПоСтранице.Параметры.Заполнить(ИтоговыеСуммы);
		
		ОбластьИтоговПоСтранице.Параметры.КоличествоПорядковыхНомеровНаСтраницеПрописью = ЧислоПрописью(ИтоговыеСуммы.КоличествоПорядковыхНомеровНаСтранице, ,",,,,,,,,0");
		
		Если НЕ Пустографка Тогда
			
			ОбластьИтоговПоСтранице.Параметры.КоличествоНаСтраницеПрописью = ФормированиеПечатныхФормСервер.КоличествоПрописью(ИтоговыеСуммы.ИтогоКоличествоНаСтранице);
			ОбластьИтоговПоСтранице.Параметры.СуммаНаСтраницеПрописью = ФормированиеПечатныхФормСервер.СформироватьСуммуПрописью(ИтоговыеСуммы.ИтогоСуммаНаСтранице);
			
		КонецЕсли;
		
		ТабличныйДокумент.Вывести(ОбластьИтоговПоСтранице);
		
		ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		
		НомерСтраницы = НомерСтраницы + 1;
		
		// Выводим подвал документа
		ОбластьПодвала.Параметры.Заполнить(ДанныеПечати);
		ОбластьПодвала.Параметры.НомерСтраницы = "Страница " + НомерСтраницы;
		ОбластьПодвала.Параметры.КоличествоПорядковыхНомеровЗаписейПрописью =  ЧислоПрописью(ИтоговыеСуммы.КоличествоПорядковыхНомеровЗаписейПрописью, ,",,,,,,,,0");
		
		Если НЕ Пустографка Тогда
			
			ОбластьПодвала.Параметры.ИтогоКоличествоПрописью = ФормированиеПечатныхФормСервер.КоличествоПрописью(ИтоговыеСуммы.ИтогоКоличество);
			ОбластьПодвала.Параметры.ИтогоСуммаПрописью = ЧислоПрописью(Цел(ИтоговыеСуммы.ИтогоСумма),,",,,,,,,,0");
			ОбластьПодвала.Параметры.ИтогоСуммаКопейки  = (ИтоговыеСуммы.ИтогоСумма - Цел(ИтоговыеСуммы.ИтогоСумма))*100;
			
		КонецЕсли;
		
		ТабличныйДокумент.Вывести(ОбластьПодвала);
		
		УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТабличныйДокумент, НомерСтрокиНачало, ОбъектыПечати, ДанныеПечати.Ссылка);
		
	КонецЦикла;
	
	Возврат ТабличныйДокумент;
	
	
КонецФункции

Функция ПечатьИНВ19(МассивОбъектов, ОбъектыПечати)
	
	КолонкаКодов = ФормированиеПечатныхФормСервер.ИмяДополнительнойКолонки();
	
	Если ПустаяСтрока(КолонкаКодов) Тогда
		
		КолонкаКодов = "Код";
		
	КонецЕсли;
	
	Запрос = Новый Запрос("ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	Документ.Ссылка                                       КАК Ссылка,
	|	Документ.Номер                                        КАК Номер,
	|	Документ.Дата                                         КАК Дата,
	|	Документ.Дата                                         КАК ДатаДокумента,
	|	Документ.Дата                                         КАК ДатаНачалаИнвентаризации,
	|	Документ.Организация                                  КАК Организация,
	|	Документ.Организация                                  КАК Руководители,
	|	Документ.Организация.Префикс                          КАК Префикс,
	|	ПРЕДСТАВЛЕНИЕ(Документ.Магазин)                       КАК ПредставлениеПодразделения,
	|	ПРЕДСТАВЛЕНИЕ(Документ.Склад)                         КАК СкладПредставление,
	|	ПРЕДСТАВЛЕНИЕ(Документ.Организация)                   КАК ОрганизацияПредставление
	|ИЗ
	|	Документ.ПриказНаПроведениеИнвентаризацииТоваров КАК Документ
	|
	|ГДЕ
	|	Документ.Ссылка В (&МассивДокументов)
	|	И Документ.Проведен
	|
	|УПОРЯДОЧИТЬ ПО
	|	Ссылка
	|;
	|
	|
	|ВЫБРАТЬ
	|	ВложенныйЗапрос.Ссылка                                                     КАК Ссылка,
	|	ВложенныйЗапрос.Номенклатура                                               КАК Номенклатура,
	|	ПРЕДСТАВЛЕНИЕ(ВложенныйЗапрос.Номенклатура)                                КАК НоменклатураПредставление,
	|	ПРЕДСТАВЛЕНИЕ(ВложенныйЗапрос.Характеристика)                              КАК ХарактеристикаПредставление,
	|	ВложенныйЗапрос.Номенклатура.НаименованиеПолное                            КАК ТоварНаименование,
	|	ВложенныйЗапрос.Номенклатура." + КолонкаКодов + "                          КАК ТоварКод,
	|	ВложенныйЗапрос.ЕдиницаИзмерения.Представление                             КАК ЕдиницаИзмеренияПредставление,
	|	ВложенныйЗапрос.ЕдиницаИзмерения.Код                                       КАК ЕдиницаИзмеренияКодПоОКЕИ,
	|	ВложенныйЗапрос.Характеристика                                             КАК Характеристика,
	|	ВложенныйЗапрос.РезультатНедостачаКолво                                    КАК РезультатНедостачаКолво,
	|	ВложенныйЗапрос.РезультатНедостачаСумма                                    КАК РезультатНедостачаСумма,
	|	ВложенныйЗапрос.РезультатИзлишекКолво                                      КАК РезультатИзлишекКолво,
	|	ВложенныйЗапрос.РезультатИзлишекСумма                                      КАК РезультатИзлишекСумма,
	|	ВложенныйЗапрос.НомерСтроки                                                КАК НомерСтроки
	|ИЗ (
	|	ВЫБРАТЬ
	|		Документ.Ссылка.ДокументОснование                                      КАК Ссылка,
	|		Документ.Номенклатура                                                  КАК Номенклатура,
	|		ВЫБОР КОГДА Документ.Упаковка = ЗНАЧЕНИЕ(Справочник.УпаковкиНоменклатуры.ПустаяСсылка) ТОГДА
	|			Документ.Номенклатура.ЕдиницаИзмерения
	|		ИНАЧЕ
	|			Документ.Упаковка.ЕдиницаИзмерения
	|		КОНЕЦ                                                                  КАК ЕдиницаИзмерения,
	|		Документ.Характеристика                                                КАК Характеристика,
	|		Документ.НомерСтроки                                                   КАК НомерСтроки,
	|       ВЫБОР 
	|           КОГДА 
	|               (Документ.КоличествоФакт - Документ.Количество) < 0 
	|             И (Документ.СуммаФакт - Документ.Сумма) < 0 
	|           ТОГДА
	|             -(Документ.КоличествоФакт - Документ.Количество)
	|           КОГДА 
	|               (Документ.КоличествоФакт - Документ.Количество) < 0 
	|             И (Документ.СуммаФакт - Документ.Сумма) >= 0 
	|           ТОГДА
	|             -(Документ.КоличествоФакт - Документ.Количество)
	|           ИНАЧЕ
	|             0
	|       КОНЕЦ КАК РезультатНедостачаКолво,
	|       ВЫБОР 
	|           КОГДА 
	|               (Документ.КоличествоФакт - Документ.Количество) < 0 
	|             И (Документ.СуммаФакт - Документ.Сумма) < 0 
	|           ТОГДА
	|             -(Документ.СуммаФакт - Документ.Сумма)
	|           КОГДА 
	|               (Документ.КоличествоФакт - Документ.Количество) < 0 
	|             И (Документ.СуммаФакт - Документ.Сумма) >= 0 
	|           ТОГДА
	|             (Документ.СуммаФакт - Документ.Сумма)
	|           ИНАЧЕ
	|             0
	|       КОНЕЦ КАК РезультатНедостачаСумма,
	|       ВЫБОР 
	|           КОГДА 
	|               (Документ.КоличествоФакт - Документ.Количество) < 0 
	|             И (Документ.СуммаФакт - Документ.Сумма) < 0 
	|           ТОГДА
	|             0
	|           КОГДА 
	|               (Документ.КоличествоФакт - Документ.Количество) < 0 
	|             И (Документ.СуммаФакт - Документ.Сумма) >= 0 
	|           ТОГДА
	|             0
	|           ИНАЧЕ
	|             (Документ.КоличествоФакт - Документ.Количество)
	|       КОНЕЦ КАК РезультатИзлишекКолво,
	|       ВЫБОР 
	|           КОГДА 
	|               (Документ.КоличествоФакт - Документ.Количество) < 0 
	|             И (Документ.СуммаФакт - Документ.Сумма) < 0 
	|           ТОГДА
	|             0
	|           КОГДА 
	|               (Документ.КоличествоФакт - Документ.Количество) < 0 
	|             И (Документ.СуммаФакт - Документ.Сумма) >= 0 
	|           ТОГДА
	|             0
	|           ИНАЧЕ
	|             (Документ.СуммаФакт - Документ.Сумма)
	|       КОНЕЦ КАК РезультатИзлишекСумма
	|	ИЗ
	|		Документ.ПересчетТоваров.Товары КАК Документ
	|	ГДЕ
	|		Документ.Ссылка.ДокументОснование В (&МассивДокументов)
	|		И Документ.Ссылка.Проведен
	|		И Документ.Ссылка.ДокументОснование.Проведен
	|		И Документ.Номенклатура.ТипНоменклатуры <> ЗНАЧЕНИЕ(Перечисление.ТипыНоменклатуры.Услуга)
	|		И Документ.КоличествоФакт-Документ.Количество <> 0
	|	) КАК ВложенныйЗапрос
	|
	|УПОРЯДОЧИТЬ ПО
	|	Ссылка,
	|	НомерСтроки
	|
	|ИТОГИ ПО
	|	Ссылка
	|");
	
	Запрос.УстановитьПараметр("МассивДокументов", МассивОбъектов);
	
	ТабличныйДокумент = Новый ТабличныйДокумент;
	ТабличныйДокумент.ИмяПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_ПересчетТоваров_ИНВ19";
	
	МассивРезультатов = Запрос.ВыполнитьПакет();
	ДанныеПечати      = МассивРезультатов[0].Выбрать();
	ВыборкаПоДокументам = МассивРезультатов[1].Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	
	Макет = УправлениеПечатью.МакетПечатнойФормы("ОбщийМакет.ПФ_MXL_ИНВ19");
	
	ПервыйДокумент = Истина;
	
	Пока ДанныеПечати.Следующий() Цикл
		
		Если Не ПервыйДокумент Тогда
			
			ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
			
		КонецЕсли;
		
		ПервыйДокумент = Ложь;
		НомерСтрокиНачало = ТабличныйДокумент.ВысотаТаблицы + 1;
		
		// Выводим общие реквизиты шапки.
		ОбластьМакета = Макет.ПолучитьОбласть("Шапка");
		
		СведенияОбОрганизации    = ФормированиеПечатныхФормСервер.СведенияОЮрФизЛице(ДанныеПечати.Организация,      ДанныеПечати.ДатаДокумента);
		
		ОбластьМакета.Параметры.Заполнить(ДанныеПечати);
		ОбластьМакета.Параметры.НомерДокумента           = ПрефиксацияОбъектовКлиентСервер.НомерНаПечать(ДанныеПечати.Номер, Ложь, Истина);
		ОбластьМакета.Параметры.ПредставлениеОрганизации = ФормированиеПечатныхФормСервер.ОписаниеОрганизации(СведенияОбОрганизации);
		ОбластьМакета.Параметры.ОрганизацияПоОКПО        = СведенияОбОрганизации.КодПоОКПО;
		
		ТабличныйДокумент.Вывести(ОбластьМакета);
		
		ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		
		НомерСтраницы = 2;
		
		ИтоговыеСуммы = Новый Структура;
		
		// Инициализация итогов по странице.
		
		ИтоговыеСуммы.Вставить("ИтогоРезультатНедостачаКолвоНаСтранице", 0);
		ИтоговыеСуммы.Вставить("ИтогоРезультатНедостачаСуммаНаСтранице", 0);
		ИтоговыеСуммы.Вставить("ИтогоРезультатИзлишекКолвоНаСтранице", 0);
		ИтоговыеСуммы.Вставить("ИтогоРезультатИзлишекСуммаНаСтранице", 0);
		
		// Инициализация итогов по документу.
		ИтоговыеСуммы.Вставить("ИтогоРезультатНедостачаКолво", 0);
		ИтоговыеСуммы.Вставить("ИтогоРезультатНедостачаСумма", 0);
		ИтоговыеСуммы.Вставить("ИтогоРезультатИзлишекКолво", 0);
		ИтоговыеСуммы.Вставить("ИтогоРезультатИзлишекСумма", 0);
		
		ДанныеСтроки = Новый Структура;
		ДанныеСтроки.Вставить("Номер", 0);
		ДанныеСтроки.Вставить("РезультатНедостачаКолво", 0);
		ДанныеСтроки.Вставить("РезультатНедостачаСумма", 0);
		ДанныеСтроки.Вставить("РезультатИзлишекКолво", 0);
		ДанныеСтроки.Вставить("РезультатИзлишекСумма", 0);
		
		
		// Создаем массив для проверки вывода.
		МассивВыводимыхОбластей = Новый Массив;
		
		// Выводим многострочную часть документа.
		ОбластьЗаголовокТаблицы = Макет.ПолучитьОбласть("ЗаголовокТаблицы");
		ОбластьМакета           = Макет.ПолучитьОбласть("СтрокаТаблицы");
		ОбластьИтоговПоСтранице = Макет.ПолучитьОбласть("ИтогоПоСтранице");
		ОбластьВсего            = Макет.ПолучитьОбласть("Всего");
		ОбластьПодвала          = Макет.ПолучитьОбласть("Подвал");
		
		СтруктураПоиска = Новый Структура("Ссылка", ДанныеПечати.Ссылка);
		ВыборкаПоДокументам.НайтиСледующий(СтруктураПоиска);
		
		КоличествоСтрок = ВыборкаПоДокументам.Количество();
		
		СтрокаТовары = ВыборкаПоДокументам.Выбрать();
		Пока СтрокаТовары.Следующий() Цикл
			
			ДанныеСтроки.Номер = ДанныеСтроки.Номер + 1;
			
			ОбластьМакета.Параметры.Заполнить(СтрокаТовары);
			ОбластьМакета.Параметры.ТоварНаименование = ФормированиеПечатныхФормСервер.ПолучитьПредставлениеНоменклатурыДляПечати(
			СтрокаТовары.ТоварНаименование,
			СтрокаТовары.Характеристика);
			
			ДанныеСтроки.РезультатНедостачаКолво = СтрокаТовары.РезультатНедостачаКолво;
			ДанныеСтроки.РезультатНедостачаСумма = СтрокаТовары.РезультатНедостачаСумма;
			ДанныеСтроки.РезультатИзлишекКолво   = СтрокаТовары.РезультатИзлишекКолво;
			ДанныеСтроки.РезультатИзлишекСумма   = СтрокаТовары.РезультатИзлишекСумма;
			
			ОбластьМакета.Параметры.Заполнить(ДанныеСтроки);
			
			Если ДанныеСтроки.Номер = 1 Тогда // первая строка
				
				ОбластьЗаголовокТаблицы.Параметры.НомерСтраницы = "Страница " + НомерСтраницы; 
				ТабличныйДокумент.Вывести(ОбластьЗаголовокТаблицы);
				
			Иначе
				
				МассивВыводимыхОбластей.Очистить();
				МассивВыводимыхОбластей.Добавить(ОбластьМакета);
				МассивВыводимыхОбластей.Добавить(ОбластьИтоговПоСтранице);
				
				Если ДанныеСтроки.Номер = КоличествоСтрок Тогда
					
					МассивВыводимыхОбластей.Добавить(ОбластьВсего);
					МассивВыводимыхОбластей.Добавить(ОбластьПодвала);
					
				КонецЕсли;
				
				Если ДанныеСтроки.Номер <> 1 И Не ТабличныйДокумент.ПроверитьВывод(МассивВыводимыхОбластей) Тогда
					
					ОбластьИтоговПоСтранице.Параметры.Заполнить(ИтоговыеСуммы);
					
					ТабличныйДокумент.Вывести(ОбластьИтоговПоСтранице);
					
					// Очистим итоги по странице.
					ИтоговыеСуммы.ИтогоРезультатНедостачаКолвоНаСтранице = 0;
					ИтоговыеСуммы.ИтогоРезультатНедостачаСуммаНаСтранице = 0;
					ИтоговыеСуммы.ИтогоРезультатИзлишекКолвоНаСтранице   = 0;
					ИтоговыеСуммы.ИтогоРезультатИзлишекСуммаНаСтранице   = 0;
					
					
					НомерСтраницы = НомерСтраницы + 1;
					ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
					ОбластьЗаголовокТаблицы.Параметры.НомерСтраницы = "Страница " + НомерСтраницы;
					ТабличныйДокумент.Вывести(ОбластьЗаголовокТаблицы);
					
				КонецЕсли;
				
			КонецЕсли;
			
			ТабличныйДокумент.Вывести(ОбластьМакета);
			
			// Увеличим итоги по странице.
			
			ИтоговыеСуммы.ИтогоРезультатНедостачаКолвоНаСтранице = ИтоговыеСуммы.ИтогоРезультатНедостачаКолвоНаСтранице + ДанныеСтроки.РезультатНедостачаКолво;
			ИтоговыеСуммы.ИтогоРезультатНедостачаСуммаНаСтранице = ИтоговыеСуммы.ИтогоРезультатНедостачаСуммаНаСтранице + ДанныеСтроки.РезультатНедостачаСумма;
			ИтоговыеСуммы.ИтогоРезультатИзлишекКолвоНаСтранице   = ИтоговыеСуммы.ИтогоРезультатИзлишекКолвоНаСтранице   + ДанныеСтроки.РезультатИзлишекКолво;
			ИтоговыеСуммы.ИтогоРезультатИзлишекСуммаНаСтранице   = ИтоговыеСуммы.ИтогоРезультатИзлишекСуммаНаСтранице   + ДанныеСтроки.РезультатИзлишекСумма;
			
			// Увеличим итоги по документу.
			
			ИтоговыеСуммы.ИтогоРезультатНедостачаКолво  = ИтоговыеСуммы.ИтогоРезультатНедостачаКолво + ДанныеСтроки.РезультатНедостачаКолво;
			ИтоговыеСуммы.ИтогоРезультатНедостачаСумма  = ИтоговыеСуммы.ИтогоРезультатНедостачаСумма + ДанныеСтроки.РезультатНедостачаСумма;
			ИтоговыеСуммы.ИтогоРезультатИзлишекКолво    = ИтоговыеСуммы.ИтогоРезультатИзлишекКолво   + ДанныеСтроки.РезультатИзлишекКолво;
			ИтоговыеСуммы.ИтогоРезультатИзлишекСумма    = ИтоговыеСуммы.ИтогоРезультатИзлишекСумма   + ДанныеСтроки.РезультатИзлишекСумма;
			
		КонецЦикла;
		
		Если ДанныеСтроки.Номер = 0 Тогда // шапка не выводилась
			
			ОбластьЗаголовокТаблицы.Параметры.НомерСтраницы = "Страница " + НомерСтраницы; 
			ТабличныйДокумент.Вывести(ОбластьЗаголовокТаблицы);
			
		КонецЕсли;
		
		// Выводим итоги по последней странице.
		ОбластьИтоговПоСтранице.Параметры.Заполнить(ИтоговыеСуммы);
		
		ТабличныйДокумент.Вывести(ОбластьИтоговПоСтранице);
		
		// Выводим итоги по документу в целом.
		
		ОбластьВсего.Параметры.Заполнить(ИтоговыеСуммы);
		
		ТабличныйДокумент.Вывести(ОбластьВсего);
		
		// Выводим подвал документа
		ОбластьПодвала.Параметры.Заполнить(ДанныеПечати);
		
		Руководители = ФормированиеПечатныхФормСервер.ОтветственныеЛицаОрганизаций(ДанныеПечати.Руководители, ДанныеПечати.Дата);
		ОбластьПодвала.Параметры.ФИОБухгалтера       = ФормированиеПечатныхФормСервер.ФамилияИнициалыФизЛица(Руководители.ГлавныйБухгалтер);
		
		ТабличныйДокумент.Вывести(ОбластьПодвала);
		
		УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТабличныйДокумент, НомерСтрокиНачало, ОбъектыПечати, ДанныеПечати.Ссылка);
		
	КонецЦикла;
	
	Возврат ТабличныйДокумент;
	
КонецФункции

Функция ПечатьИНВ22(МассивОбъектов, ОбъектыПечати)
	
	ТабличныйДокумент = Новый ТабличныйДокумент();
	ТабличныйДокумент.ИмяПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_ПриказОПроведенииИнвентаризации_ПФ_MXL_ИНВ22";
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ПриказНаПроведениеИнвентаризацииТоваров.Ссылка КАК Ссылка,
	|	ПриказНаПроведениеИнвентаризацииТоваров.Номер КАК Номер,
	|	ПриказНаПроведениеИнвентаризацииТоваров.Дата КАК ДатаДокумента,
	|	ПриказНаПроведениеИнвентаризацииТоваров.ДатаНачала,
	|	ПриказНаПроведениеИнвентаризацииТоваров.ДатаОкончания,
	|	ПриказНаПроведениеИнвентаризацииТоваров.Описание,
	|	ПриказНаПроведениеИнвентаризацииТоваров.Организация,
	|	ПриказНаПроведениеИнвентаризацииТоваров.Склад,
	|	ПриказНаПроведениеИнвентаризацииТоваров.Магазин
	|ИЗ
	|	Документ.ПриказНаПроведениеИнвентаризацииТоваров КАК ПриказНаПроведениеИнвентаризацииТоваров
	|ГДЕ
	|	ПриказНаПроведениеИнвентаризацииТоваров.Ссылка В(&МассивОбъектов)
	|
	|УПОРЯДОЧИТЬ ПО
	|	Дата,
	|	Ссылка";
	
	Запрос.УстановитьПараметр("МассивОбъектов", МассивОбъектов);
	
	Результат = Запрос.Выполнить();
	ДанныеПечати = Результат.Выбрать();
	
	ПервыйДокумент = Истина;
	Макет = УправлениеПечатью.МакетПечатнойФормы("ОбщийМакет.ПФ_MXL_ИНВ22");
	ОбластьМакета = Макет.ПолучитьОбласть("Шапка");
	
	Пока ДанныеПечати.Следующий() Цикл
		
		Если Не ПервыйДокумент Тогда
			ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;
		
		ПервыйДокумент = Ложь;
		НомерСтрокиНачало = ТабличныйДокумент.ВысотаТаблицы + 1;

		ОбластьМакета.Параметры.Заполнить(ДанныеПечати);
		СведенияОбОрганизации = ФормированиеПечатныхФормСервер.СведенияОЮрФизЛице(ДанныеПечати.Организация, ДанныеПечати.ДатаДокумента);
		ОбластьМакета.Параметры.ПредставлениеОрганизации = ФормированиеПечатныхФормСервер.ОписаниеОрганизации(СведенияОбОрганизации, "ПолноеНаименование,");
		ОбластьМакета.Параметры.НомерДокумента           = ПрефиксацияОбъектовКлиентСервер.НомерНаПечать(ДанныеПечати.Номер, Ложь, Истина);
		ОбластьМакета.Параметры.ДатаДокумента            = ДанныеПечати.ДатаДокумента;
		ОбластьМакета.Параметры.Подразделение            = ДанныеПечати.Магазин;
		ОбластьМакета.Параметры.ДатаНачалаСтрокой        = Формат(ДанныеПечати.ДатаНачала,"ДЛФ=DD");
		ОбластьМакета.Параметры.ДатаОкончанияСтрокой	 = Формат(ДанныеПечати.ДатаОкончания,"ДЛФ=DD");
		
		Руководители = ФормированиеПечатныхФормСервер.ОтветственныеЛицаОрганизаций(ДанныеПечати.Организация, КонецДня(ДанныеПечати.ДатаДокумента));
		
		ОбластьМакета.Параметры.РуководительДолжность = Руководители.РуководительДолжность;
		ОбластьМакета.Параметры.ФИОРуководитель       = Руководители.Руководитель;
		
		ТабличныйДокумент.Вывести(ОбластьМакета);
		УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТабличныйДокумент, НомерСтрокиНачало, ОбъектыПечати, ДанныеПечати.Ссылка);
		
	КонецЦикла;
	ТабличныйДокумент.АвтоМасштаб = Истина;
	
	Возврат ТабличныйДокумент;
	
КонецФункции

#КонецОбласти

#КонецЕсли
