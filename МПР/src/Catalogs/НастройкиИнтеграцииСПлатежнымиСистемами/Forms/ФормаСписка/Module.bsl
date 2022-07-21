///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2021, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформление();
	
	Результат = ОбновлениеИнформационнойБазы.ОбъектОбработан(
		"Справочник.НастройкиИнтеграцииСПлатежнымиСистемами");
	
	Если Не Результат.Обработан Тогда
		ЭтотОбъект.ТолькоПросмотр = Истина;
		Элементы.НоваяИнтеграция.Доступность = Ложь;
		Элементы.Список.Доступность = Ложь;
		Элементы.ФормаДобавитьИнтеграциюСБП.Доступность = Ложь;
		ОбщегоНазначения.СообщитьПользователю(
			Результат.ТекстИсключения);
	КонецЕсли;
	
	ЭтотОбъект.КоманднаяПанель.Видимость = ИнтеграцияСПлатежнымиСистемами.НастройкаИнтеграцияДоступна();
	Элементы.СписокКонтекстноеМенюСкопировать.Видимость = ЭтотОбъект.КоманднаяПанель.Видимость;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаКлиенте
Процедура СписокПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	
	Отказ = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	Если Элемент.ТекущиеДанные <> Неопределено
		И ЗначениеЗаполнено(Элемент.ТекущиеДанные.Родитель) Тогда
		
		ПараметрыФормы = Новый Структура;
		ПараметрыФормы.Вставить("Ключ", ВыбраннаяСтрока);
		Если Не Элемент.ТекущиеДанные.ЭтоГруппа Тогда
			ОткрытьФорму(
				"Справочник.НастройкиИнтеграцииСПлатежнымиСистемами.ФормаОбъекта",
				ПараметрыФормы);
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Создать(Команда)
	
	ОписаниеОповещения = Новый ОписаниеОповещения(
		"ОбновитьДанныеФормы",
		ЭтотОбъект);
	
	ПараметрыПодключения = Новый Структура;
	ПараметрыПодключения.Вставить("БИК", Неопределено);
	ПараметрыПодключения.Вставить("ТорговаяТочка", Неопределено);
	ПараметрыПодключения.Вставить("ДополнительныеПараметры", Неопределено);
	
	ИнтеграцияСПлатежнымиСистемамиКлиент.СлужебнаяПодключитьИнтеграциюССБП(
		ПараметрыПодключения,
		ОписаниеОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура Скопировать(Команда)
	
	ТекстПредупреждения = НСтр("ru = 'Копирование доступно только для настроек подключения.'");
	Если Элементы.Список.ТекущиеДанные = Неопределено Тогда
		ПоказатьПредупреждение(
			Неопределено,
			ТекстПредупреждения);
		Возврат;
	КонецЕсли;
	
	Если Элементы.Список.ТекущиеДанные.ЭтоГруппа Тогда
		ПоказатьПредупреждение(
			Неопределено,
			ТекстПредупреждения);
		Возврат;
	КонецЕсли;
	
	ОписаниеОповещения = Новый ОписаниеОповещения(
		"ОбновитьДанныеФормы",
		ЭтотОбъект);
	
	ПараметрыПодключения = Новый Структура;
	ПараметрыПодключения.Вставить("БИК", Неопределено);
	ПараметрыПодключения.Вставить("ТорговаяТочка", Элементы.Список.ТекущиеДанные.Ссылка);
	ПараметрыПодключения.Вставить("ДополнительныеПараметры", Неопределено);
	
	ИнтеграцияСПлатежнымиСистемамиКлиент.СлужебнаяПодключитьИнтеграциюССБП(
		ПараметрыПодключения,
		ОписаниеОповещения);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ОбновитьДанныеФормы(Результат, ДополнительныеПараметры) Экспорт
	
	Элементы.Список.Обновить();
	
КонецПроцедуры

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	УсловноеОформление.Элементы.Очистить();
	
	ЭлементОформления = Список.УсловноеОформление.Элементы.Добавить();
	ЭлементОформления.Оформление.УстановитьЗначениеПараметра("Видимость", Ложь);
	
	ОформлениеОтбор = ЭлементОформления.Отбор.Элементы.Добавить(Тип("ГруппаЭлементовОтбораКомпоновкиДанных"));
	ОформлениеОтбор = ОформлениеОтбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОформлениеОтбор.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ПометкаУдаления");
	ОформлениеОтбор.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОформлениеОтбор.ПравоеЗначение = Истина;
	
	ЭлементОформления = Список.УсловноеОформление.Элементы.Добавить();
	ЭлементОформления.Оформление.УстановитьЗначениеПараметра(
		"ЦветТекста",
		Метаданные.ЭлементыСтиля.ЦветНеАктивнойСтроки.Значение);
	
	ОформлениеОтбор = ЭлементОформления.Отбор.Элементы.Добавить(Тип("ГруппаЭлементовОтбораКомпоновкиДанных"));
	ОформлениеОтбор = ОформлениеОтбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОформлениеОтбор.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Используется");
	ОформлениеОтбор.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОформлениеОтбор.ПравоеЗначение = Ложь;
	
КонецПроцедуры

#КонецОбласти
