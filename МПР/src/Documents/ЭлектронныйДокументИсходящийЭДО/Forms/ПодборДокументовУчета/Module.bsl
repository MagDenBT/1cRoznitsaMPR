
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Параметры.Свойство("ДокументРаспознан", ДокументРаспознан);
	
	Если Параметры.Свойство("ЭлектронныйДокумент", ЭлектронныйДокумент)
		 И Параметры.Свойство("ВидДокумента", ВидДокумента) Тогда
		
		Основания.Загрузить(ИнтеграцияЭДО.ОбъектыУчетаЭлектронныхДокументов(ЭлектронныйДокумент));		

		Если ДокументРаспознан Тогда
			СписокТиповДокументов = ЭлектронныеДокументыЭДО.СписокОперацийВидаДокумента(ВидДокумента);
		Иначе
			СписокТиповДокументов = ИнтеграцияЭДО.СписокОперацийВсехТиповДокумента();
		КонецЕсли;
		
		Если СписокТиповДокументов.Количество() = 0 Тогда
			Элементы.ГруппаПодобрать.Видимость = Ложь;
			Элементы.ГруппаСоздать.Видимость = Ложь;
			Элементы.ФормаПодобратьДокумент.Видимость = Ложь;
			
		ИначеЕсли СписокТиповДокументов.Количество() = 1 Тогда
			
			Элементы.ГруппаПодобрать.Видимость = Ложь;
			Элементы.ГруппаСоздать.Видимость = Ложь;
			
			НоваяКоманда = ЭтотОбъект.Команды.Добавить("Создать_" + СписокТиповДокументов[0].Значение);
			НоваяКоманда.Действие = "СоздатьДокументУчета";
			Элементы.ФормаСоздатьДокумент.ИмяКоманды = "Создать_" + СписокТиповДокументов[0].Значение;

			НоваяКоманда = ЭтотОбъект.Команды.Добавить("Прикрепить_" + СписокТиповДокументов[0].Значение);
			НоваяКоманда.Действие = "ПодобратьДокумент";
			Элементы.ФормаПодобратьДокумент.ИмяКоманды = "Прикрепить_" + СписокТиповДокументов[0].Значение;
			
		Иначе
			
			Элементы.ФормаПодобратьДокумент.Видимость = Ложь;
			Элементы.ФормаСоздатьДокумент.Видимость = Ложь;
			
			Для Каждого ЭлементСписка Из СписокТиповДокументов Цикл
				
				НоваяКоманда = ЭтотОбъект.Команды.Добавить("Прикрепить_" + ЭлементСписка.Значение);
				НоваяКоманда.Действие = "ПодобратьДокумент";
				
				НоваяКнопка = Элементы.Добавить("Прикрепить_" + ЭлементСписка.Значение,Тип("КнопкаФормы"),Элементы.ГруппаПодобрать);
				НоваяКнопка.Заголовок = ЭлементСписка.Представление;  
				НоваяКнопка.ИмяКоманды = "Прикрепить_" + ЭлементСписка.Значение;
				
			КонецЦикла;
			
		КонецЕсли;
		
		Если ВидДокумента.ТипДокумента = Перечисления.ТипыДокументовЭДО.КаталогТоваров Тогда
			Элементы.ФормаПерезаполнитьТекущий.Заголовок = НСтр("ru = 'Сопоставить номенклатуру'");
		КонецЕсли;
		
		ВидыДокументовДляПроизвольногоФормата = ЭлектронныеДокументыЭДО.ВидыДокументовДляПроизвольногоФормата();
		Элементы.ЭлектронныйДокументДокументыОснованияУдалитьДокумент.Видимость = ВидыДокументовДляПроизвольногоФормата.Найти(
			ВидДокумента) <> Неопределено;
		Элементы.ЭлектронныйДокументДокументыОснованияУдалитьДокумент.ТолькоВоВсехДействиях = Ложь;
		
	Иначе
		Отказ = Истина;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаКлиенте
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ТекСтрока = Элементы.Список.ТекущиеДанные;
	
	Если ТекСтрока <> Неопределено Тогда
		ПоказатьЗначение(, ТекСтрока.ОбъектУчета);	
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПодобратьДокумент(Команда)
	
	Модифицированность = Ложь;
	СпособОбработки = СтрЗаменить(Команда.Имя,"Прикрепить_","");
	Тип = ПолучитьИмяДокументаНаСервере(СпособОбработки); 
	Если ЗначениеЗаполнено(Тип) Тогда
		ОписаниеОповещения = Новый ОписаниеОповещения("ПодобратьДокументЗавершить", ЭтотОбъект, СпособОбработки);
		Подсказка = НСтр("ru = 'Укажите документ отражения в учете'");
		ПоказатьВводЗначения(ОписаниеОповещения, , Подсказка, Новый ОписаниеТипов(Тип));
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура УдалитьСвязьСДокументом(Команда)
		
	ТекСтрока = Элементы.Список.ТекущиеДанные;
	
	Если ТекСтрока <> Неопределено Тогда
		ТекстВопроса = НСтр("ru = 'Связь между документами разорвется. Повторно связать документы возможно только в ручном режиме. Продолжить?'");
		ОписаниеОповещения = Новый ОписаниеОповещения("УдалитьСвязьСДокументомЗавершить", ЭтотОбъект, ТекСтрока.ОбъектУчета);
		ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, РежимДиалогаВопрос.ДаНет, , КодВозвратаДиалога.Нет);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПерезаполнитьТекущий(Команда)
	
	Модифицированность = Ложь;
	ТекСтрока = Элементы.Список.ТекущиеДанные;
	
	Если ТекСтрока <> Неопределено Тогда
		ТекстВопроса = НСтр("ru = 'Документ учета будет заполнены данными электронного документа. Продолжить?'");
		СтруктураПараметров = Новый Структура("ДокументОснование,СпособОбработки",ТекСтрока.ДокументОснование,ТекСтрока.СпособОбработки);
		ОписаниеОповещения = Новый ОписаниеОповещения("ПерезаполнитьТекущийПродолжить", ЭтотОбъект, СтруктураПараметров);
		ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, РежимДиалогаВопрос.ДаНет, , КодВозвратаДиалога.Нет);
	КонецЕсли;
	
КонецПроцедуры


#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ПодобратьДокументЗавершить(Знач Результат, Знач СпособОбработки) Экспорт
	
	Если ЗначениеЗаполнено(Результат) Тогда
		ПерепривязатьЭлектронныйДокумент(Результат,СпособОбработки);
		ОповеститьВладельца();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОповеститьВладельца()
	
	Оповестить("ЭлектронныйДокументИсходящий_ПодборДокументаУчета", ЭлектронныйДокумент, ЭтотОбъект.ВладелецФормы);
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьДокументУчета(Команда)
	
	КонтекстОперации = ОбработкаНеисправностейБЭДКлиент.НовыйКонтекстДиагностики();
	СсылкаНаНовыйДокумент = СоздатьДокументУчетаНаСервере(СтрЗаменить(Команда.Имя,"Создать_",""), КонтекстОперации);
	ОповеститьВладельца();
	ПоказатьЗначение(,СсылкаНаНовыйДокумент);
	ОбработкаНеисправностейБЭДКлиент.ОбработатьОшибки(КонтекстОперации);
	
КонецПроцедуры

&НаСервере
Функция СоздатьДокументУчетаНаСервере(СпособОбработки, КонтекстОперации)
	
	СсылкаНаНовыйДокумент = Неопределено;
	ИнтеграцияЭДО.ПерезаполнитьОбъектУчетаПоЭлектронномуДокументу(СсылкаНаНовыйДокумент, ЭлектронныйДокумент, СпособОбработки, КонтекстОперации);
	
	ОбработатьДокументыОснования(СсылкаНаНовыйДокумент, СпособОбработки);
	
	Возврат СсылкаНаНовыйДокумент;
	
КонецФункции

&НаКлиенте
Процедура УдалитьСвязьСДокументомЗавершить(Результат, СсылкаНаОбъект) Экспорт 
	
	Если Результат = КодВозвратаДиалога.Да Тогда
		УдалитьСвязьСДокументомНаСервере(СсылкаНаОбъект);
		ОповеститьВладельца();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УдалитьСвязьСДокументомНаСервере(СсылкаНаОбъект)
	
	ОбработатьДокументыОснования(СсылкаНаОбъект,,Истина);
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьИмяДокументаНаСервере(СпособОбработки)
	
	ИмяТипа = ИнтеграцияЭДО.ИмяДокументаПоСпособуОбработки(СпособОбработки);
	
	Тип = Неопределено;
	Если Метаданные.Справочники.Найти(ИмяТипа) <> Неопределено Тогда
	
		Тип = "СправочникСсылка." + ИмяТипа;
	ИначеЕсли Метаданные.Документы.Найти(ИмяТипа) <> Неопределено Тогда
	
		Тип = "ДокументСсылка." + ИмяТипа;
	КонецЕсли;
	
	Возврат Тип;
		
КонецФункции

&НаСервере
Процедура ПерепривязатьЭлектронныйДокумент(ВыбранноеЗначение,СпособОбработки)
	
	ОбработатьДокументыОснования(ВыбранноеЗначение,СпособОбработки);
		
КонецПроцедуры

&НаСервере
Процедура ОбработатьДокументыОснования(СсылкаНаДокумент, СпособОбработки = "",Удаление = Ложь)
	
	Если Удаление Тогда
		ИнтеграцияЭДО.РазорватьСвязьЭлектронногоДокументаСОбъектомУчета(ЭлектронныйДокумент, СсылкаНаДокумент);
	Иначе
		ИнтеграцияЭДО.УстановитьСвязьЭлектронногоДокументаСОбъектомУчета(ЭлектронныйДокумент, СсылкаНаДокумент, СпособОбработки);
	КонецЕсли;
	
	Основания.Загрузить(ИнтеграцияЭДО.ОбъектыУчетаЭлектронныхДокументов(ЭлектронныйДокумент));
	
КонецПроцедуры

&НаКлиенте
Процедура ПерезаполнитьТекущийПродолжить(Результат, СтруктураПараметров) Экспорт 
	
	Если Результат = КодВозвратаДиалога.Да Тогда
		
		ПерезаполнитьОбъектУчета(СтруктураПараметров.ОбъектУчета, ЭлектронныйДокумент,
			СтруктураПараметров.СпособОбработки);

		ОповеститьВладельца();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПерезаполнитьОбъектУчета(ОбъектУчета, ЭлектронныйДокумент, СпособОбработки) Экспорт

	ИнтеграцияЭДО.ПерезаполнитьОбъектУчетаПоЭлектронномуДокументу(ОбъектУчета, ЭлектронныйДокумент, СпособОбработки);
	Основания.Загрузить(ИнтеграцияЭДО.ОбъектыУчетаЭлектронныхДокументов(ЭлектронныйДокумент));
	
КонецПроцедуры

#КонецОбласти

