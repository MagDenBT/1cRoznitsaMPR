#Область ОбработчикиСобытий

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
    
    // &ЗамерПроизводительности
	ОценкаПроизводительностиРТКлиент.НачатьЗамер(
		     Истина, "Обработка.ПечатьЭтикетокИЦенников.Форма.Форма.Открытие");
	
	ПараметрыФормы = ПодготовитьСтруктуруПечати(ПараметрКоманды);
	ОткрытьФорму("Обработка.ПечатьЭтикетокИЦенников.Форма.Форма", ПараметрыФормы, ПараметрыВыполненияКоманды.Источник, ПараметрыВыполненияКоманды.Уникальность, ПараметрыВыполненияКоманды.Окно, ПараметрыВыполненияКоманды.НавигационнаяСсылка);
	
КонецПроцедуры

&НаСервере
Функция ПодготовитьСтруктуруПечати(ПараметрКоманды)
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	Номенклатура.Ссылка,
	|	Номенклатура.Ссылка.ВидНоменклатуры КАК ВидНоменклатуры,
	|	Номенклатура.Ссылка.ВидНоменклатуры.ИспользоватьХарактеристики КАК ИспользоватьХарактеристики,
	|	Номенклатура.Ссылка.ВидНоменклатуры.ИспользованиеХарактеристик КАК ИспользованиеХарактеристик,
	|	Номенклатура.НаборУпаковок
	|ПОМЕСТИТЬ СпрНоменклатура
	|ИЗ
	|	Справочник.Номенклатура КАК Номенклатура
	|ГДЕ
	|	НЕ Номенклатура.ЭтоГруппа
	|	И Номенклатура.Ссылка В ИЕРАРХИИ(&МассивСсылок)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	СпрНоменклатура.Ссылка КАК Номенклатура,
	|	ЕСТЬNULL(ХарактеристикиНоменклатуры.Ссылка, ЗНАЧЕНИЕ(Справочник.ХарактеристикиНоменклатуры.ПустаяСсылка)) КАК Характеристика,
	|	ЕСТЬNULL(УпаковкиНоменклатуры.Ссылка, ЗНАЧЕНИЕ(Справочник.УпаковкиНоменклатуры.ПустаяСсылка)) КАК Упаковка
	|ПОМЕСТИТЬ НоменклатураХарактеристикиУпаковки
	|ИЗ
	|	СпрНоменклатура КАК СпрНоменклатура
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ХарактеристикиНоменклатуры КАК ХарактеристикиНоменклатуры
	|		ПО (ВЫБОР
	|				КОГДА НЕ СпрНоменклатура.ИспользоватьХарактеристики
	|						ИЛИ СпрНоменклатура.ИспользованиеХарактеристик = ЗНАЧЕНИЕ(Перечисление.ВариантыВеденияДополнительныхДанныхПоНоменклатуре.НеИспользовать)
	|					ТОГДА ЛОЖЬ
	|				ИНАЧЕ ВЫБОР
	|						КОГДА СпрНоменклатура.ИспользованиеХарактеристик = ЗНАЧЕНИЕ(Перечисление.ВариантыВеденияДополнительныхДанныхПоНоменклатуре.ОбщиеДляВидаНоменклатуры)
	|							ТОГДА СпрНоменклатура.ВидНоменклатуры = ХарактеристикиНоменклатуры.Владелец
	|						ИНАЧЕ СпрНоменклатура.Ссылка = ХарактеристикиНоменклатуры.Владелец
	|					КОНЕЦ
	|			КОНЕЦ)
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.УпаковкиНоменклатуры КАК УпаковкиНоменклатуры
	|		ПО (ВЫБОР
	|				КОГДА СпрНоменклатура.НаборУпаковок = ЗНАЧЕНИЕ(СПРАВОЧНИК.НаборыУпаковок.ИндивидуальныйДляНоменклатуры)
	|					ТОГДА СпрНоменклатура.Ссылка = УпаковкиНоменклатуры.Владелец
	|				ИНАЧЕ СпрНоменклатура.НаборУпаковок = УпаковкиНоменклатуры.Владелец
	|			КОНЕЦ)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	НоменклатураХарактеристикиУпаковки.Номенклатура КАК Номенклатура,
	|	НоменклатураХарактеристикиУпаковки.Характеристика КАК Характеристика,
	|	ЗНАЧЕНИЕ(Справочник.УпаковкиНоменклатуры.ПустаяСсылка) КАК Упаковка
	|ИЗ
	|	НоменклатураХарактеристикиУпаковки КАК НоменклатураХарактеристикиУпаковки
	|ГДЕ
	|	НЕ НоменклатураХарактеристикиУпаковки.Упаковка = ЗНАЧЕНИЕ(Справочник.УпаковкиНоменклатуры.ПустаяСсылка)
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	НоменклатураХарактеристикиУпаковки.Номенклатура,
	|	НоменклатураХарактеристикиУпаковки.Характеристика,
	|	НоменклатураХарактеристикиУпаковки.Упаковка
	|ИЗ
	|	НоменклатураХарактеристикиУпаковки КАК НоменклатураХарактеристикиУпаковки
	|
	|УПОРЯДОЧИТЬ ПО
	|	Номенклатура,
	|	Характеристика,
	|	Упаковка";
	
	Запрос.УстановитьПараметр("МассивСсылок", ПараметрКоманды);
	
	РезультатЗапроса = Запрос.Выполнить();
	Выборка = РезультатЗапроса.Выбрать();
	
	СтруктураДействий = Новый Структура;
	СтруктураДействий.Вставить("ЗаполнитьМагазин"               , ОбщегоНазначенияРТ.ОпределитьТекущийМагазин());
	СтруктураДействий.Вставить("УстановитьРежим"                , "ПечатьЦенниковИЭтикеток");
	СтруктураДействий.Вставить("ПоказыватьКолонкуКоличествоВДокументе", Ложь);
	СтруктураДействий.Вставить("РежимПечатиИзОбработки", Ложь);
	
	СтруктураДействий.Вставить("ЗаполнитьТаблицуТоваров");
	Товары         = Новый ТаблицаЗначений;
	Товары.Колонки.Добавить("Номенклатура", Новый ОписаниеТипов("СправочникСсылка.Номенклатура"));
	Товары.Колонки.Добавить("Характеристика", Новый ОписаниеТипов("СправочникСсылка.ХарактеристикиНоменклатуры"));
	Товары.Колонки.Добавить("Упаковка", Новый ОписаниеТипов("СправочникСсылка.УпаковкиНоменклатуры"));
	Товары.Колонки.Добавить("Количество", Новый ОписаниеТипов("Число"));
	Товары.Колонки.Добавить("Цена", Новый ОписаниеТипов("Число"));
	
	Пока Выборка.Следующий() Цикл
		НоваяСтрока = Товары.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, Выборка);
	КонецЦикла;
	
	СтруктураРезультат = Новый Структура;
	СтруктураРезультат.Вставить("Товары", Товары);
	СтруктураРезультат.Вставить("СтруктураДействий", СтруктураДействий);
	СтруктураПараметры = Новый Структура("АдресВХранилище", ПоместитьВоВременноеХранилище(СтруктураРезультат));
	
	Возврат СтруктураПараметры;
КонецФункции

#КонецОбласти