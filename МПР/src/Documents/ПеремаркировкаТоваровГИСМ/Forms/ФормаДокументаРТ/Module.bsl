&НаКлиенте
Перем КэшированныеЗначения; //используется механизмом обработки изменения реквизитов ТЧ

&НаКлиенте
Перем ТекущиеДанныеИдентификатор; //используется для передачи текущей строки в обработчик ожидания

&НаКлиенте
Перем РедактируетсяСписываемаяСерия; //используется для определения, что форма подбора серий вызвана для списываемой серии

#Область ПрограммныйИнтерфейс

&НаСервере
//Возвращает параметры указания серий для товаров, указанных в документе
//
// Параметры:
//  Объект - Структура - структура значений реквизитов объекта, необходимых для заполнения параметров указания серий.
//
// Возвращаемое значение:
//  ПараметрыУказанияСерий - Структура - Состав полей задается в функции ОбработкаТабличнойЧастиКлиентСервер.ПараметрыУказанияСерий.
//
Функция ПараметрыУказанияСерий(Объект) Экспорт
	
	ПараметрыУказанияСерий = Новый Структура;
	
	ПараметрыУказанияСерий = МаркировкаТоваровГИСМРТ.ПараметрыУказанияСерий();
	ИспользоватьСерииНоменклатуры = ПолучитьФункциональнуюОпцию("ИспользоватьСерииНоменклатуры");
	
	ПараметрыУказанияСерий.Вставить("ИспользоватьСерииНоменклатуры", ИспользоватьСерииНоменклатуры);
	ПараметрыУказанияСерий.Вставить("ПолноеИмяОбъекта", "Документ.ПеремаркировкаТоваровГИСМ");
	ПараметрыУказанияСерий.Вставить("ИспользоватьСерииНоменклатуры", ИспользоватьСерииНоменклатуры);
	ПараметрыУказанияСерий.СкладскиеОперации.Добавить(Перечисления.СкладскиеОперации.МаркировкаПродукцииДляГИСМ);
	ПараметрыУказанияСерий.Вставить("Магазин", Объект.Магазин);
	
	ПараметрыУказанияСерий.ИмяТЧСерии = "Товары";
	
	ПараметрыУказанияСерий.ЭтоНакладная = Истина;
	ПараметрыУказанияСерий.ТолькоПросмотр = Ложь;
	ПараметрыУказанияСерий.Дата = Объект.Дата;
	
	ПараметрыУказанияСерий.Вставить("ИменаПолейСтатусУказанияСерий", Новый Структура);
	ПараметрыУказанияСерий.ИменаПолейСтатусУказанияСерий.Вставить("СтатусУказанияСерий");
	ПараметрыУказанияСерий.ИменаПолейСтатусУказанияСерий.Вставить("СтатусУказанияСерийСписываемаяСерия");
	
	ПараметрыУказанияСерий.ИменаПолейДополнительные.Добавить("GTIN");
	ПараметрыУказанияСерий.ИменаПолейДополнительные.Добавить("НоменклатураКиЗ");
	ПараметрыУказанияСерий.ИменаПолейДополнительные.Добавить("ХарактеристикаКиЗ");
	ПараметрыУказанияСерий.ИменаПолейДополнительные.Добавить("СписываемаяСерия");
	
	ПараметрыУказанияСерий.ОсобеннаяПроверкаСтатусовУказанияСерий = Истина;
	
	Возврат ПараметрыУказанияСерий;
КонецФункции

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформление();
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(Объект, ЭтотОбъект);
	
	Если Не ЗначениеЗаполнено(Объект.Ссылка) Тогда
		ПриЧтенииСозданииНаСервере();
		ПараметрыУказанияСерий = Новый ФиксированнаяСтруктура(ПараметрыУказанияСерий(Объект));
		ОбработкаТабличнойЧастиТоварыСервер.ЗаполнитьСтатусыУказанияСерий(Объект, ПараметрыУказанияСерий);
	КонецЕсли;
	
	ОбщегоНазначенияРТ.ЗаполнитьШапкуДокумента(Объект,КартинкаСостоянияДокумента,СостояниеДокумента,РазрешеноПроведение);
	
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов
	
	МассивКомандПО = Новый Массив;
	МассивКомандПО.Добавить("ТоварыЗагрузитьДанныеИзТСД");
	ПодключаемоеОборудованиеРТ.НастроитьПодключаемоеОборудование(ЭтаФорма, МассивКомандПО);
	
	СобытияФормИСПереопределяемый.УстановитьУсловноеОформлениеХарактеристикНоменклатуры(ЭтотОбъект);
	СобытияФормИСПереопределяемый.УстановитьУсловноеОформлениеХарактеристикНоменклатуры(ЭтотОбъект, "ТоварыХарактеристикаКиЗ");
	
	СобытияФормИСПереопределяемый.ПриСозданииНаСервере(ЭтотОбъект, Отказ, СтандартнаяОбработка);
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	// СтандартныеПодсистемы.УправлениеДоступом
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УправлениеДоступом") Тогда
		МодульУправлениеДоступом = ОбщегоНазначения.ОбщийМодуль("УправлениеДоступом");
		МодульУправлениеДоступом.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
	// Обработчик механизма "ДатыЗапретаИзменения"
	ДатыЗапретаИзменения.ОбъектПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);
	ПараметрыУказанияСерий =
		Новый ФиксированнаяСтруктура(МаркировкаТоваровГИСМРТ.ПараметрыУказанияСерийПеремаркировкаТоваров(Объект));
	ПриЧтенииСозданииНаСервере();
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	ДатыЗапретаИзменения.ОбъектПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	// СтандартныеПодсистемы.УправлениеДоступом
	УправлениеДоступом.ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи);
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
	МаркировкаТоваровГИСМРТ.ЗаполнитьСлужебныеРеквизитыТабличнойЧасти(Объект.Товары);
	
	ОбновитьСтатусГИСМ();
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	Оповестить("#ГИСМ#Запись_ПеремаркировкаТоваровГИСМ");
	
	ОбщегоНазначенияРТКлиент.ВыполнитьДействияПослеЗаписи(ЭтаФорма, Объект, ПараметрыЗаписи);
	ОбщегоНазначенияРТКлиентСервер.ОбновитьСостояниеДокумента(
		Объект,
		Элементы.КартинкаСостоянияДокумента.Подсказка,
		КартинкаСостоянияДокумента, РазрешеноПроведение);
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "#ГИСМ#ИзменениеСостоянияГИСМ"
		И Параметр.Ссылка = Объект.Ссылка Тогда
		
		ОбновитьСтатусГИСМ();
		
	КонецЕсли;
	
	Если ИмяСобытия = "#ГИСМ#ВыполненОбменГИСМ"
		И (Параметр = Неопределено
		Или (ТипЗнч(Параметр) = Тип("Структура") И Параметр.ОбновлятьСтатусВФормахДокументов)) Тогда
		
		ОбновитьСтатусГИСМ();
		
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// ПодключаемоеОборудование
	МенеджерОборудованияКлиент.НачатьПодключениеОборудованиеПриОткрытииФормы(Неопределено, ЭтотОбъект, "СканерШтрихкода");
	// Конец ПодключаемоеОборудование
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии()
	
	// ПодключаемоеОборудование
	МенеджерОборудованияКлиент.НачатьОтключениеОборудованиеПриЗакрытииФормы(Неопределено, ЭтотОбъект);
	// Конец ПодключаемоеОборудование
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	
	Если ИсточникВыбора.ИмяФормы = "Обработка.ПодборТоваров.Форма.Форма" Тогда
		
		ОбработкаВыбораПодборНаСервере(ВыбранноеЗначение);
		
	ИначеЕсли МаркировкаТоваровГИСМРТКлиент.ЭтоУказаниеСерий(ИсточникВыбора) Тогда
		
		ТекущиеДанные =
			Элементы[ПараметрыУказанияСерий.ИмяТЧТовары].ДанныеСтроки(ВыбранноеЗначение.ИдентификаторТекущейСтроки);
		
		МаркировкаТоваровГИСМРТКлиент.ОбработатьУказаниеСерии(ЭтаФорма, ПараметрыУказанияСерий, ВыбранноеЗначение);
		
		ТекущаяСтрока = Новый Структура;
		ТекущаяСтрока.Вставить("Серия", ТекущиеДанные.СписываемаяСерия);
		ТекущаяСтрока.Вставить("СтатусУказанияСерий", ТекущиеДанные.СтатусУказанияСерийСписываемаяСерия);
		ВыбранноеЗначение.Значение = ВыбранноеЗначение.ЗначениеСписываемойСерии;
		
		МаркировкаТоваровГИСМРТКлиент.ОбработатьУказаниеСерии(
			ЭтаФорма,
			ПараметрыУказанияСерий,
			ВыбранноеЗначение,
			ТекущаяСтрока);
		
		ТекущиеДанные.СписываемаяСерия = ТекущаяСтрока.Серия;
		ТекущиеДанные.СтатусУказанияСерийСписываемаяСерия = ТекущаяСтрока.СтатусУказанияСерий;
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапки

&НаКлиенте
Процедура СтатусГИСМОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если (Не ЗначениеЗаполнено(Объект.Ссылка)) Или (Не Объект.Проведен) Тогда
		
		ОписаниеОповещенияВопрос = Новый ОписаниеОповещения("СтатусГИСМОбработкаНавигационнойСсылкиЗавершение",
			ЭтотОбъект,
			Новый Структура("НавигационнаяСсылкаФорматированнойСтроки", НавигационнаяСсылкаФорматированнойСтроки));
		ТекстВопроса = НСтр("ru = 'Перемаркировка товаров ГИСМ не проведена. Провести?'");
		ПоказатьВопрос(ОписаниеОповещенияВопрос, ТекстВопроса, РежимДиалогаВопрос.ДаНет);
		
	ИначеЕсли Модифицированность Тогда
		
		ОписаниеОповещенияВопрос = Новый ОписаниеОповещения("СтатусГИСМОбработкаНавигационнойСсылкиЗавершение",
			ЭтотОбъект,
			Новый Структура("НавигационнаяСсылкаФорматированнойСтроки", НавигационнаяСсылкаФорматированнойСтроки));
		ТекстВопроса = НСтр("ru = 'Перемаркировка товаров ГИСМ была изменена. Провести?'");
		ПоказатьВопрос(ОписаниеОповещенияВопрос, ТекстВопроса, РежимДиалогаВопрос.ДаНет);
		
	Иначе
		
		ОбработатьНажатиеНавигационнойСсылки(НавигационнаяСсылкаФорматированнойСтроки);
		
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура СтатусГИСМОбработкаНавигационнойСсылкиЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	Если Не РезультатВопроса = КодВозвратаДиалога.Да Тогда
		Возврат;
	КонецЕсли;
	
	Если ПроверитьЗаполнение() Тогда
		Записать();
	КонецЕсли;
	
	Если Не Модифицированность И ЗначениеЗаполнено(Объект.Ссылка) Тогда
		ОбработатьНажатиеНавигационнойСсылки(ДополнительныеПараметры.НавигационнаяСсылкаФорматированнойСтроки);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ОбработатьНажатиеНавигационнойСсылки(НавигационнаяСсылкаФорматированнойСтроки)
	
	Если НавигационнаяСсылкаФорматированнойСтроки = "ПередатьДанные" Тогда
		
		ИнтеграцияГИСМКлиент.ПодготовитьСообщениеКПередаче(
			Объект.Ссылка,
			ПредопределенноеЗначение("Перечисление.ОперацииОбменаГИСМ.ПередачаДанныхСписаниеКиЗ"));
		
	ИначеЕсли НавигационнаяСсылкаФорматированнойСтроки = "ПередатьДанныеСписаниеКиЗ" Тогда
		
		ИнтеграцияГИСМКлиент.ПодготовитьСообщениеКПередаче(
			Объект.Ссылка,
			ПредопределенноеЗначение("Перечисление.ОперацииОбменаГИСМ.ПередачаДанныхСписаниеКиЗ"));
		
	ИначеЕсли НавигационнаяСсылкаФорматированнойСтроки = "ПередатьДанныеМаркировкаТоваров" Тогда
		
		ИнтеграцияГИСМКлиент.ПодготовитьСообщениеКПередаче(
			Объект.Ссылка,
			ПредопределенноеЗначение("Перечисление.ОперацииОбменаГИСМ.ПередачаДанныхМаркировкаТоваров"));
		
	ИначеЕсли НавигационнаяСсылкаФорматированнойСтроки = "ПередатьДанныеПеремаркировкаТоваров" Тогда
		
		ИнтеграцияГИСМКлиент.ПодготовитьСообщениеКПередаче(
			Объект.Ссылка,
			ПредопределенноеЗначение("Перечисление.ОперацииОбменаГИСМ.ПередачаДанныхПеремаркировкаТоваров"));
		
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура КиЗГИСМВидПриИзменении(Элемент)
	
	Если МаркировкаТоваровГИСМКлиент.ПроверитьЗаполнениеКатегорийКиЗ(Объект) Тогда
		КатегорияКиЗПриИзменении();
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура КиЗГИСМРазмерПриИзменении(Элемент)
	
	Если МаркировкаТоваровГИСМКлиент.ПроверитьЗаполнениеКатегорийКиЗ(Объект) Тогда
		КатегорияКиЗПриИзменении();
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура КиЗГИСМСпособВыпускаВОборотПриИзменении(Элемент)
	
	Если МаркировкаТоваровГИСМКлиент.ПроверитьЗаполнениеКатегорийКиЗ(Объект) Тогда
		КатегорияКиЗПриИзменении();
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура КиЗГИСМСИндивидуализациейПриИзменении(Элемент)
	
	Если МаркировкаТоваровГИСМКлиент.ПроверитьЗаполнениеКатегорийКиЗ(Объект) Тогда
		КатегорияКиЗПриИзменении();
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура МагазинПриИзменении(Элемент)
	
	МагазинПриИзмененииСервер();
КонецПроцедуры

&НаКлиенте
Процедура ДатаПриИзменении(Элемент)
	
	ДатаПриИзмененииСервер();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыТовары

&НаКлиенте
Процедура ТоварыНоменклатураПриИзменении(Элемент)
	
	ТекущаяСтрока = Элементы.Товары.ТекущиеДанные;
	ИдентификаторСтроки = ТекущаяСтрока.ПолучитьИдентификатор();
	ТоварыНоменклатураПриИзмененииСервер(ИдентификаторСтроки);
КонецПроцедуры

&НаКлиенте
Процедура ТоварыХарактеристикаПриИзменении(Элемент)
	
	ТекущаяСтрока = Элементы.Товары.ТекущиеДанные;
	ИдентификаторСтроки = ТекущаяСтрока.ПолучитьИдентификатор();
	ТоварыХарактеристикаПриИзмененииСервер(ИдентификаторСтроки);
КонецПроцедуры

&НаКлиенте
Процедура ТоварыХарактеристикаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ОбработкаТабличнойЧастиТоварыКлиент.ВыбратьХарактеристикуНоменклатуры(
		ЭтотОбъект,
		Элемент,
		СтандартнаяОбработка,
		Элементы.Товары.ТекущиеДанные);
КонецПроцедуры

&НаКлиенте
Процедура ТоварыХарактеристикаСоздание(Элемент, СтандартнаяОбработка)
	
	СобытияФормГИСМКлиентПереопределяемый.ХарактеристикаСоздание(
		ЭтотОбъект,
		Элементы.Товары.ТекущиеДанные,
		Элемент,
		СтандартнаяОбработка);
КонецПроцедуры

&НаКлиенте
Процедура ТоварыGTINПриИзменении(Элемент)
	
	ТекущаяСтрока = Элементы.Товары.ТекущиеДанные;
	ИдентификаторСтроки = ТекущаяСтрока.ПолучитьИдентификатор();
	ТоварыGTINПриИзмененииСервер(ИдентификаторСтроки);
КонецПроцедуры

&НаКлиенте
Процедура ТоварыGTINНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ТекущаяСтрока = Элементы.Товары.ТекущиеДанные;
	СписокВыбораGTIN = Новый Массив;
	МаркировкаТоваровГИСМВызовСервераПереопределяемый.МассивGTINМаркированногоТовара(
		ТекущаяСтрока.Номенклатура,
		ТекущаяСтрока.Характеристика,
		СписокВыбораGTIN);
	Элемент.СписокВыбора.ЗагрузитьЗначения(СписокВыбораGTIN);
КонецПроцедуры

&НаКлиенте
Процедура ТоварыНоменклатураКиЗНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ТекущаяСтрока = Элементы.Товары.ТекущиеДанные;
	GTIN = ?(Объект.КиЗГИСМСИндивидуализацией, ТекущаяСтрока.GTIN, "");
	СписокВыбораКиЗ = Новый Массив;
	МаркировкаТоваровГИСМВызовСервераПереопределяемый.ОтобратьНоменклатуруПоНомеруGTIN(
		СписокНоменклатураКиЗ,
		GTIN,
		СписокВыбораКиЗ);
	Элемент.СписокВыбора.ЗагрузитьЗначения(СписокВыбораКиЗ);
КонецПроцедуры

&НаКлиенте
Процедура ТоварыПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	
	Если ФлагРекурсии Тогда
		ФлагРекурсии = Ложь;
		Возврат;
	КонецЕсли;
	
	Отказ = Истина;
	ФлагРекурсии = Истина;
	
	Элементы.Товары.ДобавитьСтроку();
	
	НоваяСтрока = Элементы.Товары.ТекущиеДанные;
	
	Если Не НоваяСтрока = Неопределено Тогда
		НоваяСтрока.Количество = 1;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ТоварыСерияНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ОткрытьПодборСерий("",,Истина);
КонецПроцедуры

&НаКлиенте
Процедура ТоварыСерияПриИзменении(Элемент)
	
	ВыбранноеЗначение = МаркировкаТоваровГИСМРТКлиент.ВыбраннаяСерия();
	
	ВыбранноеЗначение.Значение = Элементы.Товары.ТекущиеДанные.Серия;
	ВыбранноеЗначение.ИдентификаторТекущейСтроки = Элементы.Товары.ТекущиеДанные.ПолучитьИдентификатор();
	
	МаркировкаТоваровГИСМРТКлиент.ОбработатьУказаниеСерии(ЭтаФорма, ПараметрыУказанияСерий, ВыбранноеЗначение);
КонецПроцедуры

&НаКлиенте
Процедура ТоварыСписываемаяСерияНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ОткрытьПодборСерий(Элемент.ТекстРедактирования);
КонецПроцедуры

&НаКлиенте
Процедура ТоварыСписываемаяСерияПриИзменении(Элемент)
	
	ВыбранноеЗначение = МаркировкаТоваровГИСМРТКлиент.ВыбраннаяСерия();
	ТекущиеДанные = Элементы.Товары.ТекущиеДанные;
	
	ВыбранноеЗначение.Значение = ТекущиеДанные.СписываемаяСерия;
	ВыбранноеЗначение.ИдентификаторТекущейСтроки = ТекущиеДанные.ПолучитьИдентификатор();
	
	ТекущаяСтрока = Новый Структура;
	ТекущаяСтрока.Вставить("Серия", ТекущиеДанные.СписываемаяСерия);
	ТекущаяСтрока.Вставить("СтатусУказанияСерий", ТекущиеДанные.СтатусУказанияСерийСписываемаяСерия);
	ТекущаяСтрока.Вставить("Количество", ТекущиеДанные.Количество);
	
	МаркировкаТоваровГИСМРТКлиент.ОбработатьУказаниеСерии(
		ЭтотОбъект,
		ПараметрыУказанияСерий,
		ВыбранноеЗначение,
		ТекущаяСтрока);
	
	ТекущиеДанные.СписываемаяСерия = ТекущаяСтрока.Серия;
	ТекущиеДанные.СтатусУказанияСерийСписываемаяСерия = ТекущаяСтрока.СтатусУказанияСерий;
КонецПроцедуры

&НаКлиенте
Процедура ТоварыХарактеристикаКиЗНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ОбработкаТабличнойЧастиТоварыКлиент.ВыбратьХарактеристикуНоменклатуры(
		ЭтотОбъект,
		Элемент,
		СтандартнаяОбработка,
		Элементы.Товары.ТекущиеДанные);
КонецПроцедуры

&НаКлиенте
Процедура ТоварыХарактеристикаКиЗСоздание(Элемент, СтандартнаяОбработка)
	
	СобытияФормГИСМКлиентПереопределяемый.ХарактеристикаСоздание(
		ЭтотОбъект,
		Элементы.Товары.ТекущиеДанные,
		Элемент,
		СтандартнаяОбработка);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура УказатьСерии(Команда)
	
	ОткрытьПодборСерий("");
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьПодбор(Команда)
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("РежимПодбораБезСуммовыхПараметров", Истина);
	ПараметрыФормы.Вставить("СкрыватьКолонкуВидЦены", Истина);
	ПараметрыФормы.Вставить("СкрыватьКомандуЦеныНоменклатуры", Истина);
	ПараметрыФормы.Вставить("Магазин", Объект.Магазин);
	ПараметрыФормы.Вставить("Склад", Объект.Склад);
	ПараметрыФормы.Вставить("Заголовок", НСтр("ru = 'Подбор товаров'"));
	ПараметрыФормы.Вставить("Дата", Объект.Дата);
	ПараметрыФормы.Вставить("Документ", Объект.Ссылка);
	ПараметрыФормы.Вставить("ПродукцияМаркируемаяДляГИСМ", Истина);
	
	ОткрытьФорму("Обработка.ПодборТоваров.Форма", ПараметрыФормы, ЭтотОбъект, УникальныйИдентификатор);
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьДанныеИзТСД(Команда)
	
	ОчиститьСообщения();
	
	ПодключаемоеОборудованиеРТКлиент.ПолучитьДанныеИзТСД(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьПричинуСписанияПоврежден(Команда)
	
	ЗаполнитьПричинуСписания(ПредопределенноеЗначение("Перечисление.ПричиныСписанияКиЗГИСМ.Поврежден"));
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьПричинуСписанияУничтожен(Команда)
	
	ЗаполнитьПричинуСписания(ПредопределенноеЗначение("Перечисление.ПричиныСписанияКиЗГИСМ.Уничтожен"));
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьПричинуСписанияУтерян(Команда)
	
	ЗаполнитьПричинуСписания(ПредопределенноеЗначение("Перечисление.ПричиныСписанияКиЗГИСМ.Утерян"));
КонецПроцедуры

&НаКлиенте
Процедура ПоискПоШтрихкодуВыполнить(Команда)
	
	ОбработкаТабличнойЧастиТоварыКлиент.ВвестиШтрихкод(ЭтотОбъект);
КонецПроцедуры

#КонецОбласти

#Область ШтрихкодыИТорговоеОборудование

&НаКлиенте
Функция ПолученШтрихкодИзСШК(Штрихкод) Экспорт
	
	СтруктураРезультат = ДанныеПоискаПоШтрихкодуСервер(Штрихкод);
	
	Возврат ПодключаемоеОборудованиеРТКлиент.ПолученШтрихкодИзСШК(ЭтотОбъект, СтруктураРезультат);
КонецФункции

&НаСервере
Функция ДанныеПоискаПоШтрихкодуСервер(Штрихкод)
	
	Возврат ПодключаемоеОборудованиеРТ.ДанныеПоискаПоШтрихкоду(Штрихкод, ЭтотОбъект);
КонецФункции

&НаКлиенте
Процедура ОповещениеОбработатьДанныеПоКоду(СтруктураРезультат, ДополнительныеПараметры) Экспорт
	
	ОбработатьДанныеПоКодуСервер(СтруктураРезультат);
КонецПроцедуры

&НаКлиенте
Процедура ОповещениеПоискаПоШтрихкоду(Штрихкод, ДополнительныеПараметры) Экспорт
	
	Если НЕ ПустаяСтрока(Штрихкод) Тогда
		СтруктураПараметровКлиента = ПолученШтрихкодИзСШК(Штрихкод);
		ОбработатьДанныеПоКодуКлиент(СтруктураПараметровКлиента);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ОбработатьДанныеПоКодуКлиент(СтруктураПараметровКлиента) Экспорт
	
	ОткрытаБлокирующаяФорма = Ложь;
	
	ПодключаемоеОборудованиеРТКлиент.ОбработатьДанныеПоКоду(
		ЭтотОбъект,
		СтруктураПараметровКлиента,
		ОткрытаБлокирующаяФорма);
	
	Если НЕ ОткрытаБлокирующаяФорма Тогда
		ЗавершитьОбработкуДанныхПоКодуКлиент(СтруктураПараметровКлиента);
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ОбработатьДанныеПоКодуСервер(СтруктураРезультат) Экспорт
	
	ИдентификаторСтроки = Неопределено;
	СтрокаРезультата = СтруктураРезультат.ЗначенияПоиска[0];
	
	ИдентификаторСтроки = ДобавитьНайденныеПозицииТоваровСервер(СтрокаРезультата);
	
	МаркировкаТоваровГИСМПереопределяемый.ЗаполнитьНоменклатуруКиЗВСтроках(Объект, СписокНоменклатураКиЗ, Ложь);
	
	Если ИдентификаторСтроки <> Неопределено Тогда
		СтруктураРезультат.Вставить("АктивизироватьСтроку", ИдентификаторСтроки);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ОповещениеОткрытьФормуВыбораДанныхПоиска(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат <> Неопределено Тогда
		ОбработатьДанныеПоКодуСервер(Результат);
		ОбработатьДанныеПоКодуКлиент(Результат);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ЗавершитьОбработкуДанныхПоКодуКлиент(СтруктураПараметровКлиента)
	
	ИдентификаторСтроки =
		ПодключаемоеОборудованиеРТКлиент.ЗавершитьОбработкуДанныхПоКодуКлиент(ЭтотОбъект, СтруктураПараметровКлиента);
КонецПроцедуры

&НаКлиенте
Функция ДобавитьНайденныеПозицииТоваров(СтруктураПараметров, ДополнительныеПараметры = Неопределено) Экспорт
	
	Возврат ДобавитьНайденныеПозицииТоваровСервер(СтруктураПараметров, ДополнительныеПараметры);
КонецФункции

&НаСервере
Функция ДобавитьНайденныеПозицииТоваровСервер(СтруктураПараметров, ДополнительныеПараметры = Неопределено)
	
	Если Не ДополнительныеПараметры = Неопределено Тогда
		СтруктураПараметров = ДополнительныеПараметры;
		ИдентификаторСтроки = СтруктураПараметров;
	Иначе
		ИдентификаторСтроки = Неопределено;
	КонецЕсли;
	
	ДобавленаСтрока = Ложь;
	СтруктураПараметров.Вставить("УчетУпаковок", Ложь);
	СтруктураПараметров.Вставить("СворачиватьПоСтрокеПоиска", Ложь);
	ТекущаяСтрока =
		ПодключаемоеОборудованиеРТ.ИнициализацияСтрокиТоваров(ЭтотОбъект, СтруктураПараметров, ДобавленаСтрока);
	
	СтруктураДействий = Новый Структура;
	СтруктураДействий.Вставить("ЗаполнитьКиЗВСтроке",
		Новый Структура("НоменклатураКиЗ, ХарактеристикаКиЗ",
			ТекущаяСтрока.НоменклатураКиЗ, ТекущаяСтрока.ХарактеристикаКиЗ));
	ОбработкаТабличнойЧастиТоварыСервер.ОбработатьСтрокуТЧСервер(ТекущаяСтрока, СтруктураДействий, Неопределено);
		
	МаркировкаТоваровГИСМПереопределяемый.ЗаполнитьGTINВСтроке(ТекущаяСтрока);
	МаркировкаТоваровГИСМПереопределяемый.ЗаполнитьНоменклатуруКиЗВСтроке(
		ТекущаяСтрока,
		СписокНоменклатураКиЗ,
		Объект.КиЗГИСМСИндивидуализацией);
	
	ИдентификаторСтроки =
		ПодключаемоеОборудованиеРТ.ЗавершениеОбработкиСтрокиТоваров(ЭтотОбъект, ТекущаяСтрока,СтруктураДействий);
	
	Если Не ДополнительныеПараметры = Неопределено Тогда
		СтруктураПараметров = ИдентификаторСтроки;
		Возврат СтруктураПараметров;
	Иначе
		Возврат ИдентификаторСтроки;
	КонецЕсли;
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ПриЧтенииСозданииНаСервере()
	
	ОбновитьСтатусГИСМ();
	
	МаркировкаТоваровГИСМРТ.ЗаполнитьСлужебныеРеквизитыТабличнойЧасти(Объект.Товары);
	МаркировкаТоваровГИСМРТ.УправлениеДоступностью(ЭтаФорма);
	
	МаркировкаТоваровГИСМПереопределяемый.ЗаполнитьСпискиВыбораРеквизитовШапкиПеремаркировкаТоваров(ЭтаФорма);
	МаркировкаТоваровГИСМПереопределяемый.ПолучитьКиЗДляЗаполнения(Объект,СписокНоменклатураКиЗ);
	
	ОбщегоНазначенияРТКлиентСервер.ОбновитьСостояниеДокумента(
		Объект,
		Элементы.КартинкаСостоянияДокумента.Подсказка,
		КартинкаСостоянияДокумента,
		РазрешеноПроведение);
КонецПроцедуры

&НаСервере
Процедура ОбработкаВыбораПодборНаСервере(ВыбранноеЗначение)
	
	ТаблицаТоваров = ПолучитьИзВременногоХранилища(ВыбранноеЗначение.АдресТоваровВХранилище);
	
	СтруктураДействий = Новый Структура;
	СтруктураДействий.Вставить("ЗаполнитьGTINВСтроке");
	КэшированныеЗначения = Неопределено;
	
	Для каждого СтрокаТовара Из ТаблицаТоваров Цикл
		
		ТекущаяСтрока = Объект.Товары.Добавить();
		ЗаполнитьЗначенияСвойств(
			ТекущаяСтрока,
			СтрокаТовара,
			"Номенклатура, Характеристика, ХарактеристикиИспользуются, Количество");
		ТекущаяСтрока.Количество = 1;
		ОбработкаТабличнойЧастиТоварыСервер.ОбработатьСтрокуТЧСервер(ТекущаяСтрока, СтруктураДействий, КэшированныеЗначения);
		
	КонецЦикла;
	
	ЗаполнитьСтатусыУказанияСерийСервер();
	МаркировкаТоваровГИСМПереопределяемый.ЗаполнитьНоменклатуруКиЗВСтроках(Объект, СписокНоменклатураКиЗ, Ложь);
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьПодборСерий(Текст = "",ТекущиеДанные = Неопределено,ЭтоВводНовойСерии = Ложь)
	
	Если ТекущиеДанные = Неопределено Тогда
		ТекущиеДанные = Элементы.Товары.ТекущиеДанные;
		Если ТекущиеДанные = Неопределено Тогда
			Возврат
		КонецЕсли;
	КонецЕсли;
		
	ТекущаяСтрока = Новый Структура;
	ТекущаяСтрока.Вставить("Номенклатура", ТекущиеДанные.Номенклатура);
	ТекущаяСтрока.Вставить("Характеристика", ТекущиеДанные.Характеристика);
	ТекущаяСтрока.Вставить("НоменклатураКиЗ", ТекущиеДанные.НоменклатураКиЗ);
	ТекущаяСтрока.Вставить("ХарактеристикаКиЗ", ТекущиеДанные.ХарактеристикаКиЗ);
	ТекущаяСтрока.Вставить("ХарактеристикиИспользуются", ТекущиеДанные.ХарактеристикиИспользуются);
	ТекущаяСтрока.Вставить("ХарактеристикиКиЗИспользуются", ТекущиеДанные.ХарактеристикиКиЗИспользуются);
	ТекущаяСтрока.Вставить("GTIN", ТекущиеДанные.GTIN);
	ТекущаяСтрока.Вставить("Серия", ТекущиеДанные.Серия);
	ТекущаяСтрока.Вставить("СписываемаяСерия", ТекущиеДанные.СписываемаяСерия);
	ТекущаяСтрока.Вставить("СтатусУказанияСерий", ТекущиеДанные.СтатусУказанияСерий);
	ТекущаяСтрока.Вставить("ИдентификаторТекущейСтроки", ТекущиеДанные.ПолучитьИдентификатор());
	ТекущаяСтрока.Вставить("Количество", ТекущиеДанные.Количество);
	ТекущаяСтрока.Вставить("ЭтоВводНовойСерии", ЭтоВводНовойСерии);
	
	Если МаркировкаТоваровГИСМРТКлиент.ДляУказанияСерийНуженСерверныйВызов(
			ЭтотОбъект,
			ПараметрыУказанияСерий,
			Текст,
			ТекущаяСтрока) Тогда
			
		ТекстИсключения =
			НСтр("ru = 'Ошибка при попытке указать серии - в этом документе для указания серий не нужен серверный вызов.'");
		
		ВызватьИсключение ТекстИсключения;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьПричинуСписания(ПричинаСписания)

	Для Каждого ВыделеннаяСтрока Из Элементы.Товары.ВыделенныеСтроки Цикл
		ДанныеСтроки = Элементы.Товары.ДанныеСтроки(ВыделеннаяСтрока);
		ДанныеСтроки.ПричинаСписания = ПричинаСписания;
	КонецЦикла;
КонецПроцедуры


#Область ПриИзмененииРеквизитов

&НаСервере
Процедура ТоварыНоменклатураПриИзмененииСервер(ИдентификаторСтроки)
	
	ТекущаяСтрока = Объект.Товары.НайтиПоИдентификатору(ИдентификаторСтроки);
	
	ТекущаяСтрокаСписываемаяСерия = Новый Структура;
	ТекущаяСтрокаСписываемаяСерия.Вставить("Номенклатура", ТекущаяСтрока.Номенклатура);
	ТекущаяСтрокаСписываемаяСерия.Вставить("Характеристика", ТекущаяСтрока.Характеристика);
	ТекущаяСтрокаСписываемаяСерия.Вставить("Серия", ТекущаяСтрока.СписываемаяСерия);
	ТекущаяСтрокаСписываемаяСерия.Вставить("СтатусУказанияСерий", ТекущаяСтрока.СтатусУказанияСерийСписываемаяСерия);
	
	СтруктураДействий = Новый Структура;
	СтруктураДействий.Вставить("ПроверитьХарактеристикуПоВладельцу", ТекущаяСтрока.Характеристика);
	СтруктураДействий.Вставить("ЗаполнитьGTINВСтроке");
	
	СтруктураПараметров = Новый Структура;
	
	СтруктураПараметров.Вставить("Номенклатура", "НоменклатураКиЗ");
	СтруктураПараметров.Вставить("ХарактеристикиИспользуются", "ХарактеристикиКиЗИспользуются");
	
	СтруктураДействий.Вставить("ЗаполнитьПризнакХарактеристикиИспользуются", СтруктураПараметров);
	
	СтруктураПараметров = Новый Структура;
	СтруктураПараметров.Вставить("Владелец", ТекущаяСтрока.Номенклатура);
	СтруктураПараметров.Вставить("Магазин" , Объект.Магазин);
	ПроверяемыеЗначения = Новый Структура;
	ПроверяемыеЗначения.Вставить("СписываемаяСерия", ТекущаяСтрока.СписываемаяСерия);
	ПроверяемыеЗначения.Вставить("СтатусУказанияСерийСписываемаяСерия",
		ТекущаяСтрока.СтатусУказанияСерийСписываемаяСерия);
	
	СтруктураПараметров.Вставить("ПроверяемыеЗначения", ПроверяемыеЗначения);
	
	СтруктураДействий.Вставить("ПроверитьСерииПоВладельцу", ТекущаяСтрока.Характеристика);
	
	ОбработкаТабличнойЧастиТоварыСервер.ОбработатьСтрокуТЧСервер(ТекущаяСтрока, СтруктураДействий, Неопределено);
	МаркировкаТоваровГИСМПереопределяемый.ЗаполнитьНоменклатуруКиЗВСтроке(
		ТекущаяСтрока,
		СписокНоменклатураКиЗ,
		Объект.КиЗГИСМСИндивидуализацией);
	
	МаркировкаТоваровГИСМРТ.ЗаполнитьСтатусСерииВСтроке(Объект.Магазин, ТекущаяСтрока, Объект.СерииКиЗ);
КонецПроцедуры

&НаСервере
Процедура ТоварыХарактеристикаПриИзмененииСервер(ИдентификаторСтроки)
	
	ТекущаяСтрока = Объект.Товары.НайтиПоИдентификатору(ИдентификаторСтроки);
	МаркировкаТоваровГИСМПереопределяемый.ЗаполнитьGTINВСтроке(ТекущаяСтрока);
	МаркировкаТоваровГИСМПереопределяемый.ЗаполнитьНоменклатуруКиЗВСтроке(
		ТекущаяСтрока,
		СписокНоменклатураКиЗ,
		Объект.КиЗГИСМСИндивидуализацией);
КонецПроцедуры

&НаСервере
Процедура ТоварыGTINПриИзмененииСервер(ИдентификаторСтроки)
	
	ТекущаяСтрока = Объект.Товары.НайтиПоИдентификатору(ИдентификаторСтроки);
	МаркировкаТоваровГИСМПереопределяемый.ЗаполнитьНоменклатуруКиЗВСтроке(
		ТекущаяСтрока,
		СписокНоменклатураКиЗ,
		Объект.КиЗГИСМСИндивидуализацией);
КонецПроцедуры

&НаСервере
Процедура КатегорияКиЗПриИзменении()
	
	МаркировкаТоваровГИСМПереопределяемый.КатегорияКиЗПриИзменении(Объект, СписокНоменклатураКиЗ, Ложь);
КонецПроцедуры

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	
	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Объект);
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат) Экспорт
	
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Объект, Результат);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

#КонецОбласти

&НаСервере
Процедура ОбновитьСтатусГИСМ()
	
	МаркировкаТоваровГИСМ.ОбновитьСтатусГИСМ(ЭтаФорма, "ПеремаркировкаТоваровГИСМ");
	
	Если Объект.Проведен Тогда
		Элементы.СтатусГИСМ.ОтображениеПодсказки = ОтображениеПодсказки.Нет;
		Элементы.СтатусГИСМ.Доступность = Истина;
	Иначе
		Элементы.СтатусГИСМ.ОтображениеПодсказки = ОтображениеПодсказки.Кнопка;
		Элементы.СтатусГИСМ.Доступность = Ложь;
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСтатусыУказанияСерийСервер()
	
	МаркировкаТоваровГИСМРТ.ЗаполнитьСтатусыСерииВСтроках(Объект);
КонецПроцедуры

&НаСервере
Процедура МагазинПриИзмененииСервер()
	
	ЗаполнитьСтатусыУказанияСерийСервер();
КонецПроцедуры

&НаСервере
Процедура ДатаПриИзмененииСервер()
	
	ЗаполнитьСтатусыУказанияСерийСервер();
КонецПроцедуры

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	УсловноеОформление.Элементы.Очистить();
КонецПроцедуры

#КонецОбласти