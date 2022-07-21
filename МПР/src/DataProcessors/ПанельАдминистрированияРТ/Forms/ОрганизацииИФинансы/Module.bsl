#Область ОписаниеПеременных

&НаКлиенте
Перем ОбновитьИнтерфейс;

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Если Параметры.Свойство("ТекущийЭлементИмя") Тогда
		ТекущийЭлемент = Элементы[Параметры.ТекущийЭлементИмя];
	КонецЕсли;
	
	НесколькоОрганизацийПриИзменении(ЭтотОбъект, НаборКонстант.ИспользоватьНесколькоОрганизаций);
	
	ЗаполнитьОсновнуюОрганизацию();
	
	НастройкиКассовойКниги();
	
	ТекущаяДата = ТекущаяДатаСеанса();
	
	УстановитьДоступность();
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	
	Если ЗавершениеРаботы Тогда
		Возврат;
	КонецЕсли;
	
	ОбновитьИнтерфейсПрограммы();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	ОбработчикОповещений(ИмяСобытия, Параметр, Источник);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ВыплачиватьЗарплатуВМагазинахПриИзменении(Элемент)
	
	Подключаемый_ПриИзмененииРеквизита(Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьЗаявкиНаРасходованиеДСПриИзменении(Элемент)
	
	Подключаемый_ПриИзмененииРеквизита(Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура ВедениеКассовойКнигиПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьПередачиТоваровМеждуОрганизациямиПриИзменении(Элемент)
	
	Подключаемый_ПриИзмененииРеквизита(Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьНесколькоОрганизацийПриИзменении(Элемент)
	
	Подключаемый_ПриИзмененииРеквизита(Элемент);
	
	НесколькоОрганизацийПриИзменении(ЭтотОбъект, НаборКонстант.ИспользоватьНесколькоОрганизаций);
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьАгентскиеПлатежиИРазделениеВыручкиПриИзменении(Элемент)
	
	Подключаемый_ПриИзмененииРеквизита(Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура РассчитыватьПремииВМагазинахПриИзменении(Элемент)
	
	Подключаемый_ПриИзмененииРеквизита(Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура ДекорацияКомментарийНесколькоОрганизацийНажатие(Элемент)
	
	ТекстСообщения = Элемент.Подсказка;
	ПоказатьПредупреждение(, ТекстСообщения);
	
КонецПроцедуры

&НаКлиенте
Процедура ДекорацияКомментарийЗаявкиНаРасходованиеДСНажатие(Элемент)
	
	ТекстСообщения = Элемент.Подсказка;
	ПоказатьПредупреждение(, ТекстСообщения);
	
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьМониторПоказателейМагазинаПриИзменении(Элемент)
	
	Подключаемый_ПриИзмененииРеквизита(Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура ВестиУчетОстатковБезналичныхДенежныхСредствПриИзменении(Элемент)
	
	Если НаборКонстант.ВестиУчетБезналичныхДенежныхСредств Тогда
		Если НЕ ЗначениеЗаполнено(НаборКонстант.ДатаНачалаУчетаБезналичныхДенежныхСредств) Тогда
			НаборКонстант.ДатаНачалаУчетаБезналичныхДенежныхСредств = ТекущаяДата;
			Подключаемый_ПриИзмененииРеквизита(Элементы.ДатаНачалаУчетаБезналичныхДенежныхСредств);
		КонецЕсли;
	Иначе
		НаборКонстант.ДатаНачалаУчетаБезналичныхДенежныхСредств = Неопределено;
		Подключаемый_ПриИзмененииРеквизита(Элементы.ДатаНачалаУчетаБезналичныхДенежныхСредств);
	КонецЕсли;
	
	УстановитьДоступность("УчетБезналичныхДС");
	
	Подключаемый_ПриИзмененииРеквизита(Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура ДатаНачалаУчетаБезналичныхДенежныхСредствПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОткрытьСписокОрганизаций(Команда)
	// &ЗамерПроизводительности
	ОценкаПроизводительностиРТКлиент.НачатьЗамер(
		Истина, "Справочник.Организации.Форма.ФормаСписка.Открытие");
	
	ОткрытьФорму("Справочник.Организации.ФормаСписка");
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьРеквизитыОрганизации(Команда)
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ПриЗакрытииФормыОрганизации", ЭтотОбъект);
	ОткрытьФорму(
		"Справочник.Организации.ФормаОбъекта",
		Новый Структура("Ключ", ОсновнаяОрганизация),
		ЭтотОбъект,
		ЭтотОбъект.УникальныйИдентификатор,,, ОписаниеОповещения);
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ЗаполнитьОсновнуюОрганизацию()
	
	ОсновнаяОрганизация = Справочники.Организации.ОрганизацияПоУмолчанию();
	Если ЗначениеЗаполнено(ОсновнаяОрганизация) Тогда
		Элементы.РеквизитыОрганизации.Заголовок = СокрЛП(ОсновнаяОрганизация);
	Иначе
		Элементы.РеквизитыОрганизации.Заголовок =
			НСтр("ru = 'Укажите реквизиты организации'");
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура НастройкиКассовойКниги()
	
	Если НаборКонстант.ИспользоватьКассовуюКнигу И НаборКонстант.КассоваяКнигаПоМагазинам Тогда
		ВедениеКассовойКниги = "ПоМагазинам";
	ИначеЕсли НаборКонстант.ИспользоватьКассовуюКнигу Тогда
		ВедениеКассовойКниги = "ПоОрганизации";
	Иначе
		ВедениеКассовойКниги = "НеВедется";
	КонецЕсли;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура НесколькоОрганизацийПриИзменении(Форма, НесколькоОрганизаций)
	
	Форма.Элементы.ГруппаСписокОрганизаций.Видимость = НесколькоОрганизаций;
	Форма.Элементы.ГруппаРеквизитыОрганизации.Видимость = НЕ НесколькоОрганизаций;
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьИнтерфейсПрограммы()
	
	Если ОбновитьИнтерфейс = Истина Тогда
		ОбновитьИнтерфейс = Ложь;
		ОбщегоНазначенияКлиент.ОбновитьИнтерфейсПрограммы();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработчикОповещений(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "Запись_НаборКонстант" Тогда
		УстановитьДоступность();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПриИзмененииРеквизита(Элемент, ОбновлятьИнтерфейс = Истина)
	
	КонстантаИмя = ПриИзмененииРеквизитаСервер(Элемент.Имя);
	
	ОбновитьПовторноИспользуемыеЗначения();
	
	Если ОбновлятьИнтерфейс Тогда
		ОбновитьИнтерфейс = Истина;
		ПодключитьОбработчикОжидания("ОбновитьИнтерфейсПрограммы", 2, Истина);
	КонецЕсли;
	
	Если КонстантаИмя <> "" Тогда
		Оповестить("Запись_НаборКонстант", Новый Структура, КонстантаИмя);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытииФормыОрганизации(Знач Результат, Знач ДополнительныеПараметры = Неопределено) Экспорт
	
	ЗаполнитьОсновнуюОрганизацию();
КонецПроцедуры

&НаСервере
Функция ПриИзмененииРеквизитаСервер(ИмяЭлемента)
	
	Результат = Новый Структура;
	
	РеквизитПутьКДанным = Элементы[ИмяЭлемента].ПутьКДанным;
	
	СохранитьЗначениеРеквизита(РеквизитПутьКДанным, Результат);
	
	УстановитьДоступность(РеквизитПутьКДанным);
	
	ОбновитьПовторноИспользуемыеЗначения();
	
	Возврат Результат;
	
КонецФункции

&НаСервере
Процедура СохранитьЗначениеРеквизита(РеквизитПутьКДанным, Результат)
	
	// Сохранение значений реквизитов, не связанных с константами напрямую (в отношении один-к-одному).
	Если РеквизитПутьКДанным = "" Тогда
		Возврат;
	КонецЕсли;
	
	// Определение имени константы.
	КонстантаИмя = "";
	Если НРег(Лев(РеквизитПутьКДанным, 14)) = НРег("НаборКонстант.") Тогда
		// Если путь к данным реквизита указан через "НаборКонстант".
		КонстантаИмя = Сред(РеквизитПутьКДанным, 15);
	Иначе
		// Определение имени и запись значения реквизита в соответствующей константе из "НаборКонстант".
		// Используется для тех реквизитов формы, которые связаны с константами напрямую (в отношении один-к-одному).
	КонецЕсли;
	
	// Сохранения значения константы.
	Если КонстантаИмя <> "" Тогда
		КонстантаМенеджер = Константы[КонстантаИмя];
		КонстантаЗначение = НаборКонстант[КонстантаИмя];
		
		Если КонстантаМенеджер.Получить() <> КонстантаЗначение Тогда
			КонстантаМенеджер.Установить(КонстантаЗначение);
		КонецЕсли;
		
	КонецЕсли;
	
	Если РеквизитПутьКДанным = "ВедениеКассовойКниги" Тогда
		
		Если ВедениеКассовойКниги = "ПоМагазинам" Тогда
			Константы.ИспользоватьКассовуюКнигу.Установить(Истина);
			Константы.КассоваяКнигаПоМагазинам.Установить(Истина);
		ИначеЕсли  ВедениеКассовойКниги = "ПоОрганизации" Тогда
			Константы.ИспользоватьКассовуюКнигу.Установить(Истина);
			Константы.КассоваяКнигаПоМагазинам.Установить(Ложь);
		Иначе
			Константы.ИспользоватьКассовуюКнигу.Установить(Ложь);
			Константы.КассоваяКнигаПоМагазинам.Установить(Ложь);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьДоступность(РеквизитПутьКДанным = "")
	
	ИспользоватьСинхронизациюДанных = Константы.ИспользоватьСинхронизациюДанных.Получить();
	
	Если НЕ ИспользоватьСинхронизациюДанных Тогда
		ТекстПодсказки = НСтр("ru = 'Невозможно включение заявок на расходование ДС, потому что:
		|- выключен обмен данными в разделе «Синхронизация данных»
		|- нет действующих обменов с УТ.'");
		
		Элементы.ДекорацияКомментарийЗаявкиНаРасходованиеДС.Подсказка = ТекстПодсказки;
		Элементы.ДекорацияКомментарийЗаявкиНаРасходованиеДС.Видимость = Истина;
		
	ИначеЕсли ИспользоватьСинхронизациюДанных И НЕ НаборКонстант.ИспользуетсяОбменСУправлениемТорговлей Тогда
		
		ТекстПодсказки = НСтр("ru = 'Невозможно включение заявок на расходование ДС, потому что:
		|- нет действующих обменов с УТ.'");
		
		Элементы.ДекорацияКомментарийЗаявкиНаРасходованиеДС.Подсказка = ТекстПодсказки;
		Элементы.ДекорацияКомментарийЗаявкиНаРасходованиеДС.Видимость = Истина;
	Иначе
		
		Элементы.ДекорацияКомментарийЗаявкиНаРасходованиеДС.Видимость = Ложь;
	КонецЕсли;
	
	Элементы.ИспользоватьЗаявкиНаРасходованиеДС.Доступность =
		ИспользоватьСинхронизациюДанных И НаборКонстант.ИспользуетсяОбменСУправлениемТорговлей;
	
	Элементы.ДекорацияКомментарийНесколькоОрганизаций.Видимость = Ложь;
	
	Если РеквизитПутьКДанным = "" Тогда
		
		Если ИспользоватьСинхронизациюДанных Тогда
			Если ОбменДаннымиРТ.ЭтоПодчиненныйУзелПоМагазину() Тогда
				
				Элементы.РассчитыватьПремииВМагазинах.ТолькоПросмотр = Истина;
				Элементы.ВыплачиватьЗарплатуВМагазинах.ТолькоПросмотр = Истина;
			ИначеЕсли ОбменДаннымиРТ.ЭтоПодчиненныйУзелПоРабочемуМесту() Тогда
				
				Элементы.ВыплачиватьЗарплатуВМагазинах.ТолькоПросмотр = Истина;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
	Если РеквизитПутьКДанным = "УчетБезналичныхДС"
		Или РеквизитПутьКДанным = "" Тогда
		Элементы.ГруппаУчетБезналичныхДС.Видимость = НЕ ОбщегоНазначения.ЭтоПодчиненныйУзелРИБ();
		Элементы.ДатаНачалаУчетаБезналичныхДенежныхСредств.Доступность = НаборКонстант.ВестиУчетБезналичныхДенежныхСредств;
		Элементы.ДокументВводОстатковДенежныхСредствОткрытьСписок.Видимость = НаборКонстант.ВестиУчетБезналичныхДенежныхСредств;
	КонецЕсли;
	
	Если СтандартныеПодсистемыСервер.ЭтоБазоваяВерсияКонфигурации()
		ИЛИ (НаборКонстант.ИспользоватьНесколькоОрганизаций И Справочники.Организации.КоличествоОрганизаций()>1) Тогда
		Элементы.ИспользоватьНесколькоОрганизаций.ТолькоПросмотр = Истина;
		Элементы.ИспользоватьНесколькоОрганизаций.Доступность = Ложь;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

