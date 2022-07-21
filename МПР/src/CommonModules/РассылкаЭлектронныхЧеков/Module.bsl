#Область ПрограммныйИнтерфейс

// Постановка подготовленных данных электронного чека в очередь отправки.
//
// Параметры:
//  Адресат - Строка - номер телефона или адреса электронной почты;
//  ТипРассылки - ПеречислениеСсылка.ТипыРассылкиЭлектронныхЧеков - 
//  ПараметрыСообщения - Структура - сообщения зависит от типа рассылки
//
Процедура НачатьОтправкуЭлектронногоЧека(Адресат, ТипРассылки, ПараметрыСообщения) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Параметры = РассылкаЭлектронныхЧековПовтИсп.ПараметрыИспользования();
	
	ОтправкаЭлектронныхЧековПослеПробитияЧека = Константы.ОтправкаЭлектронныхЧековПослеПробитияЧека.Получить();
	
	Если Параметры.НаличиеБСП И ОтправкаЭлектронныхЧековПослеПробитияЧека Тогда
		
		УникальныйИдентификатор = Новый УникальныйИдентификатор();
		
		ТекущееХранилище = ПоместитьВоВременноеХранилище(Неопределено, УникальныйИдентификатор);
		
		МодульДлительныеОперации = ОбщегоНазначения.ОбщийМодуль("ДлительныеОперации");
		ПараметрыВыполнения = МодульДлительныеОперации.ПараметрыВыполненияВФоне(УникальныйИдентификатор);
		ПараметрыВыполнения.ОжидатьЗавершение = 0; // запускать сразу
		ПараметрыВыполнения.НаименованиеФоновогоЗадания = НСтр("ru = 'Рассылка электронных чеков'");
		ПараметрыВыполнения.АдресРезультата = ТекущееХранилище;
		ПараметрыВыполнения.ЗапуститьВФоне = Истина; // Всегда в фоне (очередь заданий в файловом варианте).
		
		ПараметрыПроцедуры = Новый Структура;
		ПараметрыПроцедуры.Вставить("ТипРассылки", ТипРассылки);
		ПараметрыПроцедуры.Вставить("ПараметрыСообщения", ПараметрыСообщения);
		ПараметрыПроцедуры.Вставить("Адресат", Адресат);
		
		МодульДлительныеОперации.ВыполнитьВФоне("РассылкаЭлектронныхЧеков.ОтправитьСообщениеОчередиВФоне",
			ПараметрыПроцедуры, ПараметрыВыполнения);
			
		
	Иначе
		ЭлементОбъект = Справочники.ОчередьЭлектронныхЧековКОтправке.СоздатьЭлемент();
		ЭлементОбъект.ТипРассылки  = ТипРассылки;
		ЭлементОбъект.Наименование = Адресат;
		ПараметрыСообщения         = Новый ХранилищеЗначения(ПараметрыСообщения);
		ЭлементОбъект.ПараметрыСообщения     = ПараметрыСообщения;
		ЭлементОбъект.ДатаПостановкиВОчередь = ТекущаяДатаСеанса();
		
		ЭлементОбъект.Записать();
	КонецЕсли;
	
	РассылкаЭлектронныхЧековПереопределяемый.НачатьОтправкуЭлектронногоЧека(Адресат, ТипРассылки, ПараметрыСообщения);
	
КонецПроцедуры

// В фоне отправляет электронный чек через настроенного поставщика услуги, при возникновении ошибки записываются данные ошибки.
// 
// Параметры:
//  ПараметрыЗадания - Структура:
//   * Адресат - Строка, номер телефона или адреса электронной почты.
//   * ТипРассылки -Перечисления.ТипыРассылкиЭлектронного чека
//   * ПараметрыСообщения - Структура. Структура сообщения зависит от типа рассылки.
//  АдресРезультата - ХранилищеЗначения - хранилище сохраняющее результаты выполнения
// 
Процедура ОтправитьСообщениеОчередиВФоне(ПараметрыЗадания, АдресРезультата) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	ТипРассылки        = ПараметрыЗадания.ТипРассылки;
	ПараметрыСообщения = ПараметрыЗадания.ПараметрыСообщения;
	Адресат            = ПараметрыЗадания.Адресат;
	
	Параметры = РассылкаЭлектронныхЧековПовтИсп.ПараметрыИспользования();
	
	Если ТипРассылки = Перечисления.ТипыРассылкиЭлектронныхЧеков.СообщениеSMS 
		И Параметры.НаличиеПодсистемыОтправкаSMS Тогда
		
		Если ТипЗнч(ПараметрыСообщения) = Тип("ХранилищеЗначения") Тогда
			ПараметрыСообщения = ПараметрыСообщения.Получить();
		КонецЕсли;
		
		НомерПолучателя = ПараметрыСообщения.НомерПолучателя;
		ТекстСообщения = ПараметрыСообщения.ТекстСообщения;
		
		ДлинаНомераТелефона = СтрДлина(НомерПолучателя);
		
		Если ДлинаНомераТелефона = 10 Тогда
			НомерПолучателя = "+7" + НомерПолучателя;
		ИначеЕсли ДлинаНомераТелефона = 11
				И Лев(НомерПолучателя, 1) = "8" Тогда
			НомерПолучателя = "+7" + Сред(НомерПолучателя,2);
		Иначе
			НомерПолучателя = НомерПолучателя;
		КонецЕсли;
		
		НомераПолучателей = Новый Массив;
		НомераПолучателей.Добавить(НомерПолучателя);
		
		МодульОтправкаSMS = ОбщегоНазначения.ОбщийМодуль("ОтправкаSMS");
		РезультатОтправки = МодульОтправкаSMS.ОтправитьSMS(НомераПолучателей, ТекстСообщения, Неопределено, Ложь);
		
		Если РезультатОтправки.ОтправленныеСообщения.Количество() = 0 Тогда
			
			ЭлементОбъект = Справочники.ОчередьЭлектронныхЧековКОтправке.СоздатьЭлемент();
			
			ЭлементОбъект.ДатаПостановкиВОчередь = ТекущаяДатаСеанса();
			ЭлементОбъект.Наименование = Адресат;
			ЭлементОбъект.ТипРассылки = ТипРассылки;
			ЭлементОбъект.ПараметрыСообщения = Новый ХранилищеЗначения(ПараметрыСообщения);
			ЭлементОбъект.ПроизошлаОшибкаПередачи = Истина;
			Если РезультатОтправки.Свойство("ОписаниеОшибки") Тогда
				ЭлементОбъект.ОписаниеОшибки = РезультатОтправки.ОписаниеОшибки;
			КонецЕсли;
			ЭлементОбъект.Записать();
			
		КонецЕсли;
	ИначеЕсли Параметры.НаличиеПодсистемыРаботаСПочтовымиСообщениями Тогда
		
		Если ТипЗнч(ПараметрыСообщения) = Тип("ХранилищеЗначения") Тогда
			ПараметрыСообщения = ПараметрыСообщения.Получить();
		КонецЕсли;
		
		ОписаниеОшибки = "";
		ИдентификаторСообщения = "";
		Попытка
			// АПК: 223 - выкл  обратная совместимость
			МодульРаботаСПочтовымиСообщениями = ОбщегоНазначения.ОбщийМодуль("РаботаСПочтовымиСообщениями");
			ИдентификаторСообщения = МодульРаботаСПочтовымиСообщениями.ОтправитьПочтовоеСообщение(
									 МодульРаботаСПочтовымиСообщениями.СистемнаяУчетнаяЗапись(),
									 ПараметрыСообщения);
			// АПК: 223 - вкл
			
		Исключение
			Инфо = ИнформацияОбОшибке();
			ОписаниеОшибки = Инфо.Описание;
			
			Если ТипЗнч(Инфо.Причина) = Тип("ИнформацияОбОшибке") Тогда
				ОписаниеОшибки = ОписаниеОшибки + Символы.ПС + ПодробноеПредставлениеОшибки(Инфо.Причина);
			КонецЕсли; 
			
		КонецПопытки;
		
		Если НЕ ЗначениеЗаполнено(ИдентификаторСообщения) Тогда
			ЭлементОбъект = Справочники.ОчередьЭлектронныхЧековКОтправке.СоздатьЭлемент();
			
			ЭлементОбъект.ДатаПостановкиВОчередь = ТекущаяДатаСеанса();
			ЭлементОбъект.Наименование = Адресат;
			ЭлементОбъект.ТипРассылки = ТипРассылки;
			ЭлементОбъект.ПараметрыСообщения = Новый ХранилищеЗначения(ПараметрыСообщения);
			ЭлементОбъект.ПроизошлаОшибкаПередачи = Истина;
			ЭлементОбъект.ОписаниеОшибки = ОписаниеОшибки;
			ЭлементОбъект.Записать();
		КонецЕсли;
		
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Ложь);
	
	РассылкаЭлектронныхЧековПереопределяемый.ОтправитьСообщениеОчередиВФоне(ПараметрыЗадания, АдресРезультата);
	
КонецПроцедуры

// Отправляет электронный чек через настроенного поставщика услуги, обрабатывает очередь
// При успешной отправке запись очереди удаляется, при возникновении ошибки записываются данные ошибки.
// 
// Параметры:
//  ЭлементСсылка - СправочникСсылка.ОчередьЭлектронныхЧековКОтправке - Элемент ссылка
//  ТипРассылки - ПеречислениеСсылка.ТипыРассылкиЭлектронныхЧеков - Тип рассылки
//  ПараметрыСообщения - Структура - Параметры сообщения
//  Соединение - ИнтернетПочта - Соединение
//
// Возвращаемое значение:
//  Булево - Истина - Если сообщение отправлено
//  
Функция ОтправитьСообщениеОчереди(Знач ЭлементСсылка, Знач ТипРассылки, Знач ПараметрыСообщения, Знач Соединение = Неопределено) Экспорт
	
	Параметры = РассылкаЭлектронныхЧековПовтИсп.ПараметрыИспользования();
	
	Если Параметры.НаличиеБСП Тогда
		УстановитьПривилегированныйРежим(Истина);
		
		ЭлементОбъект = ЭлементСсылка.ПолучитьОбъект();
		ЭлементОбъект.Заблокировать();
		Если ТипРассылки = Перечисления.ТипыРассылкиЭлектронныхЧеков.СообщениеSMS 
			И Параметры.НаличиеПодсистемыОтправкаSMS Тогда
			ПараметрыСообщенияСтруктура = ПараметрыСообщения.Получить();
			НомерПолучателя = ПараметрыСообщенияСтруктура.НомерПолучателя;
			ТекстСообщения = ПараметрыСообщенияСтруктура.ТекстСообщения;
			
			ДлинаНомераТелефона = СтрДлина(НомерПолучателя);
			
			Если ДлинаНомераТелефона = 10 Тогда
				НомерПолучателя = "+7" + НомерПолучателя;
			ИначеЕсли ДлинаНомераТелефона = 11
					И Лев(НомерПолучателя, 1) = "8" Тогда
				НомерПолучателя = "+7" + Сред(НомерПолучателя,2);
			Иначе
				НомерПолучателя = НомерПолучателя;
			КонецЕсли;
			
			НомераПолучателей = Новый Массив;
			НомераПолучателей.Добавить(НомерПолучателя);
			
			МодульОтправкаSMS = ОбщегоНазначения.ОбщийМодуль("ОтправкаSMS");
			РезультатОтправки = МодульОтправкаSMS.ОтправитьSMS(НомераПолучателей, ТекстСообщения, Неопределено, Ложь);
			
			Если РезультатОтправки.ОтправленныеСообщения.Количество() = 0 Тогда
				
				ЭлементОбъект.ПроизошлаОшибкаПередачи = Истина;
				Если РезультатОтправки.Свойство("ОписаниеОшибки") Тогда
					ЭлементОбъект.ОписаниеОшибки = РезультатОтправки.ОписаниеОшибки;
				КонецЕсли;
				ЭлементОбъект.Записать();
				Возврат РассылкаЭлектронныхЧековПереопределяемый.ОтправитьСообщениеОчереди(Ложь, ЭлементСсылка, ТипРассылки, ПараметрыСообщения, Соединение);
			Иначе
				ЭлементОбъект.Удалить();
				Возврат РассылкаЭлектронныхЧековПереопределяемый.ОтправитьСообщениеОчереди(Истина, ЭлементСсылка, ТипРассылки, ПараметрыСообщения, Соединение);
			КонецЕсли;
		ИначеЕсли Параметры.НаличиеПодсистемыРаботаСПочтовымиСообщениями Тогда
			
			Если ТипЗнч(ПараметрыСообщения) = Тип("ХранилищеЗначения") Тогда
				ПараметрыСообщения = ПараметрыСообщения.Получить();
				ПараметрыСообщения.Вставить("ПротоколПочты", "");
				ДобавитьЧекВоВложение(ПараметрыСообщения);
			КонецЕсли;
			
			ОписаниеОшибки = "";
			ИдентификаторСообщения = "";
			Попытка
				
				МодульРаботаСПочтовымиСообщениями = ОбщегоНазначения.ОбщийМодуль("РаботаСПочтовымиСообщениями");
				// АПК: 223 - выкл  обратная совместимость
				ИдентификаторСообщения = МодульРаботаСПочтовымиСообщениями.ОтправитьПочтовоеСообщение(
										 МодульРаботаСПочтовымиСообщениями.СистемнаяУчетнаяЗапись(),
										 ПараметрыСообщения,
										 Соединение);
				// АПК: 223 - вкл
				
			Исключение
				Инфо = ИнформацияОбОшибке();
				ОписаниеОшибки = Инфо.Описание;
				
				Если ТипЗнч(Инфо.Причина) = Тип("ИнформацияОбОшибке") Тогда
						ОписаниеОшибки = ОписаниеОшибки + Символы.ПС + ПодробноеПредставлениеОшибки(Инфо.Причина);
					КонецЕсли; 
					
				КонецПопытки; 
			
			Если ЗначениеЗаполнено(ИдентификаторСообщения) Тогда
				ЭлементОбъект.Удалить();
				Возврат РассылкаЭлектронныхЧековПереопределяемый.ОтправитьСообщениеОчереди(Истина, ЭлементСсылка, ТипРассылки, ПараметрыСообщения, Соединение);
			Иначе
				ЭлементОбъект.ПроизошлаОшибкаПередачи = Истина;
				ЭлементОбъект.ОписаниеОшибки = ОписаниеОшибки;
				ЭлементОбъект.Записать();
				Возврат РассылкаЭлектронныхЧековПереопределяемый.ОтправитьСообщениеОчереди(Ложь, ЭлементСсылка, ТипРассылки, ПараметрыСообщения, Соединение);
			КонецЕсли;
			
		КонецЕсли;
	Иначе
		Возврат РассылкаЭлектронныхЧековПереопределяемый.ОтправитьСообщениеОчереди(Ложь, ЭлементСсылка, ТипРассылки, ПараметрыСообщения, Соединение);
	КонецЕсли;
	
КонецФункции

// Обрабатывается очередь электронных чеков. Обрабатывается регламентным заданием "РассылкаЭлектронныхЧеков".
//
Процедура ОтправитьСообщенияОчереди() Экспорт
	
	ОбщегоНазначения.ПриНачалеВыполненияРегламентногоЗадания(Метаданные.РегламентныеЗадания.РассылкаЭлектронныхЧеков);
	
	УстановитьПривилегированныйРежим(Истина);
	
	// Проверка записей готовых к передаче.
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	ОчередьЭлектронныхЧековКОтправке.ДатаПостановкиВОчередь
	|ИЗ
	|	Справочник.ОчередьЭлектронныхЧековКОтправке КАК ОчередьЭлектронныхЧековКОтправке
	|ГДЕ
	|	НЕ ОчередьЭлектронныхЧековКОтправке.ПроизошлаОшибкаПередачи";
	
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	
	Если НЕ Выборка.Следующий() Тогда
		Возврат;
	КонецЕсли;
	Соединение = Неопределено;
	
	Параметры = РассылкаЭлектронныхЧековПовтИсп.ПараметрыИспользования();
	
	Если Параметры.НаличиеПодсистемыРаботаСПочтовымиСообщениями Тогда
		Попытка
			
			МодульРаботаСПочтовымиСообщениямиСлужебный = ОбщегоНазначения.ОбщийМодуль("РаботаСПочтовымиСообщениямиСлужебный");
			МодульРаботаСПочтовымиСообщениями = ОбщегоНазначения.ОбщийМодуль("РаботаСПочтовымиСообщениями");
			// АПК: 223 - выкл обратная совместимость
			// АПК: 278 - выкл обратная совместимость, Профиль используется в предопределенных модулях
			Профиль = МодульРаботаСПочтовымиСообщениямиСлужебный.ИнтернетПочтовыйПрофиль(
					  МодульРаботаСПочтовымиСообщениями.СистемнаяУчетнаяЗапись());
			// АПК: 278 - вкл
			// АПК: 223 - вкл
			Соединение = Новый ИнтернетПочта;
			ПротоколПодключения = ?(ПустаяСтрока(Профиль.АдресСервераIMAP),ПротоколИнтернетПочты.POP3, ПротоколИнтернетПочты.IMAP);
			Соединение.Подключиться(Профиль, ПротоколПодключения);
			
		Исключение
			
			МодульРаботаСПочтовымиСообщениями = ОбщегоНазначения.ОбщийМодуль("РаботаСПочтовымиСообщениями");
			
			ТекстСообщенияОбОшибке = СтрШаблон(
				НСтр("ru = 'Во время подключения к учетной записи %1 произошла ошибка
					|%2'", ОбщегоНазначения.КодОсновногоЯзыка()),
				МодульРаботаСПочтовымиСообщениями.СистемнаяУчетнаяЗапись(),
				ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
			
			ЗаписьЖурналаРегистрации(НСтр("ru = 'Очередь отправки электронных писем'", ОбщегоНазначения.КодОсновногоЯзыка()),
			                         УровеньЖурналаРегистрации.Ошибка, , ,
			                         ТекстСообщенияОбОшибке);
		
		КонецПопытки;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ОчередьЭлектронныхЧековКОтправке.ТипРассылки,
	|	ОчередьЭлектронныхЧековКОтправке.ПараметрыСообщения,
	|	ОчередьЭлектронныхЧековКОтправке.Ссылка
	|ИЗ
	|	Справочник.ОчередьЭлектронныхЧековКОтправке КАК ОчередьЭлектронныхЧековКОтправке
	|ГДЕ
	|	НЕ ОчередьЭлектронныхЧековКОтправке.ПроизошлаОшибкаПередачи
	|
	|УПОРЯДОЧИТЬ ПО
	|	ОчередьЭлектронныхЧековКОтправке.ДатаПостановкиВОчередь";
	
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	
	КоличествоСообщений = 0;
	Пока Выборка.Следующий() Цикл
		
		РассылкаЭлектронныхЧеков.ОтправитьСообщениеОчереди(Выборка.Ссылка,
						Выборка.ТипРассылки,
						Выборка.ПараметрыСообщения,
						Соединение);
		
		КоличествоСообщений = КоличествоСообщений + 1;
	КонецЦикла;
	
	УстановитьПривилегированныйРежим(Ложь);
	
	РассылкаЭлектронныхЧековПереопределяемый.ОтправитьСообщенияОчереди();
	
КонецПроцедуры

// Проверка наличия подсистем БСП.
//
// Возвращаемое значение:
//  Структура.
//
Функция ПараметрыИспользования() Экспорт
	
	Параметры = Новый Структура;
	
	СтандартныеПодсистемы = Метаданные.Подсистемы.Найти("СтандартныеПодсистемы");
	
	Параметры.Вставить("НаличиеПодсистемыОтправкаSMS", СтандартныеПодсистемы.Подсистемы.Найти("ОтправкаSMS") <> Неопределено);
	Параметры.Вставить("НаличиеПодсистемыРаботаСПочтовымиСообщениями", СтандартныеПодсистемы.Подсистемы.Найти("РаботаСПочтовымиСообщениями") <> Неопределено);
	Если Параметры.НаличиеПодсистемыОтправкаSMS Или Параметры.НаличиеПодсистемыРаботаСПочтовымиСообщениями Тогда
		Параметры.Вставить("НаличиеБСП", Истина);
	Иначе
		Параметры.Вставить("НаличиеБСП", Ложь);
	КонецЕсли;
	
	Возврат Параметры;
	
КонецФункции // ПараметрыИспользования()

// Удаляет сообщения из очереди, вызывается из формы списка справочника "ОчередьЭлектронныхЧековКОтправке"
// 
// Параметры:
//  МассивСообщений - Массив - массив ссылок справочник "ОчередьЭлектронныхЧеков"
//  
Процедура УдалитьСообщенияМассива(МассивСообщений) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	КоличествоСообщений = 0;
	Для каждого СообщениеСсылка Из МассивСообщений Цикл
		
		Попытка
			СообщениеОбъект = СообщениеСсылка.ПолучитьОбъект();
			СообщениеОбъект.Заблокировать();
			СообщениеОбъект.Удалить();
			КоличествоСообщений = КоличествоСообщений + 1;
		Исключение
			КоличествоСообщений = 0;
		КонецПопытки;
	КонецЦикла;
	
	Текст = НСтр("ru = 'Удалено %1 электронных чеков(-а).'");
	Текст =  СтрЗаменить(Текст, "%1", КоличествоСообщений);
	
	ОбщегоНазначения.СообщитьПользователю(Текст);
	
	УстановитьПривилегированныйРежим(Ложь);
	
	РассылкаЭлектронныхЧековПереопределяемый.УдалитьСообщенияМассива(МассивСообщений);
	
КонецПроцедуры

// Отправляет сообщения из очереди, вызывается из формы списка справочника "ОчередьЭлектронныхЧековКОтправке"
// 
// Параметры:
//  МассивСообщений - Массив.
//  
Процедура ОтправитьСообщенияМассива(МассивСообщений) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Параметры = РассылкаЭлектронныхЧековПовтИсп.ПараметрыИспользования();
	
	Если Параметры.НаличиеБСП Тогда
		УстановитьПривилегированныйРежим(Истина);
		
		Если Параметры.НаличиеПодсистемыРаботаСПочтовымиСообщениями Тогда
			Попытка
				
				Профиль = ОбщегоНазначения.ОбщийМодуль("РаботаСПочтовымиСообщениямиСлужебный").ИнтернетПочтовыйПрофиль(
					ОбщегоНазначения.ОбщийМодуль("РаботаСПочтовымиСообщениями").СистемнаяУчетнаяЗапись());
				Соединение = Новый ИнтернетПочта;
				ПротоколПодключения = ?(ПустаяСтрока(Профиль.АдресСервераIMAP),ПротоколИнтернетПочты.POP3, ПротоколИнтернетПочты.IMAP);
				Соединение.Подключиться(Профиль, ПротоколПодключения);
				
			Исключение
				
				ТекстСообщенияОбОшибке = ОбщегоНазначения.ОбщийМодуль("СтроковыеФункцииКлиентСервер").ПодставитьПараметрыВСтроку(
					НСтр("ru = 'Во время подключения к учетной записи %1 произошла ошибка
						|%2'", ОбщегоНазначения.ОбщийМодуль("ОбщегоНазначенияКлиентСервер").КодОсновногоЯзыка()),
					ОбщегоНазначения.ОбщийМодуль("РаботаСПочтовымиСообщениями").СистемнаяУчетнаяЗапись(),
					ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
				
				ЗаписьЖурналаРегистрации(НСтр("ru = 'Очередь отправки электронных писем'", ОбщегоНазначения.КодОсновногоЯзыка()),
				                         УровеньЖурналаРегистрации.Ошибка, , ,
				                         ТекстСообщенияОбОшибке);
			
			КонецПопытки;
		КонецЕсли;
		
		Запрос = Новый Запрос;
		Запрос.Текст = 
		"ВЫБРАТЬ
		|	ОчередьЭлектронныхЧековКОтправке.ТипРассылки,
		|	ОчередьЭлектронныхЧековКОтправке.ПараметрыСообщения,
		|	ОчередьЭлектронныхЧековКОтправке.Ссылка
		|ИЗ
		|	Справочник.ОчередьЭлектронныхЧековКОтправке КАК ОчередьЭлектронныхЧековКОтправке
		|ГДЕ
		|	ОчередьЭлектронныхЧековКОтправке.Ссылка В(&МассивСообщений)
		|
		|УПОРЯДОЧИТЬ ПО
		|	ОчередьЭлектронныхЧековКОтправке.ДатаПостановкиВОчередь";
		
		Запрос.Параметры.Вставить("МассивСообщений", МассивСообщений);
		Результат = Запрос.Выполнить();
		Выборка = Результат.Выбрать();
		
		КоличествоСообщений = 0;
		Пока Выборка.Следующий() Цикл
			
			Отправлено = РассылкаЭлектронныхЧеков.ОтправитьСообщениеОчереди(Выборка.Ссылка,
							Выборка.ТипРассылки,
							Выборка.ПараметрыСообщения,
							Соединение);
			
			Если Отправлено Тогда
				КоличествоСообщений = КоличествоСообщений + 1;
			КонецЕсли;
		КонецЦикла;
		
		Текст = НСтр("ru = 'Отправлено %1 электронных чеков(-а).'");
		Текст =  СтрЗаменить(Текст, "%1", КоличествоСообщений);
		
		ОбщегоНазначения.ОбщийМодуль("ОбщегоНазначения").СообщитьПользователю(Текст);
		УстановитьПривилегированныйРежим(Ложь);
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Ложь);
	
	РассылкаЭлектронныхЧековПереопределяемый.ОтправитьСообщенияМассива(МассивСообщений);
	
КонецПроцедуры

// Обработка проверяет не доступные элементы  формы списка справочника "ОчередьЭлектронныхЧековКОтправке"
//
// Параметры:
//  ЭтотОбъект - ФормаКлиентскогоПриложения - где:
//    * Элементы - ВсеЭлементыФормы - . 
//
Процедура ПриСозданииСпискаОчереди(ЭтотОбъект) Экспорт
	
	Параметры = РассылкаЭлектронныхЧековПовтИсп.ПараметрыИспользования();
	
	ЭтотОбъект.Элементы.ФормаОтправить.Видимость = Параметры.НаличиеБСП;
	ЭтотОбъект.Элементы.ФормаУдалить.Видимость   = Параметры.НаличиеБСП;
	ЭтотОбъект.Элементы.ОтборПоОшибкам.Видимость = Параметры.НаличиеБСП;
	
	РассылкаЭлектронныхЧековПереопределяемый.ПриСозданииСпискаОчереди(ЭтотОбъект);
КонецПроцедуры

// Получить шаблон атрибутов чека для отсылки.
// 
// Параметры:
//  ПараметрыФискализации - Структура - см. ОборудованиеЧекопечатающиеУстройстваВызовСервера.ПараметрыФискализацииЧека()
//
// Возвращаемое значение:
//  Строка - сообщение для отсылки
Функция ШаблонАтрибутовЧекаДляОтсылки(ПараметрыФискализации) Экспорт 
	
	ТекстСообщения = Новый Массив();
	ТекстСообщения.Добавить(СтрШаблон(НСтр("ru = 'ККТ№:%1;'"),  ПараметрыФискализации.РегистрационныйНомерККТ));
	ТекстСообщения.Добавить(СтрШаблон(НСтр("ru = 'СУММА:%1;'"), Формат(ПараметрыФискализации.СуммаЧека, "ЧРД=.;ЧЦ=12;ЧДЦ=2;ЧН=0.00;ЧГ=0")));
	ТекстСообщения.Добавить(СтрШаблон(НСтр("ru = 'ДФ:%1;'"),    Формат(ПараметрыФискализации.ДатаВремяЧека, НСтр("ru = 'ДФ=''дд.ММ.гггг ЧЧ:мм'''"))));
	ТекстСообщения.Добавить(СтрШаблон(НСтр("ru = 'ФН№:%1;'"),   ПараметрыФискализации.ЗаводскойНомерФН));
	ТекстСообщения.Добавить(СтрШаблон(НСтр("ru = 'ФД№:%1;'"),   ПараметрыФискализации.НомерЧекаККТ));
	ТекстСообщения.Добавить(СтрШаблон(НСтр("ru = 'ФПД:%1;'"),   ПараметрыФискализации.ФискальныйПризнак));
	ТекстСообщения.Добавить(СтрШаблон(НСтр("ru = 'САЙТ:%1'"),   ПараметрыФискализации.АдресСайтаПроверки));
	
	Возврат СтрСоединить(ТекстСообщения, Символы.НПП);
	
КонецФункции 

#КонецОбласти


#Область СлужебныеПроцедурыИФункции

Процедура ДобавитьЧекВоВложение(ПараметрыСообщения)
	
	Если ПараметрыСообщения.Свойство("ИдентификаторФискальнойЗаписи") Тогда
		
		Реквизиты = ОборудованиеЧекопечатающиеУстройстваВызовСервера.ДанныеФискальнойОперации(Неопределено, ПараметрыСообщения.ИдентификаторФискальнойЗаписи);
		Если Реквизиты <> Неопределено Тогда
			ТекстСообщенияXML = Реквизиты.ДанныеXML.Получить();
			ОбщиеПараметры = ОборудованиеЧекопечатающиеУстройстваВызовСервера.ЗагрузитьДанныеФискализацииИзXML(ТекстСообщенияXML);
			ТабличныйДокумент = ОборудованиеЧекопечатающиеУстройстваВызовСервера.СформироватьФискальныйДокумент(0, ОбщиеПараметры, Реквизиты);
		КонецЕсли;
		
		Поток = Новый ПотокВПамяти();
		
		ИмяВременногоФайла = ПолучитьИмяВременногоФайла("pdf");
		ТабличныйДокумент.Записать(ИмяВременногоФайла, ТипФайлаТабличногоДокумента.PDF);
		ДвоичныеДанные = Новый ДвоичныеДанные(ИмяВременногоФайла);
		
		ФайлВложения = Новый Структура();
		ФайлВложения.Вставить("Представление", ПараметрыСообщения.ИдентификаторФискальнойЗаписи + ".pdf");
		ФайлВложения.Вставить("АдресВоВременномХранилище", ПоместитьВоВременноеХранилище(ДвоичныеДанные));
		
		Вложения = Новый Массив();
		Вложения.Добавить(ФайлВложения);
		ПараметрыСообщения.Вставить("Вложения",Вложения);
		
	КонецЕсли;
КонецПроцедуры

#КонецОбласти
