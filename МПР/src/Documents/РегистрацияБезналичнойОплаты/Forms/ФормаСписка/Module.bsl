
#Область ОбработчикиСобытийФормы

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
	
	ОбщегоНазначенияРТ.УстановитьУсловноеОформлениеПоляДата(ЭтотОбъект, "Список", "Дата");
	
	ПравоДобавление = ПравоДоступа("Добавление", Метаданные.Документы.РегистрацияБезналичнойОплаты);
	Элементы.ГруппаСоздать.Видимость =    ПравоДобавление;
	Элементы.ЗагрузитьВыписку.Видимость = ПравоДобавление;
	
КонецПроцедуры

&НаСервере
Процедура ПриЗагрузкеДанныхИзНастроекНаСервере(Настройки)
	
	ХозяйственнаяОперация = Настройки.Получить("ХозяйственнаяОперация");
	Контрагент = 			Настройки.Получить("Контрагент");
	Магазин = 				Настройки.Получить("Магазин");
	
	УстановитьОтборДинамическогоСписка("ХозяйственнаяОперация");
	УстановитьОтборДинамическогоСписка("Контрагент");
	УстановитьОтборДинамическогоСписка("Магазин");
	
КонецПроцедуры

&НаКлиенте
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
    
    // &ЗамерПроизводительности
    ОценкаПроизводительностиРТКлиент.НачатьЗамер(
                 Истина, "Документ.РегистрацияБезналичнойОплаты.Форма.ФормаДокумента.Открытие");
        
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
    
    // &ЗамерПроизводительности
    ОценкаПроизводительностиРТКлиент.НачатьЗамер(
             Истина, "Документ.РегистрацияБезналичнойОплаты.Форма.ФормаСписка.Открытие");

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ОтборКонтрагентПриИзменении(Элемент)
	
	УстановитьОтборДинамическогоСписка("Контрагент");
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборМагазинПриИзменении(Элемент)
	
	УстановитьОтборДинамическогоСписка("Магазин");
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборОперацияПриИзменении(Элемент)
	
	УстановитьОтборДинамическогоСписка("ХозяйственнаяОперация");
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТабличнойЧастиСписок

&НаКлиенте
Процедура СписокПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	
	Если НЕ Копирование Тогда
		Операция = ПредопределенноеЗначение("Перечисление.ХозяйственныеОперации.ОплатаПоставщику");
		СоздатьНовыйДокументПоОперации(Операция)
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура НовыйДокументРБОВозвратДенежныхСредствОтПоставщика(Команда)
	
	Операция = ПредопределенноеЗначение("Перечисление.ХозяйственныеОперации.ВозвратДенежныхСредствОтПоставщика");
	СоздатьНовыйДокументПоОперации(Операция)
	
КонецПроцедуры

&НаКлиенте
Процедура НовыйДокументРБОПрочиеРасходы(Команда)
	
	Операция = ПредопределенноеЗначение("Перечисление.ХозяйственныеОперации.ПрочиеРасходы");
	СоздатьНовыйДокументПоОперации(Операция)
	
КонецПроцедуры

&НаКлиенте
Процедура ИзменитьВыделенные(Команда)
	
	ГрупповоеИзменениеОбъектовКлиент.ИзменитьВыделенные(Элементы.Список);
	
КонецПроцедуры

&НаКлиенте
Процедура НовыйДокументПБОПоступлениеОплатыОтКлиента(Команда)
	
	Операция = ПредопределенноеЗначение("Перечисление.ХозяйственныеОперации.ПоступлениеОплатыОтКлиента");
	СоздатьНовыйДокументПоОперации(Операция)
	
КонецПроцедуры

&НаКлиенте
Процедура НовыйДокументПБОВозвратОплатыКлиенту(Команда)
	
	Операция = ПредопределенноеЗначение("Перечисление.ХозяйственныеОперации.ВозвратОплатыКлиенту");
	СоздатьНовыйДокументПоОперации(Операция)
	
КонецПроцедуры

&НаКлиенте
Процедура НовыйДокументПБОПрочиеДоходы(Команда)
	
	Операция = ПредопределенноеЗначение("Перечисление.ХозяйственныеОперации.ПрочиеДоходы");
	СоздатьНовыйДокументПоОперации(Операция)
	
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьВыписку(Команда)
	
	ОткрытьЗагрузкуВыписки();
	
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

&НаКлиенте
Процедура ОткрытьЗагрузкуВыписки(ПараметрБанковскийСчет = Неопределено)
	
	Если ПараметрБанковскийСчет = Неопределено Тогда
		СтруктураОбмена = ДенежныеСредстваВызовСервера.ПолучитьСтруктуруПрямогоОбмена();
		Если СтруктураОбмена.БанковскийСчет = Неопределено Тогда // Есть несколько счетов, нужно выбирать.
			ОткрытьФорму("Справочник.БанковскиеСчета.Форма.ФормаВыбора", Новый Структура("ТекущаяСтрока", СтруктураОбмена.БанковскийСчет), ЭтотОбъект);
		ИначеЕсли СтруктураОбмена.БанковскийСчет.Пустая() Тогда  // Нет ни одной настройки обмена с банками, можно сразу выбирать файл загрузки.
			ДенежныеСредстваКлиент.ВыбратьФайлВыписки();
		Иначе                                                           // Один счет, можно сразу подставить его.
			ОткрытьФорму(
				"Обработка.КлиентБанк.Форма.Форма",
				СтруктураОбмена
			);
		КонецЕсли;
	Иначе
		СтруктураОбмена = ДенежныеСредстваВызовСервера.ПолучитьСтруктуруОбмена(ПараметрБанковскийСчет);
		Если НЕ СтруктураОбмена.ПрямойОбмен Тогда
			ДенежныеСредстваКлиент.ВыбратьФайлВыписки();
		Иначе
			ОткрытьФорму(
				"Обработка.КлиентБанк.Форма.Форма",
				СтруктураОбмена
			);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьОтборДинамическогоСписка(ИмяРеквизита)
	
	ОтборыСписковКлиентСервер.ИзменитьЭлементОтбораСписка(
		Список, 
		ИмяРеквизита, 
		ЭтаФорма[ИмяРеквизита], 
		ЗначениеЗаполнено(ЭтаФорма[ИмяРеквизита]));
		
КонецПроцедуры

&НаКлиенте
Процедура СоздатьНовыйДокументПоОперации(Операция)
	
	СтруктураПараметры = Новый Структура;
	СтруктураПараметры.Вставить("Основание", Новый Структура("ХозяйственнаяОперация, Контрагент, Магазин", Операция, Контрагент, Магазин));
   
    // &ЗамерПроизводительности
	ОценкаПроизводительностиРТКлиент.НачатьЗамер(
		         Истина, "Документ.РегистрацияБезналичнойОплаты.Форма.ФормаДокумента.СозданиеНового");                  

	ОткрытьФорму("Документ.РегистрацияБезналичнойОплаты.ФормаОбъекта", СтруктураПараметры, Элементы.Список);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	
	Если ТипЗнч(ВыбранноеЗначение) = Тип("СправочникСсылка.БанковскиеСчета") Тогда
		ОткрытьЗагрузкуВыписки(ВыбранноеЗначение);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
