#Область ПрограммныйИнтерфейс
&НаКлиенте
Процедура ОповещениеВыборВладельца(РезультатВыбора, ДополнительныеПараметры) Экспорт
	
	Если НЕ РезультатВыбора = Неопределено Тогда
		Объект.ВладелецСерии = РезультатВыбора;
		ВладелецСерииПриИзменении(Элементы.ВладелецСерии);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОповещениеВыборИзСписка(РезультатВыбора, ДополнительныеПараметры) Экспорт
	Если НЕ РезультатВыбора = Неопределено Тогда
		Если РезультатВыбора = ДополнительныеПараметры.СписокВыбора.НайтиПоЗначению(НСтр("ru = 'Вид номенклатуры'")) Тогда
			ПараметрыОтбора = Новый Структура;
			ПараметрыОтбора.Вставить("ИспользованиеСерий", ПредопределенноеЗначение("Перечисление.ВариантыВеденияДополнительныхДанныхПоНоменклатуре.ОбщиеДляВидаНоменклатуры"));
			ПараметрыФормы = Новый Структура;
			ПараметрыФормы.Вставить("Отбор", ПараметрыОтбора);
			
			ОткрытьФорму("Справочник.ВидыНоменклатуры.ФормаВыбора",
							ПараметрыФормы,
							ЭтотОбъект,,,,
							Новый ОписаниеОповещения("ОповещениеВыборВладельца", ЭтотОбъект),
							РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
		Иначе
			ПараметрыОтбора = Новый Структура;
			ПараметрыОтбора.Вставить("ВидыНоменклатур", ВидыНоменклатурыИндивидуальныеДляНоменклатуры());
			
			ПараметрыФормы = Новый Структура;
			ПараметрыФормы.Вставить("СтруктураПараметрыОтбора", ПараметрыОтбора);
			ОткрытьФорму("Справочник.Номенклатура.ФормаВыбора",
							ПараметрыФормы,
							ЭтотОбъект,,,,
							Новый ОписаниеОповещения("ОповещениеВыборВладельца", ЭтотОбъект),
							РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Объект.ВладелецСерии) Тогда
		Элементы.ВладелецСерии.ТолькоПросмотр = Ложь;
		Возврат;
	КонецЕсли; 
		
	Элементы.ВладелецСерии.ТолькоПросмотр = Истина;
	Если НЕ ЗначениеЗаполнено(Объект.Ссылка)  Тогда
		ОпределитьВидНоменклатуры = Истина;
	Иначе
		ОпределитьВидНоменклатуры = Ложь;
	КонецЕсли;
	
	УстановитьНастройкиПоШаблону(ОпределитьВидНоменклатуры);
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	СтруктураОповещения = Новый Структура;
	СтруктураОповещения.Вставить("Номер", Объект.Номер);
	СтруктураОповещения.Вставить("ГоденДо", Объект.ГоденДо);
	
	Оповестить("Запись_СерииНоменклатуры", СтруктураОповещения, Объект.Ссылка);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ВладелецСерииПриИзменении(Элемент)
	УстановитьНастройкиПоШаблону(Истина);
КонецПроцедуры

&НаКлиенте
Процедура ВладелецСерииНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	СписокВыбора = Новый СписокЗначений;
	СписокВыбора.Добавить(НСтр("ru = 'Вид номенклатуры'"));
	СписокВыбора.Добавить(НСтр("ru = 'Позиция номенклатуры'"));
	
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("СписокВыбора", СписокВыбора);
	
	ОбработчикОповещения = Новый ОписаниеОповещения("ОповещениеВыборИзСписка", ЭтотОбъект, ДополнительныеПараметры);
	Режим = РежимОткрытияОкнаФормы.БлокироватьВесьИнтерфейс;
	
	ПоказатьВыборИзСписка(ОбработчикОповещения, СписокВыбора, Элементы.ВладелецСерии);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

// СтандартныеПодсистемы.Свойства

&НаКлиенте
Процедура Подключаемый_СвойстваВыполнитьКоманду(ЭлементИлиКоманда, НавигационнаяСсылка = Неопределено, СтандартнаяОбработка = Неопределено)
	УправлениеСвойствамиКлиент.ВыполнитьКоманду(ЭтотОбъект, ЭлементИлиКоманда, СтандартнаяОбработка);
КонецПроцедуры

// Конец СтандартныеПодсистемы.Свойства

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьНастройкиПоШаблону(ОпределитьВидНоменклатуры = Ложь)
	
	Если ОпределитьВидНоменклатуры Тогда
		Объект.ВидНоменклатуры = Справочники.СерииНоменклатуры.ЗаполнитьВидНоменклатуры(Объект.ВладелецСерии);
	КонецЕсли;
	
	ВидНоменклатуры = Объект.ВидНоменклатуры;
	
	Если НЕ ЗначениеЗаполнено(ВидНоменклатуры) Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыШаблона = Новый ФиксированнаяСтруктура(
		ЗначениеНастроекПовтИсп.ПараметрыСерийНоменклатуры(ВидНоменклатуры, Объект.ВладелецСерии));
	
	Элементы.ГоденДо.Видимость = ПараметрыШаблона.ИспользоватьСрокГодностиСерии;
	Если ПараметрыШаблона.ИспользоватьСрокГодностиСерии Тогда
		Элементы.ГоденДо.Формат               = ПараметрыШаблона.ФорматнаяСтрокаСрокаГодности;
		Элементы.ГоденДо.ФорматРедактирования = ПараметрыШаблона.ФорматнаяСтрокаСрокаГодности;
	КонецЕсли;
		
	Если ПараметрыШаблона.ИспользоватьДатуПроизводстваСерии Тогда
		Элементы.ДатаПроизводства.Формат               = ПараметрыШаблона.ФорматнаяСтрокаСрокаГодности;
		Элементы.ДатаПроизводства.ФорматРедактирования = ПараметрыШаблона.ФорматнаяСтрокаСрокаГодности;
	КонецЕсли;
	
	Элементы.Номер.Видимость   = ПараметрыШаблона.ИспользоватьНомерСерии;
	
	МожноМенятьНомер = НЕ ПараметрыШаблона.ИспользоватьRFIDМеткиСерии
						Или НЕ ((ЗначениеЗаполнено(Объект.RFIDTID)
							Или ЗначениеЗаполнено(Объект.RFIDEPC))
						И НЕ Объект.RFIDМеткаНеЧитаемая);

	Элементы.Номер.ТолькоПросмотр = Не МожноМенятьНомер;
	
	Элементы.НомерКИЗГИСМ.Видимость = ПараметрыШаблона.ИспользоватьНомерКИЗГИСМСерии;
	
	Элементы.RFIDTID.Видимость  = ПараметрыШаблона.ИспользоватьRFIDМеткиСерии;
	Элементы.RFIDUser.Видимость = ПараметрыШаблона.ИспользоватьRFIDМеткиСерии;
	Элементы.RFIDEPC.Видимость  = ПараметрыШаблона.ИспользоватьRFIDМеткиСерии;
	Элементы.EPCGTIN.Видимость  = ПараметрыШаблона.ИспользоватьRFIDМеткиСерии;
	Элементы.RFIDМеткаНеЧитаемая.Видимость  = ПараметрыШаблона.ИспользоватьRFIDМеткиСерии;
	
	Элементы.RFIDTID.ТолькоПросмотр  = Истина;
	Элементы.RFIDUser.ТолькоПросмотр = Истина;
	Элементы.RFIDEPC.ТолькоПросмотр  = Истина;
	Элементы.EPCGTIN.ТолькоПросмотр  = Истина;
	Элементы.RFIDМеткаНеЧитаемая.ТолькоПросмотр = Истина;
	
	Элементы.ДатаПроизводства.Видимость   = ПараметрыШаблона.ИспользоватьДатуПроизводстваСерии;
	Элементы.ПроизводительЕГАИС.Видимость = ПараметрыШаблона.ИспользоватьПроизводителяЕГАИССерии;
	Элементы.Справка2ЕГАИС.Видимость      = ПараметрыШаблона.ИспользоватьСправку2ЕГАИССерии;
	
	Если ЗначениеЗаполнено(Объект.ВладелецСерии) Тогда
		Если ТипЗнч(Объект.ВладелецСерии) = Тип("СправочникСсылка.ВидыНоменклатуры") Тогда
			Элементы.ВладелецСерии.Заголовок = НСтр("ru = 'Вид номенклатуры'");
		ИначеЕсли ТипЗнч(Объект.ВладелецСерии) = Тип("СправочникСсылка.Номенклатура") Тогда
			Элементы.ВладелецСерии.Заголовок = НСтр("ru = 'Номенклатура'");
		Иначе
			Элементы.ВладелецСерии.Заголовок = НСтр("ru = 'Владелец'");
		КонецЕсли;
	Иначе
		Элементы.ВладелецСерии.Заголовок = НСтр("ru = 'Владелец'");
	КонецЕсли;
	
	
КонецПроцедуры

&НаСервере
Функция ВидыНоменклатурыИндивидуальныеДляНоменклатуры()

	Возврат Справочники.СерииНоменклатуры.ВидыНоменклатурыИндивидуальныеДляНоменклатуры()

КонецФункции // ВидыНоменклатурыИндивидуальныеДляНоменклатуры()

#КонецОбласти