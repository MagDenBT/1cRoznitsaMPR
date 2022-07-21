#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ИдентификаторОбращения = Параметры.ИдентификаторОбращения;
	Если Параметры.Свойство("КодПользователя") 
		И ЗначениеЗаполнено(Параметры.КодПользователя) Тогда
		КодПользователя = Параметры.КодПользователя;
	Иначе
		КодПользователя = ИнформационныйЦентрСервер.КодПользователяДляДоступа();
	КонецЕсли;
	ЗаполнитьНепросмотренныеВзаимодействия();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура НепросмотренныеВзаимодействияВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ТекущиеДанные = Элемент.ТекущиеДанные;
	ИнформационныйЦентрКлиент.ОткрытьВзаимодействиеВСлужбуПоддержки(
		ИдентификаторОбращения, ТекущиеДанные.Идентификатор, ТекущиеДанные.Тип, ТекущиеДанные.Входящее, Ложь, КодПользователя);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ЗаполнитьНепросмотренныеВзаимодействия()
	
	Для Каждого ЭлементСписка Из Параметры.СписокНеПросмотренныхВзаимодействий Цикл
		 
		НепросмотренноеВзаимодействие = ЭлементСписка.Значение;
		НоваяСтрокаТЗ = НепросмотренныеВзаимодействия.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрокаТЗ, НепросмотренноеВзаимодействие);
		НоваяСтрокаТЗ.НомерКартинки = 
			ИнформационныйЦентрСервер.НомерКартинкиПоВзаимодействию(НоваяСтрокаТЗ.Тип, НоваяСтрокаТЗ.Входящее);
		НоваяСтрокаТЗ.ПояснениеККартинке = ?(НоваяСтрокаТЗ.Входящее, НСтр("ru = 'Вх.'"), НСтр("ru = 'Исх.'"));
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

