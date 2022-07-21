#Область ОписаниеПеременных

&НаКлиенте
Перем ПараметрыПроверки; // см. ШтрихкодированиеИСМПКлиент.НовыеПараметрыПроверкиНаККТ - 
&НаКлиенте
Перем ВыполняемыеОперации; // см. ВыполняемыеОперации

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Элементы.Прогресс.Видимость = Ложь;
	
	ДанныеСтрокиСообщения = Новый Массив();
	ДанныеСтрокиСообщения.Добавить(НСтр("ru = 'Подготовка к проверке средствами ККТ пожалуйста, подождите...'"));
	
	Элементы.ДекорацияПоясняющийТекстДлительнойОперации.Заголовок = Новый ФорматированнаяСтрока(ДанныеСтрокиСообщения);
	
	СброситьРазмерыИПоложениеОкна();
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ПрерватьОперацию", "Доступность", Ложь);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, ВходящиеПараметрыПроверки, Источник)
	
	Если ВладелецФормы <> Источник
		Или Источник = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если ИмяСобытия = "НачалоПроверки" Тогда
		
		ПараметрыПроверки = ВходящиеПараметрыПроверки;
		ТекущаяОперация   = ВыполняемыеОперации.ЛокальнаяПроверка;
		
		СледующийШаг();
		
	КонецЕсли;
	
	НастроитьПредставление();
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Если ЗавершениеРаботы
		Или ЗакрытиеОкнаРазрешено Тогда
		Возврат;
	КонецЕсли;
	
	Отказ = Истина;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийКомандФормы

&НаКлиенте
Процедура ПрерватьОперацию(Команда)
	
	ПрерываниеОперации();
	Элементы.ПрерватьОперацию.Доступность = Ложь;
	Элементы.ПрерватьОперацию.Заголовок   = НСтр("ru = 'Отменено'");
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура ДекорацияПоясняющийТекстДлительнойОперацииОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	Если НавигационнаяСсылкаФорматированнойСтроки = "СкопироватьШтриховойКодВБуферОбмена" Тогда
		
		СтандартнаяОбработка = Ложь;
		ИнтеграцияИСКлиент.СкопироватьШтрихКодВБуферОбмена(Элементы.БуферОбмена, КодМаркировки);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОписаниеОповещений

&НаКлиенте
Процедура ЛокальнаяПроверкаСредствамиККТЗавершение(ДанныеОтвета, ПараметрыПроверки) Экспорт
	
	ЭлементПроверки           = ПараметрыПроверки.ЭлементыПроверки[ПараметрыПроверки.ТекущийИндекс];
	РезультатЭлементаПроверки = ПараметрыПроверки.Результат.ДанныеПроверки.Получить(ЭлементПроверки.ИдентификаторЭлемента);
	ВыходныеПараметры         = ВыходныеПараметрыИзРезультатаБПО(ДанныеОтвета);
	
	Если ПараметрыПроверки.ВыполняетсяЛогирование
		И ВыходныеПараметры <> Неопределено Тогда
		
		ДанныеРезультата = Новый Массив();
		
		Если ВыходныеПараметры.Свойство("РезультатXML")
			И ЗначениеЗаполнено(ВыходныеПараметры.РезультатXML) Тогда
			ДанныеРезультата.Добавить(ВыходныеПараметры.РезультатXML);
		КонецЕсли;
		
		Если Не ДанныеОтвета.Результат
			И ЗначениеЗаполнено(ДанныеОтвета.ОписаниеОшибки) Тогда
			ДанныеРезультата.Добавить(ДанныеОтвета.ОписаниеОшибки);
		КонецЕсли;
		
		ТекстЛога = ТекстДляЗаписиВЛогЗапросов(
			НСтр("ru = 'Локальная проверка средствами ККТ'"),
			ПараметрыПроверки,
			ВыходныеПараметры.ЗапросXML,
			СтрСоединить(ДанныеРезультата, Символы.ПС));
		ЛогированиеЗапросовИСМПКлиент.Вывести(ТекстЛога);
		
	КонецЕсли;
	
	Если ДанныеОтвета.Результат Тогда
		
		РезультатЭлементаПроверки.КодМаркировкиПроверен = ВыходныеПараметры.КодМаркировкиПроверен;
		РезультатЭлементаПроверки.РезультатПроверки     = ВыходныеПараметры.РезультатПроверки;
		ТекущаяОперация                                 = ВыполняемыеОперации.УдаленнаяПроверка;
	
	Иначе
		
		РезультатЭлементаПроверки.ТекстОшибки         = ДанныеОтвета.ОписаниеОшибки;
		ПараметрыПроверки.Результат.ТекстОшибки       = ДанныеОтвета.ОписаниеОшибки;
		ПараметрыПроверки.Результат.ЕстьОшибки        = Истина;
		ПараметрыПроверки.ЗапрещеноИгнорироватьОшибку = Истина;
		
	КонецЕсли;
	
	СледующийШаг();
	
КонецПроцедуры

&НаКлиенте
Процедура УдаленнаяПроверкаКодаМаркировкиСредствамиККТЗавершение(ДанныеОтвета, ПараметрыПроверки) Экспорт
	
	ЭлементПроверки           = ПараметрыПроверки.ЭлементыПроверки[ПараметрыПроверки.ТекущийИндекс];
	РезультатЭлементаПроверки = ПараметрыПроверки.Результат.ДанныеПроверки.Получить(ЭлементПроверки.ИдентификаторЭлемента);
	ВыходныеПараметры         = ВыходныеПараметрыИзРезультатаБПО(ДанныеОтвета);
	ИнтервалСледующегоШага    = Неопределено;
	
	Если ЭлементПроверки.ПолученРезультатЗапросаКМ Тогда
		Возврат;
	КонецЕсли;
	
	Если ПараметрыПроверки.ВыполняетсяЛогирование Тогда
		
		ДанныеДляЛогирования = Новый Массив();
		
		Если ВыходныеПараметры.Свойство("РезультатXML")
			И ЗначениеЗаполнено(ВыходныеПараметры.РезультатXML) Тогда
			ДанныеДляЛогирования.Добавить(ВыходныеПараметры.РезультатXML);
		КонецЕсли;
		
		Если (ДанныеОтвета.Результат = Ложь Или ДанныеОтвета.Результат = 1)
			И ЗначениеЗаполнено(ДанныеОтвета.ОписаниеОшибки) Тогда
			ДанныеДляЛогирования.Добавить(ДанныеОтвета.ОписаниеОшибки);
		КонецЕсли;
		
		Если ДанныеДляЛогирования.Количество() Тогда
			ТекстЛога = ТекстДляЗаписиВЛогЗапросов(
				НСтр("ru = 'Проверка статуса товара ОИСМ средствами ККТ'"),
				ПараметрыПроверки,,
				СтрСоединить(ДанныеДляЛогирования, Символы.ПС));
			ЛогированиеЗапросовИСМПКлиент.Вывести(ТекстЛога);
		КонецЕсли;
		
	КонецЕсли;
	
	Если ДанныеОтвета.Результат Тогда
		
		РезультатЭлементаПроверки.РезультаПроверкиОИСМ = ВыходныеПараметры.РезультатПроверкиОИСМ;
		РезультатЭлементаПроверки.СтатусТовара         = ВыходныеПараметры.СтатусТовара;
		РезультатЭлементаПроверки.КодРезультатаПроверки           = ВыходныеПараметры.КодРезультатаПроверкиОИСМ;
		РезультатЭлементаПроверки.ПредставлениеРезультатаПроверки = ВыходныеПараметры.РезультатПроверкиОИСМПредставление;
		РезультатЭлементаПроверки.КодОбработкиЗапроса             = ВыходныеПараметры.КодОбработкиЗапроса;
		
		Если ВыходныеПараметры.СтатусРезультата = ПредопределенноеЗначение("Перечисление.СтатусРезультатаЗапросаКМ.Получен")
			Или ВыходныеПараметры.СтатусРезультата = ПредопределенноеЗначение("Перечисление.СтатусРезультатаЗапросаКМ.НеМожетБытьПолучен") Тогда
			
			ТекущаяОперация                           = ВыполняемыеОперации.Подтверждение;
			ЭлементПроверки.ПолученРезультатЗапросаКМ = Истина;
			
		ИначеЕсли ВыходныеПараметры.СтатусРезультата = ПредопределенноеЗначение("Перечисление.СтатусРезультатаЗапросаКМ.Ожидается") Тогда
		
			Если РезультатЭлементаПроверки.ПропуститьОжиданиеОтветаОИСМ Тогда
				ТекущаяОперация = ВыполняемыеОперации.Подтверждение;
			Иначе
				ИнтервалСледующегоШага = 1;
			КонецЕсли;
			
		КонецЕсли;
		
	Иначе
		
		РезультатЭлементаПроверки.ТекстОшибки         = ДанныеОтвета.ОписаниеОшибки;
		ПараметрыПроверки.Результат.ТекстОшибки       = ДанныеОтвета.ОписаниеОшибки;
		ПараметрыПроверки.Результат.ЕстьОшибки        = Истина;
		ПараметрыПроверки.ЗапрещеноИгнорироватьОшибку = Истина;
		
	КонецЕсли;
	
	СледующийШаг(ИнтервалСледующегоШага);
	
КонецПроцедуры

&НаКлиенте
Процедура ПодтверждениеКодаМаркировкиНаККТЗавершение(ДанныеОтвета, ПараметрыПроверки) Экспорт
	
	ЭлементПроверки           = ПараметрыПроверки.ЭлементыПроверки[ПараметрыПроверки.ТекущийИндекс];
	РезультатЭлементаПроверки = ПараметрыПроверки.Результат.ДанныеПроверки.Получить(ЭлементПроверки.ИдентификаторЭлемента);
	
	Если ПараметрыПроверки.ВыполняетсяЛогирование Тогда
		
		ТекстОшибки = Неопределено;
		
		Если Не ДанныеОтвета.Результат Тогда
			ТекстОшибки = ДанныеОтвета.ОписаниеОшибки;
		КонецЕсли;
		
		ТекстЛога = ТекстДляЗаписиВЛогЗапросов(
			НСтр("ru = 'Подтверждение кода маркировки при выбытии'"),
			ПараметрыПроверки,
			ЭлементПроверки.ИдентификаторЗапроса,
			ТекстОшибки);
		
		ЛогированиеЗапросовИСМПКлиент.Вывести(ТекстЛога);
		
	КонецЕсли;
	
	Если ДанныеОтвета.Результат Тогда
		
		РезультатЭлементаПроверки.ПодтвержденНаККТ = Истина;
		
	Иначе
		
		РезультатЭлементаПроверки.ТекстОшибки   = ДанныеОтвета.ОписаниеОшибки;
		ПараметрыПроверки.Результат.ТекстОшибки = ДанныеОтвета.ОписаниеОшибки;
		ПараметрыПроверки.Результат.ЕстьОшибки  = Истина;
		
		ПараметрыПроверки.ЗапрещеноИгнорироватьОшибку = Истина;
		
	КонецЕсли;
	
	СледующийКод();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура Подключаемый_ВыполнениеШагаПроверки()
	
	Если ПараметрыПроверки.ЭлементыПроверки.Количество() = 0
		Или ПараметрыПроверки.ТекущийИндекс > ПараметрыПроверки.ЭлементыПроверки.ВГраница()
		Или ЗначениеЗаполнено(ПараметрыПроверки.Результат.ТекстОшибки)
		Или (ПараметрыПроверки.ПерерватьОперацию
			И ТекущаяОперация = ВыполняемыеОперации.ЛокальнаяПроверка) Тогда
		
		ОбработкаРезультатаПроверкиСредствамиККТ();
		
		ЗакрытьОкно();
		
		Если ПараметрыПроверки.ПерерватьОперацию Тогда
		
			Если Не ПараметрыПроверки.ЭтоСканирование  Тогда
				ВыполнитьОбработкуОповещения(ПараметрыПроверки.ОповещениеОЗавершении, ПараметрыПроверки.Результат);
			КонецЕсли;
			
		ИначеЕсли Не ПроверкаСредствамиККТВыполненаСОшибками() Тогда
			
			Если Не ПараметрыПроверки.ЭтоСканирование  Тогда
				ПараметрыПроверки.Результат.ВыполнитьФискализацию = Истина;
			КонецЕсли;
			
			ВыполнитьОбработкуОповещения(ПараметрыПроверки.ОповещениеОЗавершении, ПараметрыПроверки.Результат);
			
		КонецЕсли;
		
		Возврат;
	
	КонецЕсли;
	
	НастроитьПредставление();
	
	Если ТекущаяОперация = ВыполняемыеОперации.ЛокальнаяПроверка Тогда
		
		ЛокальнаяПроверкаИОтправкаЗапроса();
		
	ИначеЕсли ТекущаяОперация = ВыполняемыеОперации.УдаленнаяПроверка Тогда
		
		ПолучениеРезультатаУдаленнойПроверки();
		
	ИначеЕсли ТекущаяОперация = ВыполняемыеОперации.Подтверждение Тогда
		
		ПодтверждениеКодаМаркировки();
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЛокальнаяПроверкаИОтправкаЗапроса()
	
	ЭлементПроверки   = ПараметрыПроверки.ЭлементыПроверки[ПараметрыПроверки.ТекущийИндекс];
	РезультатПроверки = ПараметрыПроверки.Результат.ДанныеПроверки[ЭлементПроверки.ИдентификаторЭлемента];
	
	ПараметрыЗапросаКМ                            = МенеджерОборудованияКлиентСервер.ПараметрыЗапросКМ();
	ПараметрыЗапросаКМ.ИдентификаторЗапроса       = ЭлементПроверки.ИдентификаторЗапроса;
	ПараметрыЗапросаКМ.Количество                 = 1;
	ПараметрыЗапросаКМ.КонтрольнаяМарка           = ЭлементПроверки.ПолныйКодМаркировки;
	ПараметрыЗапросаКМ.ПланируемыйСтатусТовара    = ЭлементПроверки.ПланируемыйСтатусТовара;
	ПараметрыЗапросаКМ.ОжидатьПолучениеОтветаОИСМ = (Не РезультатПроверки.ПропуститьОжиданиеОтветаОИСМ);
	
	ПараметрыЗапросаКМ.ДробноеКоличество.Числитель   = ЭлементПроверки.ЧастичноеВыбытиеКоличество;
	ПараметрыЗапросаКМ.ДробноеКоличество.Знаменатель = ЭлементПроверки.ЕмкостьПотребительскойУпаковки;
	ПараметрыЗапросаКМ.КодЕдиницыИзмерения           = ЭлементПроверки.КодЕдиницыИзмерения;
	
	Если Не ЗначениеЗаполнено(ПараметрыЗапросаКМ.КонтрольнаяМарка) Тогда
		РезультатПроверки.ТребуетсяПолныйКодМаркировки = Истина;
		ПараметрыПроверки.ЗапрещеноИгнорироватьОшибку  = Истина;
		СледующийКод();
		Возврат;
	КонецЕсли;
	
	Если Не ПараметрыПроверки.ЭтоСканирование Тогда
		
		ИдентификаторСессии = МенеджерОборудованияКлиент.СессияПроверкиКодовМаркировки(ПараметрыПроверки.ИдентификаторУстройства);
		
		Если ИдентификаторСессии <> Неопределено Тогда
			
			РезультатПроверки = МенеджерОборудованияКлиент.РезультатПроверкиКодаМаркировки(
				ПараметрыПроверки.ИдентификаторУстройства,
				ИдентификаторСессии,
				ПараметрыЗапросаКМ);
			
			Если РезультатПроверки <> Неопределено Тогда
				СледующийКод();
				Возврат;
			КонецЕсли;
			
		КонецЕсли;
	
	КонецЕсли;
	
	ЛокальнаяПроверкаСредствамиККТЗавершение = Новый ОписаниеОповещения(
		"ЛокальнаяПроверкаСредствамиККТЗавершение",
		ЭтотОбъект,
		ПараметрыПроверки);
	
	МенеджерОборудованияКлиент.НачатьЗапросКМ(
		ЛокальнаяПроверкаСредствамиККТЗавершение,
		ШтрихкодированиеИСМПКлиент.ФормаБлокировкиПоПараметрамПроверки(ПараметрыПроверки).УникальныйИдентификатор,
		ПараметрыЗапросаКМ,
		ПараметрыПроверки.ИдентификаторУстройства);
	
КонецПроцедуры

&НаКлиенте
Процедура ПолучениеРезультатаУдаленнойПроверки()
	
	УдаленнаяПроверкаКодаМаркировкиСредствамиККТЗавершение = Новый ОписаниеОповещения(
		"УдаленнаяПроверкаКодаМаркировкиСредствамиККТЗавершение",
		ЭтотОбъект,
		ПараметрыПроверки);
	
	МенеджерОборудованияКлиент.НачатьПолученияРезультатовЗапросаКМ(
		УдаленнаяПроверкаКодаМаркировкиСредствамиККТЗавершение,
		ШтрихкодированиеИСМПКлиент.ФормаБлокировкиПоПараметрамПроверки(ПараметрыПроверки).УникальныйИдентификатор,
		Неопределено,
		ПараметрыПроверки.ИдентификаторУстройства);
	
КонецПроцедуры

&НаКлиенте
Процедура ПодтверждениеКодаМаркировки()
	
	ЭлементПроверки          = ПараметрыПроверки.ЭлементыПроверки[ПараметрыПроверки.ТекущийИндекс];
	ПараметрыПодтвержденияКМ = МенеджерОборудованияКлиентСервер.ПараметрыПодтверждениеКМ();
	ПараметрыПодтвержденияКМ.ИдентификаторЗапроса = ЭлементПроверки.ИдентификаторЗапроса;
	
	ПодтверждениеКодаМаркировкиНаККТЗавершение = Новый ОписаниеОповещения(
		"ПодтверждениеКодаМаркировкиНаККТЗавершение",
		ЭтотОбъект,
		ПараметрыПроверки);
	
	МенеджерОборудованияКлиент.НачатьПодтверждениеКМ(
		ПодтверждениеКодаМаркировкиНаККТЗавершение,
		ШтрихкодированиеИСМПКлиент.ФормаБлокировкиПоПараметрамПроверки(ПараметрыПроверки),
		ПараметрыПодтвержденияКМ,
		ПараметрыПроверки.ИдентификаторУстройства);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция ВыполняемыеОперации()
	
	ВозвращаемоеЗначение= Новый Структура();
	ВозвращаемоеЗначение.Вставить("ЛокальнаяПроверка", "ЛокальнаяПроверка");
	ВозвращаемоеЗначение.Вставить("УдаленнаяПроверка", "УдаленнаяПроверка");
	ВозвращаемоеЗначение.Вставить("Подтверждение",     "Подтверждение");
	
	Возврат ВозвращаемоеЗначение;
	
КонецФункции

&НаКлиенте
Процедура СледующийКод()
	
	ТекущаяОперация                 = ВыполняемыеОперации.ЛокальнаяПроверка;
	ПараметрыПроверки.ТекущийИндекс = ПараметрыПроверки.ТекущийИндекс + 1;
	СледующийШаг();
	
КонецПроцедуры

&НаКлиенте
Процедура СледующийШаг(Знач Интервал = Неопределено)
	
	Если Не ЗначениеЗаполнено(Интервал) Тогда
		Интервал = 0.1;
	КонецЕсли;
	
	ПодключитьОбработчикОжидания("Подключаемый_ВыполнениеШагаПроверки", Интервал, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаРезультатаПроверкиСредствамиККТ()
	
	Для Каждого СтрокаПроверки Из ПараметрыПроверки.Результат.ЭлементыПроверки Цикл
		
		РезультатПроверкиСтроки = ПараметрыПроверки.Результат.ДанныеПроверки[СтрокаПроверки.ИдентификаторЭлемента];
		
		Если Не ПараметрыПроверки.ЭтоСканирование
			И ШтрихкодированиеИСМПКлиент.РежимПроверкиПриСканировании()
			И Не (РезультатПроверкиСтроки.ПодтвержденНаККТ
				Или РезультатПроверкиСтроки.ТребуетсяПолныйКодМаркировки) Тогда
			Продолжить;
		КонецЕсли;
		
		Если Не РезультатПроверкиСтроки.ОтображатьОшибки
			И Не РезультатПроверкиСтроки.ТребуетсяПолныйКодМаркировки Тогда
			Продолжить;
		КонецЕсли;
		
		ДанныеПредставления = ШтрихкодированиеИСМПКлиентСервер.ДанныеПредставленияРезультатовПроверкиСредствамиККТ(РезультатПроверкиСтроки);
		
		Если ДанныеПредставления.ЕстьОшибки Тогда
			РезультатПроверкиСтроки.ПредставлениеВЧеке = ДанныеПредставления.ПредставлениеВЧеке;
			РезультатПроверкиСтроки.ТекстОшибки        = ДанныеПредставления.ОписаниеОшибок;
			ПараметрыПроверки.Результат.ЕстьОшибки     = Истина;
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Функция ПроверкаСредствамиККТВыполненаСОшибками()
	
	Если Не ПараметрыПроверки.Результат.ЕстьОшибки Тогда
		Возврат Ложь;
	КонецЕсли;
	
	ПараметрыСканирования = ПараметрыПроверки.ПараметрыСканирования;
	
	ПараметрыОткрытияФормы = ШтрихкодированиеИСКлиент.ПараметрыОткрытияФормыНевозможностиДобавленияОтсканированного();
	ПараметрыОткрытияФормы.ТекстОшибки               = ПараметрыПроверки.Результат.ТекстОшибки;
	ПараметрыОткрытияФормы.Организация               = ПараметрыСканирования.Организация;
	ПараметрыОткрытияФормы.ИмяФормыИсточник          = ПараметрыПроверки.ФормаОсновногоОбъекта.ИмяФормы;
	
	ПараметрыОписания = ШтрихкодированиеИСМПКлиентСервер.ПараметрыРасширенногоОписанияОшибки();
	
	ПараметрыОписания.ВозможноИгнорировать = (Не ПараметрыПроверки.ЗапрещеноИгнорироватьОшибку);
	ПараметрыОписания.ДанныеПроверкиНаККТ  = ПараметрыПроверки.Результат;
	ПараметрыОписания.ЗаголовокПродолжить  = ПараметрыПроверки.ЗаголовокКнопкиИгнорировать;
	ПараметрыОткрытияФормы.ПараметрыОшибки = ПараметрыОписания;
	
	Для Каждого ЭлементПроверки Из ПараметрыПроверки.Результат.ЭлементыПроверки Цикл
		
		РезультатПроверкиСтроки = ПараметрыПроверки.Результат.ДанныеПроверки[ЭлементПроверки.ИдентификаторЭлемента];
		Если ЗначениеЗаполнено(РезультатПроверкиСтроки.ТекстОшибки) Тогда
			ПараметрыОткрытияФормы.ВидПродукции = ЭлементПроверки.ВидПродукции;
			Прервать;
		КонецЕсли;
		
	КонецЦикла;
	
	ПараметрыОповещенияОбертки = Новый Структура;
	ПараметрыОповещенияОбертки.Вставить("ПараметрыПроверки", ПараметрыПроверки);
	
	ОповещениеОЗакрытииФормыОшибки = Новый ОписаниеОповещения(
		"ОповещениеОЗакрытииФормыОшибки",
		ШтрихкодированиеИСМПКлиент,
		ПараметрыОповещенияОбертки);
	
	ШтрихкодированиеИСМПКлиент.ОткрытьФормуНевозможностиДобавленияОтсканированного(
		ШтрихкодированиеИСМПКлиент.ФормаБлокировкиПоПараметрамПроверки(ПараметрыПроверки),
		ПараметрыОткрытияФормы,
		ОповещениеОЗакрытииФормыОшибки);
	
	Возврат Истина;
	
КонецФункции

&НаКлиенте
Функция ТекстДляЗаписиВЛогЗапросов(Операция, ПараметрыПроверки, ЗапросXML = Неопределено, РезультатXML = Неопределено)
	
	СтрокиЛога = Новый Массив;
	
	СтрокиЛога.Добавить(СтрШаблон(
		НСтр("ru = 'Операция: %1 (%2)'"),
		Операция,
		ПараметрыПроверки.ИдентификаторУстройства));
	
	Если ЗначениеЗаполнено(ЗапросXML) Тогда
		СтрокиЛога.Добавить(НСтр("ru = 'Запрос:'"));
		СтрокиЛога.Добавить(ЗапросXML);
	КонецЕсли;
	
	Если ЗначениеЗаполнено(РезультатXML) Тогда
		СтрокиЛога.Добавить(НСтр("ru = 'Результат:'"));
		СтрокиЛога.Добавить(РезультатXML);
	КонецЕсли;
	
	Возврат СтрСоединить(СтрокиЛога, Символы.ПС);
	
КонецФункции

&НаКлиенте
Функция ВыходныеПараметрыИзРезультатаБПО(ДанныеОтвета)
	
	Если ИнтеграцияИСМПКлиентСерверПовтИсп.РедакцияБПО() = 2 Тогда
		Если ДанныеОтвета.ВыходныеПараметры <> Неопределено
			И ТипЗнч(ДанныеОтвета.ВыходныеПараметры[0]) = Тип("Структура") Тогда
			Возврат ДанныеОтвета.ВыходныеПараметры[0];
		Иначе
			Возврат Неопределено;
		КонецЕсли;
	Иначе
		Возврат ДанныеОтвета;
	КонецЕсли;
	
КонецФункции

&НаКлиенте
Процедура ПрерываниеОперации()
	
	ПараметрыПроверки.ПерерватьОперацию = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗакрытьОкно(РезультаЗакрытия = Ложь)
	
	ЗакрытиеОкнаРазрешено = Истина;
	Закрыть(РезультаЗакрытия);
	
КонецПроцедуры

&НаКлиенте
Процедура НастроитьПредставление()
	
	ЭлементПроверки       = ПараметрыПроверки.ЭлементыПроверки[ПараметрыПроверки.ТекущийИндекс]; 
	КодМаркировки         = ЭлементПроверки.КодМаркировки;
	КоличествоЭлементов   = ПараметрыПроверки.ЭлементыПроверки.Количество();
	НомерТекущегоЭлемента = ПараметрыПроверки.ТекущийИндекс + 1;
	Суффикс               = Неопределено;
	
	ДанныеСтрокиСообщения = Новый Массив();
	Если ТекущаяОперация = ВыполняемыеОперации.ЛокальнаяПроверка Тогда
		ДанныеСтрокиСообщения.Добавить(НСтр("ru = 'Выполняется локальная проверка кода маркировки'"));
		Суффикс = НСтр("ru = 'на ККТ. Пожалуйста, подождите...'");
	ИначеЕсли ТекущаяОперация = ВыполняемыеОперации.УдаленнаяПроверка Тогда
		ДанныеСтрокиСообщения.Добавить(НСтр("ru = 'Выполняется проверка статуса кода маркировки ОИСМ'"));
		Суффикс = НСтр("ru = 'средствами ККТ. Пожалуйста, подождите...'");
	ИначеЕсли ТекущаяОперация = ВыполняемыеОперации.Подтверждение Тогда
		ДанныеСтрокиСообщения.Добавить(НСтр("ru = 'Выполняется подтверждение кода маркировки'"));
		Суффикс = НСтр("ru = 'на ККТ. Пожалуйста, подождите...'");
	КонецЕсли;
	
	ДанныеСтрокиСообщения.Добавить(" ");
	ДанныеСтрокиСообщения.Добавить(Новый ФорматированнаяСтрока(КодМаркировки,,,, "СкопироватьШтриховойКодВБуферОбмена"));
	
	Если КоличествоЭлементов > 1 Тогда
		
		Элементы.Прогресс.РасширеннаяПодсказка.Заголовок = СтрШаблон(
			НСтр("ru = 'Код маркировки %1 из %2'"),
			НомерТекущегоЭлемента,
			КоличествоЭлементов);
		
		Элементы.Прогресс.Видимость = Истина;
		
		Если КоличествоЭлементов <> 0 Тогда
			Прогресс = Окр(НомерТекущегоЭлемента / КоличествоЭлементов * 100);
		КонецЕсли;
		
	КонецЕсли;
	
	ДанныеСтрокиСообщения.Добавить(Символы.ПС);
	Если ЗначениеЗаполнено(Суффикс) Тогда
		ДанныеСтрокиСообщения.Добавить(Суффикс);
	КонецЕсли;
	
	Элементы.ДекорацияПоясняющийТекстДлительнойОперации.Заголовок = Новый ФорматированнаяСтрока(ДанныеСтрокиСообщения);
	Элементы.ПрерватьОперацию.Видимость                           = (Не ПараметрыПроверки.ЭтоСканирование);
	
КонецПроцедуры

&НаСервере
Процедура СброситьРазмерыИПоложениеОкна()
	
	ИмяПользователя = ПользователиИнформационнойБазы.ТекущийПользователь().Имя;
	Если ПравоДоступа("СохранениеДанныхПользователя", Метаданные) Тогда
		ХранилищеСистемныхНастроек.Удалить("ОбщаяФорма.ОжиданиеПроверкиКодовМаркировкиИСМП", "", ИмяПользователя);
	КонецЕсли;
	КлючСохраненияПоложенияОкна = Строка(Новый УникальныйИдентификатор);
	
КонецПроцедуры

#КонецОбласти

ВыполняемыеОперации = ВыполняемыеОперации();
