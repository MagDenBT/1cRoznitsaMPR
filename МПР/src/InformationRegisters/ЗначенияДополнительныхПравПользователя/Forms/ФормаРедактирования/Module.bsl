
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Параметры.Свойство("Пользователь", Пользователь);
	
	Если НЕ ЗначениеЗаполнено(Пользователь) Тогда
		ОпределитьТекущегоПользователяГруппуПользователя();
	КонецЕсли;
	
	Если НЕ Пользователи.РолиДоступны("ПолныеПрава") Тогда
		ТолькоПросмотр = Истина;
	КонецЕсли;
	
	ЗаполнитьДерево();
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Если Модифицированность И НЕ ВопросОЗакрытииУжеЗадан Тогда
		
		Если ЗавершениеРаботы Тогда
			Отказ = Истина;
			Возврат;
		КонецЕсли;
		
		ВопросОЗакрытииУжеЗадан = Ложь;
		ТекстВопроса = НСтр("ru = 'Данные были изменены. Сохранить изменения?'");
		
		ОбработчикОповещения = Новый ОписаниеОповещения("ОповещениеВопросПередЗакрытием", ЭтотОбъект);
		ПоказатьВопрос(ОбработчикОповещения, ТекстВопроса, РежимДиалогаВопрос.ДаНетОтмена,, КодВозвратаДиалога.Да);
		
		СтандартнаяОбработка = Ложь;
		Отказ = Истина;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти


#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ПользовательПриИзменении(Элемент)
	
	ЗаполнитьДерево();
	
	РазвернутьДерево(ДеревоПрав.ПолучитьЭлементы());
	
КонецПроцедуры

&НаКлиенте
Процедура ПользовательНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	Если Модифицированность Тогда
		ТекстВопроса = НСтр("ru = 'Данные были изменены. Сохранить изменения?'");
		
		ОбработчикОповещения = Новый ОписаниеОповещения("ОповещениеВопросПриНачалеВыбораПользователя", ЭтотОбъект);
		ПоказатьВопрос(ОбработчикОповещения, ТекстВопроса, РежимДиалогаВопрос.ДаНет);
		СтандартнаяОбработка = Ложь;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура СнятьВсеФлажки(Команда)
	
	ПроставитьФлажки(ДеревоПрав.ПолучитьЭлементы(), Ложь);
	
КонецПроцедуры

&НаКлиенте
Процедура ПоставитьВсеФлажки(Команда)
	
	ПроставитьФлажки(ДеревоПрав.ПолучитьЭлементы(), Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаписатьНабор(Команда)
	
	ЗаписатьНаборСервер();
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаписатьИЗакрыть(Команда)
	
	ЗаписатьНаборСервер();
	Если Открыта() Тогда
		Закрыть();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ОповещениеВопросПриНачалеВыбораПользователя(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	Если РезультатВопроса = КодВозвратаДиалога.Да Тогда
		ЗаписатьНаборСервер();
		ЗаполнитьДерево();
		РазвернутьДерево(ДеревоПрав.ПолучитьЭлементы());
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОповещениеВопросПередЗакрытием(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	ВопросОЗакрытииУжеЗадан = Истина;
	
	Если РезультатВопроса = КодВозвратаДиалога.Нет Тогда
		Закрыть();
	ИначеЕсли РезультатВопроса = КодВозвратаДиалога.Да Тогда
		ЗаписатьНаборСервер(Ложь);
		Закрыть();
	КонецЕсли;
	
	ВопросОЗакрытииУжеЗадан = Ложь;
	
КонецПроцедуры

&НаСервере
Процедура ОпределитьТекущегоПользователяГруппуПользователя()
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ТекущийПользователь", Пользователи.ТекущийПользователь());
	Запрос.Текст =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ ПЕРВЫЕ 1
	|	Вложенный.Пользователь,
	|	Вложенный.Приоритет КАК Приоритет
	|ИЗ
	|	(ВЫБРАТЬ РАЗЛИЧНЫЕ
	|		ЗначенияДополнительныхПравПользователя.Пользователь КАК Пользователь,
	|		0 КАК Приоритет
	|	ИЗ
	|		РегистрСведений.ЗначенияДополнительныхПравПользователя КАК ЗначенияДополнительныхПравПользователя
	|	ГДЕ
	|		ЗначенияДополнительныхПравПользователя.Пользователь = &ТекущийПользователь
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ РАЗЛИЧНЫЕ
	|		ЗначенияДополнительныхПравПользователя.Пользователь,
	|		1
	|	ИЗ
	|		РегистрСведений.ЗначенияДополнительныхПравПользователя КАК ЗначенияДополнительныхПравПользователя
	|			ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.ГруппыПользователей.Состав КАК ПользователиГруппы
	|			ПО (ПользователиГруппы.Ссылка = ЗначенияДополнительныхПравПользователя.Пользователь)
	|				И (ПользователиГруппы.Пользователь = &ТекущийПользователь)) КАК Вложенный
	|
	|УПОРЯДОЧИТЬ ПО
	|	Приоритет";
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Если Выборка.Следующий() Тогда
		Пользователь = Выборка.Пользователь;
	Иначе
		Пользователь = Пользователи.ТекущийПользователь();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьДерево()
	
	ЭлементыДерева = ДеревоПрав.ПолучитьЭлементы();
	ЭлементыДерева.Очистить();
	
	
	Если НЕ ЗначениеЗаполнено(Пользователь) Тогда
		Модифицированность = Ложь;
		Возврат;
	КонецЕсли;
	
	МассивИсключаемыхПрав = Новый Массив;
	
	Если ОбменДаннымиРТ.ЭтоПодчиненныйУзелПоРабочемуМесту() Тогда
	
		МассивИсключаемыхПрав.Добавить(ПланыВидовХарактеристик.ПраваПользователей.КонтролироватьОстатокПриПроведении)
	
	КонецЕсли;
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	Права.Родитель,
	|	Права.Ссылка,
	|	Права.ЭтоГруппа,
	|	ЗначениеПрав.Значение
	|ИЗ
	|	ПланВидовХарактеристик.ПраваПользователей КАК Права
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ЗначенияДополнительныхПравПользователя КАК ЗначениеПрав
	|		ПО (ЗначениеПрав.Право = Права.Ссылка)
	|			И (ЗначениеПрав.Пользователь = &Пользователь)
	|ГДЕ
	|	(НЕ Права.Ссылка В (&МассивИсключаемыхПрав))
	|
	|УПОРЯДОЧИТЬ ПО
	|	Права.ЭтоГруппа ИЕРАРХИЯ,
	|	Права.Наименование");
	Запрос.УстановитьПараметр("Пользователь", Пользователь);
	Запрос.УстановитьПараметр("МассивИсключаемыхПрав", МассивИсключаемыхПрав);
	Запрос.Выполнить();
	ВыборкаТаблица = Запрос.Выполнить().Выгрузить();
	
	ТаблицаРодителей = Новый ТаблицаЗначений;
	ТаблицаРодителей.Колонки.Добавить("Идентификатор");
	ТаблицаРодителей.Колонки.Добавить("Родитель");
	
	Для каждого Выборка Из ВыборкаТаблица Цикл
		
		Если НЕ Выборка.Родитель.Пустая() Тогда
			СтрокаТаблицы = ТаблицаРодителей.Найти(Выборка.Родитель, "Родитель");
			Если СтрокаТаблицы = Неопределено Тогда
				
				СтрокаГруппы = ЭлементыДерева.Добавить();
				СтрокаГруппы.Право     = Выборка.Родитель;
				СтрокаГруппы.ЭтоГруппа = Выборка.ЭтоГруппа;
				
				СтрокаТаблицы = ТаблицаРодителей.Добавить();
				СтрокаТаблицы.Родитель      = Выборка.Родитель;
				СтрокаТаблицы.Идентификатор = СтрокаГруппы.ПолучитьИдентификатор();
				
				ЭлементыТекущегоУровня = СтрокаГруппы.ПолучитьЭлементы();
			Иначе
				ЭлементыТекущегоУровня = ДеревоПрав.НайтиПоИдентификатору(СтрокаТаблицы.Идентификатор).ПолучитьЭлементы();
			КонецЕсли;
		Иначе
			ЭлементыТекущегоУровня = ЭлементыДерева;
		КонецЕсли;
		
		СтрокаПрава = ЭлементыТекущегоУровня.Добавить();
		СтрокаПрава.Право     = Выборка.Ссылка;
		СтрокаПрава.Значение  = Выборка.Ссылка.ТипЗначения.ПривестиЗначение(Выборка.Значение);
		СтрокаПрава.ЭтоГруппа = Выборка.ЭтоГруппа;
		
		Если Выборка.ЭтоГруппа Тогда
			СтрокаТаблицы = ТаблицаРодителей.Найти(Выборка.Ссылка, "Родитель");
			
			Если СтрокаТаблицы = Неопределено Тогда
				СтрокаТаблицы = ТаблицаРодителей.Добавить();
				СтрокаТаблицы.Родитель      = Выборка.Ссылка;
				СтрокаТаблицы.Идентификатор = СтрокаПрава.ПолучитьИдентификатор();
			Иначе
				СтрокаТаблицы.Идентификатор = СтрокаПрава.ПолучитьИдентификатор();
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
	Модифицированность = Ложь;
	
КонецПроцедуры

&НаКлиенте
Процедура ПроставитьФлажки(ЭлементыДерева, ЗначениеФлажки)

	Для каждого ЭлементДерева Из ЭлементыДерева Цикл
		Если ЭлементДерева.ЭтоГруппа Тогда
			ПроставитьФлажки(ЭлементДерева.ПолучитьЭлементы(), ЗначениеФлажки)
		Иначе
			ЭлементДерева.Значение = ЗначениеФлажки;
		КонецЕсли;
	КонецЦикла;

КонецПроцедуры

&НаСервере
Процедура ЗаполнитьНаборЗаписей(ЭлементыДерева, НаборЗаписей)
	
	Для каждого ЭлементДерева Из ЭлементыДерева Цикл
		Если НЕ ЭлементДерева.ЭтоГруппа Тогда
			Запись = НаборЗаписей.Добавить();
			
			Запись.Пользователь = Пользователь;
			Запись.Право        = ЭлементДерева.Право;
			Запись.Значение     = Запись.Право.ТипЗначения.ПривестиЗначение(ЭлементДерева.Значение);
		Иначе
			ЗаполнитьНаборЗаписей(ЭлементДерева.ПолучитьЭлементы(), НаборЗаписей);
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ЗаписатьНаборСервер(СброситьМодифицированность = Истина)
	
	Если НЕ ЗначениеЗаполнено(Пользователь) Тогда
		Возврат;
	КонецЕсли;
	
	Набор = РегистрыСведений.ЗначенияДополнительныхПравПользователя.СоздатьНаборЗаписей();
	Набор.Отбор.Пользователь.Использование = Истина;
	Набор.Отбор.Пользователь.Значение = Пользователь;
	ЗаполнитьНаборЗаписей(ДеревоПрав.ПолучитьЭлементы(), Набор);
	Набор.Записать();
	
	Если СброситьМодифицированность Тогда
		Модифицированность = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура РазвернутьДерево(ЭлементыДерева)
	
	Для каждого ЭлементДерева Из ЭлементыДерева Цикл
		Если ЭлементДерева.ЭтоГруппа Тогда
			
			Элементы.ДеревоПрав.Развернуть(ЭлементДерева.ПолучитьИдентификатор(), Истина);
			
		КонецЕсли;
	КонецЦикла;
	
	
КонецПроцедуры

#КонецОбласти