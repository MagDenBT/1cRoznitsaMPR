
////////////////////////////////////////////////////////////////////////////////
// Подсистема "Торговые предложения".
// ОбщийМодуль.ТорговыеПредложенияРТ.
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Возвращает признак того, что функциональная опция использования видов номенклатуры включена.
// 
// Параметры:
//   ИмяФормы - Строка - имя формы, для которой получаются данные.
//   Результат - Булево - признак того, что функциональная опция включена.
//
Процедура ФункциональнаяОпцияИспользуется(Знач ИмяФормы, Результат) Экспорт
	
	Если ИмяФормы = "Обработка.ТорговыеПредложения.Форма.СопоставлениеНоменклатуры"
		ИЛИ ИмяФормы = "Обработка.ТорговыеПредложения.Форма.СписокПубликаций" Тогда
		Результат = Истина;
	КонецЕсли;
		
КонецПроцедуры

// Получение валюты регламентированного учета.
// 
// Параметры:
//  Валюта - СправочникСсылка - валюта регламентированного учета.
//
Процедура ПолучитьВалютуРегламентированногоУчета(Валюта) Экспорт
	Валюта = НСтр("ru = 'руб.'");
КонецПроцедуры

// Создает документ заказ поставщику на основании данных торгового предложения.
//
// Параметры:
//  ДанныеЗаполнения - Структура - данные торгового предложения:
//   * Организация       - СправочникСсылка - организация торгового предложения.
//   * Контрагент        - СправочникСсылка - поставщик торгового предложения.
//   * Валюта            - СправочникСсылка.Валюты - валюта торгового предложения.
//   * СтрокиЗаказа      - ТаблицаЗначений - содержит данные табличной части.
//       * Номенклатура - СправочникСсылка.
//       * Характеристика - СправочникСсылка.
//       * ЕдиницаИзмерения - СправочникСсылка.
//       * Количество - Число.
//       * Цена - Число.
//       * ЦенаВключаетНДС - Булево.
//       * СтавкаНДС - ПеречислениеСсылка.
//       * СуммаНДС - Число.
//       * СуммаСНДС - Число.
//       * Сумма - Число.
//       * ИдентификаторНоменклатуры - Строка - идентификатор номенклатуры поставщика.
//   * КонтекстИсточника - Структура - набор данных из основания содержащий данные для заполнения шапки документа.
//   * СпособДоставки    - Ссылка - способ доставки прикладного решения.
//   * АдресДоставки     - Строка - представление адреса доставки.
//   * АдресДоставкиЗначенияПолей - Строка - значение адреса доставки в формате XML.
//  ДокументОбъект - ДокументОбъект - возвращается созданный, но не записанный документ.
//  Отказ - Булево - признак ошибки при работе метода.
//
Процедура СоздатьДокументЗаказПоставщикуНаОснованииТорговогоПредложения(Знач ДанныеЗаполнения, ДокументОбъект, Отказ) Экспорт
	
	КонтекстИсточника = ДанныеЗаполнения.КонтекстИсточника;
	СтрокиЗаказа = ДанныеЗаполнения.СтрокиЗаказа;
	Организация = ДанныеЗаполнения.Организация;
	Контрагент = ДанныеЗаполнения.Контрагент;
	
	ДокументОбъект = Документы.ЗаказПоставщику.СоздатьДокумент();
	ДокументОбъект.Дата = ТекущаяДатаСеанса();
	ДокументОбъект.ДатаПоступления = ДокументОбъект.Дата;
	ДокументОбъект.Заполнить(Неопределено);
	ДокументОбъект.УстановитьНовыйНомер();

	// Реквизиты шапки.
	ДокументОбъект.Организация = Организация;
	ДокументОбъект.Контрагент =  Контрагент;
	Если КонтекстИсточника <> Неопределено Тогда
		ЗаполнитьЗначенияСвойств(ДокументОбъект, КонтекстИсточника);
	КонецЕсли;
	
	ЦенаВключаетНДС = Ложь;
	Для Каждого СтрокаЗаказа Из СтрокиЗаказа Цикл
		Если СтрокаЗаказа.ЦенаВключаетНДС = Истина Тогда
			ЦенаВключаетНДС = Истина;
			Прервать;
		КонецЕсли;
	КонецЦикла;
	ДокументОбъект.ЦенаВключаетНДС = ЦенаВключаетНДС;
	
	КэшированныеЗначения = Новый Структура;
	// Товары.
	Для Каждого СтрокаЗаказа Из СтрокиЗаказа Цикл
		СтрокаТовары = ДокументОбъект.Товары.Добавить();
		ЗаполнитьЗначенияСвойств(СтрокаТовары, СтрокаЗаказа);
		СтрокаТовары.ИдентификаторНоменклатурыПоставщика = СтрокаЗаказа.ИдентификаторНоменклатуры;
		СтрокаТовары.Характеристика = СтрокаЗаказа.Характеристика;
		СтрокаТовары.КоличествоУпаковок = СтрокаЗаказа.Количество;
		Если ЗначениеЗаполнено(СтрокаЗаказа.КонтекстСтроки) Тогда
			ЗаполнитьЗначенияСвойств(СтрокаТовары, СтрокаЗаказа.КонтекстСтроки);
		КонецЕсли;
		СтруктураПараметровСтавкиНДС = Новый Структура;
		СтруктураПараметровСтавкиНДС.Вставить("Дата", ДокументОбъект.Дата);
		СтруктураПараметровСтавкиНДС.Вставить("Склад", ДокументОбъект.Склад);
		СтруктураПараметровСтавкиНДС.Вставить("Организация", ДокументОбъект.Организация);
		
		СтруктураДействий = Новый Структура;
		СтруктураДействий.Вставить("ЗаполнитьСтавкуНДССкладВШапке", СтруктураПараметровСтавкиНДС);
		
		ОбработкаТабличнойЧастиТоварыСервер.ЗаполнитьСтавкуНДСВСтрокеСкладВШапкеТЧСервер(СтрокаТовары, 
			СтруктураДействий, КэшированныеЗначения);
			
		Если ЦенаВключаетНДС 
			И Не СтрокаЗаказа.ЦенаВключаетНДС 
			И СтрокаЗаказа.Количество > 0 Тогда
			
			СтрокаТовары.Цена = СтрокаЗаказа.СуммаСНДС/СтрокаЗаказа.Количество;
			СтрокаТовары.Сумма = СтрокаЗаказа.СуммаСНДС;
		КонецЕсли;
			
		СтруктураДействий = Новый Структура;
		ПараметрыПересчетаНДС = ОбработкаТабличнойЧастиТоварыКлиентСервер.СтруктураПересчетаСуммыНДСВСтрокеТЧ(ДокументОбъект);
		СтруктураДействий.Вставить("ПересчитатьСуммуНДС", ПараметрыПересчетаНДС);
		
		ОбработкаТабличнойЧастиТоварыСервер.ПересчитатьСуммуНДСВСтрокеТЧСервер(СтрокаТовары, СтруктураДействий, 
			КэшированныеЗначения);
	КонецЦикла;
	
КонецПроцедуры

// Удаляет созданные заказы поставщику при переходе на шаг назад.
//
// Параметры:
//  ТаблицаДокументы - ТаблицаЗначений - таблица документов для удаления, состав:
//    * Ссылка - ДокументСсылка - ссылка на удаляемый документ.
//  Отказ - Булево - признак результата удаления документов.
//
Процедура УдалитьДокументыЗаказПоставщику(ТаблицаДокументы, Отказ) Экспорт
	
	Сообщение = Новый СообщениеПользователю;
	ТекстИмеютсяСсылки = НСтр("ru = 'Имеются ссылки на %1 - %2.'");
	ТекстПомечен       = НСтр("ru = '%1 - помечен на удаление.'");
	ТекстЗаблокирован  = НСтр("ru = '%1 - заблокирован. Пометить на удаление не удалось.'");
	ТекстУдален        = НСтр("ru = '%1 - удален.'");
	
	СсылкиНаУдаление = Новый Массив;
	Для каждого СтрокаТаблицы Из ТаблицаДокументы Цикл
		СсылкиНаУдаление.Добавить(СтрокаТаблицы.Ссылка);
	КонецЦикла;
	
	ТаблицаСсылок = НайтиПоСсылкам(СсылкиНаУдаление);
	
	СсылкиПометокУдаления = Новый Массив;
	ВсегоСтрок = ТаблицаСсылок.Количество();
	Для Счетчик = 1 По ВсегоСтрок Цикл
		Ссылка = ТаблицаСсылок[ВсегоСтрок - Счетчик];
		Индекс = СсылкиНаУдаление.Найти(Ссылка[1]);
		Если Индекс = Неопределено Тогда
			Если СсылкиПометокУдаления.Найти(Ссылка[0]) = Неопределено Тогда
				СсылкиПометокУдаления.Добавить(Ссылка[0]);
				Сообщение.Текст = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстИмеютсяСсылки, 
					СокрЛП(Ссылка[0]), СокрЛП(Ссылка[1]));
				Сообщение.Сообщить();
			КонецЕсли;
			ТаблицаСсылок.Удалить(Ссылка);
		КонецЕсли;
	КонецЦикла;
	
	ОбработкаЗавершена = Ложь;
	Пока Не ОбработкаЗавершена Цикл
		ОбработкаЗавершена = Истина;
		ВсегоСтрок = ТаблицаСсылок.Количество();
		Для Счетчик = 1 По ВсегоСтрок Цикл
			Ссылка = ТаблицаСсылок[ВсегоСтрок - Счетчик];
			Если СсылкиПометокУдаления.Найти(Ссылка[0]) <> Неопределено Тогда
				Если СсылкиПометокУдаления.Найти(Ссылка[1]) = Неопределено Тогда
					СсылкиПометокУдаления.Добавить(Ссылка[1]);
				КонецЕсли;
				ТаблицаСсылок.Удалить(Ссылка);
				ОбработкаЗавершена = Ложь;
			КонецЕсли;
		КонецЦикла;
	КонецЦикла;
	
	ТаблицаДокументы.Очистить();
	
	Для каждого ЗначениеМассива Из СсылкиПометокУдаления Цикл
		Индекс = СсылкиНаУдаление.Найти(ЗначениеМассива);
		Если Индекс <> Неопределено Тогда
			СсылкиНаУдаление.Удалить(Индекс);
		КонецЕсли;
		ДокументОбъект = ЗначениеМассива.ПолучитьОбъект();
		Если Не ДокументОбъект.Заблокирован() Тогда
			ДокументОбъект.УстановитьПометкуУдаления(Истина);
			Сообщение.Текст = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстПомечен, 
				СокрЛП(ЗначениеМассива));
		Иначе
			Сообщение.Текст = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстЗаблокирован, 
				СокрЛП(ЗначениеМассива));
		КонецЕсли;
		Сообщение.Сообщить();
	КонецЦикла;
	
	Для каждого ЗначениеМассива Из СсылкиНаУдаление Цикл
		Сообщение.Текст = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстУдален, 
			СокрЛП(ЗначениеМассива));
		Сообщение.Сообщить();
	КонецЦикла;
	
	УдалитьОбъекты(СсылкиНаУдаление, Ложь);

КонецПроцедуры

// Получает значения контекста на основании которого будет производиться поиск предложений
// и которые будут переданы в шапку создаваемых заказов.
//
// Параметры:
//  ПараметрКоманды   - Массив из ДокументСсылка - ссылки на документы для заполнения таблицы поиска товаров в 1С:Бизнес-сеть.
//  КонтекстИсточника - Структура - свойства источника, используемые для формирования заказов.
//  ТаблицаТовары     - ТаблицаЗначений - товары для поиска с реквизитами, состав:
//    * Номенклатура     - СправочникСсылка - номенклатура.
//    * Характеристика   - СправочникСсылка - характеристика номенклатуры.
//    * Упаковка         - СправочникСсылка - упаковка номенклатуры.
//    * Количество       - Число - количество.
//    * ЕдиницаИзмерения - СправочникСсылка - единица измерения номенклатуры.
//    * Числитель        - Число - числитель упаковки.
//    * Знаменатель      - Число - знаменатель номенклатуры.
//    * Склад            - СправочникСсылка - склад для заказа.
//    * КонтекстСтроки   - Произвольный - дополнительные свойства по источнику.
//
Процедура СвойстваКонтекстаДокументовДляПоискаПредложений(Знач ПараметрКоманды, КонтекстИсточника, ТаблицаТовары) Экспорт
	
	Если ТипЗнч(ПараметрКоманды) = Тип("Массив") Тогда
		Ссылка = ПараметрКоманды[0];
	Иначе
		Ссылка = ПараметрКоманды;
	КонецЕсли;
	
	ДополнительныеРеквизиты = Новый Структура;
	ДополнительныеРеквизиты.Вставить("Организация");
	
	Запрос = Новый Запрос;
	Если ТипЗнч(Ссылка) = Тип("ДокументСсылка.ЗаказПоставщику") Тогда
		
		Запрос.Текст =
		"ВЫБРАТЬ
		|	ЗаказПоставщикуТовары.Номенклатура КАК Номенклатура,
		|	ЗаказПоставщикуТовары.Номенклатура.ЕдиницаИзмерения КАК ЕдиницаИзмерения,
		|	СУММА(ЗаказПоставщикуТовары.КоличествоУпаковок) КАК Количество,
		|	ЗаказПоставщикуТовары.Характеристика КАК Характеристика
		|ИЗ
		|	Документ.ЗаказПоставщику.Товары КАК ЗаказПоставщикуТовары
		|ГДЕ
		|	ЗаказПоставщикуТовары.Ссылка В(&Ссылки)
		|
		|СГРУППИРОВАТЬ ПО
		|	ЗаказПоставщикуТовары.Номенклатура,
		|	ЗаказПоставщикуТовары.Характеристика
		|
		|УПОРЯДОЧИТЬ ПО
		|	Номенклатура";
		КонтекстИсточника = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Ссылка, ДополнительныеРеквизиты);
		
	Иначе
		
		Возврат;
		
	КонецЕсли;
	
	Запрос.УстановитьПараметр("Ссылки", Ссылка);
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		НоваяСтрока = ТаблицаТовары.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, Выборка);
		НоваяСтрока.Упаковка = Выборка.ЕдиницаИзмерения;
	КонецЦикла;
	
КонецПроцедуры

// Производит пересчет суммы для заказа товаров.
//
// Параметры:
//  СтрокаТоваров - Структура - реквизиты строки товаров для пересчета суммы при формировании заказов:
//    * ПроцентНДС      - Строка - значение НДС, полученное из сервиса.
//    * СтавкаНДС       - Ссылка - значение ставки НДС.
//    * Цена            - Число - цена товара для заказа.
//    * ЦенаВключаетНДС - Булево - признак включения НДС в цену.
//    * Количество      - Число - количество товара для заказа.
//    * Сумма           - Число - сумма заказа по строке.
//    * СуммаНДС        - Число - сумма НДС строки.
//    * СуммаСНДС       - Число - значение суммы с НДС.
//    * ПроцентСкидки   - Число - процент скидки по строке.
//    * СуммаСкидки     - Число - сумма скидки по строке.
//
Процедура ПересчитатьСуммуПоСтроке(СтрокаТоваров) Экспорт
	
	СуммаБезСкидки = СтрокаТоваров.Цена * СтрокаТоваров.Количество;
	СтрокаТоваров.СуммаСкидки = Окр(СуммаБезСкидки * СтрокаТоваров.ПроцентСкидки / 100, 2);
	СтрокаТоваров.Сумма = Макс(СуммаБезСкидки - СтрокаТоваров.СуммаСкидки,0);
	
	ЗначениеСтавки = ОбработкаТабличнойЧастиТоварыСерверПовтИсп.СтавкаНДСЧислом(СтрокаТоваров.СтавкаНДС);
	Если СтрокаТоваров.ЦенаВключаетНДС Тогда
		СтрокаТоваров.СуммаНДС  = СтрокаТоваров.Сумма - СтрокаТоваров.Сумма / (1 + ЗначениеСтавки);
		СтрокаТоваров.СуммаСНДС = СтрокаТоваров.Сумма;
	Иначе
		СтрокаТоваров.СуммаНДС  = СтрокаТоваров.Сумма * ЗначениеСтавки;
		СтрокаТоваров.СуммаСНДС = СтрокаТоваров.Сумма + СтрокаТоваров.СуммаНДС;
	КонецЕсли;
	
КонецПроцедуры

// Устанавливаем условное оформление для единиц измерения номенклатуры.
//
// Параметры:
// 	 Форма - Форма - управляемая форму.
// 	 ИмяПоляВводаЕдиницИзмерения - Строка - наименование элемента формы, содержащего ед. измерения номенклатуры.
// 	 ПутьКПолюОтбора - Строка - полный путь к реквизиту.
//
Процедура УстановитьУсловноеОформлениеЕдиницИзмерения(Форма, Знач ИмяПоляВводаЕдиницИзмерения, Знач ПутьКПолюОтбора) Экспорт
	
	УсловноеОформление = Форма.УсловноеОформление;
	ЭлементыФормы = Форма.Элементы;
	
	ЭлементУсловногоОформления = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = ЭлементУсловногоОформления.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(ЭлементыФормы[ИмяПоляВводаЕдиницИзмерения].Имя);

	ОтборЭлемента = ЭлементУсловногоОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных(ПутьКПолюОтбора);
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Заполнено;
	
	ЭлементУсловногоОформления.Оформление.УстановитьЗначениеПараметра("Отображать", Ложь);
	
КонецПроцедуры

// Заполнение реквизитов номенклатуры в процедуре формирования заказа.
//
// Параметры:
//  Номенклатура - СправочникСсылка - ссылка на справочник номенклатура.
//  Результат	 - Структура - возвращаемые реквизиты ссылки справочника:
//    * ИспользованиеХарактеристик - Булево - признак использования характеристик номенклатуры.
//    * ЕдиницаИзмерения - СправочникСсылка - единица измерения номенклатуры.
//    * Упаковка - СправочникСсылка - упаковка номенклатуры.
//
Процедура ЗаполнитьРеквизитыНоменклатурыДляФормированияЗаказа(Знач Номенклатура, Результат) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	Номенклатура.ЕдиницаИзмерения КАК ЕдиницаИзмерения,
	|	Номенклатура.ЕдиницаИзмерения КАК Упаковка,
	|	Номенклатура.ВидНоменклатуры.ИспользоватьХарактеристики КАК ИспользованиеХарактеристик
	|ИЗ
	|	Справочник.Номенклатура КАК Номенклатура
	|ГДЕ
	|	Номенклатура.Ссылка = &Номенклатура";
	
	Запрос.УстановитьПараметр("Номенклатура", Номенклатура);
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Выборка.Следующий();
	
	ЗаполнитьЗначенияСвойств(Результат, Выборка);
	
КонецПроцедуры

// Заполнение реквизитов заказов.
//
// Параметры:
//  ТаблицаЗаказов	 - ТаблицаЗначений - таблица с ссылками и реквизитами для заполнения.
//                     см. табличную часть "Заказы" обработки ТорговыеПредложения.ФормированиеЗаказов.
//
Процедура ЗаполнитьРеквизитыЗаказов(ТаблицаЗаказов) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ЗаказПоставщику.Ссылка КАК Ссылка,
	|	ЗаказПоставщику.Контрагент КАК Контрагент,
	|	ЗаказПоставщику.Организация КАК Организация,
	|	ЗаказПоставщику.СуммаДокумента КАК СуммаДокумента,
	|	ВЫБОР
	|		КОГДА ЗаказПоставщику.Проведен
	|			ТОГДА 1
	|		КОГДА ЗаказПоставщику.ПометкаУдаления
	|			ТОГДА 2
	|		ИНАЧЕ 0
	|	КОНЕЦ КАК ЗначениеКартинки
	|ИЗ
	|	Документ.ЗаказПоставщику КАК ЗаказПоставщику
	|ГДЕ
	|	ЗаказПоставщику.Ссылка В(&СписокДокументов)";
	
	Запрос.УстановитьПараметр("СписокДокументов", ТаблицаЗаказов.ВыгрузитьКолонку("Ссылка"));
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		СтрокаТаблицы = ТаблицаЗаказов.Найти(Выборка.Ссылка, "Ссылка");
		Если СтрокаТаблицы = Неопределено Тогда
			Продолжить;
		КонецЕсли;
		ЗаполнитьЗначенияСвойств(СтрокаТаблицы, Выборка);
		ПолучитьВалютуРегламентированногоУчета(СтрокаТаблицы.Валюта);
	КонецЦикла;
	
КонецПроцедуры

// Заполнение адресов абонента по зарегистрированным организациям и складам.
//
// Параметры:
//  АдресаАбонента - ТаблицаЗначения - таблица для заполнения:
//   * Представление - Строка - представление адреса.
//   * ЗначенияПолей - Строка - адрес в формате XML.
//   * Описание - Строка - комментарий адреса.
//   * Ссылка - Ссылка - объект хранения контактной информации.
//   * Вид - СправочникСсылка.ВидыКонтактнойИнформации - вид контактной информации.
//
Процедура ЗаполнитьАдресаАбонента(АдресаАбонента) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ОрганизацииКонтактнаяИнформация.Представление КАК Представление,
	|	ОрганизацииКонтактнаяИнформация.ЗначенияПолей КАК ЗначенияПолей,
	|	ОрганизацииКонтактнаяИнформация.Вид КАК Вид,
	|	ОрганизацииКонтактнаяИнформация.Ссылка КАК Ссылка
	|ИЗ
	|	РегистрСведений.ОрганизацииБизнесСеть КАК ОрганизацииБизнесСеть
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Организации.КонтактнаяИнформация КАК ОрганизацииКонтактнаяИнформация
	|		ПО (ОрганизацииКонтактнаяИнформация.Ссылка = ОрганизацииБизнесСеть.Организация)
	|ГДЕ
	|	ОрганизацииКонтактнаяИнформация.Тип = ЗНАЧЕНИЕ(Перечисление.ТипыКонтактнойИнформации.Адрес)
	|";
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		Если ПустаяСтрока(Выборка.Представление) Тогда
			Продолжить;
		КонецЕсли;
		СтрокаАдреса = АдресаАбонента.Добавить();
		ЗаполнитьЗначенияСвойств(СтрокаАдреса, Выборка);
		СтрокаАдреса.Описание = СтрШаблон("%1 (%2)", Выборка.Вид, Выборка.Ссылка);
	КонецЦикла;
	
	АдресаАбонента.Сортировать("Представление");
	
КонецПроцедуры

// Получение способов доставки для заполнения по умолчанию значений при формировании заказов.
//
// Параметры:
//  СпособыДоставки - СписокЗначений - возможные значения способа доставки.
//                                     Первое значение является значением по умолчанию.
//  ВидДоставки	- Строка - значение вида доставки, варианты "Самовывоз", "Доставка".
//
Процедура ПолучитьСпособыДоставки(СпособыДоставки, ВидДоставки = Неопределено) Экспорт
	
	СпособыДоставки = Новый СписокЗначений;
	Если ВРег(ВидДоставки) = "САМОВЫВОЗ" Тогда
		СпособыДоставки.Добавить(НСтр("ru = 'Самовывоз'"));
	ИначеЕсли ВРег(ВидДоставки) = "ДОСТАВКА" Тогда 
		СпособыДоставки.Добавить(НСтр("ru = 'Доставка'"));
	Иначе
		СпособыДоставки.Добавить(НСтр("ru = 'Доставка'"));
		СпособыДоставки.Добавить(НСтр("ru = 'Самовывоз'"));
	КонецЕсли;
	
КонецПроцедуры

// Получение доступности функционала запроса цен в прикладном решении.
//
// Параметры:
//  Результат - Булево - признак доступности функционала запроса цен.
//
Процедура ПолучитьДоступностьФункционалаЗапросаЦен(Результат) Экспорт
	Результат = Истина;
КонецПроцедуры

// Процедура, вызываемая из обработчика события формы ПриСозданииНаСервере.
//
// Параметры:
//  Форма - УправляемаяФорма - из обработчика события которой происходит вызов процедуры.
//
Процедура ПриСозданииНаСервере(Форма) Экспорт
	Если Форма.ИмяФормы = "Обработка.ТорговыеПредложения.Форма.ПоискПоТоварам"
		ИЛИ Форма.ИмяФормы = "Обработка.ТорговыеПредложения.Форма.ПоискПоОтборам" Тогда
		Форма.Элементы.ИзменитьВалютуПоиска.Видимость = Ложь;
	ИначеЕсли Форма.ИмяФормы = "Обработка.ТорговыеПредложения.Форма.ФормированиеЗаказов" Тогда
		Форма.Элементы.КонтрагентыСпособДоставки.Видимость = Ложь;
		Форма.Элементы.КонтрагентыАдресДоставки.Видимость = Ложь;
	КонецЕсли; 
КонецПроцедуры

// Получение значения ставки НДС по идентификатору.
//
// Параметры:
//  ИмяСтавкиНДС - Строка - идентификатор ставки НДС, например "НДС0", "НДС10", "НДС18", "НДС20", "БезНДС".
//  Ссылка		 - СправочникСсылка, ПеречислениеСсылка - ссылка на значение ставки НДС прикладного решения.
//
Процедура ПолучитьЗначениеСтавкиНДС(Знач ИмяСтавкиНДС, Ссылка) Экспорт
	
	Если Не ПустаяСтрока(ИмяСтавкиНДС)
		И Метаданные.Перечисления.СтавкиНДС.ЗначенияПеречисления.Найти(ИмяСтавкиНДС) <> Неопределено Тогда
		Ссылка = Перечисления.СтавкиНДС[ИмяСтавкиНДС];
	Иначе
		Ссылка = Перечисления.СтавкиНДС.БезНДС;
	КонецЕсли;
	
КонецПроцедуры

// Получение имени ставки НДС.
//
// Параметры:
//  Ссылка		 - СправочникСсылка, ПеречислениеСсылка - ссылка на значение ставки НДС прикладного решения.
//  ИмяСтавкиНДС - Строка - идентификатор ставки НДС, вида: "НДС0", "НДС10", НДС10_110, "НДС18", НДС18_118, "НДС20", НДС20_120, "БезНДС".
//
Процедура ПолучитьИмяСтавкиНДС(Знач Ссылка, ИмяСтавкиНДС) Экспорт
	
	ОбъектМетаданных = Ссылка.Метаданные();
	ИндексЗначения = Перечисления.СтавкиНДС.Индекс(Ссылка);
	Если ИндексЗначения <> -1 Тогда
		ИмяСтавкиНДС = ОбъектМетаданных.ЗначенияПеречисления[ИндексЗначения].Имя;
	Иначе
		ИмяСтавкиНДС = Неопределено;
	КонецЕсли;
	
КонецПроцедуры

// См. ТорговыеПредложенияПереопределяемый.ИнициализацияЗапросаПубликуемыхТоваров.
Процедура ИнициализацияЗапросаПубликуемыхТоваров(Запрос) Экспорт
	
КонецПроцедуры

// См. ТорговыеПредложенияПереопределяемый.ИнициализацияЗапросаПубликуемыхТоваров.
Процедура ПолучитьСвойстваТорговогоПредложения(Знач Источник, ЗначенияСвойств) Экспорт
	
КонецПроцедуры

// См. ТорговыеПредложенияПереопределяемый.ДобавитьСлужебныеКолонкиТовары.
Процедура ДобавитьСлужебныеКолонкиТовары(Товары, Знач ПолучатьШтрихКоды = Ложь) Экспорт
	
КонецПроцедуры

#КонецОбласти
