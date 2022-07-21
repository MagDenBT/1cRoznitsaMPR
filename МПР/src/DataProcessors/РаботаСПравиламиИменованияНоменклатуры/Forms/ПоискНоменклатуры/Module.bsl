#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("Магазин") Тогда
		Магазин = Параметры.Магазин;
	КонецЕсли;
	
	Если Параметры.Свойство("РежимПодбораВЗакупки") Тогда
		РежимПодбораВЗакупки = Истина;
		Контрагент = Параметры.Контрагент;
		СсылкаНаПоступление = Параметры.СсылкаНаПоступление;
		Элементы.ОстаткиТоваровЦена.Видимость = Ложь;
	КонецЕсли;

	УстановитьПараметрыВыбораВидаНоменклатуры();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ВидНоменклатурыПриИзменении(Элемент)
	
	ВидНоменклатурыПриИзмененииСервер();
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПараметрИменованияПриИзменении(Элемент)
	
	МассивПараметров = ПараметрыПравилаИменования.НайтиСтроки(Новый Структура("ИмяЭлемента", Элемент.Имя));
	Если МассивПараметров.Количество() > 0 Тогда
		СтрокаПараметр = МассивПараметров[0];
		Если СтрокаПараметр.ПараметрОчищенПользователем Тогда
			СтрокаПараметр.ПараметрОчищенПользователем = Ложь;
			Возврат;
		КонецЕсли;
		ЗначениеПараметра = ЭтаФорма[СтрокаПараметр.ПутьКДанным];
		СписокВыбора = Элемент.СписокВыбора.ВыгрузитьЗначения();
		Если СписокВыбора.Найти(ЗначениеПараметра) <> Неопределено Тогда
			СтрокаПараметр.ИспользоватьВПоиске = Истина;
		Иначе
			СтрокаПараметр.ИспользоватьВПоиске = Ложь;
		КонецЕсли;
		ПоискНоменклатуры();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПараметрИменованияОчистка(Элемент)

	МассивПараметров = ПараметрыПравилаИменования.НайтиСтроки(Новый Структура("ИмяЭлемента", Элемент.Имя));
	Если МассивПараметров.Количество() > 0 Тогда
		СтрокаПараметр = МассивПараметров[0];
		СтрокаПараметр.ИспользоватьВПоиске = Ложь;
		СтрокаПараметр.ПараметрОчищенПользователем = Истина;
		ПоискНоменклатуры();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыТаблицаНоменклатуры

&НаКлиенте
Процедура ТаблицаНоменклатурыВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ДанныеСтроки = Элементы.ТаблицаНоменклатуры.ДанныеСтроки(ВыбраннаяСтрока);
	
	Если ХарактеристикиИспользуются Тогда
		ПерейтиКТаблицеХарактеристик(ДанныеСтроки.Номенклатура);
	Иначе
		ПеренестиВыбранныеДанныеВДокумент(ДанныеСтроки.Номенклатура);
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ТаблицаНоменклатурыПриАктивизацииСтроки(Элемент)
	
	ОстаткиТоваров.Очистить();

	ТекДанные = Элементы.ТаблицаНоменклатуры.ТекущиеДанные;
	Если ТекДанные <> Неопределено Тогда
		ЗаполнитьОстаткиИЦены(ТекДанные.Номенклатура);
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыТаблицаХарактеристик

&НаКлиенте
Процедура ТаблицаХарактеристикВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ДанныеСтроки = Элементы.ТаблицаХарактеристик.ДанныеСтроки(ВыбраннаяСтрока);
	ПеренестиВыбранныеДанныеВДокумент(ТекущаяНоменклатура, ДанныеСтроки.Характеристика);
	
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаХарактеристикПриАктивизацииСтроки(Элемент)
	
	ОстаткиТоваров.Очистить();
	
	ТекДанные = Элементы.ТаблицаХарактеристик.ТекущиеДанные;
	Если ТекДанные <> Неопределено Тогда
		ЗаполнитьОстаткиИЦены(ТекущаяНоменклатура, ТекДанные.Характеристика);
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПерейтиКСпискуХарактеристик(Команда)
	
	ДанныеСтроки = Элементы.ТаблицаНоменклатуры.ТекущиеДанные;
	Если ДанныеСтроки <> Неопределено Тогда
		ПерейтиКТаблицеХарактеристик(ДанныеСтроки.Номенклатура);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПерейтиКСпискуНоменклатуры(Команда)
	
	Элементы.ГруппаТаблицаНоменклатуры.Видимость	= Истина;
	Элементы.ГруппаТаблицаХарактеристик.Видимость	= Ложь;
	Элементы.ГруппаНайденныеПозиции.Заголовок		= Нстр("ru='Найдено позиций:'") + " " + ТаблицаНоменклатуры.Количество();
	Элементы.ЦенаЗакупки.Видимость 					= Ложь;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьПараметрыВыбораВидаНоменклатуры()
	
	РаботаСПравиламиИменования.УстановитьПараметрыВыбораВидаНоменклатуры(Элементы.ВидНоменклатуры);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьПараметрыИменования()
	
	УдалитьРеквизитыИЭлементыПравилаИменования();
	ЗаполнитьТаблицуПараметровПравилаИменования();
	
КонецПроцедуры

&НаСервере
Процедура УдалитьРеквизитыИЭлементыПравилаИменования()
	
	МассивУдаляемыхРеквизитов = Новый Массив;
	
	Для Каждого Строка Из ПараметрыПравилаИменования Цикл
		
		МассивУдаляемыхРеквизитов.Добавить(Строка.ПутьКДанным);
		
		УдаляемыйЭлемент = Элементы.Найти(Строка.ИмяЭлемента);
		Если УдаляемыйЭлемент <> Неопределено Тогда
			ЭтаФорма.Элементы.Удалить(УдаляемыйЭлемент);
		КонецЕсли;
		
	КонецЦикла;
	
	ЭтаФорма.ИзменитьРеквизиты(, МассивУдаляемыхРеквизитов);

КонецПроцедуры

&НаСервере
Процедура ЗаполнитьТаблицуПараметровПравилаИменования()
	
	СтруктураПараметров = РаботаСПравиламиИменования.СтруктураПараметровПравилаИменования(ВидНоменклатуры,, Истина);

	ПараметрыПравилаИменования.Очистить();
	
	МассивПараметровПравила = Новый Массив;
	ТипСтрока = Тип("Строка");
	Для Каждого Строка Из СтруктураПараметров.ПараметрыПравилаИменования Цикл
		ЗаполнитьЗначенияСвойств(ПараметрыПравилаИменования.Добавить(), Строка);
		СписокТипов = Строка.ТипРеквизита.Типы();
		Если Не Строка.ТипРеквизита.СодержитТип(ТипСтрока) Тогда
			СписокТипов.Добавить(Тип("Строка"));
		КонецЕсли;
		МассивПараметровПравила.Добавить(
			Новый РеквизитФормы(Строка.ПутьКДанным, Новый ОписаниеТипов(СписокТипов),, Строка.ИмяПараметра));
	КонецЦикла;
	
	ЭтаФорма.ИзменитьРеквизиты(МассивПараметровПравила);
	
	РаботаСПравиламиИменования.ДобавитьЭлементыПравилаИменования(ЭтаФорма, Элементы.ГруппаПараметрыИменования);
	
	Для Каждого Строка Из ПараметрыПравилаИменования Цикл
		Элемент = Элементы[Строка.ИмяЭлемента];
		Элемент.АвтоОтметкаНезаполненного = Ложь;
		Элемент.КнопкаОчистки = Истина;
		Элемент.КнопкаОткрытия = Ложь;
		Элемент.КнопкаСоздания = Ложь;
		Элемент.КнопкаВыбора = Ложь;
		Элемент.УстановитьДействие("Очистка", "Подключаемый_ПараметрИменованияОчистка");
	КонецЦикла;

КонецПроцедуры

&НаСервере
Процедура ПоискНоменклатуры()
	
	ТаблицаНоменклатуры.Очистить();
	
	СтруктураПоискаНоменклатуры = РаботаСПравиламиИменования.СтруктураПоискаНоменклатуры(ЭтаФорма, Истина);
	СтруктураПоискаНоменклатуры.Вставить("ВидНоменклатуры", ВидНоменклатуры);
	Результат = РаботаСПравиламиИменования.ПоискНоменклатуры(СтруктураПоискаНоменклатуры);
	Выборка   = Результат.Выбрать();
	Пока Выборка.Следующий() Цикл
		ЗаполнитьЗначенияСвойств(ТаблицаНоменклатуры.Добавить(), Выборка);
	КонецЦикла;
	
	Элементы.ГруппаНайденныеПозиции.Заголовок = НСтр("ru='Найдено позиций:'") + " " + Выборка.Количество();
	
	ЗаполнитьСпискиВыбораПараметров();
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСпискиВыбораПараметров()
	
	Результат = РаботаСПравиламиИменования.СпискиВыбораПараметровПоиска(ЭтаФорма, ВидНоменклатуры);
	
	Сч = Результат.Количество() - ПараметрыПравилаИменования.Количество();
	Для Каждого СтрокаПараметр Из ПараметрыПравилаИменования Цикл
		Выборка = Результат[Сч].Выбрать();
		ЗначенияВыбора = Новый Массив;
		
		СписокВыбора = Элементы[СтрокаПараметр.ИмяЭлемента].СписокВыбора;
		СписокВыбора.Очистить();
		Пока Выборка.Следующий() Цикл
			Если ЗначениеЗаполнено(Выборка.ЗначениеПараметра) Тогда
				СписокВыбора.Добавить(Выборка.ЗначениеПараметра);
			Иначе
				СписокВыбора.Добавить(Выборка.ЗначениеПараметра, НСтр("ru='<Пустое значение>'"));
			КонецЕсли;
		КонецЦикла;
		
		СписокВыбора.СортироватьПоЗначению();
		Элементы[СтрокаПараметр.ИмяЭлемента].РежимВыбораИзСписка = Истина;
		
		Сч = Сч + 1;
		
		Если СтрокаПараметр.ИспользоватьВПоиске Тогда
			Элементы[СтрокаПараметр.ИмяЭлемента].ЦветФона = ЦветаСтиля.ФонУправляющегоПоля;
			Элементы[СтрокаПараметр.ИмяЭлемента].ЦветТекста = ЦветаСтиля.ЦветТекстаПоля;
		Иначе
			Элементы[СтрокаПараметр.ИмяЭлемента].ЦветФона = ЦветаСтиля.ЦветФонаФормы;
			Элементы[СтрокаПараметр.ИмяЭлемента].ЦветТекста = ЦветаСтиля.ЦветФонаПоля;
		КонецЕсли;
		
	КонецЦикла;

КонецПроцедуры

&НаСервере
Процедура ЗаполнитьОстаткиИЦены(Номенклатура,Характеристика = Неопределено)
	
	Если Характеристика = Неопределено Тогда
		Характеристика = Справочники.ХарактеристикиНоменклатуры.ПустаяСсылка();
	КонецЕсли;

	Если РежимПодбораВЗакупки Тогда
		СтруктураИнформацииОТоваре = ПодборТоваровВызовСервера.ЦенаЗакупки(
			Номенклатура, Характеристика, Магазин, Контрагент, СсылкаНаПоступление);
		Цена = СтруктураИнформацииОТоваре.Цена.Цена;
		Если Цена = 0 Тогда
			ЦенаЗакупки = НСтр("ru='Не назначена'");
		Иначе
			ЦенаЗакупки = Цена;
		КонецЕсли;
	КонецЕсли;

	РаботаСПравиламиИменования.ЗаполнитьОстаткиИЦены(
		ОстаткиТоваров, Номенклатура, Характеристика, Магазин, РежимПодбораВЗакупки);
	
КонецПроцедуры

&НаСервере
Процедура ВидНоменклатурыПриИзмененииСервер()
	
	ЗаполнитьПараметрыИменования();
	Если ЗначениеЗаполнено(ВидНоменклатуры) Тогда
		Элементы.ВидНоменклатуры.ЦветФона = ЦветаСтиля.ФонУправляющегоПоля;
		ПоискНоменклатуры();
	Иначе
		Элементы.ВидНоменклатуры.ЦветФона = ЦветаСтиля.ЦветФонаФормы;
		Элементы.ГруппаНайденныеПозиции.Заголовок = "";
		ТаблицаНоменклатуры.Очистить();
	КонецЕсли;

	ИндивидуальныеХарактеристики =
		Перечисления.ВариантыВеденияДополнительныхДанныхПоНоменклатуре.ИндивидуальныеДляНоменклатуры;
	ОбщиеХарактеристики = Перечисления.ВариантыВеденияДополнительныхДанныхПоНоменклатуре.ОбщиеДляВидаНоменклатуры;
	
	ХарактеристикиИспользуются = (ВидНоменклатуры.ИспользованиеХарактеристик = ИндивидуальныеХарактеристики
			ИЛИ ВидНоменклатуры.ИспользованиеХарактеристик = ОбщиеХарактеристики);
	
	Элементы.ПерейтиКСпискуХарактеристик.Видимость = ХарактеристикиИспользуются;
	
	Элементы.ЦенаЗакупки.Видимость = РежимПодбораВЗакупки И Не ХарактеристикиИспользуются;
	
	Элементы.ГруппаТаблицаНоменклатуры.Видимость	= Истина;
	Элементы.ГруппаТаблицаХарактеристик.Видимость	= Ложь;
	
КонецПроцедуры

&НаКлиенте
Процедура ПерейтиКТаблицеХарактеристик(ВыбраннаяНоменклатура)
	
	Если ТекущаяНоменклатура <> ВыбраннаяНоменклатура Тогда
		ТекущаяНоменклатура = ВыбраннаяНоменклатура;
		ЗаполнитьТаблицуХарактеристик();
	КонецЕсли;
	Элементы.ГруппаТаблицаНоменклатуры.Видимость	= Ложь;
	Элементы.ГруппаТаблицаХарактеристик.Видимость	= Истина;
	Элементы.ГруппаНайденныеПозиции.Заголовок		= ТекущаяНоменклатура;
	Элементы.ЦенаЗакупки.Видимость 					= РежимПодбораВЗакупки;

КонецПроцедуры

&НаСервере
Процедура ЗаполнитьТаблицуХарактеристик()
	
	РаботаСПравиламиИменования.ЗаполнитьТаблицуХарактеристикНоменклатуры(ТаблицаХарактеристик, ТекущаяНоменклатура);
	
КонецПроцедуры

&НаКлиенте
Процедура ПеренестиВыбранныеДанныеВДокумент(Номенклатура, Характеристика = Неопределено)
	
	СтруктураПараметров = ПодключаемоеОборудованиеРТКлиент.СтруктураДанныхПоиска();
	
	ПараметрыСтроки = Новый Структура;
	ПараметрыСтроки.Вставить("Номенклатура",				Номенклатура);
	ПараметрыСтроки.Вставить("Характеристика",				Характеристика);
	ПараметрыСтроки.Вставить("ХарактеристикиИспользуются",	Характеристика <> Неопределено);
	ПараметрыСтроки.Вставить("Упаковка",					ПредопределенноеЗначение("Справочник.УпаковкиНоменклатуры.ПустаяСсылка"));
	ПараметрыСтроки.Вставить("Количество",					1);
	ПараметрыСтроки.Вставить("КоличествоУпаковок",			1);
	
	СтруктураПараметров.ЗначенияПоиска.Добавить(ПараметрыСтроки);
	
	Закрыть(СтруктураПараметров);

КонецПроцедуры

#КонецОбласти

