

////////////////////////////////////////////////////////////////////////////////
// ОбменСКонтрагентамиРТКлиент: механизм обмена электронными документами для РТ.
//
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

//См. ОбменСКонтрагентамиКлиентПереопределяемый.ОткрытьФормуПодбораТоваров
// Заполняет адрес хранилища с таблицей значений - каталога товаров.
//
// Параметры:
//  ИдентификаторФормы   - УникальныйИдентификатор - уникальный  идентификатор формы, вызвавшей функцию. Форма должна
//                                                   возвращать адрес хранилища значения, содержащего таблицу товаров,
//                                                   либо Неопределено, если была вызвана отмена операции.
//  ОбработкаПродолжения - ОписаниеОповещения - содержит описание процедуры,
//                            которая будет вызвана после закрытия формы подбора.
//
Процедура ОткрытьФормуПодбораТоваров(ИдентификаторФормы, ОбработкаПродолжения) Экспорт
	
	Параметры = Новый Структура("ИдентификаторФормы", ИдентификаторФормы);
	ОткрытьФорму("ОбщаяФорма.ПодборТоваровБЭД", Параметры,,,,, ОбработкаПродолжения);
	
КонецПроцедуры

// Открывает форму создания нового контрагента с заполненными данными.
// 
// Параметры:
//  РеквизитыКонтрагента - Структура - источник заполнения реквизитов. Возможные элементы:
//   * Наименование - Строка
//   * ИНН - Строка
//   * КПП - Строка
//  ОписаниеОповещенияОСозданииКонтрагента - ОписаниеОповещения - (не является обработчиком оповещения о закрытии)
//   требуется вызвать данный обработчик со ссылкой на созданного контрагента в параметре Результат.
Процедура СоздатьКонтрагентаИнтерактивно(РеквизитыКонтрагента, ОписаниеОповещенияОСозданииКонтрагента) Экспорт
	
	СтруктураЗаполнения = Новый Структура;
	СтруктураЗаполнения.Вставить("Наименование", РеквизитыКонтрагента.Наименование);
	СтруктураЗаполнения.Вставить("НаименованиеПолное", РеквизитыКонтрагента.Наименование);
	СтруктураЗаполнения.Вставить("ИНН", РеквизитыКонтрагента.ИНН);
	СтруктураЗаполнения.Вставить("КПП", РеквизитыКонтрагента.КПП);
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("СтруктураЗаполнения", СтруктураЗаполнения);
	
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("ОписаниеОповещенияОСозданииКонтрагента", ОписаниеОповещенияОСозданииКонтрагента);
	
	ОписаниеОповещенияОЗакрытии = Новый ОписаниеОповещения(Неопределено,, ДополнительныеПараметры);
	ОткрытьФорму("Справочник.Контрагенты.Форма.ФормаЭлемента", ПараметрыФормы,,,,, ОписаниеОповещенияОЗакрытии);
	
КонецПроцедуры

// Открывает форму выбора контрагента с отбором.
// 
// Параметры:
//  РеквизитыОтбораКонтрагента - Структура - источник заполнения отбора списка контрагентов.
//   Возможные значения:
//   * Наименование - Строка
//   * ИНН - Строка
//   * КПП - Строка
//  ОписаниеОповещенияОЗакрытии - ОписаниеОповещения. 
Процедура ВыбратьКонтрагента(РеквизитыОтбораКонтрагента, ОписаниеОповещенияОЗакрытии) Экспорт
	
	Отбор = Новый Структура;
	Если ЗначениеЗаполнено(РеквизитыОтбораКонтрагента.Наименование) Тогда
		Отбор.Вставить("Наименование", РеквизитыОтбораКонтрагента.Наименование);
	КонецЕсли;
	Если ЗначениеЗаполнено(РеквизитыОтбораКонтрагента.ИНН) Тогда
		Отбор.Вставить("ИНН", РеквизитыОтбораКонтрагента.ИНН);
	КонецЕсли;
	Если ЗначениеЗаполнено(РеквизитыОтбораКонтрагента.КПП) Тогда
		Отбор.Вставить("КПП", РеквизитыОтбораКонтрагента.КПП);
	КонецЕсли;
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Отбор", Отбор);

	ОткрытьФорму("Справочник.Контрагенты.ФормаВыбора", ПараметрыФормы,,,,, ОписаниеОповещенияОЗакрытии);
	
КонецПроцедуры

#Область НоменклатураКонтрагентов

// Обрабатывает выбор номенклатуры контрагента в строке источника (табличной части).
//
// Параметры:
//  ВыбранноеЗначение - Структура - выбранная номенклатура контрагента:
//   * НоменклатураКонтрагента - описание номенклатуры контрагента. См. СопоставлениеНоменклатурыКонтрагентовКлиентСервер.НоваяНоменклатураКонтрагента.
//   * НоменклатураИБ - описание номенклатуры информационной базы. См. СопоставлениеНоменклатурыКонтрагентовКлиентСервер.НоваяНоменклатураИнформационнойБазы.
//  СтрокаИсточника - ДанныеФормыЭлементКоллекции - строка источника, в которой произведен выбор номенклатуры контрагента.
//  ПутьКИдентификатору - Строка - имя колонки с идентификатором номенклатуры контрагента.
//  ПутьКПредставлению - Строка - имя колонки с представлением номенклатуры контрагента.
//
// Возвращаемое значение:
//  Структура - результат обработки выбранного значения:
//   * Идентификатор - Строка - идентификатор номенклатуры контрагента.
//   * Номенклатура - СправочникСсылка.Номенклатура - номенклатура.
//   * Характеристика - СправочникСсылка.ХарактеристикиНоменклатуры - характеристика.
//   * ЕдиницаИзмерения - СправочникСсылка.ЕдиницыИзмерения - единица измерения.
//
Функция ОбработатьВыборНоменклатурыКонтрагентаВСтрокеИсточника(ВыбранноеЗначение, СтрокаИсточника, ПутьКИдентификатору, ПутьКПредставлению) Экспорт
	
	Если ВыбранноеЗначение = Неопределено Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Результат = Новый Структура;
	Результат.Вставить("Идентификатор", ВыбранноеЗначение.НоменклатураКонтрагента.Идентификатор);
	
	Представление = ОбменСКонтрагентамиРТКлиентСервер.ПредставлениеНоменклатурыКонтрагента(ВыбранноеЗначение.НоменклатураКонтрагента);
	Результат.Вставить("Представление", Представление);
	
	СтрокаИсточника[ПутьКИдентификатору] = Результат.Идентификатор;
	СтрокаИсточника[ПутьКПредставлению] = Результат.Представление;
	
	Возврат Результат;
	
КонецФункции

// Обрабатывает изменение номенклатуры контрагента в строке источника (табличной части).
//
// Параметры:
//  СтрокаИсточника - ДанныеФормыЭлементКоллекции - строка источника, в которой произведено изменение номенклатуры контрагента.
//  ПутьКИдентификатору - Строка - имя колонки с идентификатором номенклатуры контрагента.
//  ПутьКПредставлению - Строка - имя колонки с представлением номенклатуры контрагента.
//
Процедура ПриИзмененииПредставленияНоменклатурыКонтрагентаВСтрокеИсточника(СтрокаИсточника, ПутьКИдентификатору, ПутьКПредставлению) Экспорт
	
	Если СтрокаИсточника = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(СтрокаИсточника[ПутьКПредставлению]) Тогда
		СтрокаИсточника[ПутьКИдентификатору] = "";
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти
