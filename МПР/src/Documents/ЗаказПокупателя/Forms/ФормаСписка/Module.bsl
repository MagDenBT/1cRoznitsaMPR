
#Область ОбработчикиСобытийФормы

// Процедура - обработчик события "ПриСозданииНаСервере" формы.
//
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПараметрыРазмещения = ПодключаемыеКоманды.ПараметрыРазмещения();
	ПараметрыРазмещения.КоманднаяПанель = Элементы.КоманднаяПанельФормы;
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект, ПараметрыРазмещения);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	ИспользоватьРезервированиеПоЗаказамПокупателей = ПолучитьФункциональнуюОпцию("ИспользоватьРезервированиеПоЗаказамПокупателей");
	
	УстановитьОтборДинамическихСписков();
	
	ОбщегоНазначенияРТ.УстановитьУсловноеОформлениеПоляДата(ЭтотОбъект, "Список", "Дата");
	
КонецПроцедуры

&НаСервере
Процедура ПриЗагрузкеДанныхИзНастроекНаСервере(Настройки)
	
	Магазин       = Настройки.Получить("Магазин");
	Ответственный = Настройки.Получить("Ответственный");
	СостояниеЗаказаПокупателя = Настройки.Получить("СостояниеЗаказаПокупателя");
	
	УстановитьОтборДинамическихСписков();
	
КонецПроцедуры

&НаКлиенте
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
          
    // &ЗамерПроизводительности
	ОценкаПроизводительностиРТКлиент.НачатьЗамер(
		     Истина, "Документ.ЗаказПокупателя.Форма.ФормаДокумента.Открытие");

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

// Процедура - обработчик события "ПриИзменении" поля "Магазин".
&НаКлиенте
Процедура ОтборМагазинПриИзменении(Элемент)
	
	МагазинОтборПриИзмененииНаСервере();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
        
    // &ЗамерПроизводительности
    ОценкаПроизводительностиРТКлиент.НачатьЗамер(
             Истина, "Документ.ЗаказПокупателя.Форма.ФормаДокумента.СозданиеНового");

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗаказыНаДоставку(Команда)
	
	ОчиститьСообщения();
	СервисДоставкиКлиент.ОткрытьФормуСпискаЗаказовНаДоставку();
КонецПроцедуры

&НаКлиенте
Процедура ТрекерЗаказов(Команда)
	
	ОчиститьСообщения();
	СервисДоставкиКлиент.ОткрытьФормуОтслеживанияЗаказа();
КонецПроцедуры

&НаКлиенте
Процедура ИзменитьВыделенные(Команда)
	
	ГрупповоеИзменениеОбъектовКлиент.ИзменитьВыделенные(Элементы.Список);
	
КонецПроцедуры

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Элементы.Список);
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат) Экспорт
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Элементы.Список, Результат);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Элементы.Список);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура МагазинОтборПриИзмененииНаСервере()
	
	УстановитьОтборДинамическихСписков();
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборОтветственныйПриИзменении(Элемент)
	
	УстановитьОтборДинамическихСписков();
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборСостояниеОплатыПриИзменении(Элемент)
	
	УстановитьОтборДинамическихСписков();
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборСостояниеДоставкиПриИзменении(Элемент)
	
	УстановитьОтборДинамическихСписков();
	
КонецПроцедуры

///////////////////////////////////////////////////////////////////////////////
// Прочее

// Функция возвращает массив динамических списков, для которых требуется установка отбора.
//
&НаСервере
Функция ПолучитьМассивДинамическихСписковНаСервере()

	МассивСписков = Новый Массив;
	МассивСписков.Добавить(Список);
	
	Возврат МассивСписков;

КонецФункции

// Процедура устанавливает отбор динамических списков формы.
//
&НаСервере
Процедура УстановитьОтборДинамическихСписков()
	
	Для Каждого ДинамическийСписок Из ПолучитьМассивДинамическихСписковНаСервере() Цикл
		
		ОтборыСписковКлиентСервер.ИзменитьЭлементОтбораСписка(ДинамическийСписок, "Магазин"          , Магазин          , ЗначениеЗаполнено(Магазин)          , ВидСравненияКомпоновкиДанных.Равно);
		ОтборыСписковКлиентСервер.ИзменитьЭлементОтбораСписка(ДинамическийСписок, "Ответственный"    , Ответственный    , ЗначениеЗаполнено(Ответственный)    , ВидСравненияКомпоновкиДанных.Равно);
		ОтборыСписковКлиентСервер.ИзменитьЭлементОтбораСписка(ДинамическийСписок, "СостояниеОплаты"  , СостояниеОплаты  , ЗначениеЗаполнено(СостояниеОплаты)  , ВидСравненияКомпоновкиДанных.Равно);
		ОтборыСписковКлиентСервер.ИзменитьЭлементОтбораСписка(ДинамическийСписок, "СостояниеДоставки", СостояниеДоставки, ЗначениеЗаполнено(СостояниеДоставки), ВидСравненияКомпоновкиДанных.Равно);
		
	КонецЦикла;
	
КонецПроцедуры


#КонецОбласти