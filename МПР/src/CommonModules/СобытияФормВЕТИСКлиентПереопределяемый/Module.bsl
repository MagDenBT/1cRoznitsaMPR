#Область Локализация

Процедура ПослеЗаписи(Форма, ПараметрыЗаписи) Экспорт
	
	Возврат;
	
КонецПроцедуры

#Область СобытияЭлементовФорм

// Переопределяемая процедура, вызываемая из одноименного обработчика события элемента.
//
// Параметры:
//   Форма                   - ФормаКлиентскогоПриложения - форма, из которой происходит вызов процедуры.
//   Элемент                 - ЭлементФормы     - элемент-источник события "При изменении"
//   ДополнительныеПараметры - Структура        - значения дополнительных параметров влияющих на обработку.
//
Процедура ПриИзмененииЭлемента(Форма, Элемент, ДополнительныеПараметры) Экспорт
	
	Возврат;
	
КонецПроцедуры

// Переопределяемая процедура, вызываемая из одноименного обработчика события элемента.
//
Процедура ПриВыбореЭлемента(Форма, Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка, ДополнительныеПараметры) Экспорт
	
	Возврат;
	
КонецПроцедуры

// Переопределяемая процедура, вызываемая из одноименного обработчика события элемента.
//
Процедура ПриАктивизацииЯчейки(Форма, Элемент, ДополнительныеПараметры) Экспорт
	
	Возврат;
	
КонецПроцедуры

// Переопределяемая процедура, вызываемая из одноименного обработчика события элемента.
//
Процедура ПриНачалеРедактирования(Форма, Элемент, НоваяСтрока, Копирование, ДополнительныеПараметры) Экспорт
	
	Возврат;
	
КонецПроцедуры
#КонецОбласти

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

#Область ОбработчикиКоманд

// Открывает форму подбора номенклатуры.
//
// Параметры:
//  Форма                   - ФормаКлиентскогоПриложения   - форма, в которой вызывается команда открытия обработки сопоставления;
//  ОповещениеПриЗавершении - ОписаниеОповещения - процедура, вызываемая после закрытия формы подбора,
//  ПараметрыПодбора        - Структура          - параметры открытия формы подбора товаров, состав полей определен в функции
//                                                 ИнтеграцияВЕТИСКлиентСерверПереопределяемый.ПараметрыФормыПодбораТоваров.
//
Процедура ОткрытьФормуПодбораНоменклатуры(Форма, ОповещениеПриЗавершении = Неопределено, ПараметрыПодбора = Неопределено) Экспорт
	
	СобытияФормВЕТИСРТКлиент.ОткрытьФормуПодбораНоменклатуры(Форма, ОповещениеПриЗавершении, ПараметрыПодбора);
	
КонецПроцедуры

// Открывает форму выбора характеристики номенклатуры.
//
// Параметры:
//  Форма                   - ФормаКлиентскогоПриложения   - форма, в которой вызывается команда выбора номенклатуры,
//  ОповещениеПриЗавершении - ОписаниеОповещения - процедура, вызываемая после закрытия формы подбора,
//  ПараметрыХарактеристики - Структура          - параметры создания характеристики номенклатуры из формы выбора.
Процедура ОткрытьФормуВыбораХарактеристикиНоменклатуры(Форма, ОповещениеПриЗавершении, ПараметрыХарактеристики = Неопределено) Экспорт
	
	СобытияФормВЕТИСРТКлиент.ОткрытьФормуВыбораХарактеристикиНоменклатуры(
		Форма,
		ОповещениеПриЗавершении,
		ПараметрыХарактеристики);
	
КонецПроцедуры

// Открывает форму выбора характеристики номенклатуры.
//
// Параметры:
//  Форма                 - ФормаКлиентскогоПриложения - форма, в которой вызывается команда выбора номенклатуры,
//  ПараметрыНоменклатуры - (См. ИнтеграцияВЕТИСВызовСервера.ПараметрыНоменклатуры).
Процедура ОткрытьФормуВыбораНоменклатуры(Форма, ПараметрыНоменклатуры = Неопределено) Экспорт
	
	СобытияФормВЕТИСРТКлиент.ОткрытьФормуВыбораНоменклатуры(Форма, ПараметрыНоменклатуры);
	
КонецПроцедуры

// Открывает форму создания номенклатуры.
//
// Параметры:
//  Форма                 - ФормаКлиентскогоПриложения - форма, в которой вызывается команда создания номенклатуры,
//  ПараметрыНоменклатуры - (См. описание ИнтеграцияВЕТИСВызовСервера.ПараметрыНоменклатуры)
//  ЕдиницаИзмеренияВЕТИС - СправочникСсылка.ЕдиницыИзмеренияВЕТИС - единица измерения ВЕТИС, на основании которой 
//                                                                   создается номенклатура.
Процедура ОткрытьФормуСозданияНоменклатуры(Форма, ПараметрыНоменклатуры, ЕдиницаИзмеренияВЕТИС) Экспорт
	
	СобытияФормВЕТИСРТКлиент.ОткрытьФормуСозданияНоменклатуры(Форма, ПараметрыНоменклатуры, ЕдиницаИзмеренияВЕТИС);
	
КонецПроцедуры

// Открывает форму создания нового контрагента.
//
// Параметры:
//  ФормаВладелец - ФормаКлиентскогоПриложения - форма-владелец.
//  Реквизиты     - Структура        - (См. ИнтеграцияВЕТИСКлиентСервер.РеквизитыСозданияКонтрагента)
//
Процедура ОткрытьФормуСозданияКонтрагента(ФормаВладелец, Реквизиты) Экспорт
	
	СобытияФормВЕТИСРТКлиент.ОткрытьФормуСозданияКонтрагента(ФормаВладелец, Реквизиты);
	
КонецПроцедуры

// Открывает форму выбора контрагента.
//
// Параметры:
//  ФормаВладелец - ФормаКлиентскогоПриложения - форма, из которой осуществляется выбор.
//  Реквизиты     - Структура        - данные для заполнения отбора:
//   * Наименование            - Строка - наименование контрагента,
//   * СокращенноеНаименование - Строка - сокращенное наименование контрагента,
//   * ИНН                     - Строка - ИНН контрагента,
//   * КПП                     - Строка - КПП контрагента.
Процедура ОткрытьФормуВыбораКонтрагента(ФормаВладелец, Реквизиты) Экспорт
	
	СобытияФормВЕТИСРТКлиент.ОткрытьФормуВыбораКонтрагента(ФормаВладелец, Реквизиты);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

// Выполняет действия при изменении номенклатуры в таблице Товары.
//
// Параметры:
//  Форма                  - ФормаКлиентскогоПриложения            - форма, в которой произошло событие.
//  ТекущаяСтрока          - ДанныеФормыЭлементКоллекции - строка таблицы товаров.
//  КэшированныеЗначения   - Структура                   - сохраненные значения параметров, используемых при обработке строки таблицы.
//  ПараметрыЗаполнения    - см. ИнтеграцияВЕТИСКлиентСервер.ПараметрыЗаполненияТабличнойЧасти.
//  ПараметрыУказанияСерий - Структура                   - состав полей определен в функции НоменклатураКлиентСервер.ПараметрыУказанияСерий.
Процедура ПриИзмененииНоменклатуры(Форма,
								ТекущаяСтрока,
								КэшированныеЗначения,
								ПараметрыЗаполнения,
								ПараметрыУказанияСерий = Неопределено) Экспорт
	
	СобытияФормВЕТИСРТКлиент.ПриИзмененииНоменклатуры(
		Форма,
		ТекущаяСтрока,
		КэшированныеЗначения,
		ПараметрыЗаполнения,
		ПараметрыУказанияСерий);
	
КонецПроцедуры

// Выполняет действия при изменении характеристики в таблице Товары.
//
// Параметры:
//  Форма                - ФормаКлиентскогоПриложения            - форма, в которой произошло событие,
//  ТекущаяСтрока        - ДанныеФормыЭлементКоллекции - строка таблицы товаров,
//  КэшированныеЗначения - Структура                   - сохраненные значения параметров, используемых при обработке,
//  ПараметрыЗаполнения  - Структура                   - см. функцию ИнтеграцияВЕТИСКлиентСервер.ПараметрыЗаполненияТабличнойЧасти.
Процедура ПриИзмененииХарактеристики(Форма, ТекущаяСтрока, КэшированныеЗначения, ПараметрыЗаполнения) Экспорт
	
	СобытияФормВЕТИСРТКлиент.ПриИзмененииХарактеристики(Форма, ТекущаяСтрока, КэшированныеЗначения, ПараметрыЗаполнения);
	
КонецПроцедуры

// Выполняет действия при создании характеристики в таблице Товары.
//
// Параметры:
//  Форма                - ФормаКлиентскогоПриложения            - форма, в которой произошло событие,
//  ТекущаяСтрока        - ДанныеФормыЭлементКоллекции - строка таблицы товаров,
//  Элемент              - ПолеФормы                   - поле, в котором происходит создание характеристики,
//  СтандартнаяОбработка - Булево                      - признак отказа от стандартной обработки события.
Процедура ХарактеристикаСоздание(Форма, ТекущаяСтрока, Элемент, СтандартнаяОбработка) Экспорт
	
	
	Возврат;
	
КонецПроцедуры

// Выполняет действия при изменении серии в таблице Товары.
//
// Параметры:
//  Форма                  - ФормаКлиентскогоПриложения - форма, в которой произошло событие,
//  ПараметрыУказанияСерий - Структура        - состав полей определен в функции НоменклатураКлиентСервер.ПараметрыУказанияСерий,
//  ТекущиеДанные          - ДанныеФормыЭлементКоллекции, Структура - строка таблицы товаров,
//  КэшированныеЗначения   - Структура        - сохраненные значения параметров, используемых при обработке строки таблицы,
//  ПараметрыЗаполнения    - Структура        - см. функцию ИнтеграцияВЕТИСКлиентСервер.ПараметрыЗаполненияТабличнойЧасти.
Процедура ПриИзмененииСерии(Форма,
							ПараметрыУказанияСерий,
							ТекущиеДанные,
							КэшированныеЗначения = Неопределено,
							ПараметрыЗаполнения = Неопределено) Экспорт
	
	
	Возврат;
	
КонецПроцедуры

// Выполняет действия при изменении единицы измерения ВЕТИС в таблице Товары.
//
// Параметры:
//  Форма                - ФормаКлиентскогоПриложения            - форма, в которой произошло событие,
//  ТекущаяСтрока        - ДанныеФормыЭлементКоллекции - строка таблицы товаров,
//  КэшированныеЗначения - Структура                   - сохраненные значения параметров, используемых при обработке строки таблицы,
//  ПараметрыЗаполнения  - Структура                   - см. функцию ИнтеграцияВЕТИСКлиентСервер.ПараметрыЗаполненияТабличнойЧасти.
Процедура ПриИзмененииЕдиницыИзмеренияВЕТИС(Форма, ТекущаяСтрока, КэшированныеЗначения, ПараметрыЗаполнения) Экспорт
	
	СобытияФормВЕТИСРТКлиент.ПриИзмененииЕдиницыИзмеренияВЕТИС(
		Форма,
		ТекущаяСтрока,
		КэшированныеЗначения,
		ПараметрыЗаполнения);
	
КонецПроцедуры

// Выполняет действия при изменении количества ВЕТИС в таблице Товары.
//
// Параметры:
//  Форма                - ФормаКлиентскогоПриложения            - форма, в которой произошло событие,
//  ТекущаяСтрока        - ДанныеФормыЭлементКоллекции - строка таблицы товаров,
//  КэшированныеЗначения - Структура                   - сохраненные значения параметров, используемых при обработке строки таблицы,
//  ПараметрыЗаполнения  - Структура                   - см. функцию ИнтеграцияВЕТИСКлиентСервер.ПараметрыЗаполненияТабличнойЧасти.
Процедура ПриИзмененииКоличестваВЕТИС(Форма, ТекущаяСтрока, КэшированныеЗначения, ПараметрыЗаполнения) Экспорт
	
	СобытияФормВЕТИСРТКлиент.ПриИзмененииКоличестваВЕТИС(
		Форма,
		ТекущаяСтрока,
		КэшированныеЗначения,
		ПараметрыЗаполнения);
	
КонецПроцедуры

// Выполняет действия при изменении количества в таблице Товары.
//
// Параметры:
//  Форма                - ФормаКлиентскогоПриложения            - форма, в которой произошло событие,
//  ТекущаяСтрока        - ДанныеФормыЭлементКоллекции - строка таблицы товаров,
//  КэшированныеЗначения - Структура                   - сохраненные значения параметров, используемых при обработке строки таблицы,
//  ПараметрыЗаполнения  - Структура                   - см. функцию ИнтеграцияВЕТИСКлиентСервер.ПараметрыЗаполненияТабличнойЧасти.
Процедура ПриИзмененииКоличества(Форма, ТекущаяСтрока, КэшированныеЗначения, ПараметрыЗаполнения) Экспорт
	
	СобытияФормВЕТИСРТКлиент.ПриИзмененииКоличества(
		Форма,
		ТекущаяСтрока,
		КэшированныеЗначения,
		ПараметрыЗаполнения);
	
КонецПроцедуры

// Выполняет действия при начале выбора характеристики в таблице Товары.
//
// Параметры:
//  Форма                - ФормаКлиентскогоПриложения            - форма, в которой произошло событие,
//  ТекущаяСтрока        - ДанныеФормыЭлементКоллекции - строка таблицы товаров,
//  Элемент              - ПолеВвода                   - элемент формы Характеристика,
//  ДанныеВыбора         - СписокЗначений              - в обработчике можно сформировать и передать в этом параметре данные для выбора,
//  СтандартнаяОбработка - Булево                      - признак выполнения стандартной (системной) обработки события.
Процедура НачалоВыбораХарактеристики(Форма, ТекущаяСтрока, Элемент, ДанныеВыбора, СтандартнаяОбработка) Экспорт
	
	Возврат;
	
КонецПроцедуры

// Вызывает процедуру обработки выбора номенклатуры, если произошел выбор из формы выбора.
//
// Параметры:
//  ОповещениеПриЗавершении - ОписаниеОповещения - процедура завершения выбора номенклатуры,
//  ВыбранноеЗначение       - Произвольный       - результат выбора,
//  ИсточникВыбора          - ФормаКлиентскогоПриложения   - форма, в которой осуществлен выбор номенклатуры.
Процедура ОбработкаВыбораНоменклатуры(ОповещениеПриЗавершении, ВыбранноеЗначение, ИсточникВыбора) Экспорт
	
	СобытияФормВЕТИСРТКлиент.ОбработкаВыбораНоменклатуры(ОповещениеПриЗавершении, ВыбранноеЗначение, ИсточникВыбора);
	
КонецПроцедуры

// Вызывает процедуру обработки получения данных выбора номенклатуры, если произошло окончание ввода текста.
//
// Параметры:
//  ДанныеВыбора             - СписокЗначений - данные выбора номенклатуры, параметр события "ОкончаниеВводаТекста" поля формы,
//  ПараметрыПолученияДанных - Структура      - структура получения данных номенклатуры, параметр события "ОкончаниеВводаТекста" поля формы,
//  СтандартнаяОбработка     - Булево         - признак стандартной обработки выбора номенклатуры, параметр события "ОкончаниеВводаТекста" поля формы.
Процедура ОбработкаПолученияДанныхВыбораНоменклатуры(ДанныеВыбора, ПараметрыПолученияДанных, СтандартнаяОбработка) Экспорт
	
	
	Возврат;
	
КонецПроцедуры

// Вызывает процедуру обработки выбора серии, если произошел выбор из формы подбора.
//
// Параметры:
//  Форма                  - ФормаКлиентскогоПриложения - форма, в которой произошло событие,
//  ПараметрыУказанияСерий - Структура        - состав полей определен в функции НоменклатураКлиентСервер.ПараметрыУказанияСерий,
//  ВыбраннаяСерия         - ОпределяемыйТип.СерияНоменклатурыВЕТИС - обрабатываемое значение серии,
//  ИсточникВыбора         - ФормаКлиентскогоПриложения - форма, в которой осуществлен выбор,
//  ПараметрыЗаполнения    - Структура        - параметры обработки выбора серии.
Процедура ОбработкаВыбораСерии(Форма,
								ПараметрыУказанияСерий,
								ВыбраннаяСерия,
								ИсточникВыбора,
								ПараметрыЗаполнения = Неопределено) Экспорт
	
	
	Возврат;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти
