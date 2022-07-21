#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати.
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
	// Печать КМ7
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Идентификатор = "КМ7";
	КомандаПечати.Представление = НСтр("ru = 'КМ7'");
	КомандаПечати.ПроверкаПроведенияПередПечатью = Истина;
	
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
	
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "КМ7") Тогда
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(КоллекцияПечатныхФорм, "КМ7", "", ПечатьКМ7(МассивОбъектов, ОбъектыПечати));
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

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

///////////////////////////////////////////////////////////////////////////////
// Печать

// Формирует унифицированную форму КМ7.
//
// Возвращаемое значение:
//  Табличный документ - унифицированная форма КМ7.
//
Функция ПечатьКМ7(МассивОбъектов, ОбъектыПечати)

	ТабличныйДокумент = Новый ТабличныйДокумент;
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("МассивОбъектов", МассивОбъектов);

	Запрос.Текст =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	СводныйОтчетПоКассовойСмене.Номер,
	|	СводныйОтчетПоКассовойСмене.Дата КАК ДатаДокумента,
	|	СводныйОтчетПоКассовойСмене.Организация КАК Организация,
	|	ПРЕДСТАВЛЕНИЕ(СводныйОтчетПоКассовойСмене.Магазин) КАК ПредставлениеМагазина,
	|	СводныйОтчетПоКассовойСмене.Ссылка КАК Ссылка,
	|	СводныйОтчетПоКассовойСмене.Организация.Префикс КАК Префикс
	|ИЗ
	|	Документ.СводныйОтчетПоКассовойСмене КАК СводныйОтчетПоКассовойСмене
	|ГДЕ
	|	СводныйОтчетПоКассовойСмене.Ссылка В(&МассивОбъектов)
	|
	|УПОРЯДОЧИТЬ ПО
	|	Ссылка";

	РезультатЗапроса = Запрос.Выполнить();
	ДанныеПечати = РезультатЗапроса.Выбрать();
	
	
	Запрос.Текст =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	СводныйОтчетПоКассовойСменеОтчетыОРозничныхПродажах.ОтчетОРозничныхПродажах,
	|	СводныйОтчетПоКассовойСменеОтчетыОРозничныхПродажах.Ссылка
	|ПОМЕСТИТЬ ТаблицаОтчетовОРозничнойПродаже
	|ИЗ
	|	Документ.СводныйОтчетПоКассовойСмене.ОтчетыОРозничныхПродажах КАК СводныйОтчетПоКассовойСменеОтчетыОРозничныхПродажах
	|ГДЕ
	|	СводныйОтчетПоКассовойСменеОтчетыОРозничныхПродажах.Ссылка В(&МассивОбъектов)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ТаблицаОтчетовОРозничнойПродаже.ОтчетОРозничныхПродажах.КассаККМ.РегистрационныйНомер КАК РегистрационныйНомер,
	|	ТаблицаОтчетовОРозничнойПродаже.ОтчетОРозничныхПродажах.КассаККМ.СерийныйНомер КАК СерийныйНомер,
	|	ТаблицаОтчетовОРозничнойПродаже.ОтчетОРозничныхПродажах.КассаККМ.Код КАК НомерКассы,
	|	ТаблицаОтчетовОРозничнойПродаже.ОтчетОРозничныхПродажах.Дата КАК ДатаОтчета,
	|	ТаблицаОтчетовОРозничнойПродаже.ОтчетОРозничныхПродажах.Номер КАК НомерОтчета,
	|	ТаблицаОтчетовОРозничнойПродаже.ОтчетОРозничныхПродажах КАК ОтчетОРозничныхПродажах,
	|	ТаблицаОтчетовОРозничнойПродаже.ОтчетОРозничныхПродажах.СуммаДокумента КАК Выручка,
	|	ТаблицаОтчетовОРозничнойПродаже.ОтчетОРозничныхПродажах.СуммаВозвратов КАК Возвраты,
	|	ТаблицаОтчетовОРозничнойПродаже.Ссылка КАК Ссылка,
	|	ТаблицаОтчетовОРозничнойПродаже.ОтчетОРозничныхПродажах.КассаККМ КАК КассаККМ,
	|	ТаблицаОтчетовОРозничнойПродаже.Ссылка.Организация КАК Организация,
	|	ТаблицаОтчетовОРозничнойПродаже.Ссылка.Организация.Префикс КАК Префикс
	|ИЗ
	|	ТаблицаОтчетовОРозничнойПродаже КАК ТаблицаОтчетовОРозничнойПродаже";

	Запрос.УстановитьПараметр("МассивОбъектов", МассивОбъектов);
	РезультатЗапроса = Запрос.Выполнить();
	
	ТаблицаОтчетовОРозничныхПродажах = РезультатЗапроса.Выгрузить();
	
	ПервыйДокумент = Истина;
	
	Макет = УправлениеПечатью.МакетПечатнойФормы("ОбщийМакет.ПФ_MXL_КМ7");
	ТабличныйДокумент.ИмяПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_КМ7";
	
	
	Пока ДанныеПечати.Следующий() Цикл
		
		Если Не ПервыйДокумент Тогда
			ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;
		
		ПервыйДокумент = Ложь;
		
		НомерСтрокиНачало = ТабличныйДокумент.ВысотаТаблицы + 1;
		
		СведенияОбОрганизации = ФормированиеПечатныхФормСервер.СведенияОЮрФизЛице(ДанныеПечати.Организация, ДанныеПечати.ДатаДокумента);
		
		СтрокаКассовыхОтчетов = "";
		СтруктураПоиска = Новый Структура;
		СтруктураПоиска.Вставить("Ссылка", ДанныеПечати.Ссылка);
		
		СтрокиТаблицыОтчетов = ТаблицаОтчетовОРозничныхПродажах.НайтиСтроки(СтруктураПоиска);
		
		Для каждого СтрокаТаблицыОтчетов Из СтрокиТаблицыОтчетов Цикл
			
			Если Не ЗначениеЗаполнено(СтрокаТаблицыОтчетов.НомерОтчета) Тогда
				Продолжить;
			КонецЕсли;
			
			СтрокаКассовыхОтчетов = СтрокаКассовыхОтчетов
									+ ?(ЗначениеЗаполнено(СтрокаКассовыхОтчетов), ", ", "")
									+ ПрефиксацияОбъектовКлиентСервер.НомерНаПечать(СтрокаТаблицыОтчетов.НомерОтчета, Ложь, Истина)
									+ " от "
									+ Формат(СтрокаТаблицыОтчетов.ДатаОтчета, Нстр("ru='ДФ=dd.MM.yyyy'"));
			
		КонецЦикла;
		
		
		// Выводим общие реквизиты шапки.
		ОбластьМакета = Макет.ПолучитьОбласть("Заголовок");
		
		ОбластьМакета.Параметры.Заполнить(ДанныеПечати);
		ОбластьМакета.Параметры.ПредставлениеОрганизации = ФормированиеПечатныхФормСервер.ОписаниеОрганизации(СведенияОбОрганизации, "ПолноеНаименование,ИНН,ЮридическийАдрес,Телефоны");
		ОбластьМакета.Параметры.ДатаДокумента            = Формат(ДанныеПечати.ДатаДокумента, Нстр("ru='ДФ=dd.MM.yyyy'"));
		ОбластьМакета.Параметры.ВремяДокумента           = Формат(ДанныеПечати.ДатаДокумента, Нстр("ru='ДФ=HH.mm'"));
		ОбластьМакета.Параметры.НомерДокумента           = ПрефиксацияОбъектовКлиентСервер.НомерНаПечать(ДанныеПечати.Номер, Ложь, Истина);
		ОбластьМакета.Параметры.ОрганизацияПоОКПО        = СведенияОбОрганизации.КодПоОКПО;
		ОбластьМакета.Параметры.ОрганизацияИНН           = СведенияОбОрганизации.ИНН;
		ОбластьМакета.Параметры.ВидДеятельностиПоОКДП    = "";
		ОбластьМакета.Параметры.СтрокаКассовыхОтчетов    = СтрокаКассовыхОтчетов;
		ТабличныйДокумент.Вывести(ОбластьМакета);

		ОбластьМакета = Макет.ПолучитьОбласть("ШапкаТаблицы");
		ТабличныйДокумент.Вывести(ОбластьМакета);
		
		ИтогоВыручка  = 0;
		ИтогоВозвраты = 0;
		
		// Выводим строки
		ВыборкаСтрок = РезультатЗапроса.Выбрать();
		Для каждого СтрокаТаблицыОтчетов Из СтрокиТаблицыОтчетов Цикл
			
			ОбластьМакета = Макет.ПолучитьОбласть("СтрокаТаблицы");
			ОбластьМакета.Параметры.Заполнить(СтрокаТаблицыОтчетов);
			ОбластьМакета.Параметры.Выручка = СтрокаТаблицыОтчетов.Выручка + СтрокаТаблицыОтчетов.Возвраты;
			
			ТабличныйДокумент.Вывести(ОбластьМакета);
			
			ИтогоВыручка  = ИтогоВыручка + СтрокаТаблицыОтчетов.Выручка + СтрокаТаблицыОтчетов.Возвраты;
			ИтогоВозвраты = ИтогоВозвраты + СтрокаТаблицыОтчетов.Возвраты;
			
		КонецЦикла;
		
		// Выводим итог таблицы
		ОбластьМакета = Макет.ПолучитьОбласть("ИтогТаблицы");
		
		ОбластьМакета.Параметры.СуммаВыручки = ИтогоВыручка;
		
		ТабличныйДокумент.Вывести(ОбластьМакета);
		
		// Выводим подвал
		ОбластьМакета = Макет.ПолучитьОбласть("Подвал");
		
		ОбластьМакета.Параметры.СуммаВозвратовПокупателямРубли   = ЧислоПрописью(Цел(ИтогоВозвраты), "L=ru_RU", "рубль, рубля, рублей, м, копейка, копейки, копеек, ж, 0");
		ОбластьМакета.Параметры.СуммаВозвратовПокупателямКопейки = Формат(ИтогоВозвраты - Цел(ИтогоВозвраты), "ЧЦ=2; ЧС=-2; ЧН=00; ЧВН=");
		
		Руководители            = ФормированиеПечатныхФормСервер.ОтветственныеЛицаОрганизаций(ДанныеПечати.Организация, ДанныеПечати.ДатаДокумента);
		Руководитель            = Руководители.Руководитель;
		СтаршийКассир           = Руководители.Кассир;
		ДолжностьРуководителя   = Руководители.РуководительДолжность;

		ОбластьМакета.Параметры.ФИОКассираОрганизации  = СтаршийКассир;
		ОбластьМакета.Параметры.ФИОРуководителя        = Руководитель;
		ОбластьМакета.Параметры.ДолжностьРуководителя  = ДолжностьРуководителя;

		ТабличныйДокумент.Вывести(ОбластьМакета);
	
		
	КонецЦикла;
	
	// Зададим параметры макета
	ТабличныйДокумент.ПолеСверху = 20;
	ТабличныйДокумент.ПолеСлева  = 10;
	ТабличныйДокумент.ПолеСнизу  = 20;
	ТабличныйДокумент.ПолеСправа = 20;
	ТабличныйДокумент.ОриентацияСтраницы = ОриентацияСтраницы.Ландшафт;
	
	Возврат ТабличныйДокумент;

КонецФункции

#КонецОбласти

#КонецЕсли
