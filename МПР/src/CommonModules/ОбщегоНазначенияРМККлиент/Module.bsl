
///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2022, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

#Область Запреты_продаж_ПрограммныйИнтерфейс

// Проверяет наличие актуальных запретов продажи по данным кэша запретов 
//
// Параметры:
//  ВидНоменклатуры - СправочникСсылка.ВидНоменклатуры - вид номенклатуры, по  которому
//	проверяется наличие запрета продаж на текущий момент;
//  ОсобенностьУчетаНоменклатуры - ПеречислениеСсылка.ОсобенностиУчетаНоменклатуры - особенность учета, по которой
//		проверяется наличие запрета продаж на текущий момент;
//  КэшЗапретов - ДанныеФормыКоллекция - перечень действующих запретов продаж на текущий момент
//
// Возвращаемое значение:
//  Результат - Структура, либо пустая, либо содержащая запреты продаж:
//		*ВремяНачалаЗапрета - Число - секунды, прошедшие с начала даты начала запрета
//		*ВремяОкончанияЗапрета - Число  - секунды, прошедшие с начала даты окончания запрета
//		*ВидНоменклатуры - СправочникСсылка.ВидыНоменклатуры - категория, к которой относится запрет.
//
Функция НаличиеЗапретовПродажи(ВидНоменклатуры, ОсобенностьУчетаНоменклатуры, КэшЗапретовПродаж) Экспорт
	
	Результат = Новый Структура();
	
		ПустаяОсобенностьУчета = ОбщегоНазначенияРМККлиентПереопределяемый.ПустаяСсылкаНаОсобенностьУчетаНоменклатуры();
		ПустойВидНоменклатуры = ОбщегоНазначенияРМККлиентПереопределяемый.ПустаяСсылкаНаВидНоменклатуры();
			
		ДанныеОтбора = Новый Структура();
		ДанныеОтбора.Вставить("ОсобенностьУчета", ОсобенностьУчетаНоменклатуры);
		ДанныеОтбора.Вставить("ВидНоменклатуры", ВидНоменклатуры);
			
		НайденныеЗапреты = КэшЗапретовПродаж.НайтиСтроки(ДанныеОтбора);
		// детализированные запреты: особенность учета и вид номенклатуры
		Если НайденныеЗапреты.Количество() > 0 Тогда
			
			ДействующиеЗапреты =
				ОбщегоНазначенияРМККлиентСервер.УсловияЗапретаПродажиТовара(НайденныеЗапреты, ВидНоменклатуры);
				
			Если ДействующиеЗапреты.Количество() Тогда
				Возврат ДействующиеЗапреты;
			КонецЕсли;
			
		// обобщенные запреты: для всех особенностей учета и указанного вида номенклатуры
		Иначе
				
				ДанныеОтбора.Вставить("ОсобенностьУчета", ПустаяОсобенностьУчета);
				ДанныеОтбора.Вставить("ВидНоменклатуры", ВидНоменклатуры);
				
				НайденныеЗапреты = КэшЗапретовПродаж.НайтиСтроки(ДанныеОтбора);
				
				Если НайденныеЗапреты.Количество() > 0 Тогда
					
					ДействующиеЗапреты =
						ОбщегоНазначенияРМККлиентСервер.УсловияЗапретаПродажиТовара(НайденныеЗапреты, ВидНоменклатуры);
					
					Если ДействующиеЗапреты.Количество() Тогда
						Возврат ДействующиеЗапреты;
					КонецЕсли;
					
				// обобщенные запреты: для всех видов номенклатуры и указанной особенности учета
				Иначе
					
					ДанныеОтбора.Вставить("ОсобенностьУчета", ОсобенностьУчетаНоменклатуры);
					ДанныеОтбора.Вставить("ВидНоменклатуры", ПустойВидНоменклатуры);
					
					НайденныеЗапреты = КэшЗапретовПродаж.НайтиСтроки(ДанныеОтбора);
					
					Если НайденныеЗапреты.Количество() > 0 Тогда
						
						ДействующиеЗапреты =
							ОбщегоНазначенияРМККлиентСервер.УсловияЗапретаПродажиТовара(НайденныеЗапреты, ВидНоменклатуры);
						
						Если ДействующиеЗапреты.Количество() Тогда
							Возврат ДействующиеЗапреты;
						КонецЕсли;
						
					// общие запреты: для всех видов номенклатуры и всех особенностей учета
					Иначе
						
						ДанныеОтбора.Вставить("ОсобенностьУчета", ПустаяОсобенностьУчета);
						ДанныеОтбора.Вставить("ВидНоменклатуры", ПустойВидНоменклатуры);
						
						НайденныеЗапреты = КэшЗапретовПродаж.НайтиСтроки(ДанныеОтбора);
						
						Если НайденныеЗапреты.Количество() > 0 Тогда
							
							ДействующиеЗапреты = ОбщегоНазначенияРМККлиентСервер.УсловияЗапретаПродажиТовара(НайденныеЗапреты, ВидНоменклатуры);
							
							Если ДействующиеЗапреты.Количество() Тогда
								Возврат ДействующиеЗапреты;
							КонецЕсли;
							
						КонецЕсли;
						
					КонецЕсли;
					
				КонецЕсли;
				
		КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

// Служит для отражения опосредованного влияния на значение признака использования запретов продаж
// средствами сервера лояльности
//
// Параметры:
//  НовоеЗначениеПризнака - Булево - измененное значение признака;
//  ДополнительныеПараметры - Структура - параметры оповщения
//
Процедура ОповеститьОбИзмененииПризнакаИспользованияПоставляемыхОграниченийПродаж(НовоеЗначениеПризнака,
	ДополнительныеПараметры = Неопределено) Экспорт

	ФормаНастройки = ПолучитьФорму("ОбщаяФорма.НастройкиРабочегоМестаКассира");
	ПараметрыОповещения = Новый Структура();
	ПараметрыОповещения.Вставить("ИспользоватьОграниченияПродаж", НовоеЗначениеПризнака);
	ПараметрыОповещения.Вставить("ДополнительныеПараметры", ДополнительныеПараметры);
	Оповестить("ИзмененПризнакИспользованияПоставляемыйОграниченийПродаж", ПараметрыОповещения);

КонецПроцедуры
	
#КонецОбласти

// Определяет необходимость запуска нового РМК (для поставки РМК, как библиотеки).
//
// Параметры:
//  ЗапуститьНовыйРМК - Булево
//
Процедура ОпределитьРежимЗапуска(ЗапуститьНовыйРМК) Экспорт
	ОбщегоНазначенияРМКВызовСервера.ОпределитьРежимЗапуска(ЗапуститьНовыйРМК);
КонецПроцедуры

Процедура ОткрытьНастройкиСинхронизацииДанных() Экспорт
	ОткрытьФорму("ОбщаяФорма.НастройкиСинхронизацииДанных");
КонецПроцедуры

// Процедура открывает рабочее место кассира.
//
Процедура ОткрытьРабочееМестоКассира() Экспорт
	
	ОбработчикОповещения = Новый ОписаниеОповещения("ОповещениеОткрытьРабочееМестоКассира", ЭтотОбъект);
	ОткрытьФорму("Обработка.РабочееМестоКассира.Форма.ФормаРМК", , , , , , ОбработчикОповещения);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ОповещениеОткрытьРабочееМестоКассира(РезультатОткрытияФормы, ДополнительныеПараметры) Экспорт
	
	Если РезультатОткрытияФормы = "ЗавершитьРаботуСистемы" Тогда
		ЗавершитьРаботуСистемы(Ложь);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти