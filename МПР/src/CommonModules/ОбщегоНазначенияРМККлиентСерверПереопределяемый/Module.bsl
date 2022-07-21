
///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2022, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

#Область Поясняющие_надписи_ПрограммныйИнтерфейс
	
#КонецОбласти

// Определяет имя основной таблицы для списка видов оплат в помощнике настройки кассового места
//
// Параметры:
//  ИмяТаблицы - Строка - имя основной таблицы видов оплат до переопределения.
//
Процедура ЗаполнитьИмяОсновнойТаблицыВидовОплат(ИмяТаблицы) Экспорт
	ОбщегоНазначенияРМКРТКлиентСервер.ЗаполнитьИмяОсновнойТаблицыВидовОплат(ИмяТаблицы);
КонецПроцедуры

// Рассчитывает сумму НДС исходя из суммы и флагов налогообложения.
//
// Параметры:
//  Объект - ДанныеФормыКоллекция - данные объекта формы рабочего места кассира.
//  ТекущаяСтрока - Структура - строка табличной части товаров для обработки.
//
Процедура РассчитатьСуммуНДС(Объект, ТекущаяСтрока) Экспорт
	
	ОбщегоНазначенияРМКРТКлиентСервер.РассчитатьСуммуНДС(Объект, ТекущаяСтрока);
	
КонецПроцедуры

// Возвращает признак текущего использования сокращенного сценария настройки нового рабочего места кассира.
//
// Возвращаемое значение:
//  Результат - Булево
//
Функция ЭтоСокращенныйСценарийНастройкиРабочегоМестаСПрименениемПомощника() Экспорт
	Возврат Ложь;
КонецФункции

// Возвращает имя константы, хранящей признак использования подключаемого оборудования
//
// Возвращаемое значение:
//  Результат - Строка
//
Функция ИмяКонстантыИспользованияПодключаемогоОборудования() Экспорт
	Возврат "ИспользоватьПодключаемоеОборудование";
КонецФункции

// Возвращает имя метаданных, хранящих коды доступа кассиров в конфигурации
//
// Возвращаемое значение:
//  Результат - Строка
//
Функция ИмяМетаданныхХранящихКодыДоступаКассиров() Экспорт
	Возврат "РегистрыСведений.Штрихкоды";
КонецФункции

// Возвращает имя реквизита, хранящего код доступа кассира в конфигурации
//
// Возвращаемое значение:
//  Результат - Строка
//
Функция ИмяРеквизитаХранящегоКодДоступаКассира() Экспорт
	Возврат "Штрихкод";
КонецФункции

// Возвращает имя реквизита, хранящего владельца кода доступа кассира в конфигурации
//
// Возвращаемое значение:
//  Результат - Строка
//
Функция ИмяРеквизитаХранящегоВладельцаКодаДоступа() Экспорт
	Возврат "Владелец";
КонецФункции

// Возвращает имя метаданных, хранящих особенности учета товара
//
// Возвращаемое значение:
//  Результат - Строка
//
Функция ИмяМетаданныхОсобенностиУчета() Экспорт
	Возврат "";
КонецФункции

// Возвращает имя метаданных, хранящих виды номенклатуры
//
// Возвращаемое значение:
//  Результат - Строка
//
Функция ИмяМетаданныхВидовНоменклатуры() Экспорт
	Возврат ОбщегоНазначенияРМКРТКлиентСервер.ИмяМетаданныхВидовНоменклатуры();
КонецФункции

// Возвращает имя реквизита номенклатуры, хранящего вид сущности
//
// Возвращаемое значение:
//  Результат - ВидНоменклатурыРМК
//
Функция ИмяРеквизитаВидаНоменклатуры() Экспорт
	Возврат ОбщегоНазначенияРМКРТКлиентСервер.ИмяРеквизитаВидаНоменклатуры();
КонецФункции

// Возвращает имя реквизита номенклатуры, хранящего особенность учета сущности
//
// Возвращаемое значение:
//  Результат - ВидНоменклатурыРМК
//
Функция ИмяРеквизитаОсобенностиУчета() Экспорт
	Возврат ОбщегоНазначенияРМКРТКлиентСервер.ИмяРеквизитаОсобенностиУчета();
КонецФункции

//  Возвращает признак стандартной обработки выбора кода доступа в таблице настройки помощника
//
// Возвращаемое значение:
//  Результат - Булево
//
Функция ЭтоСтандартнаяОбработкаВыбораКодаДоступаВИнтерфейсеПомощникаНастройкиРМК() Экспорт
	Возврат ОбщегоНазначенияРМКРТКлиентСервер.ЭтоСтандартнаяОбработкаВыбораКодаДоступаВИнтерфейсеПомощникаНастройкиРМК();
КонецФункции

// Возвращает вид отображения переключателя элемента интерфейса, отображающего тип Булево
//
// Возвращаемое значение:
//  Результат - ВидФлажка
//
Функция ВидОтображенияБинарногоПоля() Экспорт
	Возврат ОбщегоНазначенияРМКРТКлиентСервер.ВидОтображенияБинарногоПоля();
КонецФункции

// Возвращает положение заголовка переключателя элемента интерфейса, отображающего тип Булево
//
// Возвращаемое значение:
//  Результат - ПоложениеЗаголовкаЭлементаФормы
//
Функция ПоложениеЗаголовкаЭлемента() Экспорт
	Возврат ОбщегоНазначенияРМКРТКлиентСервер.ПоложениеЗаголовкаЭлемента();
КонецФункции

// Возвращает текст сообщения с рекомендациями по исправлению ситуации невозможности определения кассы
//
// Возвращаемое значение:
//  Результат - Строка - текст сообщения об ошибке определения кассы
//
Функция ТекстСообщенияОбОшибкеОпределенияКассы() Экспорт
	Возврат ОбщегоНазначенияРМКРТКлиентСервер.ТекстСообщенияОбОшибкеОпределенияКассы();
КонецФункции

// Возвращает текст сообщения с рекомендациями по исправлению ситуации невозможности определения настроек РМК
//
// Возвращаемое значение:
//  Результат - Строка - текст сообщения об ошибке определения кассы
//
Функция ТекстСообщенияОбОшибкеОпределенияНастройкиРМК() Экспорт
	Возврат ОбщегоНазначенияРМКРТКлиентСервер.ТекстСообщенияОбОшибкеОпределенияНастройкиРМК();
КонецФункции

// Возвращает имя заголовка элемента, хранящего особенность учета на форме запретов продаж
//
// Возвращаемое значение:
//  Результат - Строка - текст сообщения об ошибке определения кассы
//
Функция ИмяЗаголовкаОсобенностиУчета() Экспорт
КонецФункции

// Возвращает имя заголовка элемента, хранящего вид номенклатуры на форме запретов продаж
//
// Возвращаемое значение:
//  Результат - Строка - текст сообщения об ошибке определения кассы
//
Функция ИмяЗаголовкаВидаНоменклатуры() Экспорт
КонецФункции

// Возвращает текст запроса на получение последнего назначенного штрихкода сотрудника
//
// Возвращаемое значение:
//  Результат - Строка - текст запроса
//
Функция ТекстЗапросаПоследнегоНазначенногоШтрихкодаСотрудника() Экспорт
	Возврат ОбщегоНазначенияРМКРТКлиентСервер.ТекстЗапросаПоследнегоНазначенногоШтрихкодаСотрудника();
КонецФункции

// Позволяет переопределить текст подсказки настройки запрета продаж
//
// Параметры:
//  ТекстПодсказки - Строка - в этот параметр нужно записать результат.
//
Процедура ЗаполнитьТекстПодсказкиНастройкиЗапретовПродаж(ТекстПодсказки) Экспорт
	ОбщегоНазначенияРМКРТКлиентСервер.ЗаполнитьТекстПодсказкиНастройкиЗапретовПродаж(ТекстПодсказки);
КонецПроцедуры

#КонецОбласти
