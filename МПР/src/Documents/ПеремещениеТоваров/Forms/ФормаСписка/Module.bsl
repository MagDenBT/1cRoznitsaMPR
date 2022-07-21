
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПараметрыРазмещения = ПодключаемыеКоманды.ПараметрыРазмещения();
	ПараметрыРазмещения.КоманднаяПанель = Элементы.КоманднаяПанельФормы;
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект, ПараметрыРазмещения);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	Если Не ПравоДоступа("Добавление", Метаданные.Документы.ТТНИсходящаяЕГАИС) Тогда 
		Элементы.ФормаСоздатьНаОснованииТТНИсходящаяЕГАИС.Видимость = Ложь;	
	КонецЕсли;
	
	ОбщегоНазначенияРТ.УстановитьУсловноеОформлениеПоляДата(ЭтотОбъект, "Список", "Дата");
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
    
    // &ЗамерПроизводительности
    ОценкаПроизводительностиРТКлиент.НачатьЗамер(
             Истина, "Документ.ПеремещениеТоваров.Форма.ФормаСписка.Открытие");

	УстановитьДоступностьСкладаОтправителя();
	УстановитьДоступностьСкладаПолучателя();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "РаспределениеТоваровПоСкладамВыполнено" Тогда
		
		Элементы.Список.Обновить();
		
	КонецЕсли;	
	
КонецПроцедуры

&НаСервере
Процедура ПриЗагрузкеДанныхИзНастроекНаСервере(Настройки)
	
	МагазинОтправитель   = Настройки.Получить("МагазинОтправитель");
	МагазинПолучатель    = Настройки.Получить("МагазинПолучатель");
	СкладОтправитель     = Настройки.Получить("СкладОтправитель");
	СкладПолучатель      = Настройки.Получить("СкладПолучатель");
	УстановитьОтборДинамическогоСписка("МагазинОтправитель");
	УстановитьОтборДинамическогоСписка("МагазинПолучатель");
	УстановитьОтборДинамическогоСписка("СкладОтправитель");
	УстановитьОтборДинамическогоСписка("СкладПолучатель");
	
КонецПроцедуры

&НаКлиенте
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
    
    // &ЗамерПроизводительности
    ОценкаПроизводительностиРТКлиент.НачатьЗамер(
                 Истина, "Документ.ПеремещениеТоваров.Форма.ФормаДокумента.Открытие");
        
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ОтборМагазинОтправительПриИзменении(Элемент)
	
	УстановитьОтборыМагазинСклад("Отправитель");
	УстановитьДоступностьСкладаОтправителя();
КонецПроцедуры

&НаКлиенте
Процедура ОтборСкладОтправительПриИзменении(Элемент)
	
	УстановитьОтборДинамическогоСписка("СкладОтправитель");

КонецПроцедуры

&НаКлиенте
Процедура ОтборМагазинПолучательПриИзменении(Элемент)
	
	УстановитьОтборыМагазинСклад("Получатель");
	УстановитьДоступностьСкладаПолучателя();
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборСкладПолучательПриИзменении(Элемент)
	
	УстановитьОтборДинамическогоСписка("СкладПолучатель");

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры
    
&НаКлиенте
Процедура СписокПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
    
    // &ЗамерПроизводительности
    ОценкаПроизводительностиРТКлиент.НачатьЗамер(
             Истина, "Документ.ПеремещениеТоваров.Форма.ФормаДокумента.СозданиеНового");

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ИзменитьВыделенные(Команда)
	
	ГрупповоеИзменениеОбъектовКлиент.ИзменитьВыделенные(Элементы.Список);
	
КонецПроцедуры

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Элементы.Список);
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат) Экспорт
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Элементы.Список, Результат);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Элементы.Список);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

&НаКлиенте
Процедура СоздатьНаОснованииТТНИсходящаяЕГАИС(Команда)
	
	ТекущиеДанные = Элементы.Список.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		ВызватьИсключение НСтр("ru='Команда не может быть выполнена для указанного объекта!'");
	КонецЕсли;
	
	ПроверитьВозможностьВводаНаОснованииТТНИсходящая(ТекущиеДанные.Ссылка);
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Основание", ТекущиеДанные.Ссылка);
	
	ОткрытьФорму("Документ.ТТНИсходящаяЕГАИС.Форма.ФормаДокумента", ПараметрыФормы, ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьНаОснованииЧекЕГАИС(Команда)
	
	ТекущиеДанные = Элементы.Список.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		ВызватьИсключение НСтр("ru='Команда не может быть выполнена для указанного объекта.'");
	КонецЕсли;
	
	ПроверитьВозможностьВводаНаОснованииЧекЕГАИС(ТекущиеДанные.Ссылка);
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Основание", ТекущиеДанные.Ссылка);
	
	ОткрытьФорму("Документ.ЧекЕГАИС.Форма.ФормаДокумента", ПараметрыФормы, ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьОтборыМагазинСклад(ИмяРеквизита)
	
	УстановитьОтборДинамическогоСписка("Магазин" + ИмяРеквизита);
	УстановитьОтборДинамическогоСписка("Склад" + ИмяРеквизита);
	
КонецПроцедуры

&НаСервере
Процедура УстановитьОтборДинамическогоСписка(ИмяРеквизита)
	
	ОтборыСписковКлиентСервер.ИзменитьЭлементОтбораСписка(
		Список, 
		ИмяРеквизита, 
		ЭтаФорма[ИмяРеквизита], 
		ЗначениеЗаполнено(ЭтаФорма[ИмяРеквизита]));
		
КонецПроцедуры

&НаКлиенте
Процедура УстановитьДоступностьСкладаОтправителя()
	
	Элементы.ОтборСкладОтправитель.ТолькоПросмотр = НЕ ЗначениеЗаполнено(МагазинОтправитель);
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьДоступностьСкладаПолучателя()
	
	Элементы.ОтборСкладПолучатель.ТолькоПросмотр = НЕ ЗначениеЗаполнено(МагазинПолучатель);
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ПроверитьВозможностьВводаНаОснованииЧекЕГАИС(ДокументОснование)
	
	Если НЕ ПроверитьВозможностьВводаНаОсновании(ДокументОснование) Тогда
		ВызватьИсключение НСтр("ru='На основании перемещения товаров существуют созданные документы ЕГАИС'");
	КонецЕсли;
	
	ЭтоОрганизацияЕГАИС = ЗначениеЗаполнено(Справочники.КлассификаторОрганизацийЕГАИС.ОрганизацияЕГАИСПоОрганизацииИТорговомуОбъекту(ДокументОснование.ОрганизацияПолучатель, 
																																	 ДокументОснование.МагазинПолучатель,,Ложь));
																																	 
	Если ЭтоОрганизацияЕГАИС Тогда
		
		ЕстьОшибки = Истина;
		Текст = НСтр("ru = 'Получатель является участником ЕГАИС. В этом случае нужно использовать Товарно-транспортную накладнаую ЕГАИС (исходящая).'"); 
		ВызватьИсключение Текст;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ПроверитьВозможностьВводаНаОснованииТТНИсходящая(ДокументОснование)
	
	Если НЕ ПроверитьВозможностьВводаНаОсновании(ДокументОснование) Тогда
		ВызватьИсключение НСтр("ru='На основании перемещения товаров существуют созданные документы ЕГАИС'");
	КонецЕсли;
	
	ЭтоОрганизацияЕГАИС = ЗначениеЗаполнено(Справочники.КлассификаторОрганизацийЕГАИС.ОрганизацияЕГАИСПоОрганизацииИТорговомуОбъекту(ДокументОснование.ОрганизацияПолучатель, 
																																	 ДокументОснование.МагазинПолучатель,,Ложь));
																																	 
	Если НЕ ЭтоОрганизацияЕГАИС Тогда
		
		Текст = НСтр("ru = 'Получатель не является участником ЕГАИС. В этом случае нужно использовать Чек ЕГАИС.'"); 
		ВызватьИсключение Текст;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПроверитьВозможностьВводаНаОсновании(ДокументОснование)
	
	ОбщегоНазначенияРТ.ПроверитьВозможностьВводаНаОсновании(ДокументОснование);
	
	ОрганизацияЕГАИС = Справочники.КлассификаторОрганизацийЕГАИС.ОрганизацияЕГАИСПоОрганизацииИТорговомуОбъекту(ДокументОснование.Организация, 
																												ДокументОснование.МагазинОтправитель,,Ложь);
	ЭтоОрганизацияЕГАИС = ЗначениеЗаполнено(ОрганизацияЕГАИС);
	
	Если НЕ ЭтоОрганизацияЕГАИС Тогда
		
		Текст = НСтр("ru = 'Отправитель не является участником ЕГАИС.'"); 
		ВызватьИсключение Текст;
		
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ДокументОснование", ДокументОснование);
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ЧекЕГАИС.Ссылка КАК Ссылка
	|ИЗ
	|	Документ.ЧекЕГАИС КАК ЧекЕГАИС
	|ГДЕ
	|	ЧекЕГАИС.ДокументОснование = &ДокументОснование
	|	И НЕ ЧекЕГАИС.ПометкаУдаления
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ТТНИсходящаяЕГАИС.Ссылка
	|ИЗ
	|	Документ.ТТНИсходящаяЕГАИС КАК ТТНИсходящаяЕГАИС
	|ГДЕ
	|	ТТНИсходящаяЕГАИС.ДокументОснование = &ДокументОснование
	|	И НЕ ТТНИсходящаяЕГАИС.ПометкаУдаления";
	
	Возврат Запрос.Выполнить().Пустой();
	
КонецФункции

#КонецОбласти
