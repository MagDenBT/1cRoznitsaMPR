///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2022, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныйПрограммныйИнтерфейс

// Если данные не обновлены, но обновление возможно, выполняет обновление,
// в противном случае вызывает исключение.
//
Процедура ПроверитьДанныеРегистра() Экспорт
	
	Обновлен = СтандартныеПодсистемыСервер.ПараметрРаботыПрограммы(
		"СтандартныеПодсистемы.УправлениеДоступом.ПраваРолей");
	
	Если Обновлен <> Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ОбновитьДанныеРегистра();
	
КонецПроцедуры

// Процедура обновляет данные регистра при изменении конфигурации.
//
// Параметры:
//  ЕстьИзменения - Булево - (возвращаемое значение) - если производилась запись,
//                  устанавливается Истина, иначе не изменяется.
//
Процедура ОбновитьДанныеРегистра(ЕстьИзменения = Неопределено) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	СтандартныеПодсистемыСервер.ПроверитьДинамическоеОбновлениеВерсииПрограммы();
	СтандартныеПодсистемыПовтИсп.ИдентификаторыОбъектовМетаданныхПроверкаИспользования(Истина);
	
	Если ЗначениеЗаполнено(ПараметрыСеанса.ВерсияРасширений)
	   И ЕстьРолиМодифицированныеРасширениями() Тогда
		
		ТекстОшибки =
			НСтр("ru = 'Не удалось обновить права ролей конфигурации по причине:
			           |Найдены подключенные расширения конфигурации, изменяющие роли конфигурации.'");
		ВызватьИсключение ТекстОшибки;
	КонецЕсли;
	
	Запрос = ЗапросИзменений(Ложь);
	
	Блокировка = Новый БлокировкаДанных;
	Блокировка.Добавить("РегистрСведений.ПраваРолей");
	
	НачатьТранзакцию();
	Попытка
		Блокировка.Заблокировать();
		Изменения = Запрос.Выполнить().Выгрузить();
		
		Данные = Новый Структура;
		Данные.Вставить("МенеджерРегистра",      РегистрыСведений.ПраваРолей);
		Данные.Вставить("ИзмененияСоставаСтрок", Изменения);
		
		УправлениеДоступомСлужебный.ОбновитьРегистрСведений(Данные, ЕстьИзменения);
		
		СтандартныеПодсистемыСервер.ДобавитьИзмененияПараметраРаботыПрограммы(
			"СтандартныеПодсистемы.УправлениеДоступом.ОбъектыМетаданныхПравРолей",
			ИзмененныеОбъектыМетаданных(Изменения));
		
		СтандартныеПодсистемыСервер.ОбновитьПараметрРаботыПрограммы(
			"СтандартныеПодсистемы.УправлениеДоступом.ПраваРолей", Истина);
		
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		ВызватьИсключение;
	КонецПопытки;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

////////////////////////////////////////////////////////////////////////////////
// Вспомогательные процедуры и функции.

Функция ВозможныеПраваОбъектовМетаданных()
	
	УстановитьПривилегированныйРежим(Истина);
	
	ПраваОбъектовМетаданных = Новый ТаблицаЗначений;
	ПраваОбъектовМетаданных.Колонки.Добавить("Коллекция");
	ПраваОбъектовМетаданных.Колонки.Добавить("ПравоДобавления");
	ПраваОбъектовМетаданных.Колонки.Добавить("ПравоИзменения");
	
	Строка = ПраваОбъектовМетаданных.Добавить();
	Строка.Коллекция         = "Справочники";
	Строка.ПравоДобавления   = Истина;
	Строка.ПравоИзменения    = Истина;
	
	Строка = ПраваОбъектовМетаданных.Добавить();
	Строка.Коллекция         = "Документы";
	Строка.ПравоДобавления   = Истина;
	Строка.ПравоИзменения    = Истина;
	
	Строка = ПраваОбъектовМетаданных.Добавить();
	Строка.Коллекция         = "ЖурналыДокументов";
	Строка.ПравоДобавления   = Ложь;
	Строка.ПравоИзменения    = Ложь;
	
	Строка = ПраваОбъектовМетаданных.Добавить();
	Строка.Коллекция         = "ПланыВидовХарактеристик";
	Строка.ПравоДобавления   = Истина;
	Строка.ПравоИзменения    = Истина;
	
	Строка = ПраваОбъектовМетаданных.Добавить();
	Строка.Коллекция         = "ПланыСчетов";
	Строка.ПравоДобавления   = Истина;
	Строка.ПравоИзменения    = Истина;
	
	Строка = ПраваОбъектовМетаданных.Добавить();
	Строка.Коллекция         = "ПланыВидовРасчета";
	Строка.ПравоДобавления   = Истина;
	Строка.ПравоИзменения    = Истина;
	
	Строка = ПраваОбъектовМетаданных.Добавить();
	Строка.Коллекция         = "РегистрыСведений";
	Строка.ПравоДобавления   = Ложь;
	Строка.ПравоИзменения    = Истина;
	
	Строка = ПраваОбъектовМетаданных.Добавить();
	Строка.Коллекция         = "РегистрыНакопления";
	Строка.ПравоДобавления   = Ложь;
	Строка.ПравоИзменения    = Истина;
	
	Строка = ПраваОбъектовМетаданных.Добавить();
	Строка.Коллекция         = "РегистрыБухгалтерии";
	Строка.ПравоДобавления   = Ложь;
	Строка.ПравоИзменения    = Истина;
	
	Строка = ПраваОбъектовМетаданных.Добавить();
	Строка.Коллекция         = "РегистрыРасчета";
	Строка.ПравоДобавления   = Ложь;
	Строка.ПравоИзменения    = Истина;
	
	Строка = ПраваОбъектовМетаданных.Добавить();
	Строка.Коллекция         = "БизнесПроцессы";
	Строка.ПравоДобавления   = Истина;
	Строка.ПравоИзменения    = Истина;
	
	Строка = ПраваОбъектовМетаданных.Добавить();
	Строка.Коллекция         = "Задачи";
	Строка.ПравоДобавления   = Истина;
	Строка.ПравоИзменения    = Истина;
	
	Возврат ПраваОбъектовМетаданных;
	
КонецФункции

// Функция возвращает поля объекта метаданных по которым может ограничиваться доступ.
//
// Параметры:
//  ОбъектМетаданных   - ОбъектМетаданных - объект по которому нужно вернуть поля.
//  ОбъектИБ           - Неопределено - использовать текущую конфигурацию,
//                     - COMОбъект - использовать соединение с конфигурацией по COM.
//  ПолучитьМассивИмен - Булево - тип результата.
//
// Возвращаемое значение:
//  Строка - имена через запятую, если ПолучитьМассивИмен = Ложь.
//  Массив - со значениями типа Строка, если ПолучитьМассивИмен = Истина.
//
Функция ВсеПоляОграниченияДоступаОбъектаМетаданных(ОбъектМетаданных,
			ПолноеИмя, ОбъектИБ = Неопределено, ПолучитьМассивИмен = Ложь) Экспорт
	
	ИменаПолей = Новый Массив;
	ИменаКоллекций = Новый Массив;
	ЧастиИмени = СтрРазделить(ПолноеИмя, ".");
	ИмяТипа = ЧастиИмени[0];
	
	Если ИмяТипа = "Справочник" Тогда
		ИменаКоллекций.Добавить("Реквизиты");
		ИменаКоллекций.Добавить("ТабличныеЧасти");
		ИменаКоллекций.Добавить("СтандартныеРеквизиты");
		
	ИначеЕсли ИмяТипа = "Документ" Тогда
		ИменаКоллекций.Добавить("Реквизиты");
		ИменаКоллекций.Добавить("ТабличныеЧасти");
		ИменаКоллекций.Добавить("СтандартныеРеквизиты");
		
	ИначеЕсли ИмяТипа = "ЖурналДокументов" Тогда
		ИменаКоллекций.Добавить("Графы");
		ИменаКоллекций.Добавить("СтандартныеРеквизиты");
		
	ИначеЕсли ИмяТипа = "ПланВидовХарактеристик" Тогда
		ИменаКоллекций.Добавить("Реквизиты");
		ИменаКоллекций.Добавить("ТабличныеЧасти");
		ИменаКоллекций.Добавить("СтандартныеРеквизиты");
		
	ИначеЕсли ИмяТипа = "ПланСчетов" Тогда
		ИменаКоллекций.Добавить("Реквизиты");
		ИменаКоллекций.Добавить("ТабличныеЧасти");
		ИменаКоллекций.Добавить("ПризнакиУчета");
		ИменаКоллекций.Добавить("СтандартныеРеквизиты");
		ИменаКоллекций.Добавить("СтандартныеТабличныеЧасти");
		
	ИначеЕсли ИмяТипа = "ПланВидовРасчета" Тогда
		ИменаКоллекций.Добавить("Реквизиты");
		ИменаКоллекций.Добавить("ТабличныеЧасти");
		ИменаКоллекций.Добавить("СтандартныеРеквизиты");
		ИменаКоллекций.Добавить("СтандартныеТабличныеЧасти");
		
	ИначеЕсли ИмяТипа = "РегистрСведений" Тогда
		ИменаКоллекций.Добавить("Измерения");
		ИменаКоллекций.Добавить("Ресурсы");
		ИменаКоллекций.Добавить("Реквизиты");
		ИменаКоллекций.Добавить("СтандартныеРеквизиты");
		
	ИначеЕсли ИмяТипа = "РегистрНакопления" Тогда
		ИменаКоллекций.Добавить("Измерения");
		ИменаКоллекций.Добавить("Ресурсы");
		ИменаКоллекций.Добавить("Реквизиты");
		ИменаКоллекций.Добавить("СтандартныеРеквизиты");
		
	ИначеЕсли ИмяТипа = "РегистрБухгалтерии" Тогда
		ИменаКоллекций.Добавить("Измерения");
		ИменаКоллекций.Добавить("Ресурсы");
		ИменаКоллекций.Добавить("Реквизиты");
		ИменаКоллекций.Добавить("СтандартныеРеквизиты");
		
	ИначеЕсли ИмяТипа = "РегистрРасчета" Тогда
		Если ЧастиИмени.Количество() > 2 И ЧастиИмени[2] = "Перерасчет" Тогда
			ДобавитьПолеОграниченияДоступаОбъектаМетаданных(ОбъектМетаданных,
				"ОбъектПерерасчета", ИменаПолей, ОбъектИБ);
			ДобавитьПолеОграниченияДоступаОбъектаМетаданных(ОбъектМетаданных,
				"ВидРасчета", ИменаПолей, ОбъектИБ);
			ИменаКоллекций.Добавить("Измерения");
		Иначе
			ИменаКоллекций.Добавить("Измерения");
			ИменаКоллекций.Добавить("Ресурсы");
			ИменаКоллекций.Добавить("Реквизиты");
			ИменаКоллекций.Добавить("СтандартныеРеквизиты");
		КонецЕсли;
		
	ИначеЕсли ИмяТипа = "БизнесПроцесс" Тогда
		ИменаКоллекций.Добавить("Реквизиты");
		ИменаКоллекций.Добавить("ТабличныеЧасти");
		ИменаКоллекций.Добавить("СтандартныеРеквизиты");
		
	ИначеЕсли ИмяТипа = "Задача" Тогда
		ИменаКоллекций.Добавить("РеквизитыАдресации");
		ИменаКоллекций.Добавить("Реквизиты");
		ИменаКоллекций.Добавить("ТабличныеЧасти");
		ИменаКоллекций.Добавить("СтандартныеРеквизиты");
	КонецЕсли;
	
	Если ОбъектИБ = Неопределено Тогда
		ТипХранилищеЗначения = Тип("ХранилищеЗначения");
	Иначе
		ТипХранилищеЗначения = ОбъектИБ.NewObject("ОписаниеТипов", "ХранилищеЗначения").Типы().Получить(0);
	КонецЕсли;

	Для каждого ИмяКоллекции Из ИменаКоллекций Цикл
		Если ИмяКоллекции = "ТабличныеЧасти"
		 Или ИмяКоллекции = "СтандартныеТабличныеЧасти" Тогда
			Для каждого ТабличнаяЧасть Из ОбъектМетаданных[ИмяКоллекции] Цикл
				ДобавитьПолеОграниченияДоступаОбъектаМетаданных(ОбъектМетаданных, ТабличнаяЧасть.Имя, ИменаПолей, ОбъектИБ);
				Реквизиты = ?(ИмяКоллекции = "ТабличныеЧасти", ТабличнаяЧасть.Реквизиты, ТабличнаяЧасть.СтандартныеРеквизиты);
				Для каждого Поле Из Реквизиты Цикл
					Если Поле.Тип.СодержитТип(ТипХранилищеЗначения) Тогда
						Продолжить;
					КонецЕсли;
					ДобавитьПолеОграниченияДоступаОбъектаМетаданных(ОбъектМетаданных, ТабличнаяЧасть.Имя + "." + Поле.Имя, ИменаПолей, ОбъектИБ);
				КонецЦикла;
				Если ИмяКоллекции = "СтандартныеТабличныеЧасти" И ТабличнаяЧасть.Имя = "ВидыСубконто" Тогда
					Для каждого Поле Из ОбъектМетаданных.ПризнакиУчетаСубконто Цикл
						ДобавитьПолеОграниченияДоступаОбъектаМетаданных(ОбъектМетаданных, "ВидыСубконто." + Поле.Имя, ИменаПолей, ОбъектИБ);
					КонецЦикла;
				КонецЕсли;
			КонецЦикла;
		Иначе
			Для каждого Поле Из ОбъектМетаданных[ИмяКоллекции] Цикл
				Если ИмяТипа = "ЖурналДокументов"       И Поле.Имя = "Тип"
				 Или ИмяТипа = "ПланВидовХарактеристик" И Поле.Имя = "ТипЗначения"
				 Или ИмяТипа = "ПланСчетов"             И Поле.Имя = "Вид"
				 Или ИмяТипа = "РегистрНакопления"      И Поле.Имя = "ВидДвижения"
				 Или ИмяТипа = "РегистрБухгалтерии"     И ИмяКоллекции = "СтандартныеРеквизиты"
				   И СтрНайти(Поле.Имя, "Субконто") > 0 Тогда
					Продолжить;
				КонецЕсли;
				Если ИмяКоллекции = "Графы" Тогда
					Продолжить;
				КонецЕсли;
				СвойствоТип = Новый Структура("Тип");
				ЗаполнитьЗначенияСвойств(СвойствоТип, Поле);
				Если ТипЗнч(СвойствоТип.Тип) = Тип("ОписаниеТипов")
				   И СвойствоТип.Тип.СодержитТип(ТипХранилищеЗначения) Тогда
					Продолжить;
				КонецЕсли;
				Если (ИмяКоллекции = "Измерения" Или ИмяКоллекции = "Ресурсы")
				   И ?(ОбъектИБ = Неопределено, Метаданные,
				           ОбъектИБ.Метаданные).РегистрыБухгалтерии.Содержит(ОбъектМетаданных)
				   И НЕ Поле.Балансовый Тогда
					ДобавитьПолеОграниченияДоступаОбъектаМетаданных(ОбъектМетаданных,
						Поле.Имя + "Дт", ИменаПолей, ОбъектИБ);
					ДобавитьПолеОграниченияДоступаОбъектаМетаданных(ОбъектМетаданных,
						Поле.Имя + "Кт", ИменаПолей, ОбъектИБ);
				Иначе
					ДобавитьПолеОграниченияДоступаОбъектаМетаданных(ОбъектМетаданных,
						Поле.Имя, ИменаПолей, ОбъектИБ);
				КонецЕсли;
			КонецЦикла;
		КонецЕсли;
	КонецЦикла;
	
	Если ПолучитьМассивИмен Тогда
		Возврат ИменаПолей;
	КонецЕсли;
	
	СписокПолей = "";
	Для каждого ИмяПоля Из ИменаПолей Цикл
		СписокПолей = СписокПолей + ", " + ИмяПоля;
	КонецЦикла;
	
	Возврат Сред(СписокПолей, 3);
	
КонецФункции

Процедура ДобавитьПолеОграниченияДоступаОбъектаМетаданных(ОбъектМетаданных, ИмяПоля,
			ИменаПолей, ОбъектИБ)
	
	Попытка
		Если ОбъектИБ = Неопределено Тогда
			ПараметрыДоступа("Чтение",
				ОбъектМетаданных, ИмяПоля, Метаданные.Роли.ПолныеПрава);
		Иначе
			ОбъектИБ.ПараметрыДоступа("Чтение",
				ОбъектМетаданных, ИмяПоля, ОбъектИБ.Метаданные.Роли.ПолныеПрава);
		КонецЕсли;
		ПараметрыДоступаМожноПолучить = Истина;
	Исключение
		// Некоторые поля, по которым не может быть настроено отдельное ограничение чтения
		// могут вызывать ошибку при попытке получить параметры доступа.
		// Эти поля нужно сразу исключить - для них проверка наличия ограничения не требуется.
		ПараметрыДоступаМожноПолучить = Ложь;
	КонецПопытки;
	
	Если ПараметрыДоступаМожноПолучить Тогда
		ИменаПолей.Добавить(ИмяПоля);
	КонецЕсли;
	
КонецПроцедуры

Функция ЗапросИзменений(ОбъектыРасширений) Экспорт
	
	ВозможныеПраваОбъектовМетаданных = ВозможныеПраваОбъектовМетаданных();
	ПраваРолей = ТаблицаПравРолей(ОбъектыРасширений);
	
	Роли = Новый Массив;
	ПолныеИменаОбъектовМетаданных = Новый Массив;
	Для Каждого Роль Из Метаданные.Роли Цикл
		Если ОбъектыРасширений Тогда
			Если Роль.РасширениеКонфигурации() = Неопределено
			   И Не Роль.ЕстьИзмененияРасширениямиКонфигурации() Тогда
				Продолжить;
			КонецЕсли;
		ИначеЕсли Роль.РасширениеКонфигурации() <> Неопределено Тогда
			Продолжить;
		КонецЕсли;
		Роли.Добавить(Роль);
		ПолныеИменаОбъектовМетаданных.Добавить(Роль.ПолноеИмя());
	КонецЦикла;
	
	Для Каждого ВозможныеПрава Из ВозможныеПраваОбъектовМетаданных Цикл
		Для Каждого ОбъектМетаданных Из Метаданные[ВозможныеПрава.Коллекция] Цикл
			
			Если Не ОбъектыРасширений
			   И ОбъектМетаданных.РасширениеКонфигурации() <> Неопределено Тогда
				Продолжить;
			КонецЕсли;
			
			ПолноеИмя = ОбъектМетаданных.ПолноеИмя();
			ПолныеИменаОбъектовМетаданных.Добавить(ПолноеИмя);
			Поля = Неопределено;
			
			Для Каждого Роль Из Роли Цикл
				
				Если Не ПравоДоступа("Чтение", ОбъектМетаданных, Роль) Тогда
					Продолжить;
				КонецЕсли;
				
				Если Поля = Неопределено Тогда
					Поля = ВсеПоляОграниченияДоступаОбъектаМетаданных(ОбъектМетаданных, ПолноеИмя);
				КонецЕсли;
				
				НоваяСтрока = ПраваРолей.Добавить();
				НоваяСтрока.РольПолноеИмя = Роль.ПолноеИмя();
				НоваяСтрока.ОбъектМетаданныхПолноеИмя = ПолноеИмя;
				
				НоваяСтрока.ПравоЧтениеБезОграничения = Не ПараметрыДоступа("Чтение",
					ОбъектМетаданных, Поля, Роль).ОграничениеУсловием;
				НоваяСтрока.ПравоПросмотр = ПравоДоступа("Просмотр", ОбъектМетаданных, Роль);
				
				Если ВозможныеПрава.ПравоДобавления
				   И ПравоДоступа("Добавление", ОбъектМетаданных, Роль) Тогда
					
					НоваяСтрока.ПравоДобавление = Истина;
					НоваяСтрока.ПравоДобавлениеБезОграничения = Не ПараметрыДоступа("Добавление",
						ОбъектМетаданных, Поля, Роль).ОграничениеУсловием;
					НоваяСтрока.ПравоИнтерактивноеДобавление =
						ПравоДоступа("ИнтерактивноеДобавление", ОбъектМетаданных, Роль);
				КонецЕсли;
				
				Если ВозможныеПрава.ПравоИзменения
				   И ПравоДоступа("Изменение", ОбъектМетаданных, Роль) Тогда
					
					НоваяСтрока.ПравоИзменение = Истина;
					НоваяСтрока.ПравоИзменениеБезОграничения = Не ПараметрыДоступа("Изменение",
						ОбъектМетаданных, Поля, Роль).ОграничениеУсловием;
					НоваяСтрока.ПравоРедактирование =
						ПравоДоступа("Редактирование", ОбъектМетаданных, Роль);
				КонецЕсли;
			КонецЦикла;
			
		КонецЦикла;
	КонецЦикла;
	
	ИдентификаторыОбъектов = ОбщегоНазначения.ИдентификаторыОбъектовМетаданных(ПолныеИменаОбъектовМетаданных);
	Для Каждого Строка Из ПраваРолей Цикл
		Строка.Роль             = ИдентификаторыОбъектов.Получить(Строка.РольПолноеИмя);
		Строка.ОбъектМетаданных = ИдентификаторыОбъектов.Получить(Строка.ОбъектМетаданныхПолноеИмя);
	КонецЦикла;
	
	ТекстЗапросовВременныхТаблиц =
	"ВЫБРАТЬ
	|	НовыеДанные.ОбъектМетаданных,
	|	НовыеДанные.Роль,
	|	НовыеДанные.ПравоДобавление,
	|	НовыеДанные.ПравоИзменение,
	|	НовыеДанные.ПравоЧтениеБезОграничения,
	|	НовыеДанные.ПравоДобавлениеБезОграничения,
	|	НовыеДанные.ПравоИзменениеБезОграничения,
	|	НовыеДанные.ПравоПросмотр,
	|	НовыеДанные.ПравоИнтерактивноеДобавление,
	|	НовыеДанные.ПравоРедактирование
	|ПОМЕСТИТЬ НовыеДанные
	|ИЗ
	|	&ПраваРолей КАК НовыеДанные";
	
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	НовыеДанные.ОбъектМетаданных,
	|	НовыеДанные.Роль,
	|	НовыеДанные.ПравоДобавление,
	|	НовыеДанные.ПравоИзменение,
	|	НовыеДанные.ПравоЧтениеБезОграничения,
	|	НовыеДанные.ПравоДобавлениеБезОграничения,
	|	НовыеДанные.ПравоИзменениеБезОграничения,
	|	НовыеДанные.ПравоПросмотр,
	|	НовыеДанные.ПравоИнтерактивноеДобавление,
	|	НовыеДанные.ПравоРедактирование,
	|	&ПодстановкаПоляВидИзмененияСтроки
	|ИЗ
	|	НовыеДанные КАК НовыеДанные";
	
	ЗначениеОтбораРолей = ?(ОбъектыРасширений, "&УсловиеОтбораРолей", Неопределено);
	
	// Подготовка выбираемых полей с необязательным отбором.
	Поля = Новый Массив;
	Поля.Добавить(Новый Структура("ОбъектМетаданных"));
	Поля.Добавить(Новый Структура("Роль", ЗначениеОтбораРолей));
	Поля.Добавить(Новый Структура("ПравоДобавление"));
	Поля.Добавить(Новый Структура("ПравоИзменение"));
	Поля.Добавить(Новый Структура("ПравоЧтениеБезОграничения"));
	Поля.Добавить(Новый Структура("ПравоДобавлениеБезОграничения"));
	Поля.Добавить(Новый Структура("ПравоИзменениеБезОграничения"));
	Поля.Добавить(Новый Структура("ПравоПросмотр"));
	Поля.Добавить(Новый Структура("ПравоИнтерактивноеДобавление"));
	Поля.Добавить(Новый Структура("ПравоРедактирование"));
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ПраваРолей", ПраваРолей);
	
	Запрос.Текст = УправлениеДоступомСлужебный.ТекстЗапросаВыбораИзменений(
		ТекстЗапроса, Поля, "РегистрСведений.ПраваРолей", ТекстЗапросовВременныхТаблиц);
		
	Если ОбъектыРасширений Тогда
		Таблица = ПраваРолей.Скопировать(, "Роль");
		Таблица.Свернуть("Роль");
		ИзмененныеРоли = Таблица.ВыгрузитьКолонку("Роль");
		УправлениеДоступомСлужебный.УстановитьУсловиеОтбораВЗапросе(Запрос, ИзмененныеРоли, "ИзмененныеРоли",
			"&УсловиеОтбораРолей:СтарыеДанные.Роль");
	КонецЕсли;
	
	Возврат Запрос;
	
КонецФункции

// Формирует пустую таблицу прав ролей.
//
// Возвращаемое значение:
//  ТаблицаЗначений:
//    * ОбъектМетаданных - СправочникСсылка.ИдентификаторыОбъектовМетаданных
//    * Роль - СправочникСсылка.ИдентификаторыОбъектовМетаданных
//    * ПравоИзменение - Булево
//    * ПравоДобавление - Булево
//    * ПравоЧтениеБезОграничения - Булево
//    * ПравоИзменениеБезОграничения - Булево
//    * ПравоДобавлениеБезОграничения - Булево
//    * ПравоПросмотр - Булево
//    * ПравоРедактирование - Булево
//    * ПравоИнтерактивноеДобавление - Булево
//    * РольПолноеИмя - Строка
//    * ОбъектМетаданныхПолноеИмя - Строка
//
Функция ТаблицаПравРолей(ОбъектыРасширений = Ложь, ВидИзмененияСтроки = Ложь, КакРезультатЗапроса = Ложь) Экспорт
	
	ПраваРолей = СоздатьНаборЗаписей().Выгрузить();
	Если Не КакРезультатЗапроса Тогда
		ПраваРолей.Колонки.Добавить("РольПолноеИмя",             Новый ОписаниеТипов("Строка"));
		ПраваРолей.Колонки.Добавить("ОбъектМетаданныхПолноеИмя", Новый ОписаниеТипов("Строка"));
	КонецЕсли;
	
	Если ОбъектыРасширений Тогда
		// Если таблица используется для объектов расширений, то необходимо расширить
		// тип колонок Роль и ОбъектМетаданных типом СправочникСсылка.ИдентификаторыОбъектовРасширений.
		
		Типы = Новый Массив;
		Типы.Добавить(Тип("СправочникСсылка.ИдентификаторыОбъектовМетаданных"));
		Типы.Добавить(Тип("СправочникСсылка.ИдентификаторыОбъектовРасширений"));
		
		УстановитьТипыКолонке(ПраваРолей, "Роль", Типы);
		УстановитьТипыКолонке(ПраваРолей, "ОбъектМетаданных", Типы);
	КонецЕсли;
	
	Если ВидИзмененияСтроки Тогда
		ПраваРолей.Колонки.Добавить("ВидИзмененияСтроки", Новый ОписаниеТипов("Число"));
	КонецЕсли;
	
	Если КакРезультатЗапроса Тогда
		Для Каждого Колонка Из ПраваРолей.Колонки Цикл
			Типы = Колонка.ТипЗначения.Типы();
			Типы.Добавить(Тип("Null"));
			УстановитьТипыКолонке(ПраваРолей, Колонка.Имя, Типы);
		КонецЦикла;
	КонецЕсли;
	
	Возврат ПраваРолей;
	
КонецФункции

// Для функции ТаблицаПравРолей.
Процедура УстановитьТипыКолонке(Таблица, ИмяКолонки, Типы)
	
	Колонка = Таблица.Колонки[ИмяКолонки];
	СвойстваКолонки = Новый Структура("Имя, Заголовок, Ширина");
	ЗаполнитьЗначенияСвойств(СвойстваКолонки, Колонка);
	Индекс = Таблица.Колонки.Индекс(Колонка);
	Таблица.Колонки.Удалить(Индекс);
	
	Таблица.Колонки.Вставить(Индекс, СвойстваКолонки.Имя, Новый ОписаниеТипов(Типы),
		СвойстваКолонки.Заголовок, СвойстваКолонки.Ширина);
	
КонецПроцедуры

Функция ИзмененныеОбъектыМетаданных(Изменения) Экспорт
	
	Изменения.Свернуть("ОбъектМетаданных, Роль, ПравоДобавление, ПравоИзменение, "
			+ "ПравоЧтениеБезОграничения, ПравоДобавлениеБезОграничения, ПравоИзменениеБезОграничения",
		"ВидИзмененияСтроки");
	
	ЛишниеСтроки = Изменения.НайтиСтроки(Новый Структура("ВидИзмененияСтроки", 0));
	Для каждого Строка Из ЛишниеСтроки Цикл
		Изменения.Удалить(Строка);
	КонецЦикла;
	
	Изменения.Свернуть("ОбъектМетаданных");
	
	Возврат Новый ФиксированныйМассив(Изменения.ВыгрузитьКолонку("ОбъектМетаданных"));
	
КонецФункции

Функция ЕстьРолиМодифицированныеРасширениями()
	
	Для Каждого Роль Из Метаданные.Роли Цикл
		Если Роль.ЕстьИзмененияРасширениямиКонфигурации() Тогда
			Возврат Истина;
		КонецЕсли;
	КонецЦикла;
	
	Возврат Ложь;
	
КонецФункции

#КонецОбласти

#КонецЕсли
