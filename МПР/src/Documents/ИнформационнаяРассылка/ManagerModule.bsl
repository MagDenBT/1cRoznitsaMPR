#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Функция формирует текст запроса к сведениям физических лиц.
// Возвращаемое значение:
// 		ТекстЗапроса - Строка. Содержит текст запроса.
Функция ТекстЗапросаДляЗаполненияРассылки() Экспорт
	
	ТекстЗапроса = "ВЫБРАТЬ
	|	Подзапрос.Контакт КАК Контакт,
	|	ВЫБОР
	|		КОГДА &СкрытиеПерсональныхДанных = ИСТИНА
	|			ТОГДА """"
	|		ИНАЧЕ ЕСТЬNULL(МАКСИМУМ(Подзапрос.Имя), """") + "" "" + ЕСТЬNULL(МАКСИМУМ(Подзапрос.Отчество), """")
	|	КОНЕЦ КАК ПредставлениеКонтакта,
	|	ВЫБОР
	|		КОГДА &ЭтоSMS = ИСТИНА
	|			ТОГДА ЕСТЬNULL(МАКСИМУМ(Подзапрос.НомерТелефона), """")
	|		ИНАЧЕ ЕСТЬNULL(МАКСИМУМ(Подзапрос.АдресЭП), """")
	|	КОНЕЦ КАК КонтактнаяИнформация
	|ПОМЕСТИТЬ ВТКонтактнаяИнформация
	|ИЗ
	|	(ВЫБРАТЬ
	|		СоставГруппы.Получатель КАК Контакт,
	|		"""" КАК Фамилия,
	|		"""" КАК Имя,
	|		"""" КАК Отчество,
	|		ФизическиеЛицаКонтактнаяИнформация.АдресЭП КАК АдресЭП,
	|		"""" КАК НомерТелефона,
	|		"""" КАК Представление
	|	ИЗ
	|		СоставГруппы КАК СоставГруппы
	|			ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ФизическиеЛица.КонтактнаяИнформация КАК ФизическиеЛицаКонтактнаяИнформация
	|			ПО СоставГруппы.Получатель = ФизическиеЛицаКонтактнаяИнформация.Ссылка
	|				И (ФизическиеЛицаКонтактнаяИнформация.Тип = &АдресЭлектроннойПочты)
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		СоставГруппы.Получатель,
	|		"""",
	|		"""",
	|		"""",
	|		"""",
	|		ФизическиеЛицаКонтактнаяИнформация.НомерТелефона,
	|		ФизическиеЛицаКонтактнаяИнформация.Представление
	|	ИЗ
	|		СоставГруппы КАК СоставГруппы
	|			ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ФизическиеЛица.КонтактнаяИнформация КАК ФизическиеЛицаКонтактнаяИнформация
	|			ПО СоставГруппы.Получатель = ФизическиеЛицаКонтактнаяИнформация.Ссылка
	|				И (ФизическиеЛицаКонтактнаяИнформация.Тип = &Телефон)
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		СоставГруппы.Получатель,
	|		ФИОФизЛицСрезПоследних.Фамилия,
	|		ФИОФизЛицСрезПоследних.Имя,
	|		ФИОФизЛицСрезПоследних.Отчество,
	|		"""",
	|		"""",
	|		""""
	|	ИЗ
	|		СоставГруппы КАК СоставГруппы
	|			ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ФИОФизЛиц.СрезПоследних КАК ФИОФизЛицСрезПоследних
	|			ПО СоставГруппы.Получатель = ФИОФизЛицСрезПоследних.ФизЛицо) КАК Подзапрос
	|
	|СГРУППИРОВАТЬ ПО
	|	Подзапрос.Контакт
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВТКонтактнаяИнформация.Контакт КАК Контакт,
	|	ВТКонтактнаяИнформация.ПредставлениеКонтакта КАК ПредставлениеКонтакта,
	|	ВТКонтактнаяИнформация.КонтактнаяИнформация КАК КонтактнаяИнформация
	|ИЗ
	|	ВТКонтактнаяИнформация КАК ВТКонтактнаяИнформация
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СубъектыДляСкрытияПерсональныхДанных КАК СубъектыДляСкрытияПерсональныхДанных
	|		ПО ВТКонтактнаяИнформация.Контакт = СубъектыДляСкрытияПерсональныхДанных.Субъект
	|ГДЕ
	|	(СубъектыДляСкрытияПерсональныхДанных.Состояние ЕСТЬ NULL
	|			ИЛИ НЕ СубъектыДляСкрытияПерсональныхДанных.Состояние = ЗНАЧЕНИЕ(Перечисление.СостоянияСубъектовДляСкрытия.СкрытиеВыполнено))";
	
	Возврат ТекстЗапроса;
	
КонецФункции

// Определяет настройки объекта для подсистемы ВерсионированиеОбъектов.
//
// Параметры:
//  Настройки - Структура - настройки подсистемы.
Процедура ПриОпределенииНастроекВерсионированияОбъектов(Настройки) Экспорт
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли

