
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ТекущийВладелец = Неопределено;
	Если Параметры.Отбор.Свойство("Владелец", ТекущийВладелец) Тогда
		Если ЗначениеЗаполнено(ТекущийВладелец) Тогда
			Элементы.КонтрагентОтбор.Видимость = Ложь;
			Элементы.Владелец.Видимость = Ложь;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
    
    // &ЗамерПроизводительности
	ОценкаПроизводительностиРТКлиент.НачатьЗамер(
		     Истина, "Справочник.ЛицензииПоставщиковАлкогольнойПродукции.Форма.ФормаЭлемента.Открытие");

КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
    
    // &ЗамерПроизводительности
    ОценкаПроизводительностиРТКлиент.НачатьЗамер(
		     Истина, "Справочник.ЛицензииПоставщиковАлкогольнойПродукции.Форма.ФормаСписка.Открытие");

КонецПроцедуры

&НаКлиенте
Процедура СписокПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
    
    // &ЗамерПроизводительности
	ОценкаПроизводительностиРТКлиент.НачатьЗамер(
		     Истина, "Справочник.ЛицензииПоставщиковАлкогольнойПродукции.Форма.ФормаЭлемента.СозданиеНового");

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура КонтрагентОтборПриИзменении(Элемент)
	
	ОтборыСписковКлиентСервер.ИзменитьЭлементОтбораСписка(
		Список,
		"Владелец",
		Контрагент,
		ЗначениеЗаполнено(Контрагент));
	
КонецПроцедуры

#КонецОбласти