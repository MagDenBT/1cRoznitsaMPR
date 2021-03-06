
#Область ПрограммныйИнтерфейс

#Область ОбработчикиСобытийПодключаемогоОборудования

// Обработка поиска по штрихкоду.
//
// Параметры:
//  Штрихкод - Строка - прочитанный штрихкод.
//  ДополнительныеПараметры - Структура - структура дополнительных параметров.
//
&НаКлиенте
Процедура ОповещениеПоискаПоШтрихкоду(Штрихкод, ДополнительныеПараметры) Экспорт
	
	Если НЕ ПустаяСтрока(Штрихкод) Тогда
		Номер = Штрихкод;
		НомерПриИзменении(Элементы.Номер);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

&НаКлиенте
Процедура ОповещениеВыборВладельца(РезультатВыбора, ДополнительныеПараметры) Экспорт
	
	Если НЕ РезультатВыбора = Неопределено Тогда
		ВладелецСерии = РезультатВыбора;
		ВладелецСерииПриИзменении(Элементы.ВладелецСерии);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОповещениеВыборИзСписка(РезультатВыбора, ДополнительныеПараметры) Экспорт
	Если НЕ РезультатВыбора = Неопределено Тогда
		Если РезультатВыбора = ДополнительныеПараметры.СписокВыбора.НайтиПоЗначению(НСтр("ru = 'Вид номенклатуры'")) Тогда
			ПараметрыОтбора = Новый Структура;
			ПараметрыОтбора.Вставить("ИспользованиеСерий", ПредопределенноеЗначение("Перечисление.ВариантыВеденияДополнительныхДанныхПоНоменклатуре.ОбщиеДляВидаНоменклатуры"));
			ПараметрыФормы = Новый Структура;
			ПараметрыФормы.Вставить("Отбор", ПараметрыОтбора);
			
			ОткрытьФорму("Справочник.ВидыНоменклатуры.ФормаВыбора",
							ПараметрыФормы,
							ЭтотОбъект,,,,
							Новый ОписаниеОповещения("ОповещениеВыборВладельца", ЭтотОбъект),
							РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
		Иначе
			ПараметрыОтбора = Новый Структура;
			ПараметрыОтбора.Вставить("ВидыНоменклатур", ВидыНоменклатурыИндивидуальныеДляНоменклатуры());
			
			ПараметрыФормы = Новый Структура;
			ПараметрыФормы.Вставить("СтруктураПараметрыОтбора", ПараметрыОтбора);
			ОткрытьФорму("Справочник.Номенклатура.ФормаВыбора",
							ПараметрыФормы,
							ЭтотОбъект,,,,
							Новый ОписаниеОповещения("ОповещениеВыборВладельца", ЭтотОбъект),
							РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Параметры.Свойство("ВидНоменклатуры", ВидНоменклатуры);
	Параметры.Свойство("ВладелецСерии"  , ВладелецСерии);
	ПодключаемоеОборудованиеРТ.НастроитьПодключаемоеОборудование(ЭтотОбъект);
	
	Если ЗначениеЗаполнено(ВладелецСерии) Тогда
		Элементы.ВладелецСерии.Видимость = Ложь;
	КонецЕсли;
	
	НастроитьПоШаблону();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
    
    // &ЗамерПроизводительности
    ОценкаПроизводительностиРТКлиент.НачатьЗамер(
		     Истина, "Справочник.СерииНоменклатуры.Форма.ФормаСписка.Открытие");

	// ПодключаемоеОборудование
	МенеджерОборудованияКлиент.НачатьПодключениеОборудованиеПриОткрытииФормы(Неопределено, ЭтотОбъект, "СканерШтрихкода");
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

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ВладелецСерииПриИзменении(Элемент)
	
	НастроитьПоШаблону();
	
КонецПроцедуры

&НаКлиенте
Процедура ВладелецСерииНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	СписокВыбора = Новый СписокЗначений;
	СписокВыбора.Добавить(НСтр("ru = 'Вид номенклатуры'"));
	СписокВыбора.Добавить(НСтр("ru = 'Позиция номенклатуры'"));
	
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("СписокВыбора", СписокВыбора);
	
	ОбработчикОповещения = Новый ОписаниеОповещения("ОповещениеВыборИзСписка", ЭтотОбъект, ДополнительныеПараметры);
	Режим = РежимОткрытияОкнаФормы.БлокироватьВесьИнтерфейс;
	
	ПоказатьВыборИзСписка(ОбработчикОповещения, СписокВыбора, Элементы.ВладелецСерии);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура НомерПриИзменении(Элемент)
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(Список.Отбор, 
														 "Номер",
														 Номер,
														 ВидСравненияКомпоновкиДанных.Содержит,
														 ,
														 ЗначениеЗаполнено(Номер));
														 
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаКлиенте
Процедура СписокПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
    
    // &ЗамерПроизводительности
    ОценкаПроизводительностиРТКлиент.НачатьЗамер(
             Истина, "Справочник.СерииНоменклатуры.Форма.ФормаЭлемента.СозданиеНового");

    Если Не Копирование Тогда
		Отказ = Истина;
		
		Если Не ЗначениеЗаполнено(ВладелецСерии) Тогда
			ТекстПредупреждения = НСтр("ru = 'Перед добавлением серии необходимо указать владельца.'");
			
			ПоказатьПредупреждение(, ТекстПредупреждения);
			Возврат;
		КонецЕсли;
		
		ЗначенияЗаполнения = Новый Структура;
		ЗначенияЗаполнения.Вставить("ВладелецСерии",ВладелецСерии);
		
		ОткрытьФорму("Справочник.СерииНоменклатуры.ФормаОбъекта", 
			Новый Структура("ЗначенияЗаполнения",ЗначенияЗаполнения), Элементы.Список);
				
	КонецЕсли;	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Функция ВидыНоменклатурыИндивидуальныеДляНоменклатуры()

	Возврат Справочники.СерииНоменклатуры.ВидыНоменклатурыИндивидуальныеДляНоменклатуры()

КонецФункции // ВидыНоменклатурыИндивидуальныеДляНоменклатуры()
 
&НаСервере
Процедура НастроитьПоШаблону()
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(Список.Отбор,
														 "ВладелецСерии",
														 ВладелецСерии,
														 ВидСравненияКомпоновкиДанных.Равно,
														 ,
														 Истина);
														 
	ВидНоменклатуры = Справочники.СерииНоменклатуры.ЗаполнитьВидНоменклатуры(ВладелецСерии);
	
	Если ЗначениеЗаполнено(ВидНоменклатуры) Тогда
		ПараметрыШаблона = Новый ФиксированнаяСтруктура(
			ЗначениеНастроекПовтИсп.ПараметрыСерийНоменклатуры(ВидНоменклатуры, ВладелецСерии));
		
		Если ПараметрыШаблона.ИспользоватьСрокГодностиСерии Тогда
			Элементы.СписокГоденДо.Формат = ПараметрыШаблона.ФорматнаяСтрокаСрокаГодности;
		КонецЕсли;
		
		Элементы.СписокГоденДо.Видимость = ПараметрыШаблона.ИспользоватьСрокГодностиСерии;
		Элементы.НомерКиЗГИСМ.Видимость  = ПараметрыШаблона.ИспользоватьНомерКИЗГИСМСерии;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ВладелецСерии) Тогда
		Если ТипЗнч(ВладелецСерии) = Тип("СправочникСсылка.ВидыНоменклатуры") Тогда
			Элементы.ВладелецСерии.Заголовок = НСтр("ru = 'Вид номенклатуры'");
		ИначеЕсли ТипЗнч(ВладелецСерии) = Тип("СправочникСсылка.Номенклатура") Тогда
			Элементы.ВладелецСерии.Заголовок = НСтр("ru = 'Номенклатура'");
		Иначе
			Элементы.ВладелецСерии.Заголовок = НСтр("ru = 'Владелец'");
		КонецЕсли;
	Иначе
		Элементы.ВладелецСерии.Заголовок = НСтр("ru = 'Владелец'");
	КонецЕсли;
	
	ПодборТоваровКлиентСервер.УстановитьВидимостьШапкиТаблицаФормы(Элементы.Список);
	
	ЭтотОбъект.Заголовок = НСтр("ru = 'Серии'") + ?(ЗначениеЗаполнено(ВладелецСерии),": " + Строка(ВладелецСерии),"");
КонецПроцедуры

#КонецОбласти