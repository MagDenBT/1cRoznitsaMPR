
///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2022, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Возвращает значение реквизита, прочитанного из информационной базы по ссылке на объект.
// Если доступа к реквизиту нет, возникнет исключение прав доступа.
// Если необходимо зачитать реквизит независимо от прав текущего пользователя,
// то следует использовать предварительный переход в привилегированный режим.
// 
// Параметры:
//  Ссылка       - ЛюбаяСсылка - ссылка на объект метаданных для получения значения реквизита.
//  ИмяРеквизита - Строка - наименование реквизита строкой.
// 
// Возвращаемое значение:
//  Произвольный - зависит от типа значения прочитанного реквизита.
// 
Функция ЗначениеРеквизитаОбъекта(Ссылка, ИмяРеквизита) Экспорт
	Возврат ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Ссылка, ИмяРеквизита);
КонецФункции

// Возвращает структуру значений реквизитов объекта.
//
// Параметры:
//  Ссылка - ЛюбаяСсылка - ссылка на объект метаданных для получения значения реквизита.
//  СтруктураПолей - Структура - структура реквизитов объекта метаданных.
//
// Возвращаемое значение:
//  Структура - структура значений реквизитов объекта.
//
Функция ЗначенияРеквизитовОбъекта(Ссылка, СтруктураПолей) Экспорт
	Возврат ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Ссылка, СтруктураПолей);
КонецФункции

// Определяет необходимость запуска нового РМК.
//
// Параметры:
//  ЗапуститьНовыйРМК - Булево
//
Процедура ОпределитьРежимЗапуска(ЗапуститьНовыйРМК) Экспорт
	ОбщегоНазначенияРМК.ОпределитьРежимЗапуска(ЗапуститьНовыйРМК);
КонецПроцедуры

// Устанавливает выбранную настройку РМК для текущего рабочего места.
// Если находит настройки РМК, связанные с текущим рабочим местом, удаляет эти связи
//
// Параметры:
//  НастройкаРМК - СправочникСсылка.НастройкиРМК - настройки рмк
//
Процедура УстановитьНастройкуРМКДляТекущегоРабочегоМеста(НастройкаРМК) Экспорт
	ОбщегоНазначенияРМК.УстановитьНастройкуРМКДляТекущегоРабочегоМеста(НастройкаРМК);
КонецПроцедуры

// Заполняет ИмяКассира по данным физического лица для текущего пользователя 
//
// Параметры:
//  ИмяКассира - Строка.
//
Процедура ЗаполнитьФИОФизЛица(ИмяКассира) Экспорт
	ОбщегоНазначенияРМК.ЗаполнитьФИОФизЛица(ИмяКассира);
КонецПроцедуры

// Заполняет ИННКассира по данным текущего пользователя.
//
// Параметры:
//  ИННКассира - Строка.
//
Процедура ЗаполнитьИННФизЛица(ИННКассира) Экспорт
	ОбщегоНазначенияРМК.ЗаполнитьИННФизЛица(ИННКассира);
КонецПроцедуры

// Проверяет наличие актуальных запретов продажи по данным кэша запретов 
//
// Параметры:
//  Номенклатура - СправочникСсылка.Номенклатура - номенклатура, по вид и особенности учета которой
//	проверяется наличие запрета продаж на текущий момент
//  КэшЗапретов - ДанныеФормыКоллекция - перечень действующих запретов продаж на текущий момент
//
// Возвращаемое значение:
//  Результат - Структура
//
Функция НаличиеЗапретовПродажи(Номенклатура, КэшЗапретов) Экспорт
	Возврат ОбщегоНазначенияРМК.НаличиеЗапретовПродажи(Номенклатура, КэшЗапретов);
КонецФункции

// Проверяет наличие разрешения редактирования запретов продаж по данным настроек РМК
//
// Возвращаемое значение:
//  Результат - Булево
//
Функция РазрешеноРедактироватьЗапретыПродаж() Экспорт
	Возврат ОбщегоНазначенияРМК.РазрешеноРедактироватьЗапретыПродаж();
КонецФункции

// Возвращает значения адреса и имени пользователя сервиса лояльности
//
// Параметры:
//  НастройкаРабочегоМестаКассира - СправочникСсылка.НастройкиРМК - исходные данные для получения значений
//
// Возвращаемое значение:
//  Результат - Структура:
//		*АдресСервера - Строка
//		*Логин - Строка
//		*Пароль - Строка
//
Функция ЗначенияПараметровСервисаЛояльности(НастройкиРабочегоМестаКассира = Неопределено) Экспорт
	Возврат ОбщегоНазначенияРМК.ЗначенияПараметровСервисаЛояльности(НастройкиРабочегоМестаКассира);
КонецФункции

// Вспомогательный метод для обработки JSON на web - клиенте
//
// Параметры:
//  СтрокаJSON - Строка - исходные данные в формате JSON
// 
// ВозвращаемоеЗначение:
//  Результат - Структура, Неопределено - результат разбора ответа
//
Функция ОбработатьJSONСервер(СтрокаJSON) Экспорт
	
	Результат = Неопределено;
	
	Если ЗначениеЗаполнено(СтрокаJSON) Тогда
		Результат = ОбщегоНазначенияРМК.ОбработатьJSONСервер(СтрокаJSON);
	КонецЕсли;
	
	Возврат Результат;
		
КонецФункции

// Обрабатывает данные ответа из API
//
// Параметры:
//  ИсходныеДанные - Структура - данные ответа
//	НастройкиРабочегоМестаКассира - СправочникСсылка.НастройкиРМК - 
//		сущность для актуализации признака запрета интерактивного редактирования
//
// Возвращаемое значение:
//  Результат - Структура - результат обработки данных ответа
//
Функция ОбработатьДанныеЗапретовИзОтвета(ИсходныеДанные, НастройкиРабочегоМестаКассира = Неопределено) Экспорт
	Возврат ОбщегоНазначенияРМК.ОбработатьДанныеЗапретов(ИсходныеДанные, НастройкиРабочегоМестаКассира);
КонецФункции

// Выполняет обращение к ресурсу сервиса лояльности 
//
// Параметры:
//  ПараметрыВыполненияЗапроса - Структура -
//   (содержит:
//		ТипЗапроса - Строка, по умолчанию - "POST";
//		АдресСервера - Строка;
//		Логин - Строка;
//		Пароль - Строка;
//		Ресурс - Строка
//		ПараметрыМетода - Структура)
//
// Возвращаемое значение:
//  РезультатВыполнения - Структура - (содержит ДанныеОтвета, ЕстьОшибки, ТекстОшибки)
//
Функция ВыполнитьЗапросКСервисуЛояльности(ПараметрыВыполненияЗапроса) Экспорт
	Возврат ОбщегоНазначенияРМК.ВыполнитьЗапросКСервисуЛояльности(ПараметрыВыполненияЗапроса)
КонецФункции

// Возвращает реквизиты экваринговой операции Чека продажи.
//
// Параметры:
//  ЧекПродажи - ДокументСсылка.ЧекККМ - чек продажи, основание чека на возврат.
//
// Возвращаемое значение:
//  Результат - Структура - (содержит НомерПлатежнойКарты, НомерЧекаЭТ, СсылочныйНомер)
//
Функция РеквизитыЭквайринговойОперацииПродажи(ЧекПродажи) Экспорт
	Возврат ОбщегоНазначенияРМКПереопределяемый.РеквизитыЭквайринговойОперацииПродажи(ЧекПродажи);
КонецФункции

// Заполняет имя кассира и его ИНН для печати на ККТ.
//
// Параметры:
//  ПараметрыОперации - см.ОборудованиеЧекопечатающиеУстройстваКлиентСервер.ПараметрыОткрытияЗакрытияСмены().
//  Пользователь - СправочникСсылка.Пользователи - пользователь РМК.
//  Кассир - ОпределяемыйТип.КассирРМК - кассир РМК
//
Процедура ЗаполнитьПараметрыКассираДляПечати(ПараметрыОперации, Пользователь, Кассир) Экспорт
	ОбщегоНазначенияРМКПереопределяемый.ЗаполнитьПараметрыКассираДляПечати(ПараметрыОперации, Пользователь, Кассир);
КонецПроцедуры

#КонецОбласти

