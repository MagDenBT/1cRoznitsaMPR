#Область ПеременныеМодуля

// НА ПЕРИОД ПЕРЕХОДА

Перем глОбщиеЗначения Экспорт; // Переменная, хранящая кеш общих значений.

// КОНЕЦ НА ПЕРИОД ПЕРЕХОДА

// ПодключаемоеОборудование
Перем глПодключаемоеОборудование Экспорт; // для кэширования на клиенте

// ИнтеграцияЕГАИС
Перем глПодключаемоеОборудованиеСобытиеОбработано Экспорт;
// Конец ИнтеграцияЕГАИС

// СтандартныеПодсистемы

// Хранилище глобальных переменных.
//
// ПараметрыПриложения - Соответствие - хранилище переменных, где:
//   * Ключ - Строка - имя переменной в формате "ИмяБиблиотеки.ИмяПеременной";
//   * Значение - Произвольный - значение переменной.
//
// Инициализация (на примере СообщенияДляЖурналаРегистрации):
//   ИмяПараметра = "СтандартныеПодсистемы.СообщенияДляЖурналаРегистрации";
//   Если ПараметрыПриложения[ИмяПараметра] = Неопределено Тогда
//     ПараметрыПриложения.Вставить(ИмяПараметра, Новый СписокЗначений);
//   КонецЕсли;
//  
// Использование (на примере СообщенияДляЖурналаРегистрации):
//   ПараметрыПриложения["СтандартныеПодсистемы.СообщенияДляЖурналаРегистрации"].Добавить(...);
//   ПараметрыПриложения["СтандартныеПодсистемы.СообщенияДляЖурналаРегистрации"] = ...;
Перем ПараметрыПриложения Экспорт; // Общая переменная

// Конец СтандартныеПодсистемы

// МаркетинговыеАкции
Перем ПорядковыйНомерПродажи Экспорт; // Используется для вычисления скидок по кратности номера продаж.
// Конец МаркетинговыеАкции

Перем НомерДокументаКассыККМ Экспорт; // Нумератор выданных документов (чеков) покупателю.

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ПередНачаломРаботыСистемы(Отказ) 
	
	// СтандартныеПодсистемы
	СтандартныеПодсистемыКлиент.ПередНачаломРаботыСистемы();
	// Конец СтандартныеПодсистемы
	
	// ИнтернетПоддержкаПользователей
	ИнтернетПоддержкаПользователейКлиент.ПередНачаломРаботыСистемы();
	// Конец ИнтернетПоддержкаПользователей
	
	// СтандартныеПодсистемы.ОценкаПроизводительности
	ИмяПараметра = "СтандартныеПодсистемы.ОценкаПроизводительности.ТекущееВремяНачалаГлобальнойОперации";
	ПараметрыПриложения.Вставить(ИмяПараметра, ТекущаяУниверсальнаяДатаВМиллисекундах());
    // Конец СтандартныеПодсистемы.ОценкаПроизводительности
	
	// ПодключаемоеОборудование
	МенеджерОборудованияКлиент.ПередНачаломРаботыСистемы();
	// Конец ПодключаемоеОборудование
	
	НастроитьРежимОсновногоОкна();
	
КонецПроцедуры

Процедура ПриНачалеРаботыСистемы()
	
	// СтандартныеПодсистемы
	СтандартныеПодсистемыКлиент.ПриНачалеРаботыСистемы();
	// Конец СтандартныеПодсистемы
	
	// МаркетинговыеАкции
	ПорядковыйНомерПродажи = 1;
	// Конец МаркетинговыеАкции
	
	// ПодключаемоеОборудование
	МенеджерОборудованияКлиент.ПриНачалеРаботыСистемы();
	// Конец ПодключаемоеОборудование
	
	НомерДокументаКассыККМ = Новый Соответствие;
	
	//{ds-28.03.2021
	ds_СлужебныеСообщенияКлиент.ПриНачалеРаботыСистемы();
	//}
	
КонецПроцедуры

Процедура ПередЗавершениемРаботыСистемы(Отказ, ТекстПредупреждения)
	
	// СтандартныеПодсистемы
	СтандартныеПодсистемыКлиент.ПередЗавершениемРаботыСистемы(Отказ, ТекстПредупреждения);
	// Конец СтандартныеПодсистемы
	
	Если НЕ Отказ Тогда
		// ПодключаемоеОборудование
		МенеджерОборудованияКлиент.ПередЗавершениемРаботыСистемы();
		// Конец ПодключаемоеОборудование		
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область ПрограммныйИнтерфейс

// Функция возвращает значение экспортных переменных модуля.
//
// Параметры:
//  Имя - строка, содержит имя переменной целиком.
//
// Возвращаемое значение:
//   значение соответствующей экспортной переменной
Функция глЗначениеПеременной(Имя) Экспорт

	Возврат ОбщегоНазначенияРТКлиент.ПолучитьЗначениеПеременной(Имя, глОбщиеЗначения);
	
КонецФункции

// Процедура установки значения экспортных переменных модуля приложения.
//
// Параметры:
//  Имя - строка, содержит имя переменной целиком.
// 	Значение - значение переменной.
//
Процедура глЗначениеПеременнойУстановить(Имя, Значение, ОбновлятьВоВсехКэшах = Ложь) Экспорт
	
	ОбщегоНазначенияРТВызовСервера.УстановитьЗначениеПеременной(Имя, глОбщиеЗначения, Значение, ОбновлятьВоВсехКэшах);
	
КонецПроцедуры

// Процедура открывает меню РМК.
//
Процедура ОткрытьМенюРМКУправляемыйРежимПриЗапуске() Экспорт
	
	ПараметрыОткрытияРМК = ОбщегоНазначенияРТВызовСервера.ОткрыватьРМКПриЗапускеПрограммы();
	Если ПараметрыОткрытияРМК.Свойство("ОткрыватьРМК") И ПараметрыОткрытияРМК.ОткрыватьРМК Тогда
		ОбщегоНазначенияРТКлиент.ОткрытьМенюРМКУправляемыйРежим();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура НастроитьРежимОсновногоОкна()
	
	ЗапуститьНовыйРМК = Ложь;
	РежимЗапуска = РежимОсновногоОкнаКлиентскогоПриложения.Обычный;
	
	ОбщегоНазначенияРМККлиент.ОпределитьРежимЗапуска(ЗапуститьНовыйРМК);
	
	Если ЗапуститьНовыйРМК Тогда
		РежимЗапуска = РежимОсновногоОкнаКлиентскогоПриложения.РабочееМесто;
		ОбновитьИнтерфейс();
	КонецЕсли;
	
	КлиентскоеПриложение.УстановитьРежимОсновногоОкна(РежимЗапуска);
	КлиентскоеПриложение.УстановитьОтображениеЗаголовкаОС(Ложь);
	
КонецПроцедуры

#КонецОбласти

#Область Инициализация

// ИнтеграцияЕГАИС
глПодключаемоеОборудованиеСобытиеОбработано = Истина;
// Конец ИнтеграцияЕГАИС

#КонецОбласти
