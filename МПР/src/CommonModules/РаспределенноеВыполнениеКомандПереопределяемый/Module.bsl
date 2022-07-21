// @strict-types

#Область ПрограммныйИнтерфейс

// Вызывается при получении сообщения о передаче файла из другой области данных.
// @skip-warning ПустойМетод - переопределяемый метод.
//
// Параметры:
//	ИмяФайла - Строка - полное имя к передаваемому файлу.
//	ИдентификаторВызова - УникальныйИдентификатор - для идентификации конкретного вызова
//	КодОтправителя - Число - код области данных, откуда был передан файл.
//	ПараметрыВызова - Структура - дополнительные параметры вызова,
//						*Код (Число), *Тело (Строка).
//	Обработан - Булево - признак успешной обработки сообщения.
//
Процедура ОбработатьЗапросНаПередачуФайла(ИмяФайла, ИдентификаторВызова, КодОтправителя, ПараметрыВызова, Обработан) Экспорт

КонецПроцедуры

// Вызывается при получении квитанции "Успех" на передачу файла из другой области данных.
// @skip-warning ПустойМетод - переопределяемый метод.
//
// Параметры:
//	ИдентификаторВызова - УникальныйИдентификатор - для идентификации конкретного вызова
//	КодОтправителя - Число - код области данных, откуда был передан файл.
//	ПараметрыВызова - Структура - дополнительные параметры вызова,
//						*Код (Число), *Тело (Строка).
//	Обработан - Булево - признак успешной обработки сообщения.
//
Процедура ОбработатьОтветНаПередачуФайла(ИдентификаторВызова, КодОтправителя, ПараметрыВызова, Обработан) Экспорт
	
	РезультатОбменаФайлом = Новый Структура;
	РезультатОбменаФайлом.Вставить("ИдентификаторВызова", ИдентификаторВызова);
	РезультатОбменаФайлом.Вставить("ВыполненУспешно",     Истина);
	РезультатОбменаФайлом.Вставить("ТекстОшибки",         "");
	
	ОбщегоНазначенияРТ.ЗаписатьРезультатОбменаФайлом(РезультатОбменаФайлом);
	
КонецПроцедуры

// Вызывается при получении квитанции "Ошибка" на передачу файла из другой области данных.
// @skip-warning ПустойМетод - переопределяемый метод.
//
// Параметры:
//	ИдентификаторВызова - УникальныйИдентификатор - для идентификации конкретного вызова
//	КодОтправителя - Число - код области данных, откуда был передан файл.
//	ТекстОшибки - Строка - описание возникшей ошибки 
//	Обработан - Булево - признак успешной обработки сообщения.
//
Процедура ОбработатьОшибкуПередачиФайла(ИдентификаторВызова, КодОтправителя, ТекстОшибки, Обработан) Экспорт
	
	РезультатОбменаФайлом = Новый Структура;
	РезультатОбменаФайлом.Вставить("ИдентификаторВызова", ИдентификаторВызова);
	РезультатОбменаФайлом.Вставить("ВыполненУспешно",     Ложь);
	РезультатОбменаФайлом.Вставить("ТекстОшибки",         ТекстОшибки);
	
	ОбщегоНазначенияРТ.ЗаписатьРезультатОбменаФайлом(РезультатОбменаФайлом);
	
КонецПроцедуры

#КонецОбласти