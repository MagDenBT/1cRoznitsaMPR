#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформление();
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ВерсионированиеОбъектов") Тогда
		МодульВерсионированиеОбъектов = ОбщегоНазначения.ОбщийМодуль("ВерсионированиеОбъектов");
		МодульВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтотОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов

	УстановитьБыстрыйОтборСервер();
	СобытияФормИСМП.ПриСозданииНаСервереФормыСпискаДокументов(ЭтотОбъект);

	ИнтеграцияИСМП.ЗаполнитьСписокВыбораДальнейшееДействие(
		Элементы.СтраницаОформленоОтборДальнейшееДействие.СписокВыбора, ВсеТребующиеДействия(), ВсеТребующиеОжидания());
	
	НастроитьВидимостьДоступностьЭлементовСервер();
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	СобытияФормИСПереопределяемый.ПриСозданииНаСервере(ЭтотОбъект, Отказ, СтандартнаяОбработка);
	
	ИнтеграцияИС.УстановитьПризнакПравоИзмененияФормыСписка(ЭтотОбъект);
	
	ОбработатьИПроверитьПереданныеПараметры(Отказ);
	
КонецПроцедуры

&НаСервере
Процедура ОбработатьИПроверитьПереданныеПараметры(Отказ);
	
	Элементы.Список.РежимВыбора = Параметры.РежимВыбора;
	
	Если Параметры.МножественныйВыбор <> Неопределено Тогда
		Элементы.Список.МножественныйВыбор = Параметры.МножественныйВыбор;
	КонецЕсли;
	
	КлючПользовательскихНастроек = Неопределено;
	
	Если Параметры.Свойство("КлючПользовательскихНастроек", КлючПользовательскихНастроек)
		И Не ЗначениеЗаполнено(КлючПользовательскихНастроек) Тогда
		
		Параметры.КлючПользовательскихНастроек = Строка(Новый УникальныйИдентификатор());
		Список.АвтоматическоеСохранениеПользовательскихНастроек = Ложь;
		
	КонецЕсли;
	
	Если Параметры.РежимВыбора Тогда
		Элементы.СтраницаКОформлению.Видимость               = Ложь;
		Элементы.Страницы.ОтображениеСтраниц                 = ОтображениеСтраницФормы.Нет;
		Элементы.СтраницыОформленоОтборОрганизация.Видимость = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	ИнтеграцияИСКлиент.ОбработкаОповещенияВФормеСпискаДокументовИС(
		ЭтотОбъект,
		ИнтеграцияИСМПКлиентСервер.ИмяПодсистемы(),
		ИмяСобытия,
		Параметр,
		Источник);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура СтраницаОформленоОтборСтатусПриИзменении(Элемент)
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		Список, "СтатусИСМП", Статус, ВидСравненияКомпоновкиДанных.Равно,, ЗначениеЗаполнено(Статус));
	
КонецПроцедуры

&НаКлиенте
Процедура СтраницаОформленоОтборДальнейшееДействиеПриИзменении(Элемент)
	
	УстановитьОтборПоДальнейшемуДействиюСервер();
	
КонецПроцедуры

&НаКлиенте
Процедура СтраницаОформленоОтборОтветственныйПриИзменении(Элемент)
	
	ОтветственныйОтборПриИзменении();
	
КонецПроцедуры

&НаКлиенте
Процедура СтраницаКОформлениюОтборОтветственныйПриИзменении(Элемент)
	
	ОтветственныйОтборПриИзменении();
	
КонецПроцедуры

&НаКлиенте
Процедура ОформленоОрганизацииНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ИнтеграцияИСМПКлиент.ОткрытьФормуВыбораОрганизаций(ЭтотОбъект, "Оформлено");
	
КонецПроцедуры

&НаКлиенте
Процедура ОформленоОрганизацияНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ИнтеграцияИСМПКлиент.ОткрытьФормуВыбораОрганизаций(ЭтотОбъект, "Оформлено");
	
КонецПроцедуры

&НаКлиенте
Процедура ОформленоОрганизацииПриИзменении(Элемент)
	
	ИнтеграцияИСМПКлиент.ОбработатьВыборОрганизаций(ЭтотОбъект, Организации, Истина, "Оформлено");
	
КонецПроцедуры

&НаКлиенте
Процедура ОформленоОрганизацияПриИзменении(Элемент)
	
	ИнтеграцияИСМПКлиент.ОбработатьВыборОрганизаций(ЭтотОбъект, Организация, Истина, "Оформлено");
	
КонецПроцедуры

&НаКлиенте
Процедура ОформленоОрганизацииОчистка(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ИнтеграцияИСМПКлиент.ОбработатьВыборОрганизаций(ЭтотОбъект, Неопределено, Истина, "Оформлено");
	
КонецПроцедуры

&НаКлиенте
Процедура ОформленоОрганизацияОчистка(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ИнтеграцияИСМПКлиент.ОбработатьВыборОрганизаций(ЭтотОбъект, Неопределено, Истина, "Оформлено");
	
КонецПроцедуры

&НаКлиенте
Процедура ОформленоОрганизацииОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	ИнтеграцияИСМПКлиент.ОбработатьВыборОрганизаций(ЭтотОбъект, ВыбранноеЗначение, Истина, "Оформлено");
	
КонецПроцедуры

&НаКлиенте
Процедура ОформленоОрганизацияОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	ИнтеграцияИСМПКлиент.ОбработатьВыборОрганизаций(ЭтотОбъект, ВыбранноеЗначение, Истина, "Оформлено");
	
КонецПроцедуры

&НаКлиенте
Процедура КОформлениюОрганизацииПриИзменении(Элемент)
	
	ИнтеграцияИСМПКлиент.ОбработатьВыборОрганизаций(ЭтотОбъект, Организации, Истина, "КОформлению");
	
КонецПроцедуры

&НаКлиенте
Процедура КОформлениюОрганизацииНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ИнтеграцияИСМПКлиент.ОткрытьФормуВыбораОрганизаций(ЭтотОбъект, "КОформлению");
	
КонецПроцедуры

&НаКлиенте
Процедура КОформлениюОрганизацииОчистка(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ИнтеграцияИСМПКлиент.ОбработатьВыборОрганизаций(ЭтотОбъект, Неопределено, Истина, "КОформлению");
	
КонецПроцедуры

&НаКлиенте
Процедура КОформлениюОрганизацииОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ИнтеграцияИСМПКлиент.ОбработатьВыборОрганизаций(ЭтотОбъект, ВыбранноеЗначение, Истина, "КОформлению");
	
КонецПроцедуры

&НаКлиенте
Процедура КОформлениюОрганизацияПриИзменении(Элемент)
	
	ИнтеграцияИСМПКлиент.ОбработатьВыборОрганизаций(ЭтотОбъект, Организация, Истина, "КОформлению");
	
КонецПроцедуры

&НаКлиенте
Процедура КОформлениюОрганизацияНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ИнтеграцияИСМПКлиент.ОткрытьФормуВыбораОрганизаций(ЭтотОбъект, "КОформлению");
	
КонецПроцедуры

&НаКлиенте
Процедура КОформлениюОрганизацияОчистка(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ИнтеграцияИСМПКлиент.ОбработатьВыборОрганизаций(ЭтотОбъект, Неопределено, Истина, "КОформлению");
	
КонецПроцедуры

&НаКлиенте
Процедура КОформлениюОрганизацияОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ИнтеграцияИСМПКлиент.ОбработатьВыборОрганизаций(ЭтотОбъект, ВыбранноеЗначение, Истина, "КОформлению");
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ВыполнитьОбмен(Команда)
	
	ИнтеграцияИСМПКлиент.ВыполнитьОбмен(
		ЭтотОбъект,
		ИнтеграцияИСМПКлиент.ОрганизацииДляОбмена(ЭтотОбъект));
	
КонецПроцедуры

&НаКлиенте
Процедура Архивировать(Команда)
	
	ИнтеграцияИСКлиент.АрхивироватьРаспоряжения(
		ЭтотОбъект, Элементы.СписокКОформлению, ИнтеграцияИСМПКлиент,
		ПредопределенноеЗначение("Документ.ЗаказНаЭмиссиюКодовМаркировкиСУЗ.ПустаяСсылка"));
	
КонецПроцедуры

&НаКлиенте
Процедура АрхивироватьДокументы(Команда)
	
	ИнтеграцияИСКлиент.АрхивироватьДокументы(ЭтотОбъект, Элементы.Список, ИнтеграцияИСМПКлиент);
	
КонецПроцедуры

&НаКлиенте
Процедура Оформить(Команда)
	
	ОчиститьСообщения();
	
	Если Не ИнтеграцияИСКлиент.ВыборСтрокиДинамическогоСпискаКорректен(Элементы.СписокКОформлению) Тогда
		Возврат;
	КонецЕсли;
	
	ДокументОснование = Элементы.СписокКОформлению.ТекущиеДанные.ДокументОснование;
	
	Если ТребуетсяПерейтиВПул(ДокументОснование) Тогда
		
		ПараметрыФормы = Новый Структура("Документ", ДокументОснование);
		Открытьформу("РегистрСведений.ПулКодовМаркировкиСУЗ.Форма.ФормаРезервирования", ПараметрыФормы, ЭтотОбъект);
		
	Иначе
		
		ИнтеграцияИСМПКлиент.ОткрытьФормуСозданияДокумента(
			ИнтеграцияИСКлиентСервер.ИмяОбъектаИзИмениФормы(ЭтотОбъект),
			ДокументОснование,
			ЭтотОбъект);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗапроситьКодыМаркировки(Команда)
	
	ДальнейшееДействие = ПредопределенноеЗначение(
		"Перечисление.ДальнейшиеДействияПоВзаимодействиюИСМП.ЗапроситеКодыМаркировки");
	ИнтеграцияИСМПКлиент.ПодготовитьСообщенияКПередаче(
		Элементы.Список, ДальнейшееДействие);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗапроситьGTINНаОстатки(Команда)
	
	ДальнейшееДействие = ПредопределенноеЗначение(
		"Перечисление.ДальнейшиеДействияПоВзаимодействиюИСМП.ЗапроситеGTINНаОстатки");
	ИнтеграцияИСМПКлиент.ПодготовитьСообщенияКПередаче(
		Элементы.Список, ДальнейшееДействие);
	
КонецПроцедуры

#Область ПодключаемыеКоманды

//@skip-warning
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Элементы.Список);
КонецПроцедуры

//@skip-warning
&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат) Экспорт
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Элементы.Список, Результат);
КонецПроцедуры

//@skip-warning
&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Элементы.Список);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

//@skip-warning
&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормИСКлиентПереопределяемый.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

#КонецОбласти

&НаКлиенте
Процедура ИзменитьВыделенные(Команда)
	
	ГрупповоеИзменениеОбъектовКлиент.ИзменитьВыделенные(Элементы.Список);

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыСписокКОформлению

&НаКлиенте
Процедура СписокКОформлениюВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ИнтеграцияИСКлиент.ОткрытьРаспоряжение(Элементы.СписокКОформлению, СтандартнаяОбработка);

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	УсловноеОформление.Элементы.Очистить();
	
	// Ошибки
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.СтатусИСМП.Имя);
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных(Элементы.СтатусИСМП.ПутьКДанным);
	ОтборЭлемента.ВидСравнения  = ВидСравненияКомпоновкиДанных.ВСписке;
	
	СписокСтатусов = Новый СписокЗначений;
	СписокСтатусов.ЗагрузитьЗначения(Документы.ЗаказНаЭмиссиюКодовМаркировкиСУЗ.СтатусыОшибок());
	ОтборЭлемента.ПравоеЗначение = СписокСтатусов;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.СтатусОбработкиОшибкаПередачиГосИС);
	
	// Требуется ожидание
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.СтатусИСМП.Имя);
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных(Элементы.ДальнейшееДействиеИСМП.ПутьКДанным);
	ОтборЭлемента.ВидСравнения  = ВидСравненияКомпоновкиДанных.ВСписке;
	
	СписокДействий = Новый СписокЗначений;
	СписокДействий.ЗагрузитьЗначения(Документы.ЗаказНаЭмиссиюКодовМаркировкиСУЗ.ВсеТребующиеОжидания());
	ОтборЭлемента.ПравоеЗначение = СписокДействий;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.СтатусОбработкиПередаетсяГосИС);
	
	// Даты
	СтандартныеПодсистемыСервер.УстановитьУсловноеОформлениеПоляДата(ЭтотОбъект, "Список.Дата", Элементы.Дата.Имя);
	
КонецПроцедуры

#Область ОтборДальнейшиеДействия

&НаСервереБезКонтекста
Функция ВсеТребующиеДействия()
	
	Возврат Документы.ЗаказНаЭмиссиюКодовМаркировкиСУЗ.ВсеТребующиеДействия();
	
КонецФункции

&НаСервереБезКонтекста
Функция ВсеТребующиеОжидания()
	
	Возврат Документы.ЗаказНаЭмиссиюКодовМаркировкиСУЗ.ВсеТребующиеОжидания();
	
КонецФункции

&НаСервере
Процедура УстановитьОтборПоДальнейшемуДействиюСервер()
	
	ИнтеграцияИСМП.УстановитьОтборПоДальнейшемуДействию(
		Список, ДальнейшееДействие, ВсеТребующиеДействия(), ВсеТребующиеОжидания());
	
КонецПроцедуры

&НаСервере
Процедура УстановитьБыстрыйОтборСервер()
	
	СтруктураБыстрогоОтбора = Неопределено;
	Параметры.Свойство("СтруктураБыстрогоОтбора", СтруктураБыстрогоОтбора);
	
	Если СтруктураБыстрогоОтбора <> Неопределено Тогда
		
		СтруктураБыстрогоОтбора.Свойство("Организация", Организация);
		СтруктураБыстрогоОтбора.Свойство("Организации", Организации);
		
		Если ЗначениеЗаполнено(Организации) Тогда
			ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список,            "Организация", Организации,,, Истина);
			ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(СписокКОформлению, "Организация", Организации,,, Истина);
			ОрганизацииПредставление = Строка(Организации);
		КонецЕсли;
		
		ИнтеграцияИС.ОтборПоЗначениюСпискаПриСозданииНаСервере(Список,            "Ответственный", Ответственный, СтруктураБыстрогоОтбора);
		ИнтеграцияИС.ОтборПоЗначениюСпискаПриСозданииНаСервере(СписокКОформлению, "Ответственный", Ответственный, СтруктураБыстрогоОтбора);
		
	КонецЕсли;
	
	ЗаполнитьСписокВыбораОрганизацииПоСохраненнымНастройкам();
	
	Если ИнтеграцияИСМП.НеобходимОтборПоДальнейшемуДействиюПриСозданииНаСервере(ДальнейшееДействие, СтруктураБыстрогоОтбора) Тогда
		УстановитьОтборПоДальнейшемуДействиюСервер();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура НастроитьВидимостьДоступностьЭлементовСервер()
	
	УчитываемыеВидыМаркируемойПродукции = ИнтеграцияИСМПКлиентСерверПовтИсп.УчитываемыеВидыМаркируемойПродукции();
	Элементы.ВидПродукции.Видимость = УчитываемыеВидыМаркируемойПродукции.Количество() > 1;
	
	Если Не ПравоДоступа("Добавление", Метаданные.Документы.ЗаказНаЭмиссиюКодовМаркировкиСУЗ) Тогда
		Элементы.СтраницаКОформлению.Видимость = Ложь;
	ИначеЕсли Параметры.ОткрытьРаспоряжения Тогда
		Элементы.Страницы.ТекущаяСтраница = Элементы.СтраницаКОформлению;
	КонецЕсли;
	
	ДоступностьКнопкиЗапросаGTIN = Ложь;
	Для Каждого ВидПродукции Из УчитываемыеВидыМаркируемойПродукции Цикл
		Если ИнтеграцияИСКлиентСервер.ВидПродукцииПодлежитМаркировкеОстатков(ВидПродукции) Тогда
			ДоступностьКнопкиЗапросаGTIN = Истина;
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
	Элементы.ЗапроситьGTINНаОстатки.Видимость = ДоступностьКнопкиЗапросаGTIN;
	
КонецПроцедуры

#КонецОбласти

#Область Прочее

//@skip-warning
&НаКлиенте
Процедура Подключаемый_ВыполнитьОбменОбработкаОжидания()

	ИнтеграцияИСМПСлужебныйКлиент.ПродолжитьВыполнениеОбмена(ЭтотОбъект);

КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСписокВыбораОрганизацииПоСохраненнымНастройкам()
	
	СобытияФормИСМП.ЗаполнитьСписокВыбораОрганизацииПоСохраненнымНастройкам(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтветственныйОтборПриИзменении()
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		Список, "Ответственный", Ответственный, ВидСравненияКомпоновкиДанных.Равно,, ЗначениеЗаполнено(Ответственный));
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		СписокКОформлению, "Ответственный", Ответственный, ВидСравненияКомпоновкиДанных.Равно, , ЗначениеЗаполнено(Ответственный));
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ТребуетсяПерейтиВПул(ДокументОснование)
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	Ссылка
	|ИЗ
	|	Документ.ЗаказНаЭмиссиюКодовМаркировкиСУЗ КАК Т
	|ГДЕ
	|	ДокументОснование = &ДокументОснование");
	
	Запрос.УстановитьПараметр("ДокументОснование", ДокументОснование);
	
	Возврат Не Запрос.Выполнить().Пустой()
		Или РегистрыСведений.ПулКодовМаркировкиСУЗ.ЕстьНераспределенныеКоды(ДокументОснование);
	
КонецФункции

#КонецОбласти

#КонецОбласти