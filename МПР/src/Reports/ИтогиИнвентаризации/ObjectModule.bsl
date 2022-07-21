#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПриКомпоновкеРезультата(ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка)
	
	ОбщегоНазначенияРТКлиентСервер.УстановитьПараметр(КомпоновщикНастроек.Настройки, "ИспользоватьПрименениеЦен", ПолучитьФункциональнуюОпцию("ИспользоватьПрименениеЦен"));
	
	АссортиментСервер.ПроверитьНеобходимостьПереопределенияИВывестиОтчет(ЭтотОбъект, ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка);
	
	ОбщегоНазначенияРТ.ВывестиДатуФормированияОтчета(ДокументРезультат);
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
