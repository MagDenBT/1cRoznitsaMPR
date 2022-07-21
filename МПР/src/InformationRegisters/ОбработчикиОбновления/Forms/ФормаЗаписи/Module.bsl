///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2022, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Заголовок = НСтр("ru = 'Обработчик обновления'") + " " + Запись.ИмяОбработчика;
	
	Если ЗначениеЗаполнено(Запись.Комментарий) Тогда
		Элементы.ГруппаКомментарий.Заголовок = НСтр("ru = 'Комментарий'") + " *";
	Иначе
		Элементы.ГруппаКомментарий.Заголовок = НСтр("ru = 'Комментарий'");
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Запись.ИнформацияОбОшибке) Тогда
		Элементы.ГруппаИнформацияОбОшибке.Заголовок = НСтр("ru = 'Информация об ошибке'") + " *";
	Иначе
		Элементы.ГруппаИнформацияОбОшибке.Заголовок = НСтр("ru = 'Информация об ошибке'");
	КонецЕсли;
	
	ОбрабатываемыеДанные = НСтр("ru = 'Открыть'");
	
	Данные = РеквизитФормыВЗначение("Запись").ОбрабатываемыеДанные;
	ОбрабатываемыеДанныеХранилище = ПоместитьВоВременноеХранилище(Данные, УникальныйИдентификатор);
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	Оповестить("Запись_ОбработчикиОбновления", ПараметрыЗаписи);
КонецПроцедуры

#КонецОбласти
