#Область СлужебныйПрограммныйИнтерфейс

// Дополняет параметры сканирования свойствами специфичными для табачной продукции.
//
// Параметры:
// 	ПараметрыСканирования - См. ШтрихкодированиеИСКлиент.ПараметрыСканирования.
// 	ВидПродукции          - ПеречислениеСсылка.ВидыПродукцииИС - Вид продукции.
// Возвращаемое значение:
// 	Булево - поддержка табачной продукции включена.
Функция ВключитьПоддержкуТабачнойПродукции(ПараметрыСканирования, ВидПродукции = Неопределено) Экспорт
	
	Если ЗначениеЗаполнено(ВидПродукции) И Не ИнтеграцияИСКлиентСервер.ЭтоПродукцияМОТП(ВидПродукции) Тогда
		Возврат Ложь;
	КонецЕсли;
	
	ВидыПродукцииМОТП = ИнтеграцияИСМПКлиентСерверПовтИсп.УчитываемыеВидыМаркируемойПродукции(Ложь);
	Если ВидыПродукцииМОТП.Количество() = 0 Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Если ВидПродукции = Неопределено Тогда
		ОбщегоНазначенияКлиентСервер.ДополнитьМассив(ПараметрыСканирования.ДопустимыеВидыПродукции, ВидыПродукцииМОТП, Истина);
	ИначеЕсли ВидыПродукцииМОТП.Найти(ВидПродукции) = Неопределено Тогда
		Возврат Ложь;
	Иначе
		ПараметрыСканирования.ДопустимыеВидыПродукции.Добавить(ВидПродукции);
	КонецЕсли;
	
	ПараметрыСканирования.Вставить("ДатаПроизводстваНачалаКонтроляСтатусовКодовМаркировкиМОТП", ПроверкаИПодборПродукцииМОТПКлиентСервер.ДатаНачалаКонтроляКодовМаркировки());
	ПараметрыСканирования.Вставить("ДопустимыеСтатусыМОТП",                                 Новый Массив);
	ПараметрыСканирования.Вставить("ДопустимыеСтатусыУпаковокМОТП",                         Новый Массив);
	ПараметрыСканирования.Вставить("ВариантПолученияМРЦ",                                   "Вычисление");
	ПараметрыСканирования.Вставить("КонтролироватьРасхождениеСоставаУпаковокМеждуИБиИСМП",  Ложь);
	
	ПараметрыСканирования.Вставить("ДопустимыПроверкиСеройЗоныМОТП",                                     Ложь);
	ПараметрыСканирования.Вставить("ПроверятьПотребительскиеУпаковкиНаВхождениеВСеруюЗонуМОТП",          Ложь);
	ПараметрыСканирования.Вставить("ПроверятьЛогистическиеИГрупповыеУпаковкиНаСодержаниеСерыхКодовМОТП", Ложь);
	
	ШтрихкодированиеИСМПКлиентСервер.ДополнитьПараметрамиСканированияИСМП(ПараметрыСканирования);
	
	ДляВидаПродукцииСуществуетМРЦ = ПараметрыСканирования.ДопустимыеВидыПродукции.Найти(
		ПредопределенноеЗначение("Перечисление.ВидыПродукцииИС.Табак")) <> Неопределено;
	
	Если ПараметрыСканирования.ЗапрашиватьДанныеСервисаИСМП
		И ДляВидаПродукцииСуществуетМРЦ Тогда
		ПараметрыСканирования.ВариантПолученияМРЦ = "ВычислениеИЗапрос";
	Иначе
		ПараметрыСканирования.ВариантПолученияМРЦ = "Вычисление";
	КонецЕсли;
	
	Возврат Истина;
	
КонецФункции

// Заполняет параметры сканирования по контексту.
// 
// Параметры:
//  ПараметрыСканирования - (См. ШтрихкодированиеИСКлиент.ПараметрыСканирования).
//  Контекст - ФормаКлиентскогоПриложения, ДокументСсылка - источник заполнения параметров сканирования.
//  ВидПродукции - ПеречислениеСсылка.ВидыПродукцииИС - по данному параметру будет проиходить отбор заполнения.
//  ФормаВыбора - ФормаКлиентскогоПриложения - Форма выбора.
Процедура ЗаполнитьПараметрыСканирования(ПараметрыСканирования, Контекст, ВидПродукции, ФормаВыбора) Экспорт

	Если ЗначениеЗаполнено(ВидПродукции) И Не ИнтеграцияИСКлиентСервер.ЭтоПродукцияМОТП(ВидПродукции) Тогда
		Возврат;
	ИначеЕсли ЗначениеЗаполнено(ВидПродукции) И Контекст = Неопределено Тогда
		ВключитьПоддержкуТабачнойПродукции(ПараметрыСканирования);
		Возврат;
	КонецЕсли;
	
	Если ШтрихкодированиеИСКлиентСервер.ЭтоКонтекстОбъекта(Контекст, "Документ.МаркировкаТоваровИСМП") Тогда
		
		ЗаполнитьПараметрыСканированияМаркировкаТоваров(Контекст, ПараметрыСканирования);
		
	ИначеЕсли ШтрихкодированиеИСКлиентСервер.ЭтоКонтекстОбъекта(Контекст, "Документ.СписаниеКодовМаркировкиИСМП") Тогда
		
		ЗаполнитьПараметрыСканированияСписаниеКодовМаркировки(Контекст, ПараметрыСканирования);
		
	ИначеЕсли ШтрихкодированиеИСКлиентСервер.ЭтоКонтекстОбъекта(Контекст, "Документ.ПеремаркировкаТоваровИСМП") Тогда
		
		ЗаполнитьПараметрыСканированияПеремаркировкаТоваров(Контекст, ПараметрыСканирования);
		
	ИначеЕсли ШтрихкодированиеИСКлиентСервер.ЭтоКонтекстОбъекта(Контекст, "Документ.ВозвратВОборотИСМП") Тогда
		
		ЗаполнитьПараметрыСканированияВозвратаВОборот(Контекст, ПараметрыСканирования);
		
	ИначеЕсли ШтрихкодированиеИСКлиентСервер.ЭтоКонтекстОбъекта(Контекст, "Документ.ВыводИзОборотаИСМП") Тогда
		
		ЗаполнитьПараметрыСканированияВыводаИзОборота(Контекст, ПараметрыСканирования);
		
	ИначеЕсли ШтрихкодированиеИСКлиентСервер.ЭтоКонтекстОбъекта(Контекст, "Документ.ЗаказНаЭмиссиюКодовМаркировкиСУЗ") Тогда
		
		ЗаполнитьПараметрыСканированияЗаказНаЭмиссиюКодовМаркировкиСУЗ(Контекст, ПараметрыСканирования);
		
	ИначеЕсли ШтрихкодированиеИСКлиентСервер.ЭтоКонтекстОбъекта(Контекст, "Обработка.ПроверкаИПодборТабачнойПродукцииМОТП") Тогда
		
		ВключитьПоддержкуТабачнойПродукции(ПараметрыСканирования);
		
		ПараметрыСканирования.ИмяТабличнойЧастиШтрихкодыУпаковок = Неопределено;
		ПараметрыСканирования.ИмяКолонкиШтрихкодУпаковки         = Неопределено;
		
		ПараметрыСканирования.ТолькоМаркируемаяПродукция = Истина;
	
	ИначеЕсли ШтрихкодированиеИСКлиентСервер.ЭтоКонтекстОбъекта(Контекст, "Обработка.ПроверкаКодовМаркировкиИСМП") Тогда
		
		ЗаполнитьПараметрыСканированияПроверкаКодовМаркировки(Контекст, ПараметрыСканирования);
		
	КонецЕсли;
	
КонецПроцедуры

// Вычисляет штрихкод EAN из GTIN.
// 
// Параметры:
// 	GTIN - Строка - GTIN.
// Возвращаемое значение:
// 	Строка - Вычисленное значение EAN.
Функция ШтрихкодEANИзGTIN(GTIN) Экспорт
	
	Возврат ШтрихкодированиеИСКлиентСервер.ШтрихкодEANИзGTIN(GTIN);
	
КонецФункции

// Устарел. Используется См. ИнтерфейсМОТП.ЗначениеМРЦСтрокой
// Формирует МРЦ для блока.
// 
// Параметры:
//  МРЦ - Число - Максимальная розничная цена.
// Возвращаемое значение:
//  Строка - МРЦ блока.
Функция ЗначениеМРЦДляБлока(МРЦ) Экспорт
	
	СтрокаМРЦ = Формат(МРЦ * 100, "ЧГ=0;"); // МРЦ в копейках
	Пока СтрДлина(СтрокаМРЦ) < 6 Цикл
		СтрокаМРЦ = "0" + СтрокаМРЦ;
	КонецЦикла;
	
	Возврат СтрокаМРЦ;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Дополняются свойства параметров сканирования и заполняются значения для документа "Маркировка товаров ИСМП".
//
// Параметры:
//  Контекст - ФормаКлиентскогоПриложения, ДокументСсылка, СправочникСсылка - Контекст.
//  ПараметрыСканирования - (См. ШтрихкодированиеИСКлиент.ПараметрыСканирования).
//  ВидПродукции - ПеречислениеСсылка.ВидыПродукцииИС - Вид продукции ИС.
Процедура ЗаполнитьПараметрыСканированияМаркировкаТоваров(Контекст, ПараметрыСканирования)
	
	Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(Контекст, "Объект") Тогда
		ИсточникДанных = Контекст.Объект;
	Иначе
		ИсточникДанных = Контекст;
	КонецЕсли;
	
	ВидПродукции = ИсточникДанных.ВидПродукции;
	Операция     = ИсточникДанных.Операция;
	
	ПараметрыСканирования.ИмяТабличнойЧастиШтрихкодыУпаковок = "ШтрихкодыУпаковок";
	ПараметрыСканирования.ИмяКолонкиШтрихкодУпаковки         = "ШтрихкодУпаковки";
	
	Если Не ВключитьПоддержкуТабачнойПродукции(ПараметрыСканирования, ВидПродукции) Тогда
		Возврат;
	КонецЕсли;

	ПараметрыСканирования.ВариантПолученияМРЦ = "Вычисление";
	
	ПараметрыСканирования.ДопустимыеСтатусыМОТП.Добавить(ПредопределенноеЗначение("Перечисление.СтатусыКодовМаркировкиМОТП.Эмитирован"));
	
	ОперацииМаркировки = ИнтеграцияИСМПСлужебныйКлиентСервер.ОперацииМаркировки(Операция);
	
	Если Не (ОперацииМаркировки.ЭтоОперацияНанесения Или ЗначениеЗаполнено(ИсточникДанных.ОперацияНанесения)) Тогда
		
		ПараметрыСканирования.ДопустимыеСтатусыМОТП.Добавить(ПредопределенноеЗначение("Перечисление.СтатусыКодовМаркировкиМОТП.Нанесен"));
		ПараметрыСканирования.ДопустимыеСтатусыМОТП.Добавить(ПредопределенноеЗначение("Перечисление.СтатусыКодовМаркировкиМОТП.НанесенОплачен"));
		ПараметрыСканирования.ДопустимыеСтатусыМОТП.Добавить(ПредопределенноеЗначение("Перечисление.СтатусыКодовМаркировкиМОТП.НанесенНеОплачен"));
		
		ПараметрыСканирования.ДопустимыеСтатусыУпаковокМОТП.Добавить(ПредопределенноеЗначение("Перечисление.СтатусыКодовМаркировкиМОТП.Нанесен"));
		
	КонецЕсли;
	
	ПараметрыСканирования.ДопустимыеСтатусыУпаковокМОТП.Добавить(ПредопределенноеЗначение("Перечисление.СтатусыКодовМаркировкиМОТП.Эмитирован"));
	
	ПараметрыСканирования.ДоступнаПечатьЭтикеток                         = Истина;
	ПараметрыСканирования.ИспользуютсяДанныеВыбораПоМаркируемойПродукции = Истина;
	ПараметрыСканирования.ТолькоМаркируемаяПродукция                     = Истина;
	ПараметрыСканирования.КонтрольПустыхУпаковок                         = Ложь;
	ПараметрыСканирования.ПоддерживаютсяОперацииАгрегации                = Истина;
	ПараметрыСканирования.КонтролироватьСтандартнуюВложенность           = Ложь;
	
	ПараметрыСканирования.КонтрольРасхожденийСДокументомОснованием       = Истина;
	ПараметрыСканирования.ВозможнаЗагрузкаТСД                            = Истина;
	ПараметрыСканирования.РазрешенаОбработкаКодовСПустойНоменклатурой    = Истина;
	
	ПараметрыСканирования.Организация       = ИсточникДанных.Организация;
	ПараметрыСканирования.Владелец          = ИсточникДанных.Организация;
	ПараметрыСканирования.ДокументОснование = ИсточникДанных.ДокументОснование;
	
	Если Операция = ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.Агрегация") Тогда
		ПараметрыСканирования.ЭтоАгрегацияКодовМаркировкиИСМП = Истина;
	КонецЕсли;
	
	Если ОперацииМаркировки.ЭтоОперацияНанесения
		Или ЗначениеЗаполнено(ИсточникДанных.ОперацияНанесения) Тогда
		
		ПараметрыСканирования.СохранятьКодыМаркировкиВПулИСМП  = Истина;
		ПараметрыСканирования.ТребоватьПолныйКодМаркировкиИСМП = Истина;
		
	КонецЕсли;
	
	// Для обогащения информации об ошибке при выводе пользователю
	ПараметрыСканирования.ВидОперацииИСМП = Операция;
	
	НастроитьПараметрыСканированияПоРаздельномуКонтролю(ПараметрыСканирования, ВидПродукции);
	
КонецПроцедуры

// Дополняются свойства параметров сканирования и заполняются значения для документа "Списание кодов маркировки".
//
// Параметры:
//  Контекст - ФормаКлиентскогоПриложения, ДокументСсылка, СправочникСсылка - Контекст.
//  ПараметрыСканирования - (См. ШтрихкодированиеИСКлиент.ПараметрыСканирования).
//  ВидПродукции - ПеречислениеСсылка.ВидыПродукцииИС - Вид продукции ИС.
Процедура ЗаполнитьПараметрыСканированияСписаниеКодовМаркировки(Контекст, ПараметрыСканирования)
	
	Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(Контекст, "Объект") Тогда
		ИсточникДанных = Контекст.Объект;
	Иначе
		ИсточникДанных = Контекст;
	КонецЕсли;
	
	ВидПродукции = ИсточникДанных.ВидПродукции;
	
	ПараметрыСканирования.ИмяТабличнойЧастиШтрихкодыУпаковок = "ШтрихкодыУпаковок";
	ПараметрыСканирования.ИмяКолонкиШтрихкодУпаковки         = "ШтрихкодУпаковки";
	
	Если Не ВключитьПоддержкуТабачнойПродукции(ПараметрыСканирования, ВидПродукции) Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыСканирования.ДопустимыеСтатусыМОТП.Добавить(ПредопределенноеЗначение("Перечисление.СтатусыКодовМаркировкиМОТП.Нанесен"));
	ПараметрыСканирования.ДопустимыеСтатусыМОТП.Добавить(ПредопределенноеЗначение("Перечисление.СтатусыКодовМаркировкиМОТП.НанесенОплачен"));
	ПараметрыСканирования.ДопустимыеСтатусыМОТП.Добавить(ПредопределенноеЗначение("Перечисление.СтатусыКодовМаркировкиМОТП.НанесенНеОплачен"));
	ПараметрыСканирования.ДопустимыеСтатусыМОТП.Добавить(ПредопределенноеЗначение("Перечисление.СтатусыКодовМаркировкиМОТП.Эмитирован"));
	
	ПараметрыСканирования.ДопустимыеСтатусыУпаковокМОТП.Добавить(ПредопределенноеЗначение("Перечисление.СтатусыКодовМаркировкиМОТП.Нанесен"));
	ПараметрыСканирования.ДопустимыеСтатусыУпаковокМОТП.Добавить(ПредопределенноеЗначение("Перечисление.СтатусыКодовМаркировкиМОТП.НанесенОплачен"));
	ПараметрыСканирования.ДопустимыеСтатусыУпаковокМОТП.Добавить(ПредопределенноеЗначение("Перечисление.СтатусыКодовМаркировкиМОТП.НанесенНеОплачен"));
	ПараметрыСканирования.ДопустимыеСтатусыУпаковокМОТП.Добавить(ПредопределенноеЗначение("Перечисление.СтатусыКодовМаркировкиМОТП.Эмитирован"));
	
	ПараметрыСканирования.ТолькоМаркируемаяПродукция                  = Истина;
	ПараметрыСканирования.КонтрольПустыхУпаковок                      = Ложь;
	ПараметрыСканирования.ПоддерживаютсяОперацииАгрегации             = Ложь;
	ПараметрыСканирования.КонтролироватьСтандартнуюВложенность        = Ложь;
	ПараметрыСканирования.РазрешенаОбработкаКодовСПустойНоменклатурой = Истина;
	
	ПараметрыСканирования.ИспользуютсяДанныеВыбораПоМаркируемойПродукции = Истина;
	ПараметрыСканирования.ЗапрашиватьДанныеНеизвестныхУпаковокИСМП       = Истина;
	
	ПараметрыСканирования.Организация = ИсточникДанных.Организация;
	
	// Для обогащения информации об ошибке при выводе пользователю
	ПараметрыСканирования.ВидОперацииИСМП = ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.СписаниеЭмитированныхКодовМаркировки");
	
	ПараметрыСканирования.СохранятьКодыМаркировкиВПулИСМП  = Истина;
	ПараметрыСканирования.ТребоватьПолныйКодМаркировкиИСМП = Истина;
	
	НастроитьПараметрыСканированияПоРаздельномуКонтролю(ПараметрыСканирования, ВидПродукции);
	
КонецПроцедуры

// Дополняются свойства параметров сканирования и заполняются значения для документа "Перемаркировка ИСМП".
//
// Параметры:
//  Контекст - ФормаУправляемогоПриложения, ДокументСсылка, СправочникСсылка - Контекст.
//  ПараметрыСканирования - Структура - (См. ШтрихкодированиеИСКлиент.ПараметрыСканирования).
//  ВидПродукции - ПеречислениеСсылка.ВидыПродукцииИС - Вид продукции ИС.
Процедура ЗаполнитьПараметрыСканированияПеремаркировкаТоваров(Контекст, ПараметрыСканирования)
	
	Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(Контекст, "Объект") Тогда
		ИсточникДанных = Контекст.Объект;
	Иначе
		ИсточникДанных = Контекст;
	КонецЕсли;
	
	ВидПродукции = ИсточникДанных.ВидПродукции;
	
	ПараметрыСканирования.ИмяТабличнойЧастиШтрихкодыУпаковок = "Товары";
	ПараметрыСканирования.ИмяКолонкиШтрихкодУпаковки         = "КодМаркировки, НовыйКодМаркировки";
	
	Если Не ВключитьПоддержкуТабачнойПродукции(ПараметрыСканирования, ВидПродукции) Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыСканирования.ТолькоМаркируемаяПродукция = Истина;
	
	ПараметрыСканирования.Организация = ИсточникДанных.Организация;
	
	ПараметрыСканирования.ДопустимыеСтатусыМОТП.Добавить(
		ПредопределенноеЗначение("Перечисление.СтатусыКодовМаркировкиМОТП.ВведенВОборот"));
	
	// Для обогащения информации об ошибке при выводе пользователю
	ПараметрыСканирования.ВидОперацииИСМП = ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.Перемаркировка");
	
	НастроитьПараметрыСканированияПоРаздельномуКонтролю(ПараметрыСканирования, ВидПродукции);
	
КонецПроцедуры

// Дополняются свойства параметров сканирования и заполняются значения для документа "Возврат в оборот ИСМП".
//
// Параметры:
//  Контекст - ФормаУправляемогоПриложения, ДокументСсылка, СправочникСсылка - Контекст.
//  ПараметрыСканирования - Структура - (См. ШтрихкодированиеИСКлиент.ПараметрыСканирования).
//  ВидПродукции - ПеречислениеСсылка.ВидыПродукцииИС - Вид продукции ИС.
Процедура ЗаполнитьПараметрыСканированияВозвратаВОборот(Контекст, ПараметрыСканирования)
	
	Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(Контекст, "Объект") Тогда
		ИсточникДанных = Контекст.Объект;
	Иначе
		ИсточникДанных = Контекст;
	КонецЕсли;
	
	ВидПродукции = ИсточникДанных.ВидПродукции;
	Операция     = ИсточникДанных.Операция;
	
	ПараметрыСканирования.ИмяТабличнойЧастиШтрихкодыУпаковок = "Товары";
	ПараметрыСканирования.ИмяКолонкиШтрихкодУпаковки         = "КодМаркировки";
	
	Если Не ВключитьПоддержкуТабачнойПродукции(ПараметрыСканирования, ВидПродукции) Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыСканирования.ТолькоМаркируемаяПродукция = Истина;
	
	ПараметрыСканирования.Организация = ИсточникДанных.Организация;
	
	ПараметрыСканирования.ДопустимыеСтатусыМОТП.Добавить(
		ПредопределенноеЗначение("Перечисление.СтатусыКодовМаркировкиМОТП.ВыведенИзОборотаПоДоговоруРассрочки"));
	ПараметрыСканирования.ДопустимыеСтатусыМОТП.Добавить(
		ПредопределенноеЗначение("Перечисление.СтатусыКодовМаркировкиМОТП.Продан"));
	ПараметрыСканирования.ДопустимыеСтатусыМОТП.Добавить(
		ПредопределенноеЗначение("Перечисление.СтатусыКодовМаркировкиМОТП.Списан"));
	ПараметрыСканирования.ДопустимыеСтатусыМОТП.Добавить(
		ПредопределенноеЗначение("Перечисление.СтатусыКодовМаркировкиМОТП.Экспортирован"));
	
	ПараметрыСканирования.ДопустимыеСтатусыУпаковокМОТП.Добавить(ПредопределенноеЗначение("Перечисление.СтатусыКодовМаркировкиМОТП.ВыведенИзОборотаПоДоговоруРассрочки"));
	ПараметрыСканирования.ДопустимыеСтатусыУпаковокМОТП.Добавить(ПредопределенноеЗначение("Перечисление.СтатусыКодовМаркировкиМОТП.Продан"));
	ПараметрыСканирования.ДопустимыеСтатусыУпаковокМОТП.Добавить(ПредопределенноеЗначение("Перечисление.СтатусыКодовМаркировкиМОТП.Списан"));
	ПараметрыСканирования.ДопустимыеСтатусыУпаковокМОТП.Добавить(ПредопределенноеЗначение("Перечисление.СтатусыКодовМаркировкиМОТП.Экспортирован"));
	
	// Для обогащения информации об ошибке при выводе пользователю
	ПараметрыСканирования.ВидОперацииИСМП = Операция;
	
	НастроитьПараметрыСканированияПоРаздельномуКонтролю(ПараметрыСканирования, ВидПродукции);
	
КонецПроцедуры

Процедура ЗаполнитьПараметрыСканированияВыводаИзОборота(Контекст, ПараметрыСканирования)
	
	Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(Контекст, "Объект") Тогда
		ИсточникДанных = Контекст.Объект;
	Иначе
		ИсточникДанных = Контекст;
	КонецЕсли;
	
	ВидПродукции = ИсточникДанных.ВидПродукции;
	Операция     = ИсточникДанных.Операция;
	
	ПараметрыСканирования.ИмяТабличнойЧастиШтрихкодыУпаковок = "ШтрихкодыУпаковок";
	ПараметрыСканирования.ИмяКолонкиШтрихкодУпаковки         = "ШтрихкодУпаковки";
	
	Если Не ВключитьПоддержкуТабачнойПродукции(ПараметрыСканирования, ВидПродукции) Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыСканирования.ИспользуютсяДанныеВыбораПоМаркируемойПродукции = Истина;
	ПараметрыСканирования.ТолькоМаркируемаяПродукция                     = Истина;
	
	ПараметрыСканирования.ВозможнаЗагрузкаТСД = Истина;
	
	ПараметрыСканирования.Организация = ИсточникДанных.Организация;
	
	ПараметрыСканирования.ДопустимыеСтатусыМОТП.Добавить(
		ПредопределенноеЗначение("Перечисление.СтатусыКодовМаркировкиМОТП.ВведенВОборот"));
	
	ПараметрыСканирования.ДопустимыеСтатусыУпаковокМОТП.Добавить(ПредопределенноеЗначение("Перечисление.СтатусыКодовМаркировкиМОТП.ВведенВОборот"));
	
	// Для обогащения информации об ошибке при выводе пользователю
	ПараметрыСканирования.ВидОперацииИСМП = Операция;
	
	НастроитьПараметрыСканированияПоРаздельномуКонтролю(ПараметрыСканирования, ВидПродукции);
	
КонецПроцедуры

// Дополняются свойства параметров сканирования и заполняются значения для документа "Заказ на эмиссию кодов маркировки СУЗ".
//
// Параметры:
//  Контекст - ФормаКлиентскогоПриложения, ДокументСсылка, СправочникСсылка - Контекст.
//  ПараметрыСканирования - (См. ШтрихкодированиеИСКлиент.ПараметрыСканирования).
//  ВидПродукции - ПеречислениеСсылка.ВидыПродукцииИС - Вид продукции ИС.
Процедура ЗаполнитьПараметрыСканированияЗаказНаЭмиссиюКодовМаркировкиСУЗ(Контекст, ПараметрыСканирования)
	
	Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(Контекст, "Объект") Тогда
		ИсточникДанных = Контекст.Объект;
	Иначе
		ИсточникДанных = Контекст;
	КонецЕсли;
	
	ВидПродукции = ИсточникДанных.ВидПродукции;
	
	ПараметрыСканирования.ИмяТабличнойЧастиШтрихкодыУпаковок  = Неопределено;
	ПараметрыСканирования.ИмяКолонкиШтрихкодУпаковки          = Неопределено;
	
	Если Не ВключитьПоддержкуТабачнойПродукции(ПараметрыСканирования, ВидПродукции) Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыСканирования.СоздаватьШтрихкодУпаковки           = Ложь;
	ПараметрыСканирования.ТолькоМаркируемаяПродукция          = Истина;
	ПараметрыСканирования.КонтрольУникальностиКодовМаркировки = Ложь;
	ПараметрыСканирования.РазрешенаОбработкаБезУказанияМарки  = Истина;
	ПараметрыСканирования.РазрешеноЗапрашиватьКодМаркировки   = Ложь;
	
	ПараметрыСканирования.ЗапрашиватьДанныеНеизвестныхУпаковокИСМП = Ложь;
	ПараметрыСканирования.ЗапрашиватьДанныеСервисаИСМП             = Ложь;
	
	ПараметрыСканирования.Организация = ИсточникДанных.Организация;
	ПараметрыСканирования.Владелец    = "";
	
	// Для обогащения информации об ошибке при выводе пользователю
	ПараметрыСканирования.ВидОперацииИСМП = ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.ЗаказНаЭмиссиюКодовМаркировки");
	
	НастроитьПараметрыСканированияПоРаздельномуКонтролю(ПараметрыСканирования, ВидПродукции);
	
КонецПроцедуры

// Дополняются свойства параметров сканирования и заполняются значения для РМ "Проверка кодов маркировки".
//
// Параметры:
//  Контекст - ФормаКлиентскогоПриложения, ДокументСсылка, СправочникСсылка - Контекст.
//  ПараметрыСканирования - См. ШтрихкодированиеИСКлиент.ПараметрыСканирования.
Процедура ЗаполнитьПараметрыСканированияПроверкаКодовМаркировки(Контекст, ПараметрыСканирования)
	
	Если Не ВключитьПоддержкуТабачнойПродукции(ПараметрыСканирования) Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыСканирования.ДопустимыеВидыПродукции.Очистить();
	ПараметрыСканирования.ТолькоМаркируемаяПродукция                         = Истина;
	ПараметрыСканирования.РазрешенаОбработкаНеНайденныхЛогистическихУпаковок = Истина;
	ПараметрыСканирования.Владелец                                           = Неопределено;
	ПараметрыСканирования.ЗапрашиватьДанныеСервисаИСМП                       = Истина;
	ПараметрыСканирования.ЗапрашиватьДанныеНеизвестныхУпаковокИСМП           = Истина;
	ПараметрыСканирования.ИмяТабличнойЧастиШтрихкодыУпаковок                 = Неопределено;
	ПараметрыСканирования.ВозможнаЗагрузкаТСД                                = Истина;
	ПараметрыСканирования.РазрешенаОбработкаКодовСПустойНоменклатурой        = Истина;
	ПараметрыСканирования.ИспользуютсяДанныеВыбораПоМаркируемойПродукции     = Истина;
	ПараметрыСканирования.СоздаватьШтрихкодУпаковки                          = Ложь;
	ПараметрыСканирования.СопоставлятьНоменклатуру                           = Ложь;
	ПараметрыСканирования.Организация                                        = Контекст.Организация;
	
	ПараметрыСканирования.ЭтоПроверкаКодовМаркировкиИСМП                                     = Истина;
	ПараметрыСканирования.ОпределениеВидаПродукцииИСМП                                       = Истина;
	ПараметрыСканирования.ВариантПолученияМРЦ                                                = "ВычислениеИЗапрос";
	ПараметрыСканирования.ДопустимыПроверкиСеройЗоныМОТП                                     = Истина;
	ПараметрыСканирования.ПроверятьПотребительскиеУпаковкиНаВхождениеВСеруюЗонуМОТП          = Истина;
	ПараметрыСканирования.ПроверятьЛогистическиеИГрупповыеУпаковкиНаСодержаниеСерыхКодовМОТП = Истина;
	ПараметрыСканирования.ЗаписыватьЛогЗапросовИСМП                          = Истина;
	
КонецПроцедуры

Процедура НастроитьПараметрыСканированияПоРаздельномуКонтролю(ПараметрыСканирования, ВидПродукции) Экспорт
	
	ШтрихкодированиеИСМПКлиентСервер.НастроитьПараметрыСканированияПоРаздельномуКонтролю(
		ПараметрыСканирования,
		ВидПродукции);
	
КонецПроцедуры

Процедура ЗаполнитьДопустимыеНачальныеСтатусыОтчетОНанесении(Статусы) Экспорт
	
	Статусы.Добавить(ПредопределенноеЗначение("Перечисление.СтатусыКодовМаркировкиМОТП.Эмитирован"));
	
КонецПроцедуры

Процедура ЗаполнитьОжидаемыеСтатусыПослеПередачиОтчетаОНанесении(Статусы) Экспорт
	
	Статусы.Добавить(ПредопределенноеЗначение("Перечисление.СтатусыКодовМаркировкиМОТП.Нанесен"));
	Статусы.Добавить(ПредопределенноеЗначение("Перечисление.СтатусыКодовМаркировкиМОТП.НанесенОплачен"));
	Статусы.Добавить(ПредопределенноеЗначение("Перечисление.СтатусыКодовМаркировкиМОТП.НанесенНеОплачен"));
	
КонецПроцедуры

#КонецОбласти