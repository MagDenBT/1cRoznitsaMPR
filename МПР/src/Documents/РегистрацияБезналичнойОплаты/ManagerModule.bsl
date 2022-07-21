#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Инициализирует таблицы значений, содержащие данные документа.
// Таблицы значений сохраняет в свойствах структуры "ДополнительныеСвойства".
//
// Параметры:
//  ДокументСсылка - ДокументСсылка.АктОРасхожденияхПриПриемкеТоваров - документ для инициализации данных.
//  ДополнительныеСвойства - Структура - структура дополнительных свойств.
//
Процедура ИнициализироватьДанныеДокумента(ДокументСсылка, ДополнительныеСвойства) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Ссылка", ДокументСсылка);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ДанныеДокумента.Ссылка КАК Ссылка,
	|	ДанныеДокумента.Магазин КАК Магазин,
	|	ДанныеДокумента.Контрагент КАК Контрагент,
	|	ДанныеДокумента.ХозяйственнаяОперация КАК ХозяйственнаяОперация,
	|	НЕ ДанныеДокумента.Магазин.СкладУправляющейСистемы КАК ФормироватьДвижения,
	|	ДанныеДокумента.Дата КАК Период,
	|	ДанныеДокумента.ДокументОснование КАК ДокументОснование,
	|	ДанныеДокумента.Организация КАК Организация,
	|	ДанныеДокумента.БанковскийСчетОрганизации КАК БанковскийСчетОрганизации
	|ИЗ
	|	Документ.РегистрацияБезналичнойОплаты КАК ДанныеДокумента
	|ГДЕ
	|	ДанныеДокумента.Ссылка = &Ссылка";
	РезультатЗапроса = Запрос.Выполнить();
	Реквизиты = РезультатЗапроса.Выбрать();
	Реквизиты.Следующий();
	
	ОбщегоНазначенияРТ.ПеренестиСтрокуВыборкиВПараметрыЗапроса(РезультатЗапроса, Реквизиты, Запрос);
	
	ХозяйственныеОперацииПоступление = Новый Массив;
	ХозяйственныеОперацииПоступление.Добавить(Перечисления.ХозяйственныеОперации.ВозвратДенежныхСредствОтПоставщика);
	ХозяйственныеОперацииПоступление.Добавить(Перечисления.ХозяйственныеОперации.ПоступлениеОплатыОтКлиента);
	ХозяйственныеОперацииПоступление.Добавить(Перечисления.ХозяйственныеОперации.ПрочиеДоходы);
	
	Запрос.УстановитьПараметр("ХозяйственныеОперацииПоступление", ХозяйственныеОперацииПоступление);
	
	МассивПустыхДокументовРасчета = Новый Массив;
	МассивПустыхДокументовРасчета.Добавить(Документы.РеализацияТоваров.ПустаяСсылка());
	МассивПустыхДокументовРасчета.Добавить(Документы.ВозвратТоваровПоставщику.ПустаяСсылка());
	МассивПустыхДокументовРасчета.Добавить(Документы.ПоступлениеТоваров.ПустаяСсылка());
	МассивПустыхДокументовРасчета.Добавить(Документы.ЗаказПоставщику.ПустаяСсылка());
	МассивПустыхДокументовРасчета.Добавить(Документы.ВозвратТоваровОтПокупателя.ПустаяСсылка());
	МассивПустыхДокументовРасчета.Добавить(Неопределено);
	
	Запрос.УстановитьПараметр("МассивПустыхДокументовРасчета", МассивПустыхДокументовРасчета);
	
	ПоРаспоряжению = Ложь;
	Если ЗначениеЗаполнено(Реквизиты.ДокументОснование) 
		И ТипЗнч(Реквизиты.ДокументОснование) = Тип("ДокументСсылка.ЗаявкаНаРасходованиеДенежныхСредств") Тогда
		
		ПоРаспоряжению = Истина;
	КонецЕсли;
	
	Запрос.УстановитьПараметр("ПоРаспоряжению", ПоРаспоряжению);
	
	Запрос.УстановитьПараметр("УчетБезналичныхДС", ПолучитьФункциональнуюОпцию("ВестиУчетБезналичныхДенежныхСредств"));
	Запрос.УстановитьПараметр("ДатаНачалаУчетаБезналичныхДС", Константы.ДатаНачалаУчетаБезналичныхДенежныхСредств.Получить());
	
	ТекстыЗапросов = Новый Массив;
	ТекстыЗапросов.Добавить(ТекстЗапросаТаблицаДенежныеСредстваБезналичные());
	ТекстыЗапросов.Добавить(ТекстЗапросаТаблицаРасчетыСКлиентами());
	ТекстыЗапросов.Добавить(ТекстЗапросаТаблицаРасчетыСПоставщиками());
	ТекстыЗапросов.Добавить(ТекстЗапросаТаблицаДенежныеСредстваКВыплате());
	
	ТекстЗапроса = СтрСоединить(ТекстыЗапросов, ОбщегоНазначения.РазделительПакетаЗапросов());
	
	Запрос.Текст = ТекстЗапроса;
	МассивРезультатов = Запрос.ВыполнитьПакет();
	
	ТаблицыДляДвижений = ДополнительныеСвойства.ТаблицыДляДвижений;
	
	ТаблицыДляДвижений.Вставить("ТаблицаДенежныеСредстваБезналичные", МассивРезультатов[0].Выгрузить());
	ТаблицыДляДвижений.Вставить("ТаблицаРасчетыСКлиентами",           МассивРезультатов[1].Выгрузить());
	ТаблицыДляДвижений.Вставить("ТаблицаРасчетыСПоставщиками",        МассивРезультатов[2].Выгрузить());
	ТаблицыДляДвижений.Вставить("ТаблицаДенежныеСредстваКВыплате",    МассивРезультатов[3].Выгрузить());
	
	
	//Если ЭтоРасчетыСКлиентами Тогда
	//	
	//	Запрос.Текст = 
	//	"ВЫБРАТЬ
	//	|	&Контрагент КАК Контрагент,
	//	|	&Магазин КАК Магазин,
	//	|	&Организация КАК Организация,
	//	|	ТабличнаяЧастьРасшифровкаПлатежа.НомерСтроки КАК НомерСтроки,
	//	|	&Период КАК Период,
	//	|	ВЫБОР
	//	|		КОГДА &ХозяйственнаяОперация = ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ПоступлениеОплатыОтКлиента)
	//	|			ТОГДА ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)
	//	|		ИНАЧЕ ЗНАЧЕНИЕ(ВидДвиженияНакопления.Расход)
	//	|	КОНЕЦ КАК ВидДвижения,
	//	|	ВЫБОР
	//	|		КОГДА ТабличнаяЧастьРасшифровкаПлатежа.ДокументРасчетовСКонтрагентом В (&МассивПустыхДокументовРасчета)
	//	|			ТОГДА ТабличнаяЧастьРасшифровкаПлатежа.Ссылка
	//	|		ИНАЧЕ ТабличнаяЧастьРасшифровкаПлатежа.ДокументРасчетовСКонтрагентом
	//	|	КОНЕЦ КАК ДокументРасчета,
	//	|	ВЫБОР
	//	|		КОГДА НЕ ТабличнаяЧастьРасшифровкаПлатежа.ДокументРасчетовСКонтрагентом В (&МассивПустыхДокументовРасчета)
	//	|				И (ТабличнаяЧастьРасшифровкаПлатежа.ДокументРасчетовСКонтрагентом ССЫЛКА Документ.ЧекККМ
	//	|					ИЛИ ТабличнаяЧастьРасшифровкаПлатежа.ДокументРасчетовСКонтрагентом ССЫЛКА Документ.РеализацияТоваров)
	//	|			ТОГДА ТабличнаяЧастьРасшифровкаПлатежа.ДокументРасчетовСКонтрагентом.ЗаказПокупателя
	//	|		ИНАЧЕ ТабличнаяЧастьРасшифровкаПлатежа.Ссылка.ДокументОснование
	//	|	КОНЕЦ КАК ЗаказПокупателя,
	//	|	ТабличнаяЧастьРасшифровкаПлатежа.Сумма КАК Сумма
	//	|ИЗ
	//	|	Документ.РегистрацияБезналичнойОплаты.РасшифровкаПлатежа КАК ТабличнаяЧастьРасшифровкаПлатежа
	//	|ГДЕ
	//	|	ТабличнаяЧастьРасшифровкаПлатежа.Ссылка = &Ссылка
	//	|	И &ФормироватьДвижения
	//	|	И &ХозяйственнаяОперация <> ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ПрочиеДоходы)";
	//	
	//	Результат = Запрос.ВыполнитьПакет();
	//	ТаблицыДляДвижений = ДополнительныеСвойства.ТаблицыДляДвижений;
	//	ТаблицыДляДвижений.Вставить("ТаблицаРасчетыСКлиентами", Результат[0].Выгрузить());
	//	
	//Иначе
	//	ПоРаспоряжению = Ложь;
	//	Если ЗначениеЗаполнено(Реквизиты.ДокументОснование) 
	//		И ТипЗнч(Реквизиты.ДокументОснование) = Тип("ДокументСсылка.ЗаявкаНаРасходованиеДенежныхСредств") Тогда
	//		
	//		ПоРаспоряжению = Истина;
	//	КонецЕсли;
	//	
	//	Запрос.УстановитьПараметр("ПоРаспоряжению", ПоРаспоряжению);
	//	
	//	Запрос.Текст = 
	//	// [0] ТаблицаРасчетыСПоставщиками
	//	"ВЫБРАТЬ
	//	|	ТаблицаОплата.НомерСтроки                         КАК НомерСтроки,
	//	|	&Период                                           КАК Период,
	//	|	ВЫБОР
	//	|		КОГДА &ХозяйственнаяОперация = ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ОплатаПоставщику)
	//	|			ТОГДА ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)
	//	|		ИНАЧЕ ЗНАЧЕНИЕ(ВидДвиженияНакопления.Расход)
	//	|	КОНЕЦ                                             КАК ВидДвижения,
	//	|	ВЫБОР
	//	|		КОГДА ТаблицаОплата.ДокументРасчетовСКонтрагентом ССЫЛКА Документ.ПоступлениеТоваров
	//	|			ТОГДА ВЫБОР
	//	|					КОГДА ТаблицаОплата.ДокументРасчетовСКонтрагентом.ЗаказПоставщику = ЗНАЧЕНИЕ(Документ.ЗаказПоставщику.ПустаяСсылка)
	//	|						ТОГДА ТаблицаОплата.ДокументРасчетовСКонтрагентом
	//	|					ИНАЧЕ ТаблицаОплата.ДокументРасчетовСКонтрагентом.ЗаказПоставщику
	//	|				КОНЕЦ
	//	|		ИНАЧЕ ТаблицаОплата.ДокументРасчетовСКонтрагентом
	//	|	КОНЕЦ КАК ДокументРасчета,
	//	|	&Контрагент                                       КАК Поставщик,
	//	|	&Магазин                                          КАК Магазин,
	//	|	ТаблицаОплата.Сумма                               КАК Сумма,
	//	|	ТаблицаОплата.Сумма                               КАК КОплате,
	//	|	ЗНАЧЕНИЕ(Перечисление.ФормыОплаты.Безналичная)    КАК ФормаОплаты
	//	|ИЗ
	//	|	Документ.РегистрацияБезналичнойОплаты.РасшифровкаПлатежа КАК ТаблицаОплата
	//	|ГДЕ
	//	|	ТаблицаОплата.Ссылка = &Ссылка
	//	|	И &ФормироватьДвижения И &ХозяйственнаяОперация <> ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ПрочиеРасходы)
	//	|
	//	|УПОРЯДОЧИТЬ ПО
	//	|	ТаблицаОплата.НомерСтроки
	//	|;
	//	|
	//	|////////////////////////////////////////////////////////////////////////////////
	//	// [1] ТаблицаДенежныеСредстваКВыплате
	//	|ВЫБРАТЬ
	//	|	&Период                                          КАК Период,
	//	|	&ХозяйственнаяОперация                           КАК ХозяйственнаяОперация,
	//	|	ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)           КАК ВидДвижения,
	//	|	&ДокументОснование                               КАК РаспоряжениеНаРасходованиеДенежныхСредств,
	//	|	&Магазин                                         КАК Магазин,
	//	|	Оплата.СтатьяДвиженияДенежныхСредств             КАК СтатьяДвиженияДенежныхСредств,
	//	|	Оплата.ДокументРасчетовСКонтрагентом             КАК ДокументРасчета,
	//	|	Оплата.Сумма                                     КАК Сумма
	//	|ИЗ
	//	|	Документ.РегистрацияБезналичнойОплаты.РасшифровкаПлатежа КАК Оплата
	//	|ГДЕ
	//	|	Оплата.Ссылка = &Ссылка И &ПоРаспоряжению
	//	|";
	//	
	//	Результат = Запрос.ВыполнитьПакет();
	//	ТаблицыДляДвижений = ДополнительныеСвойства.ТаблицыДляДвижений;
	//	ТаблицыДляДвижений.Вставить("ТаблицаРасчетыСПоставщиками", Результат[0].Выгрузить());
	//	ТаблицыДляДвижений.Вставить("ТаблицаДенежныеСредстваКВыплате", Результат[1].Выгрузить());
	//	
	//КонецЕсли;
	//
	//
	//
	//ТаблицыДляДвижений.Вставить("ЭтоРасчетыСКлиентами", ЭтоРасчетыСКлиентами);
	
