
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

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Параметры.ТекущаяСтрока) Тогда
		РеквизитыСерии = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Параметры.ТекущаяСтрока,
			Новый Структура("ВладелецСерии","ВладелецСерии"));
			
		ВладелецСерии = РеквизитыСерии.ВладелецСерии;
	ИначеЕсли Параметры.Свойство("Номенклатура") И ЗначениеЗаполнено(Параметры.Номенклатура) Тогда
		ВидНоменклатуры = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Параметры.Номенклатура, "ВидНоменклатуры");
		ИспользованиеСерий = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ВидНоменклатуры, "ИспользованиеСерий");
		
		Если ИспользованиеСерий = Перечисления.ВариантыВеденияДополнительныхДанныхПоНоменклатуре.ОбщиеДляВидаНоменклатуры Тогда
			ВладелецСерии = ВидНоменклатуры;
		Иначе
			ВладелецСерии = Параметры.Номенклатура;
		КонецЕсли;
	КонецЕсли;
	
	ПодключаемоеОборудованиеРТ.НастроитьПодключаемоеОборудование(ЭтотОбъект);
	
	Элементы.ВладелецСерии.ТолькоПросмотр = ЗначениеЗаполнено(ВладелецСерии);
	
	НастроитьПоШаблону();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
    
    // &ЗамерПроизводительности
    ОценкаПроизводительностиРТКлиент.НачатьЗамер(
		     Истина, "Справочник.СерииНоменклатуры.Форма.ФормаВыбора.Открытие");

	// ПодключаемоеОборудование
	МенеджерОборудованияКлиент.НачатьПодключениеОборудованиеПриОткрытииФормы(Неопределено, ЭтотОбъект, "СканерШтрихкода");
	// Конец ПодключаемоеОборудование
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии()
	
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
Процедура НомерПриИзменении(Элемент)
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(Список.Отбор, 
														 "Номер",
														 Номер,
														 ВидСравненияКомпоновкиДанных.Содержит,
														 ,
														 ЗначениеЗаполнено(Номер));
	
КонецПроцедуры

&НаКлиенте
Процедура ГоденДоПриИзменении(Элемент)
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(Список.Отбор,
														 "ГоденДо",
														 ГоденДо,
														 ВидСравненияКомпоновкиДанных.Равно,
														 ,
														 ЗначениеЗаполнено(ГоденДо));
	
КонецПроцедуры

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

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаКлиенте
Процедура СписокПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	Если Не Копирование Тогда
		Отказ = Истина;
		
		Если Не ЗначениеЗаполнено(ВладелецСерии) Тогда
			ТекстПредупреждения = НСтр("ru = 'Перед добавлением серии необходимо указать владельца.'");
			
			ПоказатьПредупреждение(,ТекстПредупреждения);
			Возврат;
		КонецЕсли;
		
		ЗначенияЗаполнения = Новый Структура;
		ЗначенияЗаполнения.Вставить("ВладелецСерии",ВладелецСерии);
		ЗначенияЗаполнения.Вставить("Номер",Номер);
		ЗначенияЗаполнения.Вставить("ГоденДо",ГоденДо);
		
		ОткрытьФорму("Справочник.СерииНоменклатуры.ФормаОбъекта", 
			Новый Структура("ЗначенияЗаполнения",ЗначенияЗаполнения), Элементы.Список);
				
	КонецЕсли;	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

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
		
		Элементы.ГоденДо.Видимость = ПараметрыШаблона.ИспользоватьСрокГодностиСерии;
		
		Если ПараметрыШаблона.ИспользоватьСрокГодностиСерии Тогда
			Элементы.ГоденДо.Формат               = ПараметрыШаблона.ФорматнаяСтрокаСрокаГодности;
			Элементы.ГоденДо.ФорматРедактирования = ПараметрыШаблона.ФорматнаяСтрокаСрокаГодности;
			
			Элементы.СписокГоденДо.Формат = ПараметрыШаблона.ФорматнаяСтрокаСрокаГодности;
		КонецЕсли;
		
		Элементы.СписокГоденДо.Видимость = ПараметрыШаблона.ИспользоватьСрокГодностиСерии;
		Элементы.СписокНомер.Видимость   = ПараметрыШаблона.ИспользоватьНомерСерии;
		
	КонецЕсли;
	
	ПодборТоваровКлиентСервер.УстановитьВидимостьШапкиТаблицаФормы(Элементы.Список);
	
	ЭтотОбъект.Заголовок = "Серии" + ?(ЗначениеЗаполнено(ВладелецСерии),": " + Строка(ВладелецСерии),"");
	
КонецПроцедуры

&НаСервере
Функция ВидыНоменклатурыИндивидуальныеДляНоменклатуры()

	Возврат Справочники.СерииНоменклатуры.ВидыНоменклатурыИндивидуальныеДляНоменклатуры()

КонецФункции // ВидыНоменклатурыИндивидуальныеДляНоменклатуры()

#КонецОбласти