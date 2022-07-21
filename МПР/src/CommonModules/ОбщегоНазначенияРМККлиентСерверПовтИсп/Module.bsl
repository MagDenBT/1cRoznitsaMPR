
///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2022, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Возвращает представление валюты.
//
// Возвращаемое значение:
//  Строка - представление валюты.
//
Функция ВалютаРубли() Экспорт
	Возврат НСтр("ru = 'руб.'");
КонецФункции

// Возвращает день недели по дате 
//
// Параметры:
//  Дата - Дата - дата, по которой определяется значение дня
//
// Возвращаемое значение:
//  Результат - ПеречислениеСсылка.ДниНедели
//
Функция ДеньНеделиПеречислением(Дата) Экспорт

	НачалоЛитералаДняНедели = "Перечисление.ДниНедели.";
	ДополнениеЛитералаДняНедели = "ПустаяСсылка";
	
	Если ЗначениеЗаполнено(Дата) Тогда
	
		ДеньНеделиЧислом = ДеньНедели(Дата);
		
		Если ДеньНеделиЧислом = 1 Тогда
			ДополнениеЛитералаДняНедели = "Понедельник";
		ИначеЕсли ДеньНеделиЧислом = 2 Тогда
			ДополнениеЛитералаДняНедели = "Вторник";
		ИначеЕсли ДеньНеделиЧислом = 3 Тогда
			ДополнениеЛитералаДняНедели = "Среда";
		ИначеЕсли ДеньНеделиЧислом = 4 Тогда
			ДополнениеЛитералаДняНедели = "Четверг";
		ИначеЕсли ДеньНеделиЧислом = 5 Тогда
			ДополнениеЛитералаДняНедели = "Пятница";
		ИначеЕсли ДеньНеделиЧислом = 6 Тогда
			ДополнениеЛитералаДняНедели = "Суббота";
		ИначеЕсли ДеньНеделиЧислом = 7 Тогда
			ДополнениеЛитералаДняНедели = "Воскресенье";
		Иначе
			ДополнениеЛитералаДняНедели = "ПустаяСсылка";
		КонецЕсли;
	
	КонецЕсли;
	
	ПолноеИмяЛитерала = СтрШаблон("%1%2", НачалоЛитералаДняНедели, ДополнениеЛитералаДняНедели);
	Возврат ОбщегоНазначенияКлиентСервер.ПредопределенныйЭлемент(ПолноеИмяЛитерала);
	
КонецФункции

// Возвращает перечень маркируемой продукции, оборот которой фиксируется в ИС МП.
//
// Параметры:
//  ВключатьТабачнуюПродукцию - Булево - Признак включения табачной продукции
//  ВключатьМолочнуюПродукцию - Булево - Признак включения молочной продукции подконтрольной ВетИС
//
// Возвращаемое значение:
//   Массив Из ПеречислениеСсылка.ОсобенностиУчетаНоменклатуры - список видов маркируемой продукции ИСМП.
//
Функция ВидыМаркируемойПродукции(ВключатьТабачнуюПродукцию = Истина, ВключатьМолочнуюПродукцию = Истина) Экспорт
	
	ВидыМаркируемойПродукции = Новый Массив();
	ВидыМаркируемойПродукции.Добавить(ОбщегоНазначенияКлиентСервер.ПредопределенныйЭлемент(
		"Перечисление.ОсобенностиУчетаНоменклатуры.ОбувнаяПродукция"));
	ВидыМаркируемойПродукции.Добавить(ОбщегоНазначенияКлиентСервер.ПредопределенныйЭлемент(
		"Перечисление.ОсобенностиУчетаНоменклатуры.ЛегкаяПромышленность"));
	
	Если ВключатьМолочнуюПродукцию Тогда
		ВидыМаркируемойПродукции.Добавить(ОбщегоНазначенияКлиентСервер.ПредопределенныйЭлемент(
			"Перечисление.ОсобенностиУчетаНоменклатуры.МолочнаяПродукция"));
	КонецЕсли;
	
	ВидыМаркируемойПродукции.Добавить(ОбщегоНазначенияКлиентСервер.ПредопределенныйЭлемент(
		"Перечисление.ОсобенностиУчетаНоменклатуры.Фотоаппараты"));
	ВидыМаркируемойПродукции.Добавить(ОбщегоНазначенияКлиентСервер.ПредопределенныйЭлемент(
		"Перечисление.ОсобенностиУчетаНоменклатуры.Велосипеды"));
	ВидыМаркируемойПродукции.Добавить(ОбщегоНазначенияКлиентСервер.ПредопределенныйЭлемент(
		"Перечисление.ОсобенностиУчетаНоменклатуры.КреслаКоляски"));
	ВидыМаркируемойПродукции.Добавить(ОбщегоНазначенияКлиентСервер.ПредопределенныйЭлемент(
		"Перечисление.ОсобенностиУчетаНоменклатуры.Шины"));
	ВидыМаркируемойПродукции.Добавить(ОбщегоНазначенияКлиентСервер.ПредопределенныйЭлемент(
		"Перечисление.ОсобенностиУчетаНоменклатуры.Духи"));
	ВидыМаркируемойПродукции.Добавить(ОбщегоНазначенияКлиентСервер.ПредопределенныйЭлемент(
		"Перечисление.ОсобенностиУчетаНоменклатуры.УпакованнаяВода"));
	
	Если ВключатьТабачнуюПродукцию Тогда
		
		ВидыМаркируемойПродукции.Добавить(ОбщегоНазначенияКлиентСервер.ПредопределенныйЭлемент(
			"Перечисление.ОсобенностиУчетаНоменклатуры.ТабачнаяПродукция"));
		ВидыМаркируемойПродукции.Добавить(ОбщегоНазначенияКлиентСервер.ПредопределенныйЭлемент(
			"Перечисление.ОсобенностиУчетаНоменклатуры.АльтернативныйТабак"));
		
	КонецЕсли;
	
	Возврат ВидыМаркируемойПродукции;
	
КонецФункции

// Возвращает перечень подакцизной продукции.
//
//
// Возвращаемое значение:
//   Массив Из ПеречислениеСсылка.ОсобенностиУчетаНоменклатуры - список видов маркируемой продукции ИСМП.
//
Функция ВидыПодакцизнойНоменклатуры() Экспорт

	Результат = Новый Массив();
	Результат.Добавить(ОбщегоНазначенияКлиентСервер.ПредопределенныйЭлемент(
		"Перечисление.ОсобенностиУчетаНоменклатуры.АлкогольнаяПродукция"));
	Результат.Добавить(ОбщегоНазначенияКлиентСервер.ПредопределенныйЭлемент(
			"Перечисление.ОсобенностиУчетаНоменклатуры.ТабачнаяПродукция"));
	Результат.Добавить(ОбщегоНазначенияКлиентСервер.ПредопределенныйЭлемент(
			"Перечисление.ОсобенностиУчетаНоменклатуры.АльтернативныйТабак"));
	
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти

