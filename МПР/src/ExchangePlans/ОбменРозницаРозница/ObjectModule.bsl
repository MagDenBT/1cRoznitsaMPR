#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Дополнительный обработчик события "ПриПолученииДанныхОтГлавного".
// Выполняется после выполнения базовых алгоритмов библиотеки.
//
// Параметры:
//  ЭлементДанных     - Произвольный - см. описание обработчика "ПриПолученииДанныхОтГлавного" в синтаксис-помощнике.
//  ПолучениеЭлемента - ПолучениеЭлементаДанных - см. описание обработчика "ПриПолученииДанныхОтГлавного" в синтаксис-помощнике.
//
Процедура ПриПолученииДанных(ЭлементДанных, ПолучениеЭлемента) Экспорт
	
	ТипОбъекта = ТипЗнч(ЭлементДанных);
	
	Если ТипОбъекта = Тип("УдалениеОбъекта")
		И ЗначениеЗаполнено(ЭлементДанных.Ссылка) Тогда
		МетаданныеОбъекта = Метаданные.НайтиПоТипу(ТипЗнч(ЭлементДанных.Ссылка));
	Иначе
		МетаданныеОбъекта = Метаданные.НайтиПоТипу(ТипОбъекта);
	КонецЕсли;
	
	Если НЕ ВозможнаЗагрузкаОбъекта(ЭлементДанных, МетаданныеОбъекта) Тогда
		ПолучениеЭлемента = ПолучениеЭлементаДанных.Игнорировать;
		Возврат;
	КонецЕсли;
	
	Если НЕ ПодчиненныйУзел И ТипЗнч(ЭлементДанных) = Тип("ДокументОбъект.ВводНачальныхОстатковУзла") Тогда
		ЭлементДанных.Узел = ПланыОбмена.ОбменРозницаРозница.ЭтотУзел();
	КонецЕсли;
	
	// Для варианта настройки "ПоРабочемуМесту" передаются не все движения документов,
	// поэтому при получении Удаления или ОтменыПроведения документа,
	// необходимо дополнительно удалять движения.
	Если ВариантНастройки = "ПоРабочемуМесту"
		И ОбщегоНазначения.ЭтоДокумент(МетаданныеОбъекта)
		И ЗначениеЗаполнено(ЭлементДанных.Ссылка)
		И ОбщегоНазначения.СсылкаСуществует(ЭлементДанных.Ссылка)
		И (ТипОбъекта = Тип("УдалениеОбъекта")
		ИЛИ НЕ ЭлементДанных.Проведен И ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ЭлементДанных.Ссылка, "Проведен")) Тогда
		ОбменДаннымиРТ.ОтменитьПроведениеДокументаПриЗагрузке(ЭлементДанных.Ссылка, Ссылка);
	КонецЕсли;
	
	Если ТипЗнч(ЭлементДанных) = Тип("ДокументОбъект.ПеремещениеТоваров") Тогда
		ОбновитьПеремещениеПоТТН(ЭлементДанных, ПолучениеЭлемента);
	КонецЕсли;
	
	ЗарегистрироватьОбъектДляОтложеннойОбработки(ЭлементДанных);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Если ПодчиненныйУзел Тогда
		ПроверяемыеРеквизиты.Добавить("ДатаНачалаВыгрузкиДокументов");
		ПроверяемыеРеквизиты.Добавить("Магазины");
		ПроверяемыеРеквизиты.Добавить("Магазины.Магазин");
		ПроверяемыеРеквизиты.Добавить("РежимВыгрузкиИнформативныхОстатков");
	Иначе
		// Консолидирующий узел.
		Если ВариантНастройки = "ПоРабочемуМесту" Тогда
			ПроверяемыеРеквизиты.Добавить("РабочееМесто");
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если НЕ ЭтотУзел Тогда
		Отказ = Истина;
	КонецЕсли;

	МодульОбменДаннымиСервер = ОбщегоНазначения.ОбщийМодуль("ОбменДаннымиСервер");
	Если МодульОбменДаннымиСервер.НадоВыполнитьОбработчикПослеЗагрузкиДанных(ЭтотОбъект, Ссылка) Тогда
		ПослеЗагрузкиДанных(Отказ);
	Иначе
		ОбменДаннымиРТ.АктуализироватьЗаданияОбновленияИнформативныхОстатков(
			РежимВыгрузкиИнформативныхОстатков <> Перечисления.РежимыВыгрузкиИнформативныхОстатков.НеВыгружать,
			ВыгружатьИнформативныеОстаткиПоСкладам);
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка)
	
	Если Не ДанныеЗаполнения = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если СтандартныеПодсистемыСервер.ЭтоБазоваяВерсияКонфигурации() Тогда
		ПодчиненныйУзел = Ложь;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ВозможнаЗагрузкаОбъекта(ЭлементДанных, МетаданныеОбъекта)
	
	Если ПодчиненныйУзел
		И ОбщегоНазначения.ЭтоКонстанта(МетаданныеОбъекта) Тогда
		Возврат Ложь;
	КонецЕсли;
	
	// Обработаем загрузку неразделенных данных.
	Если ОбщегоНазначения.РазделениеВключено()
		И ОбщегоНазначения.ДоступноИспользованиеРазделенныхДанных()
		И ОбщегоНазначения.ЭтоОбъектСсылочногоТипа(МетаданныеОбъекта) Тогда
		
		Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.РаботаВМоделиСервиса") Тогда
			МодульРаботаВМоделиСервиса = ОбщегоНазначения.ОбщийМодуль("РаботаВМоделиСервиса");
			ЭтоРазделенныйОбъектМетаданных = МодульРаботаВМоделиСервиса.ЭтоРазделенныйОбъектМетаданных(МетаданныеОбъекта.ПолноеИмя());
		Иначе
			ЭтоРазделенныйОбъектМетаданных = Ложь;
		КонецЕсли;
		
		Если Не ЭтоРазделенныйОбъектМетаданных Тогда
			Возврат Ложь;
		КонецЕсли;
		
	КонецЕсли;
	
	Если ОбменДаннымиСобытия.ЗагрузкаЗапрещена(ЭлементДанных, Ссылка) Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Возврат Истина;
	
КонецФункции

Процедура ПослеЗагрузкиДанных(Отказ)
	
	ВыполнитьОтложеннуюОбработкуОбъектов(Отказ);
	
КонецПроцедуры

#Область ОтложеннаяОбработка

Процедура ЗарегистрироватьОбъектДляОтложеннойОбработки(ЭлементДанных)

	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ОбменДанными") Тогда
		
		СтрокаТипыДокументовОтложеннойОбработки = "";
		СтрокаТипыСправочниковОтложеннойОбработки = "";
		Если ПодчиненныйУзел Тогда
			Если ВариантНастройки = "ПоРабочемуМесту" Тогда
				СтрокаТипыДокументовОтложеннойОбработки =
				"ДокументОбъект.ОтчетОРозничныхПродажах,
				|ДокументОбъект.ЧекККМ";
				
				СтрокаТипыСправочниковОтложеннойОбработки = 
				"СправочникОбъект.РабочиеМеста";
			ИначеЕсли ВариантНастройки = "ПоМагазину" Тогда
				СтрокаТипыДокументовОтложеннойОбработки =
				"ДокументОбъект.АктОРасхожденияхПриПриемкеТоваров,
				|ДокументОбъект.ОтчетОРозничныхПродажах,
				|ДокументОбъект.ПеремещениеТоваров";
			КонецЕсли;
		Иначе
			Если ВариантНастройки = "ПоМагазину" Тогда
				СтрокаТипыДокументовОтложеннойОбработки =
				"ДокументОбъект.ВводНачальныхОстатковУзла";
			КонецЕсли;
		КонецЕсли;
		ТипыДокументовДляОтложеннойОбработки = Новый ОписаниеТипов(СтрокаТипыДокументовОтложеннойОбработки);
		ТипыСправочниковОтложеннойОбработки = Новый ОписаниеТипов(СтрокаТипыСправочниковОтложеннойОбработки);
		
		ТипЭлемента = ТипЗнч(ЭлементДанных);
		Если НЕ ТипыДокументовДляОтложеннойОбработки.СодержитТип(ТипЭлемента)
			И НЕ ТипыСправочниковОтложеннойОбработки.СодержитТип(ТипЭлемента) Тогда
			Возврат;
		КонецЕсли;
		
		ОбъектСуществует = ЗначениеЗаполнено(ЭлементДанных.Ссылка)
			И ОбщегоНазначения.СсылкаСуществует(ЭлементДанных.Ссылка);
		Если ОбъектСуществует Тогда
			СсылкаНаОбъект = ЭлементДанных.Ссылка;
		Иначе
			СсылкаНаОбъект = ЭлементДанных.ПолучитьСсылкуНового();
		КонецЕсли;
			
		Если ТипыДокументовДляОтложеннойОбработки.СодержитТип(ТипЭлемента) Тогда
			// Зарегистрируем документы для отложенного проведения.
			Если ЭлементДанных.Проведен ИЛИ ТипЭлемента = Тип("ДокументОбъект.ВводНачальныхОстатковУзла") Тогда
				СтрокаСообщения = НСтр("ru = 'Требуется отложенное проведение документа %1, полученного из другой информационной базы.'");
				СтрокаСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(СтрокаСообщения, Строка(ЭлементДанных));
				
				РегистрыСведений.РезультатыОбменаДанными.ЗарегистрироватьОшибкуПроверкиОбъекта(
					СсылкаНаОбъект,
					Ссылка,
					СтрокаСообщения,
					Перечисления.ТипыПроблемОбменаДанными.НепроведенныйДокумент);
					
			КонецЕсли;
		ИначеЕсли ТипыСправочниковОтложеннойОбработки.СодержитТип(ТипЭлемента) Тогда
			// Зарегистрируем справочники для отложенного проведения.
			СтрокаСообщения = НСтр("ru = 'Требуется отложенная запись объекта %1, полученного из другой информационной базы.'");
				СтрокаСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(СтрокаСообщения, Строка(ЭлементДанных));
				
			Если НЕ РабочееМесто = СсылкаНаОбъект Тогда
				РегистрыСведений.РезультатыОбменаДанными.ЗарегистрироватьОшибкуПроверкиОбъекта(
					СсылкаНаОбъект,
					Ссылка,
					СтрокаСообщения,
					Перечисления.ТипыПроблемОбменаДанными.НезаполненныеРеквизиты);
			КонецЕсли;
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ВыполнитьОтложеннуюОбработкуОбъектов(Отказ)
	
	ПодсистемаОбменДаннымиСуществует = ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ОбменДанными");
	Если НЕ ПодсистемаОбменДаннымиСуществует Тогда
		Возврат;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("УзелИнформационнойБазы", Ссылка);
	Запрос.Текст =
		"ВЫБРАТЬ
		|	РезультатыОбменаДанными.ПроблемныйОбъект КАК ПроблемныйОбъект,
		|	РезультатыОбменаДанными.ДатаДокумента КАК ДатаДокумента,
		|	РезультатыОбменаДанными.ТипПроблемы КАК ТипПроблемы
		|ПОМЕСТИТЬ втОбъектыОтложеннойОбработки
		|ИЗ
		|	РегистрСведений.РезультатыОбменаДанными КАК РезультатыОбменаДанными
		|ГДЕ
		|	РезультатыОбменаДанными.УзелИнформационнойБазы = &УзелИнформационнойБазы
		|	И (РезультатыОбменаДанными.ТипПроблемы = ЗНАЧЕНИЕ(Перечисление.ТипыПроблемОбменаДанными.НепроведенныйДокумент)
		|			ИЛИ РезультатыОбменаДанными.ТипПроблемы = ЗНАЧЕНИЕ(Перечисление.ТипыПроблемОбменаДанными.НезаполненныеРеквизиты))
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	втОбъектыОтложеннойОбработки.ПроблемныйОбъект КАК ПроблемныйОбъект,
		|	втОбъектыОтложеннойОбработки.ДатаДокумента КАК ДатаДокумента,
		|	втОбъектыОтложеннойОбработки.ПроблемныйОбъект.МоментВремени КАК ПроблемныйОбъектМоментВремени
		|ИЗ
		|	втОбъектыОтложеннойОбработки КАК втОбъектыОтложеннойОбработки
		|ГДЕ
		|	втОбъектыОтложеннойОбработки.ТипПроблемы = ЗНАЧЕНИЕ(Перечисление.ТипыПроблемОбменаДанными.НепроведенныйДокумент)
		|
		|УПОРЯДОЧИТЬ ПО
		|	ДатаДокумента,
		|	ПроблемныйОбъектМоментВремени
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	втОбъектыОтложеннойОбработки.ПроблемныйОбъект КАК ПроблемныйОбъект
		|ИЗ
		|	втОбъектыОтложеннойОбработки КАК втОбъектыОтложеннойОбработки
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.РабочиеМеста КАК РабочиеМеста
		|		ПО втОбъектыОтложеннойОбработки.ПроблемныйОбъект = РабочиеМеста.Ссылка
		|ГДЕ
		|	втОбъектыОтложеннойОбработки.ТипПроблемы = ЗНАЧЕНИЕ(Перечисление.ТипыПроблемОбменаДанными.НезаполненныеРеквизиты)";
	
	РезультатПакета = Запрос.ВыполнитьПакет();
	
	МассивДокументов = РезультатПакета[1].Выгрузить().ВыгрузитьКолонку("ПроблемныйОбъект");
	Для Каждого ДокументСсылка Из МассивДокументов Цикл
		
		Если НЕ ДокументСсылка.Пустая()
			И ОбщегоНазначения.СсылкаСуществует(ДокументСсылка) Тогда
			
			Результат = Новый Структура;
			Если ТипЗнч(ДокументСсылка) = Тип("ДокументСсылка.ВводНачальныхОстатковУзла")
				ИЛИ ВариантНастройки = "ПоРабочемуМесту" Тогда
				ДопСвойства = Новый Структура;
				ДопСвойства.Вставить("ЗагрузкаДанныхИзРабочегоМеста");
				
				ДополнительныеПараметры = Новый Структура;
				ДополнительныеПараметры.Вставить("ДополнительныеСвойства", ДопСвойства);
			
				Результат = ОбменДаннымиРТ.ВыполнитьПроведениеДокументаПриЗагрузке(ДокументСсылка,
					Ссылка, ДополнительныеПараметры);
			ИначеЕсли ВариантНастройки = "ПоМагазину" Тогда
				Результат = ОбновитьДвиженияДокументаПоРегистрам(ДокументСсылка);
			КонецЕсли;
			
			// При получении ввода остатков подчиненным узлом, сместим дату синхронизации.
			Если НЕ ПодчиненныйУзел И ТипЗнч(ДокументСсылка) = Тип("ДокументСсылка.ВводНачальныхОстатковУзла") Тогда
				ДатаНачалаВыгрузкиДокументов = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ДокументСсылка, "Дата");
			КонецЕсли;
			
			Если Результат.Свойство("Успешно") И НЕ Результат.Успешно Тогда
				ЗаписьЖурналаРегистрации(ОбменДаннымиСервер.СобытиеЖурналаРегистрацииОбменДанными(),
					УровеньЖурналаРегистрации.Предупреждение,,, Результат.ОписаниеОшибки);
			Иначе
				// Удаляем запись для отложенного проведения.
				РегистрыСведений.РезультатыОбменаДанными.ЗарегистрироватьУстранениеПроблемы(
					ДокументСсылка.ПолучитьОбъект(),
					Перечисления.ТипыПроблемОбменаДанными.НепроведенныйДокумент,
					Ссылка);
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЦикла;
	
	// Обновим рабочее место.
	ВыборкаРабочееМесто = РезультатПакета[2].Выбрать();
	Если ПодчиненныйУзел И ВариантНастройки = "ПоРабочемуМесту"
		И ВыборкаРабочееМесто.Следующий() Тогда
		
		РабочееМесто = ВыборкаРабочееМесто.ПроблемныйОбъект;
		
		// Удаляем запись для отложенного заполнения.
		РегистрыСведений.РезультатыОбменаДанными.ЗарегистрироватьУстранениеПроблемы(
			ВыборкаРабочееМесто.ПроблемныйОбъект.ПолучитьОбъект(),
			Перечисления.ТипыПроблемОбменаДанными.НезаполненныеРеквизиты,
			Ссылка);
	КонецЕсли;
	
КонецПроцедуры

Функция ОбновитьДвиженияДокументаПоРегистрам(ДокументСсылка)
	
	ОписаниеОшибки = "";
	Успешно        = Истина;
	
	ТипыДляОбновленияТоваров = Новый Массив;
	ТипыДляОбновленияТоваров.Добавить(Тип("ДокументСсылка.АктОРасхожденияхПриПриемкеТоваров"));
	ТипыДляОбновленияТоваров.Добавить(Тип("ДокументСсылка.ПеремещениеТоваров"));
	Если НЕ ТипыДляОбновленияТоваров.Найти(ТипЗнч(ДокументСсылка)) = Неопределено Тогда
		ТоварыНаСкладах = РегистрыНакопления.ТоварыНаСкладах.СоздатьНаборЗаписей();
		ТоварыНаСкладах.Отбор.Регистратор.Установить(ДокументСсылка);
		
		ДополнительныеСвойстваОбъекта = Новый Структура;
		ПроведениеСервер.ИнициализироватьДополнительныеСвойстваДляПроведения(ДокументСсылка, ДополнительныеСвойстваОбъекта);
		
		Документы[ДокументСсылка.Метаданные().Имя].ИнициализироватьДанныеДокумента(ДокументСсылка, ДополнительныеСвойстваОбъекта);
		
		ТаблицаДвижений = ДополнительныеСвойстваОбъекта.ТаблицыДляДвижений.ТаблицаТоварыНаСкладах;
		Если ТаблицаДвижений.Колонки.Найти("Регистратор") = Неопределено Тогда
			ТаблицаДвижений.Колонки.Добавить("Регистратор");
			ТаблицаДвижений.ЗаполнитьЗначения(ДокументСсылка, "Регистратор");
		КонецЕсли;
		
		ТоварыНаСкладах.Загрузить(ТаблицаДвижений);
		
		Попытка
			
			ТоварыНаСкладах.ОбменДанными.Отправитель = Ссылка;
			ТоварыНаСкладах.Записать();
			
		Исключение
			
			Успешно = Ложь;
			ОписаниеОшибки = ИнформацияОбОшибке();
			
		КонецПопытки;
	КонецЕсли;
	
	Если ТипЗнч(ДокументСсылка) = Тип("ДокументСсылка.ОтчетОРозничныхПродажах") Тогда
		МассивОтчетовОРозничныхПродажах = ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(ДокументСсылка);
		БонусныеБаллыСервер.ПровестиОтчетыОПродажахПриОбмене(МассивОтчетовОРозничныхПродажах, Ссылка);
	КонецЕсли;
	
	Результат = Новый Структура;
	Результат.Вставить("Успешно", Успешно);
	Результат.Вставить("ОписаниеОшибки", ОписаниеОшибки);
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти

Процедура ОбновитьПеремещениеПоТТН(ЭлементДанных, ПолучениеЭлемента)
	
	Если НЕ ЗначениеЗаполнено(ЭлементДанных.ТТНВходящаяЕГАИС) Тогда
		Если ЭлементДанных.ЭтоНовый() Тогда
			ИдентификаторПеремещения = СокрЛП(ЭлементДанных.ПолучитьСсылкуНового().УникальныйИдентификатор());
		Иначе
			ИдентификаторПеремещения = СокрЛП(ЭлементДанных.Ссылка.УникальныйИдентификатор());
		КонецЕсли;
		ТТН = ИнтеграцияЕГАИСРТ.НайтиТТНПоИдентификаторуПеремещения(ИдентификаторПеремещения);
		Если ЗначениеЗаполнено(ТТН) Тогда
			ЭлементДанных.ТТНВходящаяЕГАИС = ТТН;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
