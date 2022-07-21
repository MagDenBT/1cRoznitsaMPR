#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Возвращает организацию, валюту, номер счета, БИК выбранного банковского счета.
//
// Параметры:
//  БанковскийСчет - СправочникСсылка.УдалитьБанковскиеСчетаОрганизаций - Ссылка на банковский счет.
//
// Возвращаемое значение:
//	Структура - Организация, валюта, номер счета, БИК банковского счета.
//
Функция РеквизитыБанковскогоСчетаОрганизации(БанковскийСчет) Экспорт
	
	Запрос = Новый Запрос();
	Запрос.Текст = "
	|ВЫБРАТЬ
	|	БанковскиеСчета.Владелец   КАК Организация,
	|	БанковскиеСчета.НомерСчета КАК НомерСчета,
	|	БанковскиеСчета.Банк       КАК Банк,
	|
	|	ВЫБОР	КОГДА БанковскиеСчета.РучноеИзменениеРеквизитовБанка
	|			ТОГДА БанковскиеСчета.БИКБанка
	|			ИНАЧЕ БанковскиеСчета.Банк.Код
	|	КОНЕЦ                      КАК БИК,
	|	ВЫБОР	КОГДА БанковскиеСчета.РучноеИзменениеРеквизитовБанка
	|			ТОГДА БанковскиеСчета.КоррСчетБанка
	|			ИНАЧЕ БанковскиеСчета.Банк.КоррСчет
	|	КОНЕЦ                      КАК КоррСчет
 	|ИЗ
	|	Справочник.УдалитьБанковскиеСчетаОрганизаций КАК БанковскиеСчета
	|ГДЕ
	|	БанковскиеСчета.Ссылка = &БанковскийСчет
	|";
	
	Запрос.УстановитьПараметр("БанковскийСчет", БанковскийСчет);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		Организация = Выборка.Организация;
		НомерСчета = Выборка.НомерСчета;
		Банк = Выборка.Банк;
		БИК = Выборка.БИК;
		КоррСчет = Выборка.КоррСчет;
	Иначе
		Организация = Неопределено;
		НомерСчета = "";
		Банк = Неопределено;
		БИК = "";
		КоррСчет = "";
	КонецЕсли;
	
	СтруктураРеквизитов = Новый Структура;
	СтруктураРеквизитов.Вставить("Организация", Организация);
	СтруктураРеквизитов.Вставить("НомерСчета", НомерСчета);
	СтруктураРеквизитов.Вставить("Банк", Банк);
	СтруктураРеквизитов.Вставить("БИК", БИК);
	СтруктураРеквизитов.Вставить("КоррСчет", КоррСчет);
	
	Возврат СтруктураРеквизитов;

КонецФункции

// Возвращает банковский счет организации.
// Возвращает Неопределено, если банковский счет не найден или счетов больше одного.
//
// Параметры:
//  Организация - СправочникСсылка.Организации - Ссылка на организацию.
//  НайтиЛюбой - Булево - Выбрать любой счет, даже если их больше одного.
//
// Возвращаемое значение:
//	СправочникСсылка.БанковскиеСчетаОрганизаций - Найденный банковский счет организации.
//
Функция БанковскийСчетОрганизацииПоУмолчанию(Организация, НайтиЛюбой = Ложь) Экспорт
	
	Запрос = Новый Запрос("
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ ПЕРВЫЕ 2
	|	БанковскиеСчетаОрганизаций.Ссылка КАК БанковскийСчетОрганизации
	|ИЗ
	|	Справочник.УдалитьБанковскиеСчетаОрганизаций КАК БанковскиеСчетаОрганизаций
	|ГДЕ
	|	НЕ БанковскиеСчетаОрганизаций.ПометкаУдаления
	|	И БанковскиеСчетаОрганизаций.Владелец = &Организация
	|");
	
	Запрос.УстановитьПараметр("Организация", Организация);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Выборка.Следующий();
	Если Выборка.Количество() = 1 ИЛИ
			(Выборка.Количество() > 1 И НайтиЛюбой) Тогда
		БанковскийСчетОрганизации = Выборка.БанковскийСчетОрганизации;
	Иначе
		БанковскийСчетОрганизации = Справочники.БанковскиеСчетаОрганизаций.ПустаяСсылка();
	КонецЕсли;
	
	Возврат БанковскийСчетОрганизации;

КонецФункции

// Определяет настройки объекта для подсистемы ВерсионированиеОбъектов.
//
// Параметры:
//  Настройки - Структура - настройки подсистемы.
Процедура ПриОпределенииНастроекВерсионированияОбъектов(Настройки) Экспорт
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
