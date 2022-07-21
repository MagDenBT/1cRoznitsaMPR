#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныйПрограммныйИнтерфейс

#Область ТекущиеДела

// См. ТекущиеДелаПереопределяемый.ПриОпределенииОбработчиковТекущихДел.
Процедура ПриЗаполненииСпискаТекущихДел(ТекущиеДела) Экспорт
	
	// Определим доступны ли текущему пользователю состояния выгрузки
	Доступность = ПравоДоступа("Чтение", Метаданные.РегистрыСведений.СостоянияВыгрузкиНоменклатуры);
	
	Если НЕ Доступность Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыДел = Новый Структура("ВыгрузкаНовойНоменклатуры, ПодготовкаНоменклатурыКВыгрузке, ОбработкаОшибокВыгрузки", 0, 0, 0);
	ЛимитЗаписей = РаботаСНоменклатуройСлужебныйКлиентСервер.РазмерПорции();
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	КОЛИЧЕСТВО(НоменклатураДляТекущихДел.Номенклатура) КАК КоличествоДанных,
	|	НоменклатураДляТекущихДел.ИндексВыборки КАК ИндексВыборки
	|ИЗ
	|	(ВЫБРАТЬ ПЕРВЫЕ 1000
	|		СостоянияВыгрузкиНоменклатуры.Номенклатура КАК Номенклатура,
	|		""ВыгрузкаНовойНоменклатуры"" КАК ИндексВыборки
	|	ИЗ
	|		РегистрСведений.СостоянияВыгрузкиНоменклатуры КАК СостоянияВыгрузкиНоменклатуры
	|	ГДЕ
	|		СостоянияВыгрузкиНоменклатуры.Состояние = ЗНАЧЕНИЕ(Перечисление.СостоянияВыгрузкиНоменклатуры.ОжидаетПодтверждения)
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ ПЕРВЫЕ 1000
	|		СостоянияВыгрузкиНоменклатуры.Номенклатура,
	|		""ВыгрузкаНовойНоменклатуры""
	|	ИЗ
	|		РегистрСведений.СостоянияВыгрузкиНоменклатуры КАК СостоянияВыгрузкиНоменклатуры
	|	ГДЕ
	|		СостоянияВыгрузкиНоменклатуры.Состояние = ЗНАЧЕНИЕ(Перечисление.СостоянияВыгрузкиНоменклатуры.ОжидаетИсправления)
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ ПЕРВЫЕ 1000
	|		СостоянияВыгрузкиНоменклатуры.Номенклатура,
	|		""ПодготовкаНоменклатурыКВыгрузке""
	|	ИЗ
	|		РегистрСведений.СостоянияВыгрузкиНоменклатуры КАК СостоянияВыгрузкиНоменклатуры
	|	ГДЕ
	|		СостоянияВыгрузкиНоменклатуры.Состояние = ЗНАЧЕНИЕ(Перечисление.СостоянияВыгрузкиНоменклатуры.СодержитПроблемы)
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ ПЕРВЫЕ 1000
	|		СостоянияВыгрузкиНоменклатуры.Номенклатура,
	|		""ОбработкаОшибокВыгрузки""
	|	ИЗ
	|		РегистрСведений.СостоянияВыгрузкиНоменклатуры КАК СостоянияВыгрузкиНоменклатуры
	|	ГДЕ
	|		СостоянияВыгрузкиНоменклатуры.Состояние = ЗНАЧЕНИЕ(Перечисление.СостоянияВыгрузкиНоменклатуры.Отклонена)) КАК НоменклатураДляТекущихДел
	|
	|СГРУППИРОВАТЬ ПО
	|	НоменклатураДляТекущихДел.ИндексВыборки";
	
	Запрос.Текст = СтрЗаменить(Запрос.Текст, "1000", Формат(ЛимитЗаписей, "ЧГ=0"));
	Результат    = Запрос.Выполнить();
	Выборка      = Результат.Выбрать();
	
	ЕстьДела = Ложь;
	Пока Выборка.Следующий() Цикл
		Если ПараметрыДел.Свойство(Выборка.ИндексВыборки) Тогда
			ПараметрыДел.Вставить(Выборка.ИндексВыборки, Выборка.КоличествоДанных);
			ЕстьДела = Истина;
		КонецЕсли;
	КонецЦикла;
	
	ДелоРодитель = ТекущиеДела.Добавить();
	ДелоРодитель.Идентификатор  = "ВыгрузкаНоменклатуры";
	ДелоРодитель.Представление  = НСтр("ru = 'Выгрузка номенклатуры '");
	ДелоРодитель.Владелец       = Метаданные.Подсистемы.Администрирование;
	ДелоРодитель.ЕстьДела       = ЕстьДела;
	
	Дело = ТекущиеДела.Добавить();
	Дело.Идентификатор  = "ВыгрузкаНовойНоменклатуры";
	Дело.ЕстьДела       = ПараметрыДел[Дело.Идентификатор] > 0;
	Дело.Представление  = НСтр("ru = 'Выгрузить новую номенклатуру'");
	Дело.Количество     = ПараметрыДел[Дело.Идентификатор];
	Дело.Важное         = Ложь;
	Дело.Форма          = "Обработка.РаботаСНоменклатурой.Форма.НоваяНоменклатураКВыгрузке";
	Дело.Владелец       = "ВыгрузкаНоменклатуры";
	
	Дело = ТекущиеДела.Добавить();
	Дело.Идентификатор  = "ПодготовкаНоменклатурыКВыгрузке";
	Дело.ЕстьДела       = ПараметрыДел[Дело.Идентификатор] > 0;
	Дело.Представление  = НСтр("ru = 'Подготовить номенклатуру к выгрузке'");
	Дело.Количество     = ПараметрыДел[Дело.Идентификатор];
	Дело.Важное         = Истина;
	Дело.Форма          = "Обработка.РаботаСНоменклатурой.Форма.СопоставлениеНоменклатурыСРубрикатором";
	Дело.ПараметрыФормы = Новый Структура("СценарийИспользования", "ВыгрузкаНоменклатуры");
	Дело.Владелец       = "ВыгрузкаНоменклатуры";
	
	Дело = ТекущиеДела.Добавить();
	Дело.Идентификатор  = "ОбработкаОшибокВыгрузки";
	Дело.ЕстьДела       = ПараметрыДел[Дело.Идентификатор] > 0;
	Дело.Представление  = НСтр("ru = 'Обработать ошибки выгрузки'");
	Дело.Количество     = ПараметрыДел[Дело.Идентификатор];
	Дело.Важное         = Истина;
	Дело.Форма          = "Обработка.РаботаСНоменклатурой.Форма.РезультатыВыгрузкиНоменклатуры";
	Дело.ПараметрыФормы = Новый Структура("ИмяКоманды", "КомандаСостояниеОтклонена");
	Дело.Владелец       = "ВыгрузкаНоменклатуры";

КонецПроцедуры

#КонецОбласти

// Получает массивы родителей и видов номенклатуры по настройкам отбора
//
// Параметры:
//  Настройки                - НастройкиКомпоновкиДанных - содержит пользовательские настройки отбора номенклатуры
//  ПолучитьРодителей        - Булево - признак необходимости формирования массива родителей
//  ПолучитьВидыНоменклатуры - Булево - признак необходимости формирования массива видов номенклатуры
//
// Возвращаемое значение:
//  СтруктураРезультата - Структура с ключами Родители и ВидыНоменклатуры
//
Функция РодителиИВидыНоменклатурыПоОтбору(Настройки, ПолучитьРодителей = Ложь, ПолучитьВидыНоменклатуры = Ложь) Экспорт
	
	СтруктураРезультата   = Новый Структура("Родители, ВидыНоменклатуры");
	Запрос                = РаботаСНоменклатуройСлужебный.ЗапросОтборНоменклатуры(Настройки, Ложь);
	ТекстЗапроса          = "";
	ТекстЗапросаИсточник  = Запрос.Текст;
	ИндексВидНоменклатуры = 0;
	СхемаЗапроса          = Новый СхемаЗапроса;
	СхемаЗапроса.УстановитьТекстЗапроса(ТекстЗапросаИсточник);
	СхемаЗапроса.ПакетЗапросов[0].Операторы[0].ВыбиратьРазличные = Истина;
	ТекстЗапросаИсточник  = СхемаЗапроса.ПолучитьТекстЗапроса();
	КоличествоПолей       = СхемаЗапроса.ПакетЗапросов[0].Колонки.Количество();
	
	Если ПолучитьРодителей Тогда
		ИндексВидНоменклатуры = 1;
		Для ОбратныйИндекс = 1 По КоличествоПолей Цикл
			ПроверяемоеПоле = СхемаЗапроса.ПакетЗапросов[0].Колонки[КоличествоПолей - ОбратныйИндекс];
			Если ПроверяемоеПоле.Псевдоним <> "Родитель" Тогда
				СхемаЗапроса.ПакетЗапросов[0].Колонки.Удалить(КоличествоПолей - ОбратныйИндекс);
			КонецЕсли;
		КонецЦикла;
		ТекстЗапроса = СхемаЗапроса.ПолучитьТекстЗапроса();
		СхемаЗапроса.УстановитьТекстЗапроса(ТекстЗапросаИсточник);
	КонецЕсли;
	
	Если ПолучитьВидыНоменклатуры Тогда
		Для ОбратныйИндекс = 1 По КоличествоПолей Цикл
			ПроверяемоеПоле = СхемаЗапроса.ПакетЗапросов[0].Колонки[КоличествоПолей - ОбратныйИндекс];
			Если ПроверяемоеПоле.Псевдоним <> "ВидНоменклатуры" Тогда
				СхемаЗапроса.ПакетЗапросов[0].Колонки.Удалить(КоличествоПолей - ОбратныйИндекс);
			КонецЕсли;
		КонецЦикла;
		ТекстЗапроса = ТекстЗапроса + ?(ПустаяСтрока(ТекстЗапроса), "", ";");
		ТекстЗапроса = ТекстЗапроса + СхемаЗапроса.ПолучитьТекстЗапроса();
	КонецЕсли;
	
	Запрос.Текст = ТекстЗапроса;
	Результаты   = Запрос.ВыполнитьПакет();
	
	Если ПолучитьРодителей Тогда
		СтруктураРезультата.Вставить("Родители", Результаты[0].Выгрузить().ВыгрузитьКолонку(0));
	КонецЕсли;
	Если ПолучитьВидыНоменклатуры Тогда
		СтруктураРезультата.Вставить("ВидыНоменклатуры", Результаты[ИндексВидНоменклатуры].Выгрузить().ВыгрузитьКолонку(0));
	КонецЕсли;
	
	Возврат СтруктураРезультата;
	
КонецФункции

Функция ВидыНоменклатурыКВыгрузке(Организация, СписокСостояний = Неопределено) Экспорт
	
	ВидыНоменклатуры = Новый СписокЗначений;
	
	Если СписокСостояний = Неопределено Тогда
		СписокСостояний = РаботаСНоменклатуройСлужебный.СостоянияНоменклатурыДоВыгрузки();
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Организация) Тогда
		СхемаЗапроса = Новый СхемаЗапроса;
		СхемаЗапроса.УстановитьТекстЗапроса(РаботаСНоменклатуройСлужебный.ТекстЗапросаВыгружаемаяНоменклатура());
		ОсновнойЗапрос  = СхемаЗапроса.ПакетЗапросов[0];
		КоличествоПолей = ОсновнойЗапрос.Колонки.Количество();
		Для ОбратныйИндексПоля = 1 По КоличествоПолей Цикл
			ПроверяемоеПоле = ОсновнойЗапрос.Колонки[КоличествоПолей - ОбратныйИндексПоля];
			Если ПроверяемоеПоле.Псевдоним <> "ВидНоменклатуры" Тогда
				ОсновнойЗапрос.Колонки.Удалить(КоличествоПолей - ОбратныйИндексПоля);
			КонецЕсли;
		КонецЦикла;
		ОсновнойЗапрос.Операторы[0].ВыбиратьРазличные = Истина;
		Запрос = Новый Запрос(ОсновнойЗапрос.ПолучитьТекстЗапроса());
		Запрос.УстановитьПараметр("Организация", Организация);
		Запрос.УстановитьПараметр("СписокСостояний", СписокСостояний);
		
		ВидыНоменклатуры.ЗагрузитьЗначения(Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("ВидНоменклатуры"));
	КонецЕсли;
	
	Возврат ВидыНоменклатуры;
	
КонецФункции

Функция ДобавитьКВыгрузкеНоменклатуруПоСписку(Организация, МассивНоменклатуры) Экспорт 
	
	Состояние              = Перечисления.СостоянияВыгрузкиНоменклатуры.Новая;
	ТипНоменклатура        = Метаданные.ОпределяемыеТипы.НоменклатураРаботаСНоменклатурой.Тип;
	ПорядокНоменклатура    = ТипНоменклатура.ПривестиЗначение();
	ИмяТаблицыНоменклатура = РаботаСНоменклатурой.ИмяТаблицыПоТипу(ТипНоменклатура);
	Исключено              = 0;
	Добавлено              = 0;
	
	ТекстЗапроса = "ВЫБРАТЬ
	               |	СправочникНоменклатура.Ссылка КАК Номенклатура
	               |ИЗ
	               |	Справочник.Номенклатура КАК СправочникНоменклатура";
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "Справочник.Номенклатура", ИмяТаблицыНоменклатура);
	Запрос       = Новый Запрос(ТекстЗапроса);
	ДобавитьВТекстЗапросаУсловиеНоваяНоменклатура(Запрос,, МассивНоменклатуры);
	
	ПустаяХарактеристика = РаботаСНоменклатурой.ПустаяСсылкаНаХарактеристику();
	Запрос.УстановитьПараметр("Параметр_ПустаяХарактеристика", ПустаяХарактеристика);
	Запрос.УстановитьПараметр("Параметр_Организация", Организация);
	
	НаборЗаписей = РегистрыСведений.СостоянияВыгрузкиНоменклатуры.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.Организация.Установить(Организация);
	Пока Истина Цикл
		Запрос.УстановитьПараметр("Параметр_Порядок_Номенклатура", ПорядокНоменклатура);
		Запрос.УстановитьПараметр("МассивНоменклатуры", МассивНоменклатуры);
		НовыеЗаписи         = Запрос.Выполнить().Выгрузить();
		ЗаписейНаДобавление = НовыеЗаписи.Количество();
		Если ЗаписейНаДобавление = 0 Тогда
			Прервать;
		КонецЕсли;
		
		НовыеЗаписи.Индексы.Добавить("Номенклатура");
		
		Для каждого ПараметрыЗаписи Из НовыеЗаписи Цикл
			Запись = НаборЗаписей.Добавить();
			Запись.Номенклатура  = ПараметрыЗаписи.Номенклатура;
			Запись.Организация   = Организация;
			Запись.Состояние     = Состояние;
			Запись.ДатаСостояния = ТекущаяДатаСеанса();
		КонецЦикла;
		
		ПорядокНоменклатура = НовыеЗаписи[ЗаписейНаДобавление - 1].Номенклатура;
		Добавлено           = Добавлено + ЗаписейНаДобавление;
		
		ВсегоНоменклатуры  = МассивНоменклатуры.Количество();
		Для ОбратныйИндекс = 1 По ВсегоНоменклатуры Цикл
			ОбработанныеСтроки = НовыеЗаписи.НайтиСтроки(Новый Структура("Номенклатура", МассивНоменклатуры[ВсегоНоменклатуры - ОбратныйИндекс]));
			Если ОбработанныеСтроки.Количество() Тогда
				МассивНоменклатуры.Удалить(ВсегоНоменклатуры - ОбратныйИндекс);
			КонецЕсли;
		КонецЦикла;
		
		НаборЗаписей.ОбменДанными.Загрузка = Истина;
		НаборЗаписей.Записать(Ложь);
		НаборЗаписей.Очистить();
	КонецЦикла;
	
	Если МассивНоменклатуры.Количество() Тогда
		// Остались строки для обработки, значит выбраны строки, присутствующие в регистре.
		// С этими данными нужно поступить следующим образом:
		// 1. Если состояние ВыгрузкаЗапрещена, то подсчитать количество таких записей и вернуть в сообщении пользователю
		// 2. Если состояние ОжидаетПодтверждения или ОжидаетИсправления, то есть номенклатура добавлена регламентным заданием
		//    и ожидает интерактивного подтверждения пользователем, то обновить состояние на Новая
		// 3. Не менять состояние во всех прочих случаях.
		Запрос.Текст = "ВЫБРАТЬ
		|	СостоянияВыгрузкиНоменклатуры.Номенклатура КАК Номенклатура,
		|	СостоянияВыгрузкиНоменклатуры.Состояние КАК Состояние
		|ИЗ
		|	РегистрСведений.СостоянияВыгрузкиНоменклатуры КАК СостоянияВыгрузкиНоменклатуры
		|ГДЕ
		|	СостоянияВыгрузкиНоменклатуры.Организация = &Параметр_Организация
		|	И СостоянияВыгрузкиНоменклатуры.Номенклатура В(&МассивНоменклатуры)
		|	И СостоянияВыгрузкиНоменклатуры.ХарактеристикаНоменклатуры = &Параметр_ПустаяХарактеристика
		|	И СостоянияВыгрузкиНоменклатуры.Состояние В(&СписокСостояний)";
		
		СписокСостояний = Новый СписокЗначений;
		СписокСостояний.Добавить(Перечисления.СостоянияВыгрузкиНоменклатуры.ВыгрузкаЗапрещена);
		СписокСостояний.Добавить(Перечисления.СостоянияВыгрузкиНоменклатуры.ОжидаетИсправления);
		СписокСостояний.Добавить(Перечисления.СостоянияВыгрузкиНоменклатуры.ОжидаетПодтверждения);
		Запрос.УстановитьПараметр("СписокСостояний", СписокСостояний);
		Запрос.УстановитьПараметр("МассивНоменклатуры", МассивНоменклатуры);
		
		НоменклатураВРегистре = Запрос.Выполнить().Выгрузить();
		Для каждого СостояниеНоменклатуры Из НоменклатураВРегистре Цикл
			Номенклатура = СостояниеНоменклатуры.Номенклатура;
			Если СостояниеНоменклатуры.Состояние = Перечисления.СостоянияВыгрузкиНоменклатуры.ВыгрузкаЗапрещена Тогда
				Исключено = Исключено + 1;
			Иначе 
				НаборЗаписей.Отбор.Номенклатура.Установить(Номенклатура);
				Запись = НаборЗаписей.Добавить();
				Запись.Номенклатура  = Номенклатура;
				Запись.Организация   = Организация;
				Запись.Состояние     = Состояние;
				НаборЗаписей.Записать();
				НаборЗаписей.Очистить();
				Добавлено = Добавлено + 1;
			КонецЕсли;
			
			МассивНоменклатуры.Удалить(МассивНоменклатуры.Найти(Номенклатура));
		КонецЦикла;
	КонецЕсли;
	
	ТекстЛога = Новый Массив;
	Если Добавлено > 0 Тогда
		ТекстЛога.Добавить(СтрШаблон(НСтр("ru = 'Добавлено к выгрузке %1'"), Добавлено));
	КонецЕсли;
	Если Исключено > 0 Тогда
		ТекстЛога.Добавить(СтрШаблон(НСтр("ru = 'Найдены в исключениях %1'"), Исключено));
	КонецЕсли;
	Если МассивНоменклатуры.Количество() Тогда
		ТекстЛога.Добавить(СтрШаблон(НСтр("ru = 'Не добавлены в выгрузку (уже выгружаются) %1'"), МассивНоменклатуры.Количество()));
	КонецЕсли;
	
	Возврат Новый Структура("Добавлено, ТекстЛога", Добавлено, ТекстЛога);

КонецФункции

Функция ДобавитьКВыгрузкеНоменклатуруПоОтбору(Организация, НастройкиОтбора, ЗапускИзРегламента = Ложь) Экспорт 
	
	Добавлено             = 0;
	ЛимитЗаписей          = РаботаСНоменклатуройСлужебныйКлиентСервер.РазмерПорции();
	ПорядокХарактеристика = РаботаСНоменклатурой.ПустаяСсылкаНаХарактеристику(); 
	ПорядокНоменклатура   = Метаданные.ОпределяемыеТипы.НоменклатураРаботаСНоменклатурой.Тип.ПривестиЗначение();
	СостояниеНовая        = Перечисления.СостоянияВыгрузкиНоменклатуры.Новая;
	ИспользоватьПодбор    = РаботаСНоменклатурой.ИспользоватьПодборНоменклатурыСХарактеристиками();
	НаборЗаписей          = РегистрыСведений.СостоянияВыгрузкиНоменклатуры.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.Организация.Установить(Организация);
	
	Если ЗапускИзРегламента Тогда
		СостояниеНовая = Перечисления.СостоянияВыгрузкиНоменклатуры.ОжидаетПроверки;
	КонецЕсли;
	
	Если ИспользоватьПодбор Тогда
		Запрос = ЗапросОтборНоменклатурыСХарактеристиками(НастройкиОтбора);
	Иначе
		Запрос = РаботаСНоменклатуройСлужебный.ЗапросОтборНоменклатуры(НастройкиОтбора, Ложь, Новый Структура("Номенклатура"));
	КонецЕсли;
	ДобавитьВТекстЗапросаУсловиеНоваяНоменклатура(Запрос, ЛимитЗаписей);
	Запрос.УстановитьПараметр("Параметр_Организация", Организация);
	
	БлокировкаДанных  = Новый БлокировкаДанных;
	ЭлементБлокировки = БлокировкаДанных.Добавить("РегистрСведений.СостоянияВыгрузкиНоменклатуры");
	ЭлементБлокировки.УстановитьЗначение("Организация", Организация);
	
	НачатьТранзакцию(РежимУправленияБлокировкойДанных.Управляемый);
	
	Попытка
		БлокировкаДанных.Заблокировать(); 
		
		Пока Истина Цикл
			Запрос.УстановитьПараметр("Параметр_Порядок_Номенклатура", ПорядокНоменклатура);
			Если ИспользоватьПодбор Тогда
				Запрос.УстановитьПараметр("Параметр_Порядок_Характеристика", ПорядокХарактеристика);
			КонецЕсли;
			
			НовыеЗаписи         = Запрос.Выполнить().Выгрузить();
			ЗаписейНаДобавление = НовыеЗаписи.Количество();
			Если ЗаписейНаДобавление = 0 Тогда
				Прервать;
			КонецЕсли;
			
			Для каждого ПараметрыЗаписи Из НовыеЗаписи Цикл
				Запись = НаборЗаписей.Добавить();
				Запись.Номенклатура  = ПараметрыЗаписи.Номенклатура;
				Запись.Организация   = Организация;
				Запись.Состояние     = СостояниеНовая;
				Запись.ДатаСостояния = ТекущаяДатаСеанса();
				Если ИспользоватьПодбор Тогда
					Запись.ХарактеристикаНоменклатуры = ПараметрыЗаписи.Характеристика;
				КонецЕсли;
			КонецЦикла;
			
			НаборЗаписей.ОбменДанными.Загрузка = Истина;
			НаборЗаписей.Записать(Ложь);
			НаборЗаписей.Очистить();
			
			ПорядокНоменклатура = НовыеЗаписи[ЗаписейНаДобавление - 1].Номенклатура;
			Добавлено           = Добавлено + ЗаписейНаДобавление;
			Если ИспользоватьПодбор Тогда
				ПорядокХарактеристика = НовыеЗаписи[ЗаписейНаДобавление - 1].Характеристика;
			КонецЕсли;
		КонецЦикла;
		
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
	КонецПопытки;
	
	ТекстЛога = Новый Массив;
	Если Добавлено > 0 Тогда
		ТекстЛога.Добавить(СтрШаблон(НСтр("ru = 'Добавлено к выгрузке %1'"), Добавлено));
	Иначе
		 ТекстЛога.Добавить(НСтр("ru = 'Нет новой номенклатуры, удовлетворяющей отбору'"));
	КонецЕсли;
	
	Возврат Новый Структура("Добавлено, ТекстЛога", Добавлено, ТекстЛога);

КонецФункции

Функция ОбновитьСостоянияНовойНоменклатуры(Организация, ДатаОткрытияФормы, Добавить) Экспорт 
	
	ПорядокХарактеристика = РаботаСНоменклатурой.ПустаяСсылкаНаХарактеристику();
	ПорядокНоменклатура  = Метаданные.ОпределяемыеТипы.НоменклатураРаботаСНоменклатурой.Тип.ПривестиЗначение();
	ВсегоЗаписей         = 0;
	ЛимитСтрока          = Формат(РаботаСНоменклатуройСлужебныйКлиентСервер.РазмерПорции(), "ЧГ=");
	Запрос               = Новый Запрос;
	Запрос.Текст         = "ВЫБРАТЬ ПЕРВЫЕ 1000
	|	СостоянияВыгрузкиНоменклатуры.Номенклатура КАК Номенклатура,
	|	СостоянияВыгрузкиНоменклатуры.ХарактеристикаНоменклатуры КАК ХарактеристикаНоменклатуры
	|ИЗ
	|	РегистрСведений.СостоянияВыгрузкиНоменклатуры КАК СостоянияВыгрузкиНоменклатуры
	|ГДЕ
	|	СостоянияВыгрузкиНоменклатуры.Организация = &Организация
	|	И СостоянияВыгрузкиНоменклатуры.Состояние = &СостояниеИсходное
	|	И (СостоянияВыгрузкиНоменклатуры.Номенклатура > &ПорядокНоменклатура
	|			ИЛИ СостоянияВыгрузкиНоменклатуры.Номенклатура = &ПорядокНоменклатура
	|				И СостоянияВыгрузкиНоменклатуры.ХарактеристикаНоменклатуры = &ПорядокХарактеристика)
	|	И (&НеПроверятьДату
	|			ИЛИ СостоянияВыгрузкиНоменклатуры.ДатаСостояния > &ДатаОткрытияФормы)
	|
	|УПОРЯДОЧИТЬ ПО
	|	Номенклатура";
	
	Запрос.Текст = СтрЗаменить(Запрос.Текст, "1000", ЛимитСтрока);

	Если Добавить = Истина Тогда
		СостояниеИсходное = Перечисления.СостоянияВыгрузкиНоменклатуры.ОжидаетПодтверждения;
		Состояние         = Перечисления.СостоянияВыгрузкиНоменклатуры.ОжидаетВыгрузки;
	Иначе
		СостояниеИсходное = Перечисления.СостоянияВыгрузкиНоменклатуры.ОжидаетВыгрузки;
		Состояние         = Перечисления.СостоянияВыгрузкиНоменклатуры.ОжидаетПодтверждения;
	КонецЕсли;
	
	Запрос.УстановитьПараметр("Организация",       Организация);
	Запрос.УстановитьПараметр("СостояниеИсходное", СостояниеИсходное);
	Запрос.УстановитьПараметр("ДатаОткрытияФормы", ДатаОткрытияФормы);
	Запрос.УстановитьПараметр("НеПроверятьДату",   Добавить = Истина);
	
	Пока Истина Цикл
		Запрос.УстановитьПараметр("ПорядокНоменклатура", ПорядокНоменклатура);
		Запрос.УстановитьПараметр("ПорядокХарактеристика", ПорядокХарактеристика);
		ТаблицаНоменклатуры = Запрос.Выполнить().Выгрузить();
		ТекущееКоличество   = ТаблицаНоменклатуры.Количество();
		Если ТекущееКоличество = 0 Тогда
			Прервать;
		КонецЕсли;
		ЗаписатьДанныеВРегистрНоменклатураКВыгрузке(Организация, ТаблицаНоменклатуры, Состояние);
		
		ВсегоЗаписей        = ВсегоЗаписей + ТекущееКоличество;
		ПорядокНоменклатура = ТаблицаНоменклатуры[ТекущееКоличество - 1].Номенклатура;
		ПорядокХарактеристика = ТаблицаНоменклатуры[ТекущееКоличество - 1].ХарактеристикаНоменклатуры;
	КонецЦикла;
	
	Возврат ВсегоЗаписей;

КонецФункции

Функция НоваяНоменклатураПоОрганизациям() Экспорт 
	
	ПустаяХарактеристика = РаботаСНоменклатурой.ПустаяСсылкаНаХарактеристику();
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	|	ПодЗапрос.Организация КАК Организация,
	|	КОЛИЧЕСТВО(ПодЗапрос.Номенклатура) КАК Количество
	|ИЗ
	|	(ВЫБРАТЬ
	|		СостоянияВыгрузкиНоменклатуры.Организация КАК Организация,
	|		СостоянияВыгрузкиНоменклатуры.Номенклатура КАК Номенклатура
	|	ИЗ
	|		РегистрСведений.СостоянияВыгрузкиНоменклатуры КАК СостоянияВыгрузкиНоменклатуры
	|	ГДЕ
	|		СостоянияВыгрузкиНоменклатуры.ХарактеристикаНоменклатуры = &ПустаяХарактеристика
	|		И СостоянияВыгрузкиНоменклатуры.Состояние = ЗНАЧЕНИЕ(Перечисление.СостоянияВыгрузкиНоменклатуры.ОжидаетПодтверждения)
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		СостоянияВыгрузкиНоменклатуры.Организация,
	|		СостоянияВыгрузкиНоменклатуры.Номенклатура
	|	ИЗ
	|		РегистрСведений.СостоянияВыгрузкиНоменклатуры КАК СостоянияВыгрузкиНоменклатуры
	|	ГДЕ
	|		СостоянияВыгрузкиНоменклатуры.ХарактеристикаНоменклатуры = &ПустаяХарактеристика
	|		И СостоянияВыгрузкиНоменклатуры.Состояние = ЗНАЧЕНИЕ(Перечисление.СостоянияВыгрузкиНоменклатуры.ОжидаетИсправления)) КАК ПодЗапрос
	|
	|СГРУППИРОВАТЬ ПО
	|	ПодЗапрос.Организация";
	
	Запрос.УстановитьПараметр("ПустаяХарактеристика", ПустаяХарактеристика);
	
	Результат = Новый Соответствие;
	Для каждого СтрокаРезультата Из Запрос.Выполнить().Выгрузить() Цикл
		Результат.Вставить(СтрокаРезультата.Организация, СтрокаРезультата.Количество);
	КонецЦикла;
	
	Возврат Результат;

КонецФункции

Процедура ЗаписатьДанныеВРегистрНоменклатураКВыгрузке(Знач Организация, Знач МассивКлючей, Знач Состояние) Экспорт 
	
	Если Не ЗначениеЗаполнено(Организация) Тогда
		Возврат;
	КонецЕсли;
	
	Для каждого ТекущийКлюч Из МассивКлючей Цикл
		
		ДанныеЗаписи = Новый Структура("Номенклатура,ХарактеристикаНоменклатуры");
		ЗаполнитьЗначенияСвойств(ДанныеЗаписи, ТекущийКлюч);
		Если Не ЗначениеЗаполнено(ДанныеЗаписи.Номенклатура) Тогда
			Продолжить;
		КонецЕсли;
		ДанныеЗаписи.Вставить("Организация", Организация);
		
		НаборЗаписей = РегистрыСведений.СостоянияВыгрузкиНоменклатуры.СоздатьНаборЗаписей();
		Для Каждого ЭлементКлюча Из ДанныеЗаписи Цикл
			НаборЗаписей.Отбор[ЭлементКлюча.Ключ].Установить(ЭлементКлюча.Значение);
		КонецЦикла;
		ДанныеЗаписи.Вставить("Состояние", Состояние);
		ЗаполнитьЗначенияСвойств(НаборЗаписей.Добавить(), ДанныеЗаписи);
		НаборЗаписей.Записать();
		
	КонецЦикла;
	
КонецПроцедуры

Процедура СоздатьКомандыСостояния(Форма, ИмяГруппы, ВидКнопки = Неопределено) Экспорт
	
	ПрефиксКоманды               = "КомандаСостояние";
	Форма.ПрефиксКомандСостояние = ПрефиксКоманды;
	Форма.СтатистикаРезультатов  = Новый Структура;
	ЗаполнитьСписокСостояний     = ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(Форма, "СписокСостояний");
	
	КартинкиСостояняий = Новый Структура;
	КартинкиСостояняий.Вставить("Отклонена", БиблиотекаКартинок.КрасныйШарБЭД);
	КартинкиСостояняий.Вставить("Принята", БиблиотекаКартинок.ЗеленыйШарБЭД);
	КартинкиСостояняий.Вставить("ПроверяетсяМодератором", БиблиотекаКартинок.ЖелтыйШарБЭД);
	КартинкиСостояняий.Вставить("ОжидаетВыгрузки", БиблиотекаКартинок.СерыйШарБЭД);
	
	Для каждого ПараметрыСостояния Из КартинкиСостояняий Цикл
		СостояниеВыгрузки             = Перечисления.СостоянияВыгрузкиНоменклатуры[ПараметрыСостояния.Ключ];
		ИмяКоманды                    = ПрефиксКоманды + ПараметрыСостояния.Ключ;
		КомандаСостояния              = Форма.Команды.Добавить(ИмяКоманды);
		КомандаСостояния.Действие     = "Подключаемый_ДействиеКомандыСостояние";
		КомандаСостояния.Отображение  = ОтображениеКнопки.КартинкаИТекст;
		КомандаСостояния.Заголовок    = Строка(СостояниеВыгрузки);
		КомандаСостояния.Картинка     = ПараметрыСостояния.Значение;
		КнопкаСостояния               = Форма.Элементы.Добавить(ИмяКоманды, Тип("КнопкаФормы"), Форма.Элементы[ИмяГруппы]);
		КнопкаСостояния.ИмяКоманды    = ИмяКоманды;
		КнопкаСостояния.Заголовок     = Строка(СостояниеВыгрузки);
		Если ВидКнопки <> Неопределено Тогда
			КнопкаСостояния.Вид    = ВидКнопки;
		КонецЕсли;
		
		Форма.СтатистикаРезультатов.Вставить(ПараметрыСостояния.Ключ, 0);
		
		Если ЗаполнитьСписокСостояний Тогда
			Форма.СписокСостояний.Добавить(СостояниеВыгрузки, ИмяКоманды);
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

Процедура СброситьСостоянияВыгрузкиНоменклатуры(Организация, Состояние) Экспорт
	
	Набор = РегистрыСведений.СостоянияВыгрузкиНоменклатуры.СоздатьНаборЗаписей();
	Набор.Отбор.Организация.Установить(Организация);
	Набор.Записать();
	
КонецПроцедуры

Функция СостояниеВыгрузкиВНациональныйКаталог(Знач Организация) Экспорт
	
	СостоянияВыгрузки = Новый Структура("НаМодерации, Отклонена", Ложь, Ложь);
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ ПЕРВЫЕ 1
	|	ИСТИНА КАК НаМодерации,
	|	NULL КАК Отклонена
	|ИЗ
	|	РегистрСведений.СостоянияВыгрузкиНоменклатуры КАК СостоянияВыгрузкиНоменклатуры
	|ГДЕ
	|	СостоянияВыгрузкиНоменклатуры.Организация = &Организация
	|	И СостоянияВыгрузкиНоменклатуры.Состояние = ЗНАЧЕНИЕ(Перечисление.СостоянияВыгрузкиНоменклатуры.ПроверяетсяМодератором)
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ ПЕРВЫЕ 1
	|	NULL,
	|	ИСТИНА
	|ИЗ
	|	РегистрСведений.СостоянияВыгрузкиНоменклатуры КАК СостоянияВыгрузкиНоменклатуры
	|ГДЕ
	|	СостоянияВыгрузкиНоменклатуры.Организация = &Организация
	|	И СостоянияВыгрузкиНоменклатуры.Состояние = ЗНАЧЕНИЕ(Перечисление.СостоянияВыгрузкиНоменклатуры.Отклонена)";
	
	Запрос.УстановитьПараметр("Организация", Организация);
	УстановитьПривилегированныйРежим(Истина);
	Результат = Запрос.Выполнить();
	УстановитьПривилегированныйРежим(Ложь);
	Выборка = Результат.Выбрать();
	Пока Выборка.Следующий() Цикл 
		Если Выборка.НаМодерации = Истина Тогда
			СостоянияВыгрузки.Вставить("НаМодерации", Истина);
		КонецЕсли;
		Если Выборка.Отклонена = Истина Тогда
			СостоянияВыгрузки.Вставить("Отклонена", Истина);
		КонецЕсли;
	КонецЦикла;
	
	Возврат СостоянияВыгрузки;
	
КонецФункции

Функция ДобавитьКВыгрузкеНоменклатуруСХарактеристиками(Знач Организация, Знач АдресТаблицы, Знач ДобавитьКВыгрузке) Экспорт

	Товары = ПолучитьИзВременногоХранилища(АдресТаблицы);
	УдалитьИзВременногоХранилища(АдресТаблицы);
	РаботаСНоменклатуройСлужебный.ПодготовитьТаблицуТоваров(Товары);

	Состояние = ?(ДобавитьКВыгрузке, 
		Перечисления.СостоянияВыгрузкиНоменклатуры.Новая, 
		Перечисления.СостоянияВыгрузкиНоменклатуры.ВыгрузкаЗапрещена);

	ПустаяНоменклатура = Метаданные.ОпределяемыеТипы.НоменклатураРаботаСНоменклатурой.Тип.ПривестиЗначение();
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Товары", Товары);
	Запрос.УстановитьПараметр("Организация", Организация);
	Запрос.УстановитьПараметр("Состояние", Состояние);
	Запрос.УстановитьПараметр("ДатаСостояния", ТекущаяДатаСеанса());
	Запрос.УстановитьПараметр("ПустаяНоменклатура", ПустаяНоменклатура);
	Запрос.Текст = "ВЫБРАТЬ
	|	Товары.Номенклатура КАК Номенклатура,
	|	Товары.Характеристика КАК Характеристика
	|Поместить Товары
	|ИЗ
	|	&Товары как Товары
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Номенклатура,
	|	Характеристика
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	&Организация КАК Организация,
	|	Товары.Номенклатура как Номенклатура,
	|	Товары.Характеристика как ХарактеристикаНоменклатуры,
	|	&Состояние КАК Состояние,
	|	&ДатаСостояния КАК ДатаСостояния,
	|	СостоянияВыгрузкиНоменклатуры.Состояние КАК СостояниеВРегистра,
	|	ВЫБОР
	|		КОГДА СостоянияВыгрузкиНоменклатуры.Состояние ЕСТЬ NULL
	|			ТОГДА ИСТИНА
	|		ИНАЧЕ ЛОЖЬ
	|	КОНЕЦ КАК ДобавитьНабором
	|ИЗ
	|	Товары КАК Товары
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СостоянияВыгрузкиНоменклатуры КАК СостоянияВыгрузкиНоменклатуры
	|		ПО СостоянияВыгрузкиНоменклатуры.Организация = &Организация
	|		И Товары.Номенклатура = СостоянияВыгрузкиНоменклатуры.Номенклатура
	|		И Товары.Характеристика = СостоянияВыгрузкиНоменклатуры.ХарактеристикаНоменклатуры
	|где
	|	Товары.Номенклатура <> &ПустаяНоменклатура";

	Результат = Запрос.Выполнить();
	ТаблицаРезультата = Результат.Выгрузить();
	ТаблицаРезультата.Индексы.Добавить("ДобавитьНабором");
	
	СтрокиДляНабора = ТаблицаРезультата.НайтиСтроки(Новый Структура("ДобавитьНабором", Истина));
	Добавлено = СтрокиДляНабора.Количество();
	Если Добавлено > 0 Тогда
		ДанныеНабора = ТаблицаРезультата.Скопировать(СтрокиДляНабора);
		Набор = РегистрыСведений.СостоянияВыгрузкиНоменклатуры.СоздатьНаборЗаписей();
		Набор.Загрузить(ДанныеНабора);
		Набор.ОбменДанными.Загрузка = Истина;
		Набор.Записать(Ложь);
	КонецЕсли; 
	
	Выгружается = 0;
	Исключено   = 0;
	Изменено    = 0;
	СтрокиДляАнализа = ТаблицаРезультата.НайтиСтроки(Новый Структура("ДобавитьНабором", Ложь));
	Для Каждого СтрокаТаблицы Из СтрокиДляАнализа Цикл
		Если СтрокаТаблицы.СостояниеВРегистра = Перечисления.СостоянияВыгрузкиНоменклатуры.ВыгрузкаЗапрещена Тогда
			Исключено = Исключено + 1;
		ИначеЕсли Не ДобавитьКВыгрузке И МожноДобавитьИсключение(СтрокаТаблицы.СостояниеВРегистра) Тогда
			Запись = РегистрыСведений.СостоянияВыгрузкиНоменклатуры.СоздатьМенеджерЗаписи();
			ЗаполнитьЗначенияСвойств(Запись, СтрокаТаблицы);
			Запись.Записать();
			Добавлено = Добавлено + 1;
			Изменено  = Изменено + 1;
		Иначе
			Выгружается = Выгружается + 1;			
		КонецЕсли;
	КонецЦикла;
	
	Возврат Новый Структура("Добавлено,Выгружается,Исключено,Изменено", Добавлено,Выгружается,Исключено,Изменено);

КонецФункции

Процедура ОчиститьСписокВыгрузки(Знач Организация) Экспорт

	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Организация", Организация);
	Запрос.Текст = "ВЫБРАТЬ
				   |	СостоянияВыгрузкиНоменклатуры.Номенклатура как Номенклатура,
				   |	СостоянияВыгрузкиНоменклатуры.ХарактеристикаНоменклатуры как ХарактеристикаНоменклатуры
				   |ИЗ
				   |	РегистрСведений.СостоянияВыгрузкиНоменклатуры КАК СостоянияВыгрузкиНоменклатуры
				   |ГДЕ
				   |	СостоянияВыгрузкиНоменклатуры.Состояние = Значение(Перечисление.СостоянияВыгрузкиНоменклатуры.Новая)
				   |	И СостоянияВыгрузкиНоменклатуры.Организация = &Организация";
	
	Результат = Запрос.Выполнить();
	Выборка   = Результат.Выбрать();
	
	НаборЗаписей = РегистрыСведений.СостоянияВыгрузкиНоменклатуры.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.Организация.Установить(Организация);
	
	Пока Выборка.Следующий() Цикл
		НаборЗаписей.Отбор.Номенклатура.Установить(Выборка.Номенклатура);				
		НаборЗаписей.Отбор.ХарактеристикаНоменклатуры.Установить(Выборка.ХарактеристикаНоменклатуры);
		НаборЗаписей.Записать();
	КонецЦикла;

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ДобавитьВТекстЗапросаУсловиеНоваяНоменклатура(Запрос, ЛимитЗаписей = 1000, МассивНоменклатуры = Неопределено)

	СхемаЗапроса = Новый СхемаЗапроса;
	СхемаЗапроса.УстановитьТекстЗапроса(Запрос.Текст);
	
	ОсновнойЗапрос      = СхемаЗапроса.ПакетЗапросов[СхемаЗапроса.ПакетЗапросов.Количество()-1];
	КолонкаНоменклатура = ОсновнойЗапрос.Колонки.Найти("Номенклатура");
	ПолеНоменклатура    = ОсновнойЗапрос.Операторы[0].ВыбираемыеПоля[ОсновнойЗапрос.Колонки.Индекс(КолонкаНоменклатура)];
	ПолеНоменклатура    = Строка(ПолеНоменклатура);
	
	УсловиеПорядок        = СтрШаблон("%1 > &Параметр_Порядок_Номенклатура", Строка(ПолеНоменклатура));
	УсловиеХарактеристика = "";
	ПолеХарактеристика    = "";
	КолонкаХарактеристика = ОсновнойЗапрос.Колонки.Найти("Характеристика");
	Если КолонкаХарактеристика <> Неопределено Тогда
		ПолеХарактеристика    = ОсновнойЗапрос.Операторы[0].ВыбираемыеПоля[ОсновнойЗапрос.Колонки.Индекс(КолонкаХарактеристика)];
		ПолеХарактеристика    = Строка(ПолеХарактеристика);
		УсловиеХарактеристика = СтрШаблон("И СостоянияВыгрузкиНоменклатуры.ХарактеристикаНоменклатуры = %1",
			ПолеХарактеристика);
		
		УсловиеПорядок = СтрШаблон("(%1 > &Параметр_Порядок_Номенклатура
			|ИЛИ %1 = &Параметр_Порядок_Номенклатура И %2 > &Параметр_Порядок_Характеристика)",
			ПолеНоменклатура,
			ПолеХарактеристика);
	КонецЕсли;
	
	УсловиеНовая        = "
	|	ИСТИНА НЕ В
	|		(ВЫБРАТЬ ПЕРВЫЕ 1
	|			ИСТИНА
	|		ИЗ
	|			РегистрСведений.СостоянияВыгрузкиНоменклатуры КАК СостоянияВыгрузкиНоменклатуры
	|		ГДЕ
	|			СостоянияВыгрузкиНоменклатуры.Организация = &Параметр_Организация
	|			И СостоянияВыгрузкиНоменклатуры.Номенклатура = %1
	|			%2)";
	
	Если МассивНоменклатуры <> Неопределено Тогда
		ОсновнойЗапрос.Операторы[0].Отбор.Добавить(СтрШаблон("%1 В(&МассивНоменклатуры)", ПолеНоменклатура));
	КонецЕсли;
	ОсновнойЗапрос.Операторы[0].Отбор.Добавить(СтрШаблон(УсловиеНовая, ПолеНоменклатура, УсловиеХарактеристика));
	ОсновнойЗапрос.Операторы[0].Отбор.Добавить(УсловиеПорядок);
	ОсновнойЗапрос.Операторы[0].КоличествоПолучаемыхЗаписей = ЛимитЗаписей;
	ОсновнойЗапрос.Порядок.Добавить(ПолеНоменклатура);
	Если Не ПустаяСтрока(ПолеХарактеристика) Тогда
		ОсновнойЗапрос.Порядок.Добавить(ПолеХарактеристика);
	КонецЕсли;
	
	Запрос.Текст = СхемаЗапроса.ПолучитьТекстЗапроса();

КонецПроцедуры

Функция МожноДобавитьИсключение(Знач Состояние)
	
	Возврат Состояние = Перечисления.СостоянияВыгрузкиНоменклатуры.Новая
		ИЛИ Состояние = Перечисления.СостоянияВыгрузкиНоменклатуры.ОжидаетПодтверждения
		ИЛИ Состояние = Перечисления.СостоянияВыгрузкиНоменклатуры.СодержитПроблемы
		ИЛИ Состояние = Перечисления.СостоянияВыгрузкиНоменклатуры.ОжидаетИсправления;
		
КонецФункции

Функция ЗапросОтборНоменклатурыСХарактеристиками(Настройки)
	
	ТекстЗапроса = "";
	РаботаСНоменклатуройПереопределяемый.ИнициализацияЗапросаОтбораНоменклатурыСХарактеристиками(ТекстЗапроса);
	ЗначимыеКолонки = Новый Структура("Номенклатура, Характеристика");
	
	Возврат РаботаСНоменклатуройСлужебный.ЗапросОтборНоменклатуры(Настройки, Ложь, ЗначимыеКолонки, ТекстЗапроса);
	
КонецФункции

#КонецОбласти

#КонецЕсли