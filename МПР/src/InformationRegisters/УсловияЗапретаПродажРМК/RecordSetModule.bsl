#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Для каждого Запись Из ЭтотОбъект Цикл
	
		Если Запись.Активность
			И ПустаяСтрока(Запись.ИмяЗапрещающегоДокументаМастерСистемы) Тогда
				ПроверяемыеРеквизиты.Добавить("Организация");
		КонецЕсли;
	
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли