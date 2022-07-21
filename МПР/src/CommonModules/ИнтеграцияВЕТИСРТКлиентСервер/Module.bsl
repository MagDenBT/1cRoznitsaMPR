#Область ПрограммныйИнтерфейс

#Область ИсходящаяТранспортнаяОперацияВЕТИС

// Заполняет структуру команд для динамического формирования доступных для создания документов на основании.
// 
// Параметры:
// 	Команды - Структура - Исходящий, структура команд динамически формируемых для создания документов на основании.
//
Процедура КомандыИсходящейТранспортнойОперации(Команды) Экспорт 
	
	ПодключаемыеКомандыИСКлиентСервер.ДобавитьКомандуОформить(Команды,"РеализацияТоваров",        НСтр("ru = 'Реализацию товаров';"));
	ПодключаемыеКомандыИСКлиентСервер.ДобавитьКомандуОформить(Команды,"ВозвратТоваровПоставщику", НСтр("ru = 'Возврат товаров поставщику';"));
	ПодключаемыеКомандыИСКлиентСервер.ДобавитьКомандуОформить(Команды,"ПеремещениеТоваров",       НСтр("ru = 'Перемещение товаров';"));
	
	ПодключаемыеКомандыИСКлиентСервер.ДобавитьКомандуВыбрать(Команды,"РеализацияТоваров",    НСтр("ru = 'Реализацию товаров';"));
	ПодключаемыеКомандыИСКлиентСервер.ДобавитьКомандуВыбрать(Команды,"ВозвратТоваровПоставщику",  НСтр("ru = 'Возврат товаров поставщику';"));
	ПодключаемыеКомандыИСКлиентСервер.ДобавитьКомандуВыбрать(Команды,"ПеремещениеТоваров",        НСтр("ru = 'Перемещение товаров';"));
	
КонецПроцедуры

// Устанавливает видимость команд динамически формируемых для создания документов на основании.
// 
// Параметры:
// 	Форма   - УправляемаяФорма - Форма на которой находятся вызова команд.
// 	Команды - Структура - структура команд динамически формируемых для создания документов на основании.
//
Процедура УправлениеВидимостьюКомандИсходящейТранспортнойОперации(Форма, Команды) Экспорт
	
	Если ПодключаемыеКомандыИСКлиентСервер.УправлениеВидимостьюПоУмолчанию(Форма) Тогда
		Возврат;
	КонецЕсли;
	
	ВариантОднаОрганизация = Ложь;
	ВариантОрганизации = Ложь;
	ВариантКонтрагенты = Ложь;
	Отправителей = 0;
	Для Каждого ЭлементСписка Из Форма.ГрузоотправительСопоставлениеХСДляОтбораОснований Цикл
		Если ЗначениеЗаполнено(ЭлементСписка.Значение) Тогда
			Если Форма.ГрузополучательСопоставлениеХСДляОтбораОснований.НайтиПоЗначению(ЭлементСписка.Значение)<>Неопределено Тогда
				ВариантОднаОрганизация = Истина;
			КонецЕсли;
			Отправителей = Отправителей + 1;
		КонецЕсли;
	КонецЦикла;
	Для Каждого ЭлементСписка Из Форма.ГрузополучательСопоставлениеХСДляОтбораОснований Цикл
		Если ТипЗнч(ЭлементСписка.Значение) = Тип("СправочникСсылка.Организации") 
			И (Отправителей > 1 Или Форма.ГрузоотправительСопоставлениеХСДляОтбораОснований.НайтиПоЗначению(ЭлементСписка.Значение)<>Неопределено) Тогда
				ВариантОрганизации = Истина;
		КонецЕсли;
		Если ТипЗнч(ЭлементСписка.Значение) <> Тип("СправочникСсылка.Организации") Тогда
			ВариантКонтрагенты = Истина;
		КонецЕсли;
	КонецЦикла;
	Если Не (ВариантОднаОрганизация Или ВариантОрганизации) Тогда
		ВариантКонтрагенты = Истина;
	КонецЕсли;
	
	Для Каждого КлючИЗначение Из Форма.ВидимостьПодключаемыхКоманд Цикл
		
		Если КлючИЗначение.Значение.ИмяМетаданных = "ПеремещениеТоваров" Тогда
			Форма.Элементы[КлючИЗначение.Ключ].Видимость = ВариантОднаОрганизация ИЛИ ВариантОрганизации;
		Иначе 
			Форма.Элементы[КлючИЗначение.Ключ].Видимость = ВариантКонтрагенты;
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область ВходящаяТранспортнаяОперацияВЕТИС

// Заполняет структуру команд для динамического формирования доступных для создания документов на основании.
// 
// Параметры:
// 	Команды - Структура - Исходящий, структура команд динамически формируемых для создания документов на основании.
//
Процедура КомандыВходящейТранспортнойОперации(Команды) Экспорт 
	
	ПодключаемыеКомандыИСКлиентСервер.ДобавитьКомандуОформить(Команды,"ПоступлениеТоваров",          НСтр("ru = 'Поступление товаров';"));
	ПодключаемыеКомандыИСКлиентСервер.ДобавитьКомандуОформить(Команды,"ВозвратТоваровОтПокупателя",  НСтр("ru = 'Возврат товаров от покупателя';"));
	
	ПодключаемыеКомандыИСКлиентСервер.ДобавитьКомандуВыбрать(Команды,"ПоступлениеТоваров",          НСтр("ru = 'Поступление товаров';"));
	ПодключаемыеКомандыИСКлиентСервер.ДобавитьКомандуВыбрать(Команды,"ВозвратТоваровОтПокупателя",  НСтр("ru = 'Возврат товаров от покупателя';"));
	ПодключаемыеКомандыИСКлиентСервер.ДобавитьКомандуВыбрать(Команды,"ПеремещениеТоваров",          НСтр("ru = 'Перемещение товаров';"));
	
КонецПроцедуры

#Область ИнвентаризацияПродукцииВЕТИС

// Заполняет структуру команд для динамического формирования доступных для создания документов на основании.
// 
// Параметры:
// 	Команды - Структура - Исходящий, структура команд динамически формируемых для создания документов на основании.
//
Процедура КомандыИнвентаризацииПродукции(Команды) Экспорт 
	
	ПодключаемыеКомандыИСКлиентСервер.ДобавитьКомандуОформить(Команды, "СписаниеТоваров",      НСтр("ru = 'Списание товаров';"));
	ПодключаемыеКомандыИСКлиентСервер.ДобавитьКомандуОформить(Команды, "ОприходованиеТоваров", НСтр("ru = 'Оприходование товаров';"));
	
	ПодключаемыеКомандыИСКлиентСервер.ДобавитьКомандуВыбрать(Команды, "СписаниеТоваров",      НСтр("ru = 'Списание товаров';"));
	ПодключаемыеКомандыИСКлиентСервер.ДобавитьКомандуВыбрать(Команды, "ОприходованиеТоваров", НСтр("ru = 'Оприходование товаров';"));
	ПодключаемыеКомандыИСКлиентСервер.ДобавитьКомандуВыбрать(Команды, "ПересортицаТоваров",   НСтр("ru = 'Пересортица товаров';"));
	
КонецПроцедуры

// Устанавливает видимость команд динамически формируемых для создания документов на основании.
// 
// Параметры:
// 	Форма   - УправляемаяФорма - Форма на которой находятся вызова команд.
// 	Команды - Структура - структура команд динамически формируемых для создания документов на основании.
//
Процедура УправлениеВидимостьюКомандИнвентаризацииПродукции(Форма, Команды) Экспорт
	
	Если ПодключаемыеКомандыИСКлиентСервер.УправлениеВидимостьюПоУмолчанию(Форма) Тогда
		Возврат;
	КонецЕсли;
	
	ЕстьРасход = Ложь;
	ЕстьПриход = Ложь;
	Для Каждого СтрокаТЧ Из Форма.Объект.Товары Цикл
		Если СтрокаТЧ.КоличествоИзменениеВЕТИС<0 Тогда 
			ЕстьРасход = Истина;
		ИначеЕсли СтрокаТЧ.КоличествоИзменениеВЕТИС>0 Тогда 
			ЕстьПриход = Истина;
		КонецЕсли;
	КонецЦикла;
	
	Для Каждого КлючИЗначение Из Форма.ВидимостьПодключаемыхКоманд Цикл
		Если ЗначениеЗаполнено(Форма.Объект.ДокументОснование)Тогда
			Форма.Элементы[КлючИЗначение.Ключ].Видимость = Ложь;
		ИначеЕсли КлючИЗначение.Значение.ИмяМетаданных = "ПересортицаТоваров" Тогда
			Форма.Элементы[КлючИЗначение.Ключ].Видимость = ЕстьПриход = ЕстьРасход;
		ИначеЕсли КлючИЗначение.Значение.ИмяМетаданных = "ОприходованиеТоваров" Тогда
			Форма.Элементы[КлючИЗначение.Ключ].Видимость = НЕ ЕстьРасход;
		Иначе
			Форма.Элементы[КлючИЗначение.Ключ].Видимость = НЕ ЕстьПриход;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

// Устанавливает видимость команд динамически формируемых для создания документов на основании.
// 
// Параметры:
// 	Форма   - УправляемаяФорма - Форма на которой находятся вызова команд.
// 	Команды - Структура - структура команд динамически формируемых для создания документов на основании.
//
Процедура УправлениеВидимостьюКомандВходящейТранспортнойОперации(Форма, Команды) Экспорт
	
	Если ПодключаемыеКомандыИСКлиентСервер.УправлениеВидимостьюПоУмолчанию(Форма) Тогда
		Возврат;
	КонецЕсли;
		
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

//См. ИнтеграцияВЕТИСКлиентСерверПереопределяемый.ЗаполнитьСоответствиеПолейДокументовОснованийИИсходящейТранспортнойОперации
// Заполняет соответствие полей документов-оснований и исходящей транспортной операции
// 
// Возвращаемое значение:
//  Соответствие - соответствие со свойствами:
//  * ИмяДокумента — Соответствие — ключом свойства является имя документа, например "РеализацияТоваровУслуг",
//                                  а значением — соответствие со свойствами:
//  ** ГрузоотправительХозяйствующийСубъект — Строка — имя поля документа, которое соответствует контрагенту
//  	                                               хозяйствующего субъекта грузоотправителя
//  ** ГрузоотправительПредприятие — Строка — имя поля документа, которое соответствует предприятию грузоотправителя
//  ** ГрузополучательХозяйствующийСубъект — Строка — имя поля документа, которое соответствует контрагенту
//  	                                              хозяйствующего субъекта грузополучателя
//  ** ГрузополучательПредприятие — Строка — имя поля документа, которое соответствует предприятию грузополучателя
Процедура ЗаполнитьСоответствиеПолейДокументовОснованийИИсходящейТранспортнойОперации(СоответствиеПолей) Экспорт
	
	СоответствиеПолей.Вставить("ВозвратТоваровПоставщику", Новый Соответствие);
	СоответствиеПолей["ВозвратТоваровПоставщику"].Вставить("ГрузоотправительХозяйствующийСубъект", "Организация");
	СоответствиеПолей["ВозвратТоваровПоставщику"].Вставить("ГрузоотправительПредприятие", "Магазин");
	СоответствиеПолей["ВозвратТоваровПоставщику"].Вставить("ГрузополучательХозяйствующийСубъект", "Контрагент");
	СоответствиеПолей["ВозвратТоваровПоставщику"].Вставить("ГрузополучательПредприятие", Неопределено);
	
	СоответствиеПолей.Вставить("ПеремещениеТоваров", Новый Соответствие);
	СоответствиеПолей["ПеремещениеТоваров"].Вставить("ГрузоотправительХозяйствующийСубъект", "Организация");
	СоответствиеПолей["ПеремещениеТоваров"].Вставить("ГрузоотправительПредприятие", "МагазинОтправитель");
	СоответствиеПолей["ПеремещениеТоваров"].Вставить("ГрузополучательХозяйствующийСубъект", "ОрганизацияПолучатель");
	СоответствиеПолей["ПеремещениеТоваров"].Вставить("ГрузополучательПредприятие", "МагазинПолучатель");
	
	СоответствиеПолей.Вставить("РеализацияТоваров", Новый Соответствие);
	СоответствиеПолей["РеализацияТоваров"].Вставить("ГрузоотправительХозяйствующийСубъект", "Организация");
	СоответствиеПолей["РеализацияТоваров"].Вставить("ГрузоотправительПредприятие", "Магазин");
	СоответствиеПолей["РеализацияТоваров"].Вставить("ГрузополучательХозяйствующийСубъект", "Контрагент");
	СоответствиеПолей["РеализацияТоваров"].Вставить("ГрузополучательПредприятие", Неопределено);
	
	СоответствиеПолей.Вставить("ПередачаТоваровМеждуОрганизациями", Новый Соответствие);
	СоответствиеПолей["ПередачаТоваровМеждуОрганизациями"].Вставить("ГрузоотправительХозяйствующийСубъект", "Организация");
	СоответствиеПолей["ПередачаТоваровМеждуОрганизациями"].Вставить("ГрузоотправительПредприятие", "Магазин");
	СоответствиеПолей["ПередачаТоваровМеждуОрганизациями"].Вставить("ГрузополучательХозяйствующийСубъект", "ОрганизацияПолучатель");
	СоответствиеПолей["ПередачаТоваровМеждуОрганизациями"].Вставить("ГрузополучательПредприятие", "Магазин");
	
КонецПроцедуры

//См. ИнтеграцияВЕТИСКлиентСерверПереопределяемый.ЗаполнитьСоответствиеПолейДокументовОснованийИВходящейТранспортнойОперации
// Заполняет соответствие полей документов-оснований и входящей транспортной операции
//
// Возвращаемое значение:
//  Соответствие - соответствие со свойствами:
//  * ИмяДокумента — Соответствие — ключом свойства является имя документа, например "РеализацияТоваровУслуг",
//                                  а значением — соответствие со свойствами:
//  ** ГрузоотправительХозяйствующийСубъект — Строка — имя поля документа, которое соответствует контрагенту
//                                                     хозяйствующего субъекта грузоотправителя
//  ** ГрузоотправительПредприятие — Строка — имя поля документа, которое соответствует предприятию грузоотправителя
//  ** ГрузополучательХозяйствующийСубъект — Строка — имя поля документа, которое соответствует контрагенту
//                                                    хозяйствующего субъекта грузополучателя
//  ** ГрузополучательПредприятие — Строка — имя поля документа, которое соответствует предприятию грузополучателя
Процедура ЗаполнитьСоответствиеПолейДокументовОснованийИВходящейТранспортнойОперации(СоответствиеПолей) Экспорт
	
	СоответствиеПолей.Вставить("ВозвратТоваровОтПокупателя", Новый Соответствие);
	СоответствиеПолей["ВозвратТоваровОтПокупателя"].Вставить("ГрузоотправительХозяйствующийСубъект", "Контрагент");
	СоответствиеПолей["ВозвратТоваровОтПокупателя"].Вставить("ГрузоотправительПредприятие", Неопределено);
	СоответствиеПолей["ВозвратТоваровОтПокупателя"].Вставить("ГрузополучательХозяйствующийСубъект", "Организация");
	СоответствиеПолей["ВозвратТоваровОтПокупателя"].Вставить("ГрузополучательПредприятие", "Магазин");
	
	СоответствиеПолей.Вставить("ПоступлениеТоваров", Новый Соответствие);
	СоответствиеПолей["ПоступлениеТоваров"].Вставить("ГрузоотправительХозяйствующийСубъект", "Контрагент");
	СоответствиеПолей["ПоступлениеТоваров"].Вставить("ГрузоотправительПредприятие", Неопределено);
	СоответствиеПолей["ПоступлениеТоваров"].Вставить("ГрузополучательХозяйствующийСубъект", "Организация");
	СоответствиеПолей["ПоступлениеТоваров"].Вставить("ГрузополучательПредприятие", "Магазин");
	
	СоответствиеПолей.Вставить("ПеремещениеТоваров", Новый Соответствие);
	СоответствиеПолей["ПеремещениеТоваров"].Вставить("ГрузоотправительХозяйствующийСубъект", "Организация");
	СоответствиеПолей["ПеремещениеТоваров"].Вставить("ГрузоотправительПредприятие", "МагазинОтправитель");
	СоответствиеПолей["ПеремещениеТоваров"].Вставить("ГрузополучательХозяйствующийСубъект", "ОрганизацияПолучатель");
	СоответствиеПолей["ПеремещениеТоваров"].Вставить("ГрузополучательПредприятие", "МагазинПолучатель");
	
	СоответствиеПолей.Вставить("ПередачаТоваровМеждуОрганизациями", Новый Соответствие);
	СоответствиеПолей["ПередачаТоваровМеждуОрганизациями"].Вставить("ГрузоотправительХозяйствующийСубъект", "Организация");
	СоответствиеПолей["ПередачаТоваровМеждуОрганизациями"].Вставить("ГрузоотправительПредприятие", "Магазин");
	СоответствиеПолей["ПередачаТоваровМеждуОрганизациями"].Вставить("ГрузополучательХозяйствующийСубъект", "ОрганизацияПолучатель");
	СоответствиеПолей["ПередачаТоваровМеждуОрганизациями"].Вставить("ГрузополучательПредприятие", "Магазин");
	
КонецПроцедуры

//См. ИнтеграцияВЕТИСКлиентСерверПереопределяемый.ЗаполнитьСоответствиеПолейДокументовОснованийИПроизводственнойОперации
// Заполняет соответствие полей документов-оснований и производственных операций
//
// Возвращаемое значение:
//  Соответствие - соответствие со свойствами:
//  * ИмяДокумента — Соответствие — ключом свойства является имя документа, например "СборкаТоваров",
//                                  а значением — соответствие со свойствами:
//  ** ХозяйствующийСубъект — Строка — имя поля документа, которое соответствует хозяйствующему субъекту
//  ** Предприятие — Строка — имя поля документа, которое соответствует предприятию хозяйствующего субъекта
Процедура ЗаполнитьСоответствиеПолейДокументовОснованийИПроизводственнойОперации(СоответствиеПолей) Экспорт
	
	СоответствиеПолей.Вставить("СборкаТоваров", Новый Соответствие);
	СоответствиеПолей["СборкаТоваров"].Вставить("ХозяйствующийСубъект", "Организация");
	СоответствиеПолей["СборкаТоваров"].Вставить("Предприятие", "Магазин");
	
КонецПроцедуры

//См. ИнтеграцияВЕТИСКлиентСерверПереопределяемый.ЗаполнитьСоответствиеПолейДокументовОснованийИИнвентаризацииПродукции
// Заполняет соответствие полей документов-оснований и инвентаризации продукции
//
// Возвращаемое значение:
//  Соответствие - соответствие со свойствами:
//  * ИмяДокумента — Соответствие — ключом свойства является имя документа, например "СписаниеНедостачТоваров",
//                                  а значением — соответствие со свойствами:
//  ** ХозяйствующийСубъект — Строка — имя поля документа, которое соответствует хозяйствующему субъекту
//  ** Предприятие — Строка — имя поля документа, которое соответствует предприятию хозяйствующего субъекта
Процедура ЗаполнитьСоответствиеПолейДокументовОснованийИИнвентаризацииПродукции(СоответствиеПолей) Экспорт
	
	СоответствиеПолей.Вставить("СписаниеТоваров", Новый Соответствие);
	СоответствиеПолей["СписаниеТоваров"].Вставить("ХозяйствующийСубъект", "Организация");
	СоответствиеПолей["СписаниеТоваров"].Вставить("Предприятие", "Магазин");
	
	СоответствиеПолей.Вставить("ПересортицаТоваров", Новый Соответствие);
	СоответствиеПолей["ПересортицаТоваров"].Вставить("ХозяйствующийСубъект", "Организация");
	СоответствиеПолей["ПересортицаТоваров"].Вставить("Предприятие", "Магазин");
	
	СоответствиеПолей.Вставить("ОприходованиеТоваров", Новый Соответствие);
	СоответствиеПолей["ОприходованиеТоваров"].Вставить("ХозяйствующийСубъект", "Организация");
	СоответствиеПолей["ОприходованиеТоваров"].Вставить("Предприятие", "Магазин");
	
КонецПроцедуры

//См. ИнтеграцияВЕТИСКлиентСерверПереопределяемый.ЗаполнитьСтруктуруКэшируемыеЗначения
// Заполняет структуру, содержащую поля кэшируемых значений.
// 
// Параметры:
//   КэшированныеЗначения - (см. ОбработкаТабличнойЧастиКлиентСервер.ПолучитьСтруктуруКэшируемыеЗначения) - результат.
//
Процедура ЗаполнитьСтруктуруКэшируемыеЗначения(КэшированныеЗначения) Экспорт
	
	КэшированныеЗначения = Неопределено;
	
	КэшированныеЗначения = ОбработкаТабличнойЧастиТоварыКлиентСервер.СтруктураКэшируемыхЗначений();
	
КонецПроцедуры

//См. ИнтеграцияВЕТИСКлиентСерверПереопределяемый.ЗаполнитьКоличествоЕдиницВЕТИС
// Пересчитывает количество из базовой единицы измерения номенклатуры в единицу измерения ВЕТИС.
//
Процедура ЗаполнитьКоличествоЕдиницВЕТИС(КоличествоВЕТИС, Количество, Номенклатура, ЕдиницаИзмеренияВЕТИС, КэшированныеЗначения, ТекстОшибки) Экспорт
	
	КоличествоВЕТИС = ПересчитатьКоличествоЕдиницВЕТИС(
		Количество,
		Номенклатура,
		ЕдиницаИзмеренияВЕТИС,
		Истина,
		КэшированныеЗначения,
		ТекстОшибки);
	
КонецПроцедуры

//См. ИнтеграцияВЕТИСКлиентСерверПереопределяемый.ЗаполнитьКоличествоЕдиницПоВЕТИС
// Пересчитывает количество из единицы измерения ВЕТИС в базовую единицу измерения номенклатуры.
//
Процедура ЗаполнитьКоличествоЕдиницПоВЕТИС(Количество, КоличествоВЕТИС, Номенклатура, ЕдиницаИзмеренияВЕТИС, КэшированныеЗначения, ТекстОшибки = Неопределено) Экспорт
	
	Количество = ПересчитатьКоличествоЕдиниц(
		КоличествоВЕТИС,
		Номенклатура,
		ЕдиницаИзмеренияВЕТИС,
		Истина,
		КэшированныеЗначения,
		ТекстОшибки);
	
КонецПроцедуры

#КонецОбласти


#Область Прочее

// Пересчитывает количество из базовой единицы измерения номенклатуры в единицу измерения ВЕТИС.
Функция ПересчитатьКоличествоЕдиницВЕТИС(Количество, Номенклатура, ЕдиницаИзмеренияВЕТИС, НужноОкруглять, КэшированныеЗначения, ТекстОшибки = Неопределено) Экспорт
	
	НовоеКоличествоВЕТИС = Неопределено;
	ТекстОшибки = Неопределено;
	
	Если ЗначениеЗаполнено(Номенклатура) Тогда
		
		ДанныеЕдиницыИзмерения = ОбработкаТабличнойЧастиТоварыКлиентСервер.КоэффициентЕдиницыИзмеренияВЕТИС(
									ЕдиницаИзмеренияВЕТИС, 
									КэшированныеЗначения,
									Номенклатура);
		
		Если ЗначениеЗаполнено(ЕдиницаИзмеренияВЕТИС) Тогда
			
			Если ДанныеЕдиницыИзмерения.КодОшибки <> 0 Тогда
				
				ТекстОшибки = ТекстОшибкиПересчетаЕдиницыИзмеренияВЕТИС(
										ДанныеЕдиницыИзмерения.КодОшибки,
										Номенклатура, 
										ЕдиницаИзмеренияВЕТИС, 
										ДанныеЕдиницыИзмерения.ТипИзмеряемойВеличины);
				
				Возврат Неопределено;
				
			КонецЕсли;
			
			НовоеКоличествоВЕТИС = Количество / ДанныеЕдиницыИзмерения.Коэффициент;
		
			Если НужноОкруглять
				И ДанныеЕдиницыИзмерения.НужноОкруглятьКоличество Тогда
				
				НовоеКоличествоВЕТИС = Окр(НовоеКоличествоВЕТИС, 0, РежимОкругления.Окр15как20);
				
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЕсли;

	Возврат НовоеКоличествоВЕТИС;
	
КонецФункции

// Пересчитывает количество из единицы измерения ВЕТИС в базовую единицу измерения номенклатуры.
Функция ПересчитатьКоличествоЕдиниц(КоличествоВЕТИС, Номенклатура, ЕдиницаИзмеренияВЕТИС, НужноОкруглять, КэшированныеЗначения, ТекстОшибки = Неопределено) Экспорт
	
	НовоеКоличество = Неопределено;
	ТекстОшибки = Неопределено;
	
	Если ЗначениеЗаполнено(Номенклатура) Тогда
		
		ДанныеЕдиницыИзмерения = ОбработкаТабличнойЧастиТоварыКлиентСервер.КоэффициентЕдиницыИзмеренияВЕТИС(
									ЕдиницаИзмеренияВЕТИС, 
									КэшированныеЗначения,
									Номенклатура);
		
		Если ЗначениеЗаполнено(ЕдиницаИзмеренияВЕТИС) Тогда
			
			Если ДанныеЕдиницыИзмерения.КодОшибки <> 0 Тогда
				
				ТекстОшибки = ТекстОшибкиПересчетаЕдиницыИзмеренияВЕТИС(
										ДанныеЕдиницыИзмерения.КодОшибки,
										Номенклатура,
										ЕдиницаИзмеренияВЕТИС,
										ДанныеЕдиницыИзмерения.ТипИзмеряемойВеличины,
										"ВЕТИС");
				
				Возврат Неопределено;
				
			КонецЕсли;
			
			НовоеКоличество = КоличествоВЕТИС * ДанныеЕдиницыИзмерения.Коэффициент;
			
			Если НужноОкруглять
				И ДанныеЕдиницыИзмерения.НужноОкруглятьКоличество Тогда
				
				НовоеКоличество = Окр(НовоеКоличество, 0, РежимОкругления.Окр15как20);
				
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЕсли;

	Возврат НовоеКоличество;
	
КонецФункции

#КонецОбласти


#Область СлужебныеПроцедурыИФункции

Функция ТекстОшибкиПересчетаЕдиницыИзмеренияВЕТИС(КодОшибки, Номенклатура, ЕдиницаИзмеренияВЕТИС, ТипИзмеряемойВеличины, СуффиксКоличества = "")
	
	ПересчетВЕТИС        = СокрЛП(СуффиксКоличества) = "ВЕТИС";
	ТекстЕдиницыХранения = ?(ПересчетВЕТИС, НСтр("ru = 'в единицу хранения'"), НСтр("ru = 'количества (ВетИС)'"));
	
	ШаблонСообщенияНеЗаполненаЕдиницаИзмерения    = НСтр("ru = 'Не удалось выполнить пересчет %ЕдиницаХранения%, т.к. не заполнено поле ""Единица измерения"" в карточке единицы измерения ВетИС ""%ЕдиницаИзмеренияВЕТИС%""'");
	ШаблонСообщенияНеУказанТипИзмеряемойВеличины  = НСтр("ru = 'Не удалось выполнить пересчет %ЕдиницаХранения%, т.к. в карточке номенклатуры ""%Номенклатура%"" выключена возможность указания количества в единицах измерения %ТипИзмеряемойВеличины%'");
	ШаблонСообщенияНеСопоставленыЕдиницыИзмерения = НСтр("ru = 'Не удалось выполнить пересчет %ЕдиницаХранения%. Приведите в соответствие единицу измерения в карточке единицы измерения ВетИС ""%ЕдиницаИзмеренияВЕТИС%"" с единицей хранения номенклатуры ""%Номенклатура%"" или укажите %ТипКоличества% вручную'");
	
	Если КодОшибки = 1 Тогда
		ТекстСообщения = ШаблонСообщенияНеЗаполненаЕдиницаИзмерения;
		ТекстСообщения = СтрЗаменить(ТекстСообщения, "%ЕдиницаХранения%",       ТекстЕдиницыХранения);
		ТекстСообщения = СтрЗаменить(ТекстСообщения, "%ЕдиницаИзмеренияВЕТИС%", Строка(ЕдиницаИзмеренияВЕТИС));
	ИначеЕсли КодОшибки = 3 Тогда
		ТекстТипаКоличества = ?(ПересчетВЕТИС, НСтр("ru = 'количество'"), НСтр("ru = 'количество (ВетИС)'"));
		
		ТекстСообщения = ШаблонСообщенияНеСопоставленыЕдиницыИзмерения;
		ТекстСообщения = СтрЗаменить(ТекстСообщения, "%ЕдиницаХранения%",       ТекстЕдиницыХранения);
		ТекстСообщения = СтрЗаменить(ТекстСообщения, "%ЕдиницаИзмеренияВЕТИС%", Строка(ЕдиницаИзмеренияВЕТИС));
		ТекстСообщения = СтрЗаменить(ТекстСообщения, "%Номенклатура%",          Строка(Номенклатура));
		ТекстСообщения = СтрЗаменить(ТекстСообщения, "%ТипКоличества%",          Строка(Номенклатура));
	Иначе
		ТекстСообщения = "";
	КонецЕсли;
	
	Возврат ТекстСообщения;
	
КонецФункции

#КонецОбласти
