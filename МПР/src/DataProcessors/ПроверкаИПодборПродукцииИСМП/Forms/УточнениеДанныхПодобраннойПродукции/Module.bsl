#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	КоличествоПодобрано                                   = Параметры.КоличествоПодобрано;
	КоличествоПодобраноВзвешено                           = Параметры.КоличествоПодобраноВзвешено;
	КоличествоПотребительскихУпаковок                     = Параметры.КоличествоПотребительскихУпаковок;
	КоличествоПотребительскихУпаковокТребующихВзвешивания = Параметры.КоличествоПотребительскихУпаковокТребующихВзвешивания;
	
	ИнтеграцияИСПереопределяемый.НастроитьПодключаемоеОборудование(ЭтотОбъект, "");
	СобытияФормИСПереопределяемый.ПриСозданииНаСервере(ЭтотОбъект, Отказ, СтандартнаяОбработка);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Готово(Команда)
	
	Если КоличествоПодобрано < КоличествоПодобраноВзвешено
		И КоличествоПодобрано <> 0 Тогда // Разрешено указывать 0, если товар требуется перевзвесить
		
		ТекстОшибки = СтрШаблон(
			НСтр("ru = 'Количество должно быть не менее %1'"),
			КоличествоПодобраноВзвешено);
		
		ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстОшибки,, Элементы.КоличествоПодобрано.Имя);
		
	Иначе
		
		ПараметрыЗакрытия = Новый Структура;
		ПараметрыЗакрытия.Вставить("Количество", КоличествоПодобрано);
		
		Закрыть(ПараметрыЗакрытия);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПолучитьВес(Команда)
	
	МенеджерОборудованияКлиент.НачатьПолученияВесаСЭлектронныхВесов(
		Новый ОписаниеОповещения("ПолучитьВесЗавершение", ЭтотОбъект),
		УникальныйИдентификатор);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ПолучитьВесЗавершение(РезультатВыполнения, ДополнительныеПараметры) Экспорт
	
	Если РезультатВыполнения.Результат Тогда
		
		КоличествоПодобрано = РезультатВыполнения.Вес;
		
	Иначе
		
		ОбщегоНазначенияКлиент.СообщитьПользователю(
			СтрШаблон(НСтр("ru = 'При выполнении операции произошла ошибка: %1'"),
				РезультатВыполнения.ОписаниеОшибки));
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти