
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ИспользоватьОбменСБанками = ПолучитьФункциональнуюОпцию("ИспользоватьОбменСБанками");
	
	НастройкиОбменаСБанком			= Параметры.НастройкиОбменаСБанком;
	Организация						= Параметры.Организация;
	БанковскийСчет					= Параметры.БанковскийСчет;
	
	ПроводитьДокументыПриЗагрузке = НастройкиОбменаСБанком.ПроводитьДокументыПриЗагрузке;
	
	УстановитьВидимостьДоступностьОбменСБанками(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	ДенежныеСредстваКлиент.ВосстановитьДетальныеНастройкиОбмена(ЭтотОбъект, НастройкиОбменаСБанком);
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Если Модифицированность Тогда
		ТекстПредупреждения = НСтр("ru = 'Настройки были изменены. Закрыть без сохранения?'");
		ОбщегоНазначенияКлиент.ПоказатьПодтверждениеЗакрытияПроизвольнойФормы(
			ЭтотОбъект, Отказ, ЗавершениеРаботы, ТекстПредупреждения, "ЗакрытьФормуБезПодтверждения");
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	ПриИзмененииКлючаНастройкиОбменаСБанком();
КонецПроцедуры

&НаКлиенте
Процедура БанковскийСчетПриИзменении(Элемент)
	ПриИзмененииКлючаНастройкиОбменаСБанком();
КонецПроцедуры

&НаКлиенте
Процедура ФайлЗагрузкиНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	Оповещение = Новый ОписаниеОповещения("ВыборФайлаВыпискиЗавершение", ЭтотОбъект);
	ДенежныеСредстваКлиент.ВыбратьФайлВыписки(ЭтотОбъект ,Оповещение);
КонецПроцедуры

&НаКлиенте
Процедура ФайлЗагрузкиОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, СтандартнаяОбработка)
	ФайлЗагрузки = СокрЛП(Текст);
	Если ЗначениеЗаполнено(ФайлЗагрузки) Тогда
		СоглашениеПрямогоОбменаСБанками = ПредопределенноеЗначение("Справочник.НастройкиОбменСБанками.ПустаяСсылка");
	КонецЕсли;
	Если ДенежныеСредстваКлиент.ОбновитьДетальныеНастройкиОбмена(ЭтотОбъект, НастройкиОбменаСБанком) Тогда
		Модифицированность = Истина;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура КодировкаПриИзменении(Элемент)
	Если ДенежныеСредстваКлиент.ОбновитьДетальныеНастройкиОбмена(ЭтотОбъект, НастройкиОбменаСБанком) Тогда
		Модифицированность = Истина;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура СоглашениеПрямогоОбменаСБанкамиПриИзменении(Элемент)
	Если ЗначениеЗаполнено(СоглашениеПрямогоОбменаСБанками) Тогда
			ФайлЗагрузки = "";
	КонецЕсли;
	Если ДенежныеСредстваКлиент.ОбновитьДетальныеНастройкиОбмена(ЭтотОбъект, НастройкиОбменаСБанком) Тогда
		Модифицированность = Истина;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПроводитьДокументыПриЗагрузкеПриИзменении(Элемент)
	Модифицированность = Истина;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура СохранитьИЗакрыть(Команда)
	
	Если Модифицированность Тогда
		Если ПроверитьЗаполнение() Тогда
			СохранитьНастройки();
			ЗакрытьФормуБезПодтверждения = Истина;
			Закрыть(ПараметрыЗакрытия());
		КонецЕсли;
	Иначе
		Закрыть();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ПриИзмененииКлючаНастройкиОбменаСБанком()
	
	Если НЕ ДенежныеСредстваКлиент.ВосстановитьДетальныеНастройкиОбмена(ЭтотОбъект, НастройкиОбменаСБанком) Тогда
		ФайлЗагрузки = "";
		Кодировка    = "";
		СоглашениеПрямогоОбменаСБанками = ПредопределенноеЗначение("Справочник.НастройкиОбменСБанками.ПустаяСсылка");
	КонецЕсли;
	
	УстановитьВидимостьДоступностьОбменСБанками(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьВидимостьДоступностьОбменСБанками(Форма)
	
	ИспользуетсяОбменСБанками = Форма.ИспользоватьОбменСБанками
		И ЗначениеЗаполнено(Форма.БанковскийСчет);
	
	Элементы = Форма.Элементы;
	Элементы.СоглашениеПрямогоОбменаСБанками.Видимость = ИспользуетсяОбменСБанками;
	Если Не ИспользуетсяОбменСБанками Тогда
		СоглашениеПрямогоОбменаСБанками = ПредопределенноеЗначение("Справочник.НастройкиОбменСБанками.ПустаяСсылка");
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура СохранитьНастройки()
	
	// Общие настройки.
	НастройкиОбменаСБанком.ПроводитьДокументыПриЗагрузке = ПроводитьДокументыПриЗагрузке;
	
	Обработки.КлиентБанк.СохранитьНастройкиОбменаСБанком(НастройкиОбменаСБанком);
	
	Модифицированность = Ложь;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыборФайлаВыпискиЗавершение(ВыбранныеФайлы, ДополнительныеПараметры) Экспорт
	
	Если ВыбранныеФайлы <> Неопределено
		И ВыбранныеФайлы.Количество() > 0 Тогда
		
		ФайлЗагрузки = ВыбранныеФайлы[0];
		
		Если ЗначениеЗаполнено(ФайлЗагрузки) Тогда
			СоглашениеПрямогоОбменаСБанками = ПредопределенноеЗначение("Справочник.НастройкиОбменСБанками.ПустаяСсылка");
		КонецЕсли;
		Если ДенежныеСредстваКлиент.ОбновитьДетальныеНастройкиОбмена(ЭтотОбъект, НастройкиОбменаСБанком) Тогда
			Модифицированность = Истина;
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Функция ПараметрыЗакрытия()
	
	ПараметрыЗакрытия = Новый Структура;
	ПараметрыЗакрытия.Вставить("Организация",            Организация);
	ПараметрыЗакрытия.Вставить("БанковскийСчет",         БанковскийСчет);
	ПараметрыЗакрытия.Вставить("ФайлЗагрузки",           ФайлЗагрузки);
	ПараметрыЗакрытия.Вставить("Кодировка",              Кодировка);
	ПараметрыЗакрытия.Вставить("НастройкиОбменаСБанком", НастройкиОбменаСБанком);
	
	Возврат ПараметрыЗакрытия;
	
КонецФункции

#КонецОбласти
