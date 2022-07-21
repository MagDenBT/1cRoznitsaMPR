
#Область РаботаСЕдиницамиИзмерения

// См. СопоставлениеНоменклатурыКонтрагентовПереопределяемый.ВладелецУпаковкиЕдиницыИзмеренияНоменклатура.
Процедура ВладелецУпаковкиЕдиницыИзмеренияНоменклатура(Знач Упаковка, ВладелецНоменклатура) Экспорт
	
	ВладелецНоменклатура = ТипЗнч(Упаковка.Владелец) = Тип("СправочникСсылка.Номенклатура");
	
КонецПроцедуры

#КонецОбласти

#Область РаботаСоСловарем

// См. СопоставлениеНоменклатурыКонтрагентовПереопределяемый.ЗначениеНаименованияДанныхСопоставленияНоменклатурыБЭД.
Процедура ЗначениеНаименованияДанныхСопоставленияНоменклатурыБЭД(Знач СсылкаНаОбъект, ЗначениеНаименования) Экспорт
	
	НаименованиеРеквизита = НаименованиеРеквизитаСопоставленияНоменклатурыБЭД(ТипЗнч(СсылкаНаОбъект));
	
	Если НаименованиеРеквизита = Неопределено Тогда
		Возврат;
	КонецЕсли;
		
	ЗначениеНаименования = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(СсылкаНаОбъект, НаименованиеРеквизита);
	
КонецПроцедуры

// См. СопоставлениеНоменклатурыКонтрагентовПереопределяемый.ЗначенияНаименованийДанныхСопоставленияНоменклатурыБЭД.
Процедура ЗначенияНаименованийДанныхСопоставленияНоменклатурыБЭД(Знач НаборСсылокНаОбъекты, СоответствиеЗначенийНаименований) Экспорт
	
	СоответствиеЗначенийНаименований = Новый Соответствие;
	
	Запрос = Новый Запрос();
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	Номенклатура.Ссылка КАК Ссылка,
	|	Номенклатура.Наименование КАК Наименование
	|ИЗ
	|	Справочник.Номенклатура КАК Номенклатура
	|ГДЕ
	|	Номенклатура.Ссылка В(&НаборСсылок)
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ХарактеристикиНоменклатуры.Ссылка,
	|	ХарактеристикиНоменклатуры.Наименование
	|ИЗ
	|	Справочник.ХарактеристикиНоменклатуры КАК ХарактеристикиНоменклатуры
	|ГДЕ
	|	ХарактеристикиНоменклатуры.Ссылка В(&НаборСсылок)";
	
	Запрос.УстановитьПараметр("НаборСсылок", НаборСсылокНаОбъекты);
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		СоответствиеЗначенийНаименований.Вставить(Выборка.Ссылка, Выборка.Наименование);
	КонецЦикла;
	
КонецПроцедуры

// См. СопоставлениеНоменклатурыКонтрагентовПереопределяемый.ОпределитьНаименованиеТипаОбъектаСопоставленияНоменклатурыБЭД.
Процедура ОпределитьНаименованиеТипаОбъектаСопоставленияНоменклатурыБЭД(Знач СсылкаНаОбъект, НаименованиеТипаОбъекта) Экспорт
	
	ТипСсылкиНаОбъект = ТипЗнч(СсылкаНаОбъект);
	Если ТипСсылкиНаОбъект = Тип("СправочникСсылка.Номенклатура") Тогда
		НаименованиеТипаОбъекта = "Номенклатура";
	ИначеЕсли ТипСсылкиНаОбъект = Тип("СправочникСсылка.ХарактеристикиНоменклатуры") Тогда
		НаименованиеТипаОбъекта = "Характеристика";
	КонецЕсли;
	
КонецПроцедуры

Функция НаименованиеРеквизитаСопоставленияНоменклатурыБЭД(ТипОбъекта)
	
	Если ТипОбъекта = Тип("СправочникСсылка.Номенклатура") Тогда
		Возврат "НаименованиеПолное";
	ИначеЕсли ТипОбъекта = Тип("СправочникСсылка.ХарактеристикиНоменклатуры") Тогда
		Возврат "Наименование";
	Иначе
		Возврат Неопределено;
	КонецЕсли;
	
КонецФункции

#КонецОбласти

#Область ПоискСопоставленияНоменклатурыСНоменклатуройИБ

// См. СопоставлениеНоменклатурыКонтрагентовПереопределяемый.ТекстЗапросаПоискаВариантовСопоставленияПоШтрихкодамКомбинаций.
Процедура ТекстЗапросаПоискаВариантовСопоставленияПоШтрихкодамКомбинаций(ТекстЗапроса) Экспорт
	
	ТекстЗапроса = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	Штрихкоды.Штрихкод КАК ШтрихкодКомбинации,
	|	Штрихкоды.Владелец КАК Номенклатура,
	|	Штрихкоды.Характеристика КАК Характеристика,
	|	Штрихкоды.Упаковка КАК Упаковка
	|ПОМЕСТИТЬ НайденныеКомбинации
	|ИЗ
	|	ТаблицаШтрихкодовКомбинации КАК ТаблицаШтрихкодовКомбинации
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.Штрихкоды КАК Штрихкоды
	|		ПО ТаблицаШтрихкодовКомбинации.ШтрихкодКомбинации = Штрихкоды.Штрихкод
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	ШтрихкодКомбинации,
	|	Номенклатура,
	|	Характеристика,
	|	Упаковка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	НайденныеКомбинации.ШтрихкодКомбинации КАК ШтрихкодКомбинации
	|ПОМЕСТИТЬ СписокУникальныхШтрихкодовКомбинаций
	|ИЗ
	|	НайденныеКомбинации КАК НайденныеКомбинации
	|
	|СГРУППИРОВАТЬ ПО
	|	НайденныеКомбинации.ШтрихкодКомбинации
	|
	|ИМЕЮЩИЕ
	|	КОЛИЧЕСТВО(НайденныеКомбинации.Номенклатура) = 1 И
	|	КОЛИЧЕСТВО(НайденныеКомбинации.Характеристика) = 1 И
	|	КОЛИЧЕСТВО(НайденныеКомбинации.Упаковка) = 1
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	ШтрихкодКомбинации
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	НайденныеКомбинации.ШтрихкодКомбинации КАК ШтрихкодКомбинации,
	|	НайденныеКомбинации.Номенклатура КАК НоменклатураИБ,
	|	НайденныеКомбинации.Характеристика КАК ХарактеристикаИБ,
	|	НайденныеКомбинации.Упаковка КАК УпаковкаИБ
	|ИЗ
	|	НайденныеКомбинации КАК НайденныеКомбинации
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ СписокУникальныхШтрихкодовКомбинаций КАК СписокУникальныхШтрихкодовКомбинаций
	|		ПО НайденныеКомбинации.ШтрихкодКомбинации = СписокУникальныхШтрихкодовКомбинаций.ШтрихкодКомбинации";
	
КонецПроцедуры

// См. СопоставлениеНоменклатурыКонтрагентовПереопределяемый.ИнициализацияТекстаЗапросаПоискаСопоставленияПоНатуральнымКлючам.
Процедура ИнициализацияТекстаЗапросаПоискаСопоставленияПоНатуральнымКлючам(ТекстЗапроса) Экспорт
	
	ТекстЗапроса = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ РАЗЛИЧНЫЕ
	|	ТаблицаНатуральныхКлючей.ИдентификаторНоменклатуры КАК ИдентификаторНоменклатуры,
	|	ТаблицаНатуральныхКлючей.Штрихкод КАК Штрихкод,
	|	ТаблицаНатуральныхКлючей.ЭтоВнутреннийШтрихкод КАК ЭтоВнутреннийШтрихкод,
	|	Штрихкоды.Владелец КАК Номенклатура,
	|	ИСТИНА КАК ШтрихкодСопоставлен,
	|	ТаблицаНатуральныхКлючей.ЭтоНашаНоменклатура КАК ЭтоНашаНоменклатура
	|ПОМЕСТИТЬ ТаблицаСопоставленныхПоШтрихкодам
	|ИЗ
	|	РегистрСведений.Штрихкоды КАК Штрихкоды
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ТаблицаНатуральныхКлючей КАК ТаблицаНатуральныхКлючей
	|		ПО Штрихкоды.Штрихкод = ТаблицаНатуральныхКлючей.Штрихкод
	|ГДЕ
	|	ТаблицаНатуральныхКлючей.Штрихкод <> """"
	|	И НЕ Штрихкоды.Владелец.ПометкаУдаления
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	ИдентификаторНоменклатуры,
	|	Номенклатура
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ РАЗЛИЧНЫЕ
	|	Номенклатура.Артикул КАК Артикул,
	|	ТаблицаНатуральныхКлючей.ИдентификаторНоменклатуры КАК ИдентификаторНоменклатуры,
	|	Номенклатура.Ссылка КАК Номенклатура,
	|	ИСТИНА КАК АртикулСопоставлен,
	|	ТаблицаНатуральныхКлючей.ЭтоНашаНоменклатура КАК ЭтоНашаНоменклатура
	|ПОМЕСТИТЬ ТаблицаСопоставленныхПоАртикулам
	|ИЗ
	|	ТаблицаНатуральныхКлючей КАК ТаблицаНатуральныхКлючей
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.Номенклатура КАК Номенклатура
	|		ПО ТаблицаНатуральныхКлючей.Артикул = Номенклатура.Артикул
	|ГДЕ
	|	ТаблицаНатуральныхКлючей.Артикул <> """"
	|	И НЕ Номенклатура.ПометкаУдаления
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	ИдентификаторНоменклатуры,
	|	Номенклатура
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ РАЗЛИЧНЫЕ
	|	ТаблицаНатуральныхКлючей.ИдентификаторНоменклатуры КАК ИдентификаторНоменклатуры,
	|	СправочникНоменклатура.Ссылка КАК Номенклатура,
	|	ИСТИНА КАК НаименованиеСопоставлено,
	|	ТаблицаНатуральныхКлючей.ЭтоНашаНоменклатура КАК ЭтоНашаНоменклатура
	|ПОМЕСТИТЬ ТаблицаСопоставленныхПоНаименованию
	|ИЗ
	|	ТаблицаНатуральныхКлючей КАК ТаблицаНатуральныхКлючей
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.Номенклатура КАК СправочникНоменклатура
	|		ПО ТаблицаНатуральныхКлючей.Наименование = СправочникНоменклатура.Наименование
	|ГДЕ
	|	НЕ ИСТИНА В
	|				(ВЫБРАТЬ ПЕРВЫЕ 1
	|					ИСТИНА
	|				ИЗ
	|					ТаблицаСопоставленныхПоШтрихкодам КАК ТаблицаСопоставленныхПоШтрихкодам
	|				ГДЕ
	|					ТаблицаСопоставленныхПоШтрихкодам.ИдентификаторНоменклатуры = ТаблицаНатуральныхКлючей.ИдентификаторНоменклатуры
	|					И НЕ ТаблицаСопоставленныхПоШтрихкодам.ЭтоВнутреннийШтрихкод)
	|	И ТаблицаНатуральныхКлючей.ЭтоНашаНоменклатура
	|	И НЕ СправочникНоменклатура.ЭтоГруппа
	|	И НЕ СправочникНоменклатура.ПометкаУдаления
	|
	|ОБЪЕДИНИТЬ
	|
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ТаблицаНатуральныхКлючей.ИдентификаторНоменклатуры,
	|	СправочникНоменклатура.Ссылка,
	|	ИСТИНА,
	|	ТаблицаНатуральныхКлючей.ЭтоНашаНоменклатура
	|ИЗ
	|	ТаблицаНатуральныхКлючей КАК ТаблицаНатуральныхКлючей
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.Номенклатура КАК СправочникНоменклатура
	|		ПО ТаблицаНатуральныхКлючей.Наименование = СправочникНоменклатура.НаименованиеПолное
	|ГДЕ
	|	НЕ ИСТИНА В
	|				(ВЫБРАТЬ ПЕРВЫЕ 1
	|					ИСТИНА
	|				ИЗ
	|					ТаблицаСопоставленныхПоШтрихкодам КАК ТаблицаСопоставленныхПоШтрихкодам
	|				ГДЕ
	|					ТаблицаСопоставленныхПоШтрихкодам.ИдентификаторНоменклатуры = ТаблицаНатуральныхКлючей.ИдентификаторНоменклатуры
	|					И НЕ ТаблицаСопоставленныхПоШтрихкодам.ЭтоВнутреннийШтрихкод)
	|	И ТаблицаНатуральныхКлючей.ЭтоНашаНоменклатура
	|	И НЕ СправочникНоменклатура.ЭтоГруппа
	|	И НЕ СправочникНоменклатура.ПометкаУдаления
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	ИдентификаторНоменклатуры,
	|	Номенклатура";
	
КонецПроцедуры

// См. СопоставлениеНоменклатурыКонтрагентовПереопределяемый.ТекстЗапросаОтбораХарактеристикНоменклатурыБЭДПоВладельцу.
Процедура ТекстЗапросаОтбораХарактеристикНоменклатурыБЭДПоВладельцу(ТекстЗапроса) Экспорт
	
	ТекстЗапроса = 
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ВариантыСопоставленияПоСловарю.Идентификатор КАК Идентификатор,
	|	ВариантыСопоставленияПоСловарю.СсылкаНаОбъект КАК СсылкаНаОбъект,
	|	ТаблицаНоменклатуры.НоменклатураИБ КАК НоменклатураИБ
	|ПОМЕСТИТЬ ХарактеристикиПоВладельцу
	|ИЗ
	|	ВариантыСопоставленияПоСловарю КАК ВариантыСопоставленияПоСловарю
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ТаблицаНоменклатуры КАК ТаблицаНоменклатуры
	|		ПО ВариантыСопоставленияПоСловарю.Идентификатор = ТаблицаНоменклатуры.ИдентификаторХарактеристики
	|			И (ВариантыСопоставленияПоСловарю.СсылкаНаОбъект.Владелец ССЫЛКА Справочник.Номенклатура)
	|			И ВариантыСопоставленияПоСловарю.СсылкаНаОбъект.Владелец = ТаблицаНоменклатуры.НоменклатураИБ
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ВариантыСопоставленияПоСловарю.Идентификатор,
	|	ВариантыСопоставленияПоСловарю.СсылкаНаОбъект,
	|	ТаблицаНоменклатуры.НоменклатураИБ
	|ИЗ
	|	ВариантыСопоставленияПоСловарю КАК ВариантыСопоставленияПоСловарю
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ТаблицаНоменклатуры КАК ТаблицаНоменклатуры
	|		ПО ВариантыСопоставленияПоСловарю.Идентификатор = ТаблицаНоменклатуры.ИдентификаторХарактеристики
	|			И (ВариантыСопоставленияПоСловарю.СсылкаНаОбъект.Владелец ССЫЛКА Справочник.ВидыНоменклатуры)
	|			И ВариантыСопоставленияПоСловарю.СсылкаНаОбъект.Владелец = ТаблицаНоменклатуры.НоменклатураИБ.ВидНоменклатуры
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Идентификатор,
	|	СсылкаНаОбъект";
	
КонецПроцедуры

// См. СопоставлениеНоменклатурыКонтрагентовПереопределяемый.ТекстЗапросаОтбораСтрокСопоставленияДляЗаполненияХарактеристик.
Процедура ТекстЗапросаОтбораСтрокСопоставленияДляЗаполненияХарактеристик(ТекстЗапроса) Экспорт
	
	ТекстЗапроса = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ТаблицаСопоставления.Идентификатор КАК Идентификатор
	|ИЗ
	|	ТаблицаСопоставления КАК ТаблицаСопоставления
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.ХарактеристикиНоменклатуры КАК ХарактеристикиНоменклатуры
	|		ПО ТаблицаСопоставления.НоменклатураИБ = ХарактеристикиНоменклатуры.Владелец
	|			И (ХарактеристикиНоменклатуры.Владелец ССЫЛКА Справочник.Номенклатура)
	|ГДЕ
	|	ХарактеристикиНоменклатуры.Ссылка = &Характеристика
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ТаблицаСопоставления.Идентификатор
	|ИЗ
	|	ТаблицаСопоставления КАК ТаблицаСопоставления
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.Номенклатура КАК Номенклатура
	|			ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.ХарактеристикиНоменклатуры КАК ХарактеристикиНоменклатуры
	|			ПО Номенклатура.ВидНоменклатуры = ХарактеристикиНоменклатуры.Владелец
	|				И (ХарактеристикиНоменклатуры.Владелец ССЫЛКА Справочник.ВидыНоменклатуры)
	|		ПО ТаблицаСопоставления.НоменклатураИБ = Номенклатура.Ссылка
	|ГДЕ
	|	ХарактеристикиНоменклатуры.Ссылка = &Характеристика";
	
КонецПроцедуры

// См. СопоставлениеНоменклатурыКонтрагентовПереопределяемый.ТекстЗапросаПоискаВариантовСопоставленияУпаковкиНоменклатурыБЭД.
Процедура ТекстЗапросаПоискаВариантовСопоставленияУпаковкиНоменклатурыБЭД(ТекстЗапроса) Экспорт
	
	ТекстЗапроса = "ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ЕдиницыИзмерения.Ссылка КАК УпаковкаИБ,
	|	ТаблицаНоменклатуры.ИдентификаторУпаковки КАК ИдентификаторУпаковки,
	|	ТаблицаНоменклатуры.НоменклатураИБ КАК НоменклатураИБ
	|ИЗ
	|	ТаблицаНоменклатуры КАК ТаблицаНоменклатуры
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.БазовыеЕдиницыИзмерения КАК ЕдиницыИзмерения
	|		ПО ЛОЖЬ";
	
	Возврат;
	
	ТекстЗапроса = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ЕдиницыИзмерения.Ссылка КАК УпаковкаИБ,
	|	ТаблицаНоменклатуры.ИдентификаторУпаковки КАК ИдентификаторУпаковки,
	|	ТаблицаНоменклатуры.НоменклатураИБ КАК НоменклатураИБ
	|ИЗ
	|	ТаблицаНоменклатуры КАК ТаблицаНоменклатуры
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.БазовыеЕдиницыИзмерения КАК ЕдиницыИзмерения
	|		ПО ТаблицаНоменклатуры.ЕдиницаИзмеренияКод = ЕдиницыИзмерения.Код
	|
	|ОБЪЕДИНИТЬ
	|
	|ВЫБРАТЬ
	|	ЕдиницыИзмерения.Ссылка,
	|	ТаблицаНоменклатуры.ИдентификаторУпаковки,
	|	ТаблицаНоменклатуры.НоменклатураИБ
	|ИЗ
	|	ТаблицаНоменклатуры КАК ТаблицаНоменклатуры
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.БазовыеЕдиницыИзмерения КАК ЕдиницыИзмерения
	|		ПО ТаблицаНоменклатуры.ЕдиницаИзмерения = ЕдиницыИзмерения.НаименованиеПолное
	|
	|ОБЪЕДИНИТЬ
	|
	|ВЫБРАТЬ
	|	ЕдиницыИзмерения.Ссылка,
	|	ТаблицаНоменклатуры.ИдентификаторУпаковки,
	|	ТаблицаНоменклатуры.НоменклатураИБ
	|ИЗ
	|	ТаблицаНоменклатуры КАК ТаблицаНоменклатуры
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.БазовыеЕдиницыИзмерения КАК ЕдиницыИзмерения
	|		ПО ТаблицаНоменклатуры.ЕдиницаИзмерения = ЕдиницыИзмерения.Наименование";
	
КонецПроцедуры

#КонецОбласти

#Область РаботаСДаннымиИБ

// См. СопоставлениеНоменклатурыКонтрагентовПереопределяемый.ПриОпределенииСвойствНоменклатурыИнформационнойБазы.
Процедура ПриОпределенииСвойствНоменклатурыИнформационнойБазы(НаборНоменклатуры, СвойстваНоменклатурИБ) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	Номенклатура.Ссылка КАК Номенклатура,
		|	ВидыНоменклатуры.ИспользоватьХарактеристики КАК ИспользоватьХарактеристики,
		|	ЛОЖЬ КАК ИспользоватьУпаковки,
		|	ИСТИНА КАК ОбязательноеЗаполнениеХарактеристики,
		|	Номенклатура.ЕдиницаИзмерения КАК ЕдиницаИзмеренияПоУмолчанию
		|ИЗ
		|	Справочник.Номенклатура КАК Номенклатура
		|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ВидыНоменклатуры КАК ВидыНоменклатуры
		|		ПО Номенклатура.ВидНоменклатуры = ВидыНоменклатуры.Ссылка
		|ГДЕ
		|	Номенклатура.Ссылка В(&НаборНоменклатуры)";
	
	Запрос.УстановитьПараметр("НаборНоменклатуры", НаборНоменклатуры);
	РезультатЗапроса = Запрос.Выполнить();
	
	Выборка = РезультатЗапроса.Выбрать();
	
	Пока Выборка.Следующий() Цикл
		
		СвойстваНоменклатуры = СопоставлениеНоменклатурыКонтрагентовКлиентСервер.НовыеСвойстваНоменклатурыИБ();
		ЗаполнитьЗначенияСвойств(СвойстваНоменклатуры, Выборка);
		
		СвойстваНоменклатурИБ.Вставить(Выборка.Номенклатура, СвойстваНоменклатуры);
		
	КонецЦикла;
	
КонецПроцедуры

// См. СопоставлениеНоменклатурыКонтрагентовПереопределяемый.ПриОпределенииПредставленийСопоставленияНоменклатуры.
Процедура ПриОпределенииПредставленийСопоставленияНоменклатуры(Представления) Экспорт
	
	Представления.ХарактеристикаПредставлениеОбъекта = НСтр("ru = 'Характеристика'"); // Вместо "Характеристика номенклатуры".
	
КонецПроцедуры

// См. СопоставлениеНоменклатурыКонтрагентовПереопределяемый.ПриОпределенииСтруктурыНоменклатурыИнформационнойБазы.
Процедура ПриОпределенииСтруктурыНоменклатурыИнформационнойБазы(СтруктураНоменклатуры) Экспорт
	
	СтруктураНоменклатуры.ИмяПараметраСвязиХарактеристики = "Номенклатура";
	СтруктураНоменклатуры.ИмяПараметраСвязиУпаковки 	  = "Номенклатура";
	
КонецПроцедуры

#КонецОбласти

#Область ЗаполнениеФормНаОснованииНоменклатурыКонтрагентов

// См. СопоставлениеНоменклатурыКонтрагентовПереопределяемый.ПриЗаполненииФормыНоменклатурыПоДаннымКонтрагента.
Процедура ПриЗаполненииФормыНоменклатурыПоДаннымКонтрагента(Знач НоменклатураКонтрагента, Форма) Экспорт
	
	Форма.Объект.Наименование 		= НоменклатураКонтрагента.Наименование;
	Форма.Объект.НаименованиеПолное = НоменклатураКонтрагента.Наименование;
		
	Если ЗначениеЗаполнено(НоменклатураКонтрагента.Характеристика) Тогда
		
		Форма.Объект.Наименование = Форма.Объект.Наименование 
			+ " (" + НоменклатураКонтрагента.Характеристика + ")";
		
	КонецЕсли;
	
	Форма.Объект.Артикул = НоменклатураКонтрагента.Артикул;
	
	Если ЗначениеЗаполнено(НоменклатураКонтрагента.ЕдиницаИзмеренияКод) Тогда
		Форма.Объект.ЕдиницаИзмерения = ЭлектронноеВзаимодействиеРТ.НайтиСсылкуНаОбъектПоРеквизиту("БазовыеЕдиницыИзмерения", 
			"Код", НоменклатураКонтрагента.ЕдиницаИзмеренияКод);
	ИначеЕсли ЗначениеЗаполнено(НоменклатураКонтрагента.ЕдиницаИзмерения) Тогда
		Форма.Объект.ЕдиницаИзмерения = ЭлектронноеВзаимодействиеРТ.НайтиСсылкуНаОбъектПоРеквизиту("БазовыеЕдиницыИзмерения", 
			"Наименование", НоменклатураКонтрагента.ЕдиницаИзмерения);
	КонецЕсли;
	
	Если ЗначениеЗаполнено(НоменклатураКонтрагента.СтавкаНДС) Тогда
		СтавкиНДСПоКлючу = Новый Соответствие;
		ОбменСКонтрагентамиРТ.ЗаполнитьСоответствиеСтавокНДС(СтавкиНДСПоКлючу);
		Для каждого КлючЗначение Из СтавкиНДСПоКлючу Цикл
			Если КлючЗначение.Ключ = НоменклатураКонтрагента.СтавкаНДС Тогда
				Форма.Объект.СтавкаНДС = КлючЗначение.Значение;
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	Форма.Штрихкоды = НоменклатураКонтрагента.ШтрихкодыНоменклатуры;
	
КонецПроцедуры

// См. СопоставлениеНоменклатурыКонтрагентовПереопределяемый.ПриЗаполненииФормыХарактеристикиПоДаннымКонтрагента.
Процедура ПриЗаполненииФормыХарактеристикиПоДаннымКонтрагента(Знач НоменклатураКонтрагента, Форма) Экспорт
	
	Форма.Объект.Наименование = НоменклатураКонтрагента.Характеристика;
	
КонецПроцедуры

#КонецОбласти


