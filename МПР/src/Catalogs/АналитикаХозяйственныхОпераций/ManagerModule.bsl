#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Возвращает хозяйственную операцию по умолчанию.
//
// Параметры:
//  ХозяйственнаяОперация - ПеречислениеСсылка.ХозяйственныеОперации - хозяйственная операция по умолчанию.
//
// Возвращаемое значение:
//  СправочникСсылка.ХозяйственныеОперации
//
Функция ПолучитьОперациюПоУмолчанию(ХозяйственнаяОперация) Экспорт 
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ ПЕРВЫЕ 2
	|	АналитикаХозяйственныхОпераций.Ссылка КАК АналитикаХозяйственнойОперации
	|ИЗ
	|	Справочник.АналитикаХозяйственныхОпераций КАК АналитикаХозяйственныхОпераций
	|ГДЕ
	|	АналитикаХозяйственныхОпераций.ХозяйственнаяОперация = &ХозяйственнаяОперация
	|	И НЕ АналитикаХозяйственныхОпераций.ПометкаУдаления";
	
	Запрос.УстановитьПараметр("ХозяйственнаяОперация", ХозяйственнаяОперация);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Количество() = 1 Тогда
		Выборка.Следующий();
		АналитикаХозяйственнойОперации = Выборка.АналитикаХозяйственнойОперации;
	Иначе
		АналитикаХозяйственнойОперации = Справочники.АналитикаХозяйственныхОпераций.ПустаяСсылка();
	КонецЕсли;
	
	Возврат АналитикаХозяйственнойОперации;
	
КонецФункции

// Заполняет предопределенные элементы статей движения денежных средств.
//
Процедура ЗаполнитьПредопределенные() Экспорт
	
	Соответствие = Новый Соответствие;
	Соответствие.Вставить(Справочники.АналитикаХозяйственныхОпераций.КомплектацияНоменклатуры,
		Перечисления.ХозяйственныеОперации.КомплектацияНоменклатуры);
	Соответствие.Вставить(Справочники.АналитикаХозяйственныхОпераций.ОприходованиеТоваров,
		Перечисления.ХозяйственныеОперации.Оприходование);
	Соответствие.Вставить(Справочники.АналитикаХозяйственныхОпераций.ПеремещениеТоваров,
		Перечисления.ХозяйственныеОперации.ПеремещениеТоваров);
	Соответствие.Вставить(Справочники.АналитикаХозяйственныхОпераций.ПогашениеПодарочныхСертификатов,
		Перечисления.ХозяйственныеОперации.ПогашениеПодарочныхСертификатов);
	Соответствие.Вставить(Справочники.АналитикаХозяйственныхОпераций.ПоступлениеТоваров,
		Перечисления.ХозяйственныеОперации.ПоступлениеТоваров);
	Соответствие.Вставить(Справочники.АналитикаХозяйственныхОпераций.РеализацияТоваров,
		Перечисления.ХозяйственныеОперации.РеализацияТоваров);
	Соответствие.Вставить(Справочники.АналитикаХозяйственныхОпераций.СкидкиПодарки,
		Перечисления.ХозяйственныеОперации.СписаниеНаЗатраты);
	Соответствие.Вставить(Справочники.АналитикаХозяйственныхОпераций.ПередачаТоваровДоРеализации,
		Перечисления.ХозяйственныеОперации.ПередачаТоваровДоРеализации);
	Соответствие.Вставить(Справочники.АналитикаХозяйственныхОпераций.ПередачаТоваровПослеРеализации,
		Перечисления.ХозяйственныеОперации.ПередачаТоваровПослеРеализации);
	Соответствие.Вставить(Справочники.АналитикаХозяйственныхОпераций.ПриемТоваровОтДругойОрганизации,
		Перечисления.ХозяйственныеОперации.ПриемТоваровОтДругойОрганизации);
	Соответствие.Вставить(Справочники.АналитикаХозяйственныхОпераций.ПересортицаТоваров,
		Перечисления.ХозяйственныеОперации.ПересортицаТоваров);
	Соответствие.Вставить(Справочники.АналитикаХозяйственныхОпераций.ОтгрузкаНаВнутренниеНужды,
		Перечисления.ХозяйственныеОперации.ОтгрузкаНаВнутренниеНужды);
	Соответствие.Вставить(Справочники.АналитикаХозяйственныхОпераций.ОприходованиеКомиссионныхТоваров,
		Перечисления.ХозяйственныеОперации.ОприходованиеКомиссионныхТоваров);
	Соответствие.Вставить(Справочники.АналитикаХозяйственныхОпераций.ВознаграждениеОтКомитента,
		Перечисления.ХозяйственныеОперации.ВознаграждениеОтКомитента);
	Соответствие.Вставить(Справочники.АналитикаХозяйственныхОпераций.ПоступлениеКомиссионныхТоваров,
		Перечисления.ХозяйственныеОперации.ПриемНаКомиссию);

	Для Каждого Элемент Из Соответствие Цикл
	
		СправочникОбъект = Элемент.Ключ.ПолучитьОбъект();
		Если НЕ СправочникОбъект.ХозяйственнаяОперация = Элемент.Значение Тогда
			СправочникОбъект.ХозяйственнаяОперация = Элемент.Значение;
			Попытка
				СправочникОбъект.Записать();
			Исключение
				ЗаписьЖурналаРегистрации(НСтр("ru = 'Выполнение операции'"),
				УровеньЖурналаРегистрации.Ошибка,,,
				ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
			КонецПопытки;
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

// Определяет настройки объекта для подсистемы ВерсионированиеОбъектов.
//
// Параметры:
//  Настройки - Структура - настройки подсистемы.
Процедура ПриОпределенииНастроекВерсионированияОбъектов(Настройки) Экспорт
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
