#Область ПрограммныйИнтерфейс

// Возвращает структуру с остатком и сроком действия переданного сертификата
// Параметры:
//  ПодарочныйСертификат - Справочник.Номенклатура - Вид искомого сертификата
//  СерийныйНомер - Справочник.СерийныеНомера - Номер искомого сертификата
//
Функция ПолучитьСтруктуруДанныхСертификата(ПодарочныйСертификат, СерийныйНомер, Документ = Неопределено, Период = Неопределено) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	Номенклатура.Ссылка КАК ПодарочныйСертификат,
	|	ЕСТЬNULL(СерийныеНомера.Ссылка, ЗНАЧЕНИЕ(Справочник.СерийныеНомера.ПустаяСсылка)) КАК СерийныйНомер,
	|	Номенклатура.ДатаОкончанияДействия КАК ДатаОкончанияДействия,
	|	Номенклатура.КоличествоПериодовДействия КАК КоличествоПериодовДействия,
	|	Номенклатура.Периодичность КАК Периодичность,
	|	Номенклатура.ТипСрокаДействия КАК ТипСрокаДействия,
	|	Номенклатура.ЧастичноеПогашение КАК ЧастичноеПогашение,
	|	Номенклатура.ПроизвольныйНоминал КАК ПроизвольныйНоминал,
	|	Номенклатура.Номинал КАК Номинал
	|ПОМЕСТИТЬ Сертификаты
	|ИЗ
	|	Справочник.Номенклатура КАК Номенклатура
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.СерийныеНомера КАК СерийныеНомера
	|		ПО (СерийныеНомера.Ссылка = &СерийныйНомер)
	|ГДЕ
	|	Номенклатура.Ссылка = &ПодарочныйСертификат
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	ПодарочныйСертификат,
	|	СерийныйНомер
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ДвиженияСерийныхНомеровСрезПоследних.Номенклатура КАК Номенклатура,
	|	ДвиженияСерийныхНомеровСрезПоследних.СерийныйНомер КАК СерийныйНомер,
	|	ДвиженияСерийныхНомеровСрезПоследних.АналитикаХозяйственнойОперации КАК Статус
	|ПОМЕСТИТЬ СтатусыСерийныхНомеров
	|ИЗ
	|	(ВЫБРАТЬ
	|		ДвиженияСерийныхНомеровСрезПоследних.Номенклатура КАК Номенклатура,
	|		ДвиженияСерийныхНомеровСрезПоследних.СерийныйНомер КАК СерийныйНомер,
	|		МАКСИМУМ(ДвиженияСерийныхНомеровСрезПоследних.Период) КАК Период
	|	ИЗ
	|		РегистрСведений.ДвиженияСерийныхНомеров.СрезПоследних(
	|				,
	|				(Номенклатура, СерийныйНомер) В
	|					(ВЫБРАТЬ
	|						Сертификаты.ПодарочныйСертификат,
	|						Сертификаты.СерийныйНомер
	|					ИЗ
	|						Сертификаты)) КАК ДвиженияСерийныхНомеровСрезПоследних
	|	
	|	СГРУППИРОВАТЬ ПО
	|		ДвиженияСерийныхНомеровСрезПоследних.Номенклатура,
	|		ДвиженияСерийныхНомеровСрезПоследних.СерийныйНомер) КАК ДвиженияНомеровСрезПоследних
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.ДвиженияСерийныхНомеров.СрезПоследних(
	|				,
	|				(Номенклатура, СерийныйНомер) В
	|					(ВЫБРАТЬ
	|						Сертификаты.ПодарочныйСертификат,
	|						Сертификаты.СерийныйНомер
	|					ИЗ
	|						Сертификаты)) КАК ДвиженияСерийныхНомеровСрезПоследних
	|		ПО ДвиженияНомеровСрезПоследних.Номенклатура = ДвиженияСерийныхНомеровСрезПоследних.Номенклатура
	|			И ДвиженияНомеровСрезПоследних.СерийныйНомер = ДвиженияСерийныхНомеровСрезПоследних.СерийныйНомер
	|			И ДвиженияНомеровСрезПоследних.Период = ДвиженияСерийныхНомеровСрезПоследних.Период
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Номенклатура,
	|	СерийныйНомер
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ПодарочныеСертификатыОбороты.ПодарочныйСертификат КАК ПодарочныйСертификат,
	|	ПодарочныеСертификатыОбороты.НомерСертификата КАК НомерСертификата,
	|	СУММА(ПодарочныеСертификатыОбороты.СуммаПриход) КАК Номинал
	|ПОМЕСТИТЬ ПроизвольныеНоминалы
	|ИЗ
	|	РегистрНакопления.ПодарочныеСертификаты.Обороты(
	|			,
	|			,
	|			,
	|			(ПодарочныйСертификат, НомерСертификата) В
	|				(ВЫБРАТЬ
	|					Сертификаты.ПодарочныйСертификат,
	|					Сертификаты.СерийныйНомер
	|				ИЗ
	|					Сертификаты
	|				ГДЕ
	|					Сертификаты.ПроизвольныйНоминал)) КАК ПодарочныеСертификатыОбороты
	|
	|СГРУППИРОВАТЬ ПО
	|	ПодарочныеСертификатыОбороты.НомерСертификата,
	|	ПодарочныеСертификатыОбороты.ПодарочныйСертификат
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	ПодарочныйСертификат,
	|	НомерСертификата
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	МАКСИМУМ(ДвиженияСерийныхНомеров.Период) КАК Период,
	|	ДвиженияСерийныхНомеров.СерийныйНомер КАК СерийныйНомер
	|ПОМЕСТИТЬ ПродажиСерийныхНомеров
	|ИЗ
	|	РегистрСведений.ДвиженияСерийныхНомеров КАК ДвиженияСерийныхНомеров
	|ГДЕ
	|	ДвиженияСерийныхНомеров.Номенклатура = &ПодарочныйСертификат
	|	И ДвиженияСерийныхНомеров.СерийныйНомер = &СерийныйНомер
	|	И ДвиженияСерийныхНомеров.АналитикаХозяйственнойОперации = ЗНАЧЕНИЕ(Справочник.АналитикаХозяйственныхОпераций.РеализацияТоваров)
	|
	|СГРУППИРОВАТЬ ПО
	|	ДвиженияСерийныхНомеров.СерийныйНомер
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ПодарочныеСертификатыОбороты.ПодарочныйСертификат КАК ПодарочныйСертификат,
	|	ПодарочныеСертификатыОбороты.НомерСертификата КАК СерийныйНомер,
	|	ПодарочныеСертификатыОбороты.СуммаОборот КАК СуммаОборот
	|ПОМЕСТИТЬ ОборотПоДокументу
	|ИЗ
	|	РегистрНакопления.ПодарочныеСертификаты.Обороты(
	|			,
	|			,
	|			Регистратор,
	|			ПодарочныйСертификат = &ПодарочныйСертификат
	|				И НомерСертификата = &СерийныйНомер) КАК ПодарочныеСертификатыОбороты
	|ГДЕ
	|	ПодарочныеСертификатыОбороты.Регистратор = &Регистратор
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВЫБОР
	|		КОГДА Сертификаты.ПроизвольныйНоминал
	|			ТОГДА ЕСТЬNULL(ПроизвольныеНоминалы.Номинал, 0)
	|		ИНАЧЕ Сертификаты.Номинал
	|	КОНЕЦ КАК Номинал,
	|	ВЫБОР
	|		КОГДА Сертификаты.ЧастичноеПогашение
	|				ИЛИ Сертификаты.ПроизвольныйНоминал
	|			ТОГДА ЕСТЬNULL(ПодарочныеСертификатыОстатки.СуммаОстаток, 0)
	|		ИНАЧЕ Сертификаты.Номинал
	|	КОНЕЦ - ЕСТЬNULL(ОборотПоДокументу.СуммаОборот, 0) КАК Остаток,
	|	ВЫБОР
	|		КОГДА Сертификаты.ТипСрокаДействия = ЗНАЧЕНИЕ(Перечисление.СрокДействияПодарочныхСертификатов.СОграничениемНаДату)
	|			ТОГДА Сертификаты.ДатаОкончанияДействия
	|		КОГДА Сертификаты.ТипСрокаДействия = ЗНАЧЕНИЕ(Перечисление.СрокДействияПодарочныхСертификатов.ПериодПослеПродажи)
	|			ТОГДА ВЫБОР
	|					КОГДА Сертификаты.Периодичность = ЗНАЧЕНИЕ(Перечисление.Периодичность.День)
	|						ТОГДА НАЧАЛОПЕРИОДА(ДОБАВИТЬКДАТЕ(ПродажиСерийныхНомеров.Период, ДЕНЬ, Сертификаты.КоличествоПериодовДействия), ДЕНЬ)
	|					КОГДА Сертификаты.Периодичность = ЗНАЧЕНИЕ(Перечисление.Периодичность.Неделя)
	|						ТОГДА НАЧАЛОПЕРИОДА(ДОБАВИТЬКДАТЕ(ПродажиСерийныхНомеров.Период, НЕДЕЛЯ, Сертификаты.КоличествоПериодовДействия), ДЕНЬ)
	|					КОГДА Сертификаты.Периодичность = ЗНАЧЕНИЕ(Перечисление.Периодичность.Декада)
	|						ТОГДА НАЧАЛОПЕРИОДА(ДОБАВИТЬКДАТЕ(ПродажиСерийныхНомеров.Период, ДЕКАДА, Сертификаты.КоличествоПериодовДействия), ДЕНЬ)
	|					КОГДА Сертификаты.Периодичность = ЗНАЧЕНИЕ(Перечисление.Периодичность.Месяц)
	|						ТОГДА НАЧАЛОПЕРИОДА(ДОБАВИТЬКДАТЕ(ПродажиСерийныхНомеров.Период, МЕСЯЦ, Сертификаты.КоличествоПериодовДействия), ДЕНЬ)
	|					КОГДА Сертификаты.Периодичность = ЗНАЧЕНИЕ(Перечисление.Периодичность.Квартал)
	|						ТОГДА НАЧАЛОПЕРИОДА(ДОБАВИТЬКДАТЕ(ПродажиСерийныхНомеров.Период, КВАРТАЛ, Сертификаты.КоличествоПериодовДействия), ДЕНЬ)
	|					КОГДА Сертификаты.Периодичность = ЗНАЧЕНИЕ(Перечисление.Периодичность.Полугодие)
	|						ТОГДА НАЧАЛОПЕРИОДА(ДОБАВИТЬКДАТЕ(ПродажиСерийныхНомеров.Период, ПОЛУГОДИЕ, Сертификаты.КоличествоПериодовДействия), ДЕНЬ)
	|					КОГДА Сертификаты.Периодичность = ЗНАЧЕНИЕ(Перечисление.Периодичность.Год)
	|						ТОГДА НАЧАЛОПЕРИОДА(ДОБАВИТЬКДАТЕ(ПродажиСерийныхНомеров.Период, ГОД, Сертификаты.КоличествоПериодовДействия), ДЕНЬ)
	|					ИНАЧЕ ДАТАВРЕМЯ(1, 1, 1)
	|				КОНЕЦ
	|		ИНАЧЕ ДАТАВРЕМЯ(1, 1, 1)
	|	КОНЕЦ КАК ДатаОкончания,
	|	СтатусыСерийныхНомеров.Статус КАК Статус
	|ИЗ
	|	Сертификаты КАК Сертификаты
	|		ЛЕВОЕ СОЕДИНЕНИЕ ПродажиСерийныхНомеров КАК ПродажиСерийныхНомеров
	|		ПО Сертификаты.СерийныйНомер = ПродажиСерийныхНомеров.СерийныйНомер
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрНакопления.ПодарочныеСертификаты.Остатки(
	|				&Период,
	|				ПодарочныйСертификат = &ПодарочныйСертификат
	|					И НомерСертификата = &СерийныйНомер) КАК ПодарочныеСертификатыОстатки
	|		ПО Сертификаты.ПодарочныйСертификат = ПодарочныеСертификатыОстатки.ПодарочныйСертификат
	|			И Сертификаты.СерийныйНомер = ПодарочныеСертификатыОстатки.НомерСертификата
	|		ЛЕВОЕ СОЕДИНЕНИЕ ОборотПоДокументу КАК ОборотПоДокументу
	|		ПО Сертификаты.ПодарочныйСертификат = ОборотПоДокументу.ПодарочныйСертификат
	|			И Сертификаты.СерийныйНомер = ОборотПоДокументу.СерийныйНомер
	|		ЛЕВОЕ СОЕДИНЕНИЕ ПроизвольныеНоминалы КАК ПроизвольныеНоминалы
	|		ПО Сертификаты.ПодарочныйСертификат = ПроизвольныеНоминалы.ПодарочныйСертификат
	|			И Сертификаты.СерийныйНомер = ПроизвольныеНоминалы.НомерСертификата
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ СтатусыСерийныхНомеров КАК СтатусыСерийныхНомеров
	|		ПО Сертификаты.ПодарочныйСертификат = СтатусыСерийныхНомеров.Номенклатура
	|			И Сертификаты.СерийныйНомер = СтатусыСерийныхНомеров.СерийныйНомер");
	
	Запрос.УстановитьПараметр("ПодарочныйСертификат", ПодарочныйСертификат);
	Запрос.УстановитьПараметр("СерийныйНомер", СерийныйНомер);
	Запрос.УстановитьПараметр("Регистратор", Документ);
	Запрос.УстановитьПараметр("Период", ?(ЗначениеЗаполнено(Период), Новый Граница(Период, ВидГраницы.Исключая), Период));
	
	СтруктураВозврата = Новый Структура("Номинал, Остаток, ДатаОкончания, Статус");
	
	Результат = Запрос.Выполнить().Выбрать();
	Если Результат.Следующий() Тогда
		ЗаполнитьЗначенияСвойств(СтруктураВозврата, Результат);
	КонецЕсли;
	
	Возврат СтруктураВозврата;
	
КонецФункции

// Возвращает таблицу с остатками и окончанием действия переданных сертификатов
// Параметры:
//  ТаблицаСертификатов - ТаблицаЗначений - содержит колонки:
//   *ПодарочныйСертификат - СправочникСсылка.Номенклатура
//   *СерийныйНомер - СправочникСсылка.СерийныеНомера
//  ДополнитьИсходнуюТаблицу - Булево - дополняет исходную таблицу колонками сертификата
Функция ПолучитьСтруктуруДанныхПоТаблицеСертификатов(ТаблицаСертификатов, ДополнитьИсходнуюТаблицу = Ложь, Период = Неопределено) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	ТаблицаСертификатов.ПодарочныйСертификат КАК ПодарочныйСертификат,
	|	ТаблицаСертификатов.СерийныйНомер КАК СерийныйНомер
	|ПОМЕСТИТЬ ТаблицаСертификатов
	|ИЗ
	|	&ТаблицаСертификатов КАК ТаблицаСертификатов
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТаблицаСертификатов.ПодарочныйСертификат КАК ПодарочныйСертификат,
	|	ТаблицаСертификатов.СерийныйНомер КАК СерийныйНомер,
	|	Номенклатура.ДатаОкончанияДействия КАК ДатаОкончанияДействия,
	|	Номенклатура.КоличествоПериодовДействия КАК КоличествоПериодовДействия,
	|	Номенклатура.Периодичность КАК Периодичность,
	|	Номенклатура.ТипСрокаДействия КАК ТипСрокаДействия,
	|	Номенклатура.ЧастичноеПогашение КАК ЧастичноеПогашение,
	|	Номенклатура.ПроизвольныйНоминал КАК ПроизвольныйНоминал,
	|	Номенклатура.Номинал КАК Номинал
	|ПОМЕСТИТЬ Сертификаты
	|ИЗ
	|	ТаблицаСертификатов КАК ТаблицаСертификатов
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Номенклатура КАК Номенклатура
	|		ПО ТаблицаСертификатов.ПодарочныйСертификат = Номенклатура.Ссылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ПодарочныеСертификатыОбороты.ПодарочныйСертификат КАК ПодарочныйСертификат,
	|	ПодарочныеСертификатыОбороты.НомерСертификата КАК НомерСертификата,
	|	СУММА(ПодарочныеСертификатыОбороты.СуммаПриход) КАК Номинал
	|ПОМЕСТИТЬ ПроизвольныеНоминалы
	|ИЗ
	|	РегистрНакопления.ПодарочныеСертификаты.Обороты(
	|			,
	|			,
	|			,
	|			(ПодарочныйСертификат, НомерСертификата) В
	|				(ВЫБРАТЬ
	|					Сертификаты.ПодарочныйСертификат,
	|					Сертификаты.СерийныйНомер
	|				ИЗ
	|					Сертификаты
	|				ГДЕ
	|					Сертификаты.ПроизвольныйНоминал)) КАК ПодарочныеСертификатыОбороты
	|
	|СГРУППИРОВАТЬ ПО
	|	ПодарочныеСертификатыОбороты.НомерСертификата,
	|	ПодарочныеСертификатыОбороты.ПодарочныйСертификат
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	ПодарочныйСертификат,
	|	НомерСертификата
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	МАКСИМУМ(ДвиженияСерийныхНомеров.Период) КАК Период,
	|	ДвиженияСерийныхНомеров.СерийныйНомер КАК СерийныйНомер
	|ПОМЕСТИТЬ ПродажиСерийныхНомеров
	|ИЗ
	|	РегистрСведений.ДвиженияСерийныхНомеров КАК ДвиженияСерийныхНомеров
	|ГДЕ
	|	(ДвиженияСерийныхНомеров.Номенклатура, ДвиженияСерийныхНомеров.СерийныйНомер) В
	|			(ВЫБРАТЬ
	|				ТаблицаСертификатов.ПодарочныйСертификат,
	|				ТаблицаСертификатов.СерийныйНомер
	|			ИЗ
	|				ТаблицаСертификатов КАК ТаблицаСертификатов)
	|	И ДвиженияСерийныхНомеров.АналитикаХозяйственнойОперации = ЗНАЧЕНИЕ(Справочник.АналитикаХозяйственныхОпераций.РеализацияТоваров)
	|
	|СГРУППИРОВАТЬ ПО
	|	ДвиженияСерийныхНомеров.СерийныйНомер
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Сертификаты.ПодарочныйСертификат КАК ПодарочныйСертификат,
	|	Сертификаты.СерийныйНомер КАК СерийныйНомер,
	|	ВЫБОР
	|		КОГДА Сертификаты.ПроизвольныйНоминал
	|			ТОГДА ЕСТЬNULL(ПроизвольныеНоминалы.Номинал, 0)
	|		ИНАЧЕ Сертификаты.Номинал
	|	КОНЕЦ КАК Номинал,
	|	ВЫБОР
	|		КОГДА Сертификаты.ЧастичноеПогашение
	|				ИЛИ Сертификаты.ПроизвольныйНоминал
	|			ТОГДА ЕСТЬNULL(ПодарочныеСертификатыОстатки.СуммаОстаток, 0)
	|		ИНАЧЕ Сертификаты.Номинал
	|	КОНЕЦ КАК Остаток,
	|	ВЫБОР
	|		КОГДА Сертификаты.ТипСрокаДействия = ЗНАЧЕНИЕ(Перечисление.СрокДействияПодарочныхСертификатов.СОграничениемНаДату)
	|			ТОГДА Сертификаты.ДатаОкончанияДействия
	|		КОГДА Сертификаты.ТипСрокаДействия = ЗНАЧЕНИЕ(Перечисление.СрокДействияПодарочныхСертификатов.ПериодПослеПродажи)
	|			ТОГДА ВЫБОР
	|					КОГДА Сертификаты.Периодичность = ЗНАЧЕНИЕ(Перечисление.Периодичность.День)
	|						ТОГДА НАЧАЛОПЕРИОДА(ДОБАВИТЬКДАТЕ(ПродажиСерийныхНомеров.Период, ДЕНЬ, Сертификаты.КоличествоПериодовДействия), ДЕНЬ)
	|					КОГДА Сертификаты.Периодичность = ЗНАЧЕНИЕ(Перечисление.Периодичность.Неделя)
	|						ТОГДА НАЧАЛОПЕРИОДА(ДОБАВИТЬКДАТЕ(ПродажиСерийныхНомеров.Период, НЕДЕЛЯ, Сертификаты.КоличествоПериодовДействия), ДЕНЬ)
	|					КОГДА Сертификаты.Периодичность = ЗНАЧЕНИЕ(Перечисление.Периодичность.Декада)
	|						ТОГДА НАЧАЛОПЕРИОДА(ДОБАВИТЬКДАТЕ(ПродажиСерийныхНомеров.Период, ДЕКАДА, Сертификаты.КоличествоПериодовДействия), ДЕНЬ)
	|					КОГДА Сертификаты.Периодичность = ЗНАЧЕНИЕ(Перечисление.Периодичность.Месяц)
	|						ТОГДА НАЧАЛОПЕРИОДА(ДОБАВИТЬКДАТЕ(ПродажиСерийныхНомеров.Период, МЕСЯЦ, Сертификаты.КоличествоПериодовДействия), ДЕНЬ)
	|					КОГДА Сертификаты.Периодичность = ЗНАЧЕНИЕ(Перечисление.Периодичность.Квартал)
	|						ТОГДА НАЧАЛОПЕРИОДА(ДОБАВИТЬКДАТЕ(ПродажиСерийныхНомеров.Период, КВАРТАЛ, Сертификаты.КоличествоПериодовДействия), ДЕНЬ)
	|					КОГДА Сертификаты.Периодичность = ЗНАЧЕНИЕ(Перечисление.Периодичность.Полугодие)
	|						ТОГДА НАЧАЛОПЕРИОДА(ДОБАВИТЬКДАТЕ(ПродажиСерийныхНомеров.Период, ПОЛУГОДИЕ, Сертификаты.КоличествоПериодовДействия), ДЕНЬ)
	|					КОГДА Сертификаты.Периодичность = ЗНАЧЕНИЕ(Перечисление.Периодичность.Год)
	|						ТОГДА НАЧАЛОПЕРИОДА(ДОБАВИТЬКДАТЕ(ПродажиСерийныхНомеров.Период, ГОД, Сертификаты.КоличествоПериодовДействия), ДЕНЬ)
	|					ИНАЧЕ ДАТАВРЕМЯ(1, 1, 1)
	|				КОНЕЦ
	|		ИНАЧЕ ДАТАВРЕМЯ(1, 1, 1)
	|	КОНЕЦ КАК ДатаОкончания
	|ИЗ
	|	Сертификаты КАК Сертификаты
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрНакопления.ПодарочныеСертификаты.Остатки(
	|				&Период,
	|				(ПодарочныйСертификат, НомерСертификата) В
	|					(ВЫБРАТЬ
	|						ТаблицаСертификатов.ПодарочныйСертификат,
	|						ТаблицаСертификатов.СерийныйНомер
	|					ИЗ
	|						ТаблицаСертификатов КАК ТаблицаСертификатов)) КАК ПодарочныеСертификатыОстатки
	|		ПО Сертификаты.ПодарочныйСертификат = ПодарочныеСертификатыОстатки.ПодарочныйСертификат
	|			И Сертификаты.СерийныйНомер = ПодарочныеСертификатыОстатки.НомерСертификата
	|		ЛЕВОЕ СОЕДИНЕНИЕ ПродажиСерийныхНомеров КАК ПродажиСерийныхНомеров
	|		ПО Сертификаты.СерийныйНомер = ПродажиСерийныхНомеров.СерийныйНомер
	|		ЛЕВОЕ СОЕДИНЕНИЕ ПроизвольныеНоминалы КАК ПроизвольныеНоминалы
	|		ПО Сертификаты.ПодарочныйСертификат = ПроизвольныеНоминалы.ПодарочныйСертификат
	|			И Сертификаты.СерийныйНомер = ПроизвольныеНоминалы.НомерСертификата");
	
	Запрос.УстановитьПараметр("ТаблицаСертификатов", ТаблицаСертификатов);
	Запрос.УстановитьПараметр("Период", ?(ЗначениеЗаполнено(Период), Новый Граница(Период, ВидГраницы.Исключая), Период));
	Результат = Запрос.Выполнить().Выгрузить();
	
	Если ДополнитьИсходнуюТаблицу Тогда
		
		ТаблицаСертификатов.Колонки.Добавить("Номинал");
		ТаблицаСертификатов.Колонки.Добавить("Остаток");
		ТаблицаСертификатов.Колонки.Добавить("ДатаОкончания");
		
		Для Каждого СтрокаИсходнойТаблицы Из ТаблицаСертификатов Цикл
			
			СтруктураПоиска = Новый Структура;
			СтруктураПоиска.Вставить("ПодарочныйСертификат", 	СтрокаИсходнойТаблицы.ПодарочныйСертификат);
			СтруктураПоиска.Вставить("СерийныйНомер", 			СтрокаИсходнойТаблицы.СерийныйНомер);
			
			СтрокиПодарочныхСертификатов = Результат.НайтиСтроки(СтруктураПоиска);
			Для Каждого СтрокаПодарочногоСертификата Из СтрокиПодарочныхСертификатов Цикл
				ЗаполнитьЗначенияСвойств(СтрокаИсходнойТаблицы, СтрокаПодарочногоСертификата);
			КонецЦикла;
			
		КонецЦикла;
		
		Результат = ТаблицаСертификатов;
		
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

// Обновление номенклатуры.
//
// Параметры:
//  Объект				 - Ссылка - ссылка на номенклатуру.
//  ЧекККМ				 - Строка - идентификатор номенклатуры.
//
Процедура ДополнитьТоварыОстаткамиПодарочнхСертификатов(Объект, ЧекККМ) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	НеобходимПересчет = Ложь;
	КлючСвязиСерийныхНомеров = 1;
	
	Для Каждого ТоварЧекаККМ Из ЧекККМ.Товары Цикл
		
		Если ТоварЧекаККМ.Номенклатура.ТипНоменклатуры = Перечисления.ТипыНоменклатуры.ПодарочныйСертификат Тогда
			
			СтруктураОтбора = Новый Структура("КлючСвязиСерийныхНомеров", ТоварЧекаККМ.КлючСвязиСерийныхНомеров);
			НайденныеСерийныеНомера = ЧекККМ.СерийныеНомера.НайтиСтроки(СтруктураОтбора);
			Если ЗначениеЗаполнено(НайденныеСерийныеНомера) Тогда
				Для Каждого СтрокаСерийныйНомер Из НайденныеСерийныеНомера Цикл
					
					СведенияОСертификате = РаботаСПодарочнымиСертификатами.ПолучитьСтруктуруДанныхСертификата(ТоварЧекаККМ.Номенклатура, СтрокаСерийныйНомер.СерийныйНомер);
					
					Если СведенияОСертификате.Статус = Справочники.АналитикаХозяйственныхОпераций.РеализацияТоваров Тогда
						НоваяСтрокаТовары = Объект.Товары.Добавить();
						ЗаполнитьЗначенияСвойств(НоваяСтрокаТовары, ТоварЧекаККМ);
						НоваяСтрокаТовары.Количество = 1;
						НоваяСтрокаТовары.КоличествоУпаковок = 1;
						НоваяСтрокаТовары.Цена = СведенияОСертификате.Остаток;
						НоваяСтрокаТовары.КлючСвязиСерийныхНомеров = КлючСвязиСерийныхНомеров;
						
						НоваяСтрокаСерийныеНомера = Объект.СерийныеНомера.Добавить();
						НоваяСтрокаСерийныеНомера.КлючСвязиСерийныхНомеров = КлючСвязиСерийныхНомеров;
						НоваяСтрокаСерийныеНомера.СерийныйНомер = СтрокаСерийныйНомер.СерийныйНомер;
						
						КлючСвязиСерийныхНомеров = КлючСвязиСерийныхНомеров + 1;
					КонецЕсли;
					
				КонецЦикла;
			Иначе
				
				СведенияОСертификате = РаботаСПодарочнымиСертификатами.ПолучитьСтруктуруДанныхСертификата(ТоварЧекаККМ.Номенклатура, Справочники.СерийныеНомера.ПустаяСсылка());
					
				Если СведенияОСертификате.Статус = Справочники.АналитикаХозяйственныхОпераций.РеализацияТоваров Тогда
					НоваяСтрокаТовары = Объект.Товары.Добавить();
					ЗаполнитьЗначенияСвойств(НоваяСтрокаТовары, ТоварЧекаККМ);
				КонецЕсли;
			КонецЕсли;
			
			НеобходимПересчет = Истина;
			
		КонецЕсли;
		
	КонецЦикла;
	
	Если НеобходимПересчет Тогда
		СтруктураДействий = Новый Структура;
		СтруктураДействий.Вставить("ПересчитатьСумму");
		СтруктураДействий.Вставить("ПересчитатьСуммуСУчетомАвтоматическойСкидки", Новый Структура("Очищать", Истина));
		СтруктураДействий.Вставить("ПересчитатьСуммуСУчетомРучнойСкидки", Новый Структура("Очищать", Ложь));
		СтруктураДействий.Вставить("ПересчитатьСуммуНДС",
			ОбработкаТабличнойЧастиТоварыКлиентСервер.СтруктураПересчетаСуммыНДСВСтрокеТЧ(Объект));
		СтруктураДействий.ПересчитатьСуммуНДС.Вставить("НеобходимоОбработатьВсюТЧ");
		
		ОбработкаТабличнойЧастиТоварыСервер.ПриИзмененииРеквизитовВТЧСервер(
			Новый Структура("СтрокиТЧ", Объект.Товары), СтруктураДействий, Неопределено);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти