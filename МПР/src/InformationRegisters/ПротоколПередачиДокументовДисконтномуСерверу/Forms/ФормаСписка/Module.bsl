
#Область ПрограммныйИнтерфейс

#Область ОбработчикиСобытийПодключаемогоОборудования

&НаКлиенте
Функция ПолученМагнитныйКод(МагнитныйКод) Экспорт 
	
	СтруктураРезультат = ДанныеПоискаПоМагнитномуКодуСервер(МагнитныйКод);
	Возврат ПодключаемоеОборудованиеРТКлиент.ПолученМагнитныйКод(ЭтотОбъект, СтруктураРезультат);
	
КонецФункции

&НаКлиенте
Функция ПолученШтрихкодИзСШК(Штрихкод) Экспорт
	
	СтруктураРезультат = ДанныеПоискаПоШтрихкодуСервер(Штрихкод);
	Возврат ПодключаемоеОборудованиеРТКлиент.ПолученШтрихкодИзСШК(ЭтотОбъект, СтруктураРезультат);
	
КонецФункции

&НаСервере
Процедура ОбработатьДанныеПоКодуСервер(СтруктураРезультат) Экспорт
	
	СтрокаРезультата = СтруктураРезультат.ЗначенияПоиска[0];
	
	Если СтрокаРезультата.Свойство("Карта") Тогда
		
		Если СтрокаРезультата.ЭтоРегистрационнаяКарта Тогда
			ПодключаемоеОборудованиеРТ.ВставитьПредупреждениеОНевозможностиОбработкиКарт(СтруктураРезультат, СтрокаРезультата);
		Иначе
			ЭлементОтбора = Список.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
			ЭлементОтбора.ЛевоеЗначение    = Новый ПолеКомпоновкиДанных("ДисконтнаяКарта");
			ЭлементОтбора.ВидСравнения     = ВидСравненияКомпоновкиДанных.Равно;
			ЭлементОтбора.Использование    = Истина;
			ЭлементОтбора.ПравоеЗначение   = СтрокаРезультата.Карта;
			ЭлементОтбора.РежимОтображения = РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Авто;
		КонецЕсли;
		
	ИначеЕсли СтрокаРезультата.Свойство("СерийныйНомер") Тогда
		
		ПодключаемоеОборудованиеРТ.ВставитьПредупреждениеОНевозможностиОбработкиСертификатов(СтруктураРезультат, СтрокаРезультата);
		
	ИначеЕсли СтрокаРезультата.Свойство("ШтрихкодУпаковкиЕГАИС")
		И ЗначениеЗаполнено(СтрокаРезультата.ШтрихкодУпаковкиЕГАИС) Тогда
		
		ПодключаемоеОборудованиеРТ.ВставитьПредупреждениеОНевозможностиОбработкиАкцизныхМарок(СтруктураРезультат, СтрокаРезультата);
		
	Иначе // Номенклатура.
		
		ПодключаемоеОборудованиеРТ.ВставитьПредупреждениеОНевозможностиОбработкиНоменклатуры(СтруктураРезультат, СтрокаРезультата);
		
	КонецЕсли;
	
	Если СтрокаРезультата.Свойство("ТекстПредупреждения") Тогда
		СтруктураРезультат.Вставить("ТекстПредупреждения", СтрокаРезультата.ТекстПредупреждения);
	КонецЕсли;
		
КонецПроцедуры

&НаКлиенте
Процедура ОбработатьДанныеПоКодуКлиент(СтруктураПараметровКлиента) Экспорт
	
	ОткрытаБлокирующаяФорма = Ложь;
	
	ПодключаемоеОборудованиеРТКлиент.ОбработатьДанныеПоКоду(ЭтотОбъект, СтруктураПараметровКлиента, ОткрытаБлокирующаяФорма);
	
КонецПроцедуры

&НаСервере
Функция ДанныеПоискаПоМагнитномуКодуСервер(МагнитныйКод)
	
	Возврат ПодключаемоеОборудованиеРТ.ДанныеПоискаПоМагнитномуКоду(МагнитныйКод, ЭтотОбъект);
	
КонецФункции

&НаСервере
Функция ДанныеПоискаПоШтрихкодуСервер(Штрихкод)
	
	Возврат ПодключаемоеОборудованиеРТ.ДанныеПоискаПоШтрихкоду(Штрихкод, ЭтотОбъект);
	
КонецФункции

&НаКлиенте
Процедура ОповещениеОбработатьДанныеПоКоду(СтруктураРезультат, ДополнительныеПараметры) Экспорт
	
	ОбработатьДанныеПоКодуСервер(СтруктураРезультат);
	
КонецПроцедуры

#КонецОбласти

&НаКлиенте
Процедура УстановитьИнтервалЗавершение(ВыбранныйПериод, ДополнительныеПараметры) Экспорт
	
	Если ВыбранныйПериод <> Неопределено Тогда
		
		НоваяГруппаУсловий = ОбщегоНазначенияРТКлиентСервер.СоздатьГруппуЭлементовОтбора(
								Список,
								"ИнтервалПросмотра",
								ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИ);
		НоваяГруппаУсловий.Использование = Истина;
		НоваяГруппаУсловий.Элементы.Очистить();
		
		УсловиеБольше = НоваяГруппаУсловий.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		УсловиеБольше.Использование = Истина;
		УсловиеБольше.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ДокументПродажи.Дата");
		УсловиеБольше.ВидСравнения = ВидСравненияКомпоновкиДанных.БольшеИлиРавно;
		УсловиеБольше.ПравоеЗначение = ВыбранныйПериод.ДатаНачала;
		
		Если ЗначениеЗаполнено(ВыбранныйПериод.ДатаОкончания) Тогда
			УсловиеМеньше = НоваяГруппаУсловий.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
			УсловиеМеньше.Использование = Истина;
			УсловиеМеньше.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ДокументПродажи.Дата");
			УсловиеМеньше.ВидСравнения = ВидСравненияКомпоновкиДанных.МеньшеИлиРавно;
			УсловиеМеньше.ПравоеЗначение = ВыбранныйПериод.ДатаОкончания;
		КонецЕсли;
		
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Если Параметры.Свойство("ДокументПродажи") Тогда
		ОтборыСписковКлиентСервер.ИзменитьЭлементОтбораСписка(
			Список,
			"ДокументПродажи",
			Параметры.ДокументПродажи,
			Истина,
			ВидСравненияКомпоновкиДанных.Равно);
		Элементы.ДокументПродажи.Видимость = Ложь;
		Элементы.ДокументПродажиОтбор.Видимость = Истина;
		ДокументПродажиОтбор = Параметры.ДокументПродажи;
		ЭтаФорма.Заголовок = НСтр("ru = 'Протокол передачи документа дисконтному серверу'");
		ЭтаФорма.АвтоЗаголовок = Ложь;
	КонецЕсли;
	
	ПодключаемоеОборудованиеРТ.НастроитьПодключаемоеОборудование(ЭтотОбъект);

КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
    
    // &ЗамерПроизводительности
    ОценкаПроизводительностиРТКлиент.НачатьЗамер(
             Истина, "РегистрСведений.ПротоколПередачиДокументовДисконтномуСерверу.Форма.ФормаСписка.Открытие");

	// ПодключаемоеОборудование
	МенеджерОборудованияКлиент.НачатьПодключениеОборудованиеПриОткрытииФормы(Неопределено, ЭтотОбъект, "СканерШтрихкода, СчитывательМагнитныхКарт");
	// Конец ПодключаемоеОборудование
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	
	// ПодключаемоеОборудование
	МенеджерОборудованияКлиент.НачатьОтключениеОборудованиеПриЗакрытииФормы(Неопределено, ЭтотОбъект);
	// Конец ПодключаемоеОборудование
	
КонецПроцедуры

&НаКлиенте
Процедура ВнешнееСобытие(Источник, Событие, Данные)
	
	Если ВводДоступен() Тогда
		ПодключаемоеОборудованиеРТКлиент.ВнешнееСобытиеОборудования(ЭтотОбъект, Источник, Событие, Данные);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

#Область ОбработчикиКомандПодключаемогоОборудования

&НаКлиенте
Процедура ПоискПоМагнитномуКоду(Команда)
	
	ОбработкаТабличнойЧастиТоварыКлиент.ВвестиМагнитныйКод(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПоискПоШтрихкоду(Команда)
	
	ОбработкаТабличнойЧастиТоварыКлиент.ВвестиШтрихкод(ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти

&НаКлиенте
Процедура УстановитьИнтервал(Команда)
	
	ДиалогПериода = Новый ДиалогРедактированияСтандартногоПериода();
	ДополнительныеПараметры = Новый Структура;
	ОбработчикОповещения = Новый ОписаниеОповещения("УстановитьИнтервалЗавершение", ЭтотОбъект, ДополнительныеПараметры);
	
	ДиалогПериода.Показать(ОбработчикОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура ОчиститьОтбор(Команда)
	
	Список.Отбор.Элементы.Очистить();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ОповещениеПоискаПоШтрихкоду(Штрихкод, ДополнительныеПараметры) Экспорт
	
	Если НЕ ПустаяСтрока(Штрихкод) Тогда
		СтруктураПараметровКлиента = ПолученШтрихкодИзСШК(Штрихкод);
		ОбработатьДанныеПоКодуКлиент(СтруктураПараметровКлиента);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОповещениеПоискаПоМагнитномуКоду(ТекКод, ДополнительныеПараметры) Экспорт
	
	Если Не ПустаяСтрока(ТекКод) Тогда
		СтруктураПараметровКлиента = ПолученМагнитныйКод(ТекКод);
		ОбработатьДанныеПоКодуКлиент(СтруктураПараметровКлиента);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОповещениеОткрытьФормуВыбораДанныхПоиска(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат <> Неопределено Тогда
		ОбработатьДанныеПоКодуСервер(Результат);
		ОбработатьДанныеПоКодуКлиент(Результат)
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
