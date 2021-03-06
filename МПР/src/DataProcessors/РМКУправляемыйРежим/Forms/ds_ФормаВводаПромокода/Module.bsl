
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Номенклатура = Параметры.Номенклатура;

КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	МенеджерОборудованияКлиент.НачатьПодключениеОборудованиеПриОткрытииФормы(Неопределено, ЭтотОбъект, "СканерШтрихкода");
	
КонецПроцедуры

&НаКлиенте
Процедура ВнешнееСобытие(Источник, Событие, Данные)
	
	Если Событие = "Штрихкод" Тогда
		Закрыть(НайтиСкидку(Данные));	
	КонецЕсли;	
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	
	МенеджерОборудованияКлиент.НачатьОтключениеОборудованиеПриЗакрытииФормы(Неопределено, ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КомандаВыбрать(Команда)
	
	Закрыть(НайтиСкидку(Промокод));
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Функция НайтиСкидку(КодСкидки)
	
	СтруктураРезультат = Новый Структура;
	СтруктураРезультат.Вставить("Промокод", КодСкидки);
	СтруктураРезультат.Вставить("ТекстСообщения", "");
	СтруктураРезультат.Вставить("ЗначениеСкидки", 0);
	СтруктураРезультат.Вставить("СпособПредоставления");

	ТаблицаСкидок = СкидкиНаценкиСерверПереопределяемый.СкидкиДляКупона(КодСкидки);
	Если ТаблицаСкидок.Количество() = 0 Тогда
		СтруктураРезультат.ТекстСообщения = НСтр("ru = 'Не найдено действующей скидки для кода %1'");
		СтруктураРезультат.ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(СтруктураРезультат.ТекстСообщения, КодСкидки);
	Иначе
		Магазин = ПараметрыСеанса.ТекущийМагазин;
		
		Запрос = Новый Запрос;
		Запрос.Текст =
		"выбрать
		|	ТаблицаСкидок.Скидка,
		|	ТаблицаСкидок.Состояние,
		|	ТаблицаСкидок.Магазин
		|ПОМЕСТИТЬ ТаблицаСкидок
		|ИЗ
		|	&ТаблицаСкидок КАК ТаблицаСкидок
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ ПЕРВЫЕ 1
		|	ТаблицаСкидок.Скидка КАК Скидка,
		|	ТаблицаСкидок.Скидка.ЗначениеСкидкиНаценки КАК ЗначениеСкидки,
		|	ТаблицаСкидок.Скидка.СпособПредоставления КАК СпособПредоставления
		|ИЗ
		|	ТаблицаСкидок КАК ТаблицаСкидок
		|ГДЕ
		|	ТаблицаСкидок.Состояние = ЗНАЧЕНИЕ(Перечисление.СостоянияОднократныхСкидок.Активна)
		|	И ТаблицаСкидок.Скидка.ОбластьПредоставления = ЗНАЧЕНИЕ(Перечисление.ВариантыОбластейОграниченияСкидокНаценок.ВСтроке)
		|	И (ТаблицаСкидок.Магазин = ЗНАЧЕНИЕ(Справочник.Магазины.ПустаяСсылка) ИЛИ ТаблицаСкидок.Магазин = &Магазин)";
		Запрос.УстановитьПараметр("ТаблицаСкидок", ТаблицаСкидок);
		Запрос.УстановитьПараметр("Магазин", Магазин);
		
		РезультатЗапроса = Запрос.Выполнить();
		Если Не РезультатЗапроса.Пустой() Тогда
			Выборка = РезультатЗапроса.Выбрать();
			Выборка.Следующий();
			
			ТаблицаДляПроверки = Новый ТаблицаЗначений();
			ТаблицаДляПроверки.Колонки.Добавить("Номенклатура", Новый ОписаниеТипов("СправочникСсылка.Номенклатура"));
			ТаблицаДляПроверки.Колонки.Добавить("КлючСвязи", ОбщегоНазначения.ОписаниеТипаЧисло(1));
			ТаблицаДляПроверки.Колонки.Добавить("ИсключенаИзРасчета", Новый ОписаниеТипов("Булево"));
			
			НовСтр = ТаблицаДляПроверки.Добавить();
			НовСтр.Номенклатура = Номенклатура;
			НовСтр.ИсключенаИзРасчета = Ложь;
			НовСтр.КлючСвязи = 1;
			
			ds_ОбщегоНазначенияВызовСервера.ИсключитьИзРасчетаСкидокПоКатегорииНоменклатуры(Магазин, Выборка.Скидка, ТаблицаДляПроверки);
			
			Если ТаблицаДляПроверки[0].ИсключенаИзРасчета Тогда
				СтруктураРезультат.ТекстСообщения = "Промокод не действует на товар с категорией!";	
			Иначе	
				ЗаполнитьЗначенияСвойств(СтруктураРезультат, Выборка);
			КонецЕсли;		
		КонецЕсли;	
	КонецЕсли;
	
	Возврат СтруктураРезультат;
	
КонецФункции

#КонецОбласти


