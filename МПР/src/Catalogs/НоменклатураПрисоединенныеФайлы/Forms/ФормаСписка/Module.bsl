#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	ВызватьИсключение НСтр("ru = 'Самостоятельное использование формы не предусмотрено.'");
	
КонецПроцедуры

#КонецОбласти