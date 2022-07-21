
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	СсылкаНаДоверенность = Параметры.Ключ;
	ПолеПросмотра = МашиночитаемыеДоверенности.ЗаполнитьТабличныйДокументМЧД(СсылкаНаДоверенность, Отказ);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОткрытьФормуЭлемента(Команда)
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Ключ", СсылкаНаДоверенность);
	ОткрытьФорму("Справочник.МашиночитаемыеДоверенностиОрганизаций.Форма.ФормаЭлемента", ПараметрыФормы, , , , , , 
		РежимОткрытияОкнаФормы.Независимый);
		
КонецПроцедуры

&НаКлиенте
Процедура Отозвать(Команда)
	
	МашиночитаемыеДоверенностиКлиент.ОтменитьМЧД( ,СсылкаНаДоверенность);

КонецПроцедуры

#КонецОбласти