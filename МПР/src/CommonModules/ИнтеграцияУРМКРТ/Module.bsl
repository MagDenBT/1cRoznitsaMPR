#Область ПрограммныйИнтерфейс

// Обработчик регистрации изменений для начальной выгрузки данных.
//
// Параметры:
//
//   Получатель - ПланОбменаСсылка - узел плана обмена, в который требуется выгрузить данные.
//   СтандартнаяОбработка - Булево - в данный параметр передается признак выполнения стандартной
//                          (системной) обработки события.
//                          Если в теле процедуры-обработчика установить данному параметру значение Ложь,
//                          стандартная обработка события производиться не будет.
//                          Отказ от стандартной обработки не отменяет действие.
//                          Значение по умолчанию - Истина.
//   Отбор - Массив из ОбъектМетаданных
//         - ОбъектМетаданных - определяет отбор по объектам метаданных,
//           для которых следует выполнить регистрацию изменений.
//
Процедура РегистрацияИзмененийНачальнойВыгрузкиДанных(Знач Получатель, СтандартнаяОбработка = Ложь, Отбор = Неопределено) Экспорт
	
	Если ТипЗнч(Получатель) <> Тип("ПланОбменаСсылка.ОбменСУРМК") Тогда
		Возврат;
	КонецЕсли;
	
	СтандартнаяОбработка	= Ложь;
	Отбор					= Новый Массив;
	
	ЗначенияРеквизитов 		= ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Получатель,
								"ВариантНастройки, ИспользоватьОтборПоОрганизациям, ДатаНачалаВыгрузкиДокументов, Организации");
	
	Для Каждого ЭлементСостава Из Получатель.Метаданные().Состав Цикл
		Отбор.Добавить(ЭлементСостава.Метаданные);
	КонецЦикла;
	
	МетаданныеРегистрируютсяПриНеобходимости = Новый Массив;
	МетаданныеРегистрируютсяПриНеобходимости.Добавить(Метаданные.Справочники.УпаковкиНоменклатуры);
	МетаданныеРегистрируютсяПриНеобходимости.Добавить(Метаданные.Справочники.СерииНоменклатуры);
	МетаданныеРегистрируютсяПриНеобходимости.Добавить(Метаданные.Справочники.Номенклатура);
	МетаданныеРегистрируютсяПриНеобходимости.Добавить(Метаданные.Справочники.БазовыеЕдиницыИзмерения);
	МетаданныеРегистрируютсяПриНеобходимости.Добавить(Метаданные.Справочники.ХарактеристикиНоменклатуры);
	МетаданныеРегистрируютсяПриНеобходимости.Добавить(Метаданные.РегистрыСведений.Штрихкоды);
	
	Для каждого ЭлементМассива Из МетаданныеРегистрируютсяПриНеобходимости Цикл
		ОбщегоНазначенияКлиентСервер.УдалитьЗначениеИзМассива(Отбор, ЭлементМассива);
	КонецЦикла;
	
	Если ЗначенияРеквизитов.ИспользоватьОтборПоОрганизациям Тогда
		ОтборОрганизации = ЗначенияРеквизитов.Организации.Выгрузить().ВыгрузитьКолонку("Организация");
	Иначе
		ОтборОрганизации = Неопределено;
	КонецЕсли;
	
	ОбменДаннымиСервер.ЗарегистрироватьДанныеПоДатеНачалаВыгрузкиИОрганизациям(Получатель,
		ЗначенияРеквизитов.ДатаНачалаВыгрузкиДокументов, ОтборОрганизации, Отбор);
	
КонецПроцедуры

#КонецОбласти

Процедура ПриИзмененииОбщихПараметров(ОбщиеПараметры, ИмяПараметра) Экспорт
	
	Если ИмяПараметра = "ТорговыйОбъект"
		И ЗначениеЗаполнено(ОбщиеПараметры.ТорговыйОбъект) Тогда
		ОбщиеПараметры.ВидЦен = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ОбщиеПараметры.ТорговыйОбъект.ПравилоЦенообразования, "ВидЦен");
	КонецЕсли;
	
КонецПроцедуры

Процедура ПланОбменаУРМК(ПланыОбменаXDTO) Экспорт
	ПланыОбменаXDTO.Добавить(Метаданные.ПланыОбмена.ОбменСУРМК);
КонецПроцедуры

Процедура ТорговыйОбъектУРМКПоУмолчанию(ТорговыйОбъект) Экспорт
	ТорговыйОбъект = ПараметрыСеанса.ТекущийМагазин;
КонецПроцедуры

