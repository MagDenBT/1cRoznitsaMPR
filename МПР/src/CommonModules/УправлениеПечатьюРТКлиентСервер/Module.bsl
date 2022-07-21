////////////////////////////////////////////////////////////////////////////////
// УправлениеПечатьюКлиент содержит процедуры и функции для работы 
// с печатью и обработки действий пользователя с печатью.
//  
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Возвращает массив строк по разделителю.
// 
// Параметры:
//  Форма - УправляемаяФорма - форма для получения идентификатора.
//
// Возвращаемое значение:
//  Массив - массив строк.
//
Функция ИдентификаторОбъекта(Форма) Экспорт
	
	Возврат СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(Форма.ИмяФормы, ".")[1];
	
КонецФункции

// Возвращает строку наименования задачи выполнения отчета.
// 
// Параметры:
//  Форма - УправляемаяФорма - форма для получения наименования задачи.
//
// Возвращаемое значение:
//  Строка - наименование задание отчета.
//
Функция НаименованиеЗаданияВыполненияОтчета(Форма) Экспорт
	
	НаименованиеЗадания = НСтр("ru = 'Выполнение отчета: %1'");
	ИмяОтчета = ИдентификаторОбъекта(Форма);
	НаименованиеЗадания = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НаименованиеЗадания, ИмяОтчета);
	
	Возврат НаименованиеЗадания;
	
КонецФункции

// Возвращает свойство доступного поля компоновщика настроек компоновки данных.
// 
// Параметры:
//  ЭлементСтруктура - КомпоновщикНастроекКомпоновкиДанных - структура настроек компоновщика данных.
//  Поле - ПолеКомпоновкиДанных - поле свойство которого необходимо получить.
//  Свойство - Строка - наименование свойства.
//
// Возвращаемое значение:
//  Произвольный - значение поля.
//
Функция СвойствоПоля(ЭлементСтруктура, Поле, Свойство = "Заголовок") Экспорт
	
	Если ТипЗнч(ЭлементСтруктура) = Тип("КомпоновщикНастроекКомпоновкиДанных") Тогда
		Коллекция = ЭлементСтруктура.Настройки.ДоступныеПоляВыбора;
	Иначе
		Коллекция = ЭлементСтруктура;
	КонецЕсли;
	
	ПолеСтрокой = Строка(Поле);
	ПозицияКвадратнойСкобки = Найти(ПолеСтрокой, "[");
	Окончание = "";
	Заголовок = "";
	Если ПозицияКвадратнойСкобки > 0 Тогда
		Окончание = Сред(ПолеСтрокой, ПозицияКвадратнойСкобки);
		ПолеСтрокой = Лев(ПолеСтрокой, ПозицияКвадратнойСкобки - 2);
	КонецЕсли;
	
	МассивСтрок = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(ПолеСтрокой, ".");
	
	Если Не ПустаяСтрока(Окончание) Тогда
		МассивСтрок.Добавить(Окончание);
	КонецЕсли;
	
	ДоступныеПоля = Коллекция.Элементы;
	ПолеПоиска = "";
	Для Индекс = 0 По МассивСтрок.Количество() - 1 Цикл
		ПолеПоиска = ПолеПоиска + ?(Индекс = 0, "", ".") + МассивСтрок[Индекс];
		ДоступноеПоле = ДоступныеПоля.Найти(ПолеПоиска);
		Если ДоступноеПоле <> Неопределено Тогда
			ДоступныеПоля = ДоступноеПоле.Элементы;
		КонецЕсли;
	КонецЦикла;
	
	Если ДоступноеПоле <> Неопределено Тогда
		Если Свойство = "ДоступноеПоле" Тогда
			Результат = ДоступноеПоле;
		Иначе
			Результат = ДоступноеПоле[Свойство]; 
		КонецЕсли;
	Иначе
		Результат = Неопределено;
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

// Получает параметр вывода компоновщика настроек или настройки СКД
//
// Параметры:
//  Настройка - КомпоновщикНастроекГруппировка - компоновщик настроек или настройка/группировка СКД.
//  ИмяПараметра - Строка - имя параметра СКД.
//
// ВозвращаемоеЗначение:
//  Произвольный - значение параметра.
//
Функция ПараметрВывода(Настройка, ИмяПараметра) Экспорт
	
	МассивПараметров   = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(ИмяПараметра, ".");
	УровеньВложенности = МассивПараметров.Количество();
	
	Если УровеньВложенности > 1 Тогда
		ИмяПараметра = МассивПараметров[0];		
	КонецЕсли;
	
	Если ТипЗнч(Настройка) = Тип("КомпоновщикНастроекКомпоновкиДанных") Тогда
		ЗначениеПараметра = Настройка.Настройки.ПараметрыВывода.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных(ИмяПараметра));
	Иначе
		ЗначениеПараметра = Настройка.ПараметрыВывода.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных(ИмяПараметра));
	КонецЕсли;
	
	Если УровеньВложенности > 1 Тогда
		Для Индекс = 1 По УровеньВложенности - 1 Цикл
			ИмяПараметра = ИмяПараметра + "." + МассивПараметров[Индекс];
			ЗначениеПараметра = ЗначениеПараметра.ЗначенияВложенныхПараметров.Найти(ИмяПараметра); 
		КонецЦикла;
	КонецЕсли;
	
	Возврат ЗначениеПараметра;
	
КонецФункции

// Изменяет заголовок кнопки панель настроек.
//
// Параметры:
//  Кнопка - Кнопка - кнопка для изменения заголовка.
//  ВидимостьПанелиНастроек - Булево - признак видимости панели настроек.
//
Процедура ИзменитьЗаголовокКнопкиПанельНастроек(Кнопка, ВидимостьПанелиНастроек) Экспорт
	
	Если ВидимостьПанелиНастроек Тогда
		Кнопка.Заголовок = НСтр("ru = 'Скрыть настройки'");
	Иначе
		Кнопка.Заголовок = НСтр("ru = 'Показать настройки'");
	КонецЕсли;
		
КонецПроцедуры

// Устанавливает параметр вывода компоновщика настроек или настройки СКД
//
// Параметры:
//  Настройка - КомпоновщикНастроекГруппировка - компоновщик настроек или настройка/группировка СКД.
//  ИмяПараметра - Строка - имя параметра СКД.
//  Значение - Произвольный - значение параметра вывода СКД.
//  Использование - Булево - Признак использования параметра. По умолчанию всегда принимается равным истине.
//
// ВозвращаемоеЗначение:
//  Произвольный - значение параметра.
//
Функция УстановитьПараметрВывода(Настройка, ИмяПараметра, Значение, Использование = Истина) Экспорт
	
	ЗначениеПараметра = ПараметрВывода(Настройка, ИмяПараметра);
	
	Если ЗначениеПараметра <> Неопределено Тогда
		ЗначениеПараметра.Использование = Использование;
		ЗначениеПараметра.Значение      = Значение;
	КонецЕсли;
	
	Возврат ЗначениеПараметра;
	
КонецФункции

// Возвращает представление периода.
//
// Параметры:
//  НачалоПериода - Число - начало периода.
//  КонецПериода - Число - конец периода.
//  ТолькоДаты - Булево - признак использования только дат.
//
Функция ПолучитьПредставлениеПериода(НачалоПериода = '00010101', КонецПериода = '00010101', ТолькоДаты  = Ложь) Экспорт
	
	ТекстПериод = "";
	
	Если ЗначениеЗаполнено(КонецПериода) Тогда 
		Если КонецПериода >= НачалоПериода Тогда
			ТекстПериод = ?(ТолькоДаты, "", " за ") + ПредставлениеПериода(НачалоДня(НачалоПериода), КонецДня(КонецПериода), "ФП = Истина");
		Иначе
			ТекстПериод = "";
		КонецЕсли;
	ИначеЕсли ЗначениеЗаполнено(НачалоПериода) И Не ЗначениеЗаполнено(КонецПериода) Тогда
		ТекстПериод = ?(ТолькоДаты, "", " за ") + ПредставлениеПериода(НачалоДня(НачалоПериода), КонецДня(Дата(3999, 11, 11)), "ФП = Истина");
		ТекстПериод = СтрЗаменить(ТекстПериод, Сред(ТекстПериод, Найти(ТекстПериод, " - ")), " - ...");
	КонецЕсли;
	
	Возврат ТекстПериод;
	
КонецФункции

#КонецОбласти
