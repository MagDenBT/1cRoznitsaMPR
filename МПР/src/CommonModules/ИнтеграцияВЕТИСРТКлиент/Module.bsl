// Переопределяемые клиентские процедуры ВЕТИС

#Область ПрограммныйИнтерфейс

#Область ФормыДокументовОснований

//См. ИнтеграцияВЕТИСКлиентПереопределяемый.ОбработкаОповещенияВФормеДокументаОснования
// Вызывается при возникновении события ОбработкаОповещения в форме документа-основания.
// В данной процедуре можно переопределить стандартную обработку этого события механизмом ВЕТИС.
// Если процедура переопределена, то необходимо установить параметр СобытиеОбработано в значение Истина.
Процедура ОбработкаОповещенияВФормеДокументаОснования(Форма, Объект, ИмяСобытия,
			Параметр, Источник, СобытиеОбработано) Экспорт
	
	СобытиеОбработано = Ложь;
	ОписаниеСобытия = ИнтеграцияИСКлиентСервер.ПреобразоватьИмяСобытияОповещенияВоВнутреннийФормат(ИмяСобытия);
	
	// Проверим корректность имени события оповещения.
	Если ИнтеграцияИСКлиентСервер.ЭтоСобытиеОповещенияИзмененоСостояние(ОписаниеСобытия)
	 ИЛИ ИнтеграцияИСКлиентСервер.ЭтоСобытиеОповещенияВыполненОбмен(ОписаниеСобытия) Тогда
		
		СобытиеОбработано = Истина;
		
	ИначеЕсли ИнтеграцияИСКлиентСервер.ЭтоСобытиеОповещенияИзмененОбъект(ОписаниеСобытия) Тогда
		
		ИмяИзмененногоОбъекта = ИнтеграцияИСКлиентСервер.ИмяИзмененногоОбъектаИзВнутреннегоФорматаСобытияОповещения(ОписаниеСобытия);
		ЧастиИмениОбъекта 	  = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(ИмяИзмененногоОбъекта, ".");
		
		Если ЧастиИмениОбъекта.Количество() = 2 И ЧастиИмениОбъекта[0] = "Документ" Тогда
			
			ИменаДокументовВЕТИС = ИнтеграцияВЕТИСВызовСервера.ИменаДокументовДляДокументаОснования(Объект.Ссылка);
			СобытиеОбработано = ИменаДокументовВЕТИС.Свойство(ЧастиИмениОбъекта[1]);
			
		КонецЕсли;
		
	КонецЕсли;
	
	Если СобытиеОбработано Тогда
		
		// Проверим, что оповещение относится к объекту указанной формы.
		ОбязательныеПараметрыОповещения = Новый Структура("Основание");
		Если Параметр <> Неопределено Тогда
			ЗаполнитьЗначенияСвойств(ОбязательныеПараметрыОповещения, Параметр);
		КонецЕсли;
		
		Если Параметр = Неопределено ИЛИ ОбязательныеПараметрыОповещения.Основание = Объект.Ссылка Тогда
			
			ИнтеграцияИСКлиент.ОбновитьПолеИнтеграцииВФормеДокументаОснования(
				Форма,
				ИнтеграцияВЕТИСКлиентСервер.ИмяПодсистемы());
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

//См. ИнтеграцияВЕТИСКлиентПереопределяемый.ОбработкаНавигационнойСсылкиВФормеДокументаОснования
// Вызывается при возникновении события ОбработкаНавигационнойСсылки поля гиперссылки ВЕТИС в форме документа-основания.
// В данной процедуре можно переопределить стандартную обработку этого события механизмом ВЕТИС.
// Если процедура переопределена, то необходимо установить параметр СобытиеОбработано в значение Истина.
Процедура ОбработкаНавигационнойСсылкиВФормеДокументаОснования(Форма, Объект,
			Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка, СобытиеОбработано) Экспорт
	
	СтандартнаяОбработка = Ложь;
	
	Контекст = Новый Структура;
	Контекст.Вставить("Форма",  Форма);
	Контекст.Вставить("Объект", Объект);
	Контекст.Вставить("ДокументОснование", Объект.Ссылка);
	Контекст.Вставить("НавигационнаяСсылкаФорматированнойСтроки", НавигационнаяСсылкаФорматированнойСтроки);
	
	Если Форма.Модифицированность Тогда
		
		ОписаниеОповещенияВопрос = Новый ОписаниеОповещения(
			"ОбработкаНавигационнойСсылкиВФормеДокументаОснованияВЕТИСЗавершение",
			ЭтотОбъект,
			Контекст);
		
		ТекстВопроса = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Документ ""%1"" был изменен. Записать?'"),
			Контекст.ДокументОснование);
		
		ПоказатьВопрос(ОписаниеОповещенияВопрос, ТекстВопроса, РежимДиалогаВопрос.ДаНет);
		
	ИначеЕсли НЕ ЗначениеЗаполнено(Контекст.ДокументОснование) Тогда
		
		ОписаниеОповещенияВопрос = Новый ОписаниеОповещения(
			"ОбработкаНавигационнойСсылкиВФормеДокументаОснованияВЕТИСЗавершение",
			ЭтотОбъект,
			Контекст);
		
		ТекстВопроса = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Документ ""%1"" не записан. Записать?'"),
			Контекст.ДокументОснование);
		
		ПоказатьВопрос(ОписаниеОповещенияВопрос, ТекстВопроса, РежимДиалогаВопрос.ДаНет);
		
	Иначе
		
		ВыполнитьКомандуГиперссылкиВФормеДокументаОснованияВЕТИС(
			Контекст.ДокументОснование,
			НавигационнаяСсылкаФорматированнойСтроки,
			Форма);
			
		СобытиеОбработано = Истина;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область Прочие

//См. ИнтеграцияВЕТИСКлиентПереопределяемый.РазбитьСтрокуТабличнойЧасти
// Обработчик команды "Разбить строку".
//
// Параметры:
//  ТЧ - ДанныеФормыКоллекция - Табличная часть.
//  ЭлементФормы - ТаблицаФормы - Элемент формы.
//  ОповещениеПослеРазбиения - ОписаниеОповещения - Оповещение после разбиения строки ТЧ.
//  ПараметрыРазбиенияСтроки - (См. ОбщегоНазначенияУТКлиент.ПараметрыРазбиенияСтроки).
Процедура РазбитьСтрокуТабличнойЧасти(ТЧ, ЭлементФормы, ОповещениеПослеРазбиения = Неопределено, ПараметрыРазбиенияСтроки = Неопределено) Экспорт
	
	Если ПараметрыРазбиенияСтроки = Неопределено Тогда
		ПараметрыОбработки = ПараметрыРазбиенияСтроки();
	Иначе
		ПараметрыОбработки = ПараметрыРазбиенияСтроки;
	КонецЕсли;
	
	ТекущаяСтрока	= ЭлементФормы.ТекущиеДанные;
	ЧислоВведено = Истина;
	
	Если ТекущаяСтрока = Неопределено Тогда
		ТекстСообщения = НСтр("ru = 'Для выполнения команды требуется выбрать строку табличной части.'");
		ПоказатьПредупреждение(,ТекстСообщения);
		Если ОповещениеПослеРазбиения <> Неопределено Тогда
			ВыполнитьОбработкуОповещения(ОповещениеПослеРазбиения, Неопределено);
		КонецЕсли; 
		Возврат;
	ИначеЕсли ТекущаяСтрока[ПараметрыОбработки.ИмяПоляКоличество] = 0
		И Не ПараметрыОбработки.РазрешитьНулевоеКоличество Тогда
		ТекстСообщения = НСтр("ru = 'Невозможно разбить строку с нулевым количеством.'");
		ПоказатьПредупреждение(,ТекстСообщения);
		Если ОповещениеПослеРазбиения <> Неопределено Тогда
			ВыполнитьОбработкуОповещения(ОповещениеПослеРазбиения, Неопределено);
		КонецЕсли; 
		Возврат;
	КонецЕсли;
	
	Отказ = Ложь;
	
	Если Отказ Тогда
		Если ОповещениеПослеРазбиения <> Неопределено Тогда
			ВыполнитьОбработкуОповещения(ОповещениеПослеРазбиения, Неопределено);
		КонецЕсли; 
		Возврат;
	КонецЕсли;
	
	Если ТекущаяСтрока[ПараметрыОбработки.ИмяПоляКоличество] <> 0 Тогда
		
		Количество = ?(ТекущаяСтрока[ПараметрыОбработки.ИмяПоляКоличество] = 0, 0, Неопределено);
		
		Если Количество = Неопределено Тогда
			РазбитьСтрокуТЧВводЧисла(ТЧ, ЭлементФормы, ОповещениеПослеРазбиения, ПараметрыОбработки);
			Возврат;
			
		КонецЕсли;
	Иначе
		Количество = 0;
		
	КонецЕсли;
	
	РазбитьСтрокуТЧДобавлениеСтроки(ТЧ, ЭлементФормы, Количество, ОповещениеПослеРазбиения, ПараметрыОбработки);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти



#Область СлужебныеПроцедурыИФункции

#Область ФормыДокументовОснований

Процедура ОбработкаНавигационнойСсылкиВФормеДокументаОснованияВЕТИСЗавершение(РезультатВопроса, Контекст) Экспорт
	
	Если РезультатВопроса <> КодВозвратаДиалога.Да Тогда
		Возврат;
	КонецЕсли;
	
	Если Контекст.Объект.Проведен Тогда
		Если Контекст.Форма.ПроверитьЗаполнение() Тогда
			Контекст.Форма.Записать();
		КонецЕсли;
	Иначе
		Контекст.Форма.Записать();
	КонецЕсли;
	
	Если НЕ Контекст.Форма.Модифицированность И ЗначениеЗаполнено(Контекст.ДокументОснование) Тогда
		
		ВыполнитьКомандуГиперссылкиВФормеДокументаОснованияВЕТИС(
			Контекст.ДокументОснование,
			Контекст.НавигационнаяСсылкаФорматированнойСтроки,
			Контекст.Форма);
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ВыполнитьКомандуГиперссылкиВФормеДокументаОснованияВЕТИС(ДокументОснование, НавигационнаяСсылкаФорматированнойСтроки, Форма)
	
	ОписаниеКоманды = ИнтеграцияИСКлиентСервер.ПреобразоватьИмяКомандыНавигационнойСсылкиВоВнутреннийФормат(
		НавигационнаяСсылкаФорматированнойСтроки);
	
	// Открытие протокола обмена.
	Если ИнтеграцияИСКлиентСервер.ЭтоКомандаНавигационнойСсылкиОткрытьПротоколОбмена(ОписаниеКоманды) Тогда
		
		ОткрытьПротоколОбменаВЕТИС(ДокументОснование, Форма);
		
		Возврат;
		
	КонецЕсли;
	
	// Создание документа.
	Если ИнтеграцияИСКлиентСервер.ЭтоКомандаНавигационнойСсылкиСоздатьОбъект(ОписаниеКоманды) Тогда
		
		ИмяОбъектаДляСоздания = ИнтеграцияИСКлиентСервер.ИмяОбъектаДляОткрытияИзВнутреннегоФорматаКомандыНавигационнойСсылки(
			ОписаниеКоманды); // полное имя документа.
		
		ПараметрыФормы = Новый Структура("Основание", ДокументОснование);
		
		ОткрытьФорму(
			ИмяОбъектаДляСоздания + ".Форма.ФормаДокумента",
			ПараметрыФормы,
			Форма);
		
		Возврат;
		
	КонецЕсли;
	
	// Открытие документа.
	Если ИнтеграцияИСКлиентСервер.ЭтоКомандаНавигационнойСсылкиОткрытьОбъект(ОписаниеКоманды) Тогда
		
		ИмяОбъектаДляОткрытия = ИнтеграцияИСКлиентСервер.ИмяОбъектаДляОткрытияИзВнутреннегоФорматаКомандыНавигационнойСсылки(
			ОписаниеКоманды); // полное имя документа.
	
		ЧастиИмениОбъекта = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(ИмяОбъектаДляОткрытия, ".");
		
		ДокументыВЕТИС 	  = ИнтеграцияВЕТИСВызовСервера.ДокументыВЕТИСПоДокументуОснованию(ДокументОснование);
		МассивДокументов  = ДокументыВЕТИС[ЧастиИмениОбъекта[1]];
		
		Если МассивДокументов.Количество() = 1 Тогда
			ПоказатьЗначение(, МассивДокументов[0].Ссылка);
		КонецЕсли;
		
		Возврат;
		
	КонецЕсли;
	
	// Открытие произвольной навигационной ссылки.
	ПерейтиПоНавигационнойСсылке(НавигационнаяСсылкаФорматированнойСтроки);
	
КонецПроцедуры

Процедура ОткрытьПротоколОбменаВЕТИС(Документ, Владелец = Неопределено)
	
	ПараметрыФормы = Новый Структура("Документ", Документ);
	
	ОткрытьФорму(
		"Справочник.ВЕТИСПрисоединенныеФайлы.Форма.ФормаПротоколОбмена",
		ПараметрыФормы,
		Владелец,
		Новый УникальныйИдентификатор,
		,
		,
		,
		РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

Процедура РазбитьСтрокуТЧВводЧисла(ТЧ, ЭлементФормы, ОповещениеПослеРазбиения, ПараметрыОбработки) Экспорт
	
	ТекущаяСтрока	= ЭлементФормы.ТекущиеДанные;
	
	Если ПараметрыОбработки.Количество = Неопределено Тогда
		Количество = ТекущаяСтрока[ПараметрыОбработки.ИмяПоляКоличество];
	Иначе
		Количество = ПараметрыОбработки.Количество;
	КонецЕсли;
	
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("ТЧ",                       ТЧ);
	ДополнительныеПараметры.Вставить("ЭлементФормы",             ЭлементФормы);
	ДополнительныеПараметры.Вставить("ОповещениеПослеРазбиения", ОповещениеПослеРазбиения);
	ДополнительныеПараметры.Вставить("ПараметрыОбработки",       ПараметрыОбработки);
	
	Оповещение = Новый ОписаниеОповещения(
		"РазбитьСтрокуТЧПослеВводаЧисла", 
		ЭтотОбъект,
		ДополнительныеПараметры);
	ПоказатьВводЧисла(Оповещение, Количество, ПараметрыОбработки.Заголовок, 15, 3);

КонецПроцедуры

// Функция-конструктор дополнительных параметров разбиения строки.
//
// Возвращаемое значение:
// 		Структура:
//			*ИмяПоляКоличество - Строка - значение по умолчанию КоличествоУпаковок
//          *Заголовок - Строка - заголовок формы ввода числа, значение по умолчанию "Введите количество товара в новой строке"
//			*РазрешитьНулевоеКоличество - Булево - признак, что в исходной и конечной строке может быть 0, значение по умолчанию 0
//			*Количество - Неопределенно,Число - количество, которое будет отображено в форме редактирования числа. Если Неопределенно -
//					будет показано количество в текущей строке
//					
Функция ПараметрыРазбиенияСтроки() Экспорт
	
	ПараметрыРазбиенияСтроки = Новый Структура;
	ПараметрыРазбиенияСтроки.Вставить("ИмяПоляКоличество", "КоличествоУпаковок");
	ПараметрыРазбиенияСтроки.Вставить("Заголовок", НСтр("ru = 'Введите количество товара в новой строке'"));
	ПараметрыРазбиенияСтроки.Вставить("РазрешитьНулевоеКоличество", Истина);
	ПараметрыРазбиенияСтроки.Вставить("Количество", Неопределено);
	
	Возврат ПараметрыРазбиенияСтроки;
	
КонецФункции

Процедура РазбитьСтрокуТЧДобавлениеСтроки(ТЧ, ЭлементФормы, Количество, ОповещениеПослеРазбиения, ПараметрыОбработки) Экспорт
	
	ТекущаяСтрока	= ЭлементФормы.ТекущиеДанные;
	
	ИндексТекущейСтроки 	 = ТЧ.Индекс(ТекущаяСтрока);
	НоваяСтрока 			 = ТЧ.Вставить(ИндексТекущейСтроки + 1);
	ЗаполнитьЗначенияСвойств(НоваяСтрока, ТекущаяСтрока);
	
	НоваяСтрока[ПараметрыОбработки.ИмяПоляКоличество]   = Количество;
	ТекущаяСтрока[ПараметрыОбработки.ИмяПоляКоличество] = ТекущаяСтрока[ПараметрыОбработки.ИмяПоляКоличество]
		- НоваяСтрока[ПараметрыОбработки.ИмяПоляКоличество];
	
	Если ОповещениеПослеРазбиения <> Неопределено Тогда
		ВыполнитьОбработкуОповещения(ОповещениеПослеРазбиения, НоваяСтрока);
	КонецЕсли; 
	
	ЭлементФормы.ТекущаяСтрока  = НоваяСтрока.ПолучитьИдентификатор();
	
КонецПроцедуры

Процедура РазбитьСтрокуТЧПослеВводаЧисла(Количество, ДополнительныеПараметры) Экспорт
	
	ТЧ                       = ДополнительныеПараметры.ТЧ;
	ЭлементФормы             = ДополнительныеПараметры.ЭлементФормы;
	ОповещениеПослеРазбиения = ДополнительныеПараметры.ОповещениеПослеРазбиения;
	ПараметрыОбработки       = ДополнительныеПараметры.ПараметрыОбработки;
	
	ТекущаяСтрока            = ЭлементФормы.ТекущиеДанные;
	
	ЧислоВведено = Количество <> Неопределено;
	
	Если Не ЧислоВведено Тогда
		Если ОповещениеПослеРазбиения <> Неопределено Тогда
			ВыполнитьОбработкуОповещения(ОповещениеПослеРазбиения, Неопределено);
		КонецЕсли;
		Возврат;
	ИначеЕсли Количество = 0
		И Не ПараметрыОбработки.РазрешитьНулевоеКоличество Тогда
		ТекстСообщения = НСтр("ru = 'Количество в новой строке не может быть равно нулю.'");
		Оповещение = Новый ОписаниеОповещения("РазбитьСтрокуТЧПослеПредупреждения", ЭтотОбъект, ДополнительныеПараметры);
		ПоказатьПредупреждение(Оповещение,ТекстСообщения);
		Возврат;
	ИначеЕсли ТекущаяСтрока[ПараметрыОбработки.ИмяПоляКоличество] >= 0
		И Количество < 0 Тогда
		ТекстСообщения = НСтр("ru = 'Количество в новой строке не может быть отрицательным.'");
		Оповещение = Новый ОписаниеОповещения("РазбитьСтрокуТЧПослеПредупреждения", ЭтотОбъект, ДополнительныеПараметры);
		ПоказатьПредупреждение(Оповещение,ТекстСообщения);
		Возврат;
	ИначеЕсли ТекущаяСтрока[ПараметрыОбработки.ИмяПоляКоличество] <= 0
		И Количество > 0 Тогда
		ТекстСообщения = НСтр("ru = 'Количество в новой строке не может быть положительным.'");
		Оповещение = Новый ОписаниеОповещения("РазбитьСтрокуТЧПослеПредупреждения", ЭтотОбъект, ДополнительныеПараметры);
		ПоказатьПредупреждение(Оповещение,ТекстСообщения);
		Возврат;
	ИначеЕсли ТекущаяСтрока[ПараметрыОбработки.ИмяПоляКоличество] >= 0
		И Количество >  ТекущаяСтрока[ПараметрыОбработки.ИмяПоляКоличество] Тогда
		ТекстСообщения = НСтр("ru = 'Количество в новой строке не может быть больше количества в текущей.'");
		Оповещение = Новый ОписаниеОповещения("РазбитьСтрокуТЧПослеПредупреждения", ЭтотОбъект, ДополнительныеПараметры);
		ПоказатьПредупреждение(Оповещение,ТекстСообщения);
		Возврат;
	ИначеЕсли ТекущаяСтрока[ПараметрыОбработки.ИмяПоляКоличество] <= 0
		И Количество <  ТекущаяСтрока[ПараметрыОбработки.ИмяПоляКоличество] Тогда
		ТекстСообщения = НСтр("ru = 'Количество в новой строке не может быть меньше количества в текущей.'");
		Оповещение = Новый ОписаниеОповещения("РазбитьСтрокуТЧПослеПредупреждения", ЭтотОбъект, ДополнительныеПараметры);
		ПоказатьПредупреждение(Оповещение,ТекстСообщения);
		Возврат;
	ИначеЕсли Количество =  ТекущаяСтрока[ПараметрыОбработки.ИмяПоляКоличество]
		И Не ПараметрыОбработки.РазрешитьНулевоеКоличество Тогда
		ТекстСообщения = НСтр("ru = 'Количество в новой строке должно отличаться от количества в текущей.'");
		Оповещение = Новый ОписаниеОповещения("РазбитьСтрокуТЧПослеПредупреждения", ЭтотОбъект, ДополнительныеПараметры);
		ПоказатьПредупреждение(Оповещение,ТекстСообщения);
		Возврат;
	КонецЕсли;
	
	РазбитьСтрокуТЧДобавлениеСтроки(ТЧ, ЭлементФормы, Количество, ОповещениеПослеРазбиения, ПараметрыОбработки);
	
КонецПроцедуры

// Служебная процедура.
//
Процедура РазбитьСтрокуТЧПослеПредупреждения(ДополнительныеПараметры) Экспорт
	
	ТЧ                       = ДополнительныеПараметры.ТЧ;
	ЭлементФормы             = ДополнительныеПараметры.ЭлементФормы;
	ОповещениеПослеРазбиения = ДополнительныеПараметры.ОповещениеПослеРазбиения;
	ПараметрыОбработки       = ДополнительныеПараметры.ПараметрыОбработки;
	
	РазбитьСтрокуТЧВводЧисла(ТЧ, ЭлементФормы, ОповещениеПослеРазбиения, ПараметрыОбработки);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти



