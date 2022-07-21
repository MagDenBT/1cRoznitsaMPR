#Область СлужебныйПрограммныйИнтерфейс

#Область Локализация

//Обработчик события вызывается на сервере при открытии формы конфигурации.
//   Выполняется определение необходимости встраивания подсистем (с учетом их наличия) в форму.
//
// Параметры:
//   Форма            - ФормаКлиентскогоПриложения - форма конфигурации
//   МодулиИнтеграции - Массив           - используемые модули интеграции
//
Процедура ПриОпределенииПараметровИнтеграцииФормыПрикладногоОбъекта(Форма, МодулиИнтеграции) Экспорт
	
	СобытияФормИСРТ.ПриОпределенииПараметровИнтеграцииФормыПрикладногоОбъекта(Форма, МодулиИнтеграции);
	
КонецПроцедуры

// Серверные обработчики БГосИС элементов прикладных форм
//
// Параметры:
//   Форма                   - ФормаКлиентскогоПриложения - форма, из которой происходит вызов процедуры.
//   Элемент                 - Произвольный     - элемент-источник события "При изменении"
//   ДополнительныеПараметры - Структура        - значения дополнительных параметров влияющих на обработку.
//
Процедура ПриИзмененииЭлемента(Форма, Элемент, ДополнительныеПараметры) Экспорт
	
	СобытияФормИСРТ.ПриИзмененииЭлемента(Форма, Элемент, ДополнительныеПараметры);
	
КонецПроцедуры

// Вызывается после записи объекта на сервере.
//
// Параметры:
//  Форма - ФормаКлиентскогоПриложения - источник вызова
Процедура ПослеЗаписиНаСервереФормыПрикладногоОбъекта(Форма) Экспорт
	
	СобытияФормИСРТ.ПослеЗаписиНаСервереФормыПрикладногоОбъекта(Форма);
	
КонецПроцедуры

Процедура ПриСозданииНаСервереВФормеПрикладногоОбъекта(Форма, Отказ, СтандартнаяОбработка, ДополнительныеПараметры) Экспорт
	
	СобытияФормИСРТ.ПриСозданииНаСервереВФормеПрикладногоОбъекта(Форма, Отказ, СтандартнаяОбработка, ДополнительныеПараметры);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийОбъектов

// Обработчик события вызывается на сервере при получении стандартной управляемой формы.
// Если требуется переопределить выбор открываемой формы, необходимо установить в параметре <ВыбраннаяФорма>
// другое имя формы или объект метаданных формы, которую требуется открыть, и в параметре <СтандартнаяОбработка>
// установить значение Ложь.
//
// Параметры:
//  ИмяСправочника - Строка - имя справочника, для которого открывается форма,
//  ВидФормы - Строка - имя стандартной формы,
//  Параметры - Структура - параметры формы,
//  ВыбраннаяФорма - Строка, ФормаКлиентскогоПриложения - содержит имя открываемой формы или объект метаданных Форма,
//  ДополнительнаяИнформация - Структура - дополнительная информация открытия формы,
//  СтандартнаяОбработка - Булево - признак выполнения стандартной обработки события.
Процедура ПриПолученииФормыСправочника(ИмяСправочника, ВидФормы, Параметры, ВыбраннаяФорма, ДополнительнаяИнформация, СтандартнаяОбработка) Экспорт
	
	СобытияФормИСРТ.ПриПолученииФормыСправочника(ИмяСправочника, 
		ВидФормы, 
		Параметры, 
		ВыбраннаяФорма, 
		ДополнительнаяИнформация, 
		СтандартнаяОбработка);
	
КонецПроцедуры

// Обработчик события вызывается на сервере при получении стандартной управляемой формы.
// Если требуется переопределить выбор открываемой формы, необходимо установить в параметре <ВыбраннаяФорма>
// другое имя формы или объект метаданных формы, которую требуется открыть, и в параметре <СтандартнаяОбработка>
// установить значение Ложь.
//
// Параметры:
//  ИмяДокумента - Строка - имя документа, для которого открывается форма,
//  ВидФормы - Строка - имя стандартной формы,
//  Параметры - Структура - параметры формы,
//  ВыбраннаяФорма - Строка, ФормаКлиентскогоПриложения - содержит имя открываемой формы или объект метаданных Форма,
//  ДополнительнаяИнформация - Структура - дополнительная информация открытия формы,
//  СтандартнаяОбработка - Булево - признак выполнения стандартной обработки события.
Процедура ПриПолученииФормыДокумента(ИмяДокумента, ВидФормы, Параметры, ВыбраннаяФорма, ДополнительнаяИнформация, СтандартнаяОбработка) Экспорт
	
	СобытияФормИСРТ.ПриПолученииФормыДокумента(ИмяДокумента, 
		ВидФормы, 
		Параметры, 
		ВыбраннаяФорма, 
		ДополнительнаяИнформация, 
		СтандартнаяОбработка);
	
КонецПроцедуры

// Обработчик события вызывается на сервере при получении стандартной управляемой формы.
// Если требуется переопределить выбор открываемой формы, необходимо установить в параметре <ВыбраннаяФорма>
// другое имя формы или объект метаданных формы, которую требуется открыть, и в параметре <СтандартнаяОбработка>
// установить значение Ложь.
//
// Параметры:
//  ИмяРегистра - Строка - имя регистра сведений, для которого открывается форма,
//  ВидФормы - Строка - имя стандартной формы,
//  Параметры - Структура - параметры формы,
//  ВыбраннаяФорма - Строка, ФормаКлиентскогоПриложения - содержит имя открываемой формы или объект метаданных Форма,
//  ДополнительнаяИнформация - Структура - дополнительная информация открытия формы,
//  СтандартнаяОбработка - Булево - признак выполнения стандартной обработки события.
Процедура ПриПолученииФормыРегистраСведений(ИмяРегистра, ВидФормы, Параметры, ВыбраннаяФорма, ДополнительнаяИнформация, СтандартнаяОбработка) Экспорт
	
	СобытияФормИСРТ.ПриПолученииФормыРегистраСведений(ИмяРегистра, 
		ВидФормы, 
		Параметры, 
		ВыбраннаяФорма, 
		ДополнительнаяИнформация, 
		СтандартнаяОбработка);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийФормы

// Возникает на сервере при создании формы.
//
// Параметры:
//  Форма - ФормаКлиентскогоПриложения - создаваемая форма,
//  Отказ - Булево - признак отказа от создания формы,
//  СтандартнаяОбработка - Булево - признак выполнения стандартной обработки.
Процедура ПриСозданииНаСервере(Форма, Отказ, СтандартнаяОбработка) Экспорт
	
	СобытияФормИСРТ.ПриСозданииНаСервере(Форма, Отказ, СтандартнаяОбработка);
	
КонецПроцедуры

// Вызывается при чтении объекта на сервере.
//
// Параметры:
//  Форма - ФормаКлиентскогоПриложения - форма читаемого объекта,
//  ТекущийОбъект - ДокументОбъект, СправочникОбъект - читаемый объект.
Процедура ПриЧтенииНаСервере(Форма, ТекущийОбъект) Экспорт
	
	СобытияФормИСРТ.ПриЧтенииНаСервере(Форма, ТекущийОбъект);
	
КонецПроцедуры

// Переопределяемая процедура, вызываемая из одноименного обработчика события формы.
//
// Параметры:
//  Форма - форма, из обработчика события которой происходит вызов процедуры.
//          См. справочную информацию по событиям управляемой формы.
Процедура ПослеЗаписиНаСервере(Форма, ТекущийОбъект, ПараметрыЗаписи)Экспорт
	
	СобытияФормИС.ПослеЗаписиНаСервере(Форма);
	
КонецПроцедуры

// Переопределяемая часть обработки проверки заполнения формы.
//
// Параметры:
//   Форма - ФормаКлиентскогоПриложения - Форма.
//   Отказ - Булево - Истина если проверка заполнения не пройдена
//   ПроверяемыеРеквизиты - Массив Из Строка - реквизиты формы, отмеченные для проверки
Процедура ОбработкаПроверкиЗаполненияНаСервере(Форма, Отказ, ПроверяемыеРеквизиты) Экспорт
	
	СобытияФормИСРТ.ОбработкаПроверкиЗаполненияНаСервере(Форма, Отказ, ПроверяемыеРеквизиты);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиДействийФорм

// Возникает на сервере при записи константы в формах настроек
// если запись одной константы может повлечь изменение других отображаемых в этой же форме.
//
// Параметры:
//  Форма             - ФормаКлиентскогоПриложения - форма,
//  КонстантаИмя      - Строка           - записываемая константа,
//  КонстантаЗначение - Произвольный     - значение константы.
Процедура ОбновитьФормуНастройкиПриЗаписиПодчиненныхКонстант(Форма, КонстантаИмя, КонстантаЗначение) Экспорт
	
	СобытияФормИСРТ.ОбновитьФормуНастройкиПриЗаписиПодчиненныхКонстант(Форма, КонстантаИмя, КонстантаЗначение);
	
КонецПроцедуры

// Устанавливается свойство ОтображениеПредупрежденияПриРедактировании элемента формы.
//
Процедура ОтображениеПредупрежденияПриРедактировании(Элемент, Отображать) Экспорт

	СобытияФормИСРТ.ОтображениеПредупрежденияПриРедактировании(Элемент, Отображать);
	
КонецПроцедуры

#КонецОбласти

#Область УсловноеОформление

// Устанавливает условное оформление для поля "Характеристика".
//
// Параметры:
//  Форма - ФормаКлиентскогоПриложения - форма, в которой нужно установить условное оформление,
//  ИмяПоляВводаХарактеристики - Строка - имя элемента формы "Характеристика",
//  ПутьКПолюОтбора - Строка - полный путь к реквизиту "Характеристики используются".
Процедура УстановитьУсловноеОформлениеХарактеристикНоменклатуры(
	Форма,
	ИмяПоляВводаХарактеристики = "ТоварыХарактеристика",
	ПутьКПолюОтбора = "Объект.Товары.ХарактеристикиИспользуются") Экспорт
	
	СобытияФормИСРТ.УстановитьУсловноеОформлениеХарактеристикНоменклатуры(
		Форма,
		ИмяПоляВводаХарактеристики,
		ПутьКПолюОтбора);
	
КонецПроцедуры

// Устанавливает условное оформление для поля "Единица измерения".
//
// Параметры:
//  Форма - ФормаКлиентскогоПриложения - форма, в которой нужно установить условное оформление,
//  ИмяПоляВводаЕдиницИзмерения - Строка - имя элемента формы "Единица измерения",
//  ПутьКПолюОтбора - Строка - полный путь к реквизиту "Упаковка".
Процедура УстановитьУсловноеОформлениеЕдиницИзмерения(Форма,
	                                                  ИмяПоляВводаЕдиницИзмерения = "ТоварыНоменклатураЕдиницаИзмерения",
	                                                  ПутьКПолюОтбора = "Объект.Товары.Упаковка") Экспорт
	
	СобытияФормИСРТ.УстановитьУсловноеОформлениеЕдиницИзмерения(Форма,
		ИмяПоляВводаЕдиницИзмерения = "ТоварыНоменклатураЕдиницаИзмерения",
		ПутьКПолюОтбора = "Объект.Товары.Упаковка");
	
КонецПроцедуры

// Устанавливает условное оформление для поля "Серия".
//
// Параметры:
//   Форма - ФормаКлиентскогоПриложения - Форма, в которой нужно установить условное оформление,
//   ИмяПоляВводаСерии - Строка - Имя элемента формы для указания серии
//   ПутьКПолюОтбораСтатусУказанияСерий - Строка - Имя реквизита формы со статусом указания серии
//   ПутьКПолюОтбораТипНоменклатуры - Строка - Имя реквизита формы с указанием типа номенклатуры
//
Процедура УстановитьУсловноеОформлениеСерийНоменклатуры(Форма,
														ИмяПоляВводаСерии = "ТоварыСерия",
														ПутьКПолюОтбораСтатусУказанияСерий = "Объект.Товары.СтатусУказанияСерий",
														ПутьКПолюОтбораТипНоменклатуры = "Объект.Товары.ТипНоменклатуры") Экспорт
	
	СобытияФормИСРТ.УстановитьУсловноеОформлениеСерийНоменклатуры(Форма,
		ИмяПоляВводаСерии,
		ПутьКПолюОтбораСтатусУказанияСерий,
		ПутьКПолюОтбораТипНоменклатуры);
	
КонецПроцедуры

#КонецОбласти

#Область СвязиПараметровВыбора

// Устанавливает связь элемента формы с полем ввода номенклатуры.
//
// Параметры:
//	Форма					- ФормаКлиентскогоПриложения	- Форма, в которой нужно установить связь.
//	ИмяПоляВвода			- Строка			- Имя поля, связываемого с номенклатурой.
//	ПутьКДаннымНоменклатуры	- Строка			- Путь к данным текущей номенклатуры в форме.
//
Процедура УстановитьСвязиПараметровВыбораСНоменклатурой(Форма, ИмяПоляВвода,
	ПутьКДаннымНоменклатуры = "Элементы.Товары.ТекущиеДанные.Номенклатура") Экспорт
	
	СобытияФормИСРТ.УстановитьСвязиПараметровВыбораСНоменклатурой(Форма, 
		ИмяПоляВвода,
		ПутьКДаннымНоменклатуры);
	
КонецПроцедуры

// Устанавливает связь элемента формы с полем ввода характеристики номенклатуры.
//
// Параметры:
//	Форма						- ФормаКлиентскогоПриложения	- Форма, в которой нужно установить связь.
//	ИмяПоляВвода				- Строка			- Имя поля, связываемого с номенклатурой.
//	ПутьКДаннымХарактеристики	- Строка			- Путь к данным текущей характеристики номенклатуры в форме.
//
Процедура УстановитьСвязиПараметровВыбораСХарактеристикой(Форма, ИмяПоляВвода,
	ПутьКДаннымХарактеристики = "Элементы.Товары.ТекущиеДанные.Характеристика") Экспорт
	
	СобытияФормИСРТ.УстановитьСвязиПараметровВыбораСХарактеристикой(Форма, 
		ИмяПоляВвода,
		ПутьКДаннымХарактеристики);
	
КонецПроцедуры

#КонецОбласти

#Область Прочее

// Устанавливает у элемента формы Упаковка подсказку ввода для соответствующей номенклатуры
//
// Параметры:
// 	Форма - ФормаКлиентскогоПриложения - Форма объекта.
//
Процедура УстановитьИнформациюОЕдиницеХранения(Форма) Экспорт
	
	СобытияФормИСРТ.УстановитьИнформациюОЕдиницеХранения(Форма);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиИзмененияОпределяемыхТипов

// Выполняет действия при изменении номенклатуры в объекте (форме, строке табличной части итп).
//
// Параметры:
//  Форма                  - ФормаКлиентскогоПриложения - форма, в которой произошло событие,
//  ТекущаяСтрока          - Произвольный - контекст редактирования (текущая строка таблицы, шапка объекта, форма)
//  КэшированныеЗначения   - Неопределено, Структура - сохраненные значения параметров, используемых при обработке,
//  ПараметрыУказанияСерий - Произвольный - параметры указания серий формы
Процедура ПриИзмененииНоменклатуры(Форма, ТекущаяСтрока, КэшированныеЗначения = Неопределено, ПараметрыУказанияСерий = Неопределено) Экспорт
	
	СобытияФормИСРТ.ПриИзмененииНоменклатуры(Форма, ТекущаяСтрока, КэшированныеЗначения, ПараметрыУказанияСерий);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти
