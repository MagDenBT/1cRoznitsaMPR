
#Область ПрограммныйИнтерфейс

#Область ОбработчикиСобытийПодключаемогоОборудования

&НаКлиенте
Процедура ОповещениеПоискаПоШтрихкоду(Штрихкод, ДополнительныеПараметры) Экспорт
	
	Если НЕ ПустаяСтрока(Штрихкод) Тогда
		СтруктураПараметровКлиента = ПолученШтрихкодИзСШК(Штрихкод);
		ОбработатьДанныеПоКодуКлиент(СтруктураПараметровКлиента);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОповещениеПоискаПоМагнитномуКоду(ТекКод, ДополнительныеПараметры) Экспорт
	
	Если Не ПустаяСтрока(ТекКод) Тогда
		СтруктураПараметровКлиента = ПолученМагнитныйКод(ТекКод);
		ОбработатьДанныеПоКодуКлиент(СтруктураПараметровКлиента);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОповещениеОткрытьФормуВыбораДанныхПоиска(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат <> Неопределено Тогда
		ПродолжитьОбработатьДанныеПоКодуКлиент(Результат);
		ОбработатьДанныеПоКодуКлиент(Результат)
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Функция ПолученМагнитныйКод(МагнитныйКод) Экспорт 
	
	СтруктураРезультат = ДанныеПоискаПоМагнитномуКодуСервер(МагнитныйКод);
	Возврат ПодключаемоеОборудованиеРТКлиент.ПолученМагнитныйКод(ЭтотОбъект, СтруктураРезультат);
	
КонецФункции

&НаСервере
Функция ДанныеПоискаПоМагнитномуКодуСервер(МагнитныйКод)
	
	Возврат ПодключаемоеОборудованиеРТ.ДанныеПоискаПоМагнитномуКоду(МагнитныйКод, ЭтотОбъект);
	
КонецФункции

&НаКлиенте
Функция ПолученШтрихкодИзСШК(Штрихкод) Экспорт
	
	СтруктураРезультат = ДанныеПоискаПоШтрихкодуСервер(Штрихкод);
	Возврат ПодключаемоеОборудованиеРТКлиент.ПолученШтрихкодИзСШК(ЭтотОбъект, СтруктураРезультат);
	
КонецФункции

&НаСервере
Функция ДанныеПоискаПоШтрихкодуСервер(Штрихкод)
	
	Возврат ПодключаемоеОборудованиеРТ.ДанныеПоискаПоШтрихкоду(Штрихкод, ЭтотОбъект);
	
КонецФункции

&НаКлиенте
Процедура ОповещениеОбработатьДанныеПоКоду(СтруктураРезультат, ДополнительныеПараметры) Экспорт
	
	ПродолжитьОбработатьДанныеПоКодуКлиент(СтруктураРезультат);
	
КонецПроцедуры

&НаКлиенте
Процедура ПродолжитьОбработатьДанныеПоКодуКлиент(СтруктураРезультат) Экспорт
	
	ИдентификаторСтроки = Неопределено;
	СтрокаРезультата = СтруктураРезультат.ЗначенияПоиска[0];
	
	Если СтрокаРезультата.Свойство("Карта") Тогда
		
		ПодключаемоеОборудованиеРТКлиент.ВставитьПредупреждениеОНевозможностиОбработкиКарт(СтруктураРезультат, СтрокаРезультата);
		
	ИначеЕсли СтрокаРезультата.Свойство("СерийныйНомер") Тогда
		
		ИдентификаторСтроки = ПодключаемоеОборудованиеРТКлиент.ДобавитьНоменклатуруПоСерийномуНомеру(ЭтотОбъект, СтрокаРезультата);
		
	Иначе // Номенклатура.
		
		ИдентификаторСтроки = ДобавитьНайденныеПозицииТоваровСервер(СтрокаРезультата);
		
	КонецЕсли;

	Если СтрокаРезультата.Свойство("ТекстПредупреждения") Тогда
		СтруктураРезультат.Вставить("ТекстПредупреждения", СтрокаРезультата.ТекстПредупреждения);
	КонецЕсли;
	
	Если ИдентификаторСтроки <> Неопределено Тогда
		СтруктураРезультат.Вставить("СкомпоноватьРезультат", Истина);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработатьДанныеПоКодуКлиент(СтруктураПараметровКлиента) Экспорт
	
	ОткрытаБлокирующаяФорма = Ложь;
	
	Если СтруктураПараметровКлиента.Свойство("СкомпоноватьРезультат") Тогда
		СкомпоноватьРезультат();
	КонецЕсли;
	
	ПодключаемоеОборудованиеРТКлиент.ОбработатьДанныеПоКоду(ЭтотОбъект, СтруктураПараметровКлиента, ОткрытаБлокирующаяФорма);
	
КонецПроцедуры

&НаКлиенте
Функция ОбработатьДанныеИзТСДКлиент(СтруктураПараметров, ДополнительныеПараметры) Экспорт
	
	Результат = ПодключаемоеОборудованиеРТКлиент.ОбработатьДанныеПоНоменклатуреИзТСДКлиент(ЭтотОбъект, СтруктураПараметров);
	СкомпоноватьРезультат();
	ПодключаемоеОборудованиеРТКлиент.СообщитьТекстПредупреждения(СтруктураПараметров);
	
	Возврат Результат;
	
КонецФункции

&НаКлиенте
Функция ДобавитьНайденныеПозицииТоваров(СтруктураПараметров, ДополнительныеПараметры = Неопределено) Экспорт
	
	Возврат ДобавитьНайденныеПозицииТоваровСервер(СтруктураПараметров, ДополнительныеПараметры);
	
КонецФункции

&НаСервере
Функция ДобавитьНайденныеПозицииТоваровСервер(СтруктураПараметров, ДополнительныеПараметры = Неопределено)
	
	Если Не ДополнительныеПараметры = Неопределено Тогда
		СтруктураПараметров = ДополнительныеПараметры;
		ИдентификаторСтроки = СтруктураПараметров;
	Иначе
		ИдентификаторСтроки = Неопределено;
	КонецЕсли;
	
	Запись = РегистрыСведений.НоменклатураСегмента.СоздатьМенеджерЗаписи();
	Запись.Сегмент = Сегмент;
	Запись.Номенклатура = СтруктураПараметров.Номенклатура;
	Если ЗначениеЗаполнено(СтруктураПараметров.Характеристика) Тогда
		Запись.Характеристика = СтруктураПараметров.Характеристика;
	КонецЕсли;
	
	Запись.Прочитать();
	
	Если Запись.Выбран() Тогда
		ТекстПредупреждения = НСтр("ru = 'Номенклатура ""%1%2"" уже включена в сегмент.'");
		ТекстПредупреждения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
								ТекстПредупреждения,
								СтруктураПараметров.Номенклатура,
								?(ЗначениеЗаполнено(СтруктураПараметров.Характеристика), " / " + Строка(СтруктураПараметров.Характеристика), ""));
		СтруктураПараметров.Вставить("ТекстПредупреждения", ТекстПредупреждения);
	Иначе
		Запись.Сегмент = Сегмент;
		Запись.Номенклатура = СтруктураПараметров.Номенклатура;
		Если ЗначениеЗаполнено(СтруктураПараметров.Характеристика) Тогда
			Запись.Характеристика = СтруктураПараметров.Характеристика;
		КонецЕсли;
		Запись.Записать();
		ИдентификаторСтроки = 0;
	КонецЕсли;
	
	Если Не ДополнительныеПараметры = Неопределено Тогда
		СтруктураПараметров = ИдентификаторСтроки;
		Возврат СтруктураПараметров;
	Иначе
		Возврат ИдентификаторСтроки;
	КонецЕсли;
	
КонецФункции

#КонецОбласти

&НаКлиенте
Процедура ДобавитьВСегментЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если ЗначениеЗаполнено(Результат) Тогда
		Если ИспользоватьХарактеристикиНоменклатуры
			И ТипЗнч(Результат) <> Тип("Структура") Тогда
			Возврат;
		КонецЕсли;
		ДобавитьЭлемент(Результат, Истина, Истина);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьВСегментПоОтборуЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если ЗначениеЗаполнено(Результат) Тогда
		ДобавитьНоменклатуруПоОтборуНаСервере(Результат);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Сегмент = Параметры.Сегмент;
	Если НЕ ЗначениеЗаполнено(Сегмент) Тогда
		ВызватьИсключение НСтр("ru = 'Открытие отчета не возможно: не выбран сегмент'");
	КонецЕсли;
	СпособФормирования = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Сегмент, "СпособФормирования");
	ВозможенРучнойВвод = СпособФормирования = Перечисления.СпособыФормированияСегментов.ФормироватьВручную;
		
	ДоступностьИзменений = НЕ (Элементы.Найти("ДобавитьВСегмент") = Неопределено);
	Если ДоступностьИзменений Тогда
		Элементы.ДобавитьВСегмент.Видимость = ВозможенРучнойВвод;
		Элементы.УдалитьИзСегмента.Видимость = ВозможенРучнойВвод;
		Элементы.ДобавитьВСегментПоОтбору.Видимость = ВозможенРучнойВвод;
		Элементы.ФормаВыгрузитьДанныеВТСД.Видимость = ВозможенРучнойВвод;
		Элементы.ФормаЗагрузитьДанныеИзТСД.Видимость = ВозможенРучнойВвод;
		Элементы.ФормаПоискПоМагнитномуКоду.Видимость = ВозможенРучнойВвод;
		Элементы.ФормаПоискПоШтрихкоду.Видимость = ВозможенРучнойВвод;
		Элементы.СформироватьСегмент.Видимость = СпособФормирования <> Перечисления.СпособыФормированияСегментов.ФормироватьДинамически;
	КонецЕсли;
		
	Отчет.КомпоновщикНастроек.ФиксированныеНастройки.ДополнительныеСвойства.Вставить("Сегмент", Сегмент);
	ИспользоватьХарактеристикиНоменклатуры = ПолучитьФункциональнуюОпцию("ИспользоватьХарактеристикиНоменклатуры");
	
	Если ВозможенРучнойВвод Тогда
		// ПодключаемоеОборудование
		МассивКомандПО = Новый Массив;
		МассивКомандПО.Добавить("ФормаВыгрузитьДанныеВТСД");
		МассивКомандПО.Добавить("ФормаЗагрузитьДанныеИзТСД");
		ПодключаемоеОборудованиеРТ.НастроитьПодключаемоеОборудование(ЭтотОбъект, МассивКомандПО);
		ПараметрыСобытийПО = Новый Структура;
		ПараметрыСобытийПО.Вставить("ЕстьКоличество", Ложь);
		// Конец ПодключаемоеОборудование
	КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура ПриСохраненииПользовательскихНастроекНаСервере(Настройки)
	
	ВариантыОтчетов.ПриСохраненииПользовательскихНастроекНаСервере(ЭтотОбъект, Настройки);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если ВозможенРучнойВвод Тогда
		// ПодключаемоеОборудование
		МенеджерОборудованияКлиент.НачатьПодключениеОборудованиеПриОткрытииФормы(Неопределено, ЭтотОбъект, "СканерШтрихкода, СчитывательМагнитныхКарт");
		// Конец ПодключаемоеОборудование
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	
	Если ВозможенРучнойВвод Тогда
		// ПодключаемоеОборудование
		МенеджерОборудованияКлиент.НачатьОтключениеОборудованиеПриЗакрытииФормы(Неопределено, ЭтотОбъект);
		// Конец ПодключаемоеОборудование
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВнешнееСобытие(Источник, Событие, Данные)
	
	Если ВводДоступен() И ВозможенРучнойВвод Тогда
		ПодключаемоеОборудованиеРТКлиент.ВнешнееСобытиеОборудования(ЭтотОбъект, Источник, Событие, Данные);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура РезультатОбработкаРасшифровки(Элемент, Расшифровка, СтандартнаяОбработка)

	Если ТипЗнч(Расшифровка) <> Тип("ИдентификаторРасшифровкиКомпоновкиДанных") Тогда
		Возврат;
	КонецЕсли;

	СтандартнаяОбработка = Ложь;
	Элемент = РасшифроватьЭлемент(Расшифровка);
	Если ЗначениеЗаполнено(Элемент) Тогда
		ПоказатьЗначение(, Элемент);
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

#Область ОбработчикиКомандПодключаемогоОборудования

&НаКлиенте
Процедура ВыгрузитьДанныеВТСД(Команда)
	
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("ВариантЗаполнения", "ПоСегменту");
	ДополнительныеПараметры.Вставить("Сегмент", Сегмент);
	ПодключаемоеОборудованиеРТКлиент.ВыгрузитьОтчетВТСД(ЭтотОбъект, ДополнительныеПараметры);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьДанныеИзТСД(Команда)
	
	ПодключаемоеОборудованиеРТКлиент.ПолучитьДанныеИзТСД(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПоискПоМагнитномуКоду(Команда)
	
	ОбработкаТабличнойЧастиТоварыКлиент.ВвестиМагнитныйКод(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПоискПоШтрихкоду(Команда)
	
	ОбработкаТабличнойЧастиТоварыКлиент.ВвестиШтрихкод(ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти

&НаКлиенте
Процедура ДобавитьВСегмент(Команда)

	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("ИспользоватьХарактеристикиНоменклатуры", ИспользоватьХарактеристикиНоменклатуры);
	ОбработчикОповещения = Новый ОписаниеОповещения("ДобавитьВСегментЗавершение", ЭтотОбъект, ДополнительныеПараметры);
	Если ИспользоватьХарактеристикиНоменклатуры Тогда
		ОткрытьФорму("Отчет.СоставСегмента.Форма.ВыборНоменклатуры", , ЭтаФорма, , , , ОбработчикОповещения, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	Иначе
		ОткрытьФорму("Справочник.Номенклатура.ФормаВыбора", , ЭтаФорма, , , , ОбработчикОповещения, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	КонецЕсли;
	
	
КонецПроцедуры

&НаКлиенте
Процедура УдалитьИзСегмента(Команда)
	
	мРасшифровки = Новый Массив();
	Области = Результат.ВыделенныеОбласти;
	
	Для Каждого Область Из Области Цикл
		Верх = Область.Верх;
		Если Верх = 0 И Область.Низ = 0 Тогда
			ОчиститьСегмент();
			Возврат;
		КонецЕсли;
		Если Верх = 0 Тогда
			Верх = 1;
		КонецЕсли;
		
		Для Строка = Верх По Область.Низ Цикл
			Для Столбец = 1 По 200 Цикл
				Расшифровка = Результат.Область("R" + Формат(Строка, "ЧГ=0") + "C" + Столбец).Расшифровка;
				Если ТипЗнч(Расшифровка) = Тип("ИдентификаторРасшифровкиКомпоновкиДанных") Тогда
					мРасшифровки.Добавить(Расшифровка);
				КонецЕсли;
			КонецЦикла;
		КонецЦикла;
	КонецЦикла;
	
	УдалитьЭлементы(мРасшифровки);
	
КонецПроцедуры

&НаКлиенте
Процедура СформироватьСегмент(Команда)

	СегментыВызовСервера.Сформировать(Сегмент);
	СкомпоноватьРезультат();

КонецПроцедуры

&НаКлиенте
Процедура ДобавитьВСегментПоОтбору(Команда)
	
	ЗаголовокФормыПодбора = НСтр("ru = 'Подбор номенклатуры в сегмент'");
	ЗаголовокКнопкиПеренестиФормыПодбора = НСтр("ru = 'Перенести в сегмент'");
	
	ДополнительныеПараметры = Новый Структура;
	ОбработчикОповещения = Новый ОписаниеОповещения("ДобавитьВСегментПоОтборуЗавершение", ЭтотОбъект, ДополнительныеПараметры);
	
	ПараметрыОткрытия = Новый Структура("Заголовок, ЗаголовокКнопкиПеренести", ЗаголовокФормыПодбора, ЗаголовокКнопкиПеренестиФормыПодбора);
	ОткрытьФорму("Обработка.ПодборТоваровПоОтбору.Форма.Форма", ПараметрыОткрытия, ЭтаФорма, , , , ОбработчикОповещения, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Удаляет выбранные элементы из состава сегмента.
&НаСервере
Процедура УдалитьЭлементы(Расшифровки)

	ДанныеРасшифровкиОтчета = ПолучитьИзВременногоХранилища(ДанныеРасшифровки);
	
	Для Каждого Расшифровка Из Расшифровки Цикл
		ЭлементРасшифровки = ДанныеРасшифровкиОтчета.Элементы[Расшифровка];
		Для Каждого ЗначениеПоляРасшифровки Из ЭлементРасшифровки.ПолучитьПоля() Цикл
			Значение = ЗначениеПоляРасшифровки.Значение;
			Если ТипЗнч(Значение) = Тип("СправочникСсылка.Номенклатура") Тогда
				НаборЗаписей = РегистрыСведений.НоменклатураСегмента.СоздатьНаборЗаписей();
				НаборЗаписей.Отбор.Сегмент.Установить(Сегмент);
				НаборЗаписей.Отбор.Номенклатура.Установить(Значение);
				Попытка
					ЗначениеСледующейРасшифровки = ДанныеРасшифровкиОтчета.Элементы[Расшифровка+1].ПолучитьПоля()[0].Значение;
					Если ТипЗнч(ЗначениеСледующейРасшифровки) = Тип("СправочникСсылка.ХарактеристикиНоменклатуры") Тогда
						НаборЗаписей.Отбор.Характеристика.Установить(ЗначениеСледующейРасшифровки);
					Иначе
						НаборЗаписей.Отбор.Характеристика.Установить(Справочники.ХарактеристикиНоменклатуры.ПустаяСсылка());
					КонецЕсли;
				Исключение
					СтрокаОшибки = ОписаниеОшибки();
				КонецПопытки;
				НаборЗаписей.Записать(); 
			КонецЕсли;
		КонецЦикла;
	КонецЦикла;
	
	СкомпоноватьРезультат();

КонецПроцедуры

&НаСервере
Процедура ОчиститьСегмент()
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	|	НоменклатураСегмента.Номенклатура КАК Номенклатура,
	|	НоменклатураСегмента.Характеристика КАК Характеристика
	|ИЗ
	|	РегистрСведений.НоменклатураСегмента КАК НоменклатураСегмента
	|ГДЕ
	|	НоменклатураСегмента.Сегмент = &Сегмент";

	Запрос.УстановитьПараметр("Сегмент", Сегмент);

	РезультатЗапроса = Запрос.Выполнить();
	Выборка = РезультатЗапроса.Выбрать();

	Пока Выборка.Следующий() Цикл
		
		НаборЗаписей = РегистрыСведений.НоменклатураСегмента.СоздатьНаборЗаписей();
		НаборЗаписей.Отбор.Сегмент.Установить(Сегмент);
		НаборЗаписей.Отбор.Номенклатура.Установить(Выборка.Номенклатура);
		НаборЗаписей.Отбор.Характеристика.Установить(Выборка.Характеристика);
		
		НаборЗаписей.Записать(); 
		
	КонецЦикла;
	
	СкомпоноватьРезультат();
	
КонецПроцедуры


// Добавляет отобранную номенклатуру в сегмент и переформирует отчет.
//
&НаСервере
Процедура ДобавитьНоменклатуруПоОтборуНаСервере(АдресВоВременномХранилище);

	ТаблицаНоменклатура = ПолучитьИзВременногоХранилища(АдресВоВременномХранилище);
	
	Для каждого СтрокаТаблицы Из ТаблицаНоменклатура Цикл
	     ДобавитьЭлемент(СтрокаТаблицы);	
	КонецЦикла;

	СкомпоноватьРезультат();
	
КонецПроцедуры

// Возвращает возможный для просмотра элемент.
&НаСервере
Функция РасшифроватьЭлемент(Расшифровка)

	ДанныеРасшифровкиОтчета = ПолучитьИзВременногоХранилища(ДанныеРасшифровки);
	ЭлементРасшифровки = ДанныеРасшифровкиОтчета.Элементы[Расшифровка];

	Если ТипЗнч(ЭлементРасшифровки) = Тип("ЭлементРасшифровкиКомпоновкиДанныхПоля") Тогда
		Для Каждого ЗначениеПоляРасшифровки Из ЭлементРасшифровки.ПолучитьПоля() Цикл
			Значение = ЗначениеПоляРасшифровки.Значение;
			Если Справочники.ТипВсеСсылки().СодержитТип(ТипЗнч(Значение))
			 ИЛИ Документы.ТипВсеСсылки().СодержитТип(ТипЗнч(Значение)) Тогда
				Возврат Значение;
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;

	Возврат Неопределено;

КонецФункции

// Добавляет элемент в состав сегмента.
&НаСервере
Процедура ДобавитьЭлемент(Элемент, СкомпоноватьРезультат = Ложь, ВыводитьСообщения = Ложь)
	
	Если ТипЗнч(Элемент) = Тип("Массив") Тогда
		Для каждого ЭлементМассива Из Элемент Цикл
			ДобавитьЭлемент(ЭлементМассива,СкомпоноватьРезультат,ВыводитьСообщения);
		КонецЦикла;
		Возврат;
	ИначеЕсли ТипЗнч(Элемент) = Тип("СправочникСсылка.Номенклатура") Тогда
		Номенклатура = Элемент;
	Иначе
		Номенклатура = Элемент.Номенклатура;
	КонецЕсли;
	
	Если Номенклатура.Пустая() Тогда
		Возврат;
	КонецЕсли;
	
	Запись = РегистрыСведений.НоменклатураСегмента.СоздатьМенеджерЗаписи();
	Запись.Сегмент = Сегмент;
	Если ИспользоватьХарактеристикиНоменклатуры Тогда
		Запись.Номенклатура = Номенклатура;
		Если ЗначениеЗаполнено(Элемент.Характеристика) Тогда
			Запись.Характеристика = Элемент.Характеристика;
		КонецЕсли;
	Иначе
		Запись.Номенклатура = Номенклатура;
	КонецЕсли;
	
	
	Запись.Прочитать();
	
	Если Запись.Выбран() Тогда
		Если ВыводитьСообщения Тогда
			
			ОбщегоНазначения.СообщитьПользователю(
				Строка(Запись.Номенклатура)
				+ ?(ЗначениеЗаполнено(Запись.Характеристика), "/" + Строка(Запись.Характеристика), "")
				+ " " + НСтр("ru='уже включен в сегмент.'"));
			
		КонецЕсли;
	Иначе
		
		Запись.Сегмент = Сегмент;
		Если ИспользоватьХарактеристикиНоменклатуры Тогда
			Запись.Номенклатура = Номенклатура;
			Если ЗначениеЗаполнено(Элемент.Характеристика) Тогда
				Запись.Характеристика = Элемент.Характеристика;
			КонецЕсли;
		Иначе
			Запись.Номенклатура = Номенклатура;
		КонецЕсли;
		
		Запись.Записать();
		Если СкомпоноватьРезультат Тогда
			СкомпоноватьРезультат();
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
