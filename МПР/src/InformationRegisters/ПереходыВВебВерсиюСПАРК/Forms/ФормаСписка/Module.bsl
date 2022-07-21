///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2022, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Не СПАРКРиски.ИспользованиеРазрешено() Тогда
		Элементы.ГруппаПанель.Видимость = Ложь;
		Возврат;
	КонецЕсли;
	
	ДоступенПереходВСПАРК = Пользователи.РолиДоступны("ПереходВВебВерсиюСПАРК", , Ложь);
	Элементы.ПерейтиВСПАРК.Видимость = ДоступенПереходВСПАРК;
	Если ЗначениеЗаполнено(Параметры.Контрагент) Тогда
		
		КонтрагентОтбор = Параметры.Контрагент;
		
		// Проверка корректности параметра отбора.
		СвойстваСправочниковКонтрагенты = СПАРКРиски.СвойстваСправочниковКонтрагентов();
		ТипКонтрагент = ТипЗнч(КонтрагентОтбор);
		
		ОписаниеСправочника = СвойстваСправочниковКонтрагенты.Найти(ТипКонтрагент, "ТипСсылка");
		Если ОписаниеСправочника = Неопределено Тогда
			ТекстИсключения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Неизвестный тип контрагента (%1). Необходимо заполнить описание справочника в методе
					|ПриОпределенииСвойствСправочниковКонтрагентов() общего модуля СПАРКРискиПереопределяемый.'"),
				ТипКонтрагент);
			ВызватьИсключение ТекстИсключения;
		КонецЕсли;
		
		Если ОписаниеСправочника.Иерархический
			И ОбщегоНазначения.ЗначениеРеквизитаОбъекта(КонтрагентОтбор, "ЭтоГруппа") = Истина Тогда
			ОбщегоНазначения.СообщитьПользователю(
				НСтр("ru = 'Получение справок 1СПАРК Риски недоступно для группы. Выберите элемент справочника.'"));
			Отказ = Истина;
			Возврат;
		КонецЕсли;
		
		// Настройка отображения элементов формы.
		Элементы.КонтрагентОтбор.Видимость = Ложь;
		
		// Установить отбор в списке.
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(Список.Отбор, "Контрагент", КонтрагентОтбор);
		
		Элементы.КонтрагентОтборГиперссылка.Видимость = Параметры.ПоказыватьОтбор;
		Если Параметры.ПоказыватьОтбор Тогда
			Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Переходы в веб-версию СПАРК: %1'"),
				ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Параметры.Контрагент, "Наименование"));
		КонецЕсли;
		
	Иначе
		
		Элементы.КонтрагентОтборГиперссылка.Видимость = Ложь;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура КонтрагентОтборПриИзменении(Элемент)
	
	Если ЗначениеЗаполнено(КонтрагентОтбор) Тогда
		
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(
			Список.Отбор,
			"Контрагент",
			КонтрагентОтбор,
			,
			,
			Истина);
		
	Иначе
		
		ОтборыПоКонтрагенту = ОбщегоНазначенияКлиентСервер.НайтиЭлементыИГруппыОтбора(Список.Отбор, "Контрагент");
		Для Каждого ТекущийОтбор Из ОтборыПоКонтрагенту Цикл
			ТекущийОтбор.Использование = Ложь;
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ДекорацияКакПользоватьсяКарточкойНажатие(Элемент)
	
	URLИнструкций = "http://downloads.v8.1c.ru/content/Instruction/1spark-card.pdf";
	ФайловаяСистемаКлиент.ОткрытьНавигационнуюСсылку(URLИнструкций);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаКлиенте
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	Если ВыбраннаяСтрока = Неопределено Или Не ДоступенПереходВСПАРК Тогда
		Возврат;
	КонецЕсли;
	
	ДанныеСтроки = Элементы.Список.ДанныеСтроки(ВыбраннаяСтрока);
	СПАРКРискиКлиент.ПерейтиВВебВерсиюСПАРК(ДанныеСтроки.Контрагент);
	
	Элементы.Список.Обновить();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПерейтиВСПАРК(Команда)
	
	Если Не ЗначениеЗаполнено(КонтрагентОтбор) Тогда
		ОбщегоНазначенияКлиент.СообщитьПользователю(
			НСтр("ru = 'Не заполнено поле ""Контрагент""'"),
			,
			,
			"КонтрагентОтбор");
		Возврат;
	КонецЕсли;
	
	СПАРКРискиКлиент.ПерейтиВВебВерсиюСПАРК(КонтрагентОтбор);
	
	Элементы.Список.Обновить();
	
КонецПроцедуры

&НаКлиенте
Процедура ВсеПереходыНаПортале(Команда)
	
	ИнтернетПоддержкаПользователейКлиент.ОткрытьВебСтраницу(
		СПАРКРискиКлиент.АдресСтраницыПереходовВВебВерсиюСПАРК());
	
КонецПроцедуры

#КонецОбласти
