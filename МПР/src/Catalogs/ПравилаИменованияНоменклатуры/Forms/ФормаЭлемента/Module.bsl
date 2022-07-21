#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("РежимВыбораВВидНоменклатуры") Тогда
		РежимВыбораВВидНоменклатуры = Истина;
		Объект.Наименование = Параметры.Наименование;
		СтрокаНаборы = Объект.НаборыСвойств.Добавить();
		СтрокаНаборы.Набор = Параметры.НаборыСвойств;
		ВидНоменклатуры = Параметры.ВидНоменклатуры;
	КонецЕсли;
	
	ЗаблокироватьЭлементыФормы();
	
	// Обработчик подсистемы запрета редактирования реквизитов объектов
    ЗапретРедактированияРеквизитовОбъектов.ЗаблокироватьРеквизиты(ЭтаФорма);
	
	// Режим отладки
	РежимОтладки = ОбщегоНазначения.РежимОтладки()
	             И Пользователи.ЭтоПолноправныйПользователь();
	
	Элементы.СтраницаПараметрыПравила.Видимость = РежимОтладки;
	
	Если РежимОтладки Тогда
		Элементы.СтраницыФормы.ОтображениеСтраниц = ОтображениеСтраницФормы.ЗакладкиСверху;
	КонецЕсли;
	
	УстановитьОтображениеНабораСвойств();
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	РаботаСПравиламиИменования.ОбработатьВидыНоменклатурыПоПравилуИменования(Объект.Ссылка);

	// Обработчик подсистемы запрета редактирования реквизитов объектов
    ЗапретРедактированияРеквизитовОбъектов.ЗаблокироватьРеквизиты(ЭтаФорма);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура НадписьНаборыСвойствНажатие(Элемент)
	
	ПараметрыОткрытия = Новый Структура;
	ПараметрыОткрытия.Вставить("НаборыСвойств",НаборыСвойств());
	ОткрытьФорму("Справочник.ПравилаИменованияНоменклатуры.Форма.НаборыСвойств",ПараметрыОткрытия);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КонструкторПравилаИменования(Команда)
	
	ОткрытьКонструкторПравилаИменования();

КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_РазрешитьРедактированиеРеквизитовОбъекта(Команда)
  	
	Если Не Объект.Ссылка.Пустая() Тогда
		ДополнительныеПараметры = Новый Структура;
		ОбработчикОповещения = Новый ОписаниеОповещения("ОбработкаРазблокированияРеквизитовЗавершение",
														ЭтотОбъект,
														ДополнительныеПараметры);
		ЗапретРедактированияРеквизитовОбъектовКлиент.РазрешитьРедактированиеРеквизитовОбъекта(ЭтотОбъект,
																							  ОбработчикОповещения);
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ОткрытьКонструкторПравилаИменования()
	
	ОбработчикОповещения = Новый ОписаниеОповещения("ЗаполнениеПравилаИменованияЗавершение", ЭтотОбъект);
	
	ПараметрПравило  = Объект.Правило;
	ПараметрПравило  = РаботаСПравиламиИменованияКлиентСервер.ПреобразоватьСтрокуПоПравилу(ПараметрПравило,Объект.ПараметрыПравила,"ИмяПараметра","ПутьКДанным",Ложь);
			
	ПараметрыОткрытия = Новый Структура;
	ПараметрыОткрытия.Вставить("Правило"		,ПараметрПравило);	
	ПараметрыОткрытия.Вставить("НаборыСвойств"	,НаборыСвойств());
	ПараметрыОткрытия.Вставить("Номенклатура"	,Объект.Номенклатура);
	Если РежимВыбораВВидНоменклатуры Тогда
		ПараметрыОткрытия.Вставить("ВидНоменклатуры",	ВидНоменклатуры);
	КонецЕсли;
	
	ОткрытьФорму("Справочник.ПравилаИменованияНоменклатуры.Форма.КонструкторПравилаИменования",ПараметрыОткрытия,ЭтаФорма,,,,ОбработчикОповещения);

КонецПроцедуры

&НаКлиенте
Процедура ЗаполнениеПравилаИменованияЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат <> Неопределено Тогда
				
		Объект.ПараметрыПравила.Очистить();
		
		Для Каждого СтрокаПараметр Из Результат.ПараметрыПравила Цикл
			ЗаполнитьЗначенияСвойств(Объект.ПараметрыПравила.Добавить(),СтрокаПараметр);
		КонецЦикла;
		
		Объект.Правило = РаботаСПравиламиИменованияКлиентСервер.ПреобразоватьСтрокуПоПравилу(Результат.Правило,Объект.ПараметрыПравила,"ПутьКДанным","ИмяПараметра",Ложь);
		
		Объект.НаборыСвойств.Очистить();
		Для Каждого Свойство Из Результат.НаборыСвойств Цикл
			СтрокаНаборСвойств = Объект.НаборыСвойств.Добавить();
			СтрокаНаборСвойств.Набор = Свойство.Значение;
		КонецЦикла;
		
		Объект.Номенклатура = Результат.Номенклатура;
		
		УстановитьОтображениеНабораСвойств();
		
		СтруктураПроверкиДублей = НайтиРанееСозданныеПравилаИменования();
		Если СтруктураПроверкиДублей.ПравилоРанееСоздано Тогда			
			Если РежимВыбораВВидНоменклатуры Тогда
				ТекстВопроса = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Правило именования создано ранее - %1. Выбрать в вид номенклатуры существующее правило?'"),СтруктураПроверкиДублей.ПравилоИменования);
				Оповещение = Новый ОписаниеОповещения("ПослеОтветаНаВопросВыборПравилаИменования", ЭтаФорма,СтруктураПроверкиДублей.ПравилоИменования);
				ПоказатьВопрос(Оповещение, ТекстВопроса, РежимДиалогаВопрос.ДаНет, , КодВозвратаДиалога.Да);
			Иначе
				ОчиститьСообщения();
				ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Правило именования создано ранее - %1.'"),СтруктураПроверкиДублей.ПравилоИменования);
				ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения);
			КонецЕсли;
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Функция НаборыСвойств()
	
	СписокЗначений = Новый СписокЗначений;
	
	Для Каждого Строка Из Объект.НаборыСвойств Цикл
		СписокЗначений.Добавить(Строка.Набор);
	КонецЦикла;

	Возврат СписокЗначений;
	
КонецФункции

&НаКлиенте
Процедура ОбработкаРазблокированияРеквизитовЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = Истина Тогда
	
		РазблокироватьЭлементыФормы();
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗаблокироватьЭлементыФормы()
	
	ЭтоНовыйОбъект = Объект.Ссылка.Пустая();
	Если НЕ ЭтоНовыйОбъект Тогда
		Элементы.КонструкторПравилаИменования.Доступность = Ложь;
		Элементы.ПараметрыПравила.ТолькоПросмотр = Истина;
	КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура РазблокироватьЭлементыФормы()
	
	Элементы.КонструкторПравилаИменования.Доступность = Истина;
	Элементы.ПараметрыПравила.ТолькоПросмотр = Ложь;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьОтображениеНабораСвойств()
	
	КоличествоНаборовСвойств = Объект.НаборыСвойств.Количество();
	ЗаголовокНабораСвойств = Нстр("ru='Наборы свойств (%1)'");
	Элементы.НадписьНаборыСвойств.Заголовок = СтрШаблон(ЗаголовокНабораСвойств, КоличествоНаборовСвойств);
	Элементы.НадписьНаборыСвойств.Видимость = ПолучитьФункциональнуюОпцию("ИспользоватьДополнительныеРеквизитыИСведения") И КоличествоНаборовСвойств > 0;
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеОтветаНаВопросВыборПравилаИменования(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = КодВозвратаДиалога.Да Тогда
		Закрыть(ДополнительныеПараметры);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция НайтиРанееСозданныеПравилаИменования()
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ТекущаяСсылка",Объект.Ссылка);	
	Запрос.УстановитьПараметр("Правило",Объект.Правило);
	Запрос.Текст = "ВЫБРАТЬ ПЕРВЫЕ 1
	               |	ПравилаИменованияНоменклатуры.Ссылка КАК ПравилоИменования
	               |ИЗ
	               |	Справочник.ПравилаИменованияНоменклатуры КАК ПравилаИменованияНоменклатуры
	               |ГДЕ
	               |	ПравилаИменованияНоменклатуры.Ссылка <> &ТекущаяСсылка
	               |	И (ВЫРАЗИТЬ(ПравилаИменованияНоменклатуры.Правило КАК СТРОКА(1000))) = (ВЫРАЗИТЬ(&Правило КАК СТРОКА(1000)))";
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	СтруктураРезультат = Новый Структура;
	Если Выборка.Следующий() Тогда
		СтруктураРезультат.Вставить("ПравилоРанееСоздано",Истина);
		СтруктураРезультат.Вставить("ПравилоИменования",Выборка.ПравилоИменования);
	Иначе
		СтруктураРезультат.Вставить("ПравилоРанееСоздано",Ложь);
	КонецЕсли;
	
	Возврат СтруктураРезультат;
	
КонецФункции

#КонецОбласти