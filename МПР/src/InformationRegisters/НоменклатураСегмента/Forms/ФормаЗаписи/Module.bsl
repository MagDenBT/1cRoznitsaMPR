#Область ОписаниеПеременных

&НаКлиенте
Перем КэшированныеЗначения;

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если ЗначениеЗаполнено(Запись.Номенклатура) Тогда
		СтруктураРеквизитов = Новый Структура("ИспользованиеХарактеристик", "ВидНоменклатуры.ИспользованиеХарактеристик");
		ИспользованиеХарактеристик = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Запись.Номенклатура, СтруктураРеквизитов).ИспользованиеХарактеристик;
		Если ИспользованиеХарактеристик = Перечисления.ВариантыВеденияДополнительныхДанныхПоНоменклатуре.НеИспользовать Тогда
			ХарактеристикиИспользуются = Ложь;
		Иначе
			ХарактеристикиИспользуются = Истина;
		КонецЕсли;
	Иначе
		ХарактеристикиИспользуются = Ложь;
	КонецЕсли;
	
	УстановитьДоступностьХарактеристики();
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	Если ХарактеристикиИспользуются Тогда
		Если ЗначениеЗаполнено(Запись.Характеристика) Тогда
			РезультатПроверки = Справочники.Номенклатура.ПроверитьПринадлежностьХарактеристикиИУпаковкиВладельцу(Запись.Номенклатура,
																													Запись.Характеристика,
																													Справочники.НаборыУпаковок.ПустаяСсылка());
			Если НЕ ЗначениеЗаполнено(РезультатПроверки.Характеристика) Тогда
				ОбщегоНазначения.СообщитьПользователю(Нстр("ru = 'Указанная характеристика не принадлежит выбранной номенклатуре.'"),
					,
				    "Характеристика",
					"Запись");
				Отказ = Истина;
			КонецЕсли;
		Иначе
			ОбщегоНазначения.СообщитьПользователю(Нстр("ru = 'Не указана характеристика.'"),
				,
			    "Характеристика",
				"Запись");
			Отказ = Истина;
		КонецЕсли;
	КонецЕсли;
	
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
        
    // &ЗамерПроизводительности
    ОценкаПроизводительностиРТКлиент.НачатьЗамер(
             Истина, "РегистрСведений.НоменклатураСегмента.Форма.ФормаЗаписи.Открытие");

КонецПроцедуры

&НаКлиенте
Процедура ОбработатьСозданиеИВыборНовойХарактеристики(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Запись[ДополнительныеПараметры.ИмяРеквизита] = Результат;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура НоменклатураПриИзменении(Элемент)
	
	СтруктураДействий = Новый Структура;
	СтруктураДействий.Вставить("ПроверитьХарактеристикуПоВладельцу", Запись.Характеристика);
	
	СтруктураСтроки = Новый Структура;
	СтруктураСтроки.Вставить("Номенклатура", Запись.Номенклатура);
	СтруктураСтроки.Вставить("Характеристика", Запись.Характеристика);
	СтруктураСтроки.Вставить("ХарактеристикиИспользуются", ХарактеристикиИспользуются);
	
	ОбработкаТабличнойЧастиТоварыКлиент.ПриИзмененииРеквизитовВТЧКлиент(Неопределено, СтруктураСтроки, СтруктураДействий, КэшированныеЗначения);

	ЗаполнитьЗначенияСвойств(Запись, СтруктураСтроки);
	
	ХарактеристикиИспользуются = СтруктураСтроки.ХарактеристикиИспользуются;
	УстановитьДоступностьХарактеристики();
	
КонецПроцедуры

&НаКлиенте
Процедура ХарактеристикаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ОбработкаТабличнойЧастиТоварыКлиент.ВыбратьХарактеристикуНоменклатуры(ЭтаФорма, Элемент, СтандартнаяОбработка, Запись);
	
КонецПроцедуры

&НаКлиенте
Процедура ХарактеристикаСоздание(Элемент, СтандартнаяОбработка)
	
	ТекущаяСтрока = Новый Структура;
	ТекущаяСтрока.Вставить("Номенклатура", Запись.Номенклатура);
	ТекущаяСтрока.Вставить("Характеристика", Запись.Характеристика);
	ТекущаяСтрока.Вставить("ИдентификаторТекущейСтроки", 0);
	
	ОбработкаТабличнойЧастиТоварыКлиент.СоздатьХарактеристикуНоменклатуры(ЭтотОбъект, Элемент, СтандартнаяОбработка, ТекущаяСтрока);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьДоступностьХарактеристики()
	
	Элементы.Характеристика.Доступность = ХарактеристикиИспользуются;
	Элементы.Характеристика.АвтоОтметкаНезаполненного = ХарактеристикиИспользуются;
	
КонецПроцедуры

#КонецОбласти


