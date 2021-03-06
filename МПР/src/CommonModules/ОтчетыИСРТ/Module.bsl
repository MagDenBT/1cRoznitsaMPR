#Область ПрограммныйИнтерфейс

Процедура ПриОпределенииТекстаЗапросаОформленныхДокументов(ТекстЗапроса, ОтчетОбъект) Экспорт
	
	Текст = Неопределено;
	Отчет = ОтчетОбъект.Метаданные();
	
	Если Отчет = Метаданные.Отчеты.АнализРасхожденийПриПоступленииАлкогольнойПродукции Тогда
		Текст = ОформленныеДокументыПоПоступлениюАлкогольнойПродукции();
	ИначеЕсли Отчет = Метаданные.Отчеты.АнализРасхожденийПриОтгрузкеАлкогольнойПродукции Тогда
		Текст = ОформленныеДокументыПоОтгрузкеАлкогольнойПродукции();
	ИначеЕсли Отчет = Метаданные.Отчеты.АнализРасхожденийПриПоступленииПродукцииВЕТИС Тогда
		Текст = ОформленныеДокументыПоПоступлениюПродукцииВЕТИС();
	ИначеЕсли Отчет = Метаданные.Отчеты.АнализРасхожденийПриОтгрузкеПродукцииВЕТИС Тогда
		Текст = ОформленныеДокументыПоОтгрузкеПродукцииВЕТИС();
	ИначеЕсли Отчет = Метаданные.Отчеты.АнализРасхожденийПриИнвентаризацииПродукцииВЕТИС Тогда
		Текст = ОформленныеДокументыПоИнвентаризацииПродукцииВЕТИС();
	ИначеЕсли Отчет = Метаданные.Отчеты.АнализРасхожденийПриПроизводствеПродукцииВЕТИС Тогда
		Текст = ОформленныеДокументыПоПроизводственнойОперацииВЕТИС();
	ИначеЕсли Отчет = Метаданные.Отчеты.АнализРасхожденийПриМаркировкеТоваровИСМП Тогда
		Текст = ОформленныеДокументыПоМаркировкеТоваровИСМП();
	ИначеЕсли Отчет = Метаданные.Отчеты.АнализРасхожденийПриВыводеИзОборотаИСМП Тогда
		Текст = ОформленныеДокументыВыводуИзОборотаИСМП();
	КонецЕсли;
	
	Если Не Текст = Неопределено Тогда
		ТекстЗапроса = Текст;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ТекстыЗапросов

Функция ОформленныеДокументыВыводуИзОборотаИСМП()
	
	МассивТекстовЗапросов = Новый Массив;
	
	ДобавитьОснование(МассивТекстовЗапросов, "ВозвратТоваровПоставщику", "Товары");
	ДобавитьОснование(МассивТекстовЗапросов, "СписаниеТоваров", "Товары");
	ДобавитьОснование(МассивТекстовЗапросов, "ОтчетОРозничныхПродажах", "Товары");
	
	Текст = СтрСоединить(МассивТекстовЗапросов, "
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|");
	ДоработатьЗапросПродукцииИСМП(Текст);
	
	Возврат Текст;
	
КонецФункции

Функция ОформленныеДокументыПоМаркировкеТоваровИСМП()
	
	МассивТекстовЗапросов = Новый Массив;
	
	ДобавитьОснование(МассивТекстовЗапросов,"ПоступлениеТоваров", "Товары");
	ДобавитьОснование(МассивТекстовЗапросов, "ПересчетТоваров", "Товары");
	ДобавитьОснование(МассивТекстовЗапросов, "ЧекККМ", "Товары");
	
	Текст = СтрСоединить(МассивТекстовЗапросов, "
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|");
	ДоработатьЗапросПродукцииИСМП(Текст);
	
	Возврат Текст;
	
КонецФункции

Функция ОформленныеДокументыПоПроизводственнойОперацииВЕТИС()
	
	МассивТекстовЗапросов = Новый Массив;
	
	ЗнакСборки = "ВЫБОР КОГДА ТаблицаТовары.Ссылка.ВидОперации = ЗНАЧЕНИЕ(Перечисление.ВидыОперацийКомплектацияНоменклатуры.Комплектация) ТОГДА 1 ИНАЧЕ -1 КОНЕЦ *";
	
	ДобавитьОснование(МассивТекстовЗапросов, "СборкаТоваров", "Товары", "-"+ЗнакСборки);
	
	Текст = СтрСоединить(МассивТекстовЗапросов, "
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|");
	ДоработатьЗапросПродукцииВЕТИС(Текст);
	
	Возврат Текст;
	
КонецФункции

Функция ОформленныеДокументыПоИнвентаризацииПродукцииВЕТИС()
	
	МассивТекстовЗапросов = Новый Массив;
	ДобавитьОснование(МассивТекстовЗапросов, "СписаниеТоваров", "Товары", "-");
	ДобавитьОснование(МассивТекстовЗапросов, "ОприходованиеТоваров", "Товары");
	ДобавитьОснование(МассивТекстовЗапросов, "ПересортицаТоваров", "Товары", "-");
	
	Текст = СтрСоединить(МассивТекстовЗапросов, "
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|");
	ДоработатьЗапросПродукцииВЕТИС(Текст);
	
	Возврат Текст;
	
КонецФункции

Функция ОформленныеДокументыПоОтгрузкеПродукцииВЕТИС()
	
	МассивТекстовЗапросов = Новый Массив;
	ДобавитьОснование(МассивТекстовЗапросов, "РеализацияТоваров", "Товары");
	ДобавитьОснование(МассивТекстовЗапросов, "ВозвратТоваровПоставщику", "Товары");
	ДобавитьОснование(МассивТекстовЗапросов, "ПеремещениеТоваров", "Товары");
	ДобавитьОснование(МассивТекстовЗапросов, "ПередачаТоваровМеждуОрганизациями", "Товары");
	
	Текст = СтрСоединить(МассивТекстовЗапросов, "
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|");
	ДоработатьЗапросПродукцииВЕТИС(Текст);
	
	Возврат Текст;
	
КонецФункции

Функция ОформленныеДокументыПоПоступлениюПродукцииВЕТИС()
	
	МассивТекстовЗапросов = Новый Массив;
	ДобавитьОснование(МассивТекстовЗапросов,"ПоступлениеТоваров", "Товары");
	ДобавитьОснование(МассивТекстовЗапросов,"ВозвратТоваровОтПокупателя", "Товары");
	ДобавитьОснование(МассивТекстовЗапросов,"ПеремещениеТоваров", "Товары");
	ДобавитьОснование(МассивТекстовЗапросов,"ПередачаТоваровМеждуОрганизациями", "Товары");
	
	Текст = СтрСоединить(МассивТекстовЗапросов, "
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|");
	ДоработатьЗапросПродукцииВЕТИС(Текст);
	
	Возврат Текст;
	
КонецФункции

Функция ОформленныеДокументыПоОтгрузкеАлкогольнойПродукции()
	
	МассивТекстовЗапросов = Новый Массив;
	ДобавитьОснование(МассивТекстовЗапросов,"ВозвратТоваровПоставщику", "Товары");
	ДобавитьОснование(МассивТекстовЗапросов,"ПеремещениеТоваров", "Товары");
	//ДобавитьОснование(МассивТекстовЗапросов,"РеализацияТоваровУслуг", "Товары");
	ДобавитьОснование(МассивТекстовЗапросов,"ПередачаТоваровМеждуОрганизациями", "Товары");
	
	Текст = СтрСоединить(МассивТекстовЗапросов, "
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|");
	ДоработатьЗапросПродукцииЕГАИС(Текст);
	
	Возврат Текст;
	
КонецФункции

Функция ОформленныеДокументыПоПоступлениюАлкогольнойПродукции()
	
	МассивТекстовЗапросов = Новый Массив;
	ДобавитьОснование(МассивТекстовЗапросов,"ПоступлениеТоваров", "Товары");
	ДобавитьОснование(МассивТекстовЗапросов,"ПеремещениеТоваров", "Товары");
	ДобавитьОснование(МассивТекстовЗапросов,"ПередачаТоваровМеждуОрганизациями", "Товары");
	
	Текст = СтрСоединить(МассивТекстовЗапросов, "
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|");
	ДоработатьЗапросПродукцииЕГАИС(Текст);
	
	Возврат Текст;
	
КонецФункции

#КонецОбласти

#Область Шаблоны

Функция ДобавитьОснование(МассивТекстовЗапросов, ИмяДокумента, ИмяТабличнойЧасти, Знак = "", Постфикс = "")
	
	Если Не ПравоДоступа("Просмотр", Метаданные.Документы[ИмяДокумента]) Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Шаблон = 
	"ВЫБРАТЬ
	|	ТаблицаТовары.Ссылка                                КАК Ссылка,
	|	ТаблицаТовары.Номенклатура%4                        КАК Номенклатура,
	|	ТаблицаТовары.Характеристика%4                      КАК Характеристика,
	|	Значение(Справочник.СерииНоменклатуры.ПустаяСсылка) КАК Серия,
	|	%3СУММА(ТаблицаТовары.Количество) КАК Количество
	|ИЗ
	|	Документ.%1.%2 КАК ТаблицаТовары
	|ГДЕ
	|	ТаблицаТовары.Ссылка.Проведен
	|	И ТаблицаТовары.Ссылка В
	|		(ВЫБРАТЬ
	|			ПрикладныеДокументы.Ссылка
	|		ИЗ
	|			ПрикладныеДокументы КАК ПрикладныеДокументы)
	|
	|СГРУППИРОВАТЬ ПО
	|	ТаблицаТовары.Ссылка,
	|	ТаблицаТовары.Номенклатура%4,
	|	ТаблицаТовары.Характеристика%4";
	
	Шаблон = СтрШаблон(Шаблон,
		ИмяДокумента,
		ИмяТабличнойЧасти,
		Знак,
		Постфикс);
	
	МассивТекстовЗапросов.Добавить(Шаблон);
	Возврат Истина;
	
КонецФункции

Процедура ДоработатьЗапросПродукцииВЕТИС(Текст)
	
	Позиция = СтрНайти(Текст, "ВЫБРАТЬ");
	Текст = Лев(Текст, Позиция-1) + "ВЫБРАТЬ РАЗРЕШЕННЫЕ" + Сред(Текст, Позиция + СтрДлина("ВЫБРАТЬ"));
	Позиция = СтрНайти(Текст, "
	|ИЗ");
	Текст = Лев(Текст, Позиция -1)+ "
	|ПОМЕСТИТЬ ТоварыНакладнойПредварительно
	|"+ Сред(Текст, Позиция);
	
	Текст = Текст + 
	";
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	Товары.Ссылка КАК Ссылка,
	|	Товары.Номенклатура КАК Номенклатура,
	|	Товары.Характеристика КАК Характеристика,
	|	Товары.Серия КАК Серия,
	|	Товары.Количество КАК Количество
	|ПОМЕСТИТЬ ТоварыНакладной
	|ИЗ
	|	ТоварыНакладнойПредварительно КАК Товары
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.Номенклатура КАК СправочникНоменклатура
	|		ПО Товары.Номенклатура = СправочникНоменклатура.Ссылка
	|		И СправочникНоменклатура.ОсобенностьУчета В(
	|			ЗНАЧЕНИЕ(Перечисление.ОсобенностиУчетаНоменклатуры.ПодконтрольнаяПродукцияВЕТИС),
	|			ЗНАЧЕНИЕ(Перечисление.ОсобенностиУчетаНоменклатуры.МолочнаяПродукцияПодконтрольнаяВЕТИС))
	|;
	|
	|";
КонецПроцедуры

Процедура ДоработатьЗапросПродукцииЕГАИС(Текст)
	
	Позиция = СтрНайти(Текст, "ВЫБРАТЬ");
	Текст = Лев(Текст, Позиция-1) + "ВЫБРАТЬ РАЗРЕШЕННЫЕ" + Сред(Текст, Позиция + СтрДлина("ВЫБРАТЬ"));
	Позиция = СтрНайти(Текст, "
	|ИЗ");
	Текст = Лев(Текст, Позиция -1)+ "
	|ПОМЕСТИТЬ ТоварыНакладнойПредварительно
	|"+ Сред(Текст, Позиция);
	
	Текст = Текст + 
	";
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	Товары.Ссылка КАК Ссылка,
	|	Товары.Номенклатура КАК Номенклатура,
	|	Товары.Характеристика КАК Характеристика,
	|	Товары.Серия КАК Серия,
	|	Товары.Количество КАК Количество
	|ПОМЕСТИТЬ ТоварыНакладной
	|ИЗ
	|	ТоварыНакладнойПредварительно КАК Товары
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.Номенклатура КАК СправочникНоменклатура
	|		ПО Товары.Номенклатура = СправочникНоменклатура.Ссылка
	|		И СправочникНоменклатура.ОсобенностьУчета = ЗНАЧЕНИЕ(Перечисление.ОсобенностиУчетаНоменклатуры.АлкогольнаяПродукция)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ РАЗЛИЧНЫЕ
	|	ТоварыНакладной.Номенклатура КАК Номенклатура,
	|	ТоварыНакладной.Характеристика КАК Характеристика,
	|	ТоварыНакладной.Номенклатура.ОбъемДАЛ КАК ОбъемДАЛ
	|ПОМЕСТИТЬ НоменклатураПереопределяемый
	|ИЗ
	|	ТоварыНакладной КАК ТоварыНакладной
	|;
	|
	|";
	
КонецПроцедуры

Процедура ДоработатьЗапросПродукцииИСМП(Текст)
	
	Позиция = СтрНайти(Текст, "ВЫБРАТЬ");
	Текст = Лев(Текст, Позиция-1) + "ВЫБРАТЬ РАЗРЕШЕННЫЕ" + Сред(Текст, Позиция + СтрДлина("ВЫБРАТЬ"));
	
	Позиция = СтрНайти(Текст, "
	|ИЗ");
	Текст = Лев(Текст, Позиция -1)+ "
	|ПОМЕСТИТЬ ТоварыНакладнойПредварительно
	|"+ Сред(Текст, Позиция)+"
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|";
	
	Текст = Текст + 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ВложенныйЗапрос.Ссылка КАК Ссылка,
	|	ВложенныйЗапрос.Номенклатура КАК Номенклатура,
	|	ВложенныйЗапрос.Характеристика КАК Характеристика,
	|	ВложенныйЗапрос.Серия КАК Серия,
	|	ВложенныйЗапрос.Количество КАК Количество
	|ПОМЕСТИТЬ ТоварыНакладной
	|ИЗ
	|	(ВЫБРАТЬ
	|		Товары.Ссылка КАК Ссылка,
	|		Товары.Номенклатура КАК Номенклатура,
	|		Товары.Характеристика КАК Характеристика,
	|		Товары.Серия КАК Серия,
	|		Товары.Количество КАК Количество,
	|		&УсловиеОсобенностьУчета КАК ПродукцияИСМП
	|	ИЗ
	|		ТоварыНакладнойПредварительно КАК Товары) КАК ВложенныйЗапрос
	|ГДЕ
	|	ВложенныйЗапрос.ПродукцияИСМП
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ РАЗЛИЧНЫЕ
	|	ТоварыНакладной.Номенклатура КАК Номенклатура,
	|	&ОпределениеВидаПродукции КАК ВидПродукции
	|ПОМЕСТИТЬ НоменклатураПереопределяемый
	|ИЗ
	|	ТоварыНакладной КАК ТоварыНакладной
	|;
	|
	|";
	
	ИнтеграцияИСРТ.ОпределитьВидПродукцииТекстаЗапроса(Текст, "ТоварыНакладной.Номенклатура");
	ИнтеграцияИСРТ.ОпределитьОсобенностиУчетаТекстаЗапроса(Текст, "Товары.Номенклатура");
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти
