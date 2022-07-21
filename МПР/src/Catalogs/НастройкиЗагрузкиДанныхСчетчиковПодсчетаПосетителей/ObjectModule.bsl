#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)

	Если НЕ ИспользоватьНестандартныйАлгоритм Тогда
		
		ВнешняяОбработкаНастройки = ПроверяемыеРеквизиты.Найти("ВнешняяОбработка");
		Если НЕ ВнешняяОбработкаНастройки = Неопределено Тогда
			ПроверяемыеРеквизиты.Удалить(ВнешняяОбработкаНастройки);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	РегламентноеЗаданиеGUID = "";
	ИспользоватьРегламентноеЗадание = Ложь;
КонецПроцедуры

#КонецОбласти

#КонецЕсли
