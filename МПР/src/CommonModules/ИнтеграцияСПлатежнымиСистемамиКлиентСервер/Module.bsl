///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2021, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// Подсистема "ИнтернетПоддержкаПользователей.ИнтеграцияСПлатежнымиСистемами".
// ОбщийМодуль.ИнтеграцияСПлатежнымиСистемамиКлиентСервер.
//
// Клиент-серверные процедуры общих настроек и статических идентификаторов:
//  - получение статусов прикладных операций оплат.
//
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Возвращает статус операции "Выполняется".
//
// Возвращаемое значение:
//  Строка - код состояния.
//
Функция СтатусОперацииВыполняется() Экспорт
	
	Возврат "Выполняется";
	
КонецФункции

// Возвращает статус операции "Отменена".
//
// Возвращаемое значение:
//  Строка - код состояния.
//
Функция СтатусОперацииОтменена() Экспорт
	
	Возврат "Отменена";
	
КонецФункции

// Возвращает статус операции "Выполнена".
//
// Возвращаемое значение:
//  Строка - код состояния.
//
Функция СтатусОперацииВыполнена() Экспорт
	
	Возврат "Выполнена";
	
КонецФункции

// Возвращает статус операции "Ошибка".
//
// Возвращаемое значение:
//  Строка - код состояния.
//
Функция СтатусОперацииОшибка() Экспорт
	
	Возврат "Ошибка";
	
КонецФункции

// Возвращает статус операции "ТребуетсяПодтверждение".
//
// Возвращаемое значение:
//  Строка - код состояния.
//
Функция СтатусОперацииТребуетсяПодтверждение() Экспорт
	
	Возврат "ТребуетсяПодтверждение";
	
КонецФункции

#КонецОбласти
