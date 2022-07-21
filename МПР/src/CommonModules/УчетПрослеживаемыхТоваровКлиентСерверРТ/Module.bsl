
#Область ПрограммныйИнтерфейс

// Дополняет структуру действий пересчета строки табличной части, с целью заполнения признака 'ВедетсяУчетПоРНПТ'.
//
// Параметры:
//  СтруктураДействий		 - Структура - описывает действия, где:
//  	* Ключ - Строка - наименование действия.
//  	* Значение - Структура - параметры действия.
//  ИмяПоляВедетсяУчетПоРНПТ - Строка - соответствующее имя реквизита формы табличной части.
//
Процедура ДополнитьОписаниеНастроекЗаполненияСлужебныхРеквизитовТабличнойЧасти(СтруктураДействий,
	ИмяПоляВедетсяУчетПоРНПТ = "ВедетсяУчетПоРНПТ") Экспорт
	
	СтруктураДействий.Вставить("ЗаполнитьПризнакВедетсяУчетПоРНПТ", Новый Структура("Номенклатура", ИмяПоляВедетсяУчетПоРНПТ));
	
КонецПроцедуры

// Возвращает структуру, содержащую поля значений, используемых для заполнения количества по РНПТ в строках табличной
// части документа.
//
// Параметры:
//	Объект - ДанныеФормыСтруктура - данные формы объекта.
//	ИмяПоляМестоХранения - Строка - имя поля Склад или другого места хранения, находящегося в шапке объекта или табличной части.
//	МестоХраненияВТабличнойЧасти - Булево - признак наличия поля Склад или другого места хранения в табличной части объекта.
//
// Возвращаемое значение:
//	Структура - содержит следующие свойства:
//		* ИсключаемыйДокумент - ДокументСсылка - документ, движения которого исключаются при расчета коэффициента по РНПТ.
//		* Организация - СправочникСсылка.Организации - организация, для которой рассчитывается коэффициент по РНПТ.
//		* МестоХраненияВТабличнойЧасти - Булево - признак наличия поля Склад или другого места хранения в табличной части объекта.
//		* ИмяПоляМестоХранения - Строка - имя поля Склад или другого места хранения, находящегося в шапке объекта или табличной части.
//		* МестоХранения - СправочникСсылка.Склады - склад или другое место хранения, для которого рассчитывается коэффициент по РНПТ.
//
Функция ПараметрыПолученияКоэффициентаРНПТ(Объект, ИмяПоляМестоХранения = "Склад", МестоХраненияВТабличнойЧасти = Ложь) Экспорт
	
	СтруктураЗаполненияКоэффициентаРНПТ = Новый Структура;
	СтруктураЗаполненияКоэффициентаРНПТ.Вставить("Дата",							Объект.Дата);
	СтруктураЗаполненияКоэффициентаРНПТ.Вставить("ИсключаемыйДокумент",				Объект.Ссылка);
	
	Если ИмяПоляМестоХранения = "СкладПолучатель" Тогда
		СтруктураЗаполненияКоэффициентаРНПТ.Вставить("Организация",						Объект.ОрганизацияПолучатель);
	Иначе
		СтруктураЗаполненияКоэффициентаРНПТ.Вставить("Организация",						Объект.Организация);
	КонецЕсли;
	
	СтруктураЗаполненияКоэффициентаРНПТ.Вставить("МестоХраненияВТабличнойЧасти",	МестоХраненияВТабличнойЧасти);
	СтруктураЗаполненияКоэффициентаРНПТ.Вставить("ИмяПоляМестоХранения",			ИмяПоляМестоХранения);
	СтруктураЗаполненияКоэффициентаРНПТ.Вставить("МестоХранения",					Неопределено);
	
	Если Не МестоХраненияВТабличнойЧасти Тогда
		СтруктураЗаполненияКоэффициентаРНПТ.Вставить("МестоХранения", Объект[ИмяПоляМестоХранения]);
	КонецЕсли;
	
	Возврат СтруктураЗаполненияКоэффициентаРНПТ;
	
КонецФункции

// Дополняет структуру действий пересчета строки табличной части, с целью пересчета поля 'КоличествоПоРНПТ'.
//
// Параметры:
//	Объект - ДанныеФормыСтруктура - данные формы объекта.
//	СтруктураДействий - Структура - описывает действия, где Ключ - наименование действия,
//									Значение - Структура - параметры действия.
//	ИмяПоляМестоХранения - Строка - имя поля Склад или другого места хранения, находящегося в шапке объекта или табличной части.
//	МестоХраненияВТабличнойЧасти - Булево - признак наличия поля Склад или другого места хранения в табличной части объекта.
//
Процедура ДополнитьОписаниеНастроекПересчетаРеквизитовТабличнойЧасти(Объект,
																	СтруктураДействий,
																	ИмяПоляМестоХранения = "Склад",
																	МестоХраненияВТабличнойЧасти = Ложь) Экспорт
	
	СтруктураПересчетаКоличестваРНПТ = ПараметрыПолученияКоэффициентаРНПТ(Объект, ИмяПоляМестоХранения, МестоХраненияВТабличнойЧасти);
	
	СтруктураДействий.Вставить("ПересчитатьКоличествоПоРНПТ", СтруктураПересчетаКоличестваРНПТ);
	
КонецПроцедуры

// Возвращает значение коэффициента по РНПТ для текущей строки табличной части объекта по заданным параметрам.
//
// Параметры:
//	ПараметрыПересчета - Структура - см. УчетПрослеживаемыхТоваровКлиентСерверРТ.ПараметрыПолученияКоэффициентаРНПТ().
//	ТекущаяСтрока - Структура - строка табличной части для которой выполняется расчет коэффициента по РНПТ.
//	КэшированныеЗначения - Структура - кэшированные значения текущей строки табличной части.
//
// Возвращаемое значение:
//	Число - коэффициент по РНПТ.
//
Функция КоэффициентРНПТ(ПараметрыПересчета, ТекущаяСтрока, КэшированныеЗначения) Экспорт
	
	Результат = 0;
	
	ИсключаемыйДокумент	= ПараметрыПересчета.ИсключаемыйДокумент;
	Организация			= ПараметрыПересчета.Организация;
	Номенклатура		= ТекущаяСтрока.Номенклатура;
	Характеристика		= ТекущаяСтрока.Характеристика;
	МестоХранения		= ?(ПараметрыПересчета.МестоХраненияВТабличнойЧасти,
							ТекущаяСтрока[ПараметрыПересчета.ИмяПоляМестоХранения],
							ПараметрыПересчета.МестоХранения);
	НомерГТД			= ТекущаяСтрока.НомерГТД;
	
	КлючКоэффициента	= КлючКэшаКоэффициентРНПТ(Организация, Номенклатура, Характеристика, МестоХранения, НомерГТД);
	Кэш					= КэшированныеЗначения.КоэффициентыРНПТ[КлючКоэффициента];
	
	Если Кэш = Неопределено Тогда
		#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
			
			Если УчетПрослеживаемыхТоваровРТ.ИспользоватьУчетПрослеживаемыхИмпортныхТоваров(ПараметрыПересчета.Дата) Тогда
				
				Товары = Новый ТаблицаЗначений;
				Товары.Колонки.Добавить("Номенклатура",		Новый ОписаниеТипов("СправочникСсылка.Номенклатура"));
				Товары.Колонки.Добавить("Характеристика",	Новый ОписаниеТипов("СправочникСсылка.ХарактеристикиНоменклатуры"));
				Товары.Колонки.Добавить("МестоХранения",	Новый ОписаниеТипов("СправочникСсылка.Склады, СправочникСсылка.ДоговорыКонтрагентов"));
				Товары.Колонки.Добавить("НомерГТД",			Новый ОписаниеТипов("СправочникСсылка.НомераГТД"));
				
				Строка = Товары.Добавить();
				Строка.Номенклатура		= Номенклатура;
				Строка.Характеристика	= Характеристика;
				Строка.МестоХранения	= МестоХранения;
				Строка.НомерГТД			= НомерГТД;
				
				ЗначенияРеквизитов = ОбработкаТабличнойЧастиТоварыСервер.КоэффициентРНПТ(ИсключаемыйДокумент,
																							Организация,
																							Товары,
																							КэшированныеЗначения);
				
				Если ЗначенияРеквизитов.Количество() > 0 Тогда
					Результат = ЗначенияРеквизитов[0].Коэффициент;
				КонецЕсли;
				
			КонецЕсли;
			
		#Иначе
			
			ТекстИсключения = НСтр("ru = 'Попытка получения коэффициента по РНПТ на клиенте.'");
			
			ВызватьИсключение ТекстИсключения;
			
		#КонецЕсли
	Иначе
		Результат = Кэш;
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

// Вызывается после разбиения строки, для корректного распределения количества по РНПТ.
// 
// Параметры:
// 	НоваяСтрока - ДанныеФормыЭлементКоллекции - строка табличной части после выполнения разбиения.
// 	ДополнительныеПараметры - Структура - со следующими ключами:
// 		* ИсходнаяСтрока - ДанныеФормыЭлементКоллекции - ссылка на строку табличной части, которую разбиваем.
// 		* ИсходноеКоличество - Число - количество исходной строки, до разбиения.
//
Процедура РазбитьСтрокуЗавершение(НоваяСтрока, ДополнительныеПараметры) Экспорт
	
	Если НоваяСтрока <> Неопределено Тогда
		
		Если ДополнительныеПараметры = Неопределено
			Или Не ДополнительныеПараметры.Свойство("ИсходнаяСтрока")
			Или Не ДополнительныеПараметры.Свойство("ИсходноеКоличество") Тогда
			ТекстОшибки = НСтр("ru='УчетПрослеживаемыхТоваровРТ.РазбитьСтрокуЗавершение, входящий параметр ДополнительныеПараметры задан некорректно.'");
			ВызватьИсключение ТекстОшибки;
		КонецЕсли;
		
		ИсходноеКоличество = ДополнительныеПараметры.ИсходноеКоличество;
		ИсходноеКоличествоПоРНПТ = ДополнительныеПараметры.ИсходноеКоличествоРНПТ;
		ИсходнаяСтрока = ДополнительныеПараметры.ИсходнаяСтрока;
		
		Если ИсходноеКоличество <> 0 Тогда
			КоэффициентРазбиения = ИсходнаяСтрока.Количество / ИсходноеКоличество;
			
			ИсходнаяСтрока.КоличествоПоРНПТ = ИсходноеКоличествоПоРНПТ * КоэффициентРазбиения;
			НоваяСтрока.КоличествоПоРНПТ = ИсходноеКоличествоПоРНПТ - ИсходнаяСтрока.КоличествоПоРНПТ;
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

// Дополняет (или создает) структуру содержащую необходимую информацию
// для разбиения строки табличной части, с учетом количества по РНПТ.
//
// Параметры:
//  ТекущаяСтрока - Структура - выделенная строка табличной части.
//  ДополнительныеПараметры - Структура - одноименноый входящий параметр объекта ОписаниеОповещения.
//
Функция ДополнитьОписаниеПараметровРазбиенияСтрокиТабличнойЧасти(ТекущаяСтрока,
	ДополнительныеПараметры = Неопределено) Экспорт
	
	Если Не ЗначениеЗаполнено(ДополнительныеПараметры) Тогда
		ДополнительныеПараметры = Новый Структура();
	КонецЕсли;
	
	Если ТекущаяСтрока <> Неопределено Тогда
		ДополнительныеПараметры.Вставить("ИсходноеКоличество", ТекущаяСтрока.Количество);
		ДополнительныеПараметры.Вставить("ИсходноеКоличествоРНПТ", ТекущаяСтрока.КоличествоПоРНПТ);
		ДополнительныеПараметры.Вставить("ИсходнаяСтрока", ТекущаяСтрока);
	КонецЕсли;
	
	Возврат ДополнительныеПараметры;
	
КонецФункции

#КонецОбласти

#Область СлужебныйИнтерфейс

Функция КлючКэшаКоэффициентРНПТ(Организация, Номенклатура, Характеристика, МестоХранения, НомерГТД) Экспорт
	
	Если ЗначениеЗаполнено(Организация) Тогда
		КлючОрганизация = Строка(Организация.УникальныйИдентификатор());
	Иначе
		КлючОрганизация = "ПустоеЗначение";
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Номенклатура) Тогда
		КлючНоменклатура = Строка(Номенклатура.УникальныйИдентификатор());
	Иначе
		КлючНоменклатура = "ПустоеЗначение";
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Характеристика) Тогда
		КлючХарактеристика = Строка(Характеристика.УникальныйИдентификатор());
	Иначе
		КлючХарактеристика = "ПустоеЗначение";
	КонецЕсли;
	
	Если ЗначениеЗаполнено(МестоХранения) Тогда
		КлючМестоХранения = Строка(МестоХранения.УникальныйИдентификатор());
	Иначе
		КлючМестоХранения = "ПустоеЗначение";
	КонецЕсли;
	
	Если ЗначениеЗаполнено(НомерГТД) Тогда
		КлючНомерГТД = Строка(НомерГТД.УникальныйИдентификатор());
	Иначе
		КлючНомерГТД = "ПустоеЗначение";
	КонецЕсли;
	
	Возврат КлючОрганизация + КлючНоменклатура + КлючХарактеристика + КлючМестоХранения + КлючНомерГТД;
	
КонецФункции

#КонецОбласти