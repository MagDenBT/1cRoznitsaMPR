////////////////////////////////////////////////////////////////////////////////
// ОбменСБанкамиКлиентСервер: механизм обмена электронными документами с банками.
//
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Формирует текст гиперссылки для размещения в форме элемента справочника БанковскиеСчетаОрганизации.
//
// Параметры:
//  Организация  - СправочникСсылка.Организации - организация, указанная в счете.
//  Банк  - СправочникСсылка.КлассификаторБанков - банк, указанный в счете.
//
// Возвращаемое значение:
//   Строка - текст для гиперссылки.
//
Функция ЗаголовокНастройкиОбменаСБанком(Знач Организация, Знач Банк) Экспорт
	
	ТекущаяНастройка = ОбменСБанкамиСлужебныйВызовСервера.НастройкаОбмена(Организация, Банк, Истина, Ложь);
	
	Если НЕ ЗначениеЗаполнено(ТекущаяНастройка) Тогда
		Возврат(НСтр("ru = 'Подключить сервис 1С:ДиректБанк'"));
	Иначе
		РеквизитыНастройкиОбмена = Новый Структура("Недействительна, ПометкаУдаления");
		ОбменСБанкамиСлужебныйВызовСервера.ПолучитьЗначенияРеквизитовНастройкиОбмена(
			ТекущаяНастройка, РеквизитыНастройкиОбмена);
		Если НЕ РеквизитыНастройкиОбмена.Недействительна И НЕ РеквизитыНастройкиОбмена.ПометкаУдаления Тогда
			Шаблон = НСтр("ru = 'Сервис 1С:ДиректБанк подключен'");
		Иначе
			Шаблон = НСтр("ru = 'Не подключен сервис 1С:ДиректБанк'");
		КонецЕсли;
		Возврат Шаблон;
	КонецЕсли
	
КонецФункции

// Управляет видимостью и содержанием контекстной рекламы 1С:ДиректБанк.
// 
// Параметры:
//  ГруппаРекламы - ГруппаФормы - группа элементов контекстной рекламы;
//  ДекорацияТекстРекламы - ДекорацияФормы - декорация, в заголовке которой отображается текст рекламы.
// 
Процедура ПоказатьРекламуДиректБанк(ГруппаРекламы, ДекорацияТекстРекламы) Экспорт
	
	КоличествоБанков = ОбменСБанкамиСлужебныйВызовСервера.КоличествоБанковДляПодключенияДиректБанк();
	
	Если КоличествоБанков = 0 Тогда
		ГруппаРекламы.Видимость = Ложь;
	Иначе
		Заголовок = СформироватьЗаголовокРекламыДиректБанк(КоличествоБанков);
		ДекорацияТекстРекламы.Заголовок = Заголовок;
		ГруппаРекламы.Видимость = Истина;
	КонецЕсли;
	
КонецПроцедуры

// Возвращает текст гиперссылки для открытия переписки с банками
// 
// Возвращаемое значение:
//  Строка - текст гиперссылки
//  Неопределено - нет настройки обмена с письмами. Гиперссылку не нужно выводить.
//
Функция ТекстСсылкиПерепискаСБанками() Экспорт
	
	ТекущееСостояниеПисемСБанками = ОбменСБанкамиСлужебныйВызовСервера.ТекущееСостояниеПисемСБанками();
	
	Если НЕ ТекущееСостояниеПисемСБанками.ЕстьПравоЧтенияДанных Тогда
		Возврат Неопределено;
	КонецЕсли;
		
	Если НЕ ТекущееСостояниеПисемСБанками.ЕстьНастройка Тогда
		Возврат Неопределено;
	ИначеЕсли ТекущееСостояниеПисемСБанками.КоличествоНепрочитанных = 0 Тогда
		Возврат НСтр("ru = 'Переписка с банками'");
	Иначе
		Шаблон = НСтр("ru = 'Переписка с банками (%1)'");
		Возврат СтрШаблон(Шаблон, ТекущееСостояниеПисемСБанками.КоличествоНепрочитанных);
	КонецЕсли;

КонецФункции

// Формирует параметры создания формы списка документов.
//
// Возвращаемое значение:
//   Структура - содержит поля:
//     * ГруппаКоманд - Структура - параметры создания группы команд 1С:ДиректБанк, содержит поля:
//        ** Добавить - Булево - если Истина (по умолчанию), то группа команд будет создана автоматически
//        ** Родитель - ГруппаФормы, ТаблицаФормы, ФормаКлиентскогоПриложения - родитель для добавляемого элемента.
//                      Если не задан, то родителем будет являться ФормаОбъект.КоманднаяПанель.
//        ** МестоРасположения - Строка - имя элемента, перед которым нужно разместить группу команд.
//                                        Если не задан, то группа помещается в конец командной панели формы.
//     * ДинамическийСписок - Структура - параметры изменения запроса динамического списка:
//        ** Изменить - Булево - если Истина (по умолчанию), то в запрос динамического списка добавляются
//                               дополнительные поля.
//        ** ИмяРеквизита - Строка - имя реквизита формы динамического списка. "Список" по-умолчанию.
//     * СписокДокументов - Структура - параметры добавления колонок в список документов:
//        ** ДобавитьКолонки - Булево - если Истина (по умолчанию), то в список добавляются дополнительные колонки.
//        ** ИмяЭлемента - Строка - имя элемента формы динамического списка документов. "Список" по-умолчанию
//        ** ИмяРеквизита - Строка - имя реквизита формы динамического списка документов. "Список" по-умолчанию
//        ** МестоРасположения - Строка - имя элемента, перед которым нужно разместить новую колонку.
//                                        Если не задан, то перемещается в конец колонок таблицы.
//     * ПерепискаСБанками - Структура - параметры добавления ссылки на переписку с банками:
//        ** ДобавитьСсылку - Булево - если Истина (по умолчанию), то добавляется ссылка на переписку с банками.
//        ** Родитель - Строка - имя родителя добавляемого элемента.
//                               Если не указан, то элемент добавляется в конец формы.
//        ** МестоРасположения - Строка - имя элемента, перед которым нужно разместить ссылку на переписку с банками.
//     * Реклама - Структура - параметры отображения рекламы ДиректБанк:
//        ** Добавить - Булево - если Истина (по умолчанию), то на форму добавляется реклама ДиректБанка.
//        ** Родитель - Строка - имя родителя добавляемого элемента.
//                               Если не указан, то элемент добавляется в конец формы.
//        ** МестоРасположения - Строка - имя элемента, перед которым нужно разместить рекламу.
//
Функция ПараметрыСозданияФормыСписка() Экспорт
	
	СтруктураВозврата = Новый Структура;
	
	СтруктураВозврата.Вставить("ГруппаКоманд", Новый Структура);
	СтруктураВозврата.ГруппаКоманд.Вставить("Добавить", Истина);
	СтруктураВозврата.ГруппаКоманд.Вставить("Родитель");
	СтруктураВозврата.ГруппаКоманд.Вставить("МестоРасположения");
	
	СтруктураВозврата.Вставить("ДинамическийСписок", Новый Структура);
	СтруктураВозврата.ДинамическийСписок.Вставить("Изменить", Истина);
	СтруктураВозврата.ДинамическийСписок.Вставить("ИмяРеквизита", "Список");
	
	СтруктураВозврата.Вставить("СписокДокументов", Новый Структура);
	СтруктураВозврата.СписокДокументов.Вставить("ДобавитьКолонки", Истина);
	СтруктураВозврата.СписокДокументов.Вставить("ИмяЭлемента", "Список");
	СтруктураВозврата.СписокДокументов.Вставить("ИмяРеквизита", "Список");
	СтруктураВозврата.СписокДокументов.Вставить("МестоРасположения");
	
	СтруктураВозврата.Вставить("ПерепискаСБанками", Новый Структура);
	СтруктураВозврата.ПерепискаСБанками.Вставить("ДобавитьСсылку", Истина);
	СтруктураВозврата.ПерепискаСБанками.Вставить("Родитель");
	СтруктураВозврата.ПерепискаСБанками.Вставить("МестоРасположения");
	
	СтруктураВозврата.Вставить("Реклама", Новый Структура);
	СтруктураВозврата.Реклама.Вставить("Добавить", Истина);
	СтруктураВозврата.Реклама.Вставить("Родитель");
	СтруктураВозврата.Реклама.Вставить("МестоРасположения");
	
	Возврат СтруктураВозврата;
	
КонецФункции

// Формирует параметры для дополнения формы документа
// 
// Возвращаемое значение:
//  Структура - Описание:
//    * МестоРасположенияСостояния - Строка - элемент, перед которым нужно разместить состояние документа.
//    * РодительСостояния - Строка - элемент, в котором нужно разместить состояние.
Функция ПараметрыСозданияФормыДокумента() Экспорт
	
	СтруктураВозврата = Новый Структура;
	СтруктураВозврата.Вставить("РодительСостояния");
	СтруктураВозврата.Вставить("МестоРасположенияСостояния");
	Возврат СтруктураВозврата;
	
КонецФункции

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

// Определяет необходимость конкретного действия из перечня действий.
//
// Параметры:
//  ПереченьДействий - Строка - перечень действий, которые должны быть совершены с объектом;
//  Действие - Строка - конкретное действие, которое нужно найти в перечне действий;
// 
// Возвращаемое значение:
//  Булево - Если действие найдено - возвращается Истина, иначе Ложь.
//
Функция ЕстьДействие(ПереченьДействий, Действие) Экспорт
	
	Возврат (СтрНайти(ПереченьДействий, Действие) > 0);
	
КонецФункции

// Подготавливает структуру для возврата данных обмена после получения новых документов из банка.
// 
// Возвращаемое значение:
//  Структура - содержит следующие поля:
//   * ДанныеЭП - Соответствие - содержит данные электронных подписей, которые необходимо проверить на клиенте.
//   * КоличествоПолученныхПакетов - Число - количество пакетов, которые были получены из банка.
//   * ПараметрОповещения - Соответствие - данные для оповещения прикладных решений.
//   * ЕстьОшибка - Булево - если вернулось значение Истина, то произошла ошибка.
//   * ТребуетсяПовторнаяАутентификация - Булево - если вернулось значение Истина, то сессия закончилась и требуется повторная аутентификация.
//   * МассивОповещений - Массив - оповещения, сформированные в переопределяемой части. Используется в зарплатном проекте.
//
Функция ПараметрыПолученияНовыхДокументовАсинхронныйОбмен() Экспорт
	
	СтруктураВозврата = Новый Структура;
	СтруктураВозврата.Вставить("ДанныеЭП", Новый Соответствие);
	СтруктураВозврата.Вставить("КоличествоПолученныхПакетов", 0);
	СтруктураВозврата.Вставить("ПараметрОповещения", Новый Соответствие);
	СтруктураВозврата.Вставить("ЕстьОшибка", Ложь);
	СтруктураВозврата.Вставить("ТребуетсяПовторнаяАутентификация", Ложь);
	СтруктураВозврата.Вставить("МассивОповещений", Новый Массив);
	
	Возврат СтруктураВозврата
	
КонецФункции

// Возвращает версию схемы XSD для асинхронного обмена с банком, которые гарантированно поддерживают все банки.
//
// Возвращаемое значение:
//    Строка - версия формата асинхронного обмена.
//
Функция БазоваяВерсияФорматаАсинхронногоОбмена() Экспорт
	
	Возврат "2.1.1";
	
КонецФункции

// Возвращает версию схемы XSD для асинхронного обмена с банком.
//
// Возвращаемое значение:
//    Строка - актуальная версия формата асинхронного обмена.
//
Функция АктуальнаяВерсияФорматаАсинхронногоОбмена() Экспорт
	
	Возврат "2.3.2";
	
КонецФункции

// Возвращает текущую версию формата для синхронного обмена
// 
// Возвращаемое значение:
//  Строка - версия формата
//
Функция ВерсияФорматаСинхронногоОбмена() Экспорт
	
	Возврат "1.08";
	
КонецФункции

// Возвращает версию схемы XSD для асинхронного обмена с банком, которые гарантированно поддерживают все банки.
//
// Возвращаемое значение:
//    Строка - версия формата асинхронного обмена.
//
Функция УстаревшаяВерсияФорматаАсинхронногоОбмена() Экспорт
	
	Возврат "2.03";
	
КонецФункции

// Проверяет заполнение обязательных реквизитов настроек обмена с банками
//
// Параметры:
//  Объект  - СправочникОбъект.НастройкиОбменСБанками - проверяемая настройка.
//  ЭтоТест - Булево - функция вызывается при выполнении теста.
//
// Возвращаемое значение:
//   Булево   - Истина - заполнены все необходимые реквизиты.
//
Функция ЗаполненыРеквизитыНастройкиОбмена(Объект, ЭтоТест = Ложь) Экспорт
	
	Отказ = Ложь;
	
	Если Не ЭтоТест И Объект.Недействительна Тогда
		Возврат Истина;
	КонецЕсли;
		
	Если ЭтоТест И Объект.Недействительна Тогда
		ТекстСообщения = НСтр("ru = 'Для обмена по данной настройке необходимо снять флаг Недействительна'");
		СообщитьПользователю(ТекстСообщения, Неопределено, "Недействительна", "Объект");
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(Объект.Организация) Тогда
		ТекстСообщения = ОбщегоНазначенияБЭДКлиентСервер.ТекстСообщения(
			"Поле", "Заполнение", НСтр("ru = 'Организация'"));
		СообщитьПользователю(ТекстСообщения, Неопределено, "Организация", "Объект", Отказ);
	КонецЕсли;
		
	Если НЕ ЗначениеЗаполнено(Объект.Банк) Тогда
		ТекстСообщения = ОбщегоНазначенияБЭДКлиентСервер.ТекстСообщения(
			"Поле", "Заполнение", НСтр("ru = 'Банк'"));
		СообщитьПользователю(ТекстСообщения, Неопределено, "Банк", "Объект", Отказ);
	КонецЕсли;
		
	Если (Объект.ПрограммаБанка = ПредопределенноеЗначение("Перечисление.ПрограммыБанка.СбербанкОнлайн")
			ИЛИ Объект.ПрограммаБанка = ПредопределенноеЗначение("Перечисление.ПрограммыБанка.АсинхронныйОбмен"))
		И (НЕ ЗначениеЗаполнено(Объект.ИдентификаторОрганизации)
			ИЛИ Объект.ИдентификаторОрганизации = "00000000-0000-0000-0000-000000000000") Тогда
		ТекстСообщения = ОбщегоНазначенияБЭДКлиентСервер.ТекстСообщения(
			"Поле", "Заполнение", НСтр("ru = 'Идентификатор организации'"));
		СообщитьПользователю(ТекстСообщения, Неопределено, "ИдентификаторОрганизации", "Объект", Отказ);
	КонецЕсли;
	
	Если (Объект.ПрограммаБанка = ПредопределенноеЗначение("Перечисление.ПрограммыБанка.ОбменЧерезДопОбработку")
			ИЛИ Объект.ПрограммаБанка = ПредопределенноеЗначение("Перечисление.ПрограммыБанка.ОбменЧерезВК"))
		И НЕ ЗначениеЗаполнено(Объект.ИмяВнешнегоМодуля) Тогда
		
		ТекстСообщения = НСтр("ru = 'Не загружен внешний модуль'");
		СообщитьПользователю(ТекстСообщения, Неопределено, , "Объект", Отказ);
	КонецЕсли;
	
	Если Объект.ПрограммаБанка = ПредопределенноеЗначение("Перечисление.ПрограммыБанка.АльфаБанкОнлайн")
		ИЛИ Объект.ПрограммаБанка = ПредопределенноеЗначение("Перечисление.ПрограммыБанка.АсинхронныйОбмен") Тогда
		Если НЕ ЗначениеЗаполнено(Объект.АдресСервера) Тогда
			ТекстСообщения = ОбщегоНазначенияБЭДКлиентСервер.ТекстСообщения(
				"Поле", "Заполнение", НСтр("ru = 'Адрес сервера банка'"));
			СообщитьПользователю(ТекстСообщения, Неопределено, "АдресСервера", "Объект", Отказ);
		КонецЕсли;
		Если Объект.ПрограммаБанка = ПредопределенноеЗначение("Перечисление.ПрограммыБанка.АльфаБанкОнлайн") Тогда
			Если НЕ ЗначениеЗаполнено(Объект.РесурсИсходящихДокументов) Тогда
				ТекстСообщения = ОбщегоНазначенияБЭДКлиентСервер.ТекстСообщения(
					"Поле", "Заполнение", НСтр("ru = 'Ресурс для отправки'"));
				СообщитьПользователю(ТекстСообщения, Неопределено, "РесурсИсходящихДокументов", "Объект", Отказ);
			КонецЕсли;
			Если НЕ ЗначениеЗаполнено(Объект.РесурсВходящихДокументов) Тогда
				ТекстСообщения = ОбщегоНазначенияБЭДКлиентСервер.ТекстСообщения(
					"Поле", "Заполнение", НСтр("ru = 'Ресурс для получения'"));
				СообщитьПользователю(ТекстСообщения, Неопределено, "РесурсВходящихДокументов", "Объект", Отказ);
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
	Если Объект.ПрограммаБанка = ПредопределенноеЗначение("Перечисление.ПрограммыБанка.СбербанкОнлайн")
		И ЗначениеЗаполнено(Объект.ИдентификаторОрганизации) Тогда
		Попытка
			//@skip-warning
			Идентификатор = Новый УникальныйИдентификатор(Объект.ИдентификаторОрганизации);
		Исключение
			ТекстСообщения = ОбщегоНазначенияБЭДКлиентСервер.ТекстСообщения(
				"Поле", "Корректность", НСтр("ru = 'Идентификатор организации'"));
			СообщитьПользователю(ТекстСообщения, Неопределено, "ИдентификаторОрганизации", "Объект", Отказ);
		КонецПопытки
	КонецЕсли;
		
	Если (Объект.ПрограммаБанка = ПредопределенноеЗначение("Перечисление.ПрограммыБанка.ОбменЧерезДопОбработку")
			ИЛИ Объект.ИспользуетсяКриптография) И Объект.СертификатыПодписейОрганизации.Количество() = 0 Тогда
		ТекстСообщения = ОбщегоНазначенияБЭДКлиентСервер.ТекстСообщения(
			"Список", "Заполнение", , , НСтр("ru = 'Сертификаты ключа электронной подписи'"));
		СообщитьПользователю(ТекстСообщения, Неопределено, "СертификатыПодписейОрганизации", "Объект", Отказ);
	КонецЕсли;
	
	// Проверим заполненность маршрута подписания в исходящих документах
	Отбор = Новый Структура;
	Отбор.Вставить("МаршрутПодписания", ПредопределенноеЗначение("Справочник.МаршрутыПодписания.ПустаяСсылка"));
	Отбор.Вставить("ИспользоватьЭП", 	Истина);
	СтрокиСПустымиМаршрутами = Объект.ИсходящиеДокументы.НайтиСтроки(Отбор);
	Для Каждого СтрокаОшибки Из СтрокиСПустымиМаршрутами Цикл
		ТекстОшибки = ОбщегоНазначенияБЭДКлиентСервер.ТекстСообщения("Колонка", "Заполнение", "МаршрутПодписания", 
			СтрокаОшибки.НомерСтроки, НСтр("ru = 'Исходящие электронные документы'"));
		ИмяПоля = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			"ИсходящиеДокументы[%1].МаршрутПодписания", СтрокаОшибки.НомерСтроки - 1);
		
		СообщитьПользователю(ТекстОшибки, Неопределено, ИмяПоля, "Объект", Отказ);
	КонецЦикла;
	
	Если Объект.ПрограммаБанка = ПредопределенноеЗначение("Перечисление.ПрограммыБанка.АсинхронныйОбмен")
		И Объект.ПоказыватьОкноПодтвержденияПлатежей И НЕ ЗначениеЗаполнено(Объект.АдресЛичногоКабинета) Тогда
		ТекстСообщения = НСтр("ru = 'Необходимо указать адрес личного кабинета банка
									|или отключить открытие формы подтверждения платежа'");
		СообщитьПользователю(ТекстСообщения, Неопределено, "АдресЛичногоКабинета", "Объект", Отказ);
	КонецЕсли;
	
	Возврат НЕ Отказ;
	
КонецФункции

// Проверяет корректность URL.
// 
// Параметры:
//  АдресСервера - Строка - URL сервера банка.
//
// Возвращаемое значение:
//  Булево - Истина, если адрес корректный, иначе Ложь.
//
Функция ПравильныйФорматАдреса(АдресСервера) Экспорт
	
	Если НРег(Лев(АдресСервера, 7)) = "http://"
			ИЛИ НРег(Лев(АдресСервера, 8)) = "https://" Тогда
		Возврат Истина;
	Иначе
		Возврат Ложь;
	КонецЕсли;
	
КонецФункции

// Формирует параметры получения выписки банка
// 
// Возвращаемое значение:
//  Структура - содержит параметры получения выписки. Все поля необязательны для заполнения.
//   * ДатаНачала - Дата - дата начала периода запроса выписки
//   * ДатаОкончания - Дата - дата окончания периода запроса выписки
//   * НомерСчета - Строка - номер счета, по которому требуется получить выписку.
//
Функция ПараметрыПолученияВыпискиБанка() Экспорт
	
	Возврат Новый Структура("ДатаНачала, ДатаОкончания, НомерСчета");
	
КонецФункции

// Преобразовывает строку в число. В случае неудачи генерируется исключение с понятным текстом ошибки.
//
// Параметры:
//  ЧислоСтрокой - Строка, Неопределено - строка, содержащая представление числа
// 
// Возвращаемое значение:
//  Число - полученное число;
//  Неопределено - возвращается, если ЧислоСтрокой = Неопределено.
//
Функция ЧислоИзСтроки(ЧислоСтрокой) Экспорт
	
	Если ЧислоСтрокой = Неопределено Тогда
		Возврат Неопределено
	КонецЕсли;
	
	Попытка
	
		Число = Число(ЧислоСтрокой);
	
	Исключение
		
		ШаблонСообщения = НСтр("ru = 'Невозможно преобразовать значение ""%1"" в число'");
		ТекстСообщения = СтрШаблон(ШаблонСообщения, ЧислоСтрокой);
		ВызватьИсключение ТекстСообщения;
		
	КонецПопытки;
	
	Возврат Число
	
КонецФункции

// Определяет наличие доступных сертификатов в настройке обмена и выдает сообщение о наличии проблемы, если она есть.
//
// Параметры:
//  ПараметрыОбмена - Структура - настройки обмена с банком, где:
//    * ЕстьДействующиеСертификатыВНастройкеОбмена - Булево -
//    * НастройкаОбмена - СправочникСсылка.НастройкиОбменСБанками -
//    * ДоступныеСертификаты - Массив - доступные для подписи документа сертификаты
//    * СертификатДоступен - Булево - если Истина, то есть доступный сертификат для текущего пользователя.
//  ВидЭД - ПеречислениеСсылка.ВидыЭДОбменСБанками - вид электронного документа
// 
// Возвращаемое значение:
//  Булево - если Истина, то данный вид документа можно подписать.
//
Функция ЕстьДоступныеСертификаты(ПараметрыОбмена, ВидЭД) Экспорт
	
	ВозвращаемоеЗначение = Истина;
	Если Не ПараметрыОбмена.ЕстьДействующиеСертификатыВНастройкеОбмена Тогда
		ТекстСообщения = НСтр("ru = 'В настройке обмена с банком отсутствуют действующие сертификаты.
									|Получите новые настройки из банка.'");
		СообщитьПользователю(ТекстСообщения, ПараметрыОбмена.НастройкаОбмена);
		ВозвращаемоеЗначение = Ложь;
	ИначеЕсли НЕ ЗначениеЗаполнено(ПараметрыОбмена.ДоступныеСертификаты)
		ИЛИ НЕ ПараметрыОбмена.СертификатДоступен Тогда
		ШаблонСообщения = НСтр("ru = 'Не найден подходящий сертификат для подписи документа %1'");
		ТекстСообщения = СтрШаблон(ШаблонСообщения, ВидЭД);
		СообщитьПользователю(ТекстСообщения, ПараметрыОбмена.НастройкаОбмена);
		ВозвращаемоеЗначение = Ложь;
	КонецЕсли;

	Возврат ВозвращаемоеЗначение;
	
КонецФункции

// Определяет возможность обмена письмами по формату обмена
//
// Параметры:
//  ВерсияФормата - Строка - версия формата обмена.
// 
// Возвращаемое значение:
//  Булево - Истина, если в текущем формате есть поддержка писем.
//
Функция ЕстьПоддержкаОбменаПисьмами(ВерсияФормата) Экспорт

	Возврат ВерсияФормата >= "2.3.1"
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Формирует заголовок контекстной рекламы 1С:ДиректБанк
//
// Параметры:
//  КоличествоБанков - Число, Неопределено - Количество банков, с которыми можно настроить обмен.
//
Функция СформироватьЗаголовокРекламыДиректБанк(КоличествоБанков)
	
	МассивСтрок = Новый Массив;
	
	МассивСтрок.Добавить(Новый ФорматированнаяСтрока(НСтр("ru = '1С:ДиректБанк'"), Новый Шрифт(,15,Истина)));
	МассивСтрок.Добавить(Символы.ПС);
	
	МассивСтрокГиперссылки = Новый Массив;
	МассивСтрокГиперссылки.Добавить(Новый ФорматированнаяСтрока(НСтр("ru = 'Подробнее'"), Новый Шрифт(,,Истина)));
	МассивСтрокГиперссылки.Добавить(Новый ФорматированнаяСтрока(" ", Новый Шрифт(,12,Истина)));
	МассивСтрокГиперссылки.Добавить(Новый ФорматированнаяСтрока(НСтр("ru = 'о сервисе'"), Новый Шрифт(,,Истина)));
	
	МассивСтрок.Добавить(Новый ФорматированнаяСтрока(МассивСтрокГиперссылки, , , , 
		"https://v8.1c.ru/tekhnologii/obmen-dannymi-i-integratsiya/realizovannye-resheniya/directbank-pryamoy-obmen-s-bankom/?utm_source=led&utm_campaign=2017&utm_medium=app"));
	МассивСтрок.Добавить(Символы.ПС);
	
	Если КоличествоБанков = Неопределено Тогда
		
		МассивСтрокГиперссылки = Новый Массив;
		МассивСтрокГиперссылки.Добавить(Новый ФорматированнаяСтрока(НСтр("ru = 'Поддерживаемые'"), Новый Шрифт(,,Истина)));
		МассивСтрокГиперссылки.Добавить(Новый ФорматированнаяСтрока(" ", Новый Шрифт(,14,Истина)));
		МассивСтрокГиперссылки.Добавить(Новый ФорматированнаяСтрока(НСтр("ru = 'банки'"), Новый Шрифт(,,Истина)));
		
		МассивСтрок.Добавить(Новый ФорматированнаяСтрока(МассивСтрокГиперссылки, , , , 
			"https://v8.1c.ru/tekhnologii/obmen-dannymi-i-integratsiya/realizovannye-resheniya/directbank-pryamoy-obmen-s-bankom/spisok-bankov-podderzhivayushchikh-tekhnologiyu-directbank/banks.htm?utm_source=led&utm_campaign=2017&utm_medium=app"));
		
	Иначе
		
		МассивСтрокГиперссылки = Новый Массив;
		МассивСтрокГиперссылки.Добавить(Новый ФорматированнаяСтрока(НСтр("ru = 'Подключить банки'"), Новый Шрифт(,,Истина)));
		МассивСтрокГиперссылки.Добавить(Новый ФорматированнаяСтрока(" ", Новый Шрифт(,14,Истина)));
		МассивСтрокГиперссылки.Добавить(Новый ФорматированнаяСтрока(
			СтрШаблон("(%1)", КоличествоБанков), Новый Шрифт(,,Истина)));
		
		МассивСтрок.Добавить(Новый ФорматированнаяСтрока(МассивСтрокГиперссылки, , , , "ОткрытьПомощникСозданияНастройкиОбмена"));
		
	КонецЕсли;
	
	Возврат Новый ФорматированнаяСтрока(МассивСтрок);
	
КонецФункции

#Область Сбербанк

// Выводит сообщение об ошибке
//
// Параметры:
//  ВидОперации - Строка - описание выполняемой операции
//  КодОшибки - Строка - код ошибки, который вернул банк
//  Ключ - Произвольный - объект привязки сообщения.
//
Процедура СообщитьОбОшибкеСбербанк(ВидОперации, КодОшибки, Ключ = Неопределено) Экспорт
	
	ТекущаяОшибка = ТекстОшибкиСбербанк(КодОшибки);
	
	Если ТекущаяОшибка = Неопределено Тогда
		ШаблонОшибки = НСтр("ru = 'При аутентификации произошла ошибка.
								|Код: %1'");
		ТекстОшибки = СтрШаблон(ШаблонОшибки, КодОшибки);
	Иначе
		ШаблонОшибки = НСтр("ru = 'При аутентификации произошла ошибка.
								|Код: %1
								|Описание: %2'");
		ТекстОшибки = СтрШаблон(ШаблонОшибки, ТекущаяОшибка.Код, ТекущаяОшибка.Описание);
	КонецЕсли;
	
	ОбработкаНеисправностейБЭДВызовСервера.ОбработатьОшибку(ВидОперации, ОбщегоНазначенияБЭДКлиентСервер.ПодсистемыБЭД().ОбменСБанками,
		ТекстОшибки, ТекстОшибки, Ключ);
	
КонецПроцедуры

// Формирует текст сообщения по его коду
//
// Параметры:
//  Тикет - Строка - код ошибки, полученный из банка.
// 
// Возвращаемое значение:
//  Строка - текст сообщения, который необходимо вывести пользователю.
//
Функция ТекстСообщенияСбербанк(Тикет) Экспорт
	
	Если Тикет = "00000000-0000-0000-0000-000000000000" Тогда
		ТекстСообщения = НСтр("ru = 'Сервер банка временно недоступен. Повторите попытку позже или обратитесь в свой банк.'");
	ИначеЕсли Тикет = "00000000-0000-0000-0000-000000000001" Тогда
		ТекстСообщения = НСтр("ru = 'Неверный формат идентификатора сессии.
									|Обратитесь в техническую поддержку.'");
	ИначеЕсли Тикет = "00000000-0000-0000-0000-000000000002" Тогда
		ТекстСообщения = НСтр("ru = 'Неверный идентификатор сессии.
									|Обратитесь в техническую поддержку.'");
	ИначеЕсли Тикет = "00000000-0000-0000-0000-000000000003" Тогда
		ТекстСообщения = НСтр("ru = 'При вызове метода SendRequestSRP отправлен пустой request.
									|Обратитесь в техническую поддержку.'");
	ИначеЕсли Тикет = "00000000-0000-0000-0000-000000000004" Тогда
		ТекстСообщения = НСтр("ru = 'Среди параметров метода SendRequestSRP нет request-ов.
									|Обратитесь в техническую поддержку.'");
	ИначеЕсли Тикет = "00000000-0000-0000-0000-000000000005" Тогда
		ТекстСообщения = НСтр("ru = 'Неверный логин пользователя.
									|Обратитесь в техническую поддержку.'");
	ИначеЕсли Тикет = "00000000-0000-0000-0000-000000000006" Тогда
		ТекстСообщения = НСтр("ru = 'В сообщении не найден orgId, либо значение не соответствует формату.
									|Обратитесь в техническую поддержку.'");
	ИначеЕсли Тикет = "00000000-0000-0000-0000-000000000007" Тогда
		ТекстСообщения = НСтр("ru = 'Неверный идентификатор организации.
									|Проверьте настройки обмена с сервисом 1С:ДиректБанк или обратитесь в свой банк.'");
	ИначеЕсли Тикет = "00000000-0000-0000-0000-000000000008" Тогда
		ТекстСообщения = НСтр("ru = 'Не найден ContractAccessCode в БД роутера.
									|Обратитесь в техническую поддержку.'");
	ИначеЕсли Тикет = "00000000-0000-0000-0000-000000000009" Тогда
		ТекстСообщения = НСтр("ru = 'Не верный формат org id.
									|Обратитесь в техническую поддержку.'");
	ИначеЕсли Тикет = "00000000-0000-0000-0000-000000000010" Тогда
		ТекстСообщения = НСтр("ru = 'Не найден сертификат.
									|Обратитесь в техническую поддержку.'");
	ИначеЕсли Тикет = "00000000-0000-0000-0000-000000000011" Тогда
		ТекстСообщения = НСтр("ru = 'Размер пакета превысил максимально допустимый.
									|Обратитесь в техническую поддержку.'");
	ИначеЕсли Тикет = "00000000-0000-0000-0000-000000000012" Тогда
		ТекстСообщения = НСтр("ru = 'Ошибка доступа к серверу.
									|Обратитесь в техническую поддержку банка.'");
	Иначе
		ТекстСообщения = НСтр("ru = 'Сервер банка вернул неизвестный код ошибки.
								|Повторите сеанс связи или обратитесь в свой банк.'");
	КонецЕсли;
		
	Возврат ТекстСообщения;
	
КонецФункции

// Возвращает информацию об ошибке по коду.
//
// Параметры:
//  КодОшибки - Строка - код ошибки, полученный от сервера банка.
//
// Возвращаемое значение:
//  Структура - информация об ошибке, содержит поля:
//   * Код - Строка - цифровой код ошибки
//   * Описание - Строка - подробное описание ошибки.
//
Функция ТекстОшибкиСбербанк(КодОшибки) Экспорт
	
	СписокКодовСбербанк = Новый Соответствие;
	Описание = НСтр("ru = 'Неверный логин/пароль или учетная запись заблокирована.'");
	СписокКодовСбербанк.Вставить("AQ==", Новый Структура("Код, Описание", "01", Описание));
	Описание = НСтр("ru = 'Необходимо сменить пароль.'");
	СписокКодовСбербанк.Вставить("Ag==", Новый Структура("Код, Описание", "02", Описание));
	Описание = НСтр("ru = 'Срок действия сертификата истек.'");
	СписокКодовСбербанк.Вставить("Aw==", Новый Структура("Код, Описание", "03", Описание));
	Описание = НСтр("ru = 'Офис организации пользователя заблокирован.'");
	СписокКодовСбербанк.Вставить("BA==", Новый Структура("Код, Описание", "04", Описание));
	Описание = НСтр("ru = 'В аутентификации отказано ФРОД-мониторингом.'");
	СписокКодовСбербанк.Вставить("BQ==", Новый Структура("Код, Описание", "05", Описание));
	Описание = НСтр("ru = 'IP изменился.'");
	СписокКодовСбербанк.Вставить("Bg==", Новый Структура("Код, Описание", "06", Описание));
	Описание = НСтр("ru = 'Финансовый договор заблокирован.'");
	СписокКодовСбербанк.Вставить("Bw==", Новый Структура("Код, Описание", "07", Описание));
	Описание = НСтр("ru = 'Ошибка доступа к серверу.'");
	СписокКодовСбербанк.Вставить("CA==", Новый Структура("Код, Описание", "08", Описание));
	Описание = НСтр("ru = 'Не специфицированная ошибка.'");
	СписокКодовСбербанк.Вставить("CQ==", Новый Структура("Код, Описание", "09", Описание));
	Описание = НСтр("ru = 'Слишком частая ошибка входа в систему.'");
	СписокКодовСбербанк.Вставить("Cg==", Новый Структура("Код, Описание", "0A", Описание));
	Описание = НСтр("ru = 'Учетная запись отключена.'");
	СписокКодовСбербанк.Вставить("Cw==", Новый Структура("Код, Описание", "0B", Описание));
	Описание = НСтр("ru = 'Точка входа недоступна.'");
	СписокКодовСбербанк.Вставить("DA==", Новый Структура("Код, Описание", "0C", Описание));
	Описание = НСтр("ru = 'Ожидается заключение договора.'");
	СписокКодовСбербанк.Вставить("DQ==", Новый Структура("Код, Описание", "0D", Описание));
	Описание = НСтр("ru = 'Договор закрыт.'");
	СписокКодовСбербанк.Вставить("Dg==", Новый Структура("Код, Описание", "0E", Описание));
	Описание = НСтр("ru = 'Доступ закрыт настройками клиента.'");
	СписокКодовСбербанк.Вставить("Dw==", Новый Структура("Код, Описание", "0F", Описание));
	Описание = НСтр("ru = 'У пользователя в настройках отсутствует точка входа УПШ.'");
	СписокКодовСбербанк.Вставить("EA==", Новый Структура("Код, Описание", "10", Описание));
	Описание = НСтр("ru = 'У пользователя в настройках отсутствует точка входа УПШ_Холдинг.'");
	СписокКодовСбербанк.Вставить("EQ==", Новый Структура("Код, Описание", "11", Описание));
	Описание = НСтр("ru = 'Сертификат не найден в базе данных либо не привязан ни к одному пользователю.'");
	СписокКодовСбербанк.Вставить("Eg==", Новый Структура("Код, Описание", "12", Описание));
	Описание = НСтр("ru = 'Установленная сессия требует подтверждения кодом СМС.'");
	СписокКодовСбербанк.Вставить("Ew==", Новый Структура("Код, Описание", "13", Описание));
	Описание = НСтр("ru = 'Неверный код СМС.'");
	СписокКодовСбербанк.Вставить("FA==", Новый Структура("Код, Описание", "14", Описание));
	Описание = НСтр("ru = 'Срок действия кода СМС истек.'");
	СписокКодовСбербанк.Вставить("FQ==", Новый Структура("Код, Описание", "15", Описание));
	Описание = НСтр("ru = 'Неверные настройки СМС аутентификации.'");
	СписокКодовСбербанк.Вставить("Fg==", Новый Структура("Код, Описание", "16", Описание));
	Описание = НСтр("ru = 'Сессия не найдена.'");
	СписокКодовСбербанк.Вставить("Fw==", Новый Структура("Код, Описание", "17", Описание));
	Описание = НСтр("ru = 'Пользователь с указанными учетными данными должен использовать токен.'");
	СписокКодовСбербанк.Вставить("GA==", Новый Структура("Код, Описание", "18", Описание));
	Описание = НСтр("ru = 'Ошибка валидации параметров ФРОД-мониторинга при аутентификации.'");
	СписокКодовСбербанк.Вставить("GQ==", Новый Структура("Код, Описание", "19", Описание));
	Описание = НСтр("ru = 'Для организации недоступна точка входа «Банк-Клиент».'");
	СписокКодовСбербанк.Вставить("Gg==", Новый Структура("Код, Описание", "1А", Описание));
		
	ТекущаяОшибка = СписокКодовСбербанк.Получить(КодОшибки);
	
	Возврат ТекущаяОшибка;
	
КонецФункции

// Возвращает идентификатор внешней компоненты Сбербанка.
// 
// Возвращаемое значение:
//  Строка - идентификатор компоненты.
//
Функция ИдентификаторВнешнейКомпонентыСбербанк() Экспорт

	Возврат "VPNKeyTLS";
	
КонецФункции

#КонецОбласти

Процедура СообщитьПользователю(Знач ТекстСообщенияПользователю, КлючДанных, Поле = "", ПутьКДанным = "", Отказ = Ложь)
	
	Сообщение = Новый СообщениеПользователю;
	Сообщение.КлючДанных = КлючДанных;
	Сообщение.Текст = ТекстСообщенияПользователю;
	Сообщение.Поле = Поле;
	
	Если НЕ ПустаяСтрока(ПутьКДанным) Тогда
		Сообщение.ПутьКДанным = ПутьКДанным;
	КонецЕсли;
	
	Сообщение.Сообщить();
	
	Отказ = Истина;
	
КонецПроцедуры

#КонецОбласти
