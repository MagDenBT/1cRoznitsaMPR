#Область ПрограммныйИнтерфейс

#Область Локализация

// Переопределение параметров интеграции ГИСМ (расположения форматированной строки)
//
// Параметры:
//  Форма - УправляемаяФорма - прикладная форма для встраивания форматированной строки;
//  ПараметрыНадписи - Структура - (см. СобытияФормИС.ПараметрыИнтеграцииДляДокументаОснования).
//
Процедура ПриОпределенииПараметровИнтеграцииДляДокументаОснования(Форма, ПараметрыНадписи) Экспорт
	
	Если Форма.ИмяФормы = "Документ.ВозвратТоваровОтПокупателя.Форма.ФормаДокумента"
		Или Форма.ИмяФормы = "Документ.ОтчетОРозничныхПродажах.Форма.ФормаДокумента" Тогда
		
		ПараметрыНадписи.ИмяЭлементаФормы  = "";
		ПараметрыНадписи.ИмяРеквизитаФормы = "";
		
	КонецЕсли;
КонецПроцедуры

// Переопределение параметров интеграции ГИСМ (расположения форматированной строки)
//
// Параметры:
//  Форма - УправляемаяФорма - прикладная форма для встраивания форматированной строки;
//  ПараметрыНадписи - Структура - (см. СобытияФормИС.ПараметрыИнтеграцииДляДокументаОснования).
//
Процедура ПриОпределенииПараметровИнтеграцииДляОбмена(Форма, ПараметрыНадписи) Экспорт
	
	Если Форма.ИмяФормы = "Документ.ВозвратТоваровОтПокупателя.Форма.ФормаДокумента"
		Или Форма.ИмяФормы = "Документ.ОтчетОРозничныхПродажах.Форма.ФормаДокумента" Тогда
		
		ПараметрыНадписи.ИмяЭлементаФормы = "";
		ПараметрыНадписи.ИмяРеквизитаФормы = "";
	КонецЕсли;
КонецПроцедуры

// Заполняет требуемый тип надписи в прикладной форме из фиксированного списка:
//  УведомлениеОбОтгрузке
//  УведомлениеОСписании
//  <пустая строка> (надпись не требуется)
//
// Параметры:
//  Форма - УправляемаяФорма - форма для размещения надписи;
//  ТипНадписи - Строка - тип надписи связанных документов ГИСМ.
//
Процедура ПриОпределенииТипаНадписиПоФорме(Форма, ТипНадписи) Экспорт
	
	Если Форма.ИмяФормы = "Документ.РеализацияТоваров.Форма.ФормаДокумента"
		Или Форма.ИмяФормы = "Документ.ВозвратТоваровПоставщику.Форма.ФормаДокумента" Тогда
		Если Форма.Объект.ЕстьМаркируемаяПродукцияГИСМ Тогда
			ТипНадписи = "УведомлениеОбОтгрузке";
		КонецЕсли;
	ИначеЕсли Форма.ИмяФормы = "Документ.СписаниеТоваров.Форма.ФормаДокумента" Тогда
		Если Форма.Объект.ЕстьМаркируемаяПродукцияГИСМ Или Форма.Объект.ЕстьКиЗГИСМ Тогда
			ТипНадписи = "УведомлениеОСписании";
		КонецЕсли;
	ИначеЕсли Форма.ИмяФормы = "Документ.ВозвратТоваровОтПокупателя.Форма.ФормаДокумента" Тогда
		Если Форма.Объект.ЕстьМаркируемаяПродукцияГИСМ И НЕ Форма.ПараметрыУказанияСерий.ИспользоватьСерииНоменклатуры Тогда
			ТипНадписи = "Маркировка";
		КонецЕсли;
	ИначеЕсли Форма.ИмяФормы = "Документ.ЗаказПоставщику.Форма.ФормаДокумента" Тогда
		Если Форма.Объект.ЕстьКиЗГИСМ Тогда
			ТипНадписи = "ЗаявкаНаВыпускКиЗГИСМ";
		КонецЕсли;
	ИначеЕсли Форма.ИмяФормы = "Документ.ПоступлениеТоваров.Форма.ФормаДокумента" Тогда
		Если Форма.Объект.ЕстьМаркируемаяПродукцияГИСМ Тогда
			Если Форма.Объект.ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ЗакупкаПоИмпорту Тогда
				ТипНадписи = "ЗакупкаПоИмпорту";
			ИначеЕсли Форма.Объект.ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ЗакупкаВСтранахЕАЭС Тогда
				ТипНадписи = "ЗакупкаВЕАЭС";
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

// Заполняет требуемый тип надписи в прикладной форме из фиксированного списка:
//  СтатусОбмена
//  <пустая строка> (надпись не требуется)
//
// Параметры:
//  Форма - УправляемаяФорма - форма для размещения надписи;
//  ТипНадписи - Строка - тип надписи связанных документов ГИСМ.
//
Процедура ПриОпределенииТипаСтатусаОбмена(Форма, ТипНадписи) Экспорт
	
	Если Форма.ИмяФормы = "Документ.ВозвратТоваровОтПокупателя.Форма.ФормаДокумента" Тогда
		
		Если Форма.Объект.ЕстьМаркируемаяПродукцияГИСМ
			И Форма.Объект.ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ВозвратОтПокупателя
			И Форма.ПараметрыУказанияСерий.ИспользоватьСерииНоменклатуры Тогда
			
			ТипНадписи = "СтатусОбмена";
			
		КонецЕсли;
		
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
			Форма.Элементы,
			"ФормаОбщаяКомандаПротоколОбменаГИСМ",
			"Видимость",
			Форма.Объект.ЕстьМаркируемаяПродукцияГИСМ);
		
	ИначеЕсли Форма.ИмяФормы = "Документ.ОтчетОРозничныхПродажах.Форма.ФормаДокумента" Тогда
		
		Если Форма.Объект.ЕстьМаркируемаяПродукцияГИСМ Тогда
				
			ТипНадписи = "СтатусОбмена";
			
		КонецЕсли;
		
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
			Форма.Элементы,
			"ФормаОбщаяКомандаПротоколОбменаГИСМ",
			"Видимость",
			Форма.Объект.ЕстьМаркируемаяПродукцияГИСМ);
		
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область СобытияФорм

// Вызывается из одноименного обработчика события формы.
//
Процедура ПриСозданииНаСервере(Форма, Отказ, СтандартнаяОбработка) Экспорт
	
	Возврат;
	
КонецПроцедуры

// Вызывается из одноименного обработчика события формы.
//
Процедура ПриЧтенииНаСервере(Форма, ТекущийОбъект) Экспорт
	
	Возврат;
	
КонецПроцедуры

// Вызывается из одноименного обработчика события формы.
//
Процедура ПослеЗаписиНаСервере(Форма) Экспорт
	
	Возврат;
	
КонецПроцедуры

#КонецОбласти

#Область СобытияЭлементовФорм

// Вызывается из одноименного обработчика события элемента.
//
Процедура ПриИзмененииЭлемента(Форма, Элемент, ДополнительныеПараметры) Экспорт
	
	Если Форма.ИмяФормы = "Документ.ПоступлениеТоваров.Форма.ФормаДокумента" Тогда
		Если Форма.Объект.ЕстьКиЗГИСМ ИЛИ Форма.Объект.ЕстьМаркируемаяПродукцияГИСМ Тогда
			СобытияФормГИСМ.ЗаполнениеРеквизитовФормы(Форма);
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#КонецОбласти


