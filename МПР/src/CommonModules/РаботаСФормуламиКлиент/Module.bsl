////////////////////////////////////////////////////////////////////////////////
// РаботаСФормуламиКлиент содержит процедуры и функции для работы 
// с формулами и обработки действий пользователя с формулами.
//  
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Выполняет проверку формулы
// и выдает соответствующее сообщение пользователю.
//
// Параметры:
//  Формула - Строка - формула для проверки строкой.
//  Операнды - Массив - массив операндов для вставки в формулу.
// 
Процедура ПроверитьФормулуИнтерактивно(Формула, Операнды, Знач Поле) Экспорт
	
	Если ЗначениеЗаполнено(Формула) Тогда
		Если РаботаСФормуламиКлиентСервер.ПроверитьФормулу(Формула, Операнды, Поле) Тогда
			
			ПоказатьОповещениеПользователя(
				НСтр("ru = 'В формуле ошибок не обнаружено'"),
				,
				,
				БиблиотекаКартинок.Информация32);
			
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры // ПроверитьФормулуИнтерактивно()
	
#КонецОбласти
