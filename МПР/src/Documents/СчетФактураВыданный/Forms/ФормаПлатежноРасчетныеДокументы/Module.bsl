
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Параметры.Свойство("Организация", Организация);
	Параметры.Свойство("ДокументОснование", ДокументОснование);
	
	Если Параметры.Свойство("АдресВХранилище") Тогда
		ПлатежноРасчетныеДокументы.Загрузить(ПолучитьИзВременногоХранилища(Параметры.АдресВХранилище));
	КонецЕсли; 
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Если НЕ Модифицированность Тогда
		Возврат;
	КонецЕсли;
	
	Если ЗавершениеРаботы Тогда
		
		Отказ = Истина;
		
	Иначе
		
		Отказ = Истина;
		
		ОписаниеОповещения = Новый ОписаниеОповещения("ПередЗакрытиемЗавершение", ЭтотОбъект);
		ПоказатьВопрос(ОписаниеОповещения, НСтр("ru = 'Данные не перенесены в счет-фактуру. Перенести?'"), РежимДиалогаВопрос.ДаНет);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ПлатежноРасчетныеДокументыПриИзменении(Элемент)
	
	Модифицированность = Истина;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗаполнитьПлатежноРасчетныеДокументы(Команда)
	
	Если ПлатежноРасчетныеДокументы.Количество() > 0 Тогда
		
		ОписаниеОповещения = Новый ОписаниеОповещения("ОповещениеЗаполненияПлатежноРасчетныхДокументов", ЭтотОбъект);
		ПоказатьВопрос(ОписаниеОповещения, НСтр("ru = 'Табличная часть будет очищена, продолжить?'"), РежимДиалогаВопрос.ДаНет);
		
	Иначе
		ЗаполнитьПлатежноРасчетныеДокументыСервер();
		Модифицированность = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОповещениеЗаполненияПлатежноРасчетныхДокументов(КодОтвета, Параметры) Экспорт
	
	Если КодОтвета = КодВозвратаДиалога.Да Тогда
		ЗаполнитьПлатежноРасчетныеДокументыСервер();
		Модифицированность = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПеренестиВДокумент(Команда)
	
	ЕстьОшибки = Ложь;
	
	ОчиститьСообщения();
	ПроверитьЗаполнениеТабличнойЧасти(ЕстьОшибки);
	Если НЕ ЕстьОшибки Тогда
	
		Модифицированность = Ложь;
		
		Закрыть(ПоместитьПлатежноРасчетныеДокументыВХранилище());
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область Прочее

&НаКлиенте
Процедура ПередЗакрытиемЗавершение(КодОтвета, ДополнительныеПараметры) Экспорт
	
	Если КодОтвета = КодВозвратаДиалога.Да Тогда
		
		ОчиститьСообщения();
		Отказ = Ложь;
		
		ПроверитьЗаполнениеТабличнойЧасти(Отказ);
		
		Если НЕ Отказ Тогда
			Модифицированность = Ложь;
			Закрыть(ПоместитьПлатежноРасчетныеДокументыВХранилище());
		КонецЕсли;
		
	Иначе
		Модифицированность = Ложь;
		Закрыть();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьПлатежноРасчетныеДокументыСервер()
	
	ТаблицаПлатежноРасчетныеДокументы = ПлатежноРасчетныеДокументы.Выгрузить();
	
	Документы.СчетФактураВыданный.ЗаполнитьПлатежноРасчетныеДокументы(
		ТаблицаПлатежноРасчетныеДокументы,
		ДокументОснование,
		Организация);
	
	ПлатежноРасчетныеДокументы.Загрузить(ТаблицаПлатежноРасчетныеДокументы);
	
КонецПроцедуры

&НаСервере
Функция ПоместитьПлатежноРасчетныеДокументыВХранилище()
	
	Возврат ПоместитьВоВременноеХранилище(ПлатежноРасчетныеДокументы.Выгрузить());
	
КонецФункции

&НаСервере
Процедура ПроверитьЗаполнениеТабличнойЧасти(Отказ)
	
	Для ТекИндекс = 0 По ПлатежноРасчетныеДокументы.Количество()-1 Цикл
		
		Если ПустаяСтрока(ПлатежноРасчетныеДокументы[ТекИндекс].НомерПлатежноРасчетногоДокумента) Тогда
			ТекстОшибки = НСтр("ru='Не заполнен номер документа в строке %НомерСтроки%'");
			ТекстОшибки = СтрЗаменить(ТекстОшибки,"%НомерСтроки%",ТекИндекс+1);
			ОбщегоНазначения.СообщитьПользователю(
				ТекстОшибки,
				,
				ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("ПлатежноРасчетныеДокументы", ТекИндекс+1, "НомерПлатежноРасчетногоДокумента"),
				,
				Отказ);
		КонецЕсли;
		
		Если ПлатежноРасчетныеДокументы[ТекИндекс].ДатаПлатежноРасчетногоДокумента = Дата('00010101') Тогда
			ТекстОшибки = НСтр("ru='Не заполнена дата документа в строке %НомерСтроки%'");
			ТекстОшибки = СтрЗаменить( ТекстОшибки,"%НомерСтроки%",ТекИндекс+1);
			ОбщегоНазначения.СообщитьПользователю(
				ТекстОшибки ,
				,
				ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("ПлатежноРасчетныеДокументы", ТекИндекс+1, "ДатаПлатежноРасчетногоДокумента"),
				,
				Отказ);
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти
