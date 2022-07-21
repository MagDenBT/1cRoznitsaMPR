#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Если Не ЭтотУзел И Не ЗначениеЗаполнено(Пользователь)
		И Не ЗначениеЗаполнено(ГруппаПользователей) Тогда
		ПроверяемыеРеквизиты.Добавить("Пользователь");
	КонецЕсли;
	МассивНепроверяемыхРеквизитов = Новый Массив;
	ДобавитьНепроверяемыеРеквизитыВМассив(МассивНепроверяемыхРеквизитов);
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ГруппаПользователей)
		И ГруппаПользователей.Состав.Количество() = 0 Тогда
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'В группе пользователей ""%1"" отсутствуют участники'"), ГруппаПользователей);
		Поле = "ГруппаПользователей";
		ОбщегоНазначения.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, Поле,, Отказ);
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Код) Тогда
		Код = СокрЛП(Новый УникальныйИдентификатор);
	КонецЕсли;
	
	Если НЕ ЭтотУзел Тогда
		
		ПрефиксИспользуется = УправлениеМобильнымиПриложениями.ПроверитьПрефиксДляДанныхМобильногоУстройства(
			Ссылка, ПрефиксДляДанныхМобильногоУстройства);
		
		Если ПрефиксИспользуется Тогда
			ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Префикс ""%1"" уже используется'"), ПрефиксДляДанныхМобильногоУстройства);
			Поле = "ПрефиксДляДанныхМобильногоУстройства";
			ОбщегоНазначения.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, Поле,, Отказ);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	Код = "";
	Наименование = "";
	ПрефиксДляДанныхМобильногоУстройства = "";

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ДобавитьНепроверяемыеРеквизитыВМассив(МассивНепроверяемыхРеквизитов)
	
	МассивНепроверяемыхРеквизитов.Добавить("Код");
	
	Если Ссылка = ПланыОбмена.ОбменСМобильнымиПриложениями.ЭтотУзел() Тогда
		МассивНепроверяемыхРеквизитов.Добавить("МобильноеПриложение");
		МассивНепроверяемыхРеквизитов.Добавить("ПрефиксДляДанныхМобильногоУстройства");
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли

