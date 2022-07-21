////////////////////////////////////////////////////////////////////////////////
// КопированиеСтрокКлиент содержит процедуры и функции 
// для работы с копированием строк.
//  
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Проверяет заполненность реквизитов, необходимых для копирования
//
// Параметры:
//  ТекущаяСтрока - ДанныеФормыЭлементКоллекции  - Элемент табличной части, которую надо проверить на заполненность
//
// Возвращаемое значение:
//  Булево - Ложь, если необходимые данные не заполнены.
//
Функция ВозможноКопированиеСтрок(ТекущаяСтрока) Экспорт
	
	Если ТекущаяСтрока = Неопределено Тогда
		ТекстСообщения = НСтр("ru = 'Для выполнения команды требуется выбрать строку табличной части.'");
		ПоказатьПредупреждение(,ТекстСообщения);
		Возврат Ложь;
	КонецЕсли;
	
	Возврат Истина;
	
КонецФункции

// Вызывается в формах документов и справочников при копировании строк.
// 
// Параметры:
//  КоличествоВыделенных - Число - количество выделенных строк табличной части.
//
Процедура ОповеститьПользователяОКопированииСтрок(КоличествоВыделенных) Экспорт
	
	ТекстСообщения = НСтр("ru='В буфер обмена скопировано строк (%КоличествоВыделенных%)'");
	ТекстСообщения = СтрЗаменить(ТекстСообщения, "%КоличествоВыделенных%", КоличествоВыделенных);
	
	ТекстЗаголовка = НСтр("ru='Строки скопированы'");
	ПоказатьОповещениеПользователя(ТекстЗаголовка,, ТекстСообщения, БиблиотекаКартинок.Информация32);
	Оповестить("КопированиеСтрокВБуферОбмена");
	
КонецПроцедуры

// Вызывается в формах документов и справочников при вставке строк.
// 
// Параметры:
//  КоличествоВставленных - Число - количество вставленных строк в табличную часть.
//
Процедура ОповеститьПользователяОВставкеСтрок(КоличествоВставленных) Экспорт
	
	ТекстСообщения = НСтр("ru='Из буфера обмена вставлено строк (%КоличествоВставленных%)'");
	ТекстСообщения = СтрЗаменить(ТекстСообщения, "%КоличествоВставленных%", КоличествоВставленных);
	
	ТекстЗаголовка = НСтр("ru='Строки вставлены'");
	ПоказатьОповещениеПользователя(ТекстЗаголовка,, ТекстСообщения, БиблиотекаКартинок.Информация32);
	Оповестить("ВставкаСтрокИзБуфераОбмена");
	
КонецПроцедуры

#КонецОбласти
