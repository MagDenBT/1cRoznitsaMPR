#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

// Процедура - обработчик события "ОбработкаЗаполнения".
//
Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	ИнициализироватьДокумент();
	
КонецПроцедуры

// Процедура - обработчик события "ОбработкаПроведения".
//
Процедура ОбработкаПроведения(Отказ, Режим)
	
	
	ПроведениеСервер.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства, Режим);
	//
	// Инициализация данных документа.
	Документы.ЗаменаДисконтныхКарт.ИнициализироватьДанныеДокумента(Ссылка, ДополнительныеСвойства);
	//
	// Подготовка наборов записей
	ПроведениеСервер.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	//
	// Движения по денежным средствам.
	МаркетинговыеАкцииСервер.ОтразитьРегистрацияЗаменыКартПокупателей(ДополнительныеСвойства, Движения, Отказ);
	//
	СформироватьСписокРегистровДляКонтроля();
	//
	// Запись наборов записей
	ПроведениеСервер.ЗаписатьНаборыЗаписей(ЭтотОбъект);
	ПроведениеСервер.ВыполнитьКонтрольРезультатовПроведения(ЭтотОбъект, Отказ);
	ПроведениеСервер.ОчиститьДополнительныеСвойстваДляПроведения(ДополнительныеСвойства);
		
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	ПустаяКарта = Справочники.ИнформационныеКарты.ПустаяСсылка();
	НайденнаяСтрока = КартыПокупателей.Найти(ПустаяКарта, "КартаИсточник, КартаПриемник");
	Если НайденнаяСтрока = Неопределено Тогда
		ПроверитьЗаполнениеТабличнойЧастиКартыПокупателей(Отказ);
	КонецЕсли;
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ПроведениеСервер.УстановитьРежимПроведения(Проведен, РежимЗаписи, РежимПроведения);
	
	ДополнительныеСвойства.Вставить("ЭтоНовый",    ЭтоНовый());
	ДополнительныеСвойства.Вставить("РежимЗаписи", РежимЗаписи);
	
КонецПроцедуры

// Процедура - обработчик события "ПриКопировании".
//
Процедура ПриКопировании(ОбъектКопирования)
	
	ИнициализироватьДокумент();
	
КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)
	
	ПроведениеСервер.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства);
	
	ПроведениеСервер.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	ПроведениеСервер.ЗаписатьНаборыЗаписей(ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Инициализирует документ
//
Процедура ИнициализироватьДокумент()
	
	Ответственный = Пользователи.ТекущийПользователь();
	
	Магазин = ЗначениеНастроекПовтИсп.МагазинПоУмолчанию(Магазин);
	
КонецПроцедуры

Процедура СформироватьСписокРегистровДляКонтроля()

	Массив = Новый Массив;

	ДополнительныеСвойства.ДляПроведения.Вставить("РегистрыДляКонтроля", Массив);

КонецПроцедуры

// Проверяет правильность заполнения табличной части "КартыПокупателей".
// Если какой-то из реквизитов, влияющих на проведение, не заполнен или
// заполнен некорректно, то устанавливается флаг отказа в проведении.
//
// Параметры:
//  ВыборкаПоШапкеДокумента - выборка из результата запроса по шапке документа.
//  Отказ - флаг отказа в проведении.
//  Заголовок - заголовок сообщения об ошибках.
//
Процедура ПроверитьЗаполнениеТабличнойЧастиКартыПокупателей(Отказ)
	
	Если Не Отказ Тогда
		
		Запрос = Новый Запрос;
		Запрос.Текст = 
		"ВЫБРАТЬ
		|	Таблица.КартаИсточник,
		|	Таблица.НомерСтроки
		|ПОМЕСТИТЬ ТаблицаВЗапросе
		|ИЗ
		|	&Таблица КАК Таблица
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ТаблицаВЗапросе.КартаИсточник,
		|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ТаблицаВЗапросе.НомерСтроки) КАК НомерСтроки
		|ПОМЕСТИТЬ ДублирующиесяОбъекты
		|ИЗ
		|	ТаблицаВЗапросе КАК ТаблицаВЗапросе
		|
		|СГРУППИРОВАТЬ ПО
		|	ТаблицаВЗапросе.КартаИсточник
		|
		|ИМЕЮЩИЕ
		|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ТаблицаВЗапросе.НомерСтроки) > 1
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ДублирующиесяОбъекты.КартаИсточник КАК КартаИсточник,
		|	ТаблицаВЗапросе.НомерСтроки
		|ИЗ
		|	ДублирующиесяОбъекты КАК ДублирующиесяОбъекты
		|		ЛЕВОЕ СОЕДИНЕНИЕ ТаблицаВЗапросе КАК ТаблицаВЗапросе
		|		ПО ДублирующиесяОбъекты.КартаИсточник = ТаблицаВЗапросе.КартаИсточник
		|ИТОГИ ПО
		|	КартаИсточник";
		
		Запрос.УстановитьПараметр("Таблица", КартыПокупателей.Выгрузить());
		
		Результат = Запрос.Выполнить();
		Выборка = Результат.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
		
		Пока Выборка.Следующий() Цикл
			
			ВыборкаНомеровСтрок = Выборка.Выбрать();
			ТекстСообщенияСтроки = "";
			Пока ВыборкаНомеровСтрок.Следующий() Цикл
				ТекстСообщенияСтроки = ТекстСообщенияСтроки + ВыборкаНомеровСтрок.НомерСтроки + ", ";
			КонецЦикла;
			ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Для карты ""%1"" есть дублирование в строках №№ %2'"),
				Выборка.КартаИсточник,
				ТекстСообщенияСтроки);
			ТекстСообщения = Лев(ТекстСообщения, СтрДлина(ТекстСообщения)-2);
			ОбщегоНазначения.СообщитьПользователю(
				ТекстСообщения,
				ЭтотОбъект,
				"КартыПокупателей",
				,
				Отказ);
		КонецЦикла;
	КонецЕсли;
	
	Если НЕ Отказ Тогда
	
		Запрос = Новый Запрос;
		Запрос.Текст = 
		"ВЫБРАТЬ
		|	Таблица.КартаИсточник,
		|	Таблица.КартаПриемник,
		|	Таблица.НомерСтроки
		|ПОМЕСТИТЬ ТаблицаВЗапросе
		|ИЗ
		|	&Таблица КАК Таблица
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ТаблицаВЗапросе.НомерСтроки КАК НомерСтроки,
		|	ТаблицаВЗапросе.КартаИсточник
		|ИЗ
		|	ТаблицаВЗапросе КАК ТаблицаВЗапросе
		|ГДЕ
		|	ТаблицаВЗапросе.КартаИсточник = ТаблицаВЗапросе.КартаПриемник
		|	И (НЕ ТаблицаВЗапросе.КартаИсточник = ЗНАЧЕНИЕ(Справочник.ИнформационныеКарты.ПустаяСсылка))";
		
		Запрос.УстановитьПараметр("Таблица", КартыПокупателей.Выгрузить());
		
		Результат = Запрос.Выполнить();
		Выборка = Результат.Выбрать();
		
		Пока Выборка.Следующий() Цикл
			ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'В строке № %1 в источнике и приемнике указана одинаковая карта ""%2""'"),
				Выборка.НомерСтроки,
				Выборка.КартаИсточник);
			ОбщегоНазначения.СообщитьПользователю(
				ТекстСообщения,
				ЭтотОбъект,
				"КартыПокупателей[" + Строка(Выборка.НомерСтроки - 1) + "].КартаИсточник",
				,
				Отказ);
		КонецЦикла;
		
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#КонецЕсли
