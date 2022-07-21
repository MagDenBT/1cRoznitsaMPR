
#Область ПрограммныйИнтерфейс

&НаКлиенте
Процедура ОповещениеПоискаПоШтрихкоду(Штрихкод, ДополнительныеПараметры) Экспорт
	
	Если НЕ ПустаяСтрока(Штрихкод) Тогда
		ВвестиКодОдноразовойСкидкиЗавершение(Штрихкод, ДополнительныеПараметры);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОповещениеПоискаПоМагнитномуКоду(ТекКод, ДополнительныеПараметры) Экспорт
	
	Если НЕ ПустаяСтрока(ТекКод) Тогда
		ВвестиКодОдноразовойСкидкиЗавершение(ТекКод, ДополнительныеПараметры);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВвестиКодОдноразовойСкидкиЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если ЗначениеЗаполнено(Результат) Тогда
		Если СписокОдноразовыхКодов.НайтиПоЗначению(Результат) = Неопределено Тогда
			РезультатПоиска = НайтиСкидку(Результат);
			Если ЗначениеЗаполнено(РезультатПоиска.ТекстСообщения) Тогда
				ОбщегоНазначенияРТКлиент.ВывестиИнформациюДляРМКУправляемой(НСтр("ru = 'Розница'"), РезультатПоиска.ТекстСообщения);
			Иначе
				СписокОдноразовыхКодов.Добавить(Результат);
				ТекстОповещения = НСтр("ru = 'Код успешно активирован'");
				ПоказатьОповещениеПользователя(ТекстОповещения, , Результат);
			КонецЕсли;
		Иначе
			ТекстСообщения = НСтр("ru = 'Код %1 уже был введен'");
			ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстСообщения, Результат);
			ОбщегоНазначенияРТКлиент.ВывестиИнформациюДляРМКУправляемой(НСтр("ru = 'Розница'"), ТекстСообщения);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПодключитьОборудованиеЗавершение(РезультатВыполнения, Параметры) Экспорт
	
	Если НЕ РезультатВыполнения.Результат Тогда
		ЗаголовокИнформации = НСтр("ru = 'При подключении оборудования произошла ошибка:'");
		ТекстИнформации     = РезультатВыполнения.ОписаниеОшибки;
		ОбщегоНазначенияРТКлиент.ВывестиИнформациюДляРМКУправляемой(ЗаголовокИнформации, ТекстИнформации);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Если Параметры.Свойство("МассивУправляемыеСкидкиДокумента") Тогда
		ЗаполнитьСписокВыбора(Параметры);
		
		Если Параметры.Свойство("НадписьПустогоСписка") Тогда
			Элементы.ДекорацияСписокПуст.Заголовок = Параметры.НадписьПустогоСписка;
		КонецЕсли;
		
		Если Список.Количество() = 0 Тогда
			Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.ГруппаСписокПуст;
		КонецЕсли;
		
	Иначе
		Отказ = Истина;
	КонецЕсли;
	
	Если Параметры.Свойство("СписокОдноразовыхКодов") Тогда
		СписокОдноразовыхКодов.ЗагрузитьЗначения(Параметры.СписокОдноразовыхКодов);
		Для Каждого КодСкидки Из СписокОдноразовыхКодов Цикл
			РезультатПоиска = НайтиСкидку(КодСкидки.Значение);
		КонецЦикла;
	КонецЕсли;
	
	Параметры.Свойство("Магазин", Магазин);
	
	ИспользоватьПодключаемоеОборудование = ЗначениеНастроекВызовСервера.ИспользоватьПодключаемоеОборудование();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// ПодключаемоеОборудование
	ПоддерживаемыеТипыПО = Новый Массив;
	ПоддерживаемыеТипыПО.Добавить("СканерШтрихкода");
	ПоддерживаемыеТипыПО.Добавить("СчитывательМагнитныхКарт");
	ОповещенияПриПодключении = Новый ОписаниеОповещения("ПодключитьОборудованиеЗавершение", ЭтотОбъект);
	МенеджерОборудованияКлиент.НачатьПодключениеОборудованиеПоТипу(ОповещенияПриПодключении, ЭтотОбъект, ПоддерживаемыеТипыПО);
	// Конец ПодключаемоеОборудование
	
КонецПроцедуры

&НаКлиенте
Процедура ВнешнееСобытие(Источник, Событие, Данные)
	
	Если ВводДоступен() Тогда
		ПодключаемоеОборудованиеРТКлиент.ВнешнееСобытиеОборудованияРМК(ЭтотОбъект, Источник, Событие, Данные);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	
	// ПодключаемоеОборудование
	МенеджерОборудованияКлиент.НачатьОтключениеОборудованиеПриЗакрытииФормы(Неопределено, ЭтотОбъект);
	// Конец ПодключаемоеОборудование
	
КонецПроцедуры

&НаКлиенте
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ТекущиеДанные = Элементы.Список.ТекущиеДанные;
	
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ТекущиеДанные.Выбран = НЕ ТекущиеДанные.Выбран;
	
	ПередвинутьПозицию(1);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КомандаВниз(Команда)
	
	ПередвинутьПозицию(1)
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаВверх(Команда)
	
	ПередвинутьПозицию(-1)
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаВыбрать(Команда)
	
	ЗафиксироватьВыбор();
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаУстановитьФлажки(Команда)
	
	Для каждого СтрокаСписка Из Список Цикл
		СтрокаСписка.Выбран = Истина;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаСнятьФлажки(Команда)
	
	Для Каждого СтрокаСписка Из Список Цикл
		СтрокаСписка.Выбран = Ложь;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ДекорацияСписокПустНажатие(Элемент)
	
	Закрыть();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Передвинуть позицию в списке.
//
// Параметры:
// Движение = 1 (вниз) или -1 (вверх).
// 
&НаКлиенте
Процедура ПередвинутьПозицию(Движение)
	// Вставить содержимое обработчика.
	Если Список.Количество() < 2 Тогда
		Возврат;
	КонецЕсли;
	
	ТекущиеДанные = Элементы.Список.ТекущиеДанные;
	
	Если ТекущиеДанные = Неопределено  Тогда
		ИндексСтроки = 0;
	Иначе
		ИндексСтроки = Список.Индекс(ТекущиеДанные);
	КонецЕсли;
	
	ИндексСтроки = ИндексСтроки + Движение;
	
	Если ИндексСтроки > (Список.Количество() - 1) Тогда
		ИндексСтроки = 0;
	ИначеЕсли ИндексСтроки < 0 Тогда
		ИндексСтроки = Список.Количество() - 1;
	КонецЕсли;
	
	ТекущиеДанные = Список[ИндексСтроки];
	Элементы.Список.ТекущаяСтрока = ТекущиеДанные.ПолучитьИдентификатор();
	
КонецПроцедуры

&НаКлиенте
Процедура ЗафиксироватьВыбор()
	
	МассивУправляемыхСкидок = Новый Массив;
	
	Для каждого СтрокаСписка Из Список Цикл
		Если СтрокаСписка.Выбран Тогда
			МассивУправляемыхСкидок.Добавить(СтрокаСписка.СкидкаНаценка);
		КонецЕсли;
	КонецЦикла;
	
	СтруктураСтроки = Новый Структура;
	СтруктураСтроки.Вставить("МассивУправляемыхСкидок" , МассивУправляемыхСкидок);
	СтруктураСтроки.Вставить("СписокОдноразовыхКодов", СписокОдноразовыхКодов);
	Закрыть(СтруктураСтроки)
	
КонецПроцедуры

&НаСервере
Процедура ОтобразитьНадписьСегментИсключения(СведенияДокумента)
	
	Если ЗначениеЗаполнено(СведенияДокумента.СегментИсключаемойНоменклатуры) Тогда
		Запрос = Новый Запрос;
		Запрос.Текст = "ВЫБРАТЬ
		|	Товары.НомерСтроки КАК НомерСтроки,
		|	Товары.Номенклатура КАК Номенклатура,
		|	Товары.Характеристика КАК Характеристика
		|ПОМЕСТИТЬ втТовары
		|ИЗ
		|	&Товары КАК Товары
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	Товары.НомерСтроки КАК НомерСтроки
		|ИЗ
		|	втТовары КАК Товары
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.НоменклатураСегмента КАК НоменклатураСегмента
		|		ПО НоменклатураСегмента.Номенклатура = Товары.Номенклатура
		|			И НоменклатураСегмента.Характеристика = Товары.Характеристика
		|ГДЕ
		|	НоменклатураСегмента.Сегмент = &Сегмент
		|
		|УПОРЯДОЧИТЬ ПО
		|	НомерСтроки";
		Запрос.УстановитьПараметр("Сегмент", СведенияДокумента.СегментИсключаемойНоменклатуры);
		Запрос.УстановитьПараметр("Товары", СведенияДокумента.Товары.Выгрузить());
		Выборка = Запрос.Выполнить().Выбрать();
		Если Выборка.Количество() > 0 Тогда
			Элементы.ТекстОбИсключениях.Видимость = Истина;
			СтрокиСИсключениями = "";
			КоличествоСтрок = 0;
			Пока Выборка.Следующий() Цикл
				КоличествоСтрок = КоличествоСтрок + 1;
				Если КоличествоСтрок > 1 Тогда
					СтрокиСИсключениями = СтрокиСИсключениями + ", ";
				КонецЕсли;
				СтрокиСИсключениями = СтрокиСИсключениями + Выборка.НомерСтроки;
			КонецЦикла;
			Если КоличествоСтрок = 1 Тогда
				ТекстЗаголовка = НСтр("ru = 'В строке %1 содержится номенклатура, входящая в состав сегмента-исключения скидок.'")
					+ Символы.ПС + НСтр("ru = 'В этой строке автоматические и управляемые скидки рассчитываться не будут.'");
			Иначе
				ТекстЗаголовка = НСтр("ru = 'В строках %1 содержится номенклатура, входящая в состав сегмента-исключения скидок.'")
					+ Символы.ПС + НСтр("ru = 'В этих строках автоматические и управляемые скидки рассчитываться не будут.'");
			КонецЕсли;
			ТекстЗаголовка = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстЗаголовка, СтрокиСИсключениями);
			Элементы.ТекстОбИсключениях.Заголовок = ТекстЗаголовка;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ПолучитьТаблицуСкидокСВыполненнымиУсловиями(СтрокиДерева, ТаблицаРезультат)
	
	Для Каждого СтрокаДерева Из СтрокиДерева Цикл
		Если СтрокаДерева.ЭтоГруппа Тогда
			ПолучитьТаблицуСкидокСВыполненнымиУсловиями(СтрокаДерева.Строки, ТаблицаРезультат);
		Иначе
			ВсеУсловияВыполнены = Истина;
			Если НЕ СтрокаДерева.Безусловная Тогда
				Для Каждого СтрокаУсловие Из СтрокаДерева.СтруктураДополнительныхДанных.СтрокаУсловий.Строки Цикл
					Если НЕ СтрокаУсловие.Выполнено Тогда
						ВсеУсловияВыполнены = Ложь;
						Прервать;
					КонецЕсли;
				КонецЦикла;
			КонецЕсли;
			Если СтрокаДерева.Управляемая Тогда
				ТоварыПоСегментам = СтрокаДерева.СтруктураДополнительныхДанных.ТаблицаТоваровПоСегментам;
				СкидкаНаценка = СтрокаДерева.СкидкаНаценка;
				Если ТоварыПоСегментам.Найти(СкидкаНаценка.СегментНоменклатурыПредоставления, "Сегмент") = Неопределено Тогда 
					Продолжить;
				КонецЕсли;
				Если ВсеУсловияВыполнены Тогда
					НоваяСтрока = ТаблицаРезультат.Добавить();
					НоваяСтрока.Скидка = СтрокаДерева.СкидкаНаценка;
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
КонецФункции

&НаСервере
Процедура ЗаполнитьСписокВыбора(ПараметрыОткрытия)
	
	Запрос = Новый Запрос;
	
	ТекстЗапроса = "
	|ВЫБРАТЬ
	|	ТаблицаУправляемыеСкидкиДокумента.Ссылка КАК СкидкаНаценка
	|ПОМЕСТИТЬ ТаблицаВЗапросе
	|ИЗ
	|	Справочник.СкидкиНаценки КАК ТаблицаУправляемыеСкидкиДокумента
	|ГДЕ
	|	ТаблицаУправляемыеСкидкиДокумента.Ссылка В(&МассивУправляемыеСкидкиДокумента)
	|;
	|%ТаблицаСкидокСВыполненнымиУсловиями%
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ РАЗЛИЧНЫЕ
	|	ВложенныйЗапрос.СкидкаНаценка,
	|	ВложенныйЗапрос.Выбран
	|ИЗ
	|	(ВЫБРАТЬ РАЗЛИЧНЫЕ
	|		ДействиеСкидокНаценокСрезПоследних.СкидкаНаценка КАК СкидкаНаценка,
	|		ЛОЖЬ КАК Выбран
	|	ИЗ
	|		РегистрСведений.ДействиеСкидокНаценок.СрезПоследних(
	|				&ДатаСкидок,
	|				(ДатаОкончания = ДАТАВРЕМЯ(1, 1, 1, 0, 0, 0)
	|					ИЛИ КОНЕЦПЕРИОДА(ДатаОкончания, ДЕНЬ) >= &ДатаСкидок)
	|					И (Магазин = &Магазин
	|						ИЛИ Магазин = ЗНАЧЕНИЕ(Справочник.Магазины.ПустаяСсылка))
	|					И СкидкаНаценка.СтатусДействия = ЗНАЧЕНИЕ(Перечисление.СтатусыДействияСкидок.Действует)
	|					И СкидкаНаценка.СпособПредоставления <> ЗНАЧЕНИЕ(Перечисление.СпособыПредоставленияСкидокНаценок.ЗапретРозничнойПродажи)
	|					И СкидкаНаценка.Управляемая) КАК ДействиеСкидокНаценокСрезПоследних
	|	ГДЕ
	|		НЕ ДействиеСкидокНаценокСрезПоследних.СкидкаНаценка В
	|					(ВЫБРАТЬ
	|						ТаблицаВЗапросе.СкидкаНаценка
	|					ИЗ
	|						ТаблицаВЗапросе КАК ТаблицаВЗапросе)
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		ТаблицаВЗапросе.СкидкаНаценка,
	|		ИСТИНА
	|	ИЗ
	|		ТаблицаВЗапросе КАК ТаблицаВЗапросе) КАК ВложенныйЗапрос
	|%ТекстСоединенияВыполненныхУсловий%
	|УПОРЯДОЧИТЬ ПО
	|	ВложенныйЗапрос.Выбран УБЫВ";
	
	ТекстВыполненныхУсловий = "";
	ТекстСоединенияВыполненныхУсловий = "";
	
	Запрос.УстановитьПараметр("ДатаСкидок", ПараметрыОткрытия.Дата);
	Запрос.УстановитьПараметр("Магазин"   , ПараметрыОткрытия.Магазин);
	Запрос.УстановитьПараметр("МассивУправляемыеСкидкиДокумента", ПараметрыОткрытия.МассивУправляемыеСкидкиДокумента);
	Если ЗначениеЗаполнено(Параметры.АдресСкидокВХранилище) Тогда
		ПримененныеСкидки = ПолучитьИзВременногоХранилища(Параметры.АдресСкидокВХранилище);
		УдалитьИзВременногоХранилища(Параметры.АдресСкидокВХранилище);
		ТаблицаСкидокСВыполненнымиУсловиями = Новый ТаблицаЗначений;
		ТаблицаСкидокСВыполненнымиУсловиями.Колонки.Добавить("Скидка", Новый ОписаниеТипов("СправочникСсылка.СкидкиНаценки"));
		ПолучитьТаблицуСкидокСВыполненнымиУсловиями(ПримененныеСкидки.ДеревоСкидок.Строки, ТаблицаСкидокСВыполненнымиУсловиями);
		
		// Нужно обработать ПримененныеСкидки.ДеревоСкидок.Строки сформировав таблицу значений
		// выбрать из нее управляемые скидки
		// для которых выполнились условия
		// добавить соединение в текст запроса с этой таблицей.
		ТекстВыполненныхУсловий = "
		|ВЫБРАТЬ
		|	ТаблицаСкидокСВыполненнымиУсловиями.Скидка КАК Скидка
		|ПОМЕСТИТЬ ТаблицаСкидокСВыполненнымиУсловиями
		|ИЗ
		|	&ТаблицаСкидокСВыполненнымиУсловиями КАК ТаблицаСкидокСВыполненнымиУсловиями
		|;";
		ТекстСоединенияВыполненныхУсловий = "
		|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ ТаблицаСкидокСВыполненнымиУсловиями КАК ТаблицаСкидокСВыполненнымиУсловиями
		|	ПО ТаблицаСкидокСВыполненнымиУсловиями.Скидка = ВложенныйЗапрос.СкидкаНаценка
		|";
		
		Запрос.УстановитьПараметр("ТаблицаСкидокСВыполненнымиУсловиями", ТаблицаСкидокСВыполненнымиУсловиями);
		Если ПримененныеСкидки.Свойство("СведенияДокумента") Тогда
			ОтобразитьНадписьСегментИсключения(ПримененныеСкидки.СведенияДокумента);
		КонецЕсли;
		
	КонецЕсли;
	
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "%ТаблицаСкидокСВыполненнымиУсловиями%", ТекстВыполненныхУсловий);
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "%ТекстСоединенияВыполненныхУсловий%", ТекстСоединенияВыполненныхУсловий);
	
	Запрос.Текст = ТекстЗапроса;
	
	Результат = Запрос.Выполнить();
	
	Список.Загрузить(Результат.Выгрузить());
	
КонецПроцедуры

&НаКлиенте
Процедура ВвестиПромокод(Команда)
	
	ОповещениеВводаКода = Новый ОписаниеОповещения("ВвестиКодОдноразовойСкидкиЗавершение", ЭтотОбъект);
	ЗаголовокВвода = НСтр("ru = 'Введите одноразовый код скидки'");
	ПоказатьВводСтроки(ОповещениеВводаКода, , ЗаголовокВвода);
	
КонецПроцедуры

&НаСервере
Функция НайтиСкидку(КодСкидки)
	
	СтруктураРезультат = Новый Структура;
	СтруктураРезультат.Вставить("ТекстСообщения", "");
	ОднократнаяСкидка = Неопределено;
	ТаблицаСкидок = СкидкиНаценкиСерверПереопределяемый.СкидкиДляКупона(КодСкидки);
	Если ТаблицаСкидок.Количество() = 0 Тогда
		СтруктураРезультат.ТекстСообщения = НСтр("ru = 'Не найдено действующей скидки для кода %1'");
		СтруктураРезультат.ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(СтруктураРезультат.ТекстСообщения, КодСкидки);
	Иначе
		Для Каждого СтрокаСкидки Из ТаблицаСкидок Цикл
			Если ЗначениеЗаполнено(СтрокаСкидки.Скидка) Тогда
				СтруктураПоиска = Новый Структура;
				СтруктураПоиска.Вставить("СкидкаНаценка", СтрокаСкидки.Скидка);
				МассивСтрок = Список.НайтиСтроки(СтруктураПоиска);
				Если МассивСтрок.Количество() > 0 Тогда
					Для Каждого СтрокаСписка Из МассивСтрок Цикл
						СтрокаСписка.Выбран = Истина;
					КонецЦикла;
				Иначе
					СтрокаСписка = Список.Добавить();
					СтрокаСписка.СкидкаНаценка = СтрокаСкидки.Скидка;
					СтрокаСписка.Выбран = Истина;
				КонецЕсли;
				// Активизируем последнюю строку в любом случае.
				Если Элементы.ГруппаСтраницы.ТекущаяСтраница <> Элементы.ГруппаОбщая Тогда
					Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.ГруппаОбщая;
				КонецЕсли;
				Элементы.Список.ТекущаяСтрока = СтрокаСписка.ПолучитьИдентификатор();
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	Возврат СтруктураРезультат;
	
КонецФункции

#КонецОбласти