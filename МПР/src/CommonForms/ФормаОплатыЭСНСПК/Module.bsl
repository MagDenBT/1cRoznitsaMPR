#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Параметры.Свойство("КассаККМ", КассаККМ);
	Параметры.Свойство("ЭтоВозврат", ЭтоВозврат);
	Параметры.Свойство("СуммаЧека", СуммаЧека);
	Параметры.Свойство("ИдентификаторКорзины", ИдентификаторКорзины);
	
	Если ЭтоВозврат Тогда
		Заголовок = НСтр("ru = 'Возврат оплаты электронным сертификатом НСПК'");
		Элементы.ГруппаОплатаНеЭСНСПК.Видимость = Ложь;
	Иначе
		Заголовок = НСтр("ru = 'Оплата электронным сертификатом НСПК'");
		Элементы.ГруппаОплатаНеЭСНСПК.Видимость = Истина;
	КонецЕсли;
	
	ТоварныеПозиции = Новый Массив();
	Параметры.Свойство("ТоварныеПозиции", ТоварныеПозиции);
	
	ТоварыФСС.Очистить();
	
	Для Каждого СтрокаТовара Из ТоварныеПозиции Цикл
		ТоварныеСтроки = ТоварыФСС.НайтиСтроки(Новый Структура("Номенклатура", СтрокаТовара.Номенклатура));
		Если ТоварныеСтроки.Количество() = 0 Тогда
			НоваяСтрока = ТоварыФСС.Добавить();
			НоваяСтрока.НомерПозиции = НоваяСтрока.ПолучитьИдентификатор();
			НоваяСтрока.НомерПозицииВозврата = 999;
			НоваяСтрока.Артикул = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(СтрокаТовара.Номенклатура, "Код");
			ЗаполнитьЗначенияСвойств(НоваяСтрока, СтрокаТовара);
		Иначе
			НоваяСтрока = ТоварныеСтроки[0];
			НоваяСтрока.Количество = НоваяСтрока.Количество + СтрокаТовара.Количество;
			НоваяСтрока.Сумма = НоваяСтрока.Сумма + СтрокаТовара.Сумма;
			НоваяСтрока.Цена =
				?(НоваяСтрока.Количество = 0, НоваяСтрока.СуммаВсего, Окр(НоваяСтрока.СуммаВсего/НоваяСтрока.Количество, 2));
		КонецЕсли;
	КонецЦикла;
	
	ПредварительноеОдобрениеПолучено = Ложь;
	
	ВывестиПредварительноеОдобрениеНаПечать();
	УстановитьЗаголовкиОплаты(ЭтотОбъект);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура СуммаПКПриИзменении(Элемент)
	
	СуммаПК = Мин(СуммаПК, СуммаЧека - СуммаЭС);
	СуммаНаличные = СуммаЧека - СуммаЭС - СуммаПК;
	ПроверитьСуммы();
КонецПроцедуры

&НаКлиенте
Процедура СуммаНаличныеПриИзменении(Элемент)
	
	Сдача = -1 *(СуммаЧека - СуммаЭС - СуммаПК - СуммаНаличные);
	ПроверитьСуммы();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Отменить(Команда)
	
	ПараметрыЗакрытия = Новый Структура();
	ПараметрыЗакрытия.Вставить("Результат", Ложь);
	
	Закрыть(ПараметрыЗакрытия);
КонецПроцедуры

&НаКлиенте
Процедура Оплатить(Команда)
	
	ТоварныеПозиции = Новый Массив();
	ДополнительныеПараметры = Новый Структура();
	
	Если ПредварительноеОдобрениеПолучено Тогда
		СледующаяОперация = "ОплатитьЭлектроннымСертификатом";
		Если ЭтоВозврат Тогда
			СледующаяОперация = "ВернутьЭлектроннымСертификатом";
		КонецЕсли;
	Иначе
		РезультатПроверки = ПроверитьВозможностьОплатыНСПКНаСервере(КассаККМ);
		Если ЗначениеЗаполнено(РезультатПроверки) Тогда
			Элементы.ПроверкаВозможностиОплаты.Заголовок = РезультатПроверки;
			Элементы.ПроверкаВозможностиОплаты.Видимость = Истина;
			Возврат;
		Иначе
			Элементы.ПроверкаВозможностиОплаты.Видимость = Ложь;
		КонецЕсли;
		
		СледующаяОперация = "ПредварительноеОдобрениеИспользования";
		Если ЭтоВозврат Тогда
			СледующаяОперация = "ПредварительноеОдобрениеВозврата";
		КонецЕсли;
	КонецЕсли;
	
	ДополнительныеПараметры.Вставить("СледующаяОперация", СледующаяОперация);
	
	Если ПредварительноеОдобрениеПолучено Тогда
		Если ЭтоВозврат Тогда
			ВернутьЭлектронныйСертификат(СледующаяОперация);
		Иначе
			ОплатитьЭлектроннымСертификатом(СледующаяОперация);
		КонецЕсли;
	Иначе
		Для Каждого СтрокаТоваров Из ТоварыФСС Цикл
			ТоварнаяПозиция = Новый Структура();
			ТоварнаяПозиция.Вставить("НомерПозиции", СтрокаТоваров.НомерПозиции);
			ТоварнаяПозиция.Вставить("Артикул", СтрокаТоваров.Артикул);
			ТоварнаяПозиция.Вставить("КодТовараТРУ", СтрокаТоваров.КодТовараТРУ);
			ТоварнаяПозиция.Вставить("Количество", СтрокаТоваров.Количество);
			ТоварнаяПозиция.Вставить("Цена", СтрокаТоваров.Цена);
			ТоварнаяПозиция.Вставить("НомерПозицииВозврата", СтрокаТоваров.НомерПозицииВозврата);
			ТоварныеПозиции.Добавить(ТоварнаяПозиция);
		КонецЦикла;
		ДополнительныеПараметры.Вставить("ТоварныеПозиции", ТоварныеПозиции);
		
		Если ЭтоВозврат Тогда
			ДополнительныеПараметры.Вставить("ИдентификаторКорзины", ИдентификаторКорзины);
		КонецЕсли;
		
		ОписаниеОповещения = Новый ОписаниеОповещения("ВыполнитьОперациюЭТЗавершение", ЭтотОбъект, ДополнительныеПараметры);
		ОборудованиеПлатежныеСистемыКлиент.НачатьПолучениеПараметровКарты(ОписаниеОповещения, УникальныйИдентификатор);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ОплатитьЭлектроннымСертификатом(СледующаяОперация)
	
	ПараметрыОперации = ОборудованиеПлатежныеСистемыКлиентСервер.ПараметрыВыполненияЭквайринговойОперации();
	ПараметрыОперации.ТипТранзакции  = "PayElectronicCertificate";
	ПараметрыОперации.ИдентификаторКорзины = ИдентификаторКорзины;
	ПараметрыОперации.СуммаЭлектронногоСертификата = СуммаЭС;
	ПараметрыОперации.СуммаСобственныхСредств = СуммаПК;
	
	ПараметрыОперации.Вставить("СледующаяОперация", СледующаяОперация);
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ВыполнитьОперациюЭТЗавершение", ЭтотОбъект, ПараметрыОперации);
	ОборудованиеПлатежныеСистемыКлиент.НачатьВыполнениеОперацииНаЭквайринговомТерминале(
		ОписаниеОповещения,
		УникальныйИдентификатор,
		Неопределено,
		ПараметрыОперации,
		Неопределено,
		Неопределено);
	
КонецПроцедуры

&НаКлиенте
Процедура ВернутьЭлектронныйСертификат(СледующаяОперация)
	
	ПараметрыОперации = ОборудованиеПлатежныеСистемыКлиентСервер.ПараметрыВыполненияЭквайринговойОперации();
	ПараметрыОперации.ТипТранзакции  = "ReturnElectronicCertificate";
	ПараметрыОперации.ИдентификаторКорзины = ИдентификаторКорзины;
	ПараметрыОперации.СуммаЭлектронногоСертификата = СуммаЭС;
	ПараметрыОперации.СуммаСобственныхСредств = СуммаПК;
	
	ПараметрыОперации.Вставить("СледующаяОперация", СледующаяОперация);
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ВыполнитьОперациюЭТЗавершение", ЭтотОбъект, ПараметрыОперации);
	ОборудованиеПлатежныеСистемыКлиент.НачатьВыполнениеОперацииНаЭквайринговомТерминале(
		ОписаниеОповещения,
		УникальныйИдентификатор,
		Неопределено,
		ПараметрыОперации,
		Неопределено,
		Неопределено);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ПроверитьСуммы()
	
	ОплатаДоступна = СуммаЧека = СуммаНаличные + СуммаПК + СуммаЭС - Сдача;
	
	Элементы.Оплатить.Доступность = ОплатаДоступна;
КонецПроцедуры

&НаКлиенте
Процедура ОплатитьВернутьЭСНСПКНЗавершение(ДополнительныеПараметры)
	
	ДополнительныеПараметры.Вставить("Результат", Истина);
	ДополнительныеПараметры.Вставить("Наличными", СуммаНаличные);
	ДополнительныеПараметры.Вставить("Сдача", Сдача);
	
	Закрыть(ДополнительныеПараметры);
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьОперациюЭТЗавершение(РезультатВыполнения, ДополнительныеПараметры = Неопределено) Экспорт
	
	Если РезультатВыполнения.Результат Тогда
		Если РезультатВыполнения.Свойство("ХешНомерКарты") Тогда
			ХешНомерКарты = РезультатВыполнения.ХешНомерКарты;
		КонецЕсли;
		Если РезультатВыполнения.Свойство("НомерКарты") Тогда
			НомерКарты = РезультатВыполнения.НомерКарты;
		КонецЕсли;
		Если НЕ ДополнительныеПараметры = Неопределено И ДополнительныеПараметры.Свойство("СледующаяОперация") Тогда
			Если ДополнительныеПараметры.СледующаяОперация = "ПредварительноеОдобрениеИспользования" Тогда
				СогласоватьЭСНСПКНаСервере(ДополнительныеПараметры.ТоварныеПозиции, ХешНомерКарты);
			ИначеЕсли ДополнительныеПараметры.СледующаяОперация = "ПредварительноеОдобрениеВозврата" Тогда
				СогласоватьВозвратЭСНСПКНаСервере(ДополнительныеПараметры.ТоварныеПозиции, ХешНомерКарты);
			Иначе
				ДополнительныеПараметры.Вставить("ИдентификаторУстройства", РезультатВыполнения.ИдентификаторУстройства);
				ДополнительныеПараметры.Вставить("НомерКарты", РезультатВыполнения.НомерКарты);
				ДополнительныеПараметры.Вставить("НомерЧекаЭТ", РезультатВыполнения.НомерЧекаЭТ);
				ДополнительныеПараметры.Вставить("СсылочныйНомер", РезультатВыполнения.СсылочныйНомер);
				ОплатитьВернутьЭСНСПКНЗавершение(ДополнительныеПараметры);
			КонецЕсли;
		КонецЕсли;
	Иначе
		ТекстСообщения = РезультатВыполнения.ОписаниеОшибки;
		ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура СогласоватьЭСНСПКНаСервере(ТоварныеПозиции, ХешНомерКарты)
	
	ПараметрыОперации = ЭлектронныеСертификатыНСПКРТ.ПараметрыОперацииНСПКПоКассеККМ(КассаККМ);
	
	ПараметрыОперации.ХешНомерКарты = ХешНомерКарты;
	ПараметрыОперации.ТоварныеПозиции = ТоварныеПозиции;
	
	ПредварительноеОдобрениеПолучено = Ложь;
	РезультатВыполнения = ЭлектронныеСертификатыНСПК.ПредварительноеОдобрениеИспользования(ПараметрыОперации);
	
	Если РезультатВыполнения.Результат Тогда
		ПредварительноеОдобрениеПолучено = Истина;
	КонецЕсли;
	ОбработатьРезультатНаСервере(РезультатВыполнения);
КонецПроцедуры

&НаСервере
Процедура СогласоватьВозвратЭСНСПКНаСервере(ТоварныеПозиции, ХешНомерКарты)
	
	ПараметрыОперации = ЭлектронныеСертификатыНСПКРТ.ПараметрыОперацииНСПКПоКассеККМ(КассаККМ, ИдентификаторКорзины);
	
	РезультатВыполнения = ЭлектронныеСертификатыНСПК.ПолучениеСоставаКорзины(ПараметрыОперации);
	РезультатВыполнения.Вставить("ПредыдущаяПокупка", Истина);
	
	ОбработатьРезультатНаСервере(РезультатВыполнения);
	
	РезультатВыполнения.Удалить("ПредыдущаяПокупка");
	
	Если НЕ РезультатВыполнения.Результат Тогда
		Возврат;
	КонецЕсли;
	
	// Удаление строк, которых не было в оригинальной продаже ЭС.
	СтрокиНеИзВозврата = ТоварыФСС.НайтиСтроки(Новый Структура("НомерПозицииВозврата", 999));
	
	Для каждого СтрокаНеИзВозврата Из СтрокиНеИзВозврата Цикл
		КоличествоТоварныхПозиций = ТоварныеПозиции.Количество();
		Для Индекс = 1 По КоличествоТоварныхПозиций Цикл
			СтрокаТовара = ТоварныеПозиции[КоличествоТоварныхПозиций - Индекс];
			Если СтрокаТовара.Артикул = СтрокаНеИзВозврата.Артикул Тогда
				ТоварныеПозиции.Удалить(КоличествоТоварныхПозиций - Индекс);
			КонецЕсли;
		КонецЦикла;
	КонецЦикла;
	
	// Заполнение номера позиции в оригинальной продаже ЭС.
	Для каждого СтрокаПодтверждения Из ТоварныеПозиции Цикл
		СтрокаФСС = ТоварыФСС.НайтиПоИдентификатору(СтрокаПодтверждения.НомерПозиции);
		Если НЕ СтрокаФСС = Неопределено Тогда
			СтрокаПодтверждения.НомерПозицииВозврата = СтрокаФСС.НомерПозицииВозврата;
		КонецЕсли;
	КонецЦикла;
	
	ПараметрыОперации.ХешНомерКарты = ХешНомерКарты;
	ПараметрыОперации.ТоварныеПозиции = ТоварныеПозиции;
	
	ПредварительноеОдобрениеПолучено = Ложь;
	РезультатВыполнения = ЭлектронныеСертификатыНСПК.ПредварительноеОдобрениеВозврата(ПараметрыОперации);
	Если РезультатВыполнения.Результат Тогда
		ПредварительноеОдобрениеПолучено = Истина;
	КонецЕсли;
	
	ОбработатьРезультатНаСервере(РезультатВыполнения);
КонецПроцедуры

&НаСервере
Процедура ОбработатьРезультатНаСервере(РезультатВыполнения);
	
	Если РезультатВыполнения.Результат Тогда
		
		Если РезультатВыполнения.Свойство("ИдентификаторКорзины") И НЕ ПустаяСтрока(РезультатВыполнения.ИдентификаторКорзины) Тогда
			ИдентификаторКорзины = РезультатВыполнения.ИдентификаторКорзины;
		КонецЕсли;
		Если РезультатВыполнения.Свойство("СуммаСертификатами") Тогда
			СуммаЭС = РезультатВыполнения.СуммаСертификатами;
			СуммаПК = СуммаЧека - СуммаЭС;
		КонецЕсли;
		
		Если РезультатВыполнения.Свойство("ТоварныеПозиции") И РезультатВыполнения.ТоварныеПозиции.Количество() > 0 Тогда
			Для Каждого ТоварнаяПозиция Из РезультатВыполнения.ТоварныеПозиции Цикл
				
				СтрокаТовара = Неопределено;
				
				Если РезультатВыполнения.Свойство("ПредыдущаяПокупка") Тогда
					СтрокиТоваров = ТоварыФСС.НайтиСтроки(Новый Структура("Артикул", ТоварнаяПозиция.Артикул));
					Если СтрокиТоваров.Количество()>0 Тогда
						СтрокаТовара = СтрокиТоваров[0];
					КонецЕсли;
				Иначе
					СтрокаТовара = ТоварыФСС.НайтиПоИдентификатору(ТоварнаяПозиция.НомерПозиции);
				КонецЕсли;
				
				Если СтрокаТовара = Неопределено Тогда
					Продолжить;
				КонецЕсли;
				
				Если РезультатВыполнения.Свойство("ПредыдущаяПокупка") Тогда
					СтрокаТовара.НомерПозицииВозврата = ТоварнаяПозиция.НомерПозиции;
				КонецЕсли;
				
				СтрокаТовара.КоличествоФСС = ТоварнаяПозиция.Количество;
				СтрокаТовара.ЦенаФСС = ТоварнаяПозиция.Цена;
				СтрокаТовара.СуммаФСС = СтрокаТовара.КоличествоФСС*СтрокаТовара.ЦенаФСС;
				
				Если ТоварнаяПозиция.Свойство("Сертификаты") И ТоварнаяПозиция.Сертификаты.Количество() > 0 Тогда
					
					КоличествоПоСертификату = 0;
					СуммаПоСертификату = 0;
					МаксимальнаяЦена = 0;
					Для Каждого Сертификат Из ТоварнаяПозиция.Сертификаты Цикл
						СтрокаСертификата = СтрокаТовара.Сертификаты.Добавить();
						ЗаполнитьЗначенияСвойств(СтрокаСертификата, Сертификат);
						КоличествоПоСертификату = КоличествоПоСертификату + СтрокаСертификата.Количество;
						СуммаПоСертификату = СуммаПоСертификату + (СтрокаСертификата.Количество * СтрокаСертификата.Цена);
						МаксимальнаяЦена = Макс(МаксимальнаяЦена, СтрокаСертификата.МаксимальнаяЦена);
					КонецЦикла;
					
					СтрокаТовара.МаксимальнаяЦена = МаксимальнаяЦена;
					СтрокаТовара.КоличествоФСС = КоличествоПоСертификату;
					СтрокаТовара.СуммаФСС = СуммаПоСертификату;
					СтрокаТовара.ЦенаФСС =
						?(КоличествоПоСертификату = 0, СуммаПоСертификату, Окр(СуммаПоСертификату/КоличествоПоСертификату, 2));
				
				КонецЕсли;
			КонецЦикла;
		КонецЕсли;
		ВывестиПредварительноеОдобрениеНаПечать();
		УстановитьЗаголовкиОплаты(ЭтотОбъект);
	Иначе
		ОписаниеОшибки =
			СтрШаблон(НСтр("ru='Ошибка: (%1) %2'"), РезультатВыполнения.КодРезультата, РезультатВыполнения.ОписаниеОшибки); 
		ОбщегоНазначения.СообщитьПользователю(ОписаниеОшибки);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ВывестиПредварительноеОдобрениеНаПечать()
	
	Таб = Новый ТабличныйДокумент();
	
	Макет = ПолучитьОбщийМакет("ПФ_MXL_ДанныеПроверкиТоваровФСС");
	
	ОбластьЗаголовок = Макет.ПолучитьОбласть("Заголовок");
	
	Если ЭтоВозврат Тогда
		ЗаголовокТаблицы = НСтр("ru = 'Товары к возврату на электронный сертификат НСПК'");
	Иначе
		ЗаголовокТаблицы = НСтр("ru = 'Товары к оплате электронным сертификатом НСПК'");
	КонецЕсли;
	
	УстановитьПараметр(ОбластьЗаголовок, "ЗаголовокТаблицы", ЗаголовокТаблицы);
	
	Таб.Вывести(ОбластьЗаголовок);
	
	ОбластьШапка = Макет.ПолучитьОбласть("Шапка");
	Таб.Вывести(ОбластьШапка);
	
	СуммаЧекФСС = 0;
	
	Для Каждого СтрокаТоваров Из ТоварыФСС Цикл
		
		ОбластьДанныхСтроки = Макет.ПолучитьОбласть("Строка");
		УстановитьПараметр(
			ОбластьДанныхСтроки,
			"Наименование",
			СтрШаблон("%1, %2", СтрокаТоваров.Артикул, СокрЛП(СтрокаТоваров.Номенклатура)));
		ОбластьДанныхСтроки.Параметры.Заполнить(СтрокаТоваров);
		Таб.Вывести(ОбластьДанныхСтроки);
		
		СуммаЧекФСС = СуммаЧекФСС + СтрокаТоваров.Сумма;
	КонецЦикла;
	
	ОбластПодвалФСС = Макет.ПолучитьОбласть("ПодвалФСС");
	УстановитьПараметр(ОбластПодвалФСС, "Сумма", СуммаЧекФСС);
	УстановитьПараметр(ОбластПодвалФСС, "СуммаФСС", СуммаЭС);
	Таб.Вывести(ОбластПодвалФСС);
	
	Если НЕ ЭтоВозврат Тогда
		
		ОбластПрочиеТовары = Макет.ПолучитьОбласть("ПрочиеТовары");
		УстановитьПараметр(ОбластПрочиеТовары, "Сумма", СуммаЧека - СуммаЧекФСС);
		Таб.Вывести(ОбластПрочиеТовары);
		
		ОбластПодвал = Макет.ПолучитьОбласть("Подвал");
		УстановитьПараметр(ОбластПодвал, "Сумма", СуммаЧека);
		Таб.Вывести(ОбластПодвал);
	КонецЕсли;
	
	ТабличныйДокумент.Очистить();
	ТабличныйДокумент = Таб;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьЗаголовкиОплаты(Форма)
	
	Если Форма.ПредварительноеОдобрениеПолучено Тогда
		Если Форма.ЭтоВозврат Тогда
			ЗаголовокОплаты = НСтр("ru = 'Вернуть'");
			ТекстПодсказки = НСтр("ru = 'Возврат электронного сертификата должен производиться на карту, к которой приписываются электронные сертификаты покупателя.'");
		Иначе
			ЗаголовокОплаты = НСтр("ru = 'Оплатить'");
			ТекстПодсказки = НСтр("ru = 'Доплата к электронному сертификату может производиться собственными средствами с той же карты,"
				"а также наличными.'");
		КонецЕсли;
	Иначе
		ЗаголовокОплаты = НСтр("ru = 'Проверить'");
		Если Форма.ЭтоВозврат Тогда
			ТекстПодсказки = НСтр("ru = 'Перед возвратом необходимо проверить доступную сумму к возврату ЭС НСПК.'");
		Иначе
			ТекстПодсказки = НСтр("ru = 'Перед оплатой необходимо проверить доступную сумму к оплате ЭС НСПК.'");
		КонецЕсли;
	КонецЕсли;
	Форма.Элементы.Оплатить.Заголовок = ЗаголовокОплаты;
	Форма.Элементы.ГруппаСуммы.РасширеннаяПодсказка.Заголовок = ТекстПодсказки;
КонецПроцедуры

&НаСервереБезКонтекста
Процедура УстановитьПараметр(ОбластьМакета, ИмяПараметра, ЗначениеПараметра)
	
	ОбластьМакета.Параметры.Заполнить(Новый Структура(ИмяПараметра, ЗначениеПараметра));
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПроверитьВозможностьОплатыНСПКНаСервере(КассаККМ)
	
	ЧастиФорматированнойСтроки = Новый Массив;
	
	АдресМагазина = УправлениеКонтактнойИнформацией.КонтактнаяИнформацияОбъекта(
		КассаККМ.Магазин, Справочники.ВидыКонтактнойИнформации.ФактАдресМагазина, ТекущаяДатаСеанса(), Ложь);
	Если Не ЗначениеЗаполнено(АдресМагазина) Тогда
			ЧастиФорматированнойСтроки.Добавить(Новый ФорматированнаяСтрока(НСтр("ru = 'Необходимо указать адрес '")));
			ЧастиФорматированнойСтроки.Добавить(Новый ФорматированнаяСтрока(НСтр("ru = 'магазина.'"),,,, ПолучитьНавигационнуюСсылку(КассаККМ.Магазин)));
			ЧастиФорматированнойСтроки.Добавить(Символы.ПС);
	КонецЕсли;
	
	ТаблицаЭквайринговыхТерминалов = ПолучитьТаблицуЭквайринговыхТерминаловДляПроверки(КассаККМ);
	
	ПлатежнаяКартаНСПК = ЭлектронныеСертификатыНСПКРТ.ВидОплатыПлатежнаяКартаНСПК();
	ПлатежнаяСистемаНСПК = ЭлектронныеСертификатыНСПКРТ.ВидОплатыПлатежнаяСистемаНСПК();
	
	Если Не ЗначениеЗаполнено(ТаблицаЭквайринговыхТерминалов) Тогда
		ЧастиФорматированнойСтроки.Добавить(Новый ФорматированнаяСтрока(НСтр("ru = 'Для указанной '")));
		ЧастиФорматированнойСтроки.Добавить(Новый ФорматированнаяСтрока(НСтр("ru = 'кассы ККМ'"),,,, ПолучитьНавигационнуюСсылку(КассаККМ)));
		ЧастиФорматированнойСтроки.Добавить(Новый ФорматированнаяСтрока(НСтр("ru = ' необходимо создать эквайринговый терминал'")));
		ЧастиФорматированнойСтроки.Добавить(Символы.ПС);
		Возврат Новый ФорматированнаяСтрока(ЧастиФорматированнойСтроки);
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(ПлатежнаяКартаНСПК) Тогда
		ЧастиФорматированнойСтроки.Добавить(Новый ФорматированнаяСтрока(НСтр("ru = 'Необходимо создать '")));
		ЧастиФорматированнойСтроки.Добавить(Новый ФорматированнаяСтрока(НСтр("ru = 'вид оплаты'"),,,, НСтр("ru='e1cib/list/Справочник.ВидыОплатЧекаККМ'")));
		ЧастиФорматированнойСтроки.Добавить(Новый ФорматированнаяСтрока(НСтр("ru = ' Платежная карта НСПК'")));
		ЧастиФорматированнойСтроки.Добавить(Символы.ПС);
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(ПлатежнаяСистемаНСПК) Тогда
		ЧастиФорматированнойСтроки.Добавить(Новый ФорматированнаяСтрока(НСтр("ru = 'Необходимо создать '")));
		ЧастиФорматированнойСтроки.Добавить(Новый ФорматированнаяСтрока(НСтр("ru = 'вид оплаты'"),,,, НСтр("ru='e1cib/list/Справочник.ВидыОплатЧекаККМ'")));
		ЧастиФорматированнойСтроки.Добавить(Новый ФорматированнаяСтрока(НСтр("ru = ' Платежная система НСПК'")));
		ЧастиФорматированнойСтроки.Добавить(Символы.ПС);
	КонецЕсли;

	Если ЗначениеЗаполнено(ПлатежнаяКартаНСПК) И ЗначениеЗаполнено(ПлатежнаяСистемаНСПК) Тогда
		СтруктураОтбора = Новый Структура("ВидОплаты", ПлатежнаяКартаНСПК);
		НайденныеСтрокиПлатежнаяКарта = ТаблицаЭквайринговыхТерминалов.НайтиСтроки(СтруктураОтбора);
		Если НайденныеСтрокиПлатежнаяКарта.Количество() = 0 Тогда
			ЧастиФорматированнойСтроки.Добавить(Новый ФорматированнаяСтрока(НСтр("ru = 'В доступные виды оплаты эквайрингового терминала'")));
			ЧастиФорматированнойСтроки.Добавить(Новый ФорматированнаяСтрока(НСтр("ru = ' необходимо добавить вид оплаты Платежная карта НСПК'")));
			ЧастиФорматированнойСтроки.Добавить(Символы.ПС);
		Иначе
			ЕстьНастроенныйТерминал = Ложь;
			Для Каждого ТерминалСПлатежнойКартойНСПК ИЗ НайденныеСтрокиПлатежнаяКарта Цикл
				СтруктураОтбора = Новый Структура("ЭквайринговыйТерминал, ВидОплаты", ТерминалСПлатежнойКартойНСПК.ЭквайринговыйТерминал, ПлатежнаяСистемаНСПК);
				НайденныеСтроки = ТаблицаЭквайринговыхТерминалов.НайтиСтроки(СтруктураОтбора);
				Если НЕ НайденныеСтроки.Количество() = 0 Тогда
					ЕстьНастроенныйТерминал = Истина;
				КонецЕсли;
			КонецЦикла;
			Если Не ЕстьНастроенныйТерминал Тогда
				ЧастиФорматированнойСтроки.Добавить(Новый ФорматированнаяСтрока(НСтр("ru = 'В доступные виды оплаты эквайрингового терминала'")));
				ЧастиФорматированнойСтроки.Добавить(Новый ФорматированнаяСтрока(НСтр("ru = ' необходимо добавить вид оплаты Платежная система НСПК'")));
				ЧастиФорматированнойСтроки.Добавить(Символы.ПС);
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
	Возврат Новый ФорматированнаяСтрока(ЧастиФорматированнойСтроки);
	
КонецФункции

&НаСервереБезКонтекста
Функция ПолучитьТаблицуЭквайринговыхТерминаловДляПроверки(КассаККМ)
	
	ТекстЗапроса = 
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ЭквайринговыеТерминалы.Ссылка КАК ЭквайринговыйТерминал,
	|	ЭквайринговыеТерминалы.ВидОплаты КАК ВидОплаты
	|ИЗ
	|	Справочник.ЭквайринговыеТерминалы.ТарифыЗаРасчетноеОбслуживание КАК ЭквайринговыеТерминалы
	|ГДЕ
	|	НЕ ЭквайринговыеТерминалы.Ссылка.ПометкаУдаления
	|	И ЭквайринговыеТерминалы.Ссылка.Касса = &Касса
	|	И НЕ ЭквайринговыеТерминалы.Ссылка.НеДействителен
	|	И ЭквайринговыеТерминалы.Ссылка.ИспользоватьБезПодключенияОборудования = ЛОЖЬ";
	
	Запрос = Новый Запрос(ТекстЗапроса);
	Запрос.УстановитьПараметр("Касса", КассаККМ);
	Результат = Запрос.Выполнить().Выгрузить();
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти






