#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ, Замещение)

	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если НЕ ПроведениеСервер.РассчитыватьИзменения(ДополнительныеСвойства) Тогда
		Возврат;
	КонецЕсли;
	
	ТребуетсяКонтроль = Истина;
	
	Для Каждого Запись Из ЭтотОбъект Цикл
		Если (ЗначениеЗаполнено(Запись.Отправитель) И Запись.Количество <> 0) Тогда
			ТребуетсяКонтроль = УправлениеПользователями.ПолучитьБулевоЗначениеПраваПользователя(ПланыВидовХарактеристик.ПраваПользователей.КонтролироватьОстатокПриПроведении, Ложь);
			Прервать;
		КонецЕсли;
	КонецЦикла;

	Если Не ТребуетсяКонтроль Тогда
		ДополнительныеСвойства.РассчитыватьИзменения = Ложь;
		Возврат;
	КонецЕсли;

	СтруктураВременныеТаблицы = ДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы;
	БлокироватьДляИзменения = Истина;

	// Текущее состояние набора помещается во временную таблицу "ДвиженияТоварыНаСкладахПередЗаписью",
	// чтобы при записи получить изменение нового набора относительно текущего.
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Регистратор", Отбор.Регистратор.Значение);
	Запрос.УстановитьПараметр("ЭтоНовый",    ДополнительныеСвойства.ЭтоНовый);
	Запрос.МенеджерВременныхТаблиц = СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
	
	Запрос.Текст =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	Таблица.Номенклатура   КАК Номенклатура,
	|	Таблица.СерийныйНомер  КАК СерийныйНомер,
	|	Таблица.Отправитель    КАК Склад,
	|	Таблица.Количество     КАК КоличествоПередЗаписью
	|ПОМЕСТИТЬ ДвиженияДвиженияСерийныхНомеровПередЗаписью
	|ИЗ
	|	РегистрСведений.ДвиженияСерийныхНомеров КАК Таблица
	|ГДЕ
	|	Таблица.Регистратор = &Регистратор
	|	И (НЕ Таблица.Отправитель = ЗНАЧЕНИЕ(Справочник.Склады.ПустаяСсылка))
	|	И (НЕ &ЭтоНовый)";
	Запрос.Выполнить();

КонецПроцедуры

Процедура ПриЗаписи(Отказ, Замещение)

	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если НЕ ПроведениеСервер.РассчитыватьИзменения(ДополнительныеСвойства) Тогда
		Возврат;
	КонецЕсли;

	СтруктураВременныеТаблицы = ДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы;

	// Рассчитывается изменение нового набора относительно текущего с учетом накопленных изменений
	// и помещается во временную таблицу.
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Регистратор", Отбор.Регистратор.Значение);
	Запрос.МенеджерВременныхТаблиц = СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
	Запрос.Текст =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ТаблицаИзменений.Номенклатура КАК Номенклатура,
	|	ТаблицаИзменений.СерийныйНомер КАК СерийныйНомер,
	|	ТаблицаИзменений.Склад КАК Склад,
	|	СУММА(ТаблицаИзменений.КоличествоИзменение) КАК КоличествоИзменение
	|ПОМЕСТИТЬ ДвиженияДвиженияСерийныхНомеровИзменение
	|ИЗ
	|	(ВЫБРАТЬ
	|		Таблица.Номенклатура КАК Номенклатура,
	|		Таблица.СерийныйНомер КАК СерийныйНомер,
	|		Таблица.Склад КАК Склад,
	|		Таблица.КоличествоПередЗаписью КАК КоличествоИзменение
	|	ИЗ
	|		ДвиженияДвиженияСерийныхНомеровПередЗаписью КАК Таблица
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		Таблица.Номенклатура,
	|		Таблица.СерийныйНомер,
	|		Таблица.Отправитель,
	|		-Таблица.Количество
	|	ИЗ
	|		РегистрСведений.ДвиженияСерийныхНомеров КАК Таблица
	|	ГДЕ
	|		Таблица.Регистратор = &Регистратор
	|		И (НЕ Таблица.Отправитель = ЗНАЧЕНИЕ(Справочник.Склады.ПустаяСсылка))) КАК ТаблицаИзменений
	|
	|СГРУППИРОВАТЬ ПО
	|	ТаблицаИзменений.Номенклатура,
	|	ТаблицаИзменений.Склад,
	|	ТаблицаИзменений.СерийныйНомер
	|
	|ИМЕЮЩИЕ
	|	СУММА(ТаблицаИзменений.КоличествоИзменение) < 0
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|УНИЧТОЖИТЬ ДвиженияДвиженияСерийныхНомеровПередЗаписью";
	Выборка = Запрос.ВыполнитьПакет()[0].Выбрать();
	Выборка.Следующий();
	
	// Добавляется информация о ее существовании и наличии в ней записей об изменении.
	СтруктураВременныеТаблицы.Вставить("ДвиженияДвиженияСерийныхНомеровИзменение", Выборка.Количество > 0);

КонецПроцедуры

#КонецОбласти

#КонецЕсли
