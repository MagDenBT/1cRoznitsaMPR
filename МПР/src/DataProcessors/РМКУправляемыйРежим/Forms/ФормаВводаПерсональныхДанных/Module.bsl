
#Область ПрограммныйИнтерфейс

&НаКлиенте
Процедура ОповещениеУстановкаКомпонентыСклонения(ДополнительныеПараметры) Экспорт
	ФИОФизЛица = ОбщегоНазначенияРТКлиентСерверПовтИсп.ПолучитьСклонениеФИО(ФИОФизЛицаИП, 3);
КонецПроцедуры

&НаКлиенте
Процедура ОповещениеОткрытьФормуВыбораФизЛица(ФизическоеЛицо, ДополнительныеПараметры) Экспорт
	
	Если НЕ ФизическоеЛицо = Неопределено Тогда
		
		ЗаполнениеФизЛицаСервер(ФизическоеЛицо);
		
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
	
	Если Параметры.Свойство("ФизЛицо") Тогда
		Объект.ФизЛицо = Параметры.ФизЛицо
	КонецЕсли;
	
	Если Параметры.Свойство("ДатаРождения") Тогда
		Объект.ДатаРождения = Параметры.ДатаРождения
	КонецЕсли;
	
	Если Параметры.Свойство("ПоДокументу") Тогда
		Объект.ПоДокументу = Параметры.ПоДокументу
	КонецЕсли;
	
	ЭтоLinuxСервер = ОбщегоНазначенияРТВызовСервера.ЭтоLinuxСервер();
	
	Если ЗначениеЗаполнено(Объект.ФизЛицо) Тогда
		ЗаполнениеФИО();
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ФизЛицоПриИзменении(Элемент)
	ЗаполнениеФизЛицаСервер();
	
	Если ЭтоLinuxСервер Тогда
		ОбработчикОповещения = Новый ОписаниеОповещения("ОповещениеУстановкаКомпонентыСклонения", ЭтотОбъект);
		Если ОбщегоНазначенияРТКлиент.КомпонентаСклоненияУстановлена(ОбработчикОповещения) Тогда
			ФИОФизЛица = ОбщегоНазначенияРТКлиентСерверПовтИсп.ПолучитьСклонениеФИО(ФИОФизЛицаИП, 3);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ФизЛицоНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ОбработчикОповещения = Новый ОписаниеОповещения("ОповещениеОткрытьФормуВыбораФизЛица", ЭтотОбъект);
	
	Режим = РежимОткрытияОкнаФормы.БлокироватьВесьИнтерфейс;
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("НеПроверятьСотрудника", Ложь);
	
	ОткрытьФорму("Справочник.ФизическиеЛица.Форма.ФормаВыбораВРМК",
				 ПараметрыФормы, 
				 УникальныйИдентификатор,,,, ОбработчикОповещения, Режим);
	
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Печать(Команда)
	Результат = Новый Структура;
	Результат.Вставить("ФизЛицо", Объект.ФизЛицо);
	Результат.Вставить("ФИОФизЛица", ФИОФизЛица);
	Результат.Вставить("ДатаРождения", Объект.ДатаРождения);
	Результат.Вставить("ПоДокументу", Объект.ПоДокументу);
	//{ds-28.03.2021
	Результат.Вставить("Телефон", ds_Телефон);
	Результат.Вставить("ПричинаВозврата", Элементы.ds_ПричинаВозврата.ВыделенныйТекст);
	//}
	
	Закрыть(Результат);
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ЗаполнениеФизЛицаСервер(ФизическоеЛицо = Неопределено)
	
	Если ЗначениеЗаполнено(ФизическоеЛицо) Тогда
		
		УдостоверениеЛичности = РегистрыСведений.ДокументыФизическихЛиц.ДокументУдостоверяющийЛичностьФизлица(ФизическоеЛицо);
		Объект.ПоДокументу  = УдостоверениеЛичности;
		Объект.ДатаРождения = ФизическоеЛицо.ДатаРождения;
		Объект.ФизЛицо = ФизическоеЛицо.Наименование;
		
	КонецЕсли;
	
	ЗаполнениеФИО();
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнениеФИО(ФизическоеЛицо = Неопределено)
	
	Если ЗначениеЗаполнено(ФизическоеЛицо) Тогда
		ФизЛицоФИО = РегистрыСведений.ФИОФизЛиц.ПолучитьПоследнее(, Новый Структура("ФизЛицо", ФизическоеЛицо)); 
		ФИОФизЛицаИП = ФизЛицоФИО.Фамилия + " " + ФизЛицоФИО.Имя + " " + ФизЛицоФИО.Отчество;

		Если СокрЛП(ФИОФизЛицаИП) = "" Тогда
			ФИОФизЛицаИП = ФизическоеЛицо.Наименование;
		КонецЕсли;
		
	ИначеЕсли ТипЗнч(Объект.ФизЛицо) = Тип("Строка") Тогда
		ФИОФизЛицаИП = Объект.ФизЛицо;
	Иначе
		ФИОФизЛицаИП = ""
	КонецЕсли;
	Если Не ЭтоLinuxСервер Тогда
		ФИОФизЛица = ОбщегоНазначенияРТКлиентСерверПовтИсп.ПолучитьСклонениеФИО(ФИОФизЛицаИП, 3);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти


