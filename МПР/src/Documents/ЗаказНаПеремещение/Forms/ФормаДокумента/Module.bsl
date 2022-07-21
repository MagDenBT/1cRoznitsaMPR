
#Область ОписаниеПеременных

// Используется механизмом обработки изменения реквизитов ТЧ.
&НаКлиенте
Перем КэшированныеЗначения;

#КонецОбласти

#Область ПрограммныйИнтерфейс

#Область ОбработчикиСобытийПодключаемогоОборудования

&НаКлиенте
Функция ПолученМагнитныйКод(МагнитныйКод) Экспорт
	
	СтруктураРезультат = ДанныеПоискаПоМагнитномуКодуСервер(МагнитныйКод);
	Возврат ПодключаемоеОборудованиеРТКлиент.ПолученМагнитныйКод(ЭтотОбъект, СтруктураРезультат);
	
КонецФункции

&НаКлиенте
Функция ПолученШтрихкодИзСШК(Штрихкод) Экспорт
	
	СтруктураРезультат = ДанныеПоискаПоШтрихкодуСервер(Штрихкод);
	Возврат ПодключаемоеОборудованиеРТКлиент.ПолученШтрихкодИзСШК(ЭтотОбъект, СтруктураРезультат);
	
КонецФункции

&НаКлиенте
Процедура ОбработатьДанныеПоКодуКлиент(СтруктураПараметровКлиента) Экспорт
	
	ОткрытаБлокирующаяФорма = Ложь;
	
	ПодключаемоеОборудованиеРТКлиент.ОбработатьДанныеПоКоду(ЭтотОбъект, СтруктураПараметровКлиента, ОткрытаБлокирующаяФорма);
	
	Если НЕ ОткрытаБлокирующаяФорма Тогда
		ЗавершитьОбработкуДанныхПоКодуКлиент(СтруктураПараметровКлиента);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Функция ДобавитьНайденныеПозицииТоваров(СтруктураПараметров, ДополнительныеПараметры = Неопределено) Экспорт 
	
	Возврат ДобавитьНайденныеПозицииТоваровСервер(СтруктураПараметров, ДополнительныеПараметры);
	
КонецФункции

&НаКлиенте
Процедура ОповещениеПоискаПоНаименованию(Результат, ДополнительныеПараметры) Экспорт
		
	Если Результат <> Неопределено Тогда
		ПродолжитьОбработатьДанныеПоКодуКлиент(Результат);
		ЗавершитьОбработкуДанныхПоКодуКлиент(Результат);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОповещениеОткрытьФормуВыбораДанныхПоиска(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат <> Неопределено Тогда
		ПродолжитьОбработатьДанныеПоКодуКлиент(Результат);
		ОбработатьДанныеПоКодуКлиент(Результат)
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ДанныеПоискаПоМагнитномуКодуСервер(МагнитныйКод)
	
	Возврат ПодключаемоеОборудованиеРТ.ДанныеПоискаПоМагнитномуКоду(МагнитныйКод, ЭтотОбъект);
	
КонецФункции

&НаСервере
Функция ДанныеПоискаПоШтрихкодуСервер(Штрихкод)
	
	Возврат ПодключаемоеОборудованиеРТ.ДанныеПоискаПоШтрихкоду(Штрихкод, ЭтотОбъект);
	
КонецФункции

&НаКлиенте
Процедура ОповещениеОбработатьДанныеПоКоду(СтруктураРезультат, ДополнительныеПараметры) Экспорт
	
	ПродолжитьОбработатьДанныеПоКодуКлиент(СтруктураРезультат);
	
КонецПроцедуры

&НаКлиенте
Процедура ПродолжитьОбработатьДанныеПоКодуКлиент(СтруктураРезультат) Экспорт
	
	ИдентификаторСтроки = Неопределено;
	СтрокаРезультата = СтруктураРезультат.ЗначенияПоиска[0];
	
	Если СтрокаРезультата.Свойство("Карта") Тогда
		
		ПодключаемоеОборудованиеРТКлиент.ВставитьПредупреждениеОНевозможностиОбработкиКарт(СтруктураРезультат, СтрокаРезультата);
		
	ИначеЕсли СтрокаРезультата.Свойство("СерийныйНомер") Тогда
		
		ИдентификаторСтроки = ПодключаемоеОборудованиеРТКлиент.ДобавитьНоменклатуруПоСерийномуНомеру(ЭтотОбъект, СтрокаРезультата);
		
	Иначе // Номенклатура.
		
		ИдентификаторСтроки = ДобавитьНайденныеПозицииТоваров(СтрокаРезультата);
		
	КонецЕсли;

	Если СтрокаРезультата.Свойство("ТекстПредупреждения") Тогда
		СтруктураРезультат.Вставить("ТекстПредупреждения", СтрокаРезультата.ТекстПредупреждения);
	КонецЕсли;
	
	Если ИдентификаторСтроки <> Неопределено Тогда
		СтруктураРезультат.Вставить("АктивизироватьСтроку", ИдентификаторСтроки);
	КонецЕсли;
		
КонецПроцедуры

&НаКлиенте
Функция ОбработатьДанныеИзТСДКлиент(СтруктураПараметров, ДополнительныеПараметры) Экспорт
	
	Результат = ПодключаемоеОборудованиеРТКлиент.ОбработатьДанныеПоНоменклатуреИзТСДКлиент(ЭтотОбъект, СтруктураПараметров);
	ПодключаемоеОборудованиеРТКлиент.СообщитьТекстПредупреждения(СтруктураПараметров);
	
	Возврат Результат;
	
КонецФункции

&НаСервере
Функция ДобавитьНайденныеПозицииТоваровСервер(СтруктураПараметров, ДополнительныеПараметры)
	
	Если Не ДополнительныеПараметры = Неопределено Тогда 
		СтруктураПараметров = ДополнительныеПараметры;
		ИдентификаторСтроки = СтруктураПараметров;
	Иначе 
		ИдентификаторСтроки = Неопределено;
	КонецЕсли;
	
	ДобавленаСтрока = Ложь;
	ТекущаяСтрока = ПодключаемоеОборудованиеРТ.ИнициализацияСтрокиТоваров(ЭтотОбъект, СтруктураПараметров, ДобавленаСтрока);
	
	СтруктураДействий = Новый Структура;
	СтруктураДействий.Вставить("ПересчитатьКоличествоЕдиниц");
		
	Если ДобавленаСтрока Тогда
		Если ИспользоватьАссортимент Тогда
			СтруктураПроверкиАссортимента = АссортиментКлиентСервер.ПараметрыПроверкиАссортимента(Объект, , , , "МагазинПолучатель");
			СтруктураПроверкиАссортимента.Магазин = Объект.МагазинПолучатель;
			СтруктураПроверкиАссортимента.Дата = ?(ЗначениеЗаполнено(Объект.ЖелаемаяДатаПоступления),
				Объект.ЖелаемаяДатаПоступления,
				Объект.Дата);
			СтруктураПроверкиАссортимента.ТекстСообщения = 
				НСтр("ru = 'Номенклатура ""%1"" не включена в ассортимент магазина-получателя или запрещена к закупке. Заказывать ее не рекомендуется.'");
			СтруктураДействий.Вставить("ПроверитьАссортиментСтроки", СтруктураПроверкиАссортимента);
		КонецЕсли;
	КонецЕсли;
	
	ИдентификаторСтроки = ПодключаемоеОборудованиеРТ.ЗавершениеОбработкиСтрокиТоваров(ЭтотОбъект, ТекущаяСтрока, СтруктураДействий);
	
	Если Не ДополнительныеПараметры = Неопределено Тогда 
		СтруктураПараметров = ИдентификаторСтроки;
		Возврат СтруктураПараметров;
	Иначе 
		Возврат ИдентификаторСтроки;
	КонецЕсли;
	
КонецФункции

#КонецОбласти

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтотОбъект);
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	
	ДополнительныеКолонкиНоменклатуры = ЗначениеНастроекПовтИсп.ПолучитьЗначениеКонстанты("ДополнительнаяКолонкаПриОтображенииНоменклатуры");
	
	ОбщегоНазначенияРТ.ЗаполнитьШапкуДокумента(Объект,КартинкаСостоянияДокумента,Элементы.КартинкаСостоянияДокумента.Подсказка,РазрешеноПроведение);
	
	Если НЕ ЗначениеЗаполнено(Объект.Ссылка) Тогда
		ОбработкаТабличнойЧастиТоварыСервер.ЗаполнитьПризнакИспользованияХарактеристик(Объект.Товары);
		ОбщегоНазначенияРТКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "Изменить", "Доступность", Ложь);
	КонецЕсли;
	
	ПодключаемоеОборудованиеРТ.НастроитьПодключаемоеОборудование(ЭтотОбъект);
	
	ИспользоватьАссортимент = АссортиментСервер.ПолучитьФункциональнуюОпциюКонтроляАссортимента(Объект.МагазинПолучатель);
	
	НастроитьФормуПоДополнительнымПравам();
	
	УстановитьДоступностьКомандБуфераОбмена();
	
	УстановитьДоступностьСтатуса();
	
	Элементы.Изменить.Видимость = НЕ ТолькоПросмотр;
	
	Элементы.ЗаказПокупателя.Видимость = ПолучитьФункциональнуюОпцию("ИспользоватьЗаказыПокупателей") 
										 И ЗначениеЗаполнено(Объект.ЗаказПокупателя);
	
	ОбщегоНазначенияРТКлиентСервер.УстановитьКартинкуДляКомментария(Элементы.СтраницаКомментарий, Объект.Комментарий);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// ПодключаемоеОборудование
	МенеджерОборудованияКлиент.НачатьПодключениеОборудованиеПриОткрытииФормы(Неопределено, ЭтотОбъект, "СканерШтрихкода, СчитывательМагнитныхКарт");
	// Конец ПодключаемоеОборудование
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	
	// ПодключаемоеОборудование
	МенеджерОборудованияКлиент.НачатьОтключениеОборудованиеПриЗакрытииФормы(Неопределено, ЭтотОбъект);
	// Конец ПодключаемоеОборудование
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	
	Если ИсточникВыбора.ИмяФормы = "Обработка.ПодборТоваров.Форма.Форма" Тогда	
		
		ОбработкаВыбораПодборНаСервере(ВыбранноеЗначение);
		
	КонецЕсли;
	
	Если Окно <> Неопределено Тогда
		
		Окно.Активизировать();
		
	КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)

	// СтандартныеПодсистемы.УправлениеДоступом
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УправлениеДоступом") Тогда
		МодульУправлениеДоступом = ОбщегоНазначения.ОбщийМодуль("УправлениеДоступом");
		МодульУправлениеДоступом.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.Свойства
	УстановитьДоступностьЭлементовПоСтатусуСервер();
	ОбработкаТабличнойЧастиТоварыСервер.ЗаполнитьПризнакИспользованияХарактеристик(Объект.Товары);
	ДатыЗапретаИзменения.ОбъектПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	
	ОбщегоНазначенияРТКлиентСервер.ОбновитьСостояниеДокумента(
		Объект,
		Элементы.КартинкаСостоянияДокумента.Подсказка,
		КартинкаСостоянияДокумента,
		РазрешеноПроведение);
	
	ИспользоватьАссортимент = АссортиментСервер.ПолучитьФункциональнуюОпциюКонтроляАссортимента(Объект.МагазинПолучатель);
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)

	// СтандартныеПодсистемы.УправлениеДоступом
	УправлениеДоступом.ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи);
	// Конец СтандартныеПодсистемы.УправлениеДоступом

	ОбработкаТабличнойЧастиТоварыСервер.ЗаполнитьПризнакИспользованияХарактеристик(Объект.Товары);	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	ОбщегоНазначенияРТКлиентСервер.ОбновитьСостояниеДокумента(
		Объект,
		Элементы.КартинкаСостоянияДокумента.Подсказка,
		КартинкаСостоянияДокумента,
		РазрешеноПроведение);
	
	УстановитьДоступностьЭлементовПоСтатусуСервер();
	
	// &ЗамерПроизводительности 
	ОценкаПроизводительностиРТКлиент.ЗакончитьЗамер(ПараметрыЗаписи.Замер);

КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
		Запрос = Новый Запрос;
		Запрос.Текст = 
		"ВЫБРАТЬ
		|	ЗаказНаПеремещение.Ссылка,
		|	ЗаказНаПеремещение.Статус
		|ИЗ
		|	Документ.ЗаказНаПеремещение КАК ЗаказНаПеремещение
		|ГДЕ
		|	ЗаказНаПеремещение.Ссылка = &Ссылка";
		
		Запрос.УстановитьПараметр("Ссылка", ТекущийОбъект.Ссылка);
		
		Результат = Запрос.Выполнить();
		
		Выборка = Результат.Выбрать();
		
		Если Выборка.Следующий() Тогда
			
			Если ТекущийОбъект.Статус = Перечисления.СтатусыВнутреннихЗаказов.Закрыт
				И НЕ Выборка.Статус = Перечисления.СтатусыВнутреннихЗаказов.Закрыт Тогда
				
				ТекущийОбъект.ЗакрытВручную = Истина;
				
			ИначеЕсли НЕ ТекущийОбъект.Статус = Перечисления.СтатусыВнутреннихЗаказов.Закрыт
				И Выборка.Статус = Перечисления.СтатусыВнутреннихЗаказов.Закрыт Тогда
				ТекущийОбъект.ЗакрытВручную = Ложь;
			КонецЕсли;
			
		КонецЕсли;
		
КонецПроцедуры

&НаКлиенте
Процедура ВнешнееСобытие(Источник, Событие, Данные)
	
	Если ВводДоступен() И ВозможностьВводаПоШК() Тогда
		ПодключаемоеОборудованиеРТКлиент.ВнешнееСобытиеОборудования(ЭтотОбъект, Источник, Событие, Данные);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "КопированиеСтрокВБуферОбмена" Или ИмяСобытия = "ВставкаСтрокИзБуфераОбмена" Тогда
		
		УстановитьДоступностьКомандБуфераОбмена();
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	// &ЗамерПроизводительности 
	Замер = ОценкаПроизводительностиРТКлиент.НачатьЗамер(Ложь, 
	                                            "Документ.ЗаказНаПеремещение.ФормаДокумента.Запись",
                                                          Ложь);
	
	ПараметрыЗаписи.Вставить("Замер", Замер);

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура СтатусПриИзменении(Элемент)
	УстановитьДоступностьЭлементовПоСтатусуСервер();
КонецПроцедуры

&НаКлиенте
Процедура МагазинОтправительПриИзменении(Элемент)
	
	УстановитьДоступностьСтатуса(Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура КомментарийПриИзменении(Элемент)
	ПодключитьОбработчикОжидания("Подключаемый_УстановитьКартинкуДляКомментария", 0.5, Истина);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_УстановитьКартинкуДляКомментария()
	ОбщегоНазначенияРТКлиентСервер.УстановитьКартинкуДляКомментария(Элементы.СтраницаКомментарий, Объект.Комментарий);
КонецПроцедуры

#Область ОбработчикиСобытийЭлементовТабличнойЧастиТовары

&НаКлиенте
Процедура ТоварыХарактеристикаПриИзменении(Элемент)
	
	ТекущаяСтрока = Элементы.Товары.ТекущиеДанные;
	
	СтруктураДействий = Новый Структура;
	
	ОбработкаТабличнойЧастиТоварыКлиент.ПриИзмененииРеквизитовВТЧКлиент(
		Объект.Товары,
		ТекущаяСтрока,
		СтруктураДействий,
		КэшированныеЗначения);
	
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
	
	ОбработкаТабличнойЧастиТоварыКлиент.СоздатьХарактеристикуНоменклатуры(ЭтотОбъект, Элемент, СтандартнаяОбработка, Элементы.Товары.ТекущиеДанные);
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыУпаковкаПриИзменении(Элемент)

	ТекущаяСтрока = Элементы.Товары.ТекущиеДанные;

	СтруктураДействий = Новый Структура;
	СтруктураДействий.Вставить("ПересчитатьКоличествоЕдиниц");

	ОбработкаТабличнойЧастиТоварыКлиент.ПриИзмененииРеквизитовВТЧКлиент(
		Объект.Товары,
		ТекущаяСтрока,
		СтруктураДействий,
		КэшированныеЗначения);
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыУпаковкаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ОбработкаТабличнойЧастиТоварыКлиент.ВыбратьУпаковкуНоменклатуры(
		ДанныеВыбора,
		СтандартнаяОбработка,
		Элементы.Товары.ТекущиеДанные);
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыКоличествоУпаковокПриИзменении(Элемент)
	
	ТекущаяСтрока = Элементы.Товары.ТекущиеДанные;
	
	СтруктураДействий = Новый Структура;
	СтруктураДействий.Вставить("ПересчитатьКоличествоЕдиниц");
	
	ОбработкаТабличнойЧастиТоварыКлиент.ПриИзмененииРеквизитовВТЧКлиент(
		Объект.Товары,
		ТекущаяСтрока,
		СтруктураДействий,
		КэшированныеЗначения);
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыНоменклатураПриИзменении(Элемент)
	
	ТекущаяСтрока = Элементы.Товары.ТекущиеДанные;
	
	СтруктураДействий = Новый Структура;
	СтруктураДействий.Вставить("ПроверитьХарактеристикуПоВладельцу", ТекущаяСтрока.Характеристика);
	СтруктураДействий.Вставить("ПроверитьЗаполнитьУпаковкуПоВладельцу" , ТекущаяСтрока.Упаковка);
	СтруктураДействий.Вставить("ПересчитатьКоличествоЕдиниц");
	Если ИспользоватьАссортимент Тогда
		СтруктураПроверкиАссортимента = АссортиментКлиентСервер.ПараметрыПроверкиАссортимента(Объект, , , , "МагазинПолучатель");
		СтруктураПроверкиАссортимента.Магазин = Объект.МагазинПолучатель;
		СтруктураПроверкиАссортимента.Дата = ?(ЗначениеЗаполнено(Объект.ЖелаемаяДатаПоступления),
			Объект.ЖелаемаяДатаПоступления,
			Объект.Дата);
		СтруктураПроверкиАссортимента.ТекстСообщения =
			НСтр("ru = 'Номенклатура ""%1"" не включена в ассортимент магазина-получателя или запрещена к закупке. Заказывать ее не рекомендуется.'");
		СтруктураДействий.Вставить("ПроверитьАссортиментСтроки", СтруктураПроверкиАссортимента);
	КонецЕсли;
	
	ОбработкаТабличнойЧастиТоварыКлиент.ПриИзмененииРеквизитовВТЧКлиент(
		Объект.Товары,
		ТекущаяСтрока,
		СтруктураДействий,
		КэшированныеЗначения);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область ОбработчикиКомандФормы


#Область ОбработчикиКомандПодключаемогоОборудования

&НаКлиенте
Процедура ВыгрузитьДанныеВТСД(Команда)
	
	ПодключаемоеОборудованиеРТКлиент.ВыгрузитьДокументВТСД(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьДанныеИзТСД(Команда)
	
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("УчитыватьСерийныеНомераПриСвертке", Ложь);
	ПодключаемоеОборудованиеРТКлиент.ПолучитьДанныеИзТСД(ЭтотОбъект, ДополнительныеПараметры);
	
КонецПроцедуры

&НаКлиенте
Процедура ПоискПоМагнитномуКоду(Команда)
	
	ОбработкаТабличнойЧастиТоварыКлиент.ВвестиМагнитныйКод(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПоискПоШтрихкоду(Команда)
	
	ОбработкаТабличнойЧастиТоварыКлиент.ВвестиШтрихкод(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПоискПоНаименованию(Команда)
	
	ПараметрыПоиска = Новый Структура;
	ПараметрыПоиска.Вставить("Магазин",Объект.МагазинОтправитель);
	РаботаСПравиламиИменованияКлиент.ПоискПоНаименованию(ЭтаФорма,ПараметрыПоиска);
	
КонецПроцедуры

&НаКлиенте
Процедура ПолучитьВес(Команда)
	
	ОповещенияПриПолученииВеса = Новый ОписаниеОповещения("ПолучитьВесЗавершение", ЭтотОбъект);
	ПодключаемоеОборудованиеРТКлиент.ПолучениеВесаСЭлектронныхВесовДляТабличнойЧасти(ОповещенияПриПолученииВеса, ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти

 &НаКлиенте
Процедура ОткрытьПодбор(Команда)
	
	Отказ = Ложь;
	Если Не ЗначениеЗаполнено(Объект.МагазинОтправитель) Тогда
		ОчиститьСообщения();
		СообщитьОбОшибкахОткрытияПодбора(Отказ);
	КонецЕсли;
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрЗаголовок = НСтр("ru = 'Подбор товаров в %Документ%'");
	Если ЗначениеЗаполнено(Объект.Ссылка) Тогда
		ПараметрЗаголовок = СтрЗаменить(ПараметрЗаголовок, "%Документ%", Объект.Ссылка);
	Иначе
		ПараметрЗаголовок = СтрЗаменить(ПараметрЗаголовок, "%Документ%", НСтр("ru = 'заказ на перемещение'"));
	КонецЕсли;
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Магазин",    Объект.МагазинОтправитель);
	ПараметрыФормы.Вставить("РежимПодбораБезСуммовыхПараметров", Истина);
	ПараметрыФормы.Вставить("РежимПодбораБезУслуг", Истина);
	ПараметрыФормы.Вставить("СкрыватьКнопкуВвестиСерийныеНомера", Истина);
	ПараметрыФормы.Вставить("Заголовок", ПараметрЗаголовок);
	ПараметрыФормы.Вставить("Дата", Объект.Дата);
	ПараметрыФормы.Вставить("ЗаголовокКнопкиЗапрашиватьКоличествоИЦену",НСтр("ru = 'Запрашивать количество'"));
	
	Если ИспользоватьАссортимент Тогда
		ПараметрыФормы.Вставить("МагазинАссортимента", Объект.МагазинПолучатель);
		ПараметрыФормы.Вставить("РежимПодбораСУчетомАссортимента", Истина);
		ПараметрыФормы.Вставить("УсловиеАссортимента", "РазрешеныЗакупки");
	КонецЕсли;
	
	ОткрытьФорму("Обработка.ПодборТоваров.Форма", ПараметрыФормы, ЭтотОбъект, УникальныйИдентификатор);
	
КонецПроцедуры

&НаКлиенте
Процедура Изменить(Команда)
	УстановитьДоступностьЭлементовПоСтатусуСервер(Истина);
КонецПроцедуры

&НаКлиенте
Процедура РазвернутьСвернутьТЧ(Команда)
	РазвернутьСвернутьТЧНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура СкопироватьСтроки(Команда)
	
	Если КопированиеСтрокКлиент.ВозможноКопированиеСтрок(Элементы.Товары.ТекущаяСтрока) Тогда
		СкопироватьСтрокиНаСервере();
		КопированиеСтрокКлиент.ОповеститьПользователяОКопированииСтрок(Элементы.Товары.ВыделенныеСтроки.Количество());
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВставитьСтроки(Команда)
	
	КоличествоТоваровДоВставки = Объект.Товары.Количество();
	ПолучитьСтрокиИзБуфераОбмена();
	КоличествоВставленных = Объект.Товары.Количество() - КоличествоТоваровДоВставки;
	КопированиеСтрокКлиент.ОповеститьПользователяОВставкеСтрок(КоличествоВставленных);
	
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

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ОповещениеПоискаПоШтрихкоду(Штрихкод, ДополнительныеПараметры) Экспорт
	
	Если НЕ ПустаяСтрока(Штрихкод) Тогда
		СтруктураПараметровКлиента = ПолученШтрихкодИзСШК(Штрихкод);
		ОбработатьДанныеПоКодуКлиент(СтруктураПараметровКлиента);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОповещениеПоискаПоМагнитномуКоду(ТекКод, ДополнительныеПараметры) Экспорт
	
	Если Не ПустаяСтрока(ТекКод) Тогда
		СтруктураПараметровКлиента = ПолученМагнитныйКод(ТекКод);
		ОбработатьДанныеПоКодуКлиент(СтруктураПараметровКлиента);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПолучитьВесЗавершение(Результат, Параметры) Экспорт
	
	Если Результат Тогда
		ТоварыКоличествоУпаковокПриИзменении(ЭтотОбъект);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработатьСозданиеИВыборНовойХарактеристики(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ТекущаяСтрока = Объект.Товары.НайтиПоИдентификатору(ДополнительныеПараметры.ИдентификаторТекущейСтроки);
	ТекущаяСтрока.Характеристика = Результат;
	ТоварыХарактеристикаПриИзменении(Неопределено);

КонецПроцедуры

&НаКлиенте
Функция ВозможностьВводаПоШК()
	
	Результат = Истина;
	
	Если Элементы.Товары.ТолькоПросмотр Тогда
		Результат = Ложь;
	КонецЕсли;
	
	Если НЕ Результат Тогда
		ОчиститьСообщения();
		ТекстСообщения = НСтр("ru = 'Форма заблокирована. Ввод невозможен.'");
		ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения);
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

&НаСервере
Процедура РазвернутьСвернутьТЧНаСервере()
	
	РазвернутаТЧ = НЕ РазвернутаТЧ;
	
	ВидимостьЭлементов = НЕ РазвернутаТЧ;
	
	ПоложениеКоманднойПанели   = ?(ВидимостьЭлементов,
		ПоложениеКоманднойПанелиФормы.Авто,
		ПоложениеКоманднойПанелиФормы.Нет);
	
	Элементы.ГруппаОснование.Видимость     = ВидимостьЭлементов;
	Элементы.Шапка.Видимость               = ВидимостьЭлементов;
	Элементы.СтраницаКомментарий.Видимость = ВидимостьЭлементов;
	Элементы.ГруппаПодвал.Видимость        = ВидимостьЭлементов;
	
	Элементы.РазвернутьСвернутьТЧ.Картинка = ?(ВидимостьЭлементов,
		БиблиотекаКартинок.РазвернутьТабличнуюЧасть,
		БиблиотекаКартинок.СвернутьТабличнуюЧасть);
	
КонецПроцедуры

// Процедура сообщает о необходимости заполнения реквизитов документа при вызове подбора.
// Параметры:
//	Отказ - Булево
&НаКлиенте
Процедура СообщитьОбОшибкахОткрытияПодбора(Отказ)
	
	Если НЕ ЗначениеЗаполнено(Объект.МагазинОтправитель) Тогда
		ОбщегоНазначенияКлиент.СообщитьПользователю(НСтр("ru = 'Поле ""Магазин-поставщик"" не заполнено'"),
			Объект,
			"Объект.МагазинОтправитель",
			,
			Отказ);
	КонецЕсли;
	
КонецПроцедуры

// Процедура заполняет товары из подбора.
// Параметры: 
//	ВыбранноеЗначение - Структура
&НаСервере
Процедура ОбработкаВыбораПодборНаСервере(ВыбранноеЗначение)
	
	ТаблицаТоваров = ПолучитьИзВременногоХранилища(ВыбранноеЗначение.АдресТоваровВХранилище);
	
	Для каждого СтрокаТовара Из ТаблицаТоваров Цикл
		
		ТекущаяСтрока = Объект.Товары.Добавить();
		ЗаполнитьЗначенияСвойств(ТекущаяСтрока, СтрокаТовара, "Номенклатура, Характеристика, Упаковка, КоличествоУпаковок");
		
		СтруктураДействий = Новый Структура;
		СтруктураДействий.Вставить("ПересчитатьКоличествоЕдиниц");
				
		КэшированныеЗначения = ОбработкаТабличнойЧастиТоварыКлиентСервер.СтруктураКэшируемыхЗначений();
		ОбработкаТабличнойЧастиТоварыСервер.ОбработатьСтрокуТЧСервер(ТекущаяСтрока, СтруктураДействий, КэшированныеЗначения);
	
	КонецЦикла;
	
	ОбработкаТабличнойЧастиТоварыСервер.ЗаполнитьПризнакИспользованияХарактеристик(Объект.Товары);
	
КонецПроцедуры

&НаСервере
Процедура НастроитьФормуПоДополнительнымПравам()

	УправлениеПользователями.УстановитьТолькоПросмотрДляРеквизитовТабличнойЧасти(Элементы.Дата.ТолькоПросмотр, 
																				 ПланыВидовХарактеристик.ПраваПользователей.ИзменятьДату);

КонецПроцедуры

&НаСервере
Процедура УстановитьДоступностьЭлементовПоСтатусуСервер(РазрешитьРедактирование = Ложь)
	
	ТолькоПросмотрЭлементов = Объект.Статус = Перечисления.СтатусыВнутреннихЗаказов.Закрыт;
	Если РазрешитьРедактирование Тогда
		ТолькоПросмотрЭлементов = Ложь;
	КонецЕсли;
	
	МассивЭлементов = Новый Массив;
	
	// Элементы управления шапки
	
	МассивЭлементов.Добавить("Дата");
	МассивЭлементов.Добавить("Ответственный");
	МассивЭлементов.Добавить("МагазинПолучатель");
	МассивЭлементов.Добавить("МагазинОтправитель");
	МассивЭлементов.Добавить("ЖелаемаяДатаПоступления");
	МассивЭлементов.Добавить("ДлительностьПеремещения");
	МассивЭлементов.Добавить("Статус");
	МассивЭлементов.Добавить("Организация");
	
	// Элементы управления, связанные с товарами.
	МассивЭлементов.Добавить("Товары");
	
	ОбщегоНазначенияРТКлиентСервер.УстановитьСвойствоЭлементовФормы(
		Элементы,
		МассивЭлементов,
		"ТолькоПросмотр",
		ТолькоПросмотрЭлементов);
	
	МассивЭлементов = Новый Массив;
	
	МассивЭлементов.Добавить("ТоварыПоискПоШтрихкоду");
	МассивЭлементов.Добавить("ТоварыПоискПоНаименованию");
	МассивЭлементов.Добавить("ТоварыОткрытьПодбор");
	МассивЭлементов.Добавить("ТоварыЗагрузитьДанныеИзТСД");
	МассивЭлементов.Добавить("ТоварыПолучитьВес");
	
	ОбщегоНазначенияРТКлиентСервер.УстановитьСвойствоЭлементовФормы(
		Элементы,
		МассивЭлементов,
		"Доступность",
		Не ТолькоПросмотрЭлементов);
	
	ОбщегоНазначенияРТКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Элементы,
		"Изменить",
		"Доступность",
		ТолькоПросмотрЭлементов);
	
	УстановитьДоступностьСтатуса(, РазрешитьРедактирование);
	
КонецПроцедуры

// Устанавливает доступность поля Статус.
//
// Параметры:
//  <ПриИзменении>  - <Булево> - истина при изменении полей (магазин).
//
//  <РазрешитьРедактирование>  - <Булево> - истина при вызове команды Изменить.
//
&НаСервере
Процедура УстановитьДоступностьСтатуса(ПриИзменении = Ложь, РазрешитьРедактирование = Ложь)

	СписокВыбора = Элементы.Статус.СписокВыбора;
	
	Если ЗначениеЗаполнено(Объект.МагазинОтправитель) И Объект.МагазинОтправитель.СкладУправляющейСистемы Тогда
		
		НайденныйЭлемент = СписокВыбора.НайтиПоЗначению(Перечисления.СтатусыВнутреннихЗаказов.КОбеспечению);
		
		Если НайденныйЭлемент = Неопределено Тогда
			СписокВыбора.Добавить(Перечисления.СтатусыВнутреннихЗаказов.КОбеспечению);
		КонецЕсли;
		
		Если НЕ ЗначениеЗаполнено(Объект.Ссылка) ИЛИ ПриИзменении Тогда
			Объект.Статус = Перечисления.СтатусыВнутреннихЗаказов.КОбеспечению;
		КонецЕсли;
		
		Элементы.Статус.ТолькоПросмотр = Истина;
	Иначе
		НайденныйЭлемент = СписокВыбора.НайтиПоЗначению(Перечисления.СтатусыВнутреннихЗаказов.КОбеспечению);
		
		Если НайденныйЭлемент <> Неопределено Тогда
			СписокВыбора.Удалить(СписокВыбора.Индекс(НайденныйЭлемент));
		КонецЕсли;
		
		Если НЕ ЗначениеЗаполнено(Объект.Статус)
			ИЛИ Объект.Статус = Перечисления.СтатусыВнутреннихЗаказов.КОбеспечению
			ИЛИ ПриИзменении Тогда
			
			Объект.Статус = Перечисления.СтатусыВнутреннихЗаказов.КВыполнению;
		КонецЕсли;
		
		Если РазрешитьРедактирование Тогда
			Элементы.Статус.ТолькоПросмотр = Ложь;
		Иначе
			Элементы.Статус.ТолькоПросмотр = Объект.Статус = Перечисления.СтатусыВнутреннихЗаказов.Закрыт;
		КонецЕсли;
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ЗавершитьОбработкуДанныхПоКодуКлиент(СтруктураПараметровКлиента)
	
	ИдентификаторСтроки = ПодключаемоеОборудованиеРТКлиент.ЗавершитьОбработкуДанныхПоКодуКлиент(ЭтотОбъект, СтруктураПараметровКлиента);
	
КонецПроцедуры

&НаКлиенте
Процедура МагазинПолучательПриИзменении(Элемент)
	
	МагазинПолучательПриИзмененииСервер();
	
КонецПроцедуры

&НаСервере
Процедура МагазинПолучательПриИзмененииСервер()
	
	ИспользоватьАссортимент = АссортиментСервер.ПолучитьФункциональнуюОпциюКонтроляАссортимента(Объект.МагазинПолучатель);
	
КонецПроцедуры

#Область РаботаСБуферомОбмена
	
&НаСервере
Процедура СкопироватьСтрокиНаСервере()
	
	КопированиеСтрокСервер.ПоместитьВыделенныеСтрокиВБуферОбмена(Элементы.Товары.ВыделенныеСтроки, Объект.Товары);
	
КонецПроцедуры

&НаСервере
Процедура ПолучитьСтрокиИзБуфераОбмена()
	
	МассивТиповНоменклатуры = Новый Массив;
	МассивТиповНоменклатуры.Добавить(ПредопределенноеЗначение("Перечисление.ТипыНоменклатуры.Товар"));
	МассивТиповНоменклатуры.Добавить(ПредопределенноеЗначение("Перечисление.ТипыНоменклатуры.ПодарочныйСертификат"));
	
	ПараметрыОтбора = Новый Структура();
	ПараметрыОтбора.Вставить("ОтборПоТипуНоменклатуры", МассивТиповНоменклатуры);
	
	ТаблицаТоваров = КопированиеСтрокСервер.СтрокиИзБуфераОбмена(ПараметрыОтбора);
	
	Для каждого СтрокаТовара Из ТаблицаТоваров Цикл
		
		ТекущаяСтрока = Объект.Товары.Добавить();
		ЗаполнитьЗначенияСвойств(ТекущаяСтрока, СтрокаТовара);
		
		СтруктураДействий = Новый Структура;
		СтруктураДействий.Вставить("ПроверитьХарактеристикуПоВладельцу", ТекущаяСтрока.Характеристика);
		СтруктураДействий.Вставить("ПроверитьЗаполнитьУпаковкуПоВладельцу" , ТекущаяСтрока.Упаковка);
		СтруктураДействий.Вставить("ПересчитатьКоличествоЕдиниц");
		Если ИспользоватьАссортимент Тогда
			СтруктураПроверкиАссортимента = АссортиментКлиентСервер.ПараметрыПроверкиАссортимента(Объект, , , , "МагазинПолучатель");
			СтруктураПроверкиАссортимента.Магазин = Объект.МагазинПолучатель;
			СтруктураПроверкиАссортимента.Дата = ?(ЗначениеЗаполнено(Объект.ЖелаемаяДатаПоступления),
			Объект.ЖелаемаяДатаПоступления,
			Объект.Дата);
			СтруктураПроверкиАссортимента.ТекстСообщения =
			НСтр("ru = 'Номенклатура ""%1"" не включена в ассортимент магазина-получателя или запрещена к закупке. Заказывать ее не рекомендуется.'");
			СтруктураДействий.Вставить("ПроверитьАссортиментСтроки", СтруктураПроверкиАссортимента);
		КонецЕсли;
		
		КэшированныеЗначения = ОбработкаТабличнойЧастиТоварыКлиентСервер.СтруктураКэшируемыхЗначений();
		ОбработкаТабличнойЧастиТоварыСервер.ОбработатьСтрокуТЧСервер(ТекущаяСтрока, СтруктураДействий, КэшированныеЗначения);		
		
	КонецЦикла;
	
	КопированиеСтрокСервер.ОчиститьБуферОбмена();
	
КонецПроцедуры

&НаСервере
Процедура УстановитьДоступностьКомандБуфераОбмена()
	
	МассивЭлементов = Новый Массив();
	МассивЭлементов.Добавить("ТоварыВставитьСтроки");
	
	ОбщегоНазначенияРТКлиентСервер.УстановитьСвойствоЭлементовФормы(Элементы, МассивЭлементов, "Доступность", 
		НЕ ОбщегоНазначения.ПустойБуферОбмена("Строки"));
		
КонецПроцедуры

#КонецОбласти

#КонецОбласти