// Устанавливает параметры выбора для касс ККМ.
//
// Параметры:
//  Форма - УправляемаяФорма - Форма, в которой нужно установить параметры выбора.
//  ИмяПоляВвода - Строка - Имя поля ввода номенклатуры.
Процедура УстановитьПараметрыВыбораКассыККМ(Форма, ИмяПоляВвода) Экспорт
	
	ПараметрыВыбора = ОбщегоНазначенияКлиентСервер.СкопироватьМассив(Форма.Элементы[ИмяПоляВвода].ПараметрыВыбора);
	
	НовыйПараметр = Новый ПараметрВыбора("Отбор.ТипКассы", Перечисления.ТипыКассККМ.ККМED);
	ПараметрыВыбора.Добавить(НовыйПараметр);
	
	Форма.Элементы[ИмяПоляВвода].ПараметрыВыбора = Новый ФиксированныйМассив(ПараметрыВыбора);
	
	СвязиПараметровВыбора = ОбщегоНазначенияКлиентСервер.СкопироватьМассив(Форма.Элементы[ИмяПоляВвода].СвязиПараметровВыбора);;
	
	НовыйПараметр = Новый СвязьПараметраВыбора("Отбор.Магазин", "Объект.ТорговыйОбъект", РежимИзмененияСвязанногоЗначения .НеИзменять);
	СвязиПараметровВыбора.Добавить(НовыйПараметр);
	
	Форма.Элементы[ИмяПоляВвода].СвязиПараметровВыбора = Новый ФиксированныйМассив(СвязиПараметровВыбора);

КонецПроцедуры

// Устанавливает параметры выбора для торгового объекта.
//
// Параметры:
//  Форма - УправляемаяФорма - Форма, в которой нужно установить параметры выбора.
//  ИмяПоляВвода - Строка - Имя поля ввода номенклатуры.
Процедура УстановитьПараметрыВыбораТорговыйОбъект(Форма, ИмяПоляВвода) Экспорт
	
	ПараметрыВыбора = ОбщегоНазначенияКлиентСервер.СкопироватьМассив(Форма.Элементы[ИмяПоляВвода].ПараметрыВыбора);
	
	НовыйПараметр = Новый ПараметрВыбора("Отбор.СкладУправляющейСистемы", Ложь);
	ПараметрыВыбора.Добавить(НовыйПараметр);
	
	Форма.Элементы[ИмяПоляВвода].ПараметрыВыбора = Новый ФиксированныйМассив(ПараметрыВыбора);
	
КонецПроцедуры

Процедура УстановитьОтборПоТипуКассыККМ(Список) Экспорт
	
	ГруппаОтбора = ОбщегоНазначенияКлиентСервер.СоздатьГруппуЭлементовОтбора(Список.КомпоновщикНастроек.ФиксированныеНастройки.Отбор.Элементы,,
	                                                                        ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИ);
	
	ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(
		ГруппаОтбора,
		"ТипКассы",
		ВидСравненияКомпоновкиДанных.Равно,
		ПредопределенноеЗначение("Перечисление.ТипыКассККМ.ККМED"),
		,
		Истина,
		РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный);
		
КонецПроцедуры

Функция ПараметрыЗаполненияПередНачаломДобавленияУРМК(Форма, СтруктураПараметров) Экспорт
	
	ПараметрыЗаполнения = Новый Структура;
	
	ПараметрыЗаполнения.Вставить("ТипКассы", ПредопределенноеЗначение("Перечисление.ТипыКассККМ.ККМED"));
	ПараметрыЗаполнения.Вставить("Магазин", Форма.ТорговыйОбъект);
	ПараметрыЗаполнения.Вставить("ТорговыйОбъект", Форма.ТорговыйОбъект);
	
	Если СтруктураПараметров.Свойство("ОбъектКопирования") Тогда
		Если ТипЗнч(СтруктураПараметров.ОбъектКопирования) = Тип("СправочникСсылка.КассыККМ") Тогда
			ПараметрыЗаполнения.Вставить("Владелец",
				ОбщегоНазначения.ЗначениеРеквизитаОбъекта(СтруктураПараметров.ОбъектКопирования, "Владелец"));
		КонецЕсли;
	КонецЕсли;
	
	Возврат ПараметрыЗаполнения;
	
КонецФункции

Функция ОтборыТекстаЗапросовПодготовитьДанныеНастроекОбмена() Экспорт
	
	ТекстЗапроса = "И КассыККМ.ТипКассы = ЗНАЧЕНИЕ(Перечисление.ТипыКассККМ.ККМED)";
	
	Возврат ТекстЗапроса;
	
КонецФункции