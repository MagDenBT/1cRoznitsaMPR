#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	СуффиксыИменЭлементов = Новый Массив;
	
	СуффиксыИменЭлементов.Добавить("Товар");
	СуффиксыИменЭлементов.Добавить("Услуга");
	СуффиксыИменЭлементов.Добавить("ПодарочныйСертификат");
	
	Для Каждого Суффикс из СуффиксыИменЭлементов Цикл
		Элементы["ТипНоменклатуры" + Суффикс].Подсказка = Перечисления.ТипыНоменклатуры.ПодсказкаПоТипуНоменклатуры(
															ПредопределенноеЗначение("Перечисление.ТипыНоменклатуры." + Суффикс));
	КонецЦикла;
		
	ТипНоменклатуры = Параметры.ТипНоменклатуры;
	
	ПризнакПредметаРасчета = Параметры.ПризнакПредметаРасчета;
	
	СвязьОсобенностейУчетаИФО = Перечисления.ОсобенностиУчетаНоменклатуры.СвязьОсобенностейУчетаИФО();
	
	ЕстьОсобенностьПоТоварам = Ложь;
	Для Каждого ЗначениеПеречисления Из Перечисления.ОсобенностиУчетаНоменклатуры Цикл
		
		ОсобенностьВключена = Ложь;
		ИменаФО = СвязьОсобенностейУчетаИФО.Получить(ЗначениеПеречисления);
		
		Если ИменаФО <> Неопределено Тогда
			МассивИменФО = СтрРазделить(ИменаФО, ",");
			Для Каждого СтрМас Из МассивИменФО Цикл
				Если Не ПолучитьФункциональнуюОпцию(СтрМас) Тогда
					ОсобенностьВключена = Ложь;
					Прервать;
				Иначе
					ОсобенностьВключена = Истина;
					ЕстьОсобенностьПоТоварам = Истина;
				КонецЕсли;
			КонецЦикла;
		КонецЕсли;
		
		ИмяЗначенияПеречисления = ОбщегоНазначения.ИмяЗначенияПеречисления(ЗначениеПеречисления);
		Если ОсобенностьВключена Тогда
			Элементы["ОсобенностьУчета" + ИмяЗначенияПеречисления].Подсказка =
			Перечисления.ОсобенностиУчетаНоменклатуры.ПодсказкаПоОсобенностиУчетаНоменклатуры(ЗначениеПеречисления);
		Иначе
			Элементы["ОсобенностьУчета" + ИмяЗначенияПеречисления].Видимость = Ложь;	
		КонецЕсли;
	КонецЦикла;
	
	Элементы.ОсобенностьУчетаБезОсобенностейУчета.Видимость = ЕстьОсобенностьПоТоварам;

	Если ТипНоменклатуры = Перечисления.ТипыНоменклатуры.Товар Тогда
		ОсобенностьУчета = Параметры.ОсобенностьУчета;
		ПродаетсяВРозлив = Параметры.ПродаетсяВРозлив;
		Элементы.ГруппаОсобенностиЗначения.Доступность = Истина;
		Элементы.ПродаетсяВРозлив.Доступность = ОсобенностьУчета = Перечисления.ОсобенностиУчетаНоменклатуры.АлкогольнаяПродукция;
	Иначе
		ОсобенностьУчета = Перечисления.ОсобенностиУчетаНоменклатуры.ПустаяСсылка();
		ПродаетсяВРозлив = Ложь;
		Элементы.ГруппаОсобенностиЗначения.Доступность = Ложь;
		Элементы.ПродаетсяВРозлив.Доступность = Ложь;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОК(Команда)
	Результат = Новый Структура("ТипНоменклатуры, ОсобенностьУчета, ПродаетсяВРозлив, ПризнакПредметаРасчета");
	Результат.ТипНоменклатуры = ТипНоменклатуры;
	Результат.ПризнакПредметаРасчета = ПризнакПредметаРасчета;
	
	Если ТипНоменклатуры = ПредопределенноеЗначение("Перечисление.ТипыНоменклатуры.Товар") Тогда
		Результат.ОсобенностьУчета = ОсобенностьУчета;
	Иначе
		Результат.ОсобенностьУчета = ОсобенностьУчета = ПредопределенноеЗначение("Перечисление.ОсобенностиУчетаНоменклатуры.БезОсобенностейУчета");
	КонецЕсли;
	
	Если Результат.ОсобенностьУчета = ПредопределенноеЗначение("Перечисление.ОсобенностиУчетаНоменклатуры.АлкогольнаяПродукция") Тогда
		Результат.ПродаетсяВРозлив = ПродаетсяВРозлив;
	Иначе
		Результат.ПродаетсяВРозлив = Ложь;
	КонецЕсли;
	
	Если ПроверитьЗаполнение() Тогда
		Закрыть(Результат);
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура Отмена(Команда)
	Закрыть();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура ТипНоменклатурыПриИзменении(Элемент)
	
	Если ТипНоменклатуры = ПредопределенноеЗначение("Перечисление.ТипыНоменклатуры.Товар") Тогда
		ОсобенностьУчета = ПредопределенноеЗначение("Перечисление.ОсобенностиУчетаНоменклатуры.БезОсобенностейУчета");
		Элементы.ГруппаОсобенностиЗначения.Доступность = Истина;
	Иначе
		ОсобенностьУчета = ПредопределенноеЗначение("Перечисление.ОсобенностиУчетаНоменклатуры.ПустаяСсылка");
		ПродаетсяВРозлив = Ложь;
		Элементы.ГруппаОсобенностиЗначения.Доступность = Ложь;
	КонецЕсли;
	Элементы.ПродаетсяВРозлив.Доступность = Ложь;
	
	РасчитатьПризнакПредметаРасчета();
	
КонецПроцедуры

&НаКлиенте
Процедура ОсобенностьУчетаПриИзменении(Элемент)
	
	ПродаетсяВРозлив = Ложь;
	Если ОсобенностьУчета = ПредопределенноеЗначение("Перечисление.ОсобенностиУчетаНоменклатуры.АлкогольнаяПродукция") Тогда
		Элементы.ПродаетсяВРозлив.Доступность = Истина;
	Иначе
		Элементы.ПродаетсяВРозлив.Доступность = Ложь ;
	КонецЕсли; 
	
	ТипНоменклатуры = ПредопределенноеЗначение("Перечисление.ТипыНоменклатуры.Товар");
	
	РасчитатьПризнакПредметаРасчета();
	
КонецПроцедуры

&НаКлиенте
Процедура РасчитатьПризнакПредметаРасчета()
	
	Если ТипНоменклатуры = ПредопределенноеЗначение("Перечисление.ТипыНоменклатуры.Товар") Тогда
		
		Если ОсобенностьУчета = ПредопределенноеЗначение("Перечисление.ОсобенностиУчетаНоменклатуры.АлкогольнаяПродукция") Тогда
			ПризнакПредметаРасчета = ПредопределенноеЗначение("Справочник.ПризнакиПредметовРасчета.ПодакцизныйТоварМаркируемыйСИНеИмеющийКМ");
		ИначеЕсли ОсобенностьУчета = ПредопределенноеЗначение("Перечисление.ОсобенностиУчетаНоменклатуры.ТабачнаяПродукция")
			ИЛИ ОсобенностьУчета = ПредопределенноеЗначение("Перечисление.ОсобенностиУчетаНоменклатуры.АльтернативныйТабак")
			ИЛИ ОсобенностьУчета = ПредопределенноеЗначение("Перечисление.ОсобенностиУчетаНоменклатуры.НикотиносодержащаяПродукция") Тогда
			ПризнакПредметаРасчета = ПредопределенноеЗначение("Справочник.ПризнакиПредметовРасчета.ПодакцизныйТоварМаркируемыйСИИмеющийКМ");
		ИначеЕсли ОсобенностьУчета = ПредопределенноеЗначение("Перечисление.ОсобенностиУчетаНоменклатуры.ПродукцияМаркируемаяДляГИСМ") Тогда
			ПризнакПредметаРасчета = ПредопределенноеЗначение("Справочник.ПризнакиПредметовРасчета.ТоварМаркируемыйСИНеИмеющийКМ");
		Иначе
			
			ВидыПродукциИСМП = ИнтеграцияИСКлиентСервер.ВидыПродукцииИСМП(Ложь, Истина);
			
			МаркируемаяНеподакцизнаяПродукция = Новый Массив;
			Для Каждого ВидПродукцииИСМП Из ВидыПродукциИСМП Цикл
				ОсобенностьУчетаИСМП = ИнтеграцияИСРТКлиентСервер.ОсобенностьУчетаПоВидуПродукции(ВидПродукцииИСМП, Ложь);
				МаркируемаяНеподакцизнаяПродукция.Добавить(ОсобенностьУчетаИСМП);
			КонецЦикла;
			
			Если МаркируемаяНеподакцизнаяПродукция.Найти(ОсобенностьУчета) = Неопределено Тогда
				ПризнакПредметаРасчета = ПредопределенноеЗначение("Справочник.ПризнакиПредметовРасчета.Товар");
			Иначе
				ПризнакПредметаРасчета = ПредопределенноеЗначение("Справочник.ПризнакиПредметовРасчета.ТоварМаркируемыйСИИмеющийКМ");
			КонецЕсли;
			
		КонецЕсли;
	Иначе
		Если ТипНоменклатуры = ПредопределенноеЗначение("Перечисление.ТипыНоменклатуры.Услуга") Тогда
			ПризнакПредметаРасчета = ПредопределенноеЗначение("Справочник.ПризнакиПредметовРасчета.Услуга");
		ИначеЕсли ТипНоменклатуры = ПредопределенноеЗначение("Перечисление.ТипыНоменклатуры.ПодарочныйСертификат") Тогда
			ПризнакПредметаРасчета = ПредопределенноеЗначение("Справочник.ПризнакиПредметовРасчета.Платеж");
		Иначе
			ПризнакПредметаРасчета = ПредопределенноеЗначение("Справочник.ПризнакиПредметовРасчета.Товар");
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти


