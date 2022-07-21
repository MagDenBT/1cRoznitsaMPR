
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
	
	Если Элементы.Найти("ФормаДокументУстановкаЦенНоменклатурыСоздатьНаОсновании") <> Неопределено Тогда 
		Элементы.ФормаДокументУстановкаЦенНоменклатурыСоздатьНаОсновании.Видимость = ПолучитьФункциональнуюОпцию("УстанавливатьВидыЦенВАссортименте");
	КонецЕсли;
	
	ОбщегоНазначенияРТ.УстановитьУсловноеОформлениеПоляДата(ЭтотОбъект, "Список", "Дата");
	
#Область Новости
	// ИнтернетПоддержкаПользователей.Новости, код для ПриСозданииНаСервере, можно размещать в конце процедуры
	НастройкиОтображенияНовостей = Новый Структура();
	НастройкиОтображенияНовостей.Вставить("ЭлементФормыДляРазмещенияКомандыНовостей", Элементы.ПанельКонтекстныхНовостей);
	НастройкиОтображенияНовостей.Вставить("ТипЗначенияКомандыНовостей", Тип("ГруппаФормы"));
	
	ОбработкаНовостей.КонтекстныеНовости_ПриСозданииНаСервере(
		ЭтаФорма,
		"Документ.ИзменениеАссортимента",
		"ФормаСписка",
		НастройкиОтображенияНовостей,
		,
		Ложь,
		Новый Структура("ПолучатьНовостиНаСервере, ХранитьМассивНовостейТолькоНаСервере",
			Истина,
			Ложь),
		"ПриОткрытии");
	// Конец ИнтернетПоддержкаПользователей.Новости
#КонецОбласти
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
#Область Новости
	// ИнтернетПоддержкаПользователей.Новости, код для ПриОткрытии, можно размещать в конце процедуры
	ОбработкаНовостейКлиент.КонтекстныеНовости_ПриОткрытии(ЭтаФорма);
	// Конец ИнтернетПоддержкаПользователей.Новости
#КонецОбласти
	
КонецПроцедуры

&НаКлиенте
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
    
    // &ЗамерПроизводительности
	ОценкаПроизводительностиРТКлиент.НачатьЗамер(
		     Истина, "Документ.ИзменениеАссортимента.Форма.ФормаДокумента.Открытие");

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ОтборОбъектПланированияПриИзменении(Элемент)
	УстановитьОтборДинамическогоСписка("ОбъектПланирования");
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
             Истина, "Документ.ИзменениеАссортимента.Форма.ФормаДокумента.СозданиеНового");
             
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

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

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьОтборДинамическогоСписка(ИмяРеквизита)
	
	ОтборыСписковКлиентСервер.ИзменитьЭлементОтбораСписка(
		Список,
		ИмяРеквизита,
		ЭтаФорма[ИмяРеквизита],
		ЗначениеЗаполнено(ЭтаФорма[ИмяРеквизита]));
		
КонецПроцедуры

&НаКлиенте
Процедура ИзменитьВыделенные(Команда)
	
	ГрупповоеИзменениеОбъектовКлиент.ИзменитьВыделенные(Элементы.Список);
	
КонецПроцедуры

#КонецОбласти


#Область Новости

// ИнтернетПоддержкаПользователей.Новости, Процедуры и функции для работы с подсистемой новостей
////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ДЛЯ РАБОТЫ С ПОДСИСТЕМОЙ КОНТЕКСТНЫХ НОВОСТЕЙ
//

&НаКлиенте
// Процедура показывает новости, требующие прочтения (важные и очень важные)
//
// Параметры:
//  Нет
//
Процедура Подключаемый_ПоказатьНовостиТребующиеПрочтенияПриОткрытии()
	ИдентификаторыСобытийПриОткрытии = "ПриОткрытии";
	ОбработкаНовостейКлиент.КонтекстныеНовости_ПоказатьНовостиТребующиеПрочтенияПриОткрытии(ЭтаФорма, ИдентификаторыСобытийПриОткрытии);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбработкаНовости(Команда)
	ОбработкаНовостейКлиент.КонтекстныеНовости_ОбработкаКомандыНовости(
	ЭтаФорма,
	Команда
	);
КонецПроцедуры

&НаКлиенте
Процедура КомандаСкрытьТекстНовости(Команда)
	Если Элементы.Найти("ГруппаТекстНовости") <> Неопределено Тогда
		Элементы.ГруппаТекстНовости.Видимость = Ложь;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ТекстНовостиХТМЛПриНажатии(Элемент, ДанныеСобытия, СтандартнаяОбработка)
	
	Если ДанныеСобытия.Свойство("Href") Тогда
		СтандартнаяОбработка = Ложь;
		Если ЗначениеЗаполнено(ДанныеСобытия.Href) Тогда
			ФайловаяСистемаКлиент.ОткрытьНавигационнуюСсылку(ДанныеСобытия.Href);
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры
// Конец ИнтернетПоддержкаПользователей.Новости

#КонецОбласти

