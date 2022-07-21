
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ДополнительныеКолонкиНоменклатуры = ЗначениеНастроекПовтИсп.ПолучитьЗначениеКонстанты("ДополнительнаяКолонкаПриОтображенииНоменклатуры");
	
	Если НЕ Параметры.Документ = Неопределено Тогда
		
		ТаблицаТоваров = ПолучитьИзВременногоХранилища(Параметры.АдресТоваровВХранилище);
		
		ОбновитьДеревоХарактеристик(ТаблицаТоваров);
		
	КонецЕсли;
		
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если Параметры.Документ = Неопределено Тогда
		Отказ = Истина;
		ПоказатьПредупреждение(,НСтр("ru='Обработка предназначена только для открытия из документа закупки'"));
		
	КонецЕсли;
    
    // &ЗамерПроизводительности
    ОценкаПроизводительностиРТКлиент.НачатьЗамер(
             Истина, "Обработка.РаспределениеТоваровПоХарактеристикам.Форма.Форма.Открытие");

КонецПроцедуры

&НаКлиенте
Процедура ОбработкаЗаписиНового(НовыйОбъект, Источник, СтандартнаяОбработка)
	
	Если ТипЗнч(НовыйОбъект) = Тип("СправочникСсылка.ХарактеристикиНоменклатуры") Тогда
		
		ДанныеХарактеристики = ПолучитьДанныеХарактеристики(НовыйОбъект);
		
		МассивЭлементов = Новый Массив;
		
		ЭлементыДереваТоваров = ДеревоТоваров.ПолучитьЭлементы();
		
		Для каждого ЭлементДереваТоваров Из ЭлементыДереваТоваров Цикл
			
			Если ТипЗнч(ДанныеХарактеристики.Владелец) = Тип("СправочникСсылка.ВидыНоменклатуры") Тогда
				
				Если ЭлементДереваТоваров.ВидНоменклатуры = ДанныеХарактеристики.Владелец Тогда
					
					МассивЭлементов.Добавить(ЭлементДереваТоваров);
					
				КонецЕсли;
				
			ИначеЕсли ЭлементДереваТоваров.Номенклатура = ДанныеХарактеристики.Владелец  Тогда// Владелец - номенклатура	
				
				МассивЭлементов.Добавить(ЭлементДереваТоваров);
				
			КонецЕсли;
			
		КонецЦикла;
		
		Для каждого ЭлементМассива Из МассивЭлементов Цикл
			
			КоллекцияЭлементов = ЭлементМассива.ПолучитьЭлементы();
			ТекущаяСтрока = КоллекцияЭлементов.Добавить();
			ЗаполнитьЗначенияСвойств(ТекущаяСтрока, ЭлементМассива, "Номенклатура, Цена, Упаковка, НомерСтроки");
			ТекущаяСтрока.Характеристика = НовыйОбъект;
			
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры

#Область ОбработчикиСобытийЭлементовТабличнойЧастиТовары

&НаКлиенте
Процедура ТоварыУпаковкаПриИзменении(Элемент)

	ТекущаяСтрока = Элементы.ДеревоТоваров.ТекущиеДанные;
	ПараметрыПересчета = ПересчитатьКоличествоНаСервере(ТекущаяСтрока.КоличествоУпаковок, ТекущаяСтрока.Упаковка);
			
	Родитель = ТекущаяСтрока.ПолучитьРодителя();
	
	Если Родитель <> Неопределено Тогда
		
		ТекущаяСтрока.Количество = ПараметрыПересчета.Количество;
		ТекущаяСтрока.Переносить = ТекущаяСтрока.Количество <> 0;
		
		ЭлементыУзла = Родитель.ПолучитьЭлементы();
				
		Если Родитель.КоличествоУпаковок <> 0 Тогда 
			
			Коэффициент = Родитель.Количество/Родитель.КоличествоУпаковок;
			
		ИначеЕсли Родитель.КоличествоУпаковокФакт <> 0 Тогда
			
			Коэффициент = Родитель.КоличествоФакт/Родитель.КоличествоУпаковокФакт;
		
		Иначе
			
			Коэффициент = 1;
			
		КонецЕсли;
		
		Родитель.Количество = 0;
		
		Для каждого ЭлементУзла Из ЭлементыУзла Цикл
			
			Если ЭлементУзла.Переносить Тогда
				
				Родитель.Количество = ЭлементУзла.Количество + Родитель.Количество;
				
			КонецЕсли;
			
		КонецЦикла;
		
		Родитель.Количество = ?((Родитель.КоличествоФакт - Родитель.Количество)>0,(Родитель.КоличествоФакт - Родитель.Количество), 0);
		Родитель.КоличествоУпаковок = Родитель.Количество/Коэффициент;
		Родитель.Переносить = Родитель.Количество <> 0;

	Иначе
		
		ТекущаяСтрока.КоличествоУпаковокФакт = ТекущаяСтрока.КоличествоФакт/ПараметрыПересчета.Коэффициент;
		ТекущаяСтрока.КоличествоУпаковок = ТекущаяСтрока.Количество/ПараметрыПересчета.Коэффициент;
		
	КонецЕсли;
		
КонецПроцедуры

&НаКлиенте
Процедура ТоварыУпаковкаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)

	ОбработкаТабличнойЧастиТоварыКлиент.ВыбратьУпаковкуНоменклатуры(ДанныеВыбора, СтандартнаяОбработка, Элементы.ДеревоТоваров.ТекущиеДанные);

КонецПроцедуры

&НаКлиенте
Процедура ТоварыКоличествоУпаковокПриИзменении(Элемент)

	ТекущаяСтрока = Элементы.ДеревоТоваров.ТекущиеДанные;
	
	СтруктураДействий = Новый Структура;
	СтруктураДействий.Вставить("ПересчитатьКоличествоЕдиниц");
	
	ОбработкаТабличнойЧастиТоварыКлиент.ПриИзмененииРеквизитовВТЧКлиент(
		Объект.Товары,
		ТекущаяСтрока,
		СтруктураДействий,
		Неопределено);
	
	ПараметрыПересчета = ПересчитатьКоличествоНаСервере(ТекущаяСтрока.КоличествоУпаковок, ТекущаяСтрока.Упаковка);
	ТекущаяСтрока.Количество = ПараметрыПересчета.Количество;
	ТекущаяСтрока.Переносить = ТекущаяСтрока.Количество <> 0;
	
	Родитель = ТекущаяСтрока.ПолучитьРодителя();
	
	Если Родитель <> Неопределено Тогда
		
		ЭлементыУзла = Родитель.ПолучитьЭлементы();
		
		Если Родитель.КоличествоУпаковок <> 0 Тогда 
			
			Коэффициент = Родитель.Количество/Родитель.КоличествоУпаковок;
			
		ИначеЕсли Родитель.КоличествоУпаковокФакт <> 0 Тогда
			
			Коэффициент = Родитель.КоличествоФакт/Родитель.КоличествоУпаковокФакт;
			
		Иначе
			
			Коэффициент = 1;
			
		КонецЕсли;
					
		Родитель.Количество = 0;
		
		Для каждого ЭлементУзла Из ЭлементыУзла Цикл
			
			Если ЭлементУзла.Переносить Тогда 
				
				Родитель.Количество = ЭлементУзла.Количество + Родитель.Количество;
				
			КонецЕсли;
			
		КонецЦикла;
		
		Родитель.Количество = ?((Родитель.КоличествоФакт - Родитель.Количество)>0,(Родитель.КоличествоФакт - Родитель.Количество), 0);
		Родитель.КоличествоУпаковок = Родитель.Количество/Коэффициент;
		Родитель.Переносить = Родитель.Количество <> 0;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТабличнойЧастиДеревоТоваров

&НаКлиенте
Процедура ДеревоТоваровПередНачаломИзменения(Элемент, Отказ)
	
	ТекущаяСтрока       = Элемент.ТекущиеДанные;
	ИмяТекущегоЭлемента = Элемент.ТекущийЭлемент.Имя;	
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПеренестиВДокумент(Команда)
		
	ДанныеВыполнения =	ПеренестиВДокументНаСервере();
	
	Если НЕ ДанныеВыполнения.Отказ Тогда
		
		ОповеститьОВыборе(ДанныеВыполнения);
				
	КонецЕсли;	
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьХарактеристику(Команда)

	Перем ВладелецХарактеристики;
	
	ТекущаяСтрока = Элементы.ДеревоТоваров.ТекущиеДанные;
	
	Если ТекущаяСтрока <> Неопределено Тогда
		
		ОбработкаТабличнойЧастиТоварыВызовСервера.ИспользованиеХарактеристикИВладелецДляВыбора(ТекущаяСтрока.Номенклатура,ВладелецХарактеристики);
		
		ЗначенияЗаполнения = Новый Структура;
		ЗначенияЗаполнения.Вставить("Владелец", ВладелецХарактеристики);
		ОткрытьФорму("Справочник.ХарактеристикиНоменклатуры.Форма.ФормаЭлемента", Новый Структура("ЗначенияЗаполнения", ЗначенияЗаполнения), ЭтаФорма, УникальныйИдентификатор);
		
	КонецЕсли;
		
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Процедура заполняет данные таблицы формы
// по данным ТЧ "Товары" документа "ПоступлениеТоваров".
&НаСервере
Процедура ОбновитьДеревоХарактеристик(ТаблицаТоваров)
	
	Запрос = Новый Запрос("ВЫБРАТЬ
	|	ВЫРАЗИТЬ(ТабличнаяЧасть.Номенклатура КАК Справочник.Номенклатура) КАК Номенклатура,
	|	ТабличнаяЧасть.Характеристика КАК Характеристика,
	|	ТабличнаяЧасть.Упаковка КАК Упаковка,
	|	ТабличнаяЧасть.КоличествоУпаковок КАК КоличествоУпаковок,
	|	ТабличнаяЧасть.Количество КАК Количество,
	|	ТабличнаяЧасть.Цена КАК Цена,
	|	ТабличнаяЧасть.НомерСтроки КАК НомерСтроки
	|ПОМЕСТИТЬ ТабличнаяЧасть
	|ИЗ
	|	&ТабличнаяЧасть КАК ТабличнаяЧасть
	|ГДЕ
	|	ТабличнаяЧасть.Характеристика = ЗНАЧЕНИЕ(Справочник.ХарактеристикиНоменклатуры.ПустаяСсылка)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТабличнаяЧасть.Номенклатура КАК Номенклатура,
	|	ТабличнаяЧасть.Характеристика КАК Характеристика,
	|	ТабличнаяЧасть.Упаковка КАК Упаковка,
	|	ТабличнаяЧасть.КоличествоУпаковок КАК КоличествоУпаковок,
	|	ТабличнаяЧасть.Количество КАК Количество,
	|	ТабличнаяЧасть.Цена КАК Цена,
	|	ТабличнаяЧасть.Номенклатура.ВидНоменклатуры КАК ВидНоменклатуры,
	|	ТабличнаяЧасть.Номенклатура.ВидНоменклатуры.ИспользованиеХарактеристик КАК ИспользованиеХарактеристик,
	|	ТабличнаяЧасть.НомерСтроки КАК НомерСтроки
	|ПОМЕСТИТЬ ТаблицаДокумента
	|ИЗ
	|	ТабличнаяЧасть КАК ТабличнаяЧасть
	|ГДЕ
	|	ТабличнаяЧасть.Номенклатура.ВидНоменклатуры.ИспользованиеХарактеристик <> ЗНАЧЕНИЕ(Перечисление.ВариантыВеденияДополнительныхДанныхПоНоменклатуре.НеИспользовать)
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Номенклатура,
	|	Характеристика
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВЫРАЗИТЬ(ТаблицаДокумента.Номенклатура КАК Справочник.Номенклатура) КАК Номенклатура,
	|	ТаблицаДокумента.Номенклатура.ВидНоменклатуры КАК ВидНоменклатуры,
	|	ТаблицаДокумента.Упаковка,
	|	ЕСТЬNULL(ХарактеристикиНоменклатуры.Ссылка, ЗНАЧЕНИЕ(Справочник.ХарактеристикиНоменклатуры.ПустаяСсылка)) КАК Характеристика,
	|	ТаблицаДокумента.Количество КАК КоличествоФакт,
	|	ТаблицаДокумента.КоличествоУпаковок КАК КоличествоУпаковокФакт,
	|	ТаблицаДокумента.Цена КАК Цена,
	|	ТаблицаДокумента.НомерСтроки КАК НомерСтроки
	|ИЗ
	|	ТаблицаДокумента КАК ТаблицаДокумента
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ХарактеристикиНоменклатуры КАК ХарактеристикиНоменклатуры
	|		ПО (ТаблицаДокумента.ИспользованиеХарактеристик = ЗНАЧЕНИЕ(Перечисление.ВариантыВеденияДополнительныхДанныхПоНоменклатуре.ИндивидуальныеДляНоменклатуры)
	|					И ХарактеристикиНоменклатуры.Владелец = ТаблицаДокумента.Номенклатура.Ссылка
	|				ИЛИ ТаблицаДокумента.ИспользованиеХарактеристик = ЗНАЧЕНИЕ(Перечисление.ВариантыВеденияДополнительныхДанныхПоНоменклатуре.ОбщиеДляВидаНоменклатуры)
	|					И ХарактеристикиНоменклатуры.Владелец = ТаблицаДокумента.Номенклатура.ВидНоменклатуры)
	|ИТОГИ ПО
	|   НомерСтроки,
	|	Номенклатура");
	
	Запрос.УстановитьПараметр("ТабличнаяЧасть", ТаблицаТоваров);
	
	ДеревоЗапроса = Запрос.Выполнить().Выгрузить(ОбходРезультатаЗапроса.ПоГруппировкам);
	
	ДеревоРеквизит = РеквизитФормыВЗначение("ДеревоТоваров");
			
	Для каждого СтрокаДереваЗапроса Из ДеревоЗапроса.Строки Цикл
		
		Для каждого ПодСтрокаЗапроса Из СтрокаДереваЗапроса.Строки Цикл
			
			СтрокаРеквизит = ДеревоРеквизит.Строки.Добавить();
			ЗаполнитьЗначенияСвойств(СтрокаРеквизит, СтрокаДереваЗапроса);
			СтрокаРеквизит.НомерСтроки        = СтрокаДереваЗапроса.НомерСтроки;
			
			Для каждого СтрокаХарактеристики Из ПодСтрокаЗапроса.Строки Цикл
				
				ПодСтрокаХарактеристики = СтрокаРеквизит.Строки.Добавить();
				ЗаполнитьЗначенияСвойств(ПодСтрокаХарактеристики, СтрокаХарактеристики, "Номенклатура, Характеристика, Цена, Упаковка, НомерСтроки, ВидНоменклатуры");
				ЗаполнитьЗначенияСвойств(СтрокаРеквизит,СтрокаХарактеристики,,"Характеристика");
				СтрокаРеквизит.Количество         = СтрокаХарактеристики.КоличествоФакт;
				СтрокаРеквизит.КоличествоУпаковок = СтрокаХарактеристики.КоличествоУпаковокФакт;
				
			КонецЦикла;
			
		КонецЦикла;
				
	КонецЦикла;
		
	ЗначениеВРеквизитФормы(ДеревоРеквизит, "ДеревоТоваров");
		
КонецПроцедуры

// Процедура выполняет пересчет поля "Количество" при изменении поля "КоличествоУпаковок".
// Аргументы:
//КоличествоУпаковок - Число
//Упаковка  - СправочникСсылка.Упаковки
// Возвращаемое значение:
//СтруктураПараметров - Структура
// Ключи:
//Количество - Число
//Коэффициент - Число
&НаСервере
Функция ПересчитатьКоличествоНаСервере(КоличествоУпаковок, Упаковка)
	
	Коэффициент = ?(ЗначениеЗаполнено(Упаковка), Упаковка.Коэффициент, 1);
	Количество  = КоличествоУпаковок*Коэффициент;
	
	СтруктураПараметров = Новый Структура("Количество, Коэффициент",Количество, Коэффициент);
	
	Возврат СтруктураПараметров;
	
КонецФункции

// Функция формирует таблицу значений по данным дерева "ДеревоТоваров",
// помещает сформированную таблицу во временное хранилище.
// Возвращаемое значение - Структура, 
// Отказ  - Булево - признак успешности проверки.
// АдресТоваровВХранилище - Строка - Адрес таблицы во временном хранилище.
&НаСервере
Функция ПеренестиВДокументНаСервере()
	
	Отказ = Ложь;
	
	ДанныеВыполнения = Новый Структура;
	
	ДеревоРеквизит = РеквизитФормыВЗначение("ДеревоТоваров");
	
	Для каждого СтрокаНоменклатура Из ДеревоРеквизит.Строки Цикл
				
		Если СтрокаНоменклатура.Переносить 
			И СтрокаНоменклатура.КоличествоФакт < (СтрокаНоменклатура.Количество + СтрокаНоменклатура.Строки.Итог("Количество")) Тогда
			
			ТекстОшибки = НСтр("ru = 'Для номенклатуры %1 количество товаров по документу меньше 
			|количества товаров, распределенных по характеристикам'");
			ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстОшибки, СтрокаНоменклатура.Номенклатура);
			
			ОбщегоНазначения.СообщитьПользователю(ТекстОшибки,,,,Отказ);
			
		ИначеЕсли СтрокаНоменклатура.КоличествоФакт < (СтрокаНоменклатура.Строки.Итог("Количество")) Тогда
			
			ТекстОшибки = НСтр("ru = 'Для номенклатуры %1 количество товаров по документу меньше 
			|количества товаров, распределенных по характеристикам'");
			ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстОшибки, СтрокаНоменклатура.Номенклатура);
			
			ОбщегоНазначения.СообщитьПользователю(ТекстОшибки,,,,Отказ);
			
		КонецЕсли;
				
		Для каждого СтрокаХарактеристика Из СтрокаНоменклатура.Строки Цикл
			
			Если СтрокаХарактеристика.Переносить Тогда
				
				Если СтрокаХарактеристика.Количество = 0 Тогда
					
					ТекстОшибки = НСтр("ru = 'Для номенклатуры %1 (%2) не указано количество'");
					ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстОшибки, СтрокаХарактеристика.Номенклатура, СтрокаХарактеристика.Характеристика);
					
					ОбщегоНазначения.СообщитьПользователю(ТекстОшибки,,,,Отказ);
					
				КонецЕсли;
				
				Если СтрокаХарактеристика.Количество > 0 
					И СтрокаХарактеристика.Цена = 0 Тогда
					
					ТекстОшибки = НСтр("ru = 'Для номенклатуры %1 (%2) не указана цена'");
					ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстОшибки, СтрокаХарактеристика.Номенклатура, СтрокаХарактеристика.Характеристика);
					
					ОбщегоНазначения.СообщитьПользователю(ТекстОшибки,,,,Отказ);
					
				КонецЕсли;
					
			КонецЕсли;
					
		КонецЦикла;
		
	КонецЦикла;
	
	Если НЕ Отказ Тогда
				
		ТаблицаТоваров = Новый ТаблицаЗначений;
		ТаблицаТоваров.Колонки.Добавить("Номенклатура");
		ТаблицаТоваров.Колонки.Добавить("Характеристика");
		ТаблицаТоваров.Колонки.Добавить("Количество");
		ТаблицаТоваров.Колонки.Добавить("КоличествоУпаковок");
		ТаблицаТоваров.Колонки.Добавить("Цена");
		ТаблицаТоваров.Колонки.Добавить("Упаковка");
		ТаблицаТоваров.Колонки.Добавить("НомерСтроки");
		ТаблицаТоваров.Колонки.Добавить("Удалить", Новый ОписаниеТипов("Булево"));
		
		Для каждого СтрокаНоменклатура Из ДеревоРеквизит.Строки Цикл
			
			Если СтрокаНоменклатура.Переносить Тогда
				
				СтрокаТоваров = ТаблицаТоваров.Добавить();
				ЗаполнитьЗначенияСвойств(СтрокаТоваров, СтрокаНоменклатура);
				
			Иначе
				
				Если СтрокаНоменклатура.Строки.Итог("Переносить") > 0 Тогда
					
					СтрокаТоваров = ТаблицаТоваров.Добавить();
					СтрокаТоваров.Удалить = Истина;
					СтрокаТоваров.НомерСтроки = СтрокаНоменклатура.НомерСтроки;
					
				КонецЕсли;
				
			КонецЕсли;
			
			Для каждого СтрокаХарактеристика Из СтрокаНоменклатура.Строки Цикл
				
				Если СтрокаХарактеристика.Переносить Тогда
					
					СтрокаТоваров = ТаблицаТоваров.Добавить();
					ЗаполнитьЗначенияСвойств(СтрокаТоваров, СтрокаХарактеристика);
					
				КонецЕсли;
				
			КонецЦикла;
			
		КонецЦикла;
		
		АдресТоваровВХранилище = ПоместитьВоВременноеХранилище(ТаблицаТоваров, УникальныйИдентификатор);
		ДанныеВыполнения.Вставить("АдресТоваровВХранилище", АдресТоваровВХранилище);
		
	КонецЕсли;
	
	ДанныеВыполнения.Вставить("Отказ", Отказ);
	
	Возврат ДанныеВыполнения;
	
КонецФункции

// Возвращает значения реквизитов характеристики.
//
// Параметры: 
//  Характеристика - СправочникСсылка.ХарактеристикиНоменклатуры
// Возвращаемое значение:
//  Структура - структура данных характеристики с параметрами:
//				*Владелец - СправочникСсылка.Номенклатура, СправочникСсылка.ВидыНоменклатуры
//
&НаСервере
Функция ПолучитьДанныеХарактеристики(Характеристика)
	
	ДанныеХарактеристики = Новый Структура("Владелец", Характеристика.Владелец);
	Возврат ДанныеХарактеристики;
		
КонецФункции

#КонецОбласти
