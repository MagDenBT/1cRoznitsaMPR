
#Область СлужебныйПрограммныйИнтерфейс

#Область ОбщиеНастройки

// Открывает форму настроек электронного документооборота.
// 
// Параметры:
// 	ПараметрыФормы - см. ОбщегоНазначенияБЭДКлиент.ОткрытьФормуБЭД.ПараметрыОткрытияФормы
// 	ПараметрыОткрытияФормы - см. ОбщегоНазначенияБЭДКлиент.ОткрытьФормуБЭД.ПараметрыОткрытияФормы
Процедура ОткрытьФормуНастроекЭДО(ПараметрыФормы = Неопределено, ПараметрыОткрытияФормы = Неопределено) Экспорт
	
	ОбщегоНазначенияБЭДКлиент.ОткрытьФормуБЭД("Обработка.НастройкиЭДО.Форма.НастройкиЭДО", ПараметрыФормы,
		ПараметрыОткрытияФормы);
	
КонецПроцедуры

// Возвращает параметры формы настроек ЭДО, см. ОткрытьФормуНастроекЭДО.
// 
// Параметры:
// 	Параметры
// Возвращаемое значение:
// 	Структура:
// * Источник - ЛюбаяСсылка - ссылка на объект, из которого открывается форма
Функция НовыеПараметрыОткрытияФормыНастроекЭДО() Экспорт
	
	Параметры = Новый Структура;
	Параметры.Вставить("Источник");
	
	Возврат Параметры;
	
КонецФункции

Процедура ОжидатьЗавершенияВыполненияДействийПередИзменениемИспользованияУтверждения(ДлительнаяОперация, Оповещение) Экспорт
	
	ПараметрыОжидания = ДлительныеОперацииКлиент.ПараметрыОжидания(Неопределено);
	ПараметрыОжидания.ВыводитьОкноОжидания = Истина;
	ПараметрыОжидания.ТекстСообщения = НСтр("ru='Выполняется изменение опции ""Отправлять входящие документы на утверждение"".'");
	
	Контекст = Новый Структура;
	Контекст.Вставить("Оповещение", Оповещение);
	СлужебноеОповещение = Новый ОписаниеОповещения("ПослеВыполненияДействийПередИзменениемИспользованияУтверждения",
		НастройкиЭДОСлужебныйКлиент, Контекст);
	
	ДлительныеОперацииКлиент.ОжидатьЗавершение(ДлительнаяОперация, СлужебноеОповещение, ПараметрыОжидания);
	
КонецПроцедуры

#КонецОбласти

#Область НастройкиОтправки

// см. НастройкиЭДОСлужебныйВызовСервера.НастройкиОтправки
// 
// Параметры:
// 	КлючНастроекОтправки - см. НастройкиЭДОКлиентСервер.НовыйКлючНастроекОтправки
// Возвращаемое значение:
// 	см. НастройкиЭДОСлужебныйВызовСервера.НастройкиОтправки
Функция НастройкиОтправки(КлючНастроекОтправки) Экспорт
	
	Возврат НастройкиЭДОСлужебныйВызовСервера.НастройкиОтправки(КлючНастроекОтправки);
	
КонецФункции

// Выполняет настройку обмена с контрагентом.
// 
// Параметры:
// 	КлючНастроек - см. НастройкиЭДОКлиентСервер.НовыйКлючНастроекОтправки
// 	Оповещение - ОписаниеОповещения - содержит описание процедуры, которая будет вызвана
//               после завершения настройки со следующими параметрами:
//    * Настройка - Неопределено
//                - см. НастройкиЭДОКлиентСервер.НоваяНастройкаОтправки.
//    * ДополнительныеПараметры - Произвольный - значение, которое было указано при создании объекта ОписаниеОповещения.
// 	ПараметрыНастройки - см. НовыеПараметрыНастройкиОбменаСКонтрагентом
Процедура НастроитьОбменСКонтрагентом(КлючНастроек, Оповещение = Неопределено, ПараметрыНастройки = Неопределено) Экспорт
	
	Если ПараметрыНастройки = Неопределено Тогда
		ПараметрыНастройки = НовыеПараметрыНастройкиОбменаСКонтрагентом();
	КонецЕсли;
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("КлючНастроек",       КлючНастроек);
	ПараметрыФормы.Вставить("НастройкаДокумента", ПараметрыНастройки.НастройкаОдногоДокумента);

	ОткрытьФорму("Обработка.НастройкиЭДО.Форма.НастройкаОбменаСКонтрагентом", ПараметрыФормы, , , , ,
		Оповещение, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

// Возвращает параметры настройки, см. НастроитьОбменСКонтрагентом.
// 
// Возвращаемое значение:
// 	Структура:
//   * НастройкаОдногоДокумента - Булево - если Истина, мастер будет открыт в режиме настройки одного документа
//                                         (по умолчанию настройки не будут сохраняться, сохранение будет зависеть
//                                        от флага "Использовать эти настройки для последующих документов по контрагенту").
Функция НовыеПараметрыНастройкиОбменаСКонтрагентом()
	
	Параметры = Новый Структура;
	Параметры.Вставить("НастройкаОдногоДокумента", Ложь);
	
	Возврат Параметры;
	
КонецФункции

// Открывает форму настройки заполнения дополнительных полей.
// 
// Параметры:
// 	ПараметрОткрытия - см. НастройкиЭДОКлиентСервер.НовыйКлючНастроекОтправки
// 	                   см. НастройкиЭДОКлиентСервер.НоваяНастройкаОтправки
// 	Оповещение - ОписаниеОповещения
Процедура ОткрытьНастройкиЗаполненияДополнительныхПолей(ПараметрОткрытия, Оповещение = Неопределено) Экспорт
	
	НастройкиОтправкиЭДОКлиент.ОткрытьНастройкиЗаполненияДополнительныхПолей(ПараметрОткрытия, Оповещение);
	
КонецПроцедуры

// Открывает форму настроек отправки электронных документов.
// 
// Параметры:
// 	КлючНастроекОтправки - см. НастройкиЭДОКлиентСервер.НовыйКлючНастроекОтправки
// 	ПараметрыОткрытия - см. ОбщегоНазначенияБЭДКлиент.ОткрытьФормуБЭД.ПараметрыОткрытияФормы
Процедура ОткрытьНастройкуОтправки(КлючНастроекОтправки, ПараметрыОткрытия = Неопределено) Экспорт
	
	ПараметрыФормы = НастройкиОтправкиЭДОКлиент.НовыеПараметрыФормыНастроекОтправки();
	ПараметрыФормы.КлючНастроекОтправки = КлючНастроекОтправки;
	НастройкиОтправкиЭДОКлиент.ОткрытьНастройкуОтправки(ПараметрыФормы, ПараметрыОткрытия);
	
КонецПроцедуры

// Открывает форму списка настроек отправки электронных документов.
// 
// Параметры:
// 	Контрагент - ОпределяемыйТип.КонтрагентБЭД
Процедура ОткрытьНастройкиОтправки(Контрагент) Экспорт
	
	НастройкиОтправкиЭДОКлиент.ОткрытьНастройкиОтправки(Контрагент);
	
КонецПроцедуры

// Открывает форму списка настроек интеркампани.
//
// Параметры:
//  Организация -ОпределяемыйТип.ОрганизацияБЭД - Организация
Процедура ОткрытьНастройкиИнтеркампани(Организация) Экспорт
	
	НастройкиОтправкиЭДОКлиент.ОткрытьНастройкиИнтеркампани(Организация);
		
КонецПроцедуры

// Открывает форму настройки отправки по договору, а если настроек нет - форму списка настроек.
//
// Параметры:
//  Договор - ОпределяемыйТип.ДоговорыКонтрагентов - Договор
Процедура ОткрытьНастройкиОтправкиПоДоговору(Договор) Экспорт
	
	НастройкиОтправкиЭДОКлиент.ОткрытьНастройкиОтправкиПоДоговору(Договор);
	
КонецПроцедуры

// Показывает вопрос об отключении ожидания ответной подписи.
// 
// Параметры:
// 	Оповещение - ОписаниеОповещения
Процедура ЗапроситьПодтверждениеОтключенияОжиданияОтветнойПодписи(Оповещение) Экспорт
	
	ТекстВопроса = НСтр("ru = 'Отказ от ответной подписи разрешается, если:
		|- документ выписан на оказание услуг, по которым ГК РФ не требует актирования;
		|- в соглашении об обмене электронными документами предусмотрено отсутствие ответной подписи для данного вида документа.
		|
		|Если документ Не соответствует перечисленным критериям, отказ от ожидания ответной подписи может привести к тому, что документ будет признан недействительным.
		|
		|Вы действительно хотите отказаться от ожидания ответной подписи?'");
	
	ПоказатьВопрос(Оповещение, ТекстВопроса, РежимДиалогаВопрос.ДаНет);
	
КонецПроцедуры

// См. НастройкиОтправкиЭДОКлиент.ОткрытьТранспортныеНастройкиОтправки
Процедура ОткрытьТранспортныеНастройкиОтправки(ПараметрыВыбора, Владелец = Неопределено, Оповещение = Неопределено,
	Настройки = Неопределено) Экспорт
	
	НастройкиОтправкиЭДОКлиент.ОткрытьТранспортныеНастройкиОтправки(ПараметрыВыбора, Владелец, Оповещение,
		Настройки);
	
КонецПроцедуры

// См. НастройкиОтправкиЭДОКлиент.НовыеПараметрыТранспортныхНастроек
Функция НовыеПараметрыТранспортныхНастроек() Экспорт
	
	Возврат НастройкиОтправкиЭДОКлиент.НовыеПараметрыТранспортныхНастроек();
	
КонецФункции

// См. НастройкиОтправкиЭДОКлиент.НастроитьРегламентЭДО
Процедура НастроитьРегламентЭДО(КлючНастроек, Владелец, Оповещение = Неопределено,
	НастройкаДокумента = Ложь, Настройки = Неопределено) Экспорт
	
	НастройкиОтправкиЭДОКлиент.НастроитьРегламентЭДО(КлючНастроек, Владелец, Оповещение, НастройкаДокумента, Настройки);
	
КонецПроцедуры

#КонецОбласти

#Область НастройкиОтраженияВУчете

// Открывает форму настроек отражения в учете электронных документов.
// 
// Параметры:
// 	КлючНастроек - см. НастройкиЭДОКлиентСервер.НовыйКлючНастроекОтраженияВУчете
Процедура ОткрытьНастройкуОтраженияВУчете(КлючНастроек) Экспорт
	
	ПараметрыФормы = НастройкиОтраженияВУчетеЭДОКлиент.НовыеПараметрыФормыНастройкиОтраженияВУчете();
	ПараметрыФормы.Организация = КлючНастроек.Получатель;
	ПараметрыФормы.Контрагент = КлючНастроек.Отправитель;
	ПараметрыФормы.ИдентификаторОрганизации = КлючНастроек.ИдентификаторПолучателя;
	ПараметрыФормы.ИдентификаторКонтрагента = КлючНастроек.ИдентификаторОтправителя;
	НастройкиОтраженияВУчетеЭДОКлиент.ОткрытьНастройкуОтраженияВУчете(ПараметрыФормы);
	
КонецПроцедуры

// Открывает форму списка настроек отражения в учете.
// 
// Параметры:
// 	Контрагент - ОпределяемыйТип.КонтрагентБЭД
Процедура ОткрытьНастройкиОтраженияВУчете(Контрагент) Экспорт
	
	НастройкиОтраженияВУчетеЭДОКлиент.ОткрытьНастройкиОтраженияВУчете(Контрагент);
	
КонецПроцедуры

#КонецОбласти

#Область НастройкиВнутреннегоЭДО

// Открывает форму настройки внутреннего электронного документооборота.
// 
// Параметры:
// 	Организация - ОпределяемыйТип.Организация
Процедура ОткрытьНастройкиВнутреннегоЭлектронногоДокументооборота(Организация) Экспорт 
	
	НастройкиВнутреннегоЭДОКлиент.ОткрытьНастройкуВнутреннегоЭлектронногоДокументооборота(Организация);
	
КонецПроцедуры

// Открывает мастер настройки внутреннего электронного документооборота.
//
// Параметры:
//  Организация                - ОпределяемыйТип.Организация
//  ВидВнутреннегоДокумента    - СправочникСсылка.ВидыВнутреннихДокументовЭДО
//                             - См. НовоеОписаниеВидаВнутреннегоДокумента
//  ОповещениеОЗавершении      - ОписаниеОповещения - содержит описание процедуры, которая будет выполнена
//                             после завершения настройки со следующими параметрами:
//                               * Результат - Неопределено - форма была закрыта без завершения настройки.
//                                           - Структура:
//                                  ** - КлючНастройки - Структура:
//                                        ***  - Организация - ОпределяемыйТип.Организация
//                                        ***  - ВидВнутреннегоДокумента - СправочникСсылка.ВидыВнутреннихДокументовЭДО
//                                  ** - ВидЭлектроннойПодписи - ПеречислениеСсылка.ВидыЭлектронныхПодписей
//                                  ** - Маршрут - СправочникСсылка.МаршрутыПодписания
//                                  ** - Подписанты - Массив из СправочникСсылка.Пользователи
//                               * - ДополнительныеПараметры - Произвольный - значение, которое было указано 
//                                                при создании объекта ОписаниеОповещения.
//
Процедура НастроитьВнутреннийЭлектронныйДокументооборот(Организация, ВидВнутреннегоДокумента,
	ОповещениеОЗавершении = Неопределено) Экспорт
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Организация", Организация);
	ПараметрыФормы.Вставить("ВидВнутреннегоДокумента", ВидВнутреннегоДокумента);
	ОткрытьФорму("Обработка.НастройкиВнутреннегоЭДО.Форма.МастерНастройкиВнутреннегоДокументооборота",
		ПараметрыФормы,,,,, ОповещениеОЗавершении, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

// Возвращает описание вида внутреннего документа, см. НастроитьВнутреннийЭлектронныйДокументооборот.
// 
// Возвращаемое значение:
//  Структура:
//   * ОбъектУчета - ОпределяемыйТип.ОснованияЭлектронныхДокументовЭДО - (обязательный) - ссылка на объект учета
//                 - СправочникСсылка.ИдентификаторыОбъектовМетаданных - (обязательный) - идентификатор объекта учета
//   * ИдентификаторКомандыПечати - Строка - (необязательный)
Функция НовоеОписаниеВидаВнутреннегоДокумента() Экспорт
	
	Описание = Новый Структура;
	Описание.Вставить("ОбъектУчета", Неопределено);
	Описание.Вставить("ИдентификаторКомандыПечати", Неопределено);
	
	Возврат Описание;
	
КонецФункции

#КонецОбласти

#Область ДляВызоваИзДругихПодсистем

// ЭлектронноеВзаимодействие.БазоваяФункциональность.ОбработкаНеисправностей

Процедура ВключитьИспользованиеОбменаЭД(КонтекстДиагностики, ДополнительныеПараметры) Экспорт
	
	НастройкиЭДОСлужебныйВызовСервера.ВключитьИспользованиеОбменаЭД();
	
	ВидыОшибок = ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(
		НастройкиЭДОКлиентСервер.ВидОшибкиНеВключеноИспользованиеОбменаЭД());
	ОбработкаНеисправностейБЭДКлиент.ОповеститьОбИсправленииОшибок(ВидыОшибок);
	
КонецПроцедуры

// Конец ЭлектронноеВзаимодействие.БазоваяФункциональность.ОбработкаНеисправностей

#КонецОбласти

#КонецОбласти