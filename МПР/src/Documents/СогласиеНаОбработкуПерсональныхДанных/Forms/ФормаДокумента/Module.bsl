///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2022, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Ключ.Пустая() Тогда
		// Заполняем значениями по умолчанию.
		Объект.Ответственный = Пользователи.ТекущийПользователь();
		Если Не Параметры.Свойство("ДатаСогласия", Объект.ДатаПолучения) Тогда
			Объект.ДатаПолучения = ТекущаяДатаСеанса();
		КонецЕсли;
		Если Не Параметры.Свойство("Организация", Объект.Организация) Тогда
			Если Не Метаданные.ОпределяемыеТипы.Организация.Тип.СодержитТип(Тип("Строка")) Тогда
				ПолноеИмя = Метаданные.НайтиПоТипу(Метаданные.ОпределяемыеТипы.Организация.Тип.Типы()[0]).ПолноеИмя();
				ИмяСправочникаОрганизации = "Справочники." + СтрРазделить(ПолноеИмя, ".")[1];
				МодульОрганизации = ОбщегоНазначения.ОбщийМодуль(ИмяСправочникаОрганизации);
				Объект.Организация = МодульОрганизации.ОрганизацияПоУмолчанию();
			КонецЕсли;
		КонецЕсли;
		ЗаполнитьДанныеОрганизации();
		Если Параметры.Свойство("Субъект") Тогда
			Объект.Субъект = Параметры.Субъект;
			ЗаполнитьДанныеСубъекта();
		КонецЕсли;
		УстановитьСведенияДействующегоСогласия();
	КонецЕсли;
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	// СтандартныеПодсистемы.Свойства
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.Свойства") Тогда
		ДополнительныеПараметры = Новый Структура;
		ДополнительныеПараметры.Вставить("ИмяЭлементаДляРазмещения", "ГруппаДополнительныеРеквизиты");
		МодульУправлениеСвойствами = ОбщегоНазначения.ОбщийМодуль("УправлениеСвойствами");
		МодульУправлениеСвойствами.ПриСозданииНаСервере(ЭтотОбъект, ДополнительныеПараметры);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.Свойства
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	УстановитьСведенияДействующегоСогласия();
	
	// СтандартныеПодсистемы.ДатыЗапретаИзменения
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ДатыЗапретаИзменения") Тогда
		МодульДатыЗапретаИзменения = ОбщегоНазначения.ОбщийМодуль("ДатыЗапретаИзменения");
		МодульДатыЗапретаИзменения.ОбъектПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.ДатыЗапретаИзменения
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	// СтандартныеПодсистемы.УправлениеДоступом
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УправлениеДоступом") Тогда
		МодульУправлениеДоступом = ОбщегоНазначения.ОбщийМодуль("УправлениеДоступом");
		МодульУправлениеДоступом.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
	// СтандартныеПодсистемы.Свойства
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.Свойства") Тогда
		МодульУправлениеСвойствами = ОбщегоНазначения.ОбщийМодуль("УправлениеСвойствами");
		МодульУправлениеСвойствами.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.Свойства
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	// СтандартныеПодсистемы.Свойства
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.Свойства") Тогда
		МодульУправлениеСвойствамиКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("УправлениеСвойствамиКлиент");
		МодульУправлениеСвойствамиКлиент.ПослеЗагрузкиДополнительныхРеквизитов(ЭтотОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.Свойства
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	// СтандартныеПодсистемы.Свойства
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.Свойства") Тогда
		МодульУправлениеСвойствамиКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("УправлениеСвойствамиКлиент");
		Если МодульУправлениеСвойствамиКлиент.ОбрабатыватьОповещения(ЭтотОбъект, ИмяСобытия, Параметр) Тогда
			ОбновитьЭлементыДополнительныхРеквизитов();
			МодульУправлениеСвойствамиКлиент.ПослеЗагрузкиДополнительныхРеквизитов(ЭтотОбъект);
		КонецЕсли;
	КонецЕсли;
	// Конец СтандартныеПодсистемы.Свойства
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	// СтандартныеПодсистемы.Свойства
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.Свойства") Тогда
		МодульУправлениеСвойствами = ОбщегоНазначения.ОбщийМодуль("УправлениеСвойствами");
		МодульУправлениеСвойствами.ОбработкаПроверкиЗаполнения(ЭтотОбъект, Отказ, ПроверяемыеРеквизиты);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.Свойства
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	// СтандартныеПодсистемы.Свойства
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.Свойства") Тогда
		МодульУправлениеСвойствами = ОбщегоНазначения.ОбщийМодуль("УправлениеСвойствами");
		МодульУправлениеСвойствами.ПередЗаписьюНаСервере(ЭтотОбъект, ТекущийОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.Свойства
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	ПодключаемыеКомандыКлиент.ПослеЗаписи(ЭтотОбъект, Объект, ПараметрыЗаписи);
	Оповестить("ИзмененаДатаСкрытияПерсональныхДанных");
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)

	// СтандартныеПодсистемы.УправлениеДоступом
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УправлениеДоступом") Тогда
		МодульУправлениеДоступом = ОбщегоНазначения.ОбщийМодуль("УправлениеДоступом");
		МодульУправлениеДоступом.ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.УправлениеДоступом

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	
	ОрганизацияПриИзмененииНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ОтветственныйЗаОбработкуПерсональныхДанныхПриИзменении(Элемент)
	
	ОтветственныйЗаПДнПриИзмененииНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура СубъектПриИзменении(Элемент)
	
	СубъектПриИзмененииНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ДатаПолученияПриИзменении(Элемент)
	
	ДатаПолученияПриИзмененииНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура КомментарийНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ОбщегоНазначенияКлиент.ПоказатьФормуРедактированияКомментария(Элемент.ТекстРедактирования, ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.НачатьВыполнениеКоманды(ЭтотОбъект, Команда, Объект);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПродолжитьВыполнениеКомандыНаСервере(ПараметрыВыполнения, ДополнительныеПараметры) Экспорт
	ВыполнитьКомандуНаСервере(ПараметрыВыполнения);
КонецПроцедуры

&НаСервере
Процедура ВыполнитьКомандуНаСервере(ПараметрыВыполнения)
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, ПараметрыВыполнения, Объект);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

// СтандартныеПодсистемы.Свойства
&НаКлиенте
Процедура Подключаемый_СвойстваВыполнитьКоманду(ЭлементИлиКоманда, НавигационнаяСсылка = Неопределено, СтандартнаяОбработка = Неопределено)
	
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.Свойства") Тогда
		МодульУправлениеСвойствамиКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("УправлениеСвойствамиКлиент");
		МодульУправлениеСвойствамиКлиент.ВыполнитьКоманду(ЭтотОбъект, ЭлементИлиКоманда, СтандартнаяОбработка);
	КонецЕсли;
	
КонецПроцедуры
// Конец СтандартныеПодсистемы.Свойства

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ОрганизацияПриИзмененииНаСервере()
	
	ЗаполнитьДанныеОрганизации();
	УстановитьСведенияДействующегоСогласия();
	
КонецПроцедуры

&НаСервере
Процедура ОтветственныйЗаПДнПриИзмененииНаСервере()
	
	Объект.ФИООтветственногоЗаОбработкуПДн = Неопределено;
	
	Если Не ЗначениеЗаполнено(Объект.ОтветственныйЗаОбработкуПерсональныхДанных) Тогда
		Возврат;
	КонецЕсли;
	
	ОтветственныйФизическоеЛицо = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Объект.ОтветственныйЗаОбработкуПерсональныхДанных, "ФизическоеЛицо");
	ЗащитаПерсональныхДанныхПереопределяемый.ЗаполнитьФИОФизическогоЛица(ОтветственныйФизическоеЛицо, Объект.ФИООтветственногоЗаОбработкуПДн);
	
КонецПроцедуры

&НаСервере
Процедура СубъектПриИзмененииНаСервере()
	
	ЗаполнитьДанныеСубъекта();
	УстановитьСведенияДействующегоСогласия();
	
КонецПроцедуры

&НаСервере
Процедура ДатаПолученияПриИзмененииНаСервере()
	
	УстановитьСведенияДействующегоСогласия();
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьДанныеОрганизации()
	
	ДанныеОрганизации = ЗащитаПерсональныхДанных.ОписаниеДанныхОрганизации();
	
	ЗащитаПерсональныхДанныхПереопределяемый.ДополнитьДанныеОрганизацииОператораПерсональныхДанных(Объект.Организация, ДанныеОрганизации, Объект.ДатаПолучения);
	
	Объект.НаименованиеОрганизации = ДанныеОрганизации.НаименованиеОрганизации;
	Объект.ЮридическийАдресОрганизации = ДанныеОрганизации.АдресОрганизации;
	Объект.ОтветственныйЗаОбработкуПерсональныхДанных = ДанныеОрганизации.ОтветственныйЗаОбработкуПерсональныхДанных;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьДанныеСубъекта()
	
	Если Не ЗначениеЗаполнено(Объект.Субъект) Тогда
		Возврат;
	КонецЕсли;
	
	Если ОбщегоНазначения.ОбъектЯвляетсяГруппой(Объект.Субъект) Тогда
		ВызватьИсключение НСтр("ru = 'Для ввода согласия на обработку персональных данных выберите элемент, а не группу.'");
	КонецЕсли;
	
	Документы.СогласиеНаОбработкуПерсональныхДанных.ПроверитьВозможностьОформленияСогласия(Объект.Субъект);
	
	ДанныеСубъекта = ЗащитаПерсональныхДанных.ОписаниеДанныхСубъекта();
	ДанныеСубъекта.Субъект = Объект.Субъект;
	
	ДанныеСубъектов = Новый Массив;
	ДанныеСубъектов.Добавить(ДанныеСубъекта);
	
	ЗащитаПерсональныхДанныхПереопределяемый.ДополнитьДанныеСубъектовПерсональныхДанных(ДанныеСубъектов, Объект.ДатаПолучения);
	
	Объект.ФИОСубъекта = ДанныеСубъекта.ФИО;
	Объект.АдресСубъекта = ДанныеСубъекта.Адрес;
	Объект.ПаспортныеДанные = ДанныеСубъекта.ПаспортныеДанные;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьСведенияДействующегоСогласия()
	
	// Запрашиваем сведения о действующем согласии.
	Согласие = ЗащитаПерсональныхДанных.ДействующееСогласиеНаОбработкуПерсональныхДанных(Объект.Субъект, Объект.Организация, Объект.ДатаПолучения, Объект.Ссылка);
	
	Если Согласие = Неопределено Тогда
		// Не обнаружено действующего согласия - не отображаем сведения.
		Элементы.СведенияОСогласииГруппа.Видимость = Ложь;
		Возврат;
	КонецЕсли;
	
	// Обнаружено действующее согласие.
	Элементы.СведенияОСогласииГруппа.Видимость = Истина;
	
	// Пример сообщения: "У субъекта 20.03.2014 уже было получено согласие, которое действует до 20.03.2017".
	Если ЗначениеЗаполнено(Согласие.СрокДействия) Тогда
		ПредупреждениеТекст = СтроковыеФункции.ФорматированнаяСтрока(
			НСтр("ru = 'У субъекта %1 уже было получено <a href=""%2"">согласие</a>, которое действует до %3.'"),
			Формат(Согласие.ДатаПолучения, "ДЛФ=D"), ПолучитьНавигационнуюСсылку(Согласие.ДокументОснование), Формат(Согласие.СрокДействия, "ДЛФ=D"));
	Иначе	
		ПредупреждениеТекст = СтроковыеФункции.ФорматированнаяСтрока(
			НСтр("ru = 'У субъекта %1 уже было получено <a href=""%2"">согласие</a>, которое действует бессрочно.'"),
			Формат(Согласие.ДатаПолучения, "ДЛФ=D"), ПолучитьНавигационнуюСсылку(Согласие.ДокументОснование));
	КонецЕсли;
	Элементы.ПредупреждениеТекст.Заголовок = ПредупреждениеТекст;
	
КонецПроцедуры

// СтандартныеПодсистемы.Свойства

&НаСервере
Процедура ОбновитьЭлементыДополнительныхРеквизитов()
	
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.Свойства") Тогда
		МодульУправлениеСвойствами = ОбщегоНазначения.ОбщийМодуль("УправлениеСвойствами");
		МодульУправлениеСвойствами.ОбновитьЭлементыДополнительныхРеквизитов(ЭтотОбъект);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьЗависимостиДополнительныхРеквизитов()
	
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.Свойства") Тогда
		МодульУправлениеСвойствамиКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("УправлениеСвойствамиКлиент");
		МодульУправлениеСвойствамиКлиент.ОбновитьЗависимостиДополнительныхРеквизитов(ЭтотОбъект);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПриИзмененииДополнительногоРеквизита(Элемент)
	
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.Свойства") Тогда
		МодульУправлениеСвойствамиКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("УправлениеСвойствамиКлиент");
		МодульУправлениеСвойствамиКлиент.ОбновитьЗависимостиДополнительныхРеквизитов(ЭтотОбъект);
	КонецЕсли;
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.Свойства

#КонецОбласти
