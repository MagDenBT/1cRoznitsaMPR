////////////////////////////////////////////////////////////////////////////////
// ИнформационныеКартыВызовСервера содержит процедуры и функции 
// для работы с информационными рассылками.
//  
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Определяет, нужно ли проводить опрос владельца проверяемой карты на указанную дату.
//
// Параметры:
//  Карта - СправочникСсылка.ИнформационныеКарты - ссылка на проверяемую карту.
//  ДатаСобытия - Дата - дата проверки.
//
// Возвращаемое значение
//  Булево - Истина - нужно проводить опрос, Ложь - иначе.
//
Функция НеобходимостьОпросаВладельца(Карта, ДатаСобытия) Экспорт
	
	ЕстьНеобходимость = Ложь;
	ПользователюМожноПроводитьОпрос = УправлениеПользователями.ПолучитьБулевоЗначениеПраваПользователя(
										ПланыВидовХарактеристик.ПраваПользователей.ПроводитьОпросВладельцевДисконтныхКартПриОформленииДокументов,
										Ложь);
	
	Если ПользователюМожноПроводитьОпрос Тогда
		
		СтруктураРеквизитовКарты = Новый Структура;
		СтруктураРеквизитовКарты.Вставить("ДатаСледующегоОпроса", "ДатаСледующегоОпроса");
		СтруктураРеквизитовКарты.Вставить("ТипКарты", "ТипКарты");
		РеквизитыКарты = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Карта, СтруктураРеквизитовКарты);
		ДатаСледующегоОпроса = РеквизитыКарты.ДатаСледующегоОпроса;
		ТипКарты = РеквизитыКарты.ТипКарты;
		
		Если ЗначениеЗаполнено(Карта.ДатаСледующегоОпроса) 
			И ДатаСобытия >= ДатаСледующегоОпроса 
			И ТипКарты = Перечисления.ТипыИнформационныхКарт.Дисконтная Тогда
			
			ЕстьНеобходимость = Истина;
			
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат ЕстьНеобходимость;
	
КонецФункции // НеобходимостьОпросаВладельца()

// Возвращает текст запроса поиска дисконтной карты
//
// Параметры:
//  РежимПоискаКарты - Число - число режима поиска дисконтной карты.
//
// Возвращаемое значение:
//  Строка - текст запроса.
//
Функция ТекстЗапросаПоискаКарты(РежимПоискаКарты) Экспорт
	
	Если РежимПоискаКарты = 1 Тогда
		// Поиск по номеру телефона.
		ТекстЗапроса = 
		"ВЫБРАТЬ
		|	КонтактнаяИнформация.Ссылка КАК Ссылка,
		|	КонтактнаяИнформация.НомерТелефона КАК НомерТелефона,
		|	КонтактнаяИнформация.АдресЭП КАК АдресЭП
		|ПОМЕСТИТЬ Владельцы
		|ИЗ
		|	Справочник.ФизическиеЛица.КонтактнаяИнформация КАК КонтактнаяИнформация
		|ГДЕ
		|	(КонтактнаяИнформация.НомерТелефона = &ВведенноеЧисло
		|			ИЛИ КонтактнаяИнформация.НомерТелефона = &ВведенноеЧислоСВосьмеркой)
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	КонтактнаяИнформация.Ссылка,
		|	КонтактнаяИнформация.НомерТелефона,
		|	КонтактнаяИнформация.АдресЭП
		|ИЗ
		|	Справочник.Контрагенты.КонтактнаяИнформация КАК КонтактнаяИнформация
		|ГДЕ
		|	(КонтактнаяИнформация.НомерТелефона = &ВведенноеЧисло
		|			ИЛИ КонтактнаяИнформация.НомерТелефона = &ВведенноеЧислоСВосьмеркой)
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	Контрагенты.Ссылка,
		|	КонтактнаяИнформацияФЛ.НомерТелефона,
		|	КонтактнаяИнформацияФЛ.АдресЭП
		|ИЗ
		|	Справочник.Контрагенты КАК Контрагенты
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.ФизическиеЛица.КонтактнаяИнформация КАК КонтактнаяИнформацияФЛ
		|		ПО Контрагенты.ФизЛицо = КонтактнаяИнформацияФЛ.Ссылка
		|			И (КонтактнаяИнформацияФЛ.НомерТелефона = &ВведенноеЧисло
		|				ИЛИ КонтактнаяИнформацияФЛ.НомерТелефона = &ВведенноеЧислоСВосьмеркой)
		|ГДЕ
		|	Контрагенты.ЮрФизЛицо = ЗНАЧЕНИЕ(Перечисление.ЮрФизЛицо.ФизЛицо)
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	КонтактнаяИнформация.Ссылка КАК Ссылка,
		|	КонтактнаяИнформация.Ссылка.ВладелецКарты КАК ВладелецКарты,
		|	КонтактнаяИнформация.НомерТелефона КАК НомерТелефона,
		|	КонтактнаяИнформация.АдресЭП КАК АдресЭП
		|ПОМЕСТИТЬ КартыИзКонтактнойИнформации
		|ИЗ
		|	Справочник.ИнформационныеКарты.КонтактнаяИнформация КАК КонтактнаяИнформация
		|ГДЕ
		|	(КонтактнаяИнформация.НомерТелефона = &ВведенноеЧисло
		|			ИЛИ КонтактнаяИнформация.НомерТелефона = &ВведенноеЧислоСВосьмеркой)
		|	И КонтактнаяИнформация.Ссылка.ТипКарты = &ТипКарты
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	Карты.Ссылка КАК Ссылка,
		|	Владельцы.Ссылка КАК ВладелецКарты,
		|	Владельцы.НомерТелефона КАК НомерТелефона,
		|	Владельцы.АдресЭП КАК АдресЭП
		|ПОМЕСТИТЬ ТаблицаКарт
		|ИЗ
		|	Справочник.ИнформационныеКарты КАК Карты
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Владельцы КАК Владельцы
		|		ПО (Владельцы.Ссылка = Карты.ВладелецКарты)
		|ГДЕ
		|	Карты.ТипКарты = &ТипКарты
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	КартыИзКонтактнойИнформации.Ссылка,
		|	КартыИзКонтактнойИнформации.ВладелецКарты,
		|	КартыИзКонтактнойИнформации.НомерТелефона,
		|	КартыИзКонтактнойИнформации.АдресЭП
		|ИЗ
		|	КартыИзКонтактнойИнформации КАК КартыИзКонтактнойИнформации
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	ТаблицаКарт.Ссылка КАК Ссылка,
		|	ТаблицаКарт.ВладелецКарты КАК ВладелецКарты,
		|	ТаблицаКарт.НомерТелефона КАК НомерТелефона,
		|	ТаблицаКарт.АдресЭП КАК АдресЭП
		|ИЗ
		|	ТаблицаКарт КАК ТаблицаКарт";
	ИначеЕсли РежимПоискаКарты = 2 Тогда
		// Поиск по ФИО.
		ТекстЗапроса = "ВЫБРАТЬ
		|	ФизическиеЛица.Ссылка КАК Ссылка
		|ПОМЕСТИТЬ Владельцы
		|ИЗ
		|	Справочник.ФизическиеЛица КАК ФизическиеЛица
		|ГДЕ
		|	ФизическиеЛица.Наименование ПОДОБНО &Наименование
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	Контрагенты.Ссылка
		|ИЗ
		|	Справочник.Контрагенты КАК Контрагенты
		|ГДЕ
		|	Контрагенты.Наименование ПОДОБНО &Наименование
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	Карты.Ссылка КАК Ссылка,
		|	Владельцы.Ссылка КАК ВладелецКарты,
		|	ЕСТЬNULL(КонтактнаяИнформацияВладельца.НомерТелефона, """") КАК НомерТелефона,
		|	ЕСТЬNULL(КонтактнаяИнформацияВладельца.АдресЭП, """") КАК АдресЭП
		|ИЗ
		|	Справочник.ИнформационныеКарты КАК Карты
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Владельцы КАК Владельцы
		|		ПО (Владельцы.Ссылка = Карты.ВладелецКарты)
		|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ФизическиеЛица.КонтактнаяИнформация КАК КонтактнаяИнформацияВладельца
		|		ПО (Владельцы.Ссылка = КонтактнаяИнформацияВладельца.Ссылка)
		|			И (КонтактнаяИнформацияВладельца.Тип В (&ТипыИнформации))
		|ГДЕ
		|	Карты.ТипКарты = &ТипКарты";
		
	ИначеЕсли РежимПоискаКарты = 3 Тогда
		// Поиск по E-mail.
		ТекстЗапроса = 
		"ВЫБРАТЬ
		|	КонтактнаяИнформация.Ссылка КАК Ссылка,
		|	КонтактнаяИнформация.НомерТелефона КАК НомерТелефона,
		|	КонтактнаяИнформация.АдресЭП КАК АдресЭП
		|ПОМЕСТИТЬ Владельцы
		|ИЗ
		|	Справочник.ФизическиеЛица.КонтактнаяИнформация КАК КонтактнаяИнформация
		|ГДЕ
		|	КонтактнаяИнформация.АдресЭП ПОДОБНО &АдресЭП
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	КонтактнаяИнформация.Ссылка,
		|	КонтактнаяИнформация.НомерТелефона,
		|	КонтактнаяИнформация.АдресЭП
		|ИЗ
		|	Справочник.Контрагенты.КонтактнаяИнформация КАК КонтактнаяИнформация
		|ГДЕ
		|	КонтактнаяИнформация.АдресЭП ПОДОБНО &АдресЭП
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	Контрагенты.Ссылка,
		|	КонтактнаяИнформацияФЛ.НомерТелефона,
		|	КонтактнаяИнформацияФЛ.АдресЭП
		|ИЗ
		|	Справочник.Контрагенты КАК Контрагенты
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.ФизическиеЛица.КонтактнаяИнформация КАК КонтактнаяИнформацияФЛ
		|		ПО Контрагенты.ФизЛицо = КонтактнаяИнформацияФЛ.Ссылка
		|			И (КонтактнаяИнформацияФЛ.АдресЭП ПОДОБНО &АдресЭП)
		|ГДЕ
		|	Контрагенты.ЮрФизЛицо = ЗНАЧЕНИЕ(Перечисление.ЮрФизЛицо.ФизЛицо)
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	КонтактнаяИнформация.Ссылка КАК Ссылка,
		|	КонтактнаяИнформация.Ссылка.ВладелецКарты КАК ВладелецКарты,
		|	КонтактнаяИнформация.НомерТелефона КАК НомерТелефона,
		|	КонтактнаяИнформация.АдресЭП КАК АдресЭП
		|ПОМЕСТИТЬ КартыИзКонтактнойИнформации
		|ИЗ
		|	Справочник.ИнформационныеКарты.КонтактнаяИнформация КАК КонтактнаяИнформация
		|ГДЕ
		|	КонтактнаяИнформация.АдресЭП ПОДОБНО &АдресЭП
		|	И КонтактнаяИнформация.Ссылка.ТипКарты = &ТипКарты
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	Карты.Ссылка КАК Ссылка,
		|	Владельцы.Ссылка КАК ВладелецКарты,
		|	Владельцы.НомерТелефона КАК НомерТелефона,
		|	Владельцы.АдресЭП КАК АдресЭП
		|ПОМЕСТИТЬ ТаблицаКарт
		|ИЗ
		|	Справочник.ИнформационныеКарты КАК Карты
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Владельцы КАК Владельцы
		|		ПО (Владельцы.Ссылка = Карты.ВладелецКарты)
		|ГДЕ
		|	Карты.ТипКарты = &ТипКарты
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	КартыИзКонтактнойИнформации.Ссылка,
		|	КартыИзКонтактнойИнформации.ВладелецКарты,
		|	КартыИзКонтактнойИнформации.НомерТелефона,
		|	КартыИзКонтактнойИнформации.АдресЭП
		|ИЗ
		|	КартыИзКонтактнойИнформации КАК КартыИзКонтактнойИнформации
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	ТаблицаКарт.Ссылка КАК Ссылка,
		|	ТаблицаКарт.ВладелецКарты КАК ВладелецКарты,
		|	ТаблицаКарт.НомерТелефона КАК НомерТелефона,
		|	ТаблицаКарт.АдресЭП КАК АдресЭП
		|ИЗ
		|	ТаблицаКарт КАК ТаблицаКарт";
	//{ds-15.10.2021
	ИначеЕсли РежимПоискаКарты = 5 Или РежимПоискаКарты = 6 Тогда
		// Поиск Клиента UDS и GMB по ФИО.
		ТекстЗапроса = 
		"ВЫБРАТЬ
		|	ФизическиеЛица.Ссылка КАК Ссылка
		|ПОМЕСТИТЬ Владельцы
		|ИЗ
		|	Справочник.ФизическиеЛица КАК ФизическиеЛица
		|ГДЕ
		|	ФизическиеЛица.ds_ВнешнийИдентификатор = &Наименование
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	Карты.Ссылка КАК Ссылка,
		|	Владельцы.Ссылка КАК ВладелецКарты,
		|	ЕСТЬNULL(КонтактнаяИнформацияВладельца.НомерТелефона, """") КАК НомерТелефона,
		|	ЕСТЬNULL(КонтактнаяИнформацияВладельца.АдресЭП, """") КАК АдресЭП
		|ИЗ
		|	Справочник.ИнформационныеКарты КАК Карты
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Владельцы КАК Владельцы
		|		ПО (Владельцы.Ссылка = Карты.ВладелецКарты)
		|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ФизическиеЛица.КонтактнаяИнформация КАК КонтактнаяИнформацияВладельца
		|		ПО (Владельцы.Ссылка = КонтактнаяИнформацияВладельца.Ссылка)
		|		И (КонтактнаяИнформацияВладельца.Тип В (&ТипыИнформации))
		|ГДЕ
		|	Карты.ТипКарты = &ТипКарты";
	//}
	Иначе
		// Поиск по коду карты или штрихкоду
		ТекстЗапроса = "
		|ВЫБРАТЬ
		|	Карты.Ссылка КАК Ссылка,
		|	Карты.Наименование КАК Наименование
		|ИЗ
		|	Справочник.ИнформационныеКарты КАК Карты
		|ГДЕ
		|	Карты.ТипКарты = &ТипКарты
		|	И Карты.КодКарты = &ВводимоеЧисло
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	Штрихкоды.Владелец КАК Ссылка,
		|	Штрихкоды.Владелец.Наименование КАК Наименование
		|ИЗ
		|	РегистрСведений.Штрихкоды КАК Штрихкоды
		|ГДЕ
		|	Штрихкоды.Владелец.ТипКарты = &ТипКарты
		|	И Штрихкоды.Штрихкод = &ВводимоеЧисло
		|
		|УПОРЯДОЧИТЬ ПО
		|	Наименование
		|";
	КонецЕсли;
	
	Возврат ТекстЗапроса;
	
КонецФункции

// Программно создает новую дисконтную карту.
//
// Параметры:
//  СтруктураПараметров - Структура - данные для заполнения реквизитов создаваемой карты.
//
// Возвращаемое значение:
//  СправочникСсылка.ИнформационныеКарты - ссылка на созданную карту
//                    в случае возникновения исключительной ситуации возвращается пустая ссылка.
//
Функция НоваяДисконтнаяКарта(СтруктураПараметров) Экспорт
	
	ВыполненоУспешно = Ложь;
	Штрихкод = "";
	
	НачатьТранзакцию();
	Попытка
		
		ИнформационнаяКарта = Справочники.ИнформационныеКарты.СоздатьЭлемент();
		ИнформационнаяКарта.Наименование = СтруктураПараметров.КодКарты;
		
		ИнформационнаяКарта.ВидКарты = СтруктураПараметров.ВидКарты;
		ИнформационнаяКарта.ДатаОткрытия = ТекущаяДатаСеанса();
		ИнформационнаяКарта.Родитель = СтруктураПараметров.ГруппаКарты;
		ИнформационнаяКарта.ТипКарты = Перечисления.ТипыИнформационныхКарт.Дисконтная;
		
		Если СтруктураПараметров.ВидКарты <> Перечисления.ВидыИнформационныхКарт.Штриховая Тогда
			ИнформационнаяКарта.КодКарты = СтруктураПараметров.КодКарты;
		КонецЕсли;
		
		ИнформационнаяКарта.ВидДисконтнойКарты = СтруктураПараметров.ВидДисконтнойКарты;
		ИнформационнаяКарта.БонуснаяПрограммаЛояльности = СтруктураПараметров.БонуснаяПрограммаЛояльности;
		
		Если СтруктураПараметров.Свойство("ПроводитьОпросВладельцаПриРегистрации")
			И СтруктураПараметров.ПроводитьОпросВладельцаПриРегистрации Тогда
			ИнформационнаяКарта.ДатаСледующегоОпроса = ИнформационнаяКарта.ДатаОткрытия;
		КонецЕсли;
		
		Если СтруктураПараметров.Свойство("ГруппаВладельцаКарты") Тогда
			ИнформационнаяКарта.ГруппаВладельцаКартыПоШаблону = СтруктураПараметров.ГруппаВладельцаКарты;
		КонецЕсли;
		
		Если СтруктураПараметров.Свойство("ВладелецКарты") Тогда 
			ИнформационнаяКарта.ВладелецКарты = СтруктураПараметров.ВладелецКарты;
		Иначе 
			ИнформационнаяКарта.ВладелецКарты = Справочники.ФизическиеЛица.ПустаяСсылка();
		КонецЕсли;
				
		Если СтруктураПараметров.Свойство("НомерТелефона") Тогда
			УправлениеКонтактнойИнформацией.ДобавитьКонтактнуюИнформацию(
				ИнформационнаяКарта,
				СтруктураПараметров.НомерТелефона,
				Справочники.ВидыКонтактнойИнформации.ТелефонИнформационнойКарты);
		КонецЕсли;
		
		Если СтруктураПараметров.Свойство("АдресЭП") Тогда
			УправлениеКонтактнойИнформацией.ДобавитьКонтактнуюИнформацию(
				ИнформационнаяКарта,
				СтруктураПараметров.АдресЭП,
				Справочники.ВидыКонтактнойИнформации.EmailИнформационнойКарты);
		КонецЕсли;
		
		ИнформационнаяКарта.Записать();
		
		Если СтруктураПараметров.ВидКарты <> Перечисления.ВидыИнформационныхКарт.Магнитная Тогда
			
			МенеджерЗаписи = РегистрыСведений.Штрихкоды.СоздатьМенеджерЗаписи();
			МенеджерЗаписи.Штрихкод = СтруктураПараметров.КодКарты;
			МенеджерЗаписи.Владелец = ИнформационнаяКарта.Ссылка;
			Если ЗначениеЗаполнено(СтруктураПараметров.ТипШтрихкода) Тогда
				МенеджерЗаписи.ТипШтрихкода = СтруктураПараметров.ТипШтрихкода;
			Иначе
				МенеджерЗаписи.ТипШтрихкода = ПодключаемоеОборудованиеРТ.ТипШтрихкода(СтруктураПараметров.КодКарты);
			КонецЕсли;

			МенеджерЗаписи.Записать(Истина);
			Штрихкод = СтруктураПараметров.КодКарты;
			
		КонецЕсли;
		
		ВыполненоУспешно = Истина;
		ЗафиксироватьТранзакцию();
		
	Исключение
		
		ОтменитьТранзакцию();
		Инфо = ИнформацияОбОшибке();
		ТекстСообщенияОбОшибке = НСтр("ru = 'Ошибка при создании информационной карты: %1'");
		ТекстСообщенияОбОшибке = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
									ТекстСообщенияОбОшибке,
									КраткоеПредставлениеОшибки(Инфо));
		ОбщегоНазначения.СообщитьПользователю(ТекстСообщенияОбОшибке);
		ЗаписьЖурналаРегистрации(
			НСтр("ru = 'Маркетинг.Создание дисконтной карты'", ОбщегоНазначения.КодОсновногоЯзыка()),
			УровеньЖурналаРегистрации.Ошибка,
			,
			ПодробноеПредставлениеОшибки(Инфо));
		ВыполненоУспешно = Ложь;
		
	КонецПопытки;
	
	СсылкаРезультат = Справочники.ИнформационныеКарты.ПустаяСсылка();
	Если ВыполненоУспешно Тогда
		СсылкаРезультат = ИнформационнаяКарта.Ссылка;
	КонецЕсли;
	
	СтруктураКарты = Новый Структура;
	СтруктураКарты.Вставить("ДанныеПО", СтруктураПараметров.КодКарты);
	СтруктураКарты.Вставить("Штрихкод", Штрихкод);
	СтруктураКарты.Вставить("МагнитныйКод", СтруктураПараметров.КодКарты);
	СтруктураКарты.Вставить("Карта", СсылкаРезультат);
	СтруктураКарты.Вставить("ТипКарты", Перечисления.ТипыИнформационныхКарт.Дисконтная);
	СтруктураКарты.Вставить("ВладелецКарты", СсылкаРезультат.ВладелецКарты);
	СтруктураКарты.Вставить("ЭтоРегистрационнаяКарта", Ложь);
	
	Возврат СтруктураКарты;
	
КонецФункции

#КонецОбласти
