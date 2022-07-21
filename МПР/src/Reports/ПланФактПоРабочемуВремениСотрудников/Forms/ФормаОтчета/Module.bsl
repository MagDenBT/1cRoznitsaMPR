#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ОтчетОбъект = РеквизитФормыВЗначение("Отчет");
	АдресХранилищаСКД = ПоместитьВоВременноеХранилище(ОтчетОбъект.ПолучитьМакет("ОсновнаяСхемаКомпоновкиДанных"), Новый УникальныйИдентификатор);
	
КонецПроцедуры

&НаСервере
Процедура ПриЗагрузкеПользовательскихНастроекНаСервере(Настройки)
	Если Параметры.Свойство("ЭтоРасшифровка") Тогда
		Отчет.КомпоновщикНастроек.Настройки.Отбор.Элементы.Очистить();
		ПараметрДанных = Отчет.КомпоновщикНастроек.Настройки.ПараметрыДанных.Элементы.Найти("Период");
		Если ПараметрДанных <> Неопределено Тогда
			ПараметрПользовательскойНастройки =
				Отчет.КомпоновщикНастроек.ПользовательскиеНастройки.Элементы.Найти(
					ПараметрДанных.ИдентификаторПользовательскойНастройки);
			Если ПараметрПользовательскойНастройки <> Неопределено Тогда
					ПараметрПользовательскойНастройки.Значение = Параметры.Период;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ПриСохраненииПользовательскихНастроекНаСервере(Настройки)
	
	ВариантыОтчетов.ПриСохраненииПользовательскихНастроекНаСервере(ЭтотОбъект, Настройки);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура РезультатОбработкаРасшифровки(Элемент, Расшифровка, СтандартнаяОбработка)
	
	ОбработкаРасшифровки = Новый ОбработкаРасшифровкиКомпоновкиДанных(
		ДанныеРасшифровки, 
		Новый ИсточникДоступныхНастроекКомпоновкиДанных(АдресХранилищаСКД));
	СтандартнаяОбработка = Ложь;
	
	ДоступныеДействия = Новый Массив();
	ДоступныеДействия.Добавить(ДействиеОбработкиРасшифровкиКомпоновкиДанных.ОткрытьЗначение);
	ВыполненноеДействие = Неопределено;
	ДополнительноеМеню = Новый СписокЗначений();
	Если КлючТекущегоВарианта <> "ПланФактДетальный" Тогда
		ДополнительноеМеню.Добавить("ПланФактДетально", Нстр("ru='План/Факт рабочего времени (детально)'"));
	КонецЕсли;
	
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("Расшифровка", Расшифровка);
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ОбработкаРасшифровки", ЭтотОбъект, ДополнительныеПараметры);
	
	ОбработкаРасшифровки.ПоказатьВыборДействия(
		ОписаниеОповещения,
		Расшифровка,
		ДоступныеДействия,
		ДополнительноеМеню);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ОбработкаРасшифровки(ВыполненноеДействие, ПараметрВыполненногоДействия, ДополнительныеПараметры) Экспорт
	
	Расшифровка = ДополнительныеПараметры.Расшифровка;
	
	Если ВыполненноеДействие = ДействиеОбработкиРасшифровкиКомпоновкиДанных.ОткрытьЗначение Тогда
		ПоказатьЗначение(,ПараметрВыполненногоДействия);
	ИначеЕсли ВыполненноеДействие = "ПланФактДетально" Тогда
		СтруктураОтборов = ПолучитьПоляРасшифровки(Расшифровка);
		ПараметрКомпоновкиДанныхПериод = Отчет.КомпоновщикНастроек.Настройки.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("Период"));
		ПараметрКомпоновкиДанныхПериод = Отчет.КомпоновщикНастроек.ПользовательскиеНастройки.Элементы.Найти(ПараметрКомпоновкиДанныхПериод.ИдентификаторПользовательскойНастройки);
		СтандартныйПериод = Новый СтандартныйПериод();
		СтандартныйПериод.Вариант = ВариантСтандартногоПериода.ПроизвольныйПериод;
		
		Если ПараметрКомпоновкиДанныхПериод <> Неопределено Тогда
			СтандартныйПериод.ДатаНачала = ПараметрКомпоновкиДанныхПериод.Значение.ДатаНачала;
			СтандартныйПериод.ДатаОкончания = ПараметрКомпоновкиДанныхПериод.Значение.ДатаОкончания;
		КонецЕсли;
		
		КоличествоЭлементов = Отчет.КомпоновщикНастроек.Настройки.Отбор.Элементы.Количество();
		Для К=0 По КоличествоЭлементов-1 Цикл
			Если Отчет.КомпоновщикНастроек.Настройки.Отбор.Элементы[К].ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ЕстьОтклонение") Тогда
				ЕстьОтклонение = Отчет.КомпоновщикНастроек.ПользовательскиеНастройки.Элементы.Найти(Отчет.КомпоновщикНастроек.Настройки.Отбор.Элементы[К].ИдентификаторПользовательскойНастройки);
				Если ЕстьОтклонение.Использование Тогда
					СтруктураОтборов.Вставить("ЕстьОтклонение", ЕстьОтклонение.ПравоеЗначение);
				КонецЕсли;
			КонецЕсли;	
		КонецЦикла;
		
		ПараметрыФормы = Новый Структура();
		ПараметрыФормы.Вставить("Отбор", СтруктураОтборов);
		ПараметрыФормы.Вставить("Период", СтандартныйПериод);
		ПараметрыФормы.Вставить("КлючВарианта", "ПланФактДетальный");
		ПараметрыФормы.Вставить("КлючНазначенияИспользования", "ПланФактДетальныйРасшифровка");
		ПараметрыФормы.Вставить("СформироватьПриОткрытии", Истина);
		ПараметрыФормы.Вставить("ЭтоРасшифровка");
		ОткрытьФорму("Отчет.ПланФактПоРабочемуВремениСотрудников.Форма", ПараметрыФормы, ЭтаФорма,,,,,РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	КонецЕсли;
	
КонецПроцедуры

// Процедура получает поля и значения для выбранного поля расшифровки.
// Параметры:
// ЭлементРасшифровки - Тип ЭлементРасшифровкиКомпоновкиДанныхПоля - элемент для которого необходимо получить поля.
// СтруктураОтборов   - Тип Структура - Входной-выходной параметр содержит ключи (дополнительные параметры) необходимые
//                      для формирования отчета расшифровки.
//                      По наименованию поля ПолеЗначение.Поле.
&НаСервере
Процедура ПолучитьЗначениеПоляРасшифровки(ЭлементРасшифровки, СтруктураОтборов)
	
	Если ТипЗнч(ЭлементРасшифровки) = Тип("ЭлементРасшифровкиКомпоновкиДанныхПоля") Тогда
		Для каждого ЗначениеПоляРасшифровки Из ЭлементРасшифровки.ПолучитьПоля() Цикл
			Если Отчет.КомпоновщикНастроек.Настройки.ДоступныеПоляГруппировок.НайтиПоле(Новый ПолеКомпоновкиДанных(ЗначениеПоляРасшифровки.Поле)) <> Неопределено Тогда
				СтруктураОтборов.Вставить(ЗначениеПоляРасшифровки.Поле, ЗначениеПоляРасшифровки.Значение);
			КонецЕсли;
			Для Каждого ЗначениеПоляРасшифровки Из ЭлементРасшифровки.ПолучитьРодителей() Цикл
				ПолучитьЗначениеПоляРасшифровки(ЗначениеПоляРасшифровки, СтруктураОтборов);
			КонецЦикла;
		КонецЦикла;
	ИначеЕсли ТипЗнч(ЭлементРасшифровки) = Тип("ЭлементРасшифровкиКомпоновкиДанныхГруппировка") Тогда
		Для Каждого ЗначениеПоляРасшифровки Из ЭлементРасшифровки.ПолучитьРодителей() Цикл
			ПолучитьЗначениеПоляРасшифровки(ЗначениеПоляРасшифровки, СтруктураОтборов);
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ПолучитьПоляРасшифровки(Расшифровка)
	
	ДанныеРасшифровкиИзХранилища = ПолучитьИзВременногоХранилища(ДанныеРасшифровки);
	СтруктураОтборов = Новый Структура();
	// Создадим и инициализируем обработчик расшифровки.
	МассивПолейРасшифровки = Новый Массив();
	ЭлементРасшифровки = ДанныеРасшифровкиИзХранилища.Элементы.Получить(Расшифровка);
	ПолучитьЗначениеПоляРасшифровки(ЭлементРасшифровки, СтруктураОтборов);
	Возврат СтруктураОтборов;
	
КонецФункции

#КонецОбласти
