
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Если Параметры.Свойство("КассыККМ") Тогда
		ЗаполнитьСписокВыбора(Параметры.КассыККМ, 
							  Параметры.Организации);
		
		Если Параметры.КассыККМ.Количество() = 1 Тогда
			Элементы.Касса.Видимость = Ложь;
		КонецЕсли;
	Иначе
		Отказ = Истина;
	КонецЕсли;
	
	
КонецПроцедуры

&НаКлиенте
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ЗафиксироватьВыборСтроки();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КомандаВниз(Команда)
	
	ПередвинутьПозицию(1)
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаВверх(Команда)
	
	ПередвинутьПозицию(-1)
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаВыбрать(Команда)
	
	ЗафиксироватьВыборСтроки();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Передвинуть позицию в списке.
//
// Параметры:
// Движение = 1 (вниз) или -1 (вверх).
// 
&НаКлиенте
Процедура ПередвинутьПозицию(Движение)
	// Вставить содержимое обработчика.
	Если Список.Количество() < 2 Тогда
		Возврат;
	КонецЕсли;
	
	ТекущиеДанные = Элементы.Список.ТекущиеДанные;
	
	Если ТекущиеДанные = Неопределено  Тогда
		ИндексСтроки = 0;
	Иначе
		ИндексСтроки = Список.Индекс(ТекущиеДанные);
	КонецЕсли;
	
	ИндексСтроки = ИндексСтроки + Движение;
	
	Если ИндексСтроки > (Список.Количество() - 1) Тогда
		ИндексСтроки = 0;
	ИначеЕсли ИндексСтроки < 0 Тогда
		ИндексСтроки = Список.Количество() - 1;
	КонецЕсли;
	
	ТекущиеДанные = Список[ИндексСтроки];
	Элементы.Список.ТекущаяСтрока = ТекущиеДанные.ПолучитьИдентификатор();
	
КонецПроцедуры

&НаКлиенте
Процедура ЗафиксироватьВыборСтроки()
	
	ТекущиеДанные = Элементы.Список.ТекущиеДанные;
	
	Если ТекущиеДанные = Неопределено Тогда
		Закрыть();
	Иначе
		СтруктураСтроки = Новый Структура;
		СтруктураСтроки.Вставить("Касса"                 , ТекущиеДанные.Касса);
		СтруктураСтроки.Вставить("РасходныйКассовыйОрдер", ТекущиеДанные.РасходныйКассовыйОрдер);
		СтруктураСтроки.Вставить("Сумма"                 , ТекущиеДанные.Сумма);
		Закрыть(СтруктураСтроки)
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСписокВыбора(КассыККМ, Организации);
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	|	РасходныйКассовыйОрдер.Ссылка КАК РасходныйКассовыйОрдер,
	|	РасходныйКассовыйОрдер.Номер,
	|	РасходныйКассовыйОрдер.Дата,
	|	ДенежныеСредстваКПоступлениюНаличныеОстатки.Организация,
	|	ДенежныеСредстваКПоступлениюНаличныеОстатки.Касса,
	|	ДенежныеСредстваКПоступлениюНаличныеОстатки.СуммаОстаток КАК Сумма
	|ИЗ
	|	РегистрНакопления.ДенежныеСредстваКПоступлениюНаличные.Остатки(
	|			,
	|			Касса В (&КассыККМ)
	|				И Организация В (&Организации)) КАК ДенежныеСредстваКПоступлениюНаличныеОстатки
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.РасходныйКассовыйОрдер КАК РасходныйКассовыйОрдер
	|		ПО ДенежныеСредстваКПоступлениюНаличныеОстатки.ДокументПередачи = РасходныйКассовыйОрдер.Ссылка
	|ГДЕ
	|	ЕСТЬNULL(ДенежныеСредстваКПоступлениюНаличныеОстатки.СуммаОстаток, 0) > 0";
	
	Запрос.УстановитьПараметр("КассыККМ"   , КассыККМ);
	Запрос.УстановитьПараметр("Организации", Организации);
	
	Результат = Запрос.Выполнить();
	
	Список.Загрузить(Результат.Выгрузить());
	
КонецПроцедуры

#КонецОбласти