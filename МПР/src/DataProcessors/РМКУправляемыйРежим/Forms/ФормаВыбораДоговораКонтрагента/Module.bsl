
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Если Параметры.Свойство("КассаККМ") Тогда
		ЗаполнитьСписокВыбора(Параметры.КассаККМ);
	Иначе
		Отказ = Истина;
	КонецЕсли;
	
	УстановитьУсловноеОформление();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ЗафиксироватьВыборСтроки();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КомандаВниз(Команда)
	
	ПередвинутьПозицию(1)
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаВверх(Команда)
	
	ПередвинутьПозицию(-1)
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаВыбрать(Команда)
	
	ЗафиксироватьВыборСтроки();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	УсловноеОформление.Элементы.Очистить();
	
	// Собственные средства.
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных("СписокДоговорКонтрагента");
	
	ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(
		Элемент.Отбор,
		"Список.ДоговорКонтрагента",
		ВидСравненияКомпоновкиДанных.НеЗаполнено);
	
	Элемент.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru='Собственные средства'"));
	
КонецПроцедуры

&НаКлиенте
Процедура ПередвинутьПозицию(Движение)
	// Вставить содержимое обработчика.
	Если Список.Количество() < 2 Тогда
		Возврат;
	КонецЕсли;
	
	ТекущиеДанные = Элементы.Список.ТекущиеДанные;
	
	Если ТекущиеДанные = Неопределено  Тогда
		ИндексСтроки = 0;
	Иначе
		ИндексСтроки = Список.Индекс(ТекущиеДанные);
	КонецЕсли;
	
	ИндексСтроки = ИндексСтроки + Движение;
	
	Если ИндексСтроки > (Список.Количество() - 1) Тогда
		ИндексСтроки = 0;
	ИначеЕсли ИндексСтроки < 0 Тогда
		ИндексСтроки = Список.Количество() - 1;
	КонецЕсли;
	
	ТекущиеДанные = Список[ИндексСтроки];
	Элементы.Список.ТекущаяСтрока = ТекущиеДанные.ПолучитьИдентификатор();
	
КонецПроцедуры

&НаКлиенте
Процедура ЗафиксироватьВыборСтроки()
	
	ТекущиеДанные = Элементы.Список.ТекущиеДанные;
	
	Если ТекущиеДанные = Неопределено Тогда
		Закрыть();
	Иначе
		СтруктураСтроки = Новый Структура;
		СтруктураСтроки.Вставить("ДоговорКонтрагента", ТекущиеДанные.ДоговорКонтрагента);
		СтруктураСтроки.Вставить("СуммаОстаток"      , ТекущиеДанные.СуммаОстаток);
		
		Закрыть(СтруктураСтроки)
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСписокВыбора(КассаККМ)
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ВложенныйЗапрос.ДоговорКонтрагента КАК ДоговорКонтрагента,
	|	СУММА(ВложенныйЗапрос.СуммаОстаток) КАК СуммаОстаток
	|ИЗ
	|	(ВЫБРАТЬ
	|		ДенежныеСредстваККМОстатки.ДоговорКонтрагента КАК ДоговорКонтрагента,
	|		ДенежныеСредстваККМОстатки.СуммаОстаток КАК СуммаОстаток
	|	ИЗ
	|		РегистрНакопления.ДенежныеСредстваККМ.Остатки(, КассаККМ = &КассаККМ) КАК ДенежныеСредстваККМОстатки
	|	ГДЕ
	|		ДенежныеСредстваККМОстатки.СуммаОстаток > 0
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		ЗНАЧЕНИЕ(Справочник.ДоговорыКонтрагентов.ПустаяСсылка),
	|		0) КАК ВложенныйЗапрос
	|
	|СГРУППИРОВАТЬ ПО
	|	ВложенныйЗапрос.ДоговорКонтрагента
	|
	|УПОРЯДОЧИТЬ ПО
	|	ДоговорКонтрагента";
	
	Запрос.УстановитьПараметр("КассаККМ", КассаККМ);
	
	Результат = Запрос.Выполнить();
	
	Список.Загрузить(Результат.Выгрузить());
	
КонецПроцедуры

#КонецОбласти
