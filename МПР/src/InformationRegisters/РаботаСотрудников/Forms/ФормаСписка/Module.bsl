
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Если Параметры.Свойство("Отбор") И Параметры.Отбор.Свойство("Сотрудник") Тогда
		
		Сотрудник = Параметры.Отбор.Сотрудник;
		Если Сотрудник = Неопределено
			ИЛИ НЕ Сотрудник.Сотрудник Тогда
			
			ТекстЗаголовка = НСтр("ru = 'Элемент: ""%Сотрудник%"" не является сотрудником'");
			ТекстЗаголовка = СтрЗаменить(ТекстЗаголовка, "%Сотрудник%", Строка(Сотрудник));
			АвтоЗаголовок  = Ложь;
			Заголовок      = ТекстЗаголовка;
			Элементы.Список.ТолькоПросмотр = Истина;
			
		Иначе
			
			ТекстЗаголовка = НСтр("ru = 'Работы выполняемые сотрудником (%Сотрудник%)'");
			ТекстЗаголовка = СтрЗаменить(ТекстЗаголовка, "%Сотрудник%", Строка(Сотрудник));
			АвтоЗаголовок  = Ложь;
			Заголовок      = ТекстЗаголовка;
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
    
    // &ЗамерПроизводительности
    ОценкаПроизводительностиРТКлиент.НачатьЗамер(
             Истина, "РегистрСведений.РаботаСотрудников.Форма.ФормаСписка.Открытие");

КонецПроцедуры

&НаКлиенте
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
    
    // &ЗамерПроизводительности
    ОценкаПроизводительностиРТКлиент.НачатьЗамер(
             Истина, "РегистрСведений.РаботаСотрудников.Форма.ФормаЗаписи.Открытие");

КонецПроцедуры

#КонецОбласти