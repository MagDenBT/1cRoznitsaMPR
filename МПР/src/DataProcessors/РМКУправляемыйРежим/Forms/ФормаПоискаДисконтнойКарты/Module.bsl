
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.ГруппаСтраница1;
	Элементы.СтраницыВвода.ТекущаяСтраница = Элементы.СтраницаВводимоеЧисло;
	ТекущийЭлемент = Элементы.ПолеВводимоеЧисло;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Команда0(Команда)
	
	ДобавитьЦифру("0")
	
КонецПроцедуры

&НаКлиенте
Процедура Команда1(Команда)
	
	ДобавитьЦифру("1")
	
КонецПроцедуры

&НаКлиенте
Процедура Команда2(Команда)
	
	ДобавитьЦифру("2")
	
КонецПроцедуры

&НаКлиенте
Процедура Команда3(Команда)
	
	ДобавитьЦифру("3")
	
КонецПроцедуры

&НаКлиенте
Процедура Команда4(Команда)
	
	ДобавитьЦифру("4")
	
КонецПроцедуры

&НаКлиенте
Процедура Команда5(Команда)
	
	ДобавитьЦифру("5")
	
КонецПроцедуры

&НаКлиенте
Процедура Команда6(Команда)
	
	ДобавитьЦифру("6")
	
КонецПроцедуры

&НаКлиенте
Процедура Команда7(Команда)
	
	ДобавитьЦифру("7")
	
КонецПроцедуры

&НаКлиенте
Процедура Команда8(Команда)
	
	ДобавитьЦифру("8")
	
КонецПроцедуры

&НаКлиенте
Процедура Команда9(Команда)
	
	ДобавитьЦифру("9")
	
КонецПроцедуры

&НаКлиенте
Процедура Команда0ПраваяКлавиатура(Команда)
	
	ДобавитьЦифру("0")
	
КонецПроцедуры

&НаКлиенте
Процедура Команда1ПраваяКлавиатура(Команда)
	
	ДобавитьЦифру("1")
	
КонецПроцедуры

&НаКлиенте
Процедура Команда2ПраваяКлавиатура(Команда)
	
	ДобавитьЦифру("2")
	
КонецПроцедуры

&НаКлиенте
Процедура Команда3ПраваяКлавиатура(Команда)
	
	ДобавитьЦифру("3")
	
КонецПроцедуры

&НаКлиенте
Процедура Команда4ПраваяКлавиатура(Команда)
	
	ДобавитьЦифру("4")
	
КонецПроцедуры

&НаКлиенте
Процедура Команда5ПраваяКлавиатура(Команда)
	
	ДобавитьЦифру("5")
	
КонецПроцедуры

&НаКлиенте
Процедура Команда6ПраваяКлавиатура(Команда)
	
	ДобавитьЦифру("6")
	
КонецПроцедуры

&НаКлиенте
Процедура Команда7ПраваяКлавиатура(Команда)
	
	ДобавитьЦифру("7")
	
КонецПроцедуры

&НаКлиенте
Процедура Команда8ПраваяКлавиатура(Команда)
	
	ДобавитьЦифру("8")
	
КонецПроцедуры

&НаКлиенте
Процедура Команда9ПраваяКлавиатура(Команда)
	
	ДобавитьЦифру("9")
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаСтереть(Команда)
	ВводимоеЧисло = "";
	КодТелефона = "";
	НомерТелефонаЧасть1 = "";
	НомерТелефонаЧасть2 = "";
	НомерТелефонаЧасть3 = "";
	Если РежимПоискаКарты = 1 Тогда
		ПервыйВвод = Истина;
	Иначе
		ПервыйВвод = Ложь;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура КомандаEnter(Команда)
	
	ЗакрытьСПередачейРезультата();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ДобавитьЦифру(ВведеннаяЦифраСтрокой)
	
	Если ПервыйВвод Тогда
		ВводимоеЧисло = "";
		КодТелефона = "";
		НомерТелефонаЧасть1 = "";
		НомерТелефонаЧасть2 = "";
		НомерТелефонаЧасть3 = "";
		ПервыйВвод = Ложь;
	КонецЕсли;
	Если РежимПоискаКарты = 1 Тогда
		Если СтрДлина(КодТелефона) = 3 Тогда
			Если СтрДлина(НомерТелефонаЧасть1) = 3 Тогда
				Если СтрДлина(НомерТелефонаЧасть2) = 2 Тогда
					НомерТелефонаЧасть3 = НомерТелефонаЧасть3 + ВведеннаяЦифраСтрокой;
					Если СтрДлина(НомерТелефонаЧасть3) = 2 Тогда
						ТекущийЭлемент = Элементы.КомандаEnter;
					КонецЕсли;
				Иначе
					НомерТелефонаЧасть2 = НомерТелефонаЧасть2 + ВведеннаяЦифраСтрокой;
				КонецЕсли;
			Иначе
				НомерТелефонаЧасть1 = НомерТелефонаЧасть1 + ВведеннаяЦифраСтрокой;
			КонецЕсли;
		Иначе
			КодТелефона = КодТелефона + ВведеннаяЦифраСтрокой;
		КонецЕсли;
		ВводимоеЧисло = "7" + КодТелефона + НомерТелефонаЧасть1 + НомерТелефонаЧасть2 + НомерТелефонаЧасть3;
	Иначе
		ВводимоеЧисло = ВводимоеЧисло + ВведеннаяЦифраСтрокой;
		ТекущийЭлемент = Элементы.ПолеВводимоеЧисло;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗакрытьСПередачейРезультата()
	
	СтруктураОтвета = Новый Структура;
	СтруктураОтвета.Вставить("ВведенноеЧисло", ВводимоеЧисло);
	Если РежимПоискаКарты = 1 Тогда
		СтруктураОтвета.Вставить("РежимПоискаКарты", "НомерТелефона");
	ИначеЕсли РежимПоискаКарты = 2 Тогда
		СтруктураОтвета.Вставить("РежимПоискаКарты", "ФИО");
	ИначеЕсли РежимПоискаКарты = 3 Тогда
		СтруктураОтвета.Вставить("РежимПоискаКарты", "Email");
	Иначе
		СтруктураОтвета.Вставить("РежимПоискаКарты", "КодКарты");
	КонецЕсли;
	
	Закрыть(СтруктураОтвета);
	
КонецПроцедуры

&НаКлиенте
Процедура РежимПоискаКартыПриИзменении(Элемент)
	КомандаСтереть(Неопределено);
	УстановитьФокусВвода();
КонецПроцедуры

&НаКлиенте
Процедура УстановитьФокусВвода()
	
	Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.ГруппаСтраница1;
	Если РежимПоискаКарты =1 Тогда
		ТекущийЭлемент = Элементы.Команда9;
		Элементы.СтраницыВвода.ТекущаяСтраница = Элементы.СтраницаТелефон;
	Иначе
		Элементы.СтраницыВвода.ТекущаяСтраница = Элементы.СтраницаВводимоеЧисло;
		ТекущийЭлемент = Элементы.ПолеВводимоеЧисло;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаТипПоиска(Команда)
	
	КомандаСтереть(Неопределено);
	Если РежимПоискаКарты >= 3 Тогда
		РежимПоискаКарты = 0;
	Иначе
		РежимПоискаКарты = РежимПоискаКарты + 1;
	КонецЕсли;
	
	УстановитьФокусВвода();
	
КонецПроцедуры

#КонецОбласти