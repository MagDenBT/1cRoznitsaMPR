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

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	ОбработчикОповещений(ИмяСобытия, Параметр, Источник);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаНавигационнойСсылки(НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	Если НавигационнаяСсылкаФорматированнойСтроки = "Обсуждения" Тогда
		СтандартнаяОбработка = Ложь;
		ОткрытьФорму(
			"Обработка.ПанельАдминистрированияБСП.Форма.ИнтернетПоддержкаИСервисы",
			Новый Структура("Обсуждения", Истина),
			ЭтотОбъект);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ИспользоватьОбменСПодключаемымОборудованиемПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьРаспределеннуюФискализациюПриИзменении(Элемент)
	
	Подключаемый_ПриИзмененииРеквизита(Элемент);
	
	МенеджерОборудованияКлиент.ПодключениеСистемыВзаимодействия();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОткрытьРабочиеМеста(Команда)
	
	ПараметрыВыполненияКоманды = Новый Структура;
	ПараметрыВыполненияКоманды.Вставить("Источник", ЭтаФорма);
	ПараметрыВыполненияКоманды.Вставить("Уникальность", УникальныйИдентификатор);
	ПараметрыВыполненияКоманды.Вставить("Окно",);
	
	МенеджерОборудованияКлиент.ОткрытьРабочиеМеста(Неопределено, ПараметрыВыполненияКоманды);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьРМТекущегоСеанса(Команда)
	
	МенеджерОборудованияКлиент.ВыбратьРМТекущегоСеанса(Неопределено, Неопределено);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьШаблоныРаботыДисплеяПокупателя(Команда)
    
    // &ЗамерПроизводительности
    ОценкаПроизводительностиРТКлиент.НачатьЗамер(
             Истина, "Справочник.ШаблоныРаботыДисплеяПокупателя.Форма.ФормаСписка.Открытие");
	
	ОткрытьФорму("Справочник.ШаблоныРаботыДисплеяПокупателя.ФормаСписка", , ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьПравилаОбменаСПодключаемымОборудованием(Команда)

    // &ЗамерПроизводительности
        ОценкаПроизводительностиРТКлиент.НачатьЗамер(
                 Истина, "Справочник.ПравилаОбменаСПодключаемымОборудованием.Форма.ФормаСписка.Открытие");
                 
	ОткрытьФорму("Справочник.ПравилаОбменаСПодключаемымОборудованием.ФормаСписка", , ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьПодключаемоеОборудование(Команда)
	
	ПараметрыВыполненияКоманды = Новый Структура;
	ПараметрыВыполненияКоманды.Вставить("Источник", ЭтаФорма);
	ПараметрыВыполненияКоманды.Вставить("Уникальность", УникальныйИдентификатор);
	ПараметрыВыполненияКоманды.Вставить("Окно",);
	
	МенеджерОборудованияКлиент.ОткрытьПодключаемоеОборудование(Неопределено, ПараметрыВыполненияКоманды);

	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьНастройкиРаспределенияВыручкиПоСекциямФР(Команда)
	// &ЗамерПроизводительности
	ОценкаПроизводительностиРТКлиент.НачатьЗамер(
		     Истина, "Справочник.НастройкиРаспределенияВыручкиПоСекциямФР.Форма.ФормаСписка.Открытие");
             
	ОткрытьФорму("Справочник.НастройкиРаспределенияВыручкиПоСекциямФР.ФормаСписка", , ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьСоответствиеВидовОплатыСККМOffline(Команда)
    
    // &ЗамерПроизводительности
	ОценкаПроизводительностиРТКлиент.НачатьЗамер(
		         Истина, "Справочник.СоответствиеВидовОплатыСККМOffline.Форма.ФормаСписка.Открытие");
                 
	ОткрытьФорму("Справочник.СоответствиеВидовОплатыСККМOffline.ФормаСписка", , ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ПодключитьКассыКОператоруФискальныхДанных(Команда)
	ФайловаяСистемаКлиент.ОткрытьНавигационнуюСсылку("http://v8.1c.ru/cnt.jsp/:kd_roz:/https://portal.1c.ru/applications/56");
КонецПроцедуры

&НаКлиенте
Процедура ВсеО54ФЗ(Команда)
	ФайловаяСистемаКлиент.ОткрытьНавигационнуюСсылку("http://v8.1c.ru/cnt.jsp/:kd_roz:/http://v8.1c.ru/kkt/");
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьОфлайнОборудование(Команда)
	
	ПараметрыВыполненияКоманды = Новый Структура;
	ПараметрыВыполненияКоманды.Вставить("Источник", ЭтаФорма);
	ПараметрыВыполненияКоманды.Вставить("Уникальность", УникальныйИдентификатор);
	ПараметрыВыполненияКоманды.Вставить("Окно",);
	
	МенеджерОфлайнОборудованияКлиент.ОткрытьПодключаемоеОборудование(Неопределено, ПараметрыВыполненияКоманды);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьШаблоныЭтикетокИЦенников(Команда)
	
	ПараметрыВыполненияКоманды = Новый Структура;
	ПараметрыВыполненияКоманды.Вставить("Источник", ЭтаФорма);
	ПараметрыВыполненияКоманды.Вставить("Уникальность", УникальныйИдентификатор);
	ПараметрыВыполненияКоманды.Вставить("Окно",);
	
	ПараметрыФормы = Новый Структура();
	ОткрытьФорму("Справочник.ШаблоныЭтикетокИЦенниковБПО.ФормаСписка", ПараметрыФормы, ПараметрыВыполненияКоманды.Источник, ПараметрыВыполненияКоманды.Уникальность, ПараметрыВыполненияКоманды.Окно);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьПечатьЭтикетокИЦенников(Команда)
	
	ПараметрыВыполненияКоманды = Новый Структура;
	ПараметрыВыполненияКоманды.Вставить("Источник", ЭтаФорма);
	ПараметрыВыполненияКоманды.Вставить("Уникальность", УникальныйИдентификатор);
	ПараметрыВыполненияКоманды.Вставить("Окно",);
	
	ПараметрыФормы = Новый Структура();
	ОткрытьФорму("Обработка.ПечатьЭтикетокИЦенниковБПО.Форма.Форма", ПараметрыФормы, ПараметрыВыполненияКоманды.Источник, ПараметрыВыполненияКоманды.Уникальность, ПараметрыВыполненияКоманды.Окно);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область Клиент

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
Процедура ОбработчикОповещений(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "Запись_НаборКонстант" Тогда
		УстановитьДоступность();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ВызовСервера

&НаСервере
Функция ПриИзмененииРеквизитаСервер(ИмяЭлемента)
	
	РеквизитПутьКДанным = Элементы[ИмяЭлемента].ПутьКДанным;
	Результат = СохранитьЗначениеРеквизита(РеквизитПутьКДанным);
	
	УстановитьДоступность(РеквизитПутьКДанным);
	
	ОбновитьПовторноИспользуемыеЗначения();
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти

#Область Сервер

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
	
	ИспользоватьПодключаемоеОборудование		= НаборКонстант.ИспользоватьПодключаемоеОборудование;
	ИспользоватьОбменСПодключаемымОборудованием	= НаборКонстант.ИспользоватьОбменСПодключаемымОборудованием;
	ИспользоватьРаспределеннуюФискализацию		= НаборКонстант.ИспользоватьРаспределеннуюФискализацию;
	
	ИспользоватьСинхронизациюДанных = Константы.ИспользоватьСинхронизациюДанных.Получить();
	
	СистемаВзаимодействияДоступна = СистемаВзаимодействия.ИспользованиеДоступно();
	
	Если РеквизитПутьКДанным = "НаборКонстант.ИспользоватьПодключаемоеОборудование"
		ИЛИ РеквизитПутьКДанным = "НаборКонстант.ИспользоватьОбменСПодключаемымОборудованием"
		ИЛИ РеквизитПутьКДанным = "НаборКонстант.ИспользоватьРаспределеннуюФискализацию"
		ИЛИ РеквизитПутьКДанным = "" Тогда
		
		Элементы.ОткрытьПодключаемоеОборудование.Доступность					= ИспользоватьПодключаемоеОборудование;
		Элементы.ОткрытьШаблоныРаботыДисплеяПокупателя.Доступность				= ИспользоватьПодключаемоеОборудование;
		Элементы.ИспользоватьОбменСПодключаемымОборудованием.Доступность		= ИспользоватьПодключаемоеОборудование;
		Элементы.ОткрытьСоответствиеВидовОплатыСККМOffline.Доступность			= ИспользоватьОбменСПодключаемымОборудованием;
		Элементы.ФорматыЗаписиКодовМагнитныхКарт.Доступность					= ИспользоватьПодключаемоеОборудование;
		Элементы.ОткрытьПравилаОбменаСПодключаемымОборудованием.Доступность		= ИспользоватьОбменСПодключаемымОборудованием;
		Элементы.ГруппаФЗ54.Доступность											= ИспользоватьПодключаемоеОборудование;
		Элементы.ИспользоватьРаспределеннуюФискализацию.Доступность				= ИспользоватьПодключаемоеОборудование
			И СистемаВзаимодействияДоступна;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти
