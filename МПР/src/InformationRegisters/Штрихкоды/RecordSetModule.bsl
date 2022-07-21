#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

// Процедура - обработчик события "ПередЗаписью".
//
Процедура ПередЗаписью(Отказ, Замещение)

	Если ОбменДанными.Загрузка Тогда
		
		Возврат;
		
	КонецЕсли;
	
КонецПроцедуры 

// Процедура - обработчик события "ОбработкаПроверкиЗаполнения".
//
Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	ИспользоватьНеуникальныеШтрихкоды = ЗначениеНастроекПовтИсп.ПолучитьЗначениеКонстанты("ИспользоватьНеуникальныеШтрихкоды");
	ИспользоватьНеуникальныеКодыИнформационныхКарт = ЗначениеНастроекПовтИсп.ПолучитьЗначениеКонстанты("ИспользоватьНеуникальныеКодыИнформационныхКарт");
	Если (НЕ ИспользоватьНеуникальныеШтрихкоды)
		ИЛИ (НЕ ИспользоватьНеуникальныеКодыИнформационныхКарт) Тогда
			
		Запрос = Новый Запрос("ВЫБРАТЬ
		|	ТаблицаРегистра.Штрихкод,
		|	ТаблицаРегистра.Владелец,
		|	ТаблицаРегистра.Характеристика,
		|	ТаблицаРегистра.Упаковка
		|ПОМЕСТИТЬ ТаблицаРегистра
		|ИЗ
		|	&ТаблицаРегистра КАК ТаблицаРегистра
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	МАКСИМУМ(Штрихкоды.Владелец) КАК Владелец,
		|	ТаблицаРегистра.Штрихкод КАК Штрихкод
		|ИЗ
		|	ТаблицаРегистра КАК ТаблицаРегистра
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.Штрихкоды КАК Штрихкоды
		|		ПО ТаблицаРегистра.Штрихкод = Штрихкоды.Штрихкод
		|			И (ТаблицаРегистра.Владелец <> Штрихкоды.Владелец ИЛИ ТаблицаРегистра.Характеристика <> Штрихкоды.Характеристика ИЛИ ТаблицаРегистра.Упаковка <> Штрихкоды.Упаковка)
		|			И ((&ПроверятьКарты И ТаблицаРегистра.Владелец Ссылка Справочник.ИнформационныеКарты)
		|			ИЛИ (&ПроверятьНоменклатуру И НЕ ТаблицаРегистра.Владелец Ссылка Справочник.ИнформационныеКарты))
		|ГДЕ
		|	ТаблицаРегистра.Штрихкод <> """"
		|
		|СГРУППИРОВАТЬ ПО
		|	ТаблицаРегистра.Штрихкод");
							  
		Запрос.УстановитьПараметр("ТаблицаРегистра", ЭтотОбъект.Выгрузить());
		Запрос.УстановитьПараметр("ПроверятьКарты", НЕ ИспользоватьНеуникальныеКодыИнформационныхКарт);
		Запрос.УстановитьПараметр("ПроверятьНоменклатуру", НЕ ИспользоватьНеуникальныеШтрихкоды);
		Выборка = Запрос.Выполнить().Выбрать();
		ТекстСообщения = "";
		
		Пока Выборка.Следующий() Цикл
			ТекстСообщения = ТекстСообщения
							+ СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Штрихкод %1 уже существует, владелец %2.'"),
																						Выборка.Штрихкод,
																						Выборка.Владелец)
							+ Символы.ПС;
		КонецЦикла;	
		
		Если ТекстСообщения <> "" Тогда
			ОбщегоНазначения.СообщитьПользователю(ТекстСообщения,,,,Отказ);
		КонецЕсли;
		
	КонецЕсли;
		
	Если Не ПолучитьФункциональнуюОпцию("ИспользоватьХарактеристикиНоменклатуры") Тогда
		Возврат;
	КонецЕсли;
	
	МассивНепроверяемыхРеквизитов = Новый Массив;
	МассивНепроверяемыхРеквизитов.Добавить("Характеристика");

	Запрос = Новый Запрос("ВЫБРАТЬ
	|	ТаблицаТоваров.Владелец КАК Номенклатура
	|ПОМЕСТИТЬ СтрокиСОшибками
	|ИЗ
	|	&ТаблицаТоваров КАК ТаблицаТоваров
	|ГДЕ
	|	ТаблицаТоваров.Характеристика = ЗНАЧЕНИЕ(Справочник.ХарактеристикиНоменклатуры.ПустаяСсылка)
	|	И ТаблицаТоваров.Владелец ССЫЛКА Справочник.Номенклатура
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВЫБОР
	|		КОГДА ВЫРАЗИТЬ(СтрокиСОшибками.Номенклатура КАК Справочник.Номенклатура).ВидНоменклатуры.ИспользованиеХарактеристик = ЗНАЧЕНИЕ(Перечисление.ВариантыВеденияДополнительныхДанныхПоНоменклатуре.ОбщиеДляВидаНоменклатуры)
	|				ИЛИ ВЫРАЗИТЬ(СтрокиСОшибками.Номенклатура КАК Справочник.Номенклатура).ВидНоменклатуры.ИспользованиеХарактеристик = ЗНАЧЕНИЕ(Перечисление.ВариантыВеденияДополнительныхДанныхПоНоменклатуре.ИндивидуальныеДляНоменклатуры)
	|			ТОГДА ИСТИНА
	|		ИНАЧЕ ЛОЖЬ
	|	КОНЕЦ КАК НеЗаполненаХарактеристика
	|ИЗ
	|	СтрокиСОшибками КАК СтрокиСОшибками
	|ГДЕ
	|	ВЫРАЗИТЬ(СтрокиСОшибками.Номенклатура КАК Справочник.Номенклатура).ВидНоменклатуры.ИспользованиеХарактеристик <> ЗНАЧЕНИЕ(Перечисление.ВариантыВеденияДополнительныхДанныхПоНоменклатуре.НеИспользовать)");
    	
	Запрос.УстановитьПараметр("ТаблицаТоваров",  ЭтотОбъект.Выгрузить(,"НомерСтроки,Владелец,Характеристика"));
	
	ШаблонСообщения = НСтр("ru='Поле ""%Характеристика%"" не заполнено'");
	ТекстСообщения = СтрЗаменить(ШаблонСообщения, "%Характеристика%", НСтр("ru = 'Характеристика'"));
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		
		Если Выборка.НеЗаполненаХарактеристика Тогда
			ОбщегоНазначения.СообщитьПользователю(ТекстСообщения,,"Характеристика","Запись",Отказ);
		КонецЕсли;
		
	КонецЦикла;
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты,МассивНепроверяемыхРеквизитов);

КонецПроцедуры

#КонецОбласти

#КонецЕсли


