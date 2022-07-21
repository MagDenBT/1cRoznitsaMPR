#Область ПрограммныйИнтерфейс

// Выполняет печать строк на ФР.
//
// Параметры:
//  СтруктураШаблона  - Структура -  параметры шаблона.
//  Свойство          - Строка - наименование свойства.
//
// Возвращаемое значение:
//  Массив - массив напечатанных строк.
//
Функция НапечататьСтроки(СтруктураШаблона, Свойство) Экспорт
	
	МассивСтрок = Новый Массив();
	
	Если СтруктураШаблона <> Неопределено Тогда
		МассивСтрок = НапечататьНеФискальныеСтроки(СтруктураШаблона, Свойство);
	КонецЕсли;
	
	Возврат МассивСтрок;
	
КонецФункции

// Добавляет фискальные строки в дерево шаблона перед формированием
// по нему представления чека.
//
// Параметры:
//  ИмяОбъекта - Строка - имя объекта для которого нужно сформировать фискальные строки.
//  КопияШаблона - КоллекцияСтрокДереваЗначений - коллекция строк в которую необходимо добавить фискальные строки.
//  ШиринаЧека - Число - ширина чека в символах.
//  ОднаФискальнаяСтрока - Булево - определяется наличие режима одна фискальная строка.
//
// Возвращаемое значение:
//  КоллекцияСтрокДереваЗначений - коллекция строк дерева значений.
//
Функция СформироватьФискальныеСтрокиМакетаФискальногоЧека(ИмяОбъекта ,КопияШаблона, ШиринаЧека, ОднаФискальнаяСтрока) Экспорт
	
	МенеджерОбъекта = ОбщегоНазначения.МенеджерОбъектаПоПолномуИмени(ИмяОбъекта);
	Если МенеджерОбъекта = Неопределено Тогда
		Возврат КопияШаблона;
	Иначе
		Возврат МенеджерОбъекта.СформироватьФискальныеСтроки(КопияШаблона, ШиринаЧека, ОднаФискальнаяСтрока);
	КонецЕсли;
	
КонецФункции

// Выполняет вставку строки в дерево шаблона по индексу с заданными параметрами.
//
// Параметры:
//  КоллекцияСтрок   - КоллекцияСтрокДереваЗначений - коллекция строк в которую необходимо добавить новую строку.
//  Индекс           - Число - индекс в коллекции значений.
//  Параметры        - Структура:
//		*ИмяЭлемента - Строка - имя элемента.
//		*ТипЭлемента - Строка - тип элемента.
//		*Ширина - Число - ширина в символах.
//		*РазмещениеТекста - число - размещение текста.
//		*Выравнивание - Строка - выравнивание текста.
//		*Формат - Строка - формат строки.
//		*ИмяКолонки - Строка - имя колонки для СКД.
//		*Вычислять - Булево - необходимо ли вычислять значение элемента.
//
// Возвращаемое значение:
//  СтрокаДереваЗначений - строка дерева значений.
//
Функция ВставитьСтрокуВКоллекциюСтрокДерева(КоллекцияСтрок, Индекс, Параметры) Экспорт

	НоваяСтрока = КоллекцияСтрок.Вставить(Индекс);
	
	Значение = Неопределено;
	Если Параметры.Свойство("Ширина", Значение) Тогда
		НоваяСтрока.Ширина        = Значение;
	Иначе
		// Значение по умолчанию
		НоваяСтрока.Ширина        = 0;
	КонецЕсли;
	
	Значение = Неопределено;
	Если Параметры.Свойство("ИмяЭлемента", Значение) Тогда
		НоваяСтрока.Элемент        = Значение;
	Иначе
		// Значение по умолчанию
		НоваяСтрока.Элемент        = "";
	КонецЕсли;
	
	Значение = Неопределено;
	Если Параметры.Свойство("ТипЭлемента", Значение) Тогда
		НоваяСтрока.ТипЭлемента        = Значение;
	Иначе
		// Значение по умолчанию
		НоваяСтрока.ТипЭлемента        = "";
	КонецЕсли;
	
	Значение = Неопределено;
	Если Параметры.Свойство("Идентификатор", Значение) Тогда
		НоваяСтрока.Идентификатор        = Значение;
	Иначе
		// Значение по умолчанию
		НоваяСтрока.Идентификатор        = УправлениеШаблонами.ПолучитьИдентификатор();
	КонецЕсли;
	
	Значение = Неопределено;
	Если Параметры.Свойство("РазмещениеТекста", Значение) Тогда
		НоваяСтрока.РазмещениеТекста        = Значение;
	Иначе
		// Значение по умолчанию
		НоваяСтрока.РазмещениеТекста        = 1;
	КонецЕсли;
	
	Значение = Неопределено;
	Если Параметры.Свойство("Выравнивание", Значение) Тогда
		НоваяСтрока.Выравнивание        = Значение;
	Иначе
		// Значение по умолчанию
		НоваяСтрока.Выравнивание        = "Лево";
	КонецЕсли;
	
	Значение = Неопределено;
	Если Параметры.Свойство("ИмяКолонки", Значение) Тогда
		НоваяСтрока.ИмяКолонки        = Значение;
	Иначе
		// Значение по умолчанию
		НоваяСтрока.ИмяКолонки        = "";
	КонецЕсли;
	
	Значение = Неопределено;
	Если Параметры.Свойство("Формат", Значение) Тогда
		НоваяСтрока.Формат        = Значение;
	Иначе
		// Значение по умолчанию
		НоваяСтрока.Формат        = "";
	КонецЕсли;

	Значение = Неопределено;
	Если Параметры.Свойство("Префикс", Значение) Тогда
		НоваяСтрока.Префикс        = Значение;
	Иначе
		// Значение по умолчанию
		НоваяСтрока.Префикс        = "";
	КонецЕсли;

	Значение = Неопределено;
	Если Параметры.Свойство("Постфикс", Значение) Тогда
		НоваяСтрока.Постфикс        = Значение;
	Иначе
		// Значение по умолчанию
		НоваяСтрока.Постфикс        = "";
	КонецЕсли;
	
	Значение = Неопределено;
	Если Параметры.Свойство("ОписаниеТипа", Значение) Тогда
		НоваяСтрока.ОписаниеТипа        = Значение;
	Иначе
		// Значение по умолчанию
		НоваяСтрока.ОписаниеТипа = Новый ОписаниеТипов("Строка",, Новый КвалификаторыСтроки(50));
	КонецЕсли;
	
	Значение = Неопределено;
	Если Параметры.Свойство("ПустоеЗначение", Значение) Тогда
		НоваяСтрока.ПустоеЗначение        = Значение;
	Иначе
		// Значение по умолчанию
		НоваяСтрока.ПустоеЗначение = Неопределено;
	КонецЕсли;

	Значение = Неопределено;
	Если Параметры.Свойство("СтрокаПустоеЗначение", Значение) Тогда
		НоваяСтрока.СтрокаПустоеЗначение        = Значение;
	Иначе
		// Значение по умолчанию
		НоваяСтрока.СтрокаПустоеЗначение = "";
	КонецЕсли;
	
	Возврат НоваяСтрока;
	
КонецФункции

// Выполняет добавление строки в дерево шаблона с заданными параметрами.
//
// Параметры:
//  КоллекцияСтрок   - КоллекцияСтрокДереваЗначений - коллекция строк в которую необходимо добавить новую строку.
//  Параметры        - Структура:
//		*ИмяЭлемента - Строка - имя элемента.
//		*ТипЭлемента - Строка - тип элемента.
//		*Ширина - Число - ширина в символах.
//		*РазмещениеТекста - число - размещение текста.
//		*Выравнивание - Строка - выравнивание текста.
//		*Формат - Строка - формат строки.
//		*ИмяКолонки - Строка - имя колонки для СКД.
//		*Вычислять - Булево - необходимо ли вычислять значение элемента.
//
// Возвращаемое значение:
//   СтрокаДереваЗначений - Строка дерева значений.
//
Функция ДобавитьСтрокуВКоллекциюСтрокДерева(КоллекцияСтрок, Параметры) Экспорт

	НоваяСтрока = КоллекцияСтрок.Добавить();
	
	Значение = Неопределено;
	Если Параметры.Свойство("Ширина", Значение) Тогда
		НоваяСтрока.Ширина        = Значение;
	Иначе
		// Значение по умолчанию
		НоваяСтрока.Ширина        = 0;
	КонецЕсли;
	
	Значение = Неопределено;
	Если Параметры.Свойство("ИмяЭлемента", Значение) Тогда
		НоваяСтрока.Элемент        = Значение;
	Иначе
		// Значение по умолчанию
		НоваяСтрока.Элемент        = "";
	КонецЕсли;
	
	Значение = Неопределено;
	Если Параметры.Свойство("ТипЭлемента", Значение) Тогда
		НоваяСтрока.ТипЭлемента        = Значение;
	Иначе
		// Значение по умолчанию
		НоваяСтрока.ТипЭлемента        = "";
	КонецЕсли;
	
	Значение = Неопределено;
	Если Параметры.Свойство("Идентификатор", Значение) Тогда
		НоваяСтрока.Идентификатор        = Значение;
	Иначе
		// Значение по умолчанию
		НоваяСтрока.Идентификатор        = УправлениеШаблонами.ПолучитьИдентификатор();
	КонецЕсли;
	
	Значение = Неопределено;
	Если Параметры.Свойство("РазмещениеТекста", Значение) Тогда
		НоваяСтрока.РазмещениеТекста        = Значение;
	Иначе
		// Значение по умолчанию
		НоваяСтрока.РазмещениеТекста        = 1;
	КонецЕсли;
	
	Значение = Неопределено;
	Если Параметры.Свойство("Выравнивание", Значение) Тогда
		НоваяСтрока.Выравнивание        = Значение;
	Иначе
		// Значение по умолчанию
		НоваяСтрока.Выравнивание        = "Лево";
	КонецЕсли;
	
	Значение = Неопределено;
	Если Параметры.Свойство("ИмяКолонки", Значение) Тогда
		НоваяСтрока.ИмяКолонки        = Значение;
	Иначе
		// Значение по умолчанию
		НоваяСтрока.ИмяКолонки        = "";
	КонецЕсли;
	
	Значение = Неопределено;
	Если Параметры.Свойство("Формат", Значение) Тогда
		НоваяСтрока.Формат        = Значение;
	Иначе
		// Значение по умолчанию
		НоваяСтрока.Формат        = "";
	КонецЕсли;
	
	Значение = Неопределено;
	Если Параметры.Свойство("Вычислять", Значение) Тогда
		НоваяСтрока.Вычислять        = Значение;
	Иначе
		// Значение по умолчанию
		НоваяСтрока.Вычислять        = Ложь;
	КонецЕсли;
	
	Значение = Неопределено;
	Если Параметры.Свойство("Префикс", Значение) Тогда
		НоваяСтрока.Префикс        = Значение;
	Иначе
		// Значение по умолчанию
		НоваяСтрока.Префикс        = "";
	КонецЕсли;
	
	Значение = Неопределено;
	Если Параметры.Свойство("Постфикс", Значение) Тогда
		НоваяСтрока.Постфикс        = Значение;
	Иначе
		// Значение по умолчанию
		НоваяСтрока.Постфикс        = "";
	КонецЕсли;
	
	Значение = Неопределено;
	Если Параметры.Свойство("ОписаниеТипа", Значение) Тогда
		НоваяСтрока.ОписаниеТипа        = Значение;
	Иначе
		// Значение по умолчанию
		НоваяСтрока.ОписаниеТипа = Новый ОписаниеТипов("Строка",, Новый КвалификаторыСтроки(50));
	КонецЕсли;
	
	Значение = Неопределено;
	Если Параметры.Свойство("ПустоеЗначение", Значение) Тогда
		НоваяСтрока.ПустоеЗначение        = Значение;
	Иначе
		// Значение по умолчанию
		НоваяСтрока.ПустоеЗначение = Неопределено;
	КонецЕсли;

	Значение = Неопределено;
	Если Параметры.Свойство("СтрокаПустоеЗначение", Значение) Тогда
		НоваяСтрока.СтрокаПустоеЗначение        = Значение;
	Иначе
		// Значение по умолчанию
		НоваяСтрока.СтрокаПустоеЗначение = "";
	КонецЕсли;
	
	Если НоваяСтрока.ТипЭлемента = "ОбластьЧека" Тогда
		НоваяСтрока.ИндексКартинки = 0.00; // СистемнаяСтрока
	ИначеЕсли НоваяСтрока.ТипЭлемента = "СтрокаДанных" Тогда
		НоваяСтрока.ИндексКартинки = 1.00; // ВычисляемаяСтрока
	ИначеЕсли НоваяСтрока.ТипЭлемента = "СтрокаТекста" Тогда
		НоваяСтрока.ИндексКартинки = 2.00; // ПользовательскаяСтрока
	ИначеЕсли НоваяСтрока.ТипЭлемента = "СоставнаяСтрока" Тогда
		НоваяСтрока.ИндексКартинки = 3.00; // СоставнаяСтрока
	ИначеЕсли НоваяСтрока.ТипЭлемента = "Таблица" Тогда
		НоваяСтрока.ИндексКартинки = 4.00; // СтрокаТаблицы
	Иначе
		НоваяСтрока.ИндексКартинки = 5.00;
	КонецЕсли;
	
	Возврат НоваяСтрока;
	
КонецФункции

// Выполняет формирование предопределенной структуры шаблона
//  значений.
//
// Параметры:
//  ИерархическийШаблон - ДеревоЗначений - шаблон для которого необходимо сформировать предопределенную структуру.
//  ИмяОбъекта - Строка - имя объекта метаданных.
//  ПервичнаяСтруктура - Структура - структура первичных данных.
//  Загружать - Булево - признак загрузки данных.
//
Функция СформироватьПервичнуюСтруктуруИерархическогоШаблона(ИерархическийШаблон, ИмяОбъекта, ПервичнаяСтруктура, Загружать = Истина) Экспорт
	
	МенеджерОбъекта = ОбщегоНазначения.МенеджерОбъектаПоПолномуИмени(ИмяОбъекта);
	Возврат МенеджерОбъекта.СформироватьПервичнуюСтруктуруШаблона(ИерархическийШаблон, ИмяОбъекта, ПервичнаяСтруктура, Загружать);
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Выполняет печать нефискальных строк на ФР.
//
// Параметры:
//  СтруктураШаблона - Структура - параметры шаблона.
//  Свойство         - Строка - Наименование свойства
//
// Возвращаемое значение:
//  Ошибка - Представление ошибки печати на ФР.
//
Функция НапечататьНеФискальныеСтроки(СтруктураШаблона, Свойство)
	
	МассивСоответствий = Неопределено;
	СтруктураШаблона.Шаблон.Свойство(Свойство,МассивСоответствий);
	Если МассивСоответствий <> Неопределено И МассивСоответствий.Количество() > 0 Тогда
		МассивСоответствий = ПреобразоватьМассивСоответствийВМассивТекстовыхСтрок(МассивСоответствий);
	КонецЕсли;
	
	Возврат ?(МассивСоответствий = Неопределено, Новый Массив(), МассивСоответствий);
	
КонецФункции

// Преобразует массивы (из массива соответствий в массив текстовых строк).
//
// Параметры:
//  МассивСоответствий - Массив - Массив соответствий.
//
// Возвращаемое значение:
//  Массив - массив текстовых строк.
//
Функция ПреобразоватьМассивСоответствийВМассивТекстовыхСтрок(МассивСоответствий)

	РезультирующийМассив = Новый Массив;
	Для каждого Соответствия Из МассивСоответствий Цикл
		Для каждого ЭлементСоответствия Из Соответствия Цикл
			Для каждого СтрокаМассива Из ЭлементСоответствия.Значение Цикл
				РезультирующийМассив.Добавить(СтрокаМассива);
			КонецЦикла;
		КонецЦикла;
	КонецЦикла;
	
	Возврат РезультирующийМассив;
	
КонецФункции

#КонецОбласти