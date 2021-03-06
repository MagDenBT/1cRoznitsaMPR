#Область ПрограммныйИнтерфейс

// Обработчик команды формы, требующей контекстного вызова сервера.
//
// Параметры:
//   Форма - ФормаКлиентскогоПриложения - форма, из которой выполняется команда.
//   ПараметрыВызова - Структура - параметры вызова.
//   Источник - ТаблицаФормы, ДанныеФормыСтруктура - объект или список формы с полем "Ссылка".
//   Результат - Структура - результат выполнения команды.
//
Процедура ВыполнитьПереопределяемуюКоманду(Знач Форма, Знач ПараметрыВызова, Знач Источник, Результат) Экспорт
	
	Если ПараметрыВызова.Свойство("ОтправитьРаспоряжениеНаПриемкуКладовщику") Тогда
		ИнтеграцияИСРТ.ОтправитьРаспоряжениеНаПриемкуКладовщику(Форма);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

#Область МодификацияФормы

Процедура ДобавитьСлужебныеРеквизиты(Форма, ПутьКТабличнойЧасти = "Объект.Товары") Экспорт
	
	СобытияФормЕГАИСРТ.ДобавитьСлужебныеРеквизиты(Форма, ПутьКТабличнойЧасти);
	
КонецПроцедуры

Процедура МодификацияРеквизитовФормы(Форма, ПараметрыИнтеграции, ДобавляемыеРеквизиты) Экспорт
	
	Возврат;
	
КонецПроцедуры

Процедура ЗаполнениеРеквизитовФормы(Форма) Экспорт
	
	ИнтеграцияЕГАИСРТ.ЗаполнениеРеквизитовФормы(Форма);
	
КонецПроцедуры

// Переопределение параметров интеграции ЕГАИС (расположения форматированной строки).
//
// Параметры:
//   Форма            - ФормаКлиентскогоПриложения - прикладная форма для встраивания форматированной строки.
//   ПараметрыНадписи - Структура        - (см. СобытияФормЕГАИС.ПараметрыИнтеграцииЕГАИС).
//
Процедура ПриОпределенииПараметровИнтеграцииЕГАИС(Форма, ПараметрыНадписи) Экспорт
	
	Возврат;
	
КонецПроцедуры

Процедура ПослеЗаписиНаСервере(Форма) Экспорт
	
	Возврат;
	
КонецПроцедуры

Процедура ПриСозданииНаСервере(Форма, Отказ, СтандартнаяОбработка) Экспорт
	
	СобытияФормЕГАИСРТ.ПриСозданииНаСервере(Форма, Отказ, СтандартнаяОбработка);
	
КонецПроцедуры

Процедура ПриЧтенииНаСервере(Форма, ТекущийОбъект) Экспорт
	
	СобытияФормЕГАИСРТ.ПриЧтенииНаСервере(Форма, ТекущийОбъект);
	
КонецПроцедуры

#Область СобытияЭлементовФорм

// Серверная переопределяемая процедура, вызываемая из обработчика события элемента.
//
// Параметры:
//   Форма                   - ФормаКлиентскогоПриложения - форма, из которой происходит вызов процедуры.
//   Элемент                 - Строка           - имя элемента-источника события "При изменении".
//   ДополнительныеПараметры - Структура        - значения дополнительных параметров влияющих на обработку.
//
Процедура ПриИзмененииЭлемента(Форма, Элемент, ДополнительныеПараметры) Экспорт
	
	СобытияФормЕГАИСРТ.ПриИзмененииЭлемента(Форма, Элемент, ДополнительныеПараметры);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

//Выполняет действия при изменении номенклатуры в таблице Товары.
//
//Параметры:
//   Форма         - ФормаКлиентскогоПриложения            - форма, в которой произошло событие.
//   ТекущаяСтрока - ДанныеФормыЭлементКоллекции - строка таблицы товаров.
//   КэшированныеЗначения - Структура - сохраненные значения параметров, используемых при обработке.
//   ПараметрыЗаполнения  - (См. ИнтеграцияЕГАИСКлиентСервер.ПараметрыЗаполненияТабличнойЧасти).
//   ПараметрыУказанияСерий - Произвольный - параметры указания серий формы.
//
Процедура ПриИзмененииНоменклатуры(Форма, ТекущаяСтрока, КэшированныеЗначения, ПараметрыЗаполнения, ПараметрыУказанияСерий = Неопределено) Экспорт
	
	Объект = Неопределено;
	Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(Форма, "Объект") Тогда
		Объект = Форма.Объект;
	КонецЕсли;
	
	Если НЕ Объект = Неопределено
		И ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(Форма, "Дата") И ЗначениеЗаполнено(Объект.Дата) Тогда
		ДатаЗаполнения = Объект.Дата;
	Иначе
		ДатаЗаполнения = ТекущаяДатаСеанса();
	КонецЕсли;
	
	СтруктураДействий = Новый Структура;
	СтруктураДействий.Вставить("ТекущаяСтрока", ТекущаяСтрока);
	СтруктураДействий.Вставить("ПроверитьХарактеристикуПоВладельцу", ТекущаяСтрока.Характеристика);
	
	СтруктураПараметров = Новый Структура;
	СтруктураПараметров.Вставить("Номенклатура", "Номенклатура");
	СтруктураПараметров.Вставить("ХарактеристикиИспользуются", "ХарактеристикиИспользуются");
	
	СтруктураДействий.Вставить("ЗаполнитьПризнакХарактеристикиИспользуются", СтруктураПараметров);
	
	Если ПараметрыЗаполнения.ОбработатьУпаковки Тогда
		СтруктураДействий.Вставить("ПроверитьЗаполнитьУпаковкуПоВладельцу", ТекущаяСтрока.Упаковка);
	КонецЕсли;
	
	Если ПараметрыЗаполнения.ПересчитатьКоличествоЕдиниц Тогда
		СтруктураДействий.Вставить("ПересчитатьКоличествоЕдиниц");
	КонецЕсли;
	
	Если ПараметрыЗаполнения.МаркируемаяПродукцияВТЧ Тогда
		СтруктураПараметров = Новый Структура;
		СтруктураПараметров.Вставить("Номенклатура", "Номенклатура");
		СтруктураПараметров.Вставить("МаркируемаяПродукция", "МаркируемаяПродукция");
		
		СтруктураДействий.Вставить("ЗаполнитьПризнакМаркируемаяАлкогольнаяПродукция", СтруктураПараметров);
	КонецЕсли;
	
	СтруктураДействий.Вставить("ЗаполнитьПризнакЕдиницаИзмерения", Новый Структура("Номенклатура", "ЕдиницаИзмерения"));
	СтруктураДействий.Вставить("ЗаполнитьПризнакТипНоменклатуры", Новый Структура("Номенклатура", "ТипНоменклатуры"));
	
	Если ПараметрыЗаполнения.ПерезаполнитьНоменклатуруЕГАИС Тогда
		ПараметрыЗаполненияНоменклатурыЕГАИС = Новый Структура;
		ПараметрыЗаполненияНоменклатурыЕГАИС.Вставить("ЗаполнитьФлагАлкогольнаяПродукция", Ложь);
		ПараметрыЗаполненияНоменклатурыЕГАИС.Вставить("ИмяКолонки", "АлкогольнаяПродукция");
		
		СтруктураДействий.Вставить("ЗаполнитьНоменклатуруЕГАИС", ПараметрыЗаполненияНоменклатурыЕГАИС);
	КонецЕсли;
	
	Если ПараметрыЗаполнения.ПересчитатьСумму Тогда
		Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(ТекущаяСтрока, "Цена") Тогда
			ВидЦенПоУмолчанию = Справочники.ВидыЦен.ВидЦеныПоУмолчанию(, Истина);
			Если ЗначениеЗаполнено(ВидЦенПоУмолчанию) Тогда
				ПараметрыЗаполненияЦены = Новый Структура;
				ПараметрыЗаполненияЦены.Вставить("Дата",    ДатаЗаполнения);
				ПараметрыЗаполненияЦены.Вставить("ВидЦены", ВидЦенПоУмолчанию);
				СтруктураДействий.Вставить("ЗаполнитьЦенуПоВидуЦен", ПараметрыЗаполненияЦены);
			КонецЕсли;
		КонецЕсли;
		
		СтруктураДействий.Вставить("ПересчитатьСумму");
	КонецЕсли;
	
	Если ПараметрыЗаполнения.ЗаполнитьИндексАкцизнойМарки Тогда
		СтруктураДействий.Вставить("ЗаполнитьИндексАкцизнойМарки");
	КонецЕсли;
	
	Если ПараметрыЗаполнения.ПроверитьСериюРассчитатьСтатус Тогда
		Если ПараметрыУказанияСерий <> Неопределено
			И ЗначениеЗаполнено(ПараметрыУказанияСерий.ИмяПоляСклад)
			И ОбщегоНазначенияРТКлиентСервер.ЕстьРеквизитОбъекта(Форма[ПараметрыУказанияСерий.ИмяИсточникаЗначенийВФормеОбъекта], ПараметрыУказанияСерий.ИмяПоляСклад) Тогда
			Склад = Форма[ПараметрыУказанияСерий.ИмяИсточникаЗначенийВФормеОбъекта][ПараметрыУказанияСерий.ИмяПоляСклад];
		Иначе
			Склад = Неопределено;
		КонецЕсли;
		
		СтруктураДействий.Вставить("ПроверитьСериюРассчитатьСтатус", Новый Структура("ПараметрыУказанияСерий, Склад", ПараметрыУказанияСерий, Склад));
	КонецЕсли;
	
	Если ПараметрыЗаполнения.ЗаполнитьАлкогольнуюПродукцию Тогда
		СтруктураДействий.Вставить("ЗаполнитьАлкогольнуюПродукцию", ПараметрыЗаполнения);
	КонецЕсли;
	
	СтруктураДействий.Вставить("НоменклатураПриИзмененииПереопределяемый", Новый Структура("ИмяФормы, ИмяТабличнойЧасти",
		Форма.ИмяФормы, "Товары"));
		
	
	ОбработкаТабличнойЧастиТоварыСервер.ПриИзмененииРеквизитовВТЧСервер(СтруктураДействий, СтруктураДействий, КэшированныеЗначения);
	
КонецПроцедуры

//Выполняет действия при изменении номенклатуры в таблице Товары.
//
//Параметры:
//   Форма                - ФормаКлиентскогоПриложения            - форма, в которой произошло событие.
//   ТекущаяСтрока        - ДанныеФормыЭлементКоллекции - строка таблицы товаров.
//   КэшированныеЗначения - Структура                   - сохраненные значения параметров, используемых при обработке.
//   ПараметрыЗаполнения  - (См. ИнтеграцияЕГАИСКлиентСервер.ПараметрыЗаполненияТабличнойЧасти).
//
Процедура ПриИзмененииХарактеристики(Форма, ТекущаяСтрока, КэшированныеЗначения, ПараметрыЗаполнения) Экспорт
	
	СтруктураДействий = Новый Структура;
	
	Если ПараметрыЗаполнения.ПерезаполнитьНоменклатуруЕГАИС Тогда
		ПараметрыЗаполненияНоменклатурыЕГАИС = Новый Структура;
		ПараметрыЗаполненияНоменклатурыЕГАИС.Вставить("ЗаполнитьФлагАлкогольнаяПродукция", Ложь);
		ПараметрыЗаполненияНоменклатурыЕГАИС.Вставить("ИмяКолонки", "АлкогольнаяПродукция");
		
		СтруктураДействий.Вставить("ЗаполнитьНоменклатуруЕГАИС", ПараметрыЗаполненияНоменклатурыЕГАИС);
	КонецЕсли;
	
	Если ПараметрыЗаполнения.ЗаполнитьАлкогольнуюПродукцию Тогда
		СтруктураДействий.Вставить("ЗаполнитьАлкогольнуюПродукцию", ПараметрыЗаполнения);
	КонецЕсли;
	
	СтруктураТЧ = Новый Структура;
	СтруктураТЧ.Вставить("СтрокиТЧ", Форма.Объект.Товары);
	ОбработкаТабличнойЧастиТоварыСервер.ПриИзмененииРеквизитовВТЧСервер(СтруктураТЧ, СтруктураДействий, КэшированныеЗначения);
	
КонецПроцедуры

//Выполняет действия при изменении количества упаковок в таблице Товары.
//
//Параметры:
//   Форма                - ФормаКлиентскогоПриложения - форма, в которой произошло событие.
//   ТекущаяСтрока        - ДанныеФормыЭлементКоллекции - строка таблицы товаров.
//   КэшированныеЗначения - Структура - сохраненные значения параметров, используемых при обработке.
//   ПараметрыЗаполнения  - (См. ИнтеграцияЕГАИСКлиентСервер.ПараметрыЗаполненияТабличнойЧасти).
//
Процедура ПриИзмененииКоличестваУпаковок(Форма, ТекущаяСтрока, КэшированныеЗначения, ПараметрыЗаполнения) Экспорт
	
	СтруктураДействий = Новый Структура;
	
	Если ПараметрыЗаполнения.ПересчитатьКоличествоЕдиниц Тогда
		СтруктураДействий.Вставить("ПересчитатьКоличествоЕдиниц");
	ИначеЕсли ПараметрыЗаполнения.ПересчитатьКоличествоУпаковок Тогда
		СтруктураДействий.Вставить("ПересчитатьКоличествоУпаковок");
	КонецЕсли;
	
	Если ПараметрыЗаполнения.ПересчитатьСумму Тогда
		СтруктураДействий.Вставить("ПересчитатьСумму");
	КонецЕсли;
	
	Если ПараметрыЗаполнения.ЗаполнитьИндексАкцизнойМарки Тогда
		СтруктураДействий.Вставить("ЗаполнитьИндексАкцизнойМарки");
	КонецЕсли;
	
	ОбработкаТабличнойЧастиТоварыСервер.ОбработатьСтрокуТЧСервер(ТекущаяСтрока, СтруктураДействий, КэшированныеЗначения);
	
КонецПроцедуры

#КонецОбласти

//Заполняет табличную часть Товары подобранными товарами.
//
//Параметры:
//   Форма               - ФормаКлиентскогоПриложения - форма, в которой производится подбор.
//   ВыбранноеЗначение   - Произвольный     - данные, содержащие подобранную пользователем номенклатуру.
//   ПараметрыЗаполнения - (См. ИнтеграцияЕГАИСКлиентСервер.ПараметрыЗаполненияТабличнойЧасти).
Процедура ОбработкаРезультатаПодбораНоменклатуры(Форма, ВыбранноеЗначение, ПараметрыЗаполнения) Экспорт
	
	ПараметрыЗаполнения.ЗаполнитьАлкогольнуюПродукцию      = Истина;
	
	ТаблицаТоваров = ПолучитьИзВременногоХранилища(ВыбранноеЗначение.АдресТоваровВХранилище);
	КэшированныеЗначения = ОбработкаТабличнойЧастиТоварыКлиентСервер.СтруктураКэшируемыхЗначений();
	
	ЕстьМарки = Форма.Объект.Свойство("АкцизныеМарки");
	ТекущаяСтрока = Неопределено;
	Для Каждого СтрокаТовара Из ТаблицаТоваров Цикл
		
		ТекущаяСтрока = Форма.Объект.Товары.Добавить();
		
		СписокСвойств = "Номенклатура, Характеристика, Упаковка";
		Если ТекущаяСтрока.Свойство("КоличествоУпаковок") Тогда
			СписокСвойств = СписокСвойств + ", КоличествоУпаковок";
		КонецЕсли;
		
		ЗаполнитьЗначенияСвойств(ТекущаяСтрока, СтрокаТовара, СписокСвойств);
		
		СобытияФормЕГАИСПереопределяемый.ПриИзмененииНоменклатуры(
			Форма, ТекущаяСтрока, КэшированныеЗначения,
			ПараметрыЗаполнения);
			
		Если ЕстьМарки Тогда
			АкцизныеМаркиЕГАИС.ЗаполнитьСлужебныеРеквизиты(Форма);
		КонецЕсли;
	
	КонецЦикла;
	
	Если ТекущаяСтрока <> Неопределено Тогда
		Форма.Элементы.Товары.ТекущаяСтрока = ТекущаяСтрока.ПолучитьИдентификатор();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
