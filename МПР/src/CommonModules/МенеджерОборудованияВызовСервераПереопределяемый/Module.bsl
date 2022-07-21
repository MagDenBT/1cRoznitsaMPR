#Область ПрограммныйИнтерфейс

// Возвращает список доступных типов оборудования.
// 
// Параметры:
//   СписокТиповОборудования - Массив - Массив доступных типов подключаемого оборудования в конфигурации.
//   СтандартнаяОбработка - Булево - признак выполнения стандартной обработки,
// Пример:
//   СписокТиповОборудования.Добавить(Перечисления.ТипыПодключаемогоОборудования.ККТ).
//
Процедура ДоступныеТипыОборудования(СписокТиповОборудования, СтандартнаяОбработка) Экспорт

	// Сканеры штрихкода
	СписокТиповОборудования.Добавить(Перечисления.ТипыПодключаемогоОборудования.СканерШтрихкода);
	// Конец Сканеры штрихкода

	// Считыватели магнитных карт
	СписокТиповОборудования.Добавить(Перечисления.ТипыПодключаемогоОборудования.СчитывательМагнитныхКарт);
	// Конец Считыватели магнитных карт.

	// Считыватели RFID
	СписокТиповОборудования.Добавить(Перечисления.ТипыПодключаемогоОборудования.СчитывательRFID);
	// Конец Считыватели RFID.
	
	// ККТ с передачей данных ОФД
	СписокТиповОборудования.Добавить(Перечисления.ТипыПодключаемогоОборудования.ККТ);
	// Конец ККТ с передачей данных ОФД.
	
	// Принтеры чеков
	СписокТиповОборудования.Добавить(Перечисления.ТипыПодключаемогоОборудования.ПринтерЧеков);
	// Конец принтеры чеков.
	
	// Дисплеи покупателя
	СписокТиповОборудования.Добавить(Перечисления.ТипыПодключаемогоОборудования.ДисплейПокупателя);
	// Конец Дисплеи покупателя

	// Терминалы сбора данных
	СписокТиповОборудования.Добавить(Перечисления.ТипыПодключаемогоОборудования.ТерминалСбораДанных);
	// Конец Терминалы сбора данных.

	// Эквайринговые терминалы
	СписокТиповОборудования.Добавить(Перечисления.ТипыПодключаемогоОборудования.ЭквайринговыйТерминал);
	// Конец Эквайринговые терминалы.
	
	// Электронные весы
	СписокТиповОборудования.Добавить(Перечисления.ТипыПодключаемогоОборудования.ЭлектронныеВесы);
	// Конец Электронные весы
	
	Если ОбщегоНазначенияРТ.ИспользоватьПодключаемоеОборудованиеOffline() Тогда
		
		// Весы с печатью этикеток
		СписокТиповОборудования.Добавить(Перечисления.ТипыПодключаемогоОборудования.ВесыСПечатьюЭтикеток);
		// Конец Весы с печатью этикеток.
		
	КонецЕсли;
	
	// Принтер этикеток
	СписокТиповОборудования.Добавить(Перечисления.ТипыПодключаемогоОборудования.ПринтерЭтикеток);
	// Конец Принтер этикеток
	
	СтандартнаяОбработка = Ложь;
	
КонецПроцедуры

// Возвращает флаг возможности добавления новых драйверов оборудования в справочник.
// Параметры:
//   ДобавлениеНовыхДрайверовДоступно - Булево - флаг возможности добавления новых компонент подключения оборудования.
//   СтандартнаяОбработка - Булево - признак выполнения стандартной обработки,
// Пример:
//   ДобавлениеНовыхДрайверовДоступно = Ложь;
//   СтандартнаяОбработка = Ложь. 
//
Процедура ДоступноДобавлениеНовыхДрайверов(ДобавлениеНовыхДрайверовДоступно, СтандартнаяОбработка) Экспорт
	
КонецПроцедуры

// Возвращает доступность сетевого оборудования.
//
// Параметры:
//  СетевоеОборудованиеДоступно - Булево - Сетевое оборудование доступно.
//  СтандартнаяОбработка - Булево - Стандартная обработка.
//
Процедура ДоступноСетевоеОборудование(СетевоеОборудованиеДоступно, СтандартнаяОбработка) Экспорт
	
	СетевоеОборудованиеДоступно = Истина;
	СтандартнаяОбработка = Ложь;
	
КонецПроцедуры

// Возвращает доступность распределенной фискализации.
//  
// Параметры:
//  РаспределеннаяФискализацииДоступна - Булево - Доступность распределенной фискализации.
//  СтандартнаяОбработка - Булево - Стандартная обработка.
//
Процедура ДоступноРаспределеннаяФискализация(РаспределеннаяФискализацииДоступна, СтандартнаяОбработка) Экспорт
	
	РаспределеннаяФискализацииДоступна = Константы.ИспользоватьРаспределеннуюФискализацию.Получить();
	СтандартнаяОбработка = Ложь;
	
КонецПроцедуры

// Возвращает доступнось инкасации в форме управление фискальным устройством.
//  
// Параметры:
//  ИнкасацияДоступна - Булево - Доступность инкасации.
//  СтандартнаяОбработка - Булево - Стандартная обработка.
//
Процедура ДоступноИнкасацияВУправлениеФискальнымУстройством(ИнкасацияДоступна, СтандартнаяОбработка) Экспорт
	
КонецПроцедуры

// Переопределяемая процедура для подсистемы управление доступом СтандартныеПодсистемы
// См. УправлениеДоступомПереопределяемый.ПриЗаполненииСписковСОграничениемДоступа.
//
// Параметры:
//  Менеджер - Строка 
//  Ограничение - Структура:
//    * Текст                             - Строка - ограничение доступа для пользователей.
//                                          Если пустая строка, значит, доступ разрешен.
//    * ТекстДляВнешнихПользователей      - Строка - ограничение доступа для внешних пользователей.
//                                          Если пустая строка, значит, доступ запрещен.
//    * ПоВладельцуБезЗаписиКлючейДоступа - Неопределено - определить автоматически.
//                                        - Булево - если Ложь, то всегда записывать ключи доступа,
//                                          если Истина, тогда не записывать ключи доступа,
//                                          а использовать ключи доступа владельца (требуется,
//                                          чтобы ограничение было строго по объекту-владельцу).
//   * ПоВладельцуБезЗаписиКлючейДоступаДляВнешнихПользователей - Неопределено, Булево - также
//                                          как у параметра ПоВладельцуБезЗаписиКлючейДоступа.
//
Процедура ПриЗаполненииОграниченияДоступа(Менеджер, Ограничение) Экспорт
	
КонецПроцедуры

#Область Обновление

// Переопределяемая часть процедуры обновления с БПО 3
//  
// Параметры:
//  СсылкаПодключаемоеОборудование - СправочникСсылка.ПодключаемоеОборудование - оборудование для обновления перехода с БПО 3
//
Процедура ОбновитьСправочникПодключаемогоОборудования(СсылкаПодключаемоеОборудование) Экспорт
	
КонецПроцедуры

#КонецОбласти

#Область ОборудованиеККТ

// Процедура заполняет реквизиты организации для регистрации ФН.
//
// Параметры:
//  Организация - ОпределяемыйТип.ОрганизацияБПО - организация для заполнения реквизитов.
//  ПараметрыРегистрации - Структура - параметры регистрации ФН.
//
Процедура ЗаполнитьРеквизитыОрганизацииДляРегистрацииФН(Организация, ПараметрыРегистрации) Экспорт
	
	ПараметрыРегистрации.ОрганизацияИНН = Организация.ИНН;  
	ПараметрыРегистрации.ОрганизацияНазвание = ?(НЕ ПустаяСтрока(Организация.НаименованиеСокращенное), Организация.НаименованиеСокращенное, Организация.Наименование);
	
КонецПроцедуры

// Переопределяет формируемый шаблон чека.
//
// Параметры:
//  ОбщиеПараметры - Структура - см.ОборудованиеЧекопечатающиеУстройстваКлиентСервер.ПараметрыОперацииФискализацииЧека().
//  ДополнительныйТекст - Строка - дополнительный текст шаблона чека.
//  СтандартнаяОбработка - Булево - признак стандартной обработки.
//  ТипОборудования - Строка - типы оборудования строкой.
//
// Возвращаемое Значение:
//  Булево
Функция СформироватьШаблонЧека(ОбщиеПараметры, ДополнительныйТекст, СтандартнаяОбработка, ТипОборудования = "") Экспорт
	
	Если ОбщиеПараметры.Свойство("ШаблонЧека")
		И ОбщиеПараметры.Свойство("КассаККМ")
		И ЗначениеЗаполнено(ОбщиеПараметры.ШаблонЧека)
		И ЗначениеЗаполнено(ОбщиеПараметры.КассаККМ) Тогда
		
		ШаблонЧека = ПодключаемоеОборудованиеРТ.ПолучитьСтруктуруШаблонаЧека(ОбщиеПараметры, ДополнительныйТекст, ТипОборудования);
		Если ШаблонЧека <> Неопределено Тогда
			СтандартнаяОбработка = Ложь;
			Возврат ШаблонЧека;
		КонецЕсли;
	Иначе
		Возврат Неопределено;
	КонецЕсли;
	
КонецФункции

// Переопределяет доступное ККТ для фискализации чека
//
// Параметры:
//  РеквизитыЧека - Структура - реквизиты фискального чека
//  СписокУстройств - Массив - Список доступных ККТ для фискализации
//  ИдентификаторУстройстваККТ - СправочникСсылка.ПодключаемоеОборудование - выбранное ККТ для фискализации
//
Процедура ДоступноеККТДляФискализации(РеквизитыЧека, СписокУстройств, ИдентификаторУстройстваККТ) Экспорт

КонецПроцедуры

// Возвращает для каких типов идентификаторов будет заполняться тег 1162 (код товара).
//
// Параметры:
//  ТипыИдентификаторов - Массив - Типы идентификаторов, Массив значений  Перечисления.ТипыИдентификаторовТовараККТ.
//  СтандартнаяОбработка - Булево - Стандартная обработка
//
Процедура КодТовараЗаполняетсяДляТиповИдентификаторов(ТипыИдентификаторов, СтандартнаяОбработка) Экспорт
	
КонецПроцедуры

// Ведется учет ИСМП в конфигурации
// Параметры:
//  УчетПродукцииИСМП - Булево - Ведется учет ИСМП в конфигурации 
//  СтандартнаяОбработка - Булево - Выполнение стандартной обработки
//
Процедура ВедетсяУчетПродукцииИСМП(УчетПродукцииИСМП, СтандартнаяОбработка) Экспорт

КонецПроцедуры

// Процедура где можно добавить любой текст приформировании чека в формате PDF.
//
// Параметры:
//   ТекстЗаголовка - Строка - Текст который будет выведен при формировании кассового чека в формате PDF
//   ТекстПодвала - Строка - Текст который будет выведен при формировании кассового чека в формате PDF
Процедура ДополнительныйТекстПриФормированииЧекаPDF(ТекстЗаголовка, ТекстПодвала) Экспорт
	
КонецПроцедуры

#КонецОбласти

#Область РаботаСЭлементомФормы

// Дополнительные переопределяемые действия с элементом формы 
// служит для учета специфики визуального отображения в зависимости от типа клиента.
//
// Параметры:
//  ЭлементУправления - ЭлементУправленияИнтерфейсом - элемент управления.
//  СтандартнаяОбработка - Булево - Стандартная обработка.
//
Процедура ПодготовитьЭлементУправления(ЭлементУправления, СтандартнаяОбработка) Экспорт
	
КонецПроцедуры

#КонецОбласти

#Область РаботаСФормойЭкземпляраОборудования

// Дополнительные переопределяемые действия с управляемой формой в Экземпляре оборудования
// при событии "ПриСозданииНаСервере".
//
// Параметры:
//  Объект - СправочникОбъект.ПодключаемоеОборудование - Объект подключаемого оборудования.
//  ЭтаФорма - ФормаКлиентскогоПриложения - Форма настройки оборудования
//  Отказ - Булево - Отказ создания
//  Параметры - Структура - Параметры операции
//  СтандартнаяОбработка - Булево - Стандартная обработка
//
Процедура ЭкземплярОборудованияПриСозданииНаСервере(Объект, ЭтаФорма, Отказ, Параметры, СтандартнаяОбработка) Экспорт
	
	Элемент = ЭтаФорма.Элементы.Добавить("ПравилоОбмена", Тип("ПолеФормы"), );
	Элемент.Вид = ВидПоляФормы.ПолеВвода;
	Элемент.ПутьКДанным = "Объект.ПравилоОбмена";
	
	// Доступ к узлу есть только для соответствующего оборудования.
	Если Объект.ТипОборудования = Перечисления.ТипыПодключаемогоОборудования.ВесыСПечатьюЭтикеток Тогда
		ЭтаФорма.Элементы.ПравилоОбмена.Видимость = Истина;
		ПараметрыВыбораПравилаОбмена = ПодключаемоеОборудованиеOfflineВызовСервера.ПолучитьПараметрыВыбораПравилаОбмена(Объект);
		Если ЗначениеЗаполнено(ПараметрыВыбораПравилаОбмена) Тогда
			ЭтаФорма.Элементы.ПравилоОбмена.ПараметрыВыбора = ПараметрыВыбораПравилаОбмена;
		КонецЕсли;
	Иначе
		ЭтаФорма.Элементы.ПравилоОбмена.Видимость = Ложь;
	КонецЕсли;
	
КонецПроцедуры

// Дополнительные переопределяемые действия с управляемой формой в Экземпляре оборудования
// при событии "ПриЧтенииНаСервере".
//
// Параметры:
//  ТекущийОбъект - СправочникОбъект.ПодключаемоеОборудование - Объект подключаемого оборудования.
//  ЭтаФорма - ФормаКлиентскогоПриложения - Форма настройки оборудования
//
Процедура ЭкземплярОборудованияПриЧтенииНаСервере(ТекущийОбъект, ЭтаФорма) Экспорт

КонецПроцедуры

// Дополнительные переопределяемые действия с управляемой формой в Экземпляре оборудования
// при событии "ПередЗаписьюНаСервере".
//
// Параметры:
//  Отказ - Булево - Отказ операции
//  ТекущийОбъект - СправочникОбъект.ПодключаемоеОборудование - Объект подключаемого оборудования.
//  ПараметрыЗаписи - Структура - Параметры операции
//
Процедура ЭкземплярОборудованияПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи) Экспорт

КонецПроцедуры

// Дополнительные переопределяемые действия с управляемой формой в Экземпляре оборудования
// при событии "ПриЗаписиНаСервере".
//
// Параметры:
//  Отказ - Булево - Отказ операции
//  ТекущийОбъект - СправочникОбъект.ПодключаемоеОборудование - Объект подключаемого оборудования.
//  ПараметрыЗаписи - Структура - Параметры операции
//
Процедура ЭкземплярОборудованияПриЗаписиНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи) Экспорт

КонецПроцедуры

// Дополнительные переопределяемые действия с управляемой формой в Экземпляре оборудования
// при событии "ПослеЗаписиНаСервере".
//
// Параметры:
//  ТекущийОбъект - СправочникОбъект.ПодключаемоеОборудование - Объект подключаемого оборудования.
//  ПараметрыЗаписи - Структура - Параметры операции
//
Процедура ЭкземплярОборудованияПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи) Экспорт

КонецПроцедуры

// Дополнительные переопределяемые действия с управляемой формой в Экземпляре оборудования
// при событии "ОбработкаПроверкиЗаполненияНаСервере".
//
// Параметры:
//  Объект - СправочникОбъект.ПодключаемоеОборудование - Объект подключаемого оборудования.
//  ЭтаФорма - ФормаКлиентскогоПриложения - Форма настройки оборудования
//  Отказ - Булево - Отказ создания
//  ПроверяемыеРеквизиты - Структура - Проверяемые реквизиты
//
Процедура ЭкземплярОборудованияОбработкаПроверкиЗаполненияНаСервере(Объект, ЭтаФорма, Отказ, ПроверяемыеРеквизиты) Экспорт

КонецПроцедуры

#КонецОбласти

#Область РаботаСФормойЭкземпляраФискальныеОперации

// Дополнительные переопределяемые действия с управляемой формой в Экземпляре Фискальные операции
// при событии "ПриСозданииНаСервере".
//
// Параметры:
//  Запись - РегистрСведенийЗапись.ФискальныеОперации - Запись фискальные операции.
//  ЭтаФорма - ФормаКлиентскогоПриложения - Форма настройки оборудования
//  Отказ - Булево - Отказ создания
//  Параметры - Структура - Параметры операции
//  СтандартнаяОбработка - Булево - Стандартная обработка
//
Процедура ЭкземплярФискальныеОперацииПриСозданииНаСервере(Запись, ЭтаФорма, Отказ, Параметры, СтандартнаяОбработка) Экспорт

КонецПроцедуры

#КонецОбласти

#Область РаботаСФормойСпискаФискальныеОперации

// Дополнительные переопределяемые действия с управляемой формой в Список Фискальные операции
// при событии "ПриСозданииНаСервере".
//
// Параметры:
//  ЭтаФорма - ФормаКлиентскогоПриложения - Форма настройки оборудования
//  Отказ - Булево - Отказ создания
//  Параметры - Структура - Параметры операции
//  СтандартнаяОбработка - Булево - Стандартная обработка
//
Процедура СписокФискальныеОперацииПриСозданииНаСервере(ЭтаФорма, Отказ, Параметры, СтандартнаяОбработка) Экспорт

КонецПроцедуры

#КонецОбласти

#Область ОчередьФискальныхЧеков

// Завершение фискализация чека в очереди
//
// Параметры:
//  ИдентификаторФискальнойЗаписи - Строка - Идентификатор фискальной записи
//  ПараметрыФискализации - Структура - Параметры операции
//  ОборудованиеККТ - СправочникСсылка.ПодключаемоеОборудование -
//  РезультатФискализации - Структура - Результат Фискализации
//
Процедура ФискализацияЧекаВОчереди(ИдентификаторФискальнойЗаписи, ПараметрыФискализации, ОборудованиеККТ, РезультатФискализации) Экспорт
	
	ОбщегоНазначенияРМКПереопределяемый.ФискализироватьЧекЗавершение(РезультатФискализации, ПараметрыФискализации);
	
КонецПроцедуры

// Завершение фискализация чека в очереди
//
// Параметры:
//  РеквизитыЧека - Структура - Данные документа основания.
//  СтатусДокументаИзменен - Булево - признак изменения статуса документа.
//
Процедура ПроверитьСтатусДокументаОснования(РеквизитыЧека, СтатусДокументаИзменен) Экспорт
	
	СтатусДокументаИзменен = Ложь;
	
	Если ТипЗнч(РеквизитыЧека.ДокументОснование) = Тип("ДокументСсылка.ЧекККМ") Тогда
		
		СтатусДокумента = РеквизитыЧека.ДокументОснование.СтатусЧекаККМ;
		
		Если СтатусДокумента = Перечисления.СтатусыЧековККМ.Аннулированный Или СтатусДокумента = Перечисления.СтатусыЧековККМ.Пробитый Тогда
			
			НаборЗаписей = РегистрыСведений.ОчередьЧековККТ.СоздатьНаборЗаписей();
			НаборЗаписей.Отбор.ДокументОснование.Установить(РеквизитыЧека.ДокументОснование, Истина);
			НаборЗаписей.Прочитать();
			
			Для Каждого НоваяСтрока из НаборЗаписей Цикл
				НоваяСтрока.СтатусЧека  = Перечисления.СтатусЧекаККТВОчереди.Фискализирован;
				СтатусДокументаИзменен = Истина;
			КонецЦикла;
			
			НаборЗаписей.Записать();
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

// Обработчик события заполнения персональных данных.
//
// Параметры:
//  ПерсональныеДанные - Структура - Возвращаемый параметр, персональные данные.
//  СубъектПерсональныхДанных - ОпределяемыйТип.СубъектПерсональныхДанныхБПО - субъект персональных данных. 
//  ТипПерсональныхДанных - ПеречислениеСсылка.ТипыПерсональныхДанныхККТ - Тип персональных данных
//  НаДату - Дата - Дата, на которую необходимо получать персональные данные
//
Процедура ОбработкаЗаполненияПерсональныхДанных(ПерсональныеДанные, СубъектПерсональныхДанных, ТипПерсональныхДанных, НаДату) Экспорт
	
	Документ = РегистрыСведений.ДокументыФизическихЛиц.ДанныеДокументаФизлица(СубъектПерсональныхДанных);
	
	ПерсональныеДанные.ДатаРождения = СубъектПерсональныхДанных.ДатаРождения;
	ПерсональныеДанные.Гражданство = Документ.Гражданство.Код;
	Если Документ.ВидДокумента = ПредопределенноеЗначение("Справочник.ВидыДокументовФизическихЛиц.ПаспортРФ") Тогда
		ПерсональныеДанные.ВидДокумента = Перечисления.ВидДокументаУдостоверяющегоЛичностьККТ.ПаспортГражданинаРФ;
	ИначеЕсли Документ.ВидДокумента = ПредопределенноеЗначение("Справочник.ВидыДокументовФизическихЛиц.ЗагранпаспортРФ") Тогда
		ПерсональныеДанные.ВидДокумента = Перечисления.ВидДокументаУдостоверяющегоЛичностьККТ.ПаспортГражданинаРФЗаПределамиРФ;
	ИначеЕсли Документ.ВидДокумента = ПредопределенноеЗначение("Справочник.ВидыДокументовФизическихЛиц.ЗагранпаспортРФ") Тогда
		ПерсональныеДанные.ВидДокумента = Перечисления.ВидДокументаУдостоверяющегоЛичностьККТ.ПаспортГражданинаРФЗаПределамиРФ;
	Иначе
		Если Документ.Гражданство.Код = 643 И Документ.ЯвляетсяДокументомУдостоверяющимЛичность Тогда
			ПерсональныеДанные.ВидДокумента = Перечисления.ВидДокументаУдостоверяющегоЛичностьККТ.ИныеДокументыУдостоверяющиеЛичностьГражданинаРФ;
		Иначе
			ПерсональныеДанные.ВидДокумента = Перечисления.ВидДокументаУдостоверяющегоЛичностьККТ.ИныеДокументыУдостоверяющимиЛичностьИностранногоГражданина;
		КонецЕсли;
	КонецЕсли;
	ПерсональныеДанные.ДанныеДокумента = СокрЛП(Документ.Серия) + " " + СокрЛП(Документ.Номер);
	
КонецПроцедуры

#КонецОбласти