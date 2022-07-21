
#Область ОбработчикиСобытий

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	ПараметрыФормы = ПодготовитьСтруктуруПечати(ПараметрКоманды);
	Если ПараметрыФормы <> Неопределено Тогда
		ОткрытьФорму(
			"Обработка.ПечатьЭтикетокИЦенников.Форма.Форма",
			ПараметрыФормы,
			ПараметрыВыполненияКоманды.Источник,
			ПараметрыВыполненияКоманды.Уникальность,
			ПараметрыВыполненияКоманды.Окно,
			ПараметрыВыполненияКоманды.НавигационнаяСсылка);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Функция ПодготовитьСтруктуруПечати(ПараметрКоманды)
	
	ЗапросТипКарт = Новый Запрос;
	ЗапросТипКарт.Текст = "ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ИнформационныеКарты.ТипКарты
	|ИЗ
	|	Справочник.ИнформационныеКарты КАК ИнформационныеКарты
	|ГДЕ
	|	НЕ ИнформационныеКарты.ЭтоГруппа
	|	И ИнформационныеКарты.Ссылка В ИЕРАРХИИ(&МассивКарт)";
	ЗапросТипКарт.УстановитьПараметр("МассивКарт", ПараметрКоманды);
	Выборка = ЗапросТипКарт.Выполнить().Выбрать();
	ТипКарты = Неопределено;
	Пока Выборка.Следующий() Цикл
		Если ЗначениеЗаполнено(Выборка.ТипКарты) Тогда
			ТипКарты = Выборка.ТипКарты;
			Прервать;
		КонецЕсли;
	КонецЦикла;
	Если НЕ ЗначениеЗаполнено(ТипКарты) Тогда
		Возврат Неопределено;
	КонецЕсли;
	ТекущийМагазин = ОбщегоНазначенияРТ.ОпределитьТекущийМагазин();
	Если ЗначениеЗаполнено(ТекущийМагазин) Тогда
		Организация = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ТекущийМагазин, "СкладПродажи.Организация");
	Иначе
		Организация = Справочники.Организации.ПустаяСсылка();
	КонецЕсли;
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	|	ИнформационныеКарты.Ссылка КАК Карта,
	|	МАКСИМУМ(ЕСТЬNULL(Штрихкоды.Штрихкод, """")) КАК Штрихкод,
	|	1 КАК КоличествоЭтикеток,
	|	&Организация КАК Организация
	|ИЗ
	|	Справочник.ИнформационныеКарты КАК ИнформационныеКарты
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.Штрихкоды КАК Штрихкоды
	|		ПО (Штрихкоды.Владелец = ИнформационныеКарты.Ссылка)
	|ГДЕ
	|	НЕ ИнформационныеКарты.ЭтоГруппа
	|	И ИнформационныеКарты.ТипКарты = &ТипКарты
	|	И ИнформационныеКарты.Ссылка В ИЕРАРХИИ(&МассивКарт)
	|
	|СГРУППИРОВАТЬ ПО
	|	ИнформационныеКарты.Ссылка";
	Запрос.УстановитьПараметр("МассивКарт", ПараметрКоманды);
	Запрос.УстановитьПараметр("ТипКарты", ТипКарты);
	Запрос.УстановитьПараметр("Организация", Организация);
	Карты = Запрос.Выполнить().Выгрузить();
	
	СтруктураДействий = Новый Структура;
	СтруктураДействий.Вставить("ЗаполнитьМагазин", ТекущийМагазин);
	
	СтруктураРезультат = Новый Структура;
	Если ТипКарты = Перечисления.ТипыИнформационныхКарт.Регистрационная Тогда
		СтруктураРезультат.Вставить("РегистрационныеКарты", Карты);
	Иначе
		СтруктураРезультат.Вставить("ДисконтныеКарты", Карты);
	КонецЕсли;
	СтруктураРезультат.Вставить("СтруктураДействий", СтруктураДействий);
	СтруктураПараметры = Новый Структура("АдресВХранилище", ПоместитьВоВременноеХранилище(СтруктураРезультат));
	
	Возврат СтруктураПараметры;
	
КонецФункции

#КонецОбласти
