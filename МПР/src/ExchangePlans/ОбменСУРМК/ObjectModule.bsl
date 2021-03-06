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
	
	ТипЭлемента = ТипЗнч(ЭлементДанных);
	ТипыДокументовДляОтложеннойОбработки = Новый ОписаниеТипов("ДокументОбъект.КассоваяСмена");

	Если НЕ ТипыДокументовДляОтложеннойОбработки.СодержитТип(ТипЭлемента) Тогда
		Возврат;
	КонецЕсли;
	
	ОбъектСуществует = ЗначениеЗаполнено(ЭлементДанных.Ссылка)
		И ОбщегоНазначения.СсылкаСуществует(ЭлементДанных.Ссылка);
	Если ОбъектСуществует Тогда
		СсылкаНаОбъект = ЭлементДанных.Ссылка;
	Иначе
		СсылкаНаОбъект = ЭлементДанных.ПолучитьСсылкуНового();
	КонецЕсли;
		
	Если ТипыДокументовДляОтложеннойОбработки.СодержитТип(ТипЭлемента)
		И ЗначениеЗаполнено(ЭлементДанных.ОкончаниеКассовойСмены) Тогда
		
		СтрокаСообщения = НСтр("ru = 'Запись необходима для отложенной обработки документа %1.
			|Запись автоматически будет удалена после получения информации о закрытии смены из другой информационной базы.'");
		СтрокаСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(СтрокаСообщения, Строка(ЭлементДанных));
		
		РегистрыСведений.РезультатыОбменаДанными.ЗарегистрироватьОшибкуПроверкиОбъекта(
			СсылкаНаОбъект,
			Ссылка,
			СтрокаСообщения,
			Перечисления.ТипыПроблемОбменаДанными.НезаполненныеРеквизиты);

	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;

	РежимВыгрузкиПриНеобходимости = Перечисления.РежимыВыгрузкиОбъектовОбмена.ВыгружатьПриНеобходимости;

	Если ОбменДаннымиСервер.НадоВыполнитьОбработчикПослеЗагрузкиДанных(ЭтотОбъект, Ссылка) Тогда
		ПослеЗагрузкиДанных(Отказ);
	КонецЕсли;

КонецПроцедуры

Процедура ПослеЗагрузкиДанных(Отказ)

	ВыполнитьОтложеннуюОбработкуОбъектов(Отказ);

КонецПроцедуры

#КонецОбласти

#Область ОтложеннаяОбработка

Процедура ВыполнитьОтложеннуюОбработкуОбъектов(Отказ)
	
	ОтложеннаяОбработкаЧеков();
	ОтложеннаяОбработкаЗакрытиеСмены();
	
КонецПроцедуры

Процедура ОтложеннаяОбработкаЧеков()
	
	Запрос = Новый Запрос;
	Запрос.Текст = "
		|ВЫБРАТЬ
		|	УзелКассыККМ.КассаККМ КАК КассаККМ
		|ПОМЕСТИТЬ УзелКассыККМ
		|ИЗ
		|	&УзелКассыККМ КАК УзелКассыККМ
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	ЧекККМ.Ссылка КАК Ссылка,
		|	ЧекККМ.Дата КАК Дата,
		|	ЧекККМ.МоментВремени КАК МоментВремени,
		|	ЧекККМ.Проведен КАК Проведен
		|ИЗ
		|	Документ.ЧекККМ КАК ЧекККМ
		|		ЛЕВОЕ СОЕДИНЕНИЕ УзелКассыККМ КАК УзелКассыККМ
		|		ПО ЧекККМ.КассаККМ = УзелКассыККМ.КассаККМ
		|ГДЕ
		|	ЧекККМ.СтатусЧекаККМ = ЗНАЧЕНИЕ(Перечисление.СтатусыЧековККМ.ПустаяСсылка)
		|	И ЧекККМ.КассаККМ.ТипКассы = ЗНАЧЕНИЕ(Перечисление.ТипыКассККМ.ККМED)
		|
		|УПОРЯДОЧИТЬ ПО
		|	Дата,
		|	МоментВремени
		|";
	
	Запрос.УстановитьПараметр("УзелКассыККМ", ЭтотОбъект.КассыККМ.Выгрузить());
	РезультатЗапроса = Запрос.Выполнить();
	
	Выборка = РезультатЗапроса.Выбрать();
	
	Пока Выборка.Следующий() Цикл
				
		Попытка
			
			ДокументОбъект = Выборка.Ссылка.ПолучитьОбъект();
			
			Если Выборка.Проведен Тогда
				РежимЗаписи = РежимЗаписиДокумента.Проведение;
			Иначе	
				РежимЗаписи = РежимЗаписиДокумента.ОтменаПроведения;
			КонецЕсли;
			
			Если ДокументОбъект.ОтчетОРозничныхПродажах.Пустая() Тогда
				ДокументОбъект.СтатусЧекаККМ = Перечисления.СтатусыЧековККМ.Пробитый;
			Иначе
				ДокументОбъект.СтатусЧекаККМ = Перечисления.СтатусыЧековККМ.Архивный;
				ДокументОбъект.мЗакрытиеСмены = Истина;
			КонецЕсли;
			
			ДокументОбъект.ДополнительныеСвойства.Вставить("ЗагрузкаДанныхИзРабочегоМеста");
			ДокументОбъект.ДополнительныеСвойства.Вставить("НеВыполнятьРасчетСтатуса");
			ДокументОбъект.Записать(РежимЗаписи);
					
		Исключение
			
			Инфо = ИнформацияОбОшибке();
			ТекстСообщенияОбОшибке = НСтр("ru = 'Ошибка при проведении документа: %1. 
			|При загрузке данных из РМК: %2'");
			ТекстСообщенияОбОшибке = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстСообщенияОбОшибке, КраткоеПредставлениеОшибки(Инфо), Ссылка);
			ЗаписьЖурналаРегистрации(НСтр("ru = 'Обмен данными.Загрузка данных'", ОбщегоНазначения.КодОсновногоЯзыка()), УровеньЖурналаРегистрации.Ошибка,,Инфо);
			
		КонецПопытки;
				
	КонецЦикла;

КонецПроцедуры

Процедура ОтложеннаяОбработкаЗакрытиеСмены()
	
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
		|	РезультатыОбменаДанными.ПроблемныйОбъект.МоментВремени КАК ПроблемныйОбъектМоментВремени,
		|	РезультатыОбменаДанными.ТипПроблемы КАК ТипПроблемы
		|ИЗ
		|	РегистрСведений.РезультатыОбменаДанными КАК РезультатыОбменаДанными
		|ГДЕ
		|	РезультатыОбменаДанными.УзелИнформационнойБазы = &УзелИнформационнойБазы
		|	И РезультатыОбменаДанными.ТипПроблемы = ЗНАЧЕНИЕ(Перечисление.ТипыПроблемОбменаДанными.НезаполненныеРеквизиты)
		|УПОРЯДОЧИТЬ ПО
		|	ДатаДокумента,
		|	ПроблемныйОбъектМоментВремени
		|";
	
	Результат = Запрос.Выполнить();
	
	МассивДокументов = Результат.Выгрузить().ВыгрузитьКолонку("ПроблемныйОбъект");
	Для Каждого ДокументСсылка Из МассивДокументов Цикл
		
		Если ТипЗнч(ДокументСсылка) <> Тип("ДокументСсылка.КассоваяСмена") Тогда
			Продолжить;
		КонецЕсли;
		
		Если НЕ ДокументСсылка.Пустая() Тогда
			
			Результат = Новый Структура("ТекстОшибки");

			Если ОбщегоНазначения.СсылкаСуществует(ДокументСсылка) Тогда
								
				ЕстьОшибки = Ложь;
				
				ПараметрыСмены = Новый Структура;
				ПараметрыСмены.Вставить("КассаККМ", ДокументСсылка.КассаККМ);
				ПараметрыСмены.Вставить("НачалоКассовойСмены", ДокументСсылка.НачалоКассовойСмены);
				ПараметрыСмены.Вставить("ОкончаниеКассовойСмены", ДокументСсылка.ОкончаниеКассовойСмены);
				
				СсылкаНаОтчет = Неопределено;
				СписокНепроведенных = Новый СписокЗначений;
				СписокАктов = Новый СписокЗначений;
				
				РозничныеПродажиСервер.ОбработатьСоздатьДокументыПоСмене(
					ЕстьОшибки, ПараметрыСмены, СсылкаНаОтчет, СписокНепроведенных, СписокАктов);
				
				Если ЕстьОшибки	Тогда
					ОписаниеОшибки = НСтр("ru = 'Ошибка при формировании отчета о розничных продажах.'");
					Результат.Вставить("ТекстОшибки", ОписаниеОшибки);
				КонецЕсли;
				
				Если Не ЕстьОшибки Тогда
					
					ЗакрытьКассовуюСмену(ДокументСсылка, СсылкаНаОтчет, Результат);
					
					Если Результат.Свойство("Успешно")
						И СсылкаНаОтчет <> Неопределено Тогда
						ДенежныеСредстваВызовСервера.СоздатьДокументВыемкаДенежныхСредствИзКассыККМ(
							ЕстьОшибки, СсылкаНаОтчет.СуммаОплатыНаличных, ПараметрыСмены.КассаККМ, СсылкаНаОтчет);
					КонецЕсли;
				КонецЕсли;
			КонецЕсли;
			
			Если Не Результат.Свойство("Успешно") Тогда
				
				ОписаниеОшибки = НСтр("ru = 'При обработке кассовой смены произошла ошибка.
			                            |Дополнительное описание:
			                            |%ДополнительноеОписание%'");
				ОписаниеОшибки = СтрЗаменить(ОписаниеОшибки, "%ДополнительноеОписание%", Результат.ТекстОшибки);

				ЗаписьЖурналаРегистрации(ОбменДаннымиСервер.СобытиеЖурналаРегистрацииОбменДанными(),
					УровеньЖурналаРегистрации.Предупреждение,,, ОписаниеОшибки);
			Иначе
				// Удаляем запись для отложенного проведения.
				РегистрыСведений.РезультатыОбменаДанными.ЗарегистрироватьУстранениеПроблемы(
					ДокументСсылка.ПолучитьОбъект(),
					Перечисления.ТипыПроблемОбменаДанными.НезаполненныеРеквизиты,
					Ссылка);
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЦикла;

КонецПроцедуры

Процедура ЗакрытьКассовуюСмену(КассоваяСмена, СсылкаНаОтчет, Результат)
	
	КассоваяСменаОбъект = КассоваяСмена.ПолучитьОбъект();
	КассоваяСменаОбъект.Статус = Перечисления.СтатусыКассовойСмены.Закрыта;
	
	Попытка
		КассоваяСменаОбъект.Записать(РежимЗаписиДокумента.Проведение);
		Если НЕ СсылкаНаОтчет = Неопределено Тогда
			ОбъектОтчет = СсылкаНаОтчет.ПолучитьОбъект();
			ОбъектОтчет.КассоваяСмена = КассоваяСмена;
			ОбъектОтчет.Записать(РежимЗаписиДокумента.Запись);
		КонецЕсли;
		Результат.Вставить("Успешно");
	Исключение
		Результат.Вставить("ТекстОшибки", ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
	КонецПопытки;
		
КонецПроцедуры

#КонецОбласти

#КонецЕсли
