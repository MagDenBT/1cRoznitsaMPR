#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		
		Возврат;
		
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#КонецЕсли