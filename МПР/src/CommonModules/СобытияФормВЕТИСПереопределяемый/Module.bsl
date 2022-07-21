#Область Локализация

// Переопределение параметров интеграции ВЕТИС (расположения форматированной строки)
//
// Параметры:
//   Форма            - ФормаКлиентскогоПриложения - прикладная форма для встраивания форматированной строки
//   ПараметрыНадписи - Структура        - (см. СобытияФормИС.ПараметрыИнтеграцииДляДокументаОснования)
Процедура ПриОпределенииПараметровИнтеграцииВЕТИС(Форма, ПараметрыНадписи) Экспорт
	
	Возврат;
	
КонецПроцедуры

Процедура ПослеЗаписиНаСервере(Форма) Экспорт
	
	Возврат;
	
КонецПроцедуры

Процедура ПриСозданииНаСервере(Форма, Отказ, СтандартнаяОбработка) Экспорт
	
	Возврат;
	
КонецПроцедуры


Процедура ПриЧтенииНаСервере(Форма, ТекущийОбъект) Экспорт
	
	Возврат;
	
КонецПроцедуры

#Область СобытияЭлементовФорм

// Серверная переопределяемая процедура, вызываемая из обработчика события элемента.
//
// Параметры:
//   Форма                   - ФормаКлиентскогоПриложения - форма, из которой происходит вызов процедуры.
//   Элемент                 - Строка           - имя элемента-источника события "При изменении"
//   ДополнительныеПараметры - Структура        - значения дополнительных параметров влияющих на обработку.
//
Процедура ПриИзмененииЭлемента(Форма, Элемент, ДополнительныеПараметры) Экспорт
	
	Возврат;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти


#Область ОбработчикиСобытийЭлементовФормы

// Выполняет действия при изменении номенклатуры в таблице Товары.
//
// Параметры:
//  Форма - ФормаКлиентскогоПриложения - Форма, в которой произошло событие.
//  ТекущаяСтрока - ДанныеФормыЭлементКоллекции - Строка таблицы товаров.
//  КэшированныеЗначения - Структура - Сохраненные значения параметров, используемых при обработке строки таблицы.
//  ПараметрыЗаполнения - (См. ИнтеграцияВЕТИСКлиентСервер.ПараметрыЗаполненияТабличнойЧасти).
//  ПараметрыУказанияСерий - Структура - Состав полей определен в функции 
//                                       НоменклатураКлиентСервер.ПараметрыУказанияСерий.
Процедура ПриИзмененииНоменклатуры(Форма,
								ТекущаяСтрока,
								КэшированныеЗначения,
								ПараметрыЗаполнения,
								ПараметрыУказанияСерий = Неопределено) Экспорт
	
	СобытияФормВЕТИСРТ.ПриИзмененииНоменклатуры(
		Форма,
		ТекущаяСтрока,
		КэшированныеЗначения,
		ПараметрыЗаполнения,
		ПараметрыУказанияСерий);
	
КонецПроцедуры

// Выполняет действия при изменении номенклатуры в таблице Товары.
//
// Параметры:
//  Форма - ФормаКлиентскогоПриложения - Форма, в которой произошло событие.
//  ТекущаяСтрока - ДанныеФормыЭлементКоллекции - Строка таблицы товаров.
//  КэшированныеЗначения - Структура - Сохраненные значения параметров, используемых при обработке строки таблицы.
//  ПараметрыЗаполнения - (См. ИнтеграцияВЕТИСКлиентСервер.ПараметрыЗаполненияТабличнойЧасти).
//  ПараметрыУказанияСерий - Структура - Состав полей определен в функции 
//                                       НоменклатураКлиентСервер.ПараметрыУказанияСерий.
Процедура ПриИзмененииХарактеристики(Форма,
								ТекущаяСтрока,
								КэшированныеЗначения,
								ПараметрыЗаполнения,
								ПараметрыУказанияСерий = Неопределено) Экспорт
	
	СобытияФормВЕТИСРТ.ПриИзмененииХарактеристики(
		Форма,
		ТекущаяСтрока,
		КэшированныеЗначения,
		ПараметрыЗаполнения,
		ПараметрыУказанияСерий);
	
КонецПроцедуры

// Выполняет действия при изменении количества ВЕТИС в таблице Товары.
//
// Параметры:
//  Форма - ФормаКлиентскогоПриложения - Форма, в которой произошло событие.
//  ТекущаяСтрока - ДанныеФормыЭлементКоллекции - Строка таблицы товаров.
//  КэшированныеЗначения - Структура - Сохраненные значения параметров, используемых при обработке строки таблицы.
//  ПараметрыЗаполнения - (См. ИнтеграцияВЕТИСКлиентСервер.ПараметрыЗаполненияТабличнойЧасти).
Процедура ПриИзмененииКоличестваВЕТИС(Форма, ТекущаяСтрока, КэшированныеЗначения, ПараметрыЗаполнения) Экспорт
	
	СобытияФормВЕТИСРТ.ПриИзмененииКоличестваВЕТИС(Форма, ТекущаяСтрока, КэшированныеЗначения, ПараметрыЗаполнения);
	
КонецПроцедуры

// Выполняет действия при изменении количества в таблице Товары.
//
// Параметры:
//	Форма - ФормаКлиентскогоПриложения - Форма, в которой произошло событие.
//	ТекущаяСтрока - ДанныеФормыЭлементКоллекции - Строка таблицы товаров.
//	КэшированныеЗначения - Структура - Сохраненные значения параметров, используемых при обработке строки таблицы.
//	ПараметрыЗаполнения - (См. ИнтеграцияВЕТИСКлиентСервер.ПараметрыЗаполненияТабличнойЧасти).
//
Процедура ПриИзмененииКоличества(Форма, ТекущаяСтрока, КэшированныеЗначения, ПараметрыЗаполнения) Экспорт
	
	СобытияФормВЕТИСРТ.ПриИзмененииКоличества(Форма, ТекущаяСтрока, КэшированныеЗначения, ПараметрыЗаполнения);
	
КонецПроцедуры

#КонецОбласти

#Область ПрограммныйИнтерфейс

// Заполняет табличную часть Товары подобранными товарами.
//
// Параметры:
//  Форма - ФормаКлиентскогоПриложения - форма, в которой производится подбор,
//  ВыбранноеЗначение - Произвольный - данные, содержащие подобранную пользователем номенклатуру,
//  ПараметрыЗаполнения - Структура - см. функцию СобытияФормВЕТИСКлиентСервер.ПараметрыЗаполненияТабличнойЧасти.
//  ПараметрыУказанияСерий - Структура - Состав полей определен в функции 
//                                     НоменклатураКлиентСервер.ПараметрыУказанияСерий.
Процедура ОбработкаРезультатаПодбораНоменклатуры(Форма,
												ВыбранноеЗначение,
												ПараметрыЗаполнения,
												ПараметрыУказанияСерий = Неопределено) Экспорт
	
	СобытияФормВЕТИСРТ.ОбработкаРезультатаПодбораНоменклатуры(
		Форма,
		ВыбранноеЗначение,
		ПараметрыЗаполнения,
		ПараметрыУказанияСерий);
	
КонецПроцедуры

#КонецОбласти
