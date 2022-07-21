
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	РабочееМесто = МенеджерОборудованияВызовСервера.РабочееМестоКлиента();
	Весы.Параметры.УстановитьЗначениеПараметра("ТекущееРабочееМесто", РабочееМесто);
	КассыККМ.Параметры.УстановитьЗначениеПараметра("ТекущееРабочееМесто", РабочееМесто);
	
КонецПроцедуры

&НаСервере
Процедура ПриЗагрузкеДанныхИзНастроекНаСервере(Настройки)
	
	СкладККМOffline = Настройки.Получить("СкладККМOffline");
	СкладВесы = Настройки.Получить("СкладВесы");
	
	ПравилоОбменаВесы = Настройки.Получить("ПравилоОбменаВесы");
	ПравилоОбменаККМOffline = Настройки.Получить("ПравилоОбменаККМOffline");
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(КассыККМ.Отбор, "Склад", СкладККМOffline, ВидСравненияКомпоновкиДанных.Равно,, ЗначениеЗаполнено(СкладККМOffline));
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(КассыККМ.Отбор, "ПравилоОбмена", ПравилоОбменаККМOffline, ВидСравненияКомпоновкиДанных.Равно,, ЗначениеЗаполнено(ПравилоОбменаККМOffline));
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(Весы.Отбор, "Склад", СкладВесы, ВидСравненияКомпоновкиДанных.Равно,, ЗначениеЗаполнено(СкладВесы));
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(Весы.Отбор, "ПравилоОбмена", ПравилоОбменаВесы, ВидСравненияКомпоновкиДанных.Равно,, ЗначениеЗаполнено(ПравилоОбменаВесы));
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(Весы.Отбор, "ПодключеноКТекущемуРабочемуМесту", Истина, ВидСравненияКомпоновкиДанных.Равно,, ВсеОборудованиеВесы = Истина);
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(КассыККМ.Отбор, "ПодключеноКТекущемуРабочемуМесту", Истина, ВидСравненияКомпоновкиДанных.Равно,, ВсеОборудованиеККМOffline = Истина);
	
КонецПроцедуры // ПриЗагрузкеДанныхИзНастроекНаСервере()

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ИзмененоРабочееМестоТекущегоСеанса" Тогда
		
		РабочееМесто = МенеджерОборудованияВызовСервера.РабочееМестоКлиента();
		
		Весы.Параметры.УстановитьЗначениеПараметра("ТекущееРабочееМесто", РабочееМесто);
		КассыККМ.Параметры.УстановитьЗначениеПараметра("ТекущееРабочееМесто", РабочееМесто);
		
	ИначеЕсли ИмяСобытия = "Запись_ПравилаОбменаСПодключаемымОборудованием"
		ИЛИ ИмяСобытия = "Запись_КодыТоваровПодключаемогоОборудования" Тогда
		
		Элементы.Весы.Обновить();
		Элементы.КассыККМ.Обновить();
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти


#Область ОбработчикиКомандФормыККМ

&НаКлиенте
Процедура ВыгрузитьДанные(Команда)
	
	ТекущиеДанные = Элементы.КассыККМ.ТекущиеДанные;
	
	Если НЕ ТекущиеДанные = Неопределено Тогда
		ОписаниеОповещения = Новый ОписаниеОповещения("ПослеВыполненияОбмена", ЭтотОбъект);
		МенеджерОфлайнОборудованияКлиент.НачатьВыгрузкуДанныхНаККМ(ТекущиеДанные.ПодключаемоеОборудование, УникальныйИдентификатор, ОписаниеОповещения);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыгрузитьНастройки(Команда)
	
	ТекущиеДанные = Элементы.КассыККМ.ТекущиеДанные;
	
	Если НЕ ТекущиеДанные = Неопределено Тогда
		ОписаниеОповещения = Новый ОписаниеОповещения("ПослеВыполненияОбмена", ЭтотОбъект);
		МенеджерОфлайнОборудованияКлиент.НачатьВыгрузкуНастроекНаККМ(ТекущиеДанные.ПодключаемоеОборудование, УникальныйИдентификатор, ОписаниеОповещения);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыгрузитьПолныйПрайсЛист(Команда)
	
	ТекущиеДанные = Элементы.КассыККМ.ТекущиеДанные;
	
	Если НЕ ТекущиеДанные = Неопределено Тогда
		ОписаниеОповещения = Новый ОписаниеОповещения("ПослеВыполненияОбмена", ЭтотОбъект);
		МенеджерОфлайнОборудованияКлиент.НачатьПолнуюВыгрузкуПрайсЛистаНаККМ(ТекущиеДанные.ПодключаемоеОборудование, УникальныйИдентификатор, ОписаниеОповещения);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОчиститьПрайсЛист(Команда)
	
	ТекущиеДанные = Элементы.КассыККМ.ТекущиеДанные;
	
	Если НЕ ТекущиеДанные = Неопределено Тогда
		ОписаниеОповещения = Новый ОписаниеОповещения("ПослеВыполненияОбмена", ЭтотОбъект);
		МенеджерОфлайнОборудованияКлиент.НачатьОчисткуПрайсЛистаНаККМ(ТекущиеДанные.ПодключаемоеОборудование, УникальныйИдентификатор, ОписаниеОповещения);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьДанные(Команда)
	
	ТекущиеДанные = Элементы.КассыККМ.ТекущиеДанные;
	
	Если НЕ ТекущиеДанные = Неопределено Тогда
		

		Если ЗначениеЗаполнено(ТекущиеДанные.КассаККМ) Тогда
			
			ДополнительныеПараметры = Новый Структура;
			ДополнительныеПараметры.Вставить("ЭтоЗагрузка");
			
			ОписаниеОповещения = Новый ОписаниеОповещения("ПослеВыполненияОбмена", ЭтотОбъект, ДополнительныеПараметры);
			МенеджерОфлайнОборудованияКлиент.НачатьЗагрузкуДанныхИзККМ(ТекущиеДанные.ПодключаемоеОборудование, УникальныйИдентификатор, ОписаниеОповещения);
		Иначе
			ПоказатьПредупреждение(, НСтр("ru = 'Для данного объекта касса ККМ не привязана. Команда не может быть выполнена.'"));
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьДанныеЗаПериод(Команда)
	
	ТекущиеДанные = Элементы.КассыККМ.ТекущиеДанные;
	
	Если НЕ ТекущиеДанные = Неопределено Тогда
		
		Если ЗначениеЗаполнено(ТекущиеДанные.КассаККМ) Тогда
			
			ДополнительныеПараметры = Новый Структура;
			ДополнительныеПараметры.Вставить("ЭтоЗагрузка");
			
			ПараметрыФормы = Новый Структура;
			ПараметрыФормы.Вставить("ИдентификаторУстройства", ТекущиеДанные.ПодключаемоеОборудование);
			
			ЭтоКассаЭвотор = МенеджерОфлайнОборудованияВызовСервера.ПодключаемоеОборудованиеЭвотор(ТекущиеДанные.ПодключаемоеОборудование);
			Если ЭтоКассаЭвотор Тогда
				
				ОписаниеОповещения = Новый ОписаниеОповещения("ПослеВыполненияОбмена", ЭтотОбъект, ДополнительныеПараметры);
				ОткрытьФорму("Справочник.ОфлайнОборудование.Форма.ФормаНастройки1СЭвоторККМОфлайнПроизвольногоПериодаЗагрузки", ПараметрыФормы, ЭтотОбъект,,,, ОписаниеОповещения, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
				
			Иначе
				
				ПоказатьПредупреждение(, НСтр("ru = 'Для данного типа устройства данная команда недоступна.'"));
				
			КонецЕсли;
			
		Иначе
			ПоказатьПредупреждение(, НСтр("ru = 'Для данного объекта касса ККМ не привязана. Команда не может быть выполнена.'"));
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ВесыПосмотретьСписокТоваров(Команда)
		
	ТекущиеДанные = Элементы.Весы.ТекущиеДанные; 
	Если ТекущиеДанные <> Неопределено И ЗначениеЗаполнено(ТекущиеДанные.ПравилоОбмена) Тогда
		
		МассивОбъектов = Новый Массив;
		МассивОбъектов.Добавить(ТекущиеДанные.ПравилоОбмена);
		
		УправлениеПечатьюКлиент.ВыполнитьКомандуПечати(
			"Справочник.ПравилаОбменаСПодключаемымОборудованием", // Для вызова метода менеджера обработки "Печать".
			 "КодыТоваров",
			МассивОбъектов,    
			ЭтаФорма);
		
	Иначе
		ПоказатьПредупреждение(,НСтр("ru = 'Команда не может быть выполнена для указанного объекта'"));
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВесыНазначитьПравилоДляВыделенныхЗавершение(Результат, Параметры) Экспорт
	
	Если ЗначениеЗаполнено(Результат) Тогда
		НазначитьПравилоДляВыделенныхУстройствНаСервере(Параметры, Результат);
		Элементы.Весы.Обновить();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВесыНазначитьПравилоДляВыделенных(Команда)
	
	Устройства = Новый Массив;
	Для Каждого ВыделеннаяСтрока Из Элементы.Весы.ВыделенныеСтроки Цикл
		Устройства.Добавить(ВыделеннаяСтрока);
	КонецЦикла;
	
	Если Устройства.Количество() > 0 Тогда
        
        // &ЗамерПроизводительности
        ОценкаПроизводительностиРТКлиент.НачатьЗамер(
                 Истина, "Справочник.ПравилаОбменаСПодключаемымОборудованием.Форма.ФормаВыбора.Открытие");
                 
		ПараметрыОткрытия = Новый Структура;
		ПараметрыОткрытия.Вставить("ТипПодключаемогоОборудования", ПредопределенноеЗначение("Перечисление.ТипыПодключаемогоОборудования.ВесыСПечатьюЭтикеток"));
		
		Обработчик = Новый ОписаниеОповещения("ВесыНазначитьПравилоДляВыделенныхЗавершение", ЭтотОбъект, Устройства);
		ОткрытьФорму("Справочник.ПравилаОбменаСПодключаемымОборудованием.ФормаВыбора", ПараметрыОткрытия, УникальныйИдентификатор,,  ,, Обработчик, РежимОткрытияОкнаФормы.БлокироватьВесьИнтерфейс);
		
	Иначе
		ПоказатьПредупреждение(, НСтр("ru = 'Команда не может быть выполнена для указанного объекта'"));
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВесыТоварыОперацияЗавершение(РезультатВыполнения, Параметры) Экспорт
	
	Элементы.Весы.Обновить();
	
КонецПроцедуры

&НаКлиенте
Процедура ВесыТоварыОчистить(Команда)
	
	ОчиститьСообщения();
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ВесыТоварыОперацияЗавершение", ЭтотОбъект);
	ПодключаемоеОборудованиеOfflineКлиент.НачатьОчисткуТоваровВВесах(ОписаниеОповещения, Элементы.Весы.ВыделенныеСтроки);
	
КонецПроцедуры

&НаКлиенте
Процедура ВесыТоварыВыгрузить(Команда)
	
	ОчиститьСообщения();
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ВесыТоварыОперацияЗавершение", ЭтотОбъект);
	ПодключаемоеОборудованиеOfflineКлиент.НачатьВыгрузкуТоваровВВесы(ОписаниеОповещения, Элементы.Весы.ВыделенныеСтроки, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ВесыТоварыПерезагрузить(Команда)
	
	ОчиститьСообщения();
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ВесыТоварыОперацияЗавершение", ЭтотОбъект);
	ПодключаемоеОборудованиеOfflineКлиент.НачатьВыгрузкуТоваровВВесы(ОписаниеОповещения, Элементы.Весы.ВыделенныеСтроки, Ложь);
	
КонецПроцедуры

&НаКлиенте
Процедура КассыПосмотретьСписокТоваров(Команда)
	
	ТекущиеДанные = Элементы.КассыККМ.ТекущиеДанные; 
	Если ТекущиеДанные <> Неопределено И ЗначениеЗаполнено(ТекущиеДанные.ПравилоОбмена) Тогда
		
		МассивОбъектов = Новый Массив;
		МассивОбъектов.Добавить(ТекущиеДанные.ПравилоОбмена);
		
		УправлениеПечатьюКлиент.ВыполнитьКомандуПечати(
			"Справочник.ПравилаОбменаСПодключаемымОборудованием", // Для вызова метода менеджера обработки "Печать".
			 "КодыТоваров",
			МассивОбъектов,    
			ЭтаФорма);
	Иначе
		ПоказатьПредупреждение(, НСтр("ru = 'Команда не может быть выполнена для указанного объекта'"));
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура КассыНазначитьПравилоДляВыделенныхЗавершение(Результат, Параметры) Экспорт
	
	Если ЗначениеЗаполнено(Результат) Тогда
		НазначитьПравилоДляВыделенныхУстройствНаСервере(Параметры, Результат);
		Элементы.КассыККМ.Обновить();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура КассыНазначитьПравилоДляВыделенных(Команда)
	
	Устройства = Новый Массив;
	Для Каждого ВыделеннаяСтрока Из Элементы.КассыККМ.ВыделенныеСтроки Цикл
		Устройства.Добавить(ВыделеннаяСтрока);
	КонецЦикла;
	
	Если Устройства.Количество() > 0 Тогда
        // &ЗамерПроизводительности
        ОценкаПроизводительностиРТКлиент.НачатьЗамер(
                 Истина, "Справочник.ПравилаОбменаСПодключаемымОборудованием.Форма.ФормаВыбора.Открытие");

		ПараметрыОткрытия = Новый Структура;
		ПараметрыОткрытия.Вставить("ТипПодключаемогоОборудования", ПредопределенноеЗначение("Перечисление.ТипыОфлайнОборудования.ККМ"));
		
		Обработчик = Новый ОписаниеОповещения("КассыНазначитьПравилоДляВыделенныхЗавершение", ЭтотОбъект, Устройства);
		ОткрытьФорму("Справочник.ПравилаОбменаСПодключаемымОборудованием.ФормаВыбора", ПараметрыОткрытия, УникальныйИдентификатор,,  ,, Обработчик, РежимОткрытияОкнаФормы.БлокироватьВесьИнтерфейс);
		
	Иначе
		ПоказатьПредупреждение(, НСтр("ru = 'Команда не может быть выполнена для указанного объекта'"));
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВесыОткрытьПравилоОбмена(Команда)
	
	ТекущиеДанные = Элементы.Весы.ТекущиеДанные;
	
	Если ТекущиеДанные <> Неопределено И ЗначениеЗаполнено(ТекущиеДанные.ПравилоОбмена) Тогда
		ПоказатьЗначение(, ТекущиеДанные.ПравилоОбмена);
	Иначе
		ПоказатьПредупреждение(, НСтр("ru = 'Команда не может быть выполнена для указанного объекта'"));
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура КассыОткрытьПравилоОбмена(Команда)
	
	ТекущиеДанные = Элементы.КассыККМ.ТекущиеДанные;
	
	Если ТекущиеДанные <> Неопределено И ЗначениеЗаполнено(ТекущиеДанные.ПравилоОбмена) Тогда
		ПоказатьЗначение(, ТекущиеДанные.ПравилоОбмена);
	Иначе
		ПоказатьПредупреждение(,НСтр("ru = 'Команда не может быть выполнена для указанного объекта'"));
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура СкладВесыПриИзменении(Элемент)
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(Весы.Отбор, "Склад", СкладВесы, ВидСравненияКомпоновкиДанных.Равно,, ЗначениеЗаполнено(СкладВесы));
	
КонецПроцедуры

&НаКлиенте
Процедура ПравилоОбменаВесыПриИзменении(Элемент)
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(Весы.Отбор, "ПравилоОбмена", ПравилоОбменаВесы, ВидСравненияКомпоновкиДанных.Равно,, ЗначениеЗаполнено(ПравилоОбменаВесы));
	
КонецПроцедуры

&НаКлиенте
Процедура СкладККМOfflineПриИзменении(Элемент)
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(КассыККМ.Отбор, "Склад", СкладККМOffline, ВидСравненияКомпоновкиДанных.Равно,, ЗначениеЗаполнено(СкладККМOffline));
	
КонецПроцедуры

&НаКлиенте
Процедура ПравилоОбменаККМOfflineПриИзменении(Элемент)
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(КассыККМ.Отбор, "ПравилоОбмена", ПравилоОбменаККМOffline, ВидСравненияКомпоновкиДанных.Равно,, ЗначениеЗаполнено(ПравилоОбменаККМOffline));
	
КонецПроцедуры

&НаКлиенте
Процедура ОборудованиеККМOfflineПриИзменении(Элемент)
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(КассыККМ.Отбор, "ПодключеноКТекущемуРабочемуМесту", Истина, ВидСравненияКомпоновкиДанных.Равно,, ВсеОборудованиеККМOffline = Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ОборудованиеВесыПриИзменении(Элемент)
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(Весы.Отбор, "ПодключеноКТекущемуРабочемуМесту", Истина, ВидСравненияКомпоновкиДанных.Равно,, ВсеОборудованиеВесы = Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура КассыККМВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ТекущиеДанные = Элемент.ТекущиеДанные;
	
	Если НЕ ТекущиеДанные = Неопределено Тогда
		
		ИмяЭлемента = Элемент.ТекущийЭлемент.Имя;
		
		Если ИмяЭлемента = "КассыККМКассаККМ" И ЗначениеЗаполнено(ТекущиеДанные.КассаККМ) Тогда
			
			ПоказатьЗначение(, ТекущиеДанные.КассаККМ);
			
		ИначеЕсли (ИмяЭлемента = "КассыККМПравилоОбмена" ИЛИ ИмяЭлемента = "КассыККМСклад") И ЗначениеЗаполнено(ТекущиеДанные.ПравилоОбмена) Тогда
			
			ПоказатьЗначение(, ТекущиеДанные.ПравилоОбмена);
			
		Иначе
			
			ПоказатьЗначение(, ТекущиеДанные.ПодключаемоеОборудование);
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВесыВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ТекущиеДанные = Элемент.ТекущиеДанные;
	
	Если НЕ ТекущиеДанные = Неопределено Тогда
		
		ИмяЭлемента = Элемент.ТекущийЭлемент.Имя;
		
		Если (ИмяЭлемента = "ВесыПравилоОбмена" ИЛИ ИмяЭлемента = "ВесыСклад") И ЗначениеЗаполнено(ТекущиеДанные.ПравилоОбмена) Тогда
			
			ПоказатьЗначение(, ТекущиеДанные.ПравилоОбмена);
			
		Иначе
			
			ПоказатьЗначение(, ТекущиеДанные.ПодключаемоеОборудование);
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ПослеВыполненияОбмена(Результат, ДополнительныеПараметры) Экспорт
	
	Если ЗначениеЗаполнено(Результат) Тогда
		Если НЕ Результат.Результат Тогда
			ОбщегоНазначенияКлиент.СообщитьПользователю(Результат.ОписаниеОшибки);
		Иначе
			Если ТипЗнч(ДополнительныеПараметры) = Тип("Структура") И ДополнительныеПараметры.Свойство("ЭтоЗагрузка") Тогда
				ТекстСообщения = НСтр("ru='Данные успешно загружены'");
			Иначе
				ТекстСообщения = НСтр("ru='Данные успешно выгружены'");
			КонецЕсли;
						
			ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения);
			
		КонецЕсли;
	КонецЕсли;
	Элементы.КассыККМ.Обновить();
	
КонецПроцедуры

&НаСервере
Процедура НазначитьПравилоДляВыделенныхУстройствНаСервере(Устройства, ПравилоОбмена)
	
	УстановитьПривилегированныйРежим(Истина);
	
	НачатьТранзакцию();
	
	Попытка
		
		БлокировкаДанных = Новый БлокировкаДанных;
		ЭлементБлокировкиДанных = БлокировкаДанных.Добавить("Справочник.ПодключаемоеОборудование");
		ЭлементБлокировкиДанных.Режим = РежимБлокировкиДанных.Исключительный;
		БлокировкаДанных.Заблокировать();
		
		Для Каждого Устройство Из Устройства Цикл
			
			УстройствоОбъект = Устройство.ПолучитьОбъект();
			УстройствоОбъект.ПравилоОбмена = ПравилоОбмена;
			УстройствоОбъект.Записать();
			
		КонецЦикла;
		
		ЗафиксироватьТранзакцию();
	Исключение
		
		ОтменитьТранзакцию();
		ЗаписьЖурналаРегистрации(НСтр("ru = 'Заметки'", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()), УровеньЖурналаРегистрации.Ошибка,,, ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
		ВызватьИсключение;
		
	КонецПопытки
	
КонецПроцедуры

#КонецОбласти