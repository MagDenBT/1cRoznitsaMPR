
#Область ПрограмныйИнтерфейс

Функция НастройкиИсточникаКешаЧека() Экспорт
	
	Результат = ПроверкаИПодборПродукцииИС.НастройкиИсточникаКешаШтрихкодовУпаковок();
	
	Результат.Штрихкоды =        "АкцизныеМарки";
	Результат.ШтрихкодУпаковки = "АкцизнаяМарка";
	Результат.ЧастичноеВыбытие = Истина;
	
	Возврат Результат;
	
КонецФункции

Процедура ПриЗакрытииФормыПроверкиИПодбораРМК(Форма, Результат, ВидПродукцииИС) Экспорт
	
	ДанныеПроверкиИПодбора = ПолучитьИзВременногоХранилища(Результат);
	
	ПараметрыСканирования = ШтрихкодированиеИС.ПараметрыСканирования(Форма);
	
	ПараметрыШтрихкодаДляОбработки = ШтрихкодированиеИСРТ.ПараметрыШтрихкодаДляОбработки(Форма, ПараметрыСканирования);
	ПараметрыШтрихкодаДляОбработки.Вставить("ВидПродукцииИС", ВидПродукцииИС);
	
	Если ИнтеграцияИСКлиентСерверПовтИсп.ПоддерживаетсяЧастичноеВыбытие(ВидПродукцииИС, ПараметрыСканирования.ВидОперацииИСМП) Тогда
		
		ШтрихкодыУпаковок = Новый Массив;
		
		Для Каждого ШтрихкодУпаковки Из ДанныеПроверкиИПодбора.ТаблицаШтрихкодовВерхнегоУровня Цикл
			
			НовыйЭлемент = ШтрихкодированиеИСМП.НовыйЭлементКоллекцииУпаковокДляРаспределенияПоТоварам();
			ЗаполнитьЗначенияСвойств(НовыйЭлемент, ШтрихкодУпаковки);
			
			ШтрихкодыУпаковок.Добавить(НовыйЭлемент);
			
		КонецЦикла;
	Иначе
		ШтрихкодыУпаковок = ДанныеПроверкиИПодбора.ТаблицаШтрихкодовВерхнегоУровня.ВыгрузитьКолонку("ШтрихкодУпаковки");
	КонецЕсли;
	
	РезультатРазбора = ШтрихкодированиеИС.ВложенныеШтрихкодыУпаковок(ШтрихкодыУпаковок, ПараметрыСканирования);
	
	ИнтеграцияИСРТ.ЗафиксироватьРезультатПроверкиИПодбора(РезультатРазбора.ДеревоУпаковок, ПараметрыШтрихкодаДляОбработки, Форма);
	
КонецПроцедуры

Функция АдресДанныхПроверкиМаркируемойПродукцииЧекККМ(ПараметрыСканирования, Объект, УникальныйИдентификатор, ВидМаркируемойПродукции) Экспорт
	
	ТаблицаШтрихкодов = Объект.АкцизныеМарки.Выгрузить();
	ШтрихкодыМаркируемойПродукции = ИнтеграцияИСРТ.ШтрихкодыСодержащиеВидыПродукции(
		ТаблицаШтрихкодов.ВыгрузитьКолонку("АкцизнаяМарка"), ВидМаркируемойПродукции);
	
	Если ИнтеграцияИСМПКлиентСерверПовтИсп.ПоддерживаетсяЧастичноеВыбытие(
		ВидМаркируемойПродукции,
		ПараметрыСканирования.ВидОперацииИСМП) Тогда
	
		МассивУпаковок    = Новый Массив();
		КэшИсходныхДанных = Новый Соответствие();
		
		Для Каждого ШтрихкодУпаковки Из ШтрихкодыМаркируемойПродукции Цикл
			
			НовыйЭлемент = ШтрихкодированиеИСМП.НовыйЭлементКоллекцииУпаковокДляРаспределенияПоТоварам();
			НовыйЭлемент.ШтрихкодУпаковки = ШтрихкодУпаковки;
			
			МассивУпаковок.Добавить(НовыйЭлемент);
			
			КэшИсходныхДанных.Вставить(ШтрихкодУпаковки, НовыйЭлемент);
			
		КонецЦикла;
	
		Для Каждого СтрокаТаблицы Из ТаблицаШтрихкодов Цикл
			
			ДанныеРезультата = КэшИсходныхДанных.Получить(СтрокаТаблицы.АкцизнаяМарка);
			Если ДанныеРезультата = Неопределено Тогда
				Продолжить;
			КонецЕсли;
			
			ДанныеРезультата.ЧастичноеВыбытиеКоличество     = СтрокаТаблицы.ЧастичноеВыбытиеКоличество;
			ДанныеРезультата.ЧастичноеВыбытиеВариантУчета   = СтрокаТаблицы.ЧастичноеВыбытиеВариантУчета;
			ДанныеРезультата.ЧастичноеВыбытиеНоменклатура   = СтрокаТаблицы.ЧастичноеВыбытиеНоменклатура;
			ДанныеРезультата.ЧастичноеВыбытиеХарактеристика = СтрокаТаблицы.ЧастичноеВыбытиеХарактеристика;
			
		КонецЦикла;
		
	Иначе
		
		МассивУпаковок = ШтрихкодыМаркируемойПродукции;
		
	КонецЕсли;
	
	ДанныеПроверяемогоДокумента = ШтрихкодированиеИС.ВложенныеШтрихкодыУпаковок(
		МассивУпаковок, ПараметрыСканирования);
	
	ТаблицаМаркируемойПродукции = ПроверкаИПодборПродукцииИСМП.ТаблицаМаркируемойПродукцииДокумента(Объект, ВидМаркируемойПродукции);

	ДанныеХранилища = Новый Структура("ДеревоУпаковок, МаркированныеТовары, ТаблицаМаркируемойПродукции",
		ДанныеПроверяемогоДокумента.ДеревоУпаковок,
		ДанныеПроверяемогоДокумента.МаркированныеТовары,
		ТаблицаМаркируемойПродукции);
	
	Возврат ПоместитьВоВременноеХранилище(ДанныеХранилища, УникальныйИдентификатор);
	
КонецФункции

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

// Возвращает через третий параметр признак наличия маркируемой продукции.
//
// Параметры:
//  Коллекция                - ДанныеФормыКоллекция - ТЧ с товарами.
//  ВидМаркируемойПродукции  - ПеречислениеСсылка.ВидыПродукцииИС - вид продукции, наличие которой необходимо определить.
//  ЕстьМаркируемаяПродукция - Булево - Исходящий, признак наличия маркируемой продукции.
Процедура ЕстьМаркируемаяПродукцияВКоллекции(Коллекция, ВидМаркируемойПродукции, ЕстьМаркируемаяПродукция) Экспорт
	
	ТекстЗапроса = "
	|ВЫБРАТЬ
	|	ТаблицаТовары.Номенклатура КАК Номенклатура
	|ПОМЕСТИТЬ
	|	ВремТаблТовары
	|ИЗ
	|	&ТаблицаТовары КАК ТаблицаТовары
	|;
	|
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ ПЕРВЫЕ 1
	|	ИСТИНА КАК ЕстьМаркируемаяПродукция
	|ИЗ
	|	ВремТаблТовары КАК ТаблицаТовары
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.Номенклатура КАК СправочникНоменклатура
	|		ПО ТаблицаТовары.Номенклатура = СправочникНоменклатура.Ссылка
	|ГДЕ
	|	&УсловиеМаркируемаяПродукция
	|";
	
	ИнтеграцияИСМПРТ.УстановитьУсловиеПоВидуМаркируемойПродукции(ТекстЗапроса, ВидМаркируемойПродукции);
	
	Запрос = Новый Запрос(ТекстЗапроса);
	Запрос.УстановитьПараметр("ТаблицаТовары", Коллекция.Выгрузить(, "Номенклатура"));
	Результат = Запрос.Выполнить();
	
	ЕстьМаркируемаяПродукция = НЕ Результат.Пустой();
	
КонецПроцедуры

// Возвращает через третий параметр таблицу товаров документа, являющихся маркируемой продукцией требуемого вида.
//
// Параметры:
//  * Контекст                 - УправляемаяФорма, ДокументСсылка - документ, маркируемую продукцию которого необходимо получить.
//  * ВидМаркируемойПродукции  - ПеречислениеСсылка.ВидыПродукцииИС - вид маркируемой продукции, которую необходимо получить.
//  * ТаблицаМаркируемойПродукции - ТаблицаЗначений - Исходящий, таблица с маркируемой продукцией документа. Должна содержать колонки:
//  ** GTIN           - Строка - GTIN продукции
//  ** Номенклатура   - ОпределяемыйТип.Номенклатура - номенклатура маркируемой продукции
//  ** Характеристика - ОпределяемыйТип.ХарактеристикаНоменклатуры - характеристика номенклатура маркируемой продукции
//  ** Серия          - ОпределяемыйТип.СерияНоменклатуры - серия номенклатура маркируемой продукции
//  ** Количество     - Число - количество маркируемой продукции
Процедура ПриОпределенииМаркируемойПродукцииДокумента(Контекст, ВидМаркируемойПродукции, ТаблицаМаркируемойПродукции) Экспорт
	
	Если ТаблицаМаркируемойПродукции.Количество() > 0 Тогда
		РезультатЗапроса = ЗапросGTINпоТаблицеМаркируемойПродукции(ВидМаркируемойПродукции, ТаблицаМаркируемойПродукции);
		ТаблицаМаркируемойПродукции.Очистить();
	ИначеЕсли ТипЗнч(Контекст) = Тип("ДанныеФормыСтруктура") Тогда
		РезультатЗапроса = ЗапросМаркируемойПродукцииДанныеФормыСтруктура(Контекст, ВидМаркируемойПродукции);
	ИначеЕсли ИнтеграцияИСРТКлиентСервер.ЭтоДокументПоНаименованию(Контекст, "ПоступлениеТоваров") Тогда
		РезультатЗапроса = ЗапросМаркируемойПродукцииПоступлениеТоваров(Контекст, ВидМаркируемойПродукции);
	ИначеЕсли ИнтеграцияИСРТКлиентСервер.ЭтоДокументПоНаименованию(Контекст, "ЧекККМ")
		ИЛИ ИнтеграцияИСРТКлиентСервер.ЭтоДокументПоНаименованию(Контекст, "ПеремещениеТоваров") Тогда
		РезультатЗапроса = ЗапросМаркируемойПродукцииЧекККМ(Контекст, ВидМаркируемойПродукции);
	ИначеЕсли ИнтеграцияИСРТКлиентСервер.ЭтоДокументПоНаименованию(Контекст, "ВозвратТоваровПоставщику") Тогда
		РезультатЗапроса = ЗапросМаркируемойПродукцииВозвратТоваровПоставщику(Контекст, ВидМаркируемойПродукции);
	ИначеЕсли ИнтеграцияИСРТКлиентСервер.ЭтоДокументПоНаименованию(Контекст, "ВозвратТоваровОтПокупателя") Тогда
		РезультатЗапроса = ЗапросМаркируемойПродукцииВозвратТоваровОтПокупателя(Контекст, ВидМаркируемойПродукции);
	Иначе
		Возврат;
	КонецЕсли;
	
	ВыборкаНоменклатура = РезультатЗапроса.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	Пока ВыборкаНоменклатура.Следующий() Цикл
		ВыборкаХарактеристика = ВыборкаНоменклатура.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
		Пока ВыборкаХарактеристика.Следующий() Цикл
			ПродукцияПоGTIN = ТаблицаМаркируемойПродукции.СкопироватьКолонки();
			СписокКодовGTIN = Новый Массив;
			
			ВыборкаGTIN = ВыборкаХарактеристика.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
			Пока ВыборкаGTIN.Следующий() Цикл
				
				Если Не ЗначениеЗаполнено(ВыборкаНоменклатура.Номенклатура) Тогда
					// Соответственно тут должен быть остаточный GTIN
					Выборка = ВыборкаGTIN.Выбрать();
					Пока Выборка.Следующий() Цикл
						ЗаполнитьЗначенияСвойств(ТаблицаМаркируемойПродукции.Добавить(), Выборка);
					КонецЦикла;
					Продолжить;
				КонецЕсли;
				
				Если ПродукцияПоGTIN.Количество() = 0 Тогда
					Выборка = ВыборкаGTIN.Выбрать();
					Пока Выборка.Следующий() Цикл
						ЗаполнитьЗначенияСвойств(ПродукцияПоGTIN.Добавить(), Выборка,, "GTIN");
					КонецЦикла;
				КонецЕсли;
				
				Если МенеджерОборудованияКлиентСервер.ПроверитьКорректностьGTIN(ВыборкаGTIN.GTIN) Тогда
					GTIN = ШтрихкодированиеИСКлиентСервер.GTINПоШтрихкодуEAN(ВыборкаGTIN.GTIN);
					СписокКодовGTIN.Добавить(GTIN);
				КонецЕсли;
			КонецЦикла;
			
			Для Каждого СтрокаПродукцииПоGTIN Из ПродукцияПоGTIN Цикл
				ЗаполнитьЗначенияСвойств(ТаблицаМаркируемойПродукции.Добавить(), СтрокаПродукцииПоGTIN);
				СтрокаПродукцииПоGTIN.КодыGTIN.ЗагрузитьЗначения(СписокКодовGTIN);
			КонецЦикла;
		КонецЦикла;
	КонецЦикла;
	
КонецПроцедуры

// Предназначена для реализации функциональности по отражению результатов проверки и подбора в документе, из которого была вызвана соответствующая форма.
// 
// Параметры:
//  ПараметрыОкончанияПроверки - (См. ПроверкаИПодборИСМП.ЗафиксироватьРезультатПроверкиИПодбора).
Процедура ОтразитьРезультатыСканированияВДокументе(ПараметрыОкончанияПроверки) Экспорт
	
	ИнтеграцияИСМПРТ.ОтразитьРезультатыСканированияВДокументе(ПараметрыОкончанияПроверки);
	
КонецПроцедуры

// Получает сформированный ранее Акт о расхождениях для переданного документа.
// 
// Параметры:
//  Документ         - ДокументСсылка - ссылка на документ, для которого необходимо получить Акт о расхождениях:
//  АктОРасхождениях - ДокументСсылка - ссылка на Акт о расхождениях:
Процедура ПолучитьСформированныйАктОРасхождениях(Документ, АктОРасхождениях) Экспорт
	
	АктОРасхождениях = ИнтеграцияИСМПРТ.СформированныйАктОРасхождениях(Документ);
	
КонецПроцедуры

// Заполняет в табличной части служебные реквизиты, например: признак использования характеристик номенклатуры.
//
// Параметры:
//  Форма          - УправляемаяФорма - Форма.
//  ТабличнаяЧасть - ДанныеФормыКоллекция, ТаблицаЗначений - таблица для заполнения.
Процедура ЗаполнитьСлужебныеРеквизитыВКоллекции(Форма, ТабличнаяЧасть) Экспорт
	
	
КонецПроцедуры

// Устанавливает режим просмотра (доступности, для команд) элементам формы.
//   Переопределение необходимо использовать для совместной работы с аналогичными механизмами.
//   Обработанные здесь реквизиты мледует удалить из массива "Блокируемые элементы".
// 
// Параметры:
//  Форма               - УправляемаяФорма - форма в которой производится изменение доступности
//  БлокируемыеЭлементы - Массив - наименования реквизитов
//  Заблокировать       - Булево - заблокировать или разблокировать реквизиты
Процедура УстановитьТолькоПросмотрЭлементов(
		Форма,
		БлокируемыеЭлементы,
		Заблокировать) Экспорт
	
	
КонецПроцедуры

#Область СерииНоменклатуры

// Предназначена для расчета статусов указания серий во всех строках таблицы товаров
//
// Параметры:
//  Форма        - УправляемаяФорма - форма с таблицей товаров
//  ТекстЗапроса - Строка - текст запроса для расчета статусов указания серий
Процедура ЗаполнитьСтатусыУказанияСерий(Форма, ПараметрыУказанияСерий) Экспорт
	
	Если Не ПараметрыУказанияСерий.Свойство("ИспользоватьСерииНоменклатуры") Тогда 
		Возврат;
	КонецЕсли;
	
	Если Форма.ИмяФормы = "Обработка.ПроверкаИПодборТабачнойПродукцииМОТП.Форма.ПроверкаИПодбор" Тогда 
		ПараметрыУказанияСерий.ИспользоватьСерииНоменклатуры = Ложь;
	КонецЕсли;
	
КонецПроцедуры

// Возвращает через параметр наличие права на добавление элементов справочника СерииНоменклатуры
//
// Параметры:
//  ПравоДобавлениеСерий - Булево - исходящий, наличие права на добавление.
Процедура ОпределитьПравоДобавлениеСерий(ПравоДобавлениеСерий) Экспорт
	
	ПравоДобавлениеСерий = ПравоДоступа("Добавление", Метаданные.Справочники.СерииНоменклатуры);
	
КонецПроцедуры

#КонецОбласти

#Область ПараметрыИнтеграцииФормыПроверкиИПодбора

// Заполняет специфику интеграции формы проверки и подбора в конкретную форму.
//
// Параметры:
//  Форма - УправляемаяФорма - форма для которой настраиваются параметры интеграции.
//  ПараметрыИнтеграции - (См.ПроверкаИПодборПродукцииИС.ПараметрыИнтеграцииФормПроверкиИПодбора).
//  ВидПродукции - Перечислениессылка.ВидыПродукцииИС - вид продукции для которого проводится встраивание
//
Процедура ПриОпределенииПараметровИнтеграцииФормыПроверкиИПодбора(Форма, ПараметрыИнтеграции, ВидПродукции = Неопределено) Экспорт
	
	Если Форма.ИмяФормы = "Документ.ЧекККМ.Форма.ФормаДокумента"
		ИЛИ Форма.ИмяФормы = "Обработка.РМКУправляемыйРежим.Форма.Форма" Тогда

		ПараметрыИнтеграции.ИспользоватьКолонкуСтатусаПроверкиПодбора  = Истина;
		ПараметрыИнтеграции.ИспользоватьСтатусПроверкиПодбораДокумента = Ложь;
		ПараметрыИнтеграции.ОтображатьОшибкиПроверкиСредствамиККТ      = Истина;
		ПараметрыИнтеграции.ИмяТабличнойЧастиШтрихкодыУпаковок         = "АкцизныеМарки";
		ПараметрыИнтеграции.ИмяКолонкиШтрихкодУпаковки                 = "АкцизнаяМарка";
		ПараметрыИнтеграции.ДоступноЧастичноеВыбытие                   = Истина;
		
	ИначеЕсли Форма.ИмяФормы = "Документ.ПоступлениеТоваров.Форма.ФормаДокумента" Тогда
		ДокументСвязанСПриемкойТоваровИСМП                             = ИнтеграцияИСМПРТ.ДокументСвязанСПриемкойТоваровИСМП(Форма.Объект.Ссылка);
		ПараметрыИнтеграции.РазмещатьЭлементыИнтерфейса                = Не ДокументСвязанСПриемкойТоваровИСМП;
		ПараметрыИнтеграции.ЕстьПравоИзменение                         = ПравоДоступа("Изменение", Метаданные.Документы.ПоступлениеТоваров);
		ПараметрыИнтеграции.ЭтоДокументПриобретения                    = Истина;
		ПараметрыИнтеграции.ЕстьЭлектронныйДокумент                    = ЭлектронноеВзаимодействиеИСМП.ДокументСвязанСЭлектронным(Форма.Объект.Ссылка);
		ПараметрыИнтеграции.ИспользоватьКолонкуСтатусаПроверкиПодбора  = Не ПараметрыИнтеграции.ЕстьЭлектронныйДокумент И Не ДокументСвязанСПриемкойТоваровИСМП;
		ПараметрыИнтеграции.БлокироватьТабличнуюЧастьТоварыПриПроверке = ПараметрыИнтеграции.ЕстьЭлектронныйДокумент;
		ПараметрыИнтеграции.ИспользоватьСтатусПроверкаЗавершена        = ПараметрыИнтеграции.ЕстьЭлектронныйДокумент;
		
	ИначеЕсли Форма.ИмяФормы = "Документ.РеализацияТоваров.Форма.ФормаДокумента"
		ИЛИ Форма.ИмяФормы = "Документ.ВозвратТоваровПоставщику.Форма.ФормаДокумента" Тогда
		
		ПараметрыИнтеграции.РазмещатьЭлементыИнтерфейса                = Истина;
		ПараметрыИнтеграции.ИспользоватьКолонкуСтатусаПроверкиПодбора  = Истина;
		ПараметрыИнтеграции.ИспользоватьБезМаркируемойПродукции        = Истина;
		ПараметрыИнтеграции.ИспользоватьСтатусПроверкаЗавершена        = Ложь;
		ПараметрыИнтеграции.ЕстьПравоИзменение                         = ПравоДоступа("Изменение", Форма.Объект.Ссылка.Метаданные());
		
	ИначеЕсли Форма.ИмяФормы = "Документ.ПеремещениеТоваров.Форма.ФормаДокумента" Тогда
		
		ПараметрыИнтеграции.ИспользоватьКолонкуСтатусаПроверкиПодбора  = Истина;
		ПараметрыИнтеграции.ИспользоватьСтатусПроверкиПодбораДокумента = Ложь;
		
		ПараметрыИнтеграции.ИмяТабличнойЧастиШтрихкодыУпаковок         = "АкцизныеМарки";
		ПараметрыИнтеграции.ИмяКолонкиШтрихкодУпаковки                 = "АкцизнаяМарка";
		
	ИначеЕсли Форма.ИмяФормы = "Документ.ВозвратТоваровОтПокупателя.Форма.ФормаДокумента" Тогда
		
		ПараметрыИнтеграции.РазмещатьЭлементыИнтерфейса                = Истина;
		ПараметрыИнтеграции.БлокироватьТабличнуюЧастьТоварыПриПроверке = Ложь;
		ПараметрыИнтеграции.ЕстьПравоИзменение                         = ПравоДоступа("Изменение", Метаданные.Документы.ВозвратТоваровОтПокупателя);
		ПараметрыИнтеграции.ЭтоДокументПриобретения                    = Истина;
		ПараметрыИнтеграции.ЕстьЭлектронныйДокумент                    = Ложь;
		ПараметрыИнтеграции.ИспользоватьКолонкуСтатусаПроверкиПодбора  = Истина;
		ПараметрыИнтеграции.ИмяСледующейКолонки                        = "ТоварыНомерСтроки";
		ПараметрыИнтеграции.ИспользоватьСтатусПроверкаЗавершена        = Ложь;
		ПараметрыИнтеграции.ДоступноЧастичноеВыбытие                   = Истина;
		
	КонецЕсли;
	
КонецПроцедуры

// Заполняет специфику применения интеграции формы проверки и подбора в конкретную форму.
//
// Параметры:
//  Форма - УправляемаяФорма - форма для которой применяются параметры интеграции.
//
Процедура ПриПримененииПараметровИнтеграцииФормыПроверкиИПодбора(Форма) Экспорт
	
	Возврат;
	
КонецПроцедуры

#КонецОбласти

#Область РаботаСТСД

// См. ПроверкаИПодборПродукцииИСМППереопределяемый.РаспознатьШтрихкоды
//
Процедура РаспознатьШтрихкоды(ТаблицаНеАкцизныеМарки) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = "
	|ВЫБРАТЬ
	|	ШтриховыеКоды.ШтриховойКод КАК ШтриховойКод,
	|	ШтриховыеКоды.Количество   КАК Количество,
	|	ШтриховыеКоды.НомерСтроки  КАК НомерСтроки,
	|	ШтриховыеКоды.Родитель     КАК Родитель
	|ПОМЕСТИТЬ Штрихкоды
	|ИЗ
	|	&ШтриховыеКоды КАК ШтриховыеКоды
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	Штрихкоды.ШтриховойКод                                  КАК ШтриховойКод,
	|	Штрихкоды.Количество                                    КАК Количество,
	|	Штрихкоды.Родитель                                      КАК Родитель,
	|	Штрихкоды.НомерСтроки                                   КАК НомерСтроки,
	|	ЕСТЬNULL(ШтрихкодыУпаковокТоваров.Ссылка, Неопределено) КАК ШтрихКодУпаковки,
	|	ШтрихкодыНоменклатуры.Штрихкод ЕСТЬ NULL
	|		И ШтрихкодыУпаковокТоваров.Ссылка ЕСТЬ NULL         КАК ЭтоУпаковка
	|ИЗ
	|	Штрихкоды КАК Штрихкоды
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ШтрихкодыУпаковокТоваров КАК ШтрихкодыУпаковокТоваров
	|		ПО Штрихкоды.ШтриховойКод = ШтрихкодыУпаковокТоваров.ЗначениеШтрихкода
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.Штрихкоды КАК ШтрихкодыНоменклатуры
	|		ПО Штрихкоды.ШтриховойКод = ШтрихкодыНоменклатуры.Штрихкод
	|УПОРЯДОЧИТЬ ПО
	|	НомерСтроки";
	
	Запрос.УстановитьПараметр("ШтриховыеКоды", ТаблицаНеАкцизныеМарки);
	
	ТаблицаНеАкцизныеМарки = Запрос.Выполнить().Выгрузить();

КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции
#Область ЗаполнениеМаркируемойПродукцииДокумента

