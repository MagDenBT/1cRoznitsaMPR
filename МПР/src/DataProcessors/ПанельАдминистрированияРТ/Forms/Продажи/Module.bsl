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
	
	РегламентноеЗадание = РегламентныеЗаданияНайтиПредопределенное("РассылкаЭлектронныхЧеков");
	ВидимостьРасписания = (РегламентноеЗадание <> Неопределено);
	Если ВидимостьРасписания Тогда
		РассылкаЭлектронныхЧековИдентификатор = РегламентноеЗадание.УникальныйИдентификатор;
		РассылкаЭлектронныхЧековРасписание    = РегламентноеЗадание.Расписание;
	КонецЕсли;
	Элементы.РассылкаЭлектронныхЧековНастроитьРасписание.Видимость     = ВидимостьРасписания;
	Элементы.РассылкаЭлектронныхЧековПредставлениеРасписания.Видимость = ВидимостьРасписания;
	
	ОтправкаЭлектронныхЧековПослеПробитияЧека = Константы.ОтправкаЭлектронныхЧековПослеПробитияЧека.Получить();
	ОтправкаЭлектронныхЧеков = Число(ОтправкаЭлектронныхЧековПослеПробитияЧека);
	РассылкаЭлектронныхЧековИспользование = НЕ ОтправкаЭлектронныхЧековПослеПробитияЧека; 
	
	ПечататьСлипЧек = Константы.ПечатьСлипЧека.Получить();
	ПечататьПолныйСлипЧек = Константы.ПолныйСлипЧек.Получить();
	
	Если ПечататьСлипЧек И ПечататьПолныйСлипЧек Тогда
		ПечатьСлипЧекаЭквайринговойОперации = 2;
	ИначеЕсли Не ПечататьСлипЧек И Не ПечататьПолныйСлипЧек Тогда
		ПечатьСлипЧекаЭквайринговойОперации = 1;
	Иначе
		ПечатьСлипЧекаЭквайринговойОперации = 3
	КонецЕсли;
	
	// Обновление состояния элементов.
	УстановитьДоступность();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	
	Если ЗавершениеРаботы Тогда
		Возврат;
	КонецЕсли;
	
	ОбновитьИнтерфейсПрограммы();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ИспользоватьОплатуПлатежнымиКартамиПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
	НастроитьДоступностьНастроекСлипа();
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьРасчетыСКлиентамиПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьОплатуБанковскимиКредитамиПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура ФиксироватьПопыткиПродажПревышающихОстатокПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура КонтрагентРозничныйПокупательПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьЗаказыПокупателейПриИзменении(Элемент)
	
	Если НЕ НаборКонстант.ИспользоватьЗаказыПокупателей 
		И НаборКонстант.ИспользоватьРезервированиеПоЗаказамПокупателей Тогда
		
		НаборКонстант.ИспользоватьРезервированиеПоЗаказамПокупателей = Ложь;
		Результат = ПриИзмененииРеквизитаСервер("ИспользоватьРезервированиеПоЗаказамПокупателей");
		
	КонецЕсли;
	
	Если НЕ НаборКонстант.ИспользоватьЗаказыПокупателей 
		И НаборКонстант.ИспользоватьПричиныОтменыЗаказовПокупателей Тогда
		
		НаборКонстант.ИспользоватьПричиныОтменыЗаказовПокупателей = Ложь;
		Результат = ПриИзмененииРеквизитаСервер("ИспользоватьПричиныОтменыЗаказовПокупателей");
		
	КонецЕсли;
	
	Подключаемый_ПриИзмененииРеквизита(Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьРезервированиеПоЗаказамПокупателейПриИзменении(Элемент)
	
	Подключаемый_ПриИзмененииРеквизита(Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьПричиныОтменыЗаказовПокупателейПриИзменении(Элемент)
	
	Подключаемый_ПриИзмененииРеквизита(Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьЛогированиеДействийКассираВРМКПриИзменении(Элемент)
	
	Если НЕ НаборКонстант.ИспользоватьЛогированиеДействийКассираВРМК Тогда
		Оповещение = Новый ОписаниеОповещения("ПослеОтветаНаВопросЛогирование", ЭтотОбъект, Новый Структура("Элемент", Элемент));
		Кнопки = Новый СписокЗначений();
		Кнопки.Добавить(КодВозвратаДиалога.Да, НСтр("ru = 'Очистить'"));
		Кнопки.Добавить(КодВозвратаДиалога.Нет, НСтр("ru = 'Отключить без очистки'"));
		Кнопки.Добавить(КодВозвратаДиалога.Отмена, НСтр("ru = 'Отменить'"));
		ТекстЗаголовка = НСтр("ru = 'Логирование действий кассира'");
		ТекстВопроса = НСтр("ru = 'Очистить все записи лога после отключения логирования действий кассира в РМК?'");
		ПоказатьВопрос(Оповещение, ТекстВОпроса, Кнопки,, КодВозвратаДиалога.Отмена, ТекстЗаголовка);
	Иначе
		Подключаемый_ПриИзмененииРеквизита(Элемент);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура РассылкаЭлектронныхЧековИспользованиеПриИзменении(Элемент)
	РассылкаЭлектронныхЧековИспользованиеСервер();
	РегламентныеЗаданияИспользованиеПриИзменении("РассылкаЭлектронныхЧеков");
КонецПроцедуры

&НаКлиенте
Процедура КоличествоДнейХраненияОтложенныхЧековПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьСервисДоставкиКлиентамПриИзменении(Элемент)
	
	Подключаемый_ПриИзмененииРеквизита(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьНовыйРМКПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
	НастроитьВидимостьНастроекРМК();
КонецПроцедуры

&НаКлиенте
Процедура ПечатьСлипЧекаЭквайринговойОперацииПриИзменении(Элемент)
	
	УстановитьЗначенияПечатиСлипЧека();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОткрытьЭквайринговыеТерминалы(Команда)
    
    // &ЗамерПроизводительности
	ОценкаПроизводительностиРТКлиент.НачатьЗамер(
		     Истина, "Справочник.ЭквайринговыеТерминалы.Форма.ФормаСписка.Открытие");

	ОткрытьФорму("Справочник.ЭквайринговыеТерминалы.ФормаСписка", , ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьПричиныОтменыЗаказовПокупателей(Команда)
    
    // &ЗамерПроизводительности
	ОценкаПроизводительностиРТКлиент.НачатьЗамер(
		     Истина, "Справочник.ПричиныОтменыЗаказовПокупателей.Форма.ФормаСписка.Открытие");
	
	ОткрытьФорму("Справочник.ПричиныОтменыЗаказовПокупателей.ФормаСписка", , ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьНастройкиЛогированияПоВидамДействийКассираВРМК(Команда)
    
    // &ЗамерПроизводительности
    ОценкаПроизводительностиРТКлиент.НачатьЗамер(
             Истина, "РегистрСведений.НастройкиЛогированияПоВидамДействийКассираВРМК.Форма.ФормаСписка.Открытие");
            
    ОткрытьФорму("РегистрСведений.НастройкиЛогированияПоВидамДействийКассираВРМК.ФормаСписка", , ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура РассылкаЭлектронныхЧековНастроитьРасписание(Команда)
	РегламентныеЗаданияГиперссылкаНажатие("РассылкаЭлектронныхЧеков");
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьОчередьЭлектронныхЧеков(Команда)
    
    // &ЗамерПроизводительности
	ОценкаПроизводительностиРТКлиент.НачатьЗамер(
		     Истина, "Справочник.ОчередьЭлектронныхЧековКОтправке.Форма.ФормаСписка.Открытие");

	ОткрытьФорму("Справочник.ОчередьЭлектронныхЧековКОтправке.ФормаСписка", , ЭтаФорма);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура Подключаемый_ПриИзмененииРеквизита(Элемент, ОбновлятьИнтерфейс = Истина)
	
	Результат = ПриИзмененииРеквизитаСервер(Элемент.Имя);
	
	Если ОбновлятьИнтерфейс Тогда
		#Если НЕ ВебКлиент Тогда
		ПодключитьОбработчикОжидания("ОбновитьИнтерфейсПрограммы", 1, Истина);
		ОбновитьИнтерфейс = Истина;
		#КонецЕсли
	КонецЕсли;
	
	Если Результат <> "" Тогда
		Оповестить("Запись_НаборКонстант", Новый Структура, Результат);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьИнтерфейсПрограммы()
	
	#Если НЕ ВебКлиент Тогда
	Если ОбновитьИнтерфейс = Истина Тогда
		ОбновитьИнтерфейс = Ложь;
		ОбновитьИнтерфейс();
	КонецЕсли;
	#КонецЕсли
	
КонецПроцедуры

&НаКлиенте
Процедура РегламентныеЗаданияГиперссылкаНажатие(ПрефиксРеквизитов)
	ПараметрыВыполнения = Новый Структура;
	ПараметрыВыполнения.Вставить("Идентификатор", ЭтотОбъект[ПрефиксРеквизитов + "Идентификатор"]);
	ПараметрыВыполнения.Вставить("ИмяРеквизитаРасписание", ПрефиксРеквизитов + "Расписание");
	
	РегламентныеЗаданияИзменитьРасписание(ПараметрыВыполнения);
КонецПроцедуры

&НаКлиенте
Процедура РегламентныеЗаданияИзменитьРасписание(ПараметрыВыполнения)
	Обработчик = Новый ОписаниеОповещения("РегламентныеЗаданияПослеИзмененияРасписания", ЭтотОбъект, ПараметрыВыполнения);
	Диалог = Новый ДиалогРасписанияРегламентногоЗадания(ЭтотОбъект[ПараметрыВыполнения.ИмяРеквизитаРасписание]);
	Диалог.Показать(Обработчик);
КонецПроцедуры

&НаКлиенте
Процедура РегламентныеЗаданияПослеИзмененияРасписания(Расписание, ПараметрыВыполнения) Экспорт
	Если Расписание = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ЭтотОбъект[ПараметрыВыполнения.ИмяРеквизитаРасписание] = Расписание;
	
	Изменения = Новый Структура("Расписание", Расписание);
	Если ПараметрыВыполнения.Свойство("ИмяРеквизитаИспользование") Тогда
		ЭтотОбъект[ПараметрыВыполнения.ИмяРеквизитаИспользование] = Истина;
		Изменения.Вставить("Использование", Истина);
	КонецЕсли;
	РегламентныеЗаданияСохранить(ПараметрыВыполнения.Идентификатор, Изменения, ПараметрыВыполнения.ИмяРеквизитаРасписание);
КонецПроцедуры

&НаКлиенте
Процедура РегламентныеЗаданияИспользованиеПриИзменении(ПрефиксРеквизитов)
	ИмяРеквизитаИспользование = ПрефиксРеквизитов + "Использование";
	Идентификатор = ЭтотОбъект[ПрефиксРеквизитов + "Идентификатор"];
	Если ЭтотОбъект[ИмяРеквизитаИспользование] Тогда
		ЭлементПредставление = Элементы.Найти(ПрефиксРеквизитов + "ПредставлениеРасписания");
		Если ЭлементПредставление = Неопределено Или ЭлементПредставление.Видимость Тогда
			ПараметрыВыполнения = Новый Структура;
			ПараметрыВыполнения.Вставить("Идентификатор", Идентификатор);
			ПараметрыВыполнения.Вставить("ИмяРеквизитаРасписание", ПрефиксРеквизитов + "Расписание");
			ПараметрыВыполнения.Вставить("ИмяРеквизитаИспользование", ИмяРеквизитаИспользование);
			РегламентныеЗаданияИзменитьРасписание(ПараметрыВыполнения);
			Возврат;
		КонецЕсли;
	КонецЕсли;
	Изменения = Новый Структура("Использование", ЭтотОбъект[ИмяРеквизитаИспользование]);
	РегламентныеЗаданияСохранить(Идентификатор, Изменения, ИмяРеквизитаИспользование);
КонецПроцедуры

&НаСервере
Функция ПриИзмененииРеквизитаСервер(ИмяЭлемента)
	
	РеквизитПутьКДанным = Элементы[ИмяЭлемента].ПутьКДанным;
	Результат = СохранитьЗначениеРеквизита(РеквизитПутьКДанным);
	
	УстановитьДоступность(РеквизитПутьКДанным);
	
	ОбновитьПовторноИспользуемыеЗначения();
	
	Возврат Результат;
	
КонецФункции

&НаСервере
Функция СохранитьЗначениеРеквизита(РеквизитПутьКДанным)
	
	// Определение имени константы.
	КонстантаИмя = "";
	
	// Сохранение значений реквизитов, не связанных с константами напрямую (в отношении один-к-одному).
	Если РеквизитПутьКДанным = "" Тогда
		Возврат КонстантаИмя;
	КонецЕсли;
	
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
	
	Возврат КонстантаИмя;
	
КонецФункции

&НаСервере
Процедура УстановитьДоступность(РеквизитПутьКДанным = "")
	
	ИспользоватьСинхронизациюДанных = Константы.ИспользоватьСинхронизациюДанных.Получить();
	
	Если РеквизитПутьКДанным = "НаборКонстант.ИспользоватьОплатуПлатежнымиКартами" ИЛИ РеквизитПутьКДанным = "" Тогда
		Если НаборКонстант.ИспользоватьУчетТоваровФСС Тогда
			Элементы.ИспользоватьОплатуПлатежнымиКартами.ТолькоПросмотр = Истина;
			Элементы.ГруппаИспользоватьОплатуПлатежнымиКартами.Подсказка =
				НСтр("ru = 'Используется для приема оплат электронными сертификатами НСПК'");
		КонецЕсли;
		Элементы.ОткрытьЭквайринговыеТерминалы.Доступность = НаборКонстант.ИспользоватьОплатуПлатежнымиКартами;
	КонецЕсли;
	
	Если РеквизитПутьКДанным = "НаборКонстант.ИспользоватьЛогированиеДействийКассираВРМК" ИЛИ РеквизитПутьКДанным = "" Тогда
		Элементы.ОткрытьНастройкиЛогированияПоВидамДействийКассираВРМК.Доступность = НаборКонстант.ИспользоватьЛогированиеДействийКассираВРМК;
	КонецЕсли;
	
	Элементы.ИспользоватьРезервированиеПоЗаказамПокупателей.Доступность = НаборКонстант.ИспользоватьЗаказыПокупателей;
	Элементы.ИспользоватьПричиныОтменыЗаказовПокупателей.Доступность    = НаборКонстант.ИспользоватьЗаказыПокупателей;
	Элементы.ПричиныОтменыЗаказовПокупателей.Доступность                = НаборКонстант.ИспользоватьПричиныОтменыЗаказовПокупателей;
	
	Если РеквизитПутьКДанным = "" Тогда
		
		Если ИспользоватьСинхронизациюДанных Тогда
			Если ОбменДаннымиРТ.ЭтоПодчиненныйУзелПоМагазину() Тогда
				
				Элементы.ИспользоватьОплатуПлатежнымиКартами.ТолькоПросмотр 	= Истина;
				Элементы.ИспользоватьОплатуБанковскимиКредитами.ТолькоПросмотр 	= Истина;
				Элементы.ИспользоватьРасчетыСКлиентами.ТолькоПросмотр			= Истина;
				
			ИначеЕсли ОбменДаннымиРТ.ЭтоПодчиненныйУзелПоРабочемуМесту() Тогда
				
				Элементы.ИспользоватьОплатуПлатежнымиКартами.ТолькоПросмотр 	= Истина;
				Элементы.ИспользоватьОплатуБанковскимиКредитами.ТолькоПросмотр 	= Истина;
				Элементы.ИспользоватьРасчетыСКлиентами.ТолькоПросмотр			= Истина;
				
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
	Если РассылкаЭлектронныхЧековИспользование Тогда
		РасписаниеПредставление = Строка(РассылкаЭлектронныхЧековРасписание);
		Представление = ВРег(Лев(РасписаниеПредставление, 1)) + Сред(РасписаниеПредставление, 2);
	Иначе
		Представление = НСтр("ru = '<Отключено>'");
	КонецЕсли;
	Элементы.РассылкаЭлектронныхЧековПредставлениеРасписания.Заголовок = Представление;
	Элементы.РассылкаЭлектронныхЧековНастроитьРасписание.Доступность = РассылкаЭлектронныхЧековИспользование;
	
	ИспользоватьБизнесСеть = Константы.ИспользоватьОбменБизнесСеть.Получить();
	
	Элементы.ИспользоватьСервисДоставкиКлиентам.Доступность = ИспользоватьБизнесСеть;
	
	Если РеквизитПутьКДанным = "НаборКонстант.ИспользоватьСервисДоставкиКлиентам" ИЛИ РеквизитПутьКДанным = "" Тогда
		Элементы.НастройкиРаботыСПеревозчиками.Доступность = НаборКонстант.ИспользоватьСервисДоставкиКлиентам;
	КонецЕсли;
	
	НастроитьВидимостьНастроекРМК();
	
КонецПроцедуры

&НаСервере
Функция РегламентныеЗаданияНайтиПредопределенное(ИмяПредопределенного)
	Фильтр = Новый Структура("Метаданные", ИмяПредопределенного);
	Найденные = РегламентныеЗаданияСервер.НайтиЗадания(Фильтр);
	Задание = ?(Найденные.Количество() = 0, Неопределено, Найденные[0]);
	Возврат Задание;
КонецФункции

&НаСервере
Процедура РегламентныеЗаданияСохранить(УникальныйИдентификатор, Изменения, РеквизитПутьКДанным)
	РегламентныеЗаданияСервер.ИзменитьЗадание(УникальныйИдентификатор, Изменения);
	Если РеквизитПутьКДанным <> Неопределено Тогда
		УстановитьДоступность(РеквизитПутьКДанным);
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура РассылкаЭлектронныхЧековИспользованиеСервер()
	
	ОтправкаЭлектронныхЧековПослеПробитияЧека = НЕ РассылкаЭлектронныхЧековИспользование;
	Константы.ОтправкаЭлектронныхЧековПослеПробитияЧека.Установить(ОтправкаЭлектронныхЧековПослеПробитияЧека);
	Элементы.РассылкаЭлектронныхЧековНастроитьРасписание.Доступность = РассылкаЭлектронныхЧековИспользование;
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеОтветаНаВопросЛогирование(Результат, Параметры) Экспорт
	
	Если Результат = Неопределено ИЛИ Результат = КодВозвратаДиалога.Отмена Тогда
		НаборКонстант.ИспользоватьЛогированиеДействийКассираВРМК = Истина;
		Возврат;
	КонецЕсли;
	
	Отказ = Ложь;
	СообщениеОбОшибке = "";
	
	Если Результат = КодВозвратаДиалога.Да Тогда
		ОчиститьЛогДействийКассираСервер(Отказ, СообщениеОбОшибке);
	КонецЕсли;
	
	Если Отказ Тогда
		ОчиститьСообщения();
		ОбщегоНазначенияКлиент.СообщитьПользователю(СообщениеОбОшибке);
	Иначе
		Подключаемый_ПриИзмененииРеквизита(Параметры.Элемент);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОчиститьЛогДействийКассираСервер(Отказ, СообщениеОбОшибке)
	
	ЛогированиеДействийКассира.ОчиститьЛогДействийКассира(Отказ, СообщениеОбОшибке);
КонецПроцедуры

&НаСервере
Процедура НастроитьВидимостьНастроекРМК()
	
	Если НаборКонстант.ИспользоватьНовоеРМК Тогда
		Элементы.ГруппаНастройкиРМКИПалитраБыстрыхТоваров.Доступность = Ложь;
		Элементы.ГруппаЛогированиеДействийКассираВРМК.Доступность = Ложь;
		Элементы.ГруппаНастройкиНовогоРМК.Доступность = Истина;
	Иначе
		Элементы.ГруппаНастройкиРМКИПалитраБыстрыхТоваров.Доступность = Истина;
		Элементы.ГруппаЛогированиеДействийКассираВРМК.Доступность = Истина;
		Элементы.ГруппаНастройкиНовогоРМК.Доступность = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ГруппаИспользоватьОплатуПлатежнымиКартамиExtendedTooltipОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	Если НавигационнаяСсылкаФорматированнойСтроки = "ЭС_НСПК" Тогда
		СтандартнаяОбработка = Ложь;
		
		ПараметрыФормы = Новый Структура("ТекущийЭлементИмя", "ИспользоватьУчетТоваровФСС");
		ОткрытьФорму(
			"Обработка.ПанельАдминистрированияРТ.Форма.НастройкиНоменклатуры",
			ПараметрыФормы,
			ЭтотОбъект);
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура НастроитьДоступностьНастроекСлипа()
	
	Элементы.ГруппаПечатьСлипЧека.Доступность = НаборКонстант.ИспользоватьОплатуПлатежнымиКартами;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьЗначенияПечатиСлипЧека()
	
	Если ПечатьСлипЧекаЭквайринговойОперации = 1 Тогда
		Константы.ПолныйСлипЧек.Установить(Ложь);
		Константы.ПечатьСлипЧека.Установить(Ложь);
	ИначеЕсли ПечатьСлипЧекаЭквайринговойОперации = 2 Тогда
		Константы.ПолныйСлипЧек.Установить(Истина);
		Константы.ПечатьСлипЧека.Установить(Истина);
	ИначеЕсли ПечатьСлипЧекаЭквайринговойОперации = 3 Тогда
		Константы.ПолныйСлипЧек.Установить(Ложь);
		Константы.ПечатьСлипЧека.Установить(Истина);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти