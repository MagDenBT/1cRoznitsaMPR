#Область ПрограммныйИнтерфейс

// Заполнияет серии для выбранного подарка при продаже.
//
// Параметры:
//  ИдентификаторСтроки - Число.
//  СтруктураЗаполнения - Структура.
//  Объект - ДанныеФормаКоллекция.
//
Процедура ДополнитьСерииПодаркаИзСписка(ИдентификаторСтроки, СтруктураЗаполнения, Знач Объект) Экспорт
	
	РозничныеПродажиСервер.ДополнитьСерииПодаркаИзСписка(ИдентификаторСтроки, СтруктураЗаполнения, Объект);
	
КонецПроцедуры

// Получает кнопки верхней панели для текущей настройки РМК.
// 
// Параметры:
//  НастройкаРМК - СправочникСсылка.НастройкиРМК.
//  МассивКнопок - Массив.
//
Процедура ПолучитьКнопкиВерхнейПанели(НастройкаРМК, МассивКнопок) Экспорт 
	
	РозничныеПродажиСервер.ПолучитьКнопкиВерхнейПанели(НастройкаРМК, МассивКнопок);
	
КонецПроцедуры

// Функция определяет физическое лицо пользователя, к которому 
// привязана регистрационная карта.
// 
// Параметры:
//  ВладелецКарты - СправочникСсылка.Пользователи.
//
// Возвращаемое значение:
//  ФизЛицо - СправочникСсылка.ФизическиеЛица.
//
Функция ФизЛицоВладельцаКарты(ВладелецКарты) Экспорт 
	
	Возврат РозничныеПродажиСервер.ФизЛицоВладельцаКарты(ВладелецКарты);
	
КонецФункции

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

#Область ЗаполнениеПоЧекамККМ

Процедура ВыполнитьЗаполнениеПоЧекамККМ(МассивДокументов) Экспорт

	РозничныеПродажиСервер.ВыполнитьЗаполнениеПоЧекамККМ(МассивДокументов);
	
КонецПроцедуры 

#КонецОбласти

Функция КассаФискализацииРаспределяемойНоменклатуры(Магазин, РабочееМесто, Номенклатура) Экспорт
	Возврат РозничныеПродажиСервер.КассаФискализацииРаспределяемойНоменклатуры(Магазин, РабочееМесто, Номенклатура);
КонецФункции

#КонецОбласти