КонецПроцедуры

// Подготавливает данные для пробития чека.
// 
// Параметры:
//  ДокументСсылка - ДокументСсылка - документ для пробития.
//  РаспределениеВыручкиПоСекциям - Соответствие - соответсвие распределения выручки.
//  НомерЧека - Число - номер чека.
//
// Возвращаемое значение:
//  Структура - данные для пробития чека.
//
Функция ПодготовитьДанныеДляПробитияЧека(ДокументСсылка, РаспределениеВыручкиПоСекциям, НомерЧека) Экспорт
	
	ОбщиеПараметры = ОборудованиеЧекопечатающиеУстройстваКлиентСервер.ПараметрыОперацииФискализацииЧека();
	
	// Общие параметры чека
	СтруктураРеквизитов = Новый Структура;
	СтруктураРеквизитов.Вставить("КассаККМ");
	СтруктураРеквизитов.Вставить("Магазин");
	СтруктураРеквизитов.Вставить("Организация");
	СтруктураРеквизитов.Вставить("Дата");
	СтруктураРеквизитов.Вставить("ДоговорКонтрагента");
	СтруктураРеквизитов.Вставить("Ответственный");
	СтруктураРеквизитов.Вставить("СистемаНалогообложения");
	СтруктураРеквизитов.Вставить("Контрагент");
	СтруктураРеквизитов.Вставить("СуммаДокумента");
	СтруктураРеквизитов.Вставить("Телефон");
	СтруктураРеквизитов.Вставить("АдресЭП");
	СтруктураРеквизитов.Вставить("ДокументОснование");
	СтруктураРеквизитов.Вставить("ХозяйственнаяОперация");
	РеквизитыДокумента = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(ДокументСсылка, СтруктураРеквизитов);
	
	СтруктураРеквизитов = Новый Структура;
	СтруктураРеквизитов.Вставить("НаименованиеПолное");
	СтруктураРеквизитов.Вставить("ИНН");
	СтруктураРеквизитов.Вставить("КПП");
	РеквизитыОрганизация = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(РеквизитыДокумента.Организация, СтруктураРеквизитов);
	
	СтруктураРеквизитов = Новый Структура;
	СтруктураРеквизитов.Вставить("ЭлектронныйЧекSMSПередаютсяПрограммой1С");
	СтруктураРеквизитов.Вставить("ЭлектронныйЧекEmailПередаютсяПрограммой1С");
	СтруктураРеквизитов.Вставить("СерийныйНомер");
	СтруктураРеквизитов.Вставить("Магазин");
	СтруктураРеквизитов.Вставить("Код");
	СтруктураРеквизитов.Вставить("СпособФорматноЛогическогоКонтроля", "ПодключаемоеОборудование.СпособФорматноЛогическогоКонтроля");
	СтруктураРеквизитов.Вставить("ДопустимоеРасхождениеФорматноЛогическогоКонтроля", "ПодключаемоеОборудование.ДопустимоеРасхождениеФорматноЛогическогоКонтроля");
	СтруктураРеквизитов.Вставить("ТипОборудования", "ПодключаемоеОборудование.ТипОборудования");
	РеквизитыКассыККМ = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(РеквизитыДокумента.КассаККМ, СтруктураРеквизитов);
	
	СтруктураРеквизитов = Новый Структура;
	СтруктураРеквизитов.Вставить("Наименование");
	СтруктураРеквизитов.Вставить("ИНН");
	РеквизитыКассир = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(РеквизитыДокумента.Ответственный.ФизическоеЛицо, СтруктураРеквизитов);
	
	ОбщиеПараметры.СистемаНалогообложения = РеквизитыДокумента.СистемаНалогообложения;
	
	Если РеквизитыДокумента.ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ПоступлениеОплатыОтКлиента Тогда
		ОбщиеПараметры.ТипРасчета = Перечисления.ТипыРасчетаДенежнымиСредствами.ПриходДенежныхСредств;
		Если ЗначениеЗаполнено(РеквизитыДокумента.ДоговорКонтрагента) Тогда
			НомерСекции = РаспределениеВыручкиПоСекциям.СоответствиеДоговоровСекциям.Получить(РеквизитыДокумента.ДоговорКонтрагента);
		Иначе
			НомерСекции = РаспределениеВыручкиПоСекциям.НомерСекцииДляОплатыКартой;
		КонецЕсли;
		Если ОбщиеПараметры.СистемаНалогообложения = Перечисления.ТипыСистемНалогообложенияККТ.ОСН Тогда
			ЗначСтавкиНДС = УчетНДС.СтавкаНДСПоУмолчанию(ДокументСсылка.Дата);
			СтавкаНДС = ПодключаемоеОборудованиеРТ.СтавкаНДСВФорматеБПО(ЗначСтавкиНДС, Истина);	
		Иначе
			СтавкаНДС = Неопределено;
		КонецЕсли;
		ПринятоОт = ОбщегоНазначенияРТВызовСервера.ЗначениеРеквизитаОбъекта(РеквизитыДокумента.Контрагент, "НаименованиеПолное");
		Наименование = НСтр("ru = 'Безналичная оплата от:'") + " " + ПринятоОт + Символы.ПС
						+ НСтр("ru = 'Основание:'") + " " + РеквизитыДокумента.ДокументОснование;
	Иначе
		ОбщиеПараметры.ТипРасчета = Перечисления.ТипыРасчетаДенежнымиСредствами.ВозвратДенежныхСредств;
		Если ЗначениеЗаполнено(РеквизитыДокумента.ДоговорКонтрагента) Тогда
			НомерСекции = РаспределениеВыручкиПоСекциям.СоответствиеДоговоровСекциям.Получить(РеквизитыДокумента.ДоговорКонтрагента);
		Иначе
			НомерСекции = РаспределениеВыручкиПоСекциям.НомерСекцииДляВозвратаОплатыНаКарту;
		КонецЕсли;
		Если ОбщиеПараметры.СистемаНалогообложения = Перечисления.ТипыСистемНалогообложенияККТ.ОСН Тогда
			ЗначСтавкиНДС = УчетНДС.СтавкаНДСПоУмолчанию(ДокументСсылка.Дата);
			СтавкаНДС = ПодключаемоеОборудованиеРТ.СтавкаНДСВФорматеБПО(ЗначСтавкиНДС, Ложь);	
		Иначе
			СтавкаНДС = Неопределено;
		КонецЕсли;
		Вернуть = ОбщегоНазначенияРТВызовСервера.ЗначениеРеквизитаОбъекта(РеквизитыДокумента.Контрагент, "НаименованиеПолное");
		Наименование = НСтр("ru = 'Возврат безналичной оплаты:'") + " " + Вернуть + Символы.ПС
						+ НСтр("ru = 'Основание:'") + " " + РеквизитыДокумента.ДокументОснование
	КонецЕсли;
	
	ОбщиеПараметры.Электронно = Ложь;
	
	Если ЗначениеЗаполнено(РеквизитыДокумента.Телефон) Тогда
		Если РеквизитыКассыККМ.ЭлектронныйЧекSMSПередаютсяПрограммой1С Тогда
			ОбщиеПараметры.Отправляет1СSMS = Истина;
		КонецЕсли;
		Телефон = РеквизитыДокумента.Телефон;
		Если СтрНайти(Телефон, "+7") = 1 ИЛИ (СтрНайти(Телефон, "8") = 1 И СтрДлина(Телефон) = 11) Тогда
			ОбщиеПараметры.ПокупательНомер = Телефон;
		Иначе
			ОбщиеПараметры.ПокупательНомер = "+7" + Телефон;
		КонецЕсли;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(РеквизитыДокумента.АдресЭП) Тогда
		Если РеквизитыКассыККМ.ЭлектронныйЧекEmailПередаютсяПрограммой1С Тогда
			ОбщиеПараметры.Отправляет1СEmail = Истина;
			СистемнаяУчетнаяЗапись = РаботаСПочтовымиСообщениями.СистемнаяУчетнаяЗапись();
			Если ЗначениеЗаполнено(СистемнаяУчетнаяЗапись) Тогда
				ОбщиеПараметры.ОтправительEmail = СистемнаяУчетнаяЗапись.АдресЭлектроннойПочты;
			КонецЕсли;
		КонецЕсли;
		ОбщиеПараметры.ПокупательEmail = РеквизитыДокумента.АдресЭП;
	КонецЕсли;
	
	// Параметры необходимые для чека ЕНВД на принтере чеков
	ОбщиеПараметры.ДокументОснование = ДокументСсылка;
	
	ОбщиеПараметры.Кассир          = РеквизитыКассир.Наименование;
	ОбщиеПараметры.КассирИНН       = РеквизитыКассир.ИНН;
	
	ОбщиеПараметры.Организация    = РеквизитыДокумента.Организация;
	ОбщиеПараметры.ОрганизацияНазвание = РеквизитыОрганизация.НаименованиеПолное;
	ОбщиеПараметры.ОрганизацияИНН = РеквизитыОрганизация.ИНН;
	ОбщиеПараметры.ОрганизацияКПП = РеквизитыОрганизация.КПП;
	ОбщиеПараметры.НомерКассы     = РеквизитыКассыККМ.Код;
	ОбщиеПараметры.НомерЧека      = НомерЧека;
	ОбщиеПараметры.ТорговыйОбъект = РеквизитыДокумента.Магазин;
	
	ОбщиеПараметры.НомерСмены = 1;
	
	СведенияООрганизации = ФормированиеПечатныхФормСервер.СведенияОЮрФизЛице(РеквизитыДокумента.Организация, РеквизитыДокумента.Дата);
	АдресМагазина = ОбщегоНазначенияРТ.АдресМагазина(РеквизитыКассыККМ.Магазин);
	
	СерийныйНомер = РеквизитыКассыККМ.СерийныйНомер;
	Если НЕ ЗначениеЗаполнено(СерийныйНомер) Тогда
		СерийныйНомер = "1";
	КонецЕсли;
	
	ОбщиеПараметры.АдресРасчетов = АдресМагазина;
	ОбщиеПараметры.МестоРасчетов = Строка(РеквизитыКассыККМ.Магазин) + " " + АдресМагазина;
	ОбщиеПараметры.АдресМагазина = АдресМагазина;
	ОбщиеПараметры.НаименованиеМагазина = Строка(РеквизитыКассыККМ.Магазин);
	ОбщиеПараметры.СерийныйНомер = СерийныйНомер;
	
	ПодключаемоеОборудованиеРТ.ЗаполнитьДанныеПокупателя(ОбщиеПараметры, РеквизитыДокумента);
	
	ПодключаемоеОборудованиеРТ.ЗаполнитьПараметрыПлатежногоДоговора(ОбщиеПараметры, 
																	РеквизитыДокумента.ДоговорКонтрагента,
																	РеквизитыДокумента.СуммаДокумента);
	
	Если ЗначениеЗаполнено(РеквизитыДокумента.ДоговорКонтрагента) Тогда
		НомерСекции = РаспределениеВыручкиПоСекциям.СоответствиеДоговоровСекциям.Получить(РеквизитыДокумента.ДоговорКонтрагента);
	Иначе
		НомерСекции = 1;
	КонецЕсли;
	
	ПараметрыДокумента = Новый Структура;
	ПараметрыДокумента.Вставить("НомерСекции", НомерСекции);
	
	ОбщиеПараметры.КассаККМ = РеквизитыДокумента.КассаККМ;
	
	РасшифровкаПлатежа = РасшифровкаПлатежа(ДокументСсылка);
	
	СуммаДокументовРасчетов = 0;
	
	ДобавленыДанныеПоЗаказу = Ложь;
	
	Для Каждого СтрокаПлатежа Из РасшифровкаПлатежа Цикл
		
		ПараметрыДокумента.Вставить("ПризнакСпособаРасчета", СтрокаПлатежа.ПризнакСпособаРасчета);
		ТабличнаяЧастьТоварыОтсутствует = ТипЗнч(СтрокаПлатежа.ДокументРасчетовСКонтрагентом) = Тип("ДокументСсылка.РегистрацияБезналичнойОплаты");
		Если ЗначениеЗаполнено(СтрокаПлатежа.ДокументРасчетовСКонтрагентом) 
			И НЕ ТабличнаяЧастьТоварыОтсутствует Тогда
			ПодключаемоеОборудованиеРТ.ДобавитьСтрокиДляФискализацииТоваров(СтрокаПлатежа.ДокументРасчетовСКонтрагентом, ПараметрыДокумента, ОбщиеПараметры, СуммаДокументовРасчетов);
			
		ИначеЕсли ЗначениеЗаполнено(РеквизитыДокумента.ДокументОснование)
			И ТипЗнч(РеквизитыДокумента.ДокументОснование) = Тип("ДокументСсылка.ЗаказПокупателя")
			И НЕ ДобавленыДанныеПоЗаказу Тогда
			ПодключаемоеОборудованиеРТ.ДобавитьСтрокиДляФискализацииТоваров(РеквизитыДокумента.ДокументОснование,
																			ПараметрыДокумента,
																			ОбщиеПараметры,
																			СуммаДокументовРасчетов);
			ДобавленыДанныеПоЗаказу = Истина;
		Иначе
			СтрокаПозицииЧека = ОборудованиеЧекопечатающиеУстройстваКлиентСервер.ПараметрыФискальнойСтрокиЧека(); 
			
			СтрокаПозицииЧека.Наименование = Наименование;
			СтрокаПозицииЧека.Количество     = 1;
			СтрокаПозицииЧека.Цена           = СтрокаПлатежа.Сумма;
			СтрокаПозицииЧека.ЦенаСоСкидками = СтрокаПлатежа.Сумма;
			СтрокаПозицииЧека.Сумма          = СтрокаПлатежа.Сумма;
			СтрокаПозицииЧека.НомерСекции    = НомерСекции;
			СтрокаПозицииЧека.СтавкаНДС      = СтавкаНДС;
			
			СтрокаПозицииЧека.ПризнакСпособаРасчета = СтрокаПлатежа.ПризнакСпособаРасчета;
			СтрокаПозицииЧека.ПризнакПредметаРасчета = Перечисления.ПризнакиПредметаРасчета.ПлатежВыплата;
			
			ПодключаемоеОборудованиеРТ.ЗаполнитьПараметрыПлатежногоДоговораВСтроке(ОбщиеПараметры, СтрокаПозицииЧека);
			
			ОбщиеПараметры.ПозицииЧека.Добавить(СтрокаПозицииЧека);
			СуммаДокументовРасчетов = СуммаДокументовРасчетов + СтрокаПлатежа.Сумма;
		КонецЕсли;
		
	КонецЦикла;
	
	Если РеквизитыКассыККМ.ТипОборудования = Перечисления.ТипыПодключаемогоОборудования.ККТ Тогда
		// При необходимости будет проведен формато-логический контроль
		ОбщиеПараметры.СпособФорматноЛогическогоКонтроля = РеквизитыКассыККМ.СпособФорматноЛогическогоКонтроля;
		ОбщиеПараметры.ДопустимоеРасхождениеФорматноЛогическогоКонтроля = РеквизитыКассыККМ.ДопустимоеРасхождениеФорматноЛогическогоКонтроля;
		Если ФорматноЛогическийКонтрольКлиентСервер.НуженФорматноЛогическийКонтроль(ОбщиеПараметры) Тогда
			ФорматноЛогическийКонтрольКлиентСервер.ПровестиФорматноЛогическийКонтроль(ОбщиеПараметры);
		КонецЕсли;
	КонецЕсли;
	
	СтрокаНаименованиеОплаты = НСтр("ru = 'Безналичная оплата'");
	СтрокаОплаты = Новый Структура();
	СтрокаОплаты.Вставить("ТипОплаты", Перечисления.ТипыОплатыККТ.Электронно);
	СтрокаОплаты.Вставить("Наименование", СтрокаНаименованиеОплаты);
	СтрокаОплаты.Вставить("Сумма", РеквизитыДокумента.СуммаДокумента);
	ОбщиеПараметры.ТаблицаОплат.Добавить(СтрокаОплаты);
	
	РазницаСумм = СуммаДокументовРасчетов - РеквизитыДокумента.СуммаДокумента;
	Если РазницаСумм > 0 Тогда
		СтрокаОплаты = Новый Структура();
		СтрокаОплаты.Вставить("ТипОплаты", Перечисления.ТипыОплатыККТ.Постоплата);
		СтрокаОплаты.Вставить("Наименование", НСтр("ru = 'Постоплата'"));
		СтрокаОплаты.Вставить("Сумма", РазницаСумм);
		ОбщиеПараметры.ТаблицаОплат.Добавить(СтрокаОплаты);
	КонецЕсли;
	
	Возврат ОбщиеПараметры;
	
КонецФункции // ПодготовитьДанныеДляПробитияЧека()

// Процедура заполняет массивы реквизитов, зависимых от хозяйственной операции документа.
// Параметры:
//           ХозяйственнаяОперация - ПеречислениеСсылка.ХозяйственныеОперации - Хоз. операции документа для которого
//                                                                              необходимо получить массив реквизитов.
//           МассивВсехРеквизитов - Неопределено - Выходной параметр с типом Массив в который будут помещены имена всех
//                                                 реквизитов документов.
//           МассивРеквизитовОперации - Неопределено - Выходной параметр с типом Массив в который будут помещены имена
//                                                     реквизитов по виду операции документа.
//
Процедура ЗаполнитьИменаРеквизитовПоХозяйственнойОперации(ХозяйственнаяОперация, МассивВсехРеквизитов, МассивРеквизитовОперации) Экспорт
	
	МассивВсехРеквизитов = Новый Массив;
	МассивВсехРеквизитов.Добавить("ДокументОснование");
	МассивВсехРеквизитов.Добавить("ГруппаЗаказПокупателя");
	МассивВсехРеквизитов.Добавить("РасшифровкаПлатежа.ДокументРасчетовСКонтрагентом");
	МассивВсехРеквизитов.Добавить("РасшифровкаПлатежа.ПризнакСпособаРасчета");
	
	МассивРеквизитовОперации = Новый Массив;
	
	Если ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ПоступлениеОплатыОтКлиента Тогда
		МассивРеквизитовОперации.Добавить("ГруппаЗаказПокупателя");
	Иначе
		МассивРеквизитовОперации.Добавить("ДокументОснование");
	КонецЕсли;
	
	Если ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ПоступлениеОплатыОтКлиента
		ИЛИ ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ВозвратОплатыКлиенту Тогда
		МассивРеквизитовОперации.Добавить("РасшифровкаПлатежа.ПризнакСпособаРасчета");
	КонецЕсли;
	
	Если НЕ (ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ПрочиеРасходы
		ИЛИ ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ПрочиеДоходы) Тогда
		МассивРеквизитовОперации.Добавить("РасшифровкаПлатежа.ДокументРасчетовСКонтрагентом");
	КонецЕсли;
	
КонецПроцедуры

// Заполненяет признак способа расчета в строке расшифровки платежа.
//
// Параметры:
//  Объект - ДокументОбъект.РасходныйКассовыйОрдер, ДанныеФормыСтруктуры - объект для заполнения признака;
//  СтрокаРасшифровки - СтрокаТабличнойЧасти, ДанныеФормыЭлементКоллекции - строка расшифровки платежа для заполнения.
//
Процедура ЗаполнитьПризнакСпособаРасчетаСтрокиРасшифровки(Объект, СтрокаРасшифровки) Экспорт
	
	ПризнакСпособаРасчета = Перечисления.ПризнакиСпособаРасчета.ПустаяСсылка();
	
	Если Объект.ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ПоступлениеОплатыОтКлиента Тогда
		Если ЗначениеЗаполнено(СтрокаРасшифровки.ДокументРасчетовСКонтрагентом)
			И (ТипЗнч(СтрокаРасшифровки.ДокументРасчетовСКонтрагентом) = Тип("ДокументСсылка.РеализацияТоваров")
			ИЛИ ТипЗнч(СтрокаРасшифровки.ДокументРасчетовСКонтрагентом) = Тип("ДокументСсылка.ЧекККМ")) Тогда
			ПризнакСпособаРасчета = Перечисления.ПризнакиСпособаРасчета.ОплатаКредита;
		ИначеЕсли ЗначениеЗаполнено(Объект.ДокументОснование)
			И ТипЗнч(Объект.ДокументОснование) = Тип("ДокументСсылка.ЗаказПокупателя") Тогда
			СуммаЗаказа = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Объект.ДокументОснование, "СуммаДокумента");
			Если СтрокаРасшифровки.Сумма >= СуммаЗаказа Тогда
				ПризнакСпособаРасчета = Перечисления.ПризнакиСпособаРасчета.ПредоплатаПолная;
				//{ds-28.04.2021
				ПризнакСпособаРасчета = Перечисления.ПризнакиСпособаРасчета.ПередачаСПолнойОплатой;
				//}
			Иначе
				ПризнакСпособаРасчета = Перечисления.ПризнакиСпособаРасчета.ПредоплатаЧастичная;
			КонецЕсли;
		Иначе
			ПризнакСпособаРасчета = Перечисления.ПризнакиСпособаРасчета.Аванс;
		КонецЕсли;
	ИначеЕсли Объект.ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ВозвратОплатыКлиенту Тогда
		Если ЗначениеЗаполнено(СтрокаРасшифровки.ДокументРасчетовСКонтрагентом) Тогда
			Если ТипЗнч(СтрокаРасшифровки.ДокументРасчетовСКонтрагентом) = Тип("ДокументСсылка.РегистрацияБезналичнойОплаты") Тогда
				ПризнакСпособаРасчета = Перечисления.ПризнакиСпособаРасчета.Аванс;
			ИначеЕсли СтрокаРасшифровки.Сумма >= ОбщегоНазначения.ЗначениеРеквизитаОбъекта(СтрокаРасшифровки.ДокументРасчетовСКонтрагентом, "СуммаДокумента") Тогда
				ПризнакСпособаРасчета = Перечисления.ПризнакиСпособаРасчета.ПередачаСПолнойОплатой;
			Иначе
				ПризнакСпособаРасчета = Перечисления.ПризнакиСпособаРасчета.ПередачаСЧастичнойОплатой;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
	СтрокаРасшифровки.ПризнакСпособаРасчета = ПризнакСпособаРасчета;
	
КонецПроцедуры

#Область СтандарныеПодсистемы

// См. УправлениеДоступомПереопределяемый.ПриЗаполненииСписковСОграничениемДоступа.
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт

	Ограничение.Текст =
	"РазрешитьЧтениеИзменение
	|ГДЕ
	|	ЗначениеРазрешено(Магазин)";

КонецПроцедуры

// Определяет настройки объекта для подсистемы ВерсионированиеОбъектов.
//
// Параметры:
//  Настройки - Структура - настройки подсистемы.
//
Процедура ПриОпределенииНастроекВерсионированияОбъектов(Настройки) Экспорт
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция РасшифровкаПлатежа(ДокументСсылка)
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	РегистрацияБезналичнойОплатыРасшифровкаПлатежа.СтатьяДвиженияДенежныхСредств КАК СтатьяДвиженияДенежныхСредств,
	|	РегистрацияБезналичнойОплатыРасшифровкаПлатежа.ДокументРасчетовСКонтрагентом КАК ДокументРасчетовСКонтрагентом,
	|	РегистрацияБезналичнойОплатыРасшифровкаПлатежа.Сумма КАК Сумма,
	|	РегистрацияБезналичнойОплатыРасшифровкаПлатежа.ПризнакСпособаРасчета КАК ПризнакСпособаРасчета
	|ИЗ
	|	Документ.РегистрацияБезналичнойОплаты.РасшифровкаПлатежа КАК РегистрацияБезналичнойОплатыРасшифровкаПлатежа
	|ГДЕ
	|	РегистрацияБезналичнойОплатыРасшифровкаПлатежа.Ссылка = &ДокументСсылка";
	
	Запрос.УстановитьПараметр("ДокументСсылка", ДокументСсылка);
	Результат = Запрос.Выполнить();
	Возврат Результат.Выгрузить();
	
КонецФункции

#Область ОбновлениеИнформационнойБазы

Процедура ПерезаполнитьСистемуНалогообложения(Параметры) Экспорт

	МетаданныеДокумента = Метаданные.Документы.РегистрацияБезналичнойОплаты;
	ПолноеИмяОбъекта = МетаданныеДокумента.ПолноеИмя();
	
	Выборка = ОбновлениеИнформационнойБазы.ВыбратьСсылкиДляОбработки(Параметры.Очередь, ПолноеИмяОбъекта);
	
	ОбновлениеИнформационнойБазыРТ.ЗаполнитьСистемыНалогообложенияДокументов(ПолноеИмяОбъекта, Выборка, Параметры);
	
КонецПроцедуры

Процедура ЗарегистрироватьДанныеКЗаполнениюСНО(Параметры) Экспорт
	
	МетаданныеДокумента = Метаданные.Документы.РегистрацияБезналичнойОплаты;
	ПолноеИмяОбъекта = МетаданныеДокумента.ПолноеИмя();
	
	ДокументыДляОбработки = ОбновлениеИнформационнойБазыРТ.ДокументыДляЗаполненияСНО(ПолноеИмяОбъекта);
	ОбновлениеИнформационнойБазы.ОтметитьКОбработке(Параметры, ДокументыДляОбработки);
	
КонецПроцедуры

Процедура ПерезаполнитьБанковскийСчетОрганизации(Параметры) Экспорт
	
	МетаданныеДокумента = Метаданные.Документы.РегистрацияБезналичнойОплаты;
	ПолноеИмяОбъекта = МетаданныеДокумента.ПолноеИмя();
	
	#Если НЕ ТолстыйКлиентУправляемоеПриложение Тогда
		
		Выборка = ОбновлениеИнформационнойБазы.ВыбратьСсылкиДляОбработки(Параметры.Очередь, ПолноеИмяОбъекта);
		МодульОбновлениеИнформационнойБазыРТ = ОбщегоНазначения.ОбщийМодуль("ОбновлениеИнформационнойБазыРТ");
		МодульОбновлениеИнформационнойБазыРТ.ЗаполнитьБанковскийСчетОрганизацииОбъектов(ПолноеИмяОбъекта, "БанковскийСчетОрганизации", Выборка, Параметры);
		
	#КонецЕсли
	
КонецПроцедуры

Процедура ЗарегистрироватьДанныеКЗаполнениюБСО(Параметры) Экспорт
	
	МетаданныеДокумента = Метаданные.Документы.РегистрацияБезналичнойОплаты;
	ПолноеИмяОбъекта = МетаданныеДокумента.ПолноеИмя();
	
	#Если НЕ ТолстыйКлиентУправляемоеПриложение Тогда
		
		МодульОбновлениеИнформационнойБазыРТ = ОбщегоНазначения.ОбщийМодуль("ОбновлениеИнформационнойБазыРТ");
		ДокументыДляОбработки = МодульОбновлениеИнформационнойБазыРТ.ОбъектыДляЗаполненияБанковскогоСчетаОрганизации(ПолноеИмяОбъекта, "БанковскийСчетОрганизации");
		ОбновлениеИнформационнойБазы.ОтметитьКОбработке(Параметры, ДокументыДляОбработки);
		
	#КонецЕсли
	
КонецПроцедуры

#КонецОбласти

Функция ТекстЗапросаТаблицаДенежныеСредстваБезналичные()
	
	ТекстЗапроса = 
	"ВЫБРАТЬ
	|	&Период КАК Период,
	|	ВЫБОР
	|		КОГДА &ХозяйственнаяОперация В (&ХозяйственныеОперацииПоступление)
	|			ТОГДА ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)
	|		ИНАЧЕ ЗНАЧЕНИЕ(ВидДвиженияНакопления.Расход)
	|	КОНЕЦ КАК ВидДвижения,
	|	&Организация КАК Организация,
	|	&БанковскийСчетОрганизации КАК БанковскийСчет,
	|	&Магазин КАК Магазин,
	|	РегистрацияБезналичнойОплатыРасшифровкаПлатежа.СтатьяДвиженияДенежныхСредств КАК СтатьяДвиженияДенежныхСредств,
	|	РегистрацияБезналичнойОплатыРасшифровкаПлатежа.Сумма КАК Сумма
	|ИЗ
	|	Документ.РегистрацияБезналичнойОплаты.РасшифровкаПлатежа КАК РегистрацияБезналичнойОплатыРасшифровкаПлатежа
	|ГДЕ
	|	РегистрацияБезналичнойОплатыРасшифровкаПлатежа.Ссылка = &Ссылка
	|	И &УчетБезналичныхДС
	|	И &ДатаНачалаУчетаБезналичныхДС <= &Период
	|
	|УПОРЯДОЧИТЬ ПО
	|	РегистрацияБезналичнойОплатыРасшифровкаПлатежа.НомерСтроки";
	
	Возврат ТекстЗапроса;
	
КонецФункции

Функция ТекстЗапросаТаблицаРасчетыСКлиентами()
	
	ТекстЗапроса = 
		"ВЫБРАТЬ
		|	&Контрагент КАК Контрагент,
		|	&Магазин КАК Магазин,
		|	&Организация КАК Организация,
		|	ТабличнаяЧастьРасшифровкаПлатежа.НомерСтроки КАК НомерСтроки,
		|	&Период КАК Период,
		|	ВЫБОР
		|		КОГДА &ХозяйственнаяОперация = ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ПоступлениеОплатыОтКлиента)
		|			ТОГДА ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)
		|		ИНАЧЕ ЗНАЧЕНИЕ(ВидДвиженияНакопления.Расход)
		|	КОНЕЦ КАК ВидДвижения,
		|	ВЫБОР
		|		КОГДА ТабличнаяЧастьРасшифровкаПлатежа.ДокументРасчетовСКонтрагентом В (&МассивПустыхДокументовРасчета)
		|			ТОГДА ТабличнаяЧастьРасшифровкаПлатежа.Ссылка
		|		ИНАЧЕ ТабличнаяЧастьРасшифровкаПлатежа.ДокументРасчетовСКонтрагентом
		|	КОНЕЦ КАК ДокументРасчета,
		|	ВЫБОР
		|		КОГДА НЕ ТабличнаяЧастьРасшифровкаПлатежа.ДокументРасчетовСКонтрагентом В (&МассивПустыхДокументовРасчета)
		|				И (ТабличнаяЧастьРасшифровкаПлатежа.ДокументРасчетовСКонтрагентом ССЫЛКА Документ.ЧекККМ
		|					ИЛИ ТабличнаяЧастьРасшифровкаПлатежа.ДокументРасчетовСКонтрагентом ССЫЛКА Документ.РеализацияТоваров)
		|			ТОГДА ТабличнаяЧастьРасшифровкаПлатежа.ДокументРасчетовСКонтрагентом.ЗаказПокупателя
		|		ИНАЧЕ ТабличнаяЧастьРасшифровкаПлатежа.Ссылка.ДокументОснование
		|	КОНЕЦ КАК ЗаказПокупателя,
		|	ТабличнаяЧастьРасшифровкаПлатежа.Сумма КАК Сумма
		|ИЗ
		|	Документ.РегистрацияБезналичнойОплаты.РасшифровкаПлатежа КАК ТабличнаяЧастьРасшифровкаПлатежа
		|ГДЕ
		|	ТабличнаяЧастьРасшифровкаПлатежа.Ссылка = &Ссылка
		|	И &ФормироватьДвижения
		|	И (&ХозяйственнаяОперация = ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ПоступлениеОплатыОтКлиента)
		|			ИЛИ &ХозяйственнаяОперация = ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ВозвратОплатыКлиенту))";
	
	Возврат ТекстЗапроса;
	
КонецФункции

Функция ТекстЗапросаТаблицаРасчетыСПоставщиками()
	
	ТекстЗапроса = 
	"ВЫБРАТЬ
	|	ТаблицаОплата.НомерСтроки КАК НомерСтроки,
	|	&Период КАК Период,
	|	ВЫБОР
	|		КОГДА &ХозяйственнаяОперация = ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ОплатаПоставщику)
	|			ТОГДА ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)
	|		ИНАЧЕ ЗНАЧЕНИЕ(ВидДвиженияНакопления.Расход)
	|	КОНЕЦ КАК ВидДвижения,
	|	ВЫБОР
	|		КОГДА ТаблицаОплата.ДокументРасчетовСКонтрагентом ССЫЛКА Документ.ПоступлениеТоваров
	|			ТОГДА ВЫБОР
	|					КОГДА ТаблицаОплата.ДокументРасчетовСКонтрагентом.ЗаказПоставщику = ЗНАЧЕНИЕ(Документ.ЗаказПоставщику.ПустаяСсылка)
	|						ТОГДА ТаблицаОплата.ДокументРасчетовСКонтрагентом
	|					ИНАЧЕ ТаблицаОплата.ДокументРасчетовСКонтрагентом.ЗаказПоставщику
	|				КОНЕЦ
	|		КОГДА ТаблицаОплата.ДокументРасчетовСКонтрагентом ССЫЛКА Документ.ВозвратТоваровПоставщику
	|			ТОГДА ВЫБОР
	|					КОГДА ВЫРАЗИТЬ(ТаблицаОплата.ДокументРасчетовСКонтрагентом КАК Документ.ВозвратТоваровПоставщику).ДокументОснование <> ЗНАЧЕНИЕ(Документ.ПоступлениеТоваров.ПустаяСсылка)
	|						ТОГДА ВЫБОР
	|								КОГДА ВЫРАЗИТЬ(ТаблицаОплата.ДокументРасчетовСКонтрагентом КАК Документ.ВозвратТоваровПоставщику).ДокументОснование.ЗаказПоставщику <> ЗНАЧЕНИЕ(Документ.ЗаказПоставщику.ПустаяСсылка)
	|									ТОГДА ВЫРАЗИТЬ(ТаблицаОплата.ДокументРасчетовСКонтрагентом КАК Документ.ВозвратТоваровПоставщику).ДокументОснование.ЗаказПоставщику
	|								ИНАЧЕ ВЫРАЗИТЬ(ТаблицаОплата.ДокументРасчетовСКонтрагентом КАК Документ.ВозвратТоваровПоставщику).ДокументОснование
	|							КОНЕЦ
	|					ИНАЧЕ ТаблицаОплата.ДокументРасчетовСКонтрагентом
	|				КОНЕЦ
	|		ИНАЧЕ ТаблицаОплата.ДокументРасчетовСКонтрагентом
	|	КОНЕЦ КАК ДокументРасчета,
	|	&Контрагент КАК Поставщик,
	|	&Магазин КАК Магазин,
	|	ТаблицаОплата.Сумма КАК Сумма,
	|	ТаблицаОплата.Сумма КАК КОплате,
	|	ЗНАЧЕНИЕ(Перечисление.ФормыОплаты.Безналичная) КАК ФормаОплаты
	|ИЗ
	|	Документ.РегистрацияБезналичнойОплаты.РасшифровкаПлатежа КАК ТаблицаОплата
	|ГДЕ
	|	ТаблицаОплата.Ссылка = &Ссылка
	|	И &ФормироватьДвижения
	|	И (&ХозяйственнаяОперация = ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ОплатаПоставщику)
	|			ИЛИ &ХозяйственнаяОперация = ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ВозвратДенежныхСредствОтПоставщика))
	|
	|УПОРЯДОЧИТЬ ПО
	|	ТаблицаОплата.НомерСтроки";
	
	Возврат ТекстЗапроса;
		
КонецФункции

Функция ТекстЗапросаТаблицаДенежныеСредстваКВыплате()
	
	ТекстЗапроса = 
		"ВЫБРАТЬ
		|	&Период КАК Период,
		|	&ХозяйственнаяОперация КАК ХозяйственнаяОперация,
		|	ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход) КАК ВидДвижения,
		|	&ДокументОснование КАК РаспоряжениеНаРасходованиеДенежныхСредств,
		|	&Магазин КАК Магазин,
		|	Оплата.СтатьяДвиженияДенежныхСредств КАК СтатьяДвиженияДенежныхСредств,
		|	Оплата.ДокументРасчетовСКонтрагентом КАК ДокументРасчета,
		|	Оплата.Сумма КАК Сумма
		|ИЗ
		|	Документ.РегистрацияБезналичнойОплаты.РасшифровкаПлатежа КАК Оплата
		|ГДЕ
		|	Оплата.Ссылка = &Ссылка
		|	И &ПоРаспоряжению";
	
	Возврат ТекстЗапроса;
	
КонецФункции

#КонецОбласти

#КонецЕсли