Функция ЗапросGTINпоТаблицеМаркируемойПродукции(ВидМаркируемойПродукции, ТаблицаМаркируемойПродукции)
	
	ПоляВЫБРАТЬ = Новый Массив;
	ПоляБезGTIN = Новый Массив;
	Для Каждого Колонка Из ТаблицаМаркируемойПродукции.Колонки Цикл
		Если Колонка.Имя <> "КодыGTIN"
				И Колонка.Имя <> "ИдентификаторыПроисхожденияВЕТИС" Тогда
			ПоляВЫБРАТЬ.Добавить(СтрШаблон("МаркируемаяПродукция.%1 КАК %1", Колонка.Имя));
			Если Колонка.Имя <> "GTIN" Тогда
				ПоляБезGTIN.Добавить(СтрШаблон("МаркируемаяПродукция.%1 КАК %1", Колонка.Имя));
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	&ПоляВЫБРАТЬ
	|ПОМЕСТИТЬ ВТМаркируемаяПродукция
	|ИЗ
	|	&МаркируемаяПродукция КАК МаркируемаяПродукция
	|;
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ЕСТЬNULL(ШтрихкодыНоменклатуры.Штрихкод, """") КАК GTIN,
	|	&ПоляБезGTIN
	|ИЗ
	|	ВТМаркируемаяПродукция КАК МаркируемаяПродукция
	|	ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.Штрихкоды КАК ШтрихкодыНоменклатуры
	|		ПО МаркируемаяПродукция.Номенклатура = ШтрихкодыНоменклатуры.Владелец
	|		 И МаркируемаяПродукция.Характеристика = ШтрихкодыНоменклатуры.Характеристика
	|ГДЕ
	|	МаркируемаяПродукция.Номенклатура <> Значение(Справочник.Номенклатура.ПустаяСсылка)
	|	И МаркируемаяПродукция.GTIN = """"
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ // Номенклатура не заполнена только для строк с остаточными GTIN
	|	&ПоляВЫБРАТЬ
	|ИЗ
	|	ВТМаркируемаяПродукция КАК МаркируемаяПродукция
	|ГДЕ
	|	МаркируемаяПродукция.Номенклатура = Значение(Справочник.Номенклатура.ПустаяСсылка)
	|	И МаркируемаяПродукция.GTIN <> """"
	|ИТОГИ ПО
	|	Номенклатура,
	|	Характеристика,
	|	GTIN";
	
	Запрос = Новый Запрос(ТекстЗапроса);
	Запрос.УстановитьПараметр("МаркируемаяПродукция", ТаблицаМаркируемойПродукции);
	Запрос.Текст = СтрЗаменить(Запрос.Текст, "&ПоляВЫБРАТЬ", СтрСоединить(ПоляВЫБРАТЬ, ",
	|"));
	Запрос.Текст = СтрЗаменить(Запрос.Текст, "&ПоляБезGTIN", СтрСоединить(ПоляБезGTIN, ",
	|"));
	
	Возврат Запрос.Выполнить();
	
КонецФункции

Функция ЗапросМаркируемойПродукцииДанныеФормыСтруктура(ДанныеФормыСтруктура, ВидМаркируемойПродукции, ИмяКоллекции = "Товары")
	
	Возврат ЗапросМаркируемойПродукцииДанныеФормыКоллекция(ДанныеФормыСтруктура[ИмяКоллекции], ВидМаркируемойПродукции);
	
КонецФункции

Функция ЗапросМаркируемойПродукцииДанныеФормыКоллекция(ДанныеФормыКоллекция, ВидМаркируемойПродукции)
	
	ТекстЗапроса = "
	|ВЫБРАТЬ
	|	Товары.Номенклатура   КАК Номенклатура,
	|	Товары.Характеристика КАК Характеристика,
	|	ЗНАЧЕНИЕ(Справочник.СерииНоменклатуры.Пустаяссылка) КАК Серия,
	|	Товары.Количество     КАК Количество
	|ПОМЕСТИТЬ ВТ_Товары
	|ИЗ
	|	&Товары КАК Товары
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВТ_Товары.Номенклатура      КАК Номенклатура,
	|	ВТ_Товары.Характеристика    КАК Характеристика,
	|	ВТ_Товары.Серия             КАК Серия,
	|	СУММА(ВТ_Товары.Количество) КАК Количество
	|ПОМЕСТИТЬ ВТ_МаркируемаяПродукция
	|ИЗ
	|	ВТ_Товары КАК ВТ_Товары
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.Номенклатура КАК СправочникНоменклатура
	|		ПО ВТ_Товары.Номенклатура = СправочникНоменклатура.Ссылка
	|ГДЕ
	|	&УсловиеМаркируемаяПродукция
	|СГРУППИРОВАТЬ ПО
	|	ВТ_Товары.Номенклатура,
	|	ВТ_Товары.Характеристика,
	|	ВТ_Товары.Серия
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ЕСТЬNULL(ШтрихкодыНоменклатуры.Штрихкод, """") КАК GTIN,
	|	МаркируемаяПродукция.Номенклатура              КАК Номенклатура,
	|	МаркируемаяПродукция.Характеристика            КАК Характеристика,
	|	МаркируемаяПродукция.Серия                     КАК Серия,
	|	МаркируемаяПродукция.Количество                КАК Количество
	|ИЗ
	|	ВТ_МаркируемаяПродукция КАК МаркируемаяПродукция
	|	ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.Штрихкоды КАК ШтрихкодыНоменклатуры
	|		ПО МаркируемаяПродукция.Номенклатура = ШтрихкодыНоменклатуры.Владелец
	|		 И МаркируемаяПродукция.Характеристика = ШтрихкодыНоменклатуры.Характеристика
	|ИТОГИ ПО
	|	Номенклатура,
	|	Характеристика,
	|	GTIN
	|";
	
	ИнтеграцияИСМПРТ.УстановитьУсловиеПоВидуМаркируемойПродукции(ТекстЗапроса, ВидМаркируемойПродукции);

	Запрос = Новый Запрос(ТекстЗапроса);
	Запрос.УстановитьПараметр("Товары", ДанныеФормыКоллекция.Выгрузить());
	
	Возврат Запрос.Выполнить();
	
КонецФункции

Функция ЗапросМаркируемойПродукцииПоступлениеТоваров(Документ, ВидМаркируемойПродукции)
	
	ТекстЗапроса = "ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ЕСТЬNULL(ШтрихкодыНоменклатуры.Штрихкод, """") КАК GTIN,
	|	Товары.Номенклатура КАК Номенклатура,
	|	Товары.Характеристика КАК Характеристика,
	|	ЕСТЬNULL(Серии.Серия, ЗНАЧЕНИЕ(Справочник.СерииНоменклатуры.Пустаяссылка)) КАК Серия,
	|	ЕСТЬNULL(Серии.Количество, Товары.Количество) КАК Количество
	|ИЗ
	|	Документ.ПоступлениеТоваров.Товары КАК Товары
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.ПоступлениеТоваров.Серии КАК Серии
	|		ПО Товары.Ссылка = Серии.Ссылка
	|			И Товары.Номенклатура = Серии.Номенклатура
	|			И Товары.Характеристика = Серии.Характеристика
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.Номенклатура КАК СправочникНоменклатура
	|		ПО Товары.Номенклатура = СправочникНоменклатура.Ссылка
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.Штрихкоды КАК ШтрихкодыНоменклатуры
	|		ПО Товары.Номенклатура = ШтрихкодыНоменклатуры.Владелец
	|			И Товары.Характеристика = ШтрихкодыНоменклатуры.Характеристика
	|ГДЕ
	|	Товары.Ссылка = &ДокументСсылка
	|	И &УсловиеМаркируемаяПродукция
	|ИТОГИ ПО
	|	Номенклатура,
	|	Характеристика,
	|	GTIN";
	
	ИнтеграцияИСМПРТ.УстановитьУсловиеПоВидуМаркируемойПродукции(ТекстЗапроса, ВидМаркируемойПродукции);
	
	Запрос = Новый Запрос(ТекстЗапроса);
	Запрос.УстановитьПараметр("ДокументСсылка", Документ);
	
	Возврат Запрос.Выполнить();
	
КонецФункции


Функция ЗапросМаркируемойПродукцииЧекККМ(ФормаОбъект, ВидМаркируемойПродукции)
	
	Если ТипЗнч(ФормаОбъект) = Тип("ФормаКлиентскогоПриложения") Тогда
		Товары = ФормаОбъект.Объект.Товары;
	Иначе
		Товары = ФормаОбъект.Товары;
	КонецЕсли;
	
	Возврат ЗапросМаркируемойПродукцииДанныеФормыКоллекция(Товары, ВидМаркируемойПродукции);
	
КонецФункции


Функция ЗапросМаркируемойПродукцииВозвратТоваровПоставщику(Документ, ВидМаркируемойПродукции)
	
	ТекстЗапроса = "ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ЕСТЬNULL(ШтрихкодыНоменклатуры.Штрихкод, """") КАК GTIN,
	|	Товары.Номенклатура КАК Номенклатура,
	|	Товары.Характеристика КАК Характеристика,
	|	ЕСТЬNULL(Серии.Серия, ЗНАЧЕНИЕ(Справочник.СерииНоменклатуры.ПустаяСсылка)) КАК Серия,
	|	ЕСТЬNULL(Серии.Количество, Товары.Количество) КАК Количество
	|ИЗ
	|	Документ.ВозвратТоваровПоставщику.Товары КАК Товары
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.ВозвратТоваровПоставщику.Серии КАК Серии
	|		ПО Товары.Ссылка = Серии.Ссылка
	|			И Товары.Номенклатура = Серии.Номенклатура
	|			И Товары.Характеристика = Серии.Характеристика
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.Номенклатура КАК СправочникНоменклатура
	|		ПО Товары.Номенклатура = СправочникНоменклатура.Ссылка
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.Штрихкоды КАК ШтрихкодыНоменклатуры
	|		ПО Товары.Номенклатура = ШтрихкодыНоменклатуры.Владелец
	|			И Товары.Характеристика = ШтрихкодыНоменклатуры.Характеристика
	|ГДЕ
	|	Товары.Ссылка = &ДокументСсылка
	|	И &УсловиеМаркируемаяПродукция
	|ИТОГИ ПО
	|	Номенклатура,
	|	Характеристика,
	|	GTIN";
	
	ИнтеграцияИСМПРТ.УстановитьУсловиеПоВидуМаркируемойПродукции(ТекстЗапроса, ВидМаркируемойПродукции);
	
	Запрос = Новый Запрос(ТекстЗапроса);
	Запрос.УстановитьПараметр("ДокументСсылка", Документ);
	
	Возврат Запрос.Выполнить();
	
КонецФункции


Функция ЗапросМаркируемойПродукцииВозвратТоваровОтПокупателя(Документ, ВидМаркируемойПродукции)
	
	ТекстЗапроса = "ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ЕСТЬNULL(ШтрихкодыНоменклатуры.Штрихкод, """") КАК GTIN,
	|	Товары.Номенклатура КАК Номенклатура,
	|	Товары.Характеристика КАК Характеристика,
	|	ЕСТЬNULL(Серии.Серия, ЗНАЧЕНИЕ(Справочник.СерииНоменклатуры.ПустаяСсылка)) КАК Серия,
	|	ЕСТЬNULL(Серии.Количество, Товары.Количество) КАК Количество
	|ИЗ
	|	Документ.ВозвратТоваровОтПокупателя.Товары КАК Товары
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.ВозвратТоваровОтПокупателя.Серии КАК Серии
	|		ПО Товары.Ссылка = Серии.Ссылка
	|			И Товары.Номенклатура = Серии.Номенклатура
	|			И Товары.Характеристика = Серии.Характеристика
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.Номенклатура КАК СправочникНоменклатура
	|		ПО Товары.Номенклатура = СправочникНоменклатура.Ссылка
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.Штрихкоды КАК ШтрихкодыНоменклатуры
	|		ПО Товары.Номенклатура = ШтрихкодыНоменклатуры.Владелец
	|			И Товары.Характеристика = ШтрихкодыНоменклатуры.Характеристика
	|ГДЕ
	|	Товары.Ссылка = &ДокументСсылка
	|	И &УсловиеМаркируемаяПродукция
	|ИТОГИ ПО
	|	Номенклатура,
	|	Характеристика,
	|	GTIN";
	
	ИнтеграцияИСМПРТ.УстановитьУсловиеПоВидуМаркируемойПродукции(ТекстЗапроса, ВидМаркируемойПродукции);
	
	Запрос = Новый Запрос(ТекстЗапроса);
	Запрос.УстановитьПараметр("ДокументСсылка", Документ);
	
	Возврат Запрос.Выполнить();
	
КонецФункции

#КонецОбласти

#КонецОбласти
