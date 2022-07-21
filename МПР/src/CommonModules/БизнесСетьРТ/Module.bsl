
////////////////////////////////////////////////////////////////////////////////
// Подсистема "Бизнес-сеть".
// ОбщийМодуль.БизнесСетьРТ.
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Создание контрагента в информационной базе по реквизитам.
//
// Параметры:
//   РеквизитыКонтрагента - Структура - реквизиты необходимые для создания контрагента.
//    * ИНН - Строка - ИНН контрагента.
//    * КПП - Строка - КПП контрагента.
//    * Наименование - Строка - наименование контрагента.
//   Контрагент - СправочникСсылка - ссылка на созданного контрагента.
//   Отказ - Булево - признак ошибки.
//
Процедура СоздатьКонтрагентаПоРеквизитам(Знач РеквизитыКонтрагента, Контрагент, Отказ = Ложь) Экспорт
	
	Попытка
		
		КонтрагентОбъект = Справочники.Контрагенты.СоздатьЭлемент(); 
		ЗаполнитьЗначенияСвойств(КонтрагентОбъект, РеквизитыКонтрагента);
		
		КонтрагентОбъект.ЮрФизЛицо = ?(СтрДлина(РеквизитыКонтрагента.ИНН) = 12, Перечисления.ЮрФизЛицо.ИндивидуальныйПредприниматель, Перечисления.ЮрФизЛицо.ЮрЛицо);
		КонтрагентОбъект.НаименованиеПолное = КонтрагентОбъект.Наименование;
		КонтрагентОбъект.УчастникЭДО 		= Истина;
		КонтрагентОбъект.Поставщик 			= Истина;
		
		КонтрагентОбъект.Записать();
		
	Исключение
		
		Отказ = Истина;
		
		Подсистема = НСтр("ru = 'Бизнес-сеть'", ОбщегоНазначения.КодОсновногоЯзыка());
		ИмяСобытия = СтрЗаменить(НСтр("ru = 'Электронное взаимодействие.%1'", ОбщегоНазначения.КодОсновногоЯзыка()),
			"%1", Подсистема);
		ЗаписьЖурналаРегистрации(ИмяСобытия,
			УровеньЖурналаРегистрации.Ошибка,,, ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()),);
		
		Возврат;
		
	КонецПопытки;
	
	Контрагент = КонтрагентОбъект.Ссылка;
	
КонецПроцедуры

// Возвращает контакты пользователя для регистрации в сервисе.
//
// Параметры:
//   КонтактноеЛицо - СправочникСсылка - пользователь программы, контактное лицо.
//   Результат - Структура - информация о пользователе:
//     * ФИО - Строка - ФИО пользователя.
//     * Телефон - Строка - номер телефона.
//     * ЭлектроннаяПочта - Строка - адрес электронной почты пользователя.
//
Процедура ПолучитьКонтактнуюИнформациюПользователя(Знач КонтактноеЛицо, Результат) Экспорт
	
	Если ТипЗнч(КонтактноеЛицо) <> Тип("Строка") Тогда
		
		КонтактнаяИнформация = УправлениеКонтактнойИнформацией.КонтактнаяИнформацияОбъекта(КонтактноеЛицо,,,Ложь);
		
		Для каждого СтрокаКонтактов Из КонтактнаяИнформация Цикл
			
			Если СтрокаКонтактов.Тип = Перечисления.ТипыКонтактнойИнформации.АдресЭлектроннойПочты Тогда
				
				Результат.ЭлектроннаяПочта = СтрокаКонтактов.Представление;
				
			КонецЕсли;
			
			Если СтрокаКонтактов.Тип = Перечисления.ТипыКонтактнойИнформации.Телефон Тогда
				
				Результат.Телефон = СтрокаКонтактов.Представление;
				
			КонецЕсли;
			
		КонецЦикла;
		
	КонецЕсли;
	
	Если ТипЗнч(КонтактноеЛицо) = Тип("СправочникСсылка.ФизическиеЛица") Тогда
		
		ФизЛицоФИО 		= РегистрыСведений.ФИОФизЛиц.ПолучитьПоследнее(, Новый Структура("ФизЛицо", КонтактноеЛицо)); 
		Результат.ФИО 	= ФизЛицоФИО.Фамилия + " " + ФизЛицоФИО.Имя + " " + ФизЛицоФИО.Отчество;
		
	Иначе
		
		Результат.ФИО = Строка(КонтактноеЛицо);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
