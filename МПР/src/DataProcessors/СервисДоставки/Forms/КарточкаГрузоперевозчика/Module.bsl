
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Не СервисДоставки.ПравоРаботыССервисомДоставки(Истина) Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	Параметры.Свойство("Идентификатор", Идентификатор);
	Параметры.Свойство("ОрганизацияБизнесСетиСсылка", ОрганизацияБизнесСетиСсылка);
	Параметры.Свойство("ТипГрузоперевозки", ТипГрузоперевозки);
	
	Если НЕ ЗначениеЗаполнено(ТипГрузоперевозки) Тогда
		ОбщегоНазначения.СообщитьПользователю(НСтр("ru = 'Не выбран тип грузоперевозки'"));
		Отказ = Истина;
		Возврат;
	ИначеЕсли НЕ СервисДоставки.ТипГрузоперевозкиДоступен(ТипГрузоперевозки) Тогда
		ОбщегоНазначения.СообщитьПользователю(НСтр("ru = 'Выбранный тип грузоперевозки не доступен'"));
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	НастроитьФормуПоТипуГрузоперевозки();
	
	СервисДоставкиСлужебный.ПроверитьОрганизациюБизнесСети(ОрганизацияБизнесСетиСсылка, Отказ);
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	УстановитьВидимостьДоступность();
	
	// Запуск фонового задания для загрузки доступных форм.
	ФоновоеЗаданиеПолучитьДанныеГрузоперевозчика = ПолучитьДанныеГрузоперевозчикаВФоне();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если ЗначениеЗаполнено(ФоновоеЗаданиеПолучитьДанныеГрузоперевозчика) Тогда
		
		ПараметрыОперации = Новый Структура("ИмяПроцедуры, НаименованиеОперации, ВыводитьОкноОжидания");
		ПараметрыОперации.ИмяПроцедуры = СервисДоставкиКлиентСервер.ИмяПроцедурыПолучитьДанныеГрузоперевозчика();
		ПараметрыОперации.НаименованиеОперации = НСтр("ru = 'Получение заказов на доставку.'");
		
		ОжидатьЗавершениеВыполненияЗапроса(ПараметрыОперации);
		
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаКлиенте
Процедура КарточкаГрузоперевозчикаОбработкаРасшифровки(Элемент, Расшифровка, СтандартнаяОбработка,
	ДополнительныеПараметры)
	
	СтандартнаяОбработка = Ложь;
	
	Если Расшифровка = "АдресСайта" Тогда
		
		ПоказатьСайтГрузоперевозчика();
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ТарифыВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ОткрытьФормуТарифа(ВыбраннаяСтрока);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗакрытьФорму(Команда)
	
	Закрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьТарифПоУмолчанию(Команда)
	
	ТекущиеДанные = Элементы.Тарифы.ТекущиеДанные;
	
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыОперации = Новый Структура("ИмяПроцедуры, НаименованиеОперации, ВыводитьОкноОжидания");
	ПараметрыОперации.ИмяПроцедуры = СервисДоставкиКлиентСервер.ИмяПроцедурыУстановитьТарифПоУмолчанию();
	НаименованиеОперации = НСтр("ru = 'Установка тарифа по умолчанию'");
	ПараметрыОперации.НаименованиеОперации = НаименованиеОперации;
	ПараметрыОперации.ВыводитьОкноОжидания = Истина;
	ПараметрыОперации.Вставить("ГрузоперевозчикИдентификатор", Идентификатор);
	ПараметрыОперации.Вставить("ТарифИдентификатор", ТекущиеДанные.ТарифИдентификатор);
	ПараметрыОперации.Вставить("ВыводитьОкноОжидания", Истина);
	ВыполнитьЗапрос(ПараметрыОперации);
	
КонецПроцедуры

&НаКлиенте
Процедура СброситьТарифПоУмолчанию(Команда)
	
	ТекущиеДанные = Элементы.Тарифы.ТекущиеДанные;
	
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если Не ТекущиеДанные.ПоУмолчанию Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыОперации = Новый Структура("ИмяПроцедуры, НаименованиеОперации, ВыводитьОкноОжидания");
	ПараметрыОперации.ИмяПроцедуры = СервисДоставкиКлиентСервер.ИмяПроцедурыСброситьТарифПоУмолчанию();
	НаименованиеОперации = НСтр("ru = 'Сброс тарифа по умолчанию'");
	ПараметрыОперации.НаименованиеОперации = НаименованиеОперации;
	ПараметрыОперации.ВыводитьОкноОжидания = Истина;
	ПараметрыОперации.Вставить("ГрузоперевозчикИдентификатор", Идентификатор);
	ПараметрыОперации.Вставить("ТарифИдентификатор", "");
	ПараметрыОперации.Вставить("ВыводитьОкноОжидания", Истина);
	ВыполнитьЗапрос(ПараметрыОперации);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ВыполнитьЗапрос

&НаКлиенте
Процедура ВыполнитьЗапрос(ПараметрыОперации)
	
	ИнтернетПоддержкаПодключена = Ложь;
	ОчиститьСообщения();
	
	ИмяФоновогоЗадания = "ФоновоеЗадание" + ПараметрыОперации.ИмяПроцедуры;
	ФоновоеЗадание = ВыполнитьЗапросВФоне(ИнтернетПоддержкаПодключена, ПараметрыОперации);
	ЭтотОбъект[ИмяФоновогоЗадания] = ФоновоеЗадание;
	
	Если ИнтернетПоддержкаПодключена = Ложь Тогда
		
		// Загрузка с проверкой подключения интернет-поддержки.
		Оповещение = Новый ОписаниеОповещения("ВыполнитьЗапросПродолжение", ЭтотОбъект, ПараметрыОперации);
		ИнтернетПоддержкаПользователейКлиент.ПодключитьИнтернетПоддержкуПользователей(Оповещение, ЭтотОбъект);
		Возврат;
		
	Иначе
		
		ПараметрыОперации.Вставить("ФоновоеЗадание", ФоновоеЗадание);
		ВыполнитьЗапросПродолжение(Истина, ПараметрыОперации);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьЗапросПродолжение(Результат, ДополнительныеПараметры) Экспорт
	
	ИмяФоновогоЗадания = "ФоновоеЗадание"+ ДополнительныеПараметры.ИмяПроцедуры;
	
	Если Результат = Неопределено Тогда
		ТекстСообщения = НСтр("ru = 'Отсутствует подключение к Интернет-поддержке пользователей.'");
		ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения);
		Возврат;
	ИначеЕсли ТипЗнч(Результат) = Тип("Структура")
		И Результат.Свойство("Логин") Тогда
		// Повторный вызов метода после подключения к Интернет-поддержке.
		ИнтернетПоддержкаПодключена = Ложь;
		ЭтотОбъект[ИмяФоновогоЗадания] = ВыполнитьЗапросВФоне(ИнтернетПоддержкаПодключена, ДополнительныеПараметры);
		ДополнительныеПараметры.Добавить("ФоновоеЗадание", ЭтотОбъект[ИмяФоновогоЗадания]);
	КонецЕсли;
	
	Если ЭтотОбъект[ИмяФоновогоЗадания] = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если ЭтотОбъект[ИмяФоновогоЗадания].Статус = "Выполняется" Тогда
		
		ОжидатьЗавершениеВыполненияЗапроса(ДополнительныеПараметры);
		
	ИначеЕсли ЭтотОбъект[ИмяФоновогоЗадания].Статус = "Выполнено" Тогда
		
		ВыполнитьЗапросЗавершение(ЭтотОбъект[ИмяФоновогоЗадания], ДополнительныеПараметры);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОжидатьЗавершениеВыполненияЗапроса(ПараметрыОперации)
	
	ВыводитьОкноОжидания = ?(ЗначениеЗаполнено(ПараметрыОперации.ВыводитьОкноОжидания), 
																	ПараметрыОперации.ВыводитьОкноОжидания,
																	Ложь);
	// Установка картинки длительной операции.
	Если Не ВыводитьОкноОжидания Тогда
		
		Если ПараметрыОперации.ИмяПроцедуры = СервисДоставкиКлиентСервер.ИмяПроцедурыПолучитьДанныеГрузоперевозчика() Тогда
			
			Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.ГруппаОжиданиеЗагрузки;
			
		КонецЕсли;
		
	КонецЕсли;
	
	// Инициализация обработчик ожидания завершения.
	ИмяФоновогоЗадания = "ФоновоеЗадание" + ПараметрыОперации.ИмяПроцедуры;
	ФоновоеЗадание = ЭтотОбъект[ИмяФоновогоЗадания];
	ПараметрыОперации.Вставить("ФоновоеЗадание", ФоновоеЗадание);
	
	ПараметрыОжидания = ДлительныеОперацииКлиент.ПараметрыОжидания(ЭтотОбъект);
	ПараметрыОжидания.ТекстСообщения = ПараметрыОперации.НаименованиеОперации;
	ПараметрыОжидания.ВыводитьПрогрессВыполнения = Ложь;
	ПараметрыОжидания.ВыводитьОкноОжидания = ВыводитьОкноОжидания;
	ПараметрыОжидания.ОповещениеПользователя.Показать = Ложь;
	ПараметрыОжидания.ВыводитьСообщения = Истина;
	ПараметрыОжидания.Вставить("ИдентификаторЗадания", ФоновоеЗадание.ИдентификаторЗадания);
	
	ОбработкаЗавершения = Новый ОписаниеОповещения("ВыполнитьЗапросЗавершение",
		ЭтотОбъект, ПараметрыОперации);
		
	ДлительныеОперацииКлиент.ОжидатьЗавершение(ФоновоеЗадание, ОбработкаЗавершения, ПараметрыОжидания);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьЗапросЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	// Инициализация.
	Отказ = Ложь;
	ИмяФоновогоЗадания = "ФоновоеЗадание" + ДополнительныеПараметры.ИмяПроцедуры;
	ФоновоеЗадание = ЭтотОбъект[ИмяФоновогоЗадания];
	
	// Скрыть элементы ожидания на форме
	Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.ГруппаОсновная;
	
	// Вывод сообщений из фонового задания.
	СервисДоставкиКлиент.ОбработатьРезультатФоновогоЗадания(Результат, ДополнительныеПараметры, Отказ);
	Если Результат = Неопределено ИЛИ ФоновоеЗадание = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	// Проверка результата поиска.
	Если Не Отказ И Результат.Статус = "Выполнено" Тогда
		Если ЗначениеЗаполнено(Результат.АдресРезультата)
			И ЭтоАдресВременногоХранилища(Результат.АдресРезультата) 
			И ДополнительныеПараметры.ФоновоеЗадание.ИдентификаторЗадания 
			= ЭтотОбъект[ИмяФоновогоЗадания].ИдентификаторЗадания Тогда
			
			Если ДополнительныеПараметры.ИмяПроцедуры 
				= СервисДоставкиКлиентСервер.ИмяПроцедурыПолучитьДанныеГрузоперевозчика() Тогда
				
				// Загрузка результатов запроса.
				ОперацияВыполнена = Истина;
				ЗагрузитьРезультатПолученияДанныхГрузоперевозчика(Результат.АдресРезультата, ОперацияВыполнена);
				ЭтотОбъект[ИмяФоновогоЗадания] = Неопределено;
				
			ИначеЕсли ДополнительныеПараметры.ИмяПроцедуры 
				= СервисДоставкиКлиентСервер.ИмяПроцедурыУстановитьТарифПоУмолчанию() Тогда
				
				ОперацияВыполнена = Истина;
				ЗагрузитьРезультатУстановкиТарифаПоУмолчанию(Результат.АдресРезультата, ОперацияВыполнена);
				ЭтотОбъект[ИмяФоновогоЗадания] = Неопределено;
				
			ИначеЕсли ДополнительныеПараметры.ИмяПроцедуры 
				= СервисДоставкиКлиентСервер.ИмяПроцедурыСброситьТарифПоУмолчанию() Тогда
				
				ОперацияВыполнена = Истина;
				ЗагрузитьРезультатСбросаТарифаПоУмолчанию(Результат.АдресРезультата, ОперацияВыполнена);
				ЭтотОбъект[ИмяФоновогоЗадания] = Неопределено;
				
			КонецЕсли;
				
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ВыполнитьЗапросВФоне

&НаСервере
Функция ВыполнитьЗапросВФоне(ИнтернетПоддержкаПодключена, ПараметрыОперации)
	
	// Проверка подключения Интернет-поддержки пользователей.
	ИнтернетПоддержкаПодключена 
		= ИнтернетПоддержкаПользователей.ЗаполненыДанныеАутентификацииПользователяИнтернетПоддержки();
	Если Не ИнтернетПоддержкаПодключена Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Отказ = Ложь;
	ПараметрыЗапроса = ПараметрыЗапроса(ПараметрыОперации, Отказ);
	
	Если Отказ Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	ИмяФоновогоЗадания = "ФоновоеЗадание" + ПараметрыОперации.ИмяПроцедуры;
	ФоновоеЗадание = ЭтотОбъект[ИмяФоновогоЗадания];
	Если ФоновоеЗадание <> Неопределено Тогда
		ОтменитьВыполнениеЗадания(ФоновоеЗадание.ИдентификаторЗадания);
	КонецЕсли;
	
	Задание = Новый Структура("ИмяПроцедуры, Наименование, ПараметрыПроцедуры");
	Задание.Наименование = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = '%1.'"),
		ПараметрыОперации.НаименованиеОперации);
	Задание.ИмяПроцедуры = "СервисДоставки." + ПараметрыОперации.ИмяПроцедуры;
	Задание.ПараметрыПроцедуры = ПараметрыЗапроса;
	
	ПараметрыВыполнения = ДлительныеОперации.ПараметрыВыполненияВФоне(УникальныйИдентификатор);
	ПараметрыВыполнения.НаименованиеФоновогоЗадания = Задание.Наименование;
	ПараметрыВыполнения.ОжидатьЗавершение = 0;
	
	Возврат ДлительныеОперации.ВыполнитьВФоне(Задание.ИмяПроцедуры,
		Задание.ПараметрыПроцедуры, ПараметрыВыполнения);
	
КонецФункции

&НаСервереБезКонтекста
Процедура ОтменитьВыполнениеЗадания(ИдентификаторЗадания)
	
	Если ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		ДлительныеОперации.ОтменитьВыполнениеЗадания(ИдентификаторЗадания);
		ИдентификаторЗадания = Неопределено;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ПолучитьДанныеГрузоперевозчикаВФоне()
	
	ПараметрыОперации = Новый Структура("ИмяПроцедуры, НаименованиеОперации, ВыводитьОкноОжидания");
	ПараметрыОперации.ИмяПроцедуры = СервисДоставкиКлиентСервер.ИмяПроцедурыПолучитьДанныеГрузоперевозчика();
	ПараметрыОперации.НаименованиеОперации = НСтр("ru = 'Получение данные грузоперевозчика.'");
	
	Возврат ВыполнитьЗапросВФоне(Ложь, ПараметрыОперации);
	
КонецФункции

#КонецОбласти

#Область ПараметрыЗапроса

&НаСервере
Функция ПараметрыЗапроса(ПараметрыОперации, Отказ)
	
	ПараметрыЗапроса = Новый Структура();
	
	ИмяПроцедуры = ПараметрыОперации.ИмяПроцедуры;
	
	Если ИмяПроцедуры = СервисДоставкиКлиентСервер.ИмяПроцедурыПолучитьДанныеГрузоперевозчика() Тогда
		ПараметрыЗапроса = ПараметрыЗапросаПолучитьДанныеГрузоперевозчика(ПараметрыЗапроса, Отказ);
	ИначеЕсли ИмяПроцедуры = СервисДоставкиКлиентСервер.ИмяПроцедурыУстановитьТарифПоУмолчанию() Тогда
		ПараметрыЗапроса = ПараметрыЗапросаУстановитьТарифПоУмолчанию(ПараметрыОперации, Отказ);
	ИначеЕсли ИмяПроцедуры = СервисДоставкиКлиентСервер.ИмяПроцедурыСброситьТарифПоУмолчанию() Тогда
		ПараметрыЗапроса = ПараметрыЗапросаУстановитьТарифПоУмолчанию(ПараметрыОперации, Отказ);
	КонецЕсли;
	
	ПараметрыЗапроса.Вставить("ОрганизацияБизнесСетиСсылка", ОрганизацияБизнесСетиСсылка);
	
	Возврат ПараметрыЗапроса;
	
КонецФункции

&НаСервере
Функция ПараметрыЗапросаПолучитьДанныеГрузоперевозчика(ПараметрыЗапроса, Отказ)
	
	ПараметрыЗапроса = СервисДоставки.НовыйПараметрыЗапросаПолучитьДанныеГрузоперевозчика();
	ПараметрыЗапроса.Вставить("Идентификатор", Идентификатор);
	
	Возврат ПараметрыЗапроса;

КонецФункции

&НаСервере
Функция ПараметрыЗапросаУстановитьТарифПоУмолчанию(ПараметрыОперации, Отказ)
	
	ПараметрыЗапроса = СервисДоставки.НовыйПараметрыЗапросаУстановитьТарифПоУмолчанию();
	
	ПараметрыЗапроса.Вставить("ГрузоперевозчикИдентификатор", Идентификатор);
	ПараметрыЗапроса.Вставить("ТарифИдентификатор", ПараметрыОперации.ТарифИдентификатор);
	ПараметрыЗапроса.Вставить("ТипГрузоперевозки", ТипГрузоперевозки);
	
	Возврат ПараметрыЗапроса;
	
КонецФункции

#КонецОбласти

#Область ЗагрузитьРезультаты

&НаСервере
Процедура ЗагрузитьРезультатПолученияДанныхГрузоперевозчика(АдресРезультата, ОперацияВыполнена)
	
	Если ЭтоАдресВременногоХранилища(АдресРезультата) Тогда
		Результат = ПолучитьИзВременногоХранилища(АдресРезультата);
		Если ЗначениеЗаполнено(Результат) 
			И ТипЗнч(Результат) = Тип("Структура") Тогда
			
			Если Результат.Свойство("Данные") Тогда
				ЗаполнитьЗначенияСвойств(ЭтаФорма, Результат.Данные);
				Если Результат.Данные.Свойство("ДанныеПоТарифам") Тогда
					ЗаполнитьДанныеТарифов(Результат.Данные.ДанныеПоТарифам);
				КонецЕсли;
				Если ТипГрузоперевозки = 1 Тогда
					ТексЗаголовка = НСтр("ru='1С:Доставка: %1'");
				Иначе
					ТексЗаголовка = НСтр("ru='1С:Курьер: %1'");
				КонецЕсли;
				Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					ТексЗаголовка, 
					Наименование + " (" + НСтр("ru='Перевозчик'") + ")");
			Иначе
				ОперацияВыполнена = Ложь;
			КонецЕсли;
			
			СформироватьКарточкуГрузоперевозчика();
			
			СервисДоставки.ОбработатьБлокОшибок(Результат, ОперацияВыполнена);
		Иначе
			ОперацияВыполнена = Ложь;
		КонецЕсли;
	Иначе
		ОперацияВыполнена = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗагрузитьРезультатУстановкиТарифаПоУмолчанию(АдресРезультата, ОперацияВыполнена)
	
	Если ЭтоАдресВременногоХранилища(АдресРезультата) Тогда
		Результат = ПолучитьИзВременногоХранилища(АдресРезультата);
		Если ЗначениеЗаполнено(Результат) 
			И ТипЗнч(Результат) = Тип("Структура") Тогда
			
			Если Результат.Свойство("ОперацияВыполнена") Тогда
				ОперацияВыполнена = Результат.ОперацияВыполнена;
			Иначе
				ОперацияВыполнена = Ложь;
			КонецЕсли;
			
			Для Каждого ТекущийТариф Из Тарифы Цикл
				Если ТекущийТариф.ПоУмолчанию Тогда
					ТекущийТариф.ПоУмолчанию = Ложь;
					СформироватьПредставлениеТарифа(ТекущийТариф);
				КонецЕсли;
			КонецЦикла;
			
			Если Результат.Свойство("ТарифИдентификатор") Тогда
				НайденныеСтроки = Тарифы.НайтиСтроки(Новый Структура("ТарифИдентификатор", Результат.ТарифИдентификатор));
				Если НайденныеСтроки.Количество() Тогда
					НайденныеСтроки[0].ПоУмолчанию = Истина;
					СформироватьПредставлениеТарифа(НайденныеСтроки[0]);
				КонецЕсли;
			КонецЕсли;
			
			СервисДоставки.ОбработатьБлокОшибок(Результат, ОперацияВыполнена);
		Иначе
			ОперацияВыполнена = Ложь;
		КонецЕсли;
	Иначе
		ОперацияВыполнена = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗагрузитьРезультатСбросаТарифаПоУмолчанию(АдресРезультата, ОперацияВыполнена)
	
	Если ЭтоАдресВременногоХранилища(АдресРезультата) Тогда
		Результат = ПолучитьИзВременногоХранилища(АдресРезультата);
		Если ЗначениеЗаполнено(Результат) 
			И ТипЗнч(Результат) = Тип("Структура") Тогда
			
			Если Результат.Свойство("ОперацияВыполнена") Тогда
				ОперацияВыполнена = Результат.ОперацияВыполнена;
			Иначе
				ОперацияВыполнена = Ложь;
			КонецЕсли;
			
			Для Каждого ТекущийТариф Из Тарифы Цикл
				Если ТекущийТариф.ПоУмолчанию Тогда
					ТекущийТариф.ПоУмолчанию = Ложь;
					СформироватьПредставлениеТарифа(ТекущийТариф);
				КонецЕсли;
			КонецЦикла;
			
			СервисДоставки.ОбработатьБлокОшибок(Результат, ОперацияВыполнена);
		Иначе
			ОперацияВыполнена = Ложь;
		КонецЕсли;
	Иначе
		ОперацияВыполнена = Ложь;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

&НаСервере
Процедура НастроитьФормуПоТипуГрузоперевозки();
	
	Если ТипГрузоперевозки = 1 Тогда
		Заголовок = НСтр("ru = '1C:Доставка: Перевозчик'");
	Иначе
		Заголовок = НСтр("ru = '1C:Курьер: Перевозчик'");
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура СформироватьКарточкуГрузоперевозчика()
	
	КарточкаГрузоперевозчика = ТабличныйДокументКарточкаГрузоперевозчика();
	
КонецПроцедуры

&НаСервере
Функция ТабличныйДокументКарточкаГрузоперевозчика()
	
	ТабличныйДокумент = Новый ТабличныйДокумент();
	
	Обработка = РеквизитФормыВЗначение("Объект");
	Макет = Обработка.ПолучитьМакет("Грузоперевозчик");
	
	ОбластьМакетаШапка = Макет.ПолучитьОбласть("Шапка");
	
	ПараметрыОбласти = ОбластьМакетаШапка.Параметры;
	
	ПараметрыОбласти.Наименование = НаименованиеПолное;
	ПараметрыОбласти.ЮридическийАдрес = ЮридическийАдрес;
	ПараметрыОбласти.ФизическийАдрес = ФизическийАдрес;
	ПараметрыОбласти.Телефон = Телефон;
	ПараметрыОбласти.АдресСайта = АдресСайта;
	ПараметрыОбласти.РасшифровкаАдресСайта = "АдресСайта";
	ПараметрыОбласти.Описание = Описание;
	
	ТабличныйДокумент.Вывести(ОбластьМакетаШапка);
	
	Возврат ТабличныйДокумент;
	
КонецФункции

&НаКлиенте
Процедура ПоказатьСайтГрузоперевозчика()
	
	ФайловаяСистемаКлиент.ОткрытьНавигационнуюСсылку(АдресСайта);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьДанныеТарифов(ДанныеПоТарифам)
	
	Тарифы.Очистить();
	Для Каждого СтрокаТарифа Из ДанныеПоТарифам Цикл
		НоваяСтрокаТарифа = Тарифы.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрокаТарифа, СтрокаТарифа);
		СформироватьПредставлениеТарифа(НоваяСтрокаТарифа);
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура СформироватьПредставлениеТарифа(Параметры)
	
	Параметры.ТарифПредставление = Параметры.ТарифНаименование
		+ ?(Параметры.ПоУмолчанию, СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(" (%1)", НСтр("ru='по умолчанию'")), "");
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьФормуТарифа(ВыбраннаяСтрока)
	
	ПараметрыОткрытияФормы = Новый Структура();
	ТарифИдентификатор = Тарифы.НайтиПоИдентификатору(ВыбраннаяСтрока).ТарифИдентификатор;
	ПараметрыОткрытияФормы.Вставить("Идентификатор", Тарифы.НайтиПоИдентификатору(ВыбраннаяСтрока).ТарифИдентификатор);
	ПараметрыОткрытияФормы.Вставить("ОрганизацияБизнесСетиСсылка", ОрганизацияБизнесСетиСсылка);
	ПараметрыОткрытияФормы.Вставить("ТипГрузоперевозки", ТипГрузоперевозки);
	
	ОткрытьФорму("Обработка.СервисДоставки.Форма.КарточкаТарифа", 
		ПараметрыОткрытияФормы,
		,
		ТарифИдентификатор,,,,
		РежимОткрытияОкнаФормы.Независимый);
							
КонецПроцедуры

&НаСервере
Процедура УстановитьВидимостьДоступность();
	
	ДоступнаОтправкаЗаказовНаДоставку = СервисДоставки.ПравоОтправкиЗаказовНаДоставкуПеревозчику();
	Элементы.ТарифыУстановитьТарифПоУмолчанию.Видимость = ДоступнаОтправкаЗаказовНаДоставку;
	Элементы.ТарифыСброситьТарифПоУмолчанию.Видимость = ДоступнаОтправкаЗаказовНаДоставку;
	
КонецПроцедуры

#КонецОбласти
