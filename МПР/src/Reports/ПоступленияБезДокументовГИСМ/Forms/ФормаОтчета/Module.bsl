
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Если Параметры.Свойство("Организация") Тогда
		Отчет.ОтборОрганизация = Параметры.Организация;
	КонецЕсли;
	Элементы.ОтправитьПоЭлектроннойПочте.Видимость = РаботаСПочтовымиСообщениями.ДоступнаОтправкаПисем();
	
	СобытияФормИСПереопределяемый.ПриСозданииНаСервере(ЭтотОбъект, Отказ, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура РезультатОбработкаРасшифровки(Элемент, Расшифровка, СтандартнаяОбработка)
	
	Если ТипЗнч(Расшифровка) = Тип("Структура")
		И Расшифровка.Свойство("НомерКиЗ")
		И Расшифровка.Свойство("Контрагент")
		И Расшифровка.Свойство("Организация") 
		И Расшифровка.Свойство("ИмяНабораДанных") Тогда
		
		СтандартнаяОбработка = Ложь;
		ПараметрыОткрытия = ДокументыПоОрганизацииКонтрагентуНомеруКиз(Расшифровка);
		ПараметрыОткрытия.Вставить("НомерКиЗ",        Расшифровка.НомерКиЗ);
		ПараметрыОткрытия.Вставить("Контрагент",      Расшифровка.Контрагент);
		ПараметрыОткрытия.Вставить("Организация",     Расшифровка.Организация);
		ПараметрыОткрытия.Вставить("ИмяНабораДанных", Расшифровка.ИмяНабораДанных);
		ОткрытьФорму("Отчет.ПоступленияБезДокументовГИСМ.Форма.СписокДокументов", ПараметрыОткрытия, ЭтотОбъект,,,,,РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
		
		Возврат;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПередЗагрузкойДанныхИзНастроекНаСервере(Настройки)
	
	Если ЗначениеЗаполнено(Отчет.ОтборОрганизация) 
		И Настройки.Получить("Отчет.ОтборОрганизация") <> Неопределено Тогда
		Настройки.Удалить("Отчет.ОтборОрганизация");
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	
	УстановитьСостояниеОтчетНеСформирован();
	
КонецПроцедуры

&НаКлиенте
Процедура КонтрагентПриИзменении(Элемент)
	
	УстановитьСостояниеОтчетНеСформирован();
	
КонецПроцедуры

&НаКлиенте
Процедура ПоступленияЗаказанныхКиЗПриИзменении(Элемент)
	
	УстановитьСостояниеОтчетНеСформирован();
	
КонецПроцедуры

&НаКлиенте
Процедура ПоступленияМаркированныхТоваровПриИзменении(Элемент)
	
	УстановитьСостояниеОтчетНеСформирован();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Сформировать(Команда)
	
	СформироватьНаКлиенте();
	
КонецПроцедуры

&НаКлиенте
Процедура ОтправитьПоЭлектроннойПочте(Команда)
	
	ОтображениеСостояния = Элементы.Результат.ОтображениеСостояния;
	Если ОтображениеСостояния.Видимость = Истина
		И ОтображениеСостояния.ДополнительныйРежимОтображения = ДополнительныйРежимОтображения.Неактуальность Тогда
		ТекстВопроса = НСтр("ru = 'Отчет не сформирован. Сформировать?'");
		Обработчик = Новый ОписаниеОповещения("СформироватьПередОтправкойПоПочте", ЭтотОбъект);
		ПоказатьВопрос(Обработчик, ТекстВопроса, РежимДиалогаВопрос.ДаНет, 60, КодВозвратаДиалога.Да);
	Иначе
		ПоказатьДиалогОтправкиПоПочте();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура СформироватьПередОтправкойПоПочте(Ответ, ДополнительныеПараметры) Экспорт
	Если Ответ = КодВозвратаДиалога.Да Тогда
		Обработчик = Новый ОписаниеОповещения("ОтправитьПоПочтеПослеФормирования", ЭтотОбъект);
		ОтчетыКлиент.СформироватьОтчет(ЭтотОбъект, Обработчик);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ОтправитьПоПочтеПослеФормирования(ТабличныйДокументСформирован, ДополнительныеПараметры) Экспорт
	Если ТабличныйДокументСформирован Тогда
		ПоказатьДиалогОтправкиПоПочте();
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура СформироватьОтчетНаСервере()

	Результат.Очистить();
	ОбъектОтчет =  РеквизитФормыВЗначение("Отчет");
	
	ОбъектОтчет.СформироватьОтчет(Результат);
	
	ЗначениеВРеквизитФормы(ОбъектОтчет, "Отчет");
	
КонецПроцедуры
	
&НаКлиенте
Функция НастройкиОтчетаКорректны()
	
	ОчиститьСообщения();
	
	НастройкиОтчетаКорректны = Истина;
	
	Если Не Отчет.ПоступленияЗаказанныхКиЗ И Не Отчет.ПоступленияМаркированныхТоваров Тогда
		
		НастройкиОтчетаКорректны = Ложь;

		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'Не указан ни один из типов документов поступления для анализа'"), ,"ПоступленияЗаказанныхКиЗ", "Отчет");
		
	КонецЕсли;
	
	Возврат НастройкиОтчетаКорректны;
	
КонецФункции

&НаКлиенте
Процедура СформироватьНаКлиенте()

	Если НастройкиОтчетаКорректны() Тогда
		
		СформироватьОтчетНаСервере();
		Элементы.Результат.ОтображениеСостояния.ДополнительныйРежимОтображения = ДополнительныйРежимОтображения.НеИспользовать;
		Элементы.Результат.ОтображениеСостояния.Видимость = Ложь;
		
	КонецЕсли;

КонецПроцедуры

&НаСервере
Функция ДокументыПоОрганизацииКонтрагентуНомеруКиз(СтруктураПоиска)

	СтруктураВозврата = Новый Структура;
	
	НайденныеПоступления = Отчет.Поступления.НайтиСтроки(СтруктураПоиска);
	МассивПоступлений    = Новый Массив;
	Для Каждого НайденноеПоступление Из НайденныеПоступления Цикл
		МассивПоступлений.Добавить(НайденноеПоступление.ДокументПоступления);
	КонецЦикла;
	
	НайденныеДокументыГИСМ = Отчет.ДокументыГИСМ.НайтиСтроки(СтруктураПоиска);
	МассивДокументыГИСМ    = Новый Массив;
	Для Каждого НайденныйДокументГИСМ Из НайденныеДокументыГИСМ Цикл
		МассивДокументыГИСМ.Добавить(НайденныйДокументГИСМ.ДокументГИСМ);
	КонецЦикла;
	
	СтруктураВозврата.Вставить("Поступления",   МассивПоступлений);
	СтруктураВозврата.Вставить("ДокументыГИСМ", МассивДокументыГИСМ);
	
	Возврат СтруктураВозврата;
	
КонецФункции

&НаКлиенте
Процедура УстановитьСостояниеОтчетНеСформирован()
	
	Элементы.Результат.ОтображениеСостояния.ДополнительныйРежимОтображения = ДополнительныйРежимОтображения.Неактуальность;
	Элементы.Результат.ОтображениеСостояния.Текст = НСтр("ru = 'Отчет не сформирован. Нажмите ""Сформировать"" для получения отчета.'");
	Элементы.Результат.ОтображениеСостояния.Видимость = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьДиалогОтправкиПоПочте()
	
	Вложение = Новый Структура;
	Вложение.Вставить("АдресВоВременномХранилище", ПоместитьВоВременноеХранилище(Результат, УникальныйИдентификатор));
	Вложение.Вставить("Представление", Заголовок);
	
	СписокВложений = ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(Вложение);
	
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.РаботаСПочтовымиСообщениями") Тогда
		МодульРаботаСПочтовымиСообщениямиКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("РаботаСПочтовымиСообщениямиКлиент");
		ПараметрыОтправки = МодульРаботаСПочтовымиСообщениямиКлиент.ПараметрыОтправкиПисьма();
		ПараметрыОтправки.Тема = Заголовок;
		ПараметрыОтправки.Вложения = СписокВложений;
		МодульРаботаСПочтовымиСообщениямиКлиент.СоздатьНовоеПисьмо(ПараметрыОтправки);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
