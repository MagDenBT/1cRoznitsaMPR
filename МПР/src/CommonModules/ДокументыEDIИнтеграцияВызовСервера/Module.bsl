
#Область СлужебныйПрограммныйИнтерфейс

Функция МассивХэшСуммИдентификаторовТиповДокументовИСтатусов(ИдентификаторыТиповДокументов, Статусы) Экспорт
	
	Возврат ДокументыEDI.МассивХэшСуммИдентификаторовТиповДокументовИСтатусов(ИдентификаторыТиповДокументов, Статусы);
	
КонецФункции

#Область КлиентскаяБиблиотека

#Область ПроверкаПодключенияКСервису

Процедура ОпределитьДанныеОрганизации(Организация, ДанныеОрганизации) Экспорт 
	
	ДанныеОрганизации.ОрганизацияПодключена                    = БизнесСеть.ОрганизацияПодключена(Организация);
	ДанныеОрганизации.ОтправлятьЗаказыПоставщикам              = 
		РегистрыСведений.НастройкиИнтеграцииEDI.ОтправлятьЗаказыПоставщикам(Организация);
	ДанныеОрганизации.ТребуетсяПовторноеПодключениеОрганизации = 
		БизнесСеть.ТребуетсяПовторноеПодключениеОрганизации(Организация);
	
КонецПроцедуры

#КонецОбласти

#Область ПолучениеТокена

Функция ВыполнитьФоновоеПолучениеТокена(Организация, УникальныйИдентификаторФормы) Экспорт
	
	ПараметрыВыполнения = ДлительныеОперации.ПараметрыВыполненияФункции(УникальныйИдентификаторФормы);
	
	Возврат ДлительныеОперации.ВыполнитьФункцию(ПараметрыВыполнения, "БизнесСеть.ТокенДоступаОрганизации", Организация);
	
КонецФункции

#КонецОбласти

#Область КонфликтВерсий

Функция ПолучитьСведенияКонфликтующихВерсий(ДанныеДокумента, ИдентификаторФормы) Экспорт
	
	ПараметрыВыполнения = ДлительныеОперации.ПараметрыВыполненияВФоне(ИдентификаторФормы);
	ПараметрыВыполнения.НаименованиеФоновогоЗадания = НСтр("ru = 'Получение сведений о конфликтующих версиях документа'");
	
	Возврат ДлительныеОперации.ВыполнитьФункцию(ПараметрыВыполнения, "РаботаСДаннымиEDIСлужебный.ПолучитьСведенияКонфликтующихВерсий", 
		ДанныеДокумента);
	
КонецФункции

#КонецОбласти

#Область КомандыEDI

// Получение структуры команд EDI из сохраненной настройки.
//  ИмяКоманды                      - Строка - имя команды.
//  АдресКомандВоВременномХранилище - Строка - адрес во временном хранилище.
//
// Возвращаемое значение:
//  Структура - описание команды EDI:
//  * Идентификатор - Строка - Идентификатор команды ЭДО, по которому менеджер ЭДО определяет печатную
//                             форму, которую необходимо сформировать.
//                             Пример: "СчетЗаказ".
//                  - Массив - список идентификаторов команд ЭДО.
//
//  * Представление - Строка            - Представление команды в меню ЭДО. 
//                                         Пример: "Просмотр документа".
//
//  * Обработчик    - Строка            - (необязательный) Клиентский обработчик команды, в который необходимо передать
//                                        управление.
//
//  * Порядок       - Число             - (необязательный) Значение от 1 до 100, указывающее порядок размещения команды
//                                        по отношению к другим командам. Сортировка команд меню ЭДО осуществляется
//                                        сначала по полю Порядок, затем по представлению.
//                                        Значение по умолчанию: 50.
//
//  * Картинка      - Картинка          - (необязательный) Картинка, которая отображается возле команды в меню ЭДО.
//                                         Пример: БиблиотекаКартинок.ФорматPDF.
//
//  * СписокФорм    - Строка            - (необязательный) Имена форм через запятую, в которых должна отображаться
//                                        команда. Если параметр не указан, то команда ЭДО будет отображаться во
//                                        всех формах объекта, где встроена подсистема ЭДО.
//                                         Пример: "ФормаДокумента".
//
//  * МестоРазмещения - Строка          - (необязательный) Имя командной панели формы, в которую необходимо разместить
//                                        команду ЭДО. Параметр необходимо использовать только в случае, когда на
//                                        форме размещается более одного подменю "ЭДО". В остальных случаях место
//                                        размещения необходимо задавать в модуле формы при вызове метода.
//                                        
//  * ФункциональныеОпции - Строка      - (необязательный) Имена функциональных опций через запятую, от которых зависит
//                                        доступность команды ЭДО.
Функция ОписаниеКомандыEDI(ИмяКоманды, АдресКомандВоВременномХранилище) Экспорт
	
	КомандыEDI = ПолучитьИзВременногоХранилища(АдресКомандВоВременномХранилище);
	Для Каждого КомандаEDI Из КомандыEDI.НайтиСтроки(Новый Структура("ИмяКомандыНаФорме", ИмяКоманды)) Цикл
		Возврат ОбщегоНазначения.СтрокаТаблицыЗначенийВСтруктуру(КомандаEDI);
	КонецЦикла;
	
	Возврат Неопределено;
	
КонецФункции

#КонецОбласти

#Область ПоказыватьФормуПодтвержденияПриОтправкеИзменений

Функция ПоказыватьФормуПодтвержденияПриОтправкеИзменений() Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	Возврат ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить("Обработка.СервисEDI.Форма.ФормаЗаказа",
		"ПодтверждениеОтправкиНаСогласование\ПоказыватьФормуПодтвержденияПриОтправкеИзменений", Истина);
	
КонецФункции

Процедура УстановитьПодтверждениеПриОтправкеИзменений(Значение) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	ОбщегоНазначения.ХранилищеОбщихНастроекСохранить("Обработка.СервисEDI.Форма.ФормаЗаказа",
		"ПодтверждениеОтправкиНаСогласование\ПоказыватьФормуПодтвержденияПриОтправкеИзменений", Значение);
	
КонецПроцедуры

Функция ПрикладнойОбъектВEDIНаходитсяВФинальномСтатусе(ПрикладнойОбъект) Экспорт
	
	Возврат РегистрыСведений.СостоянияДокументовEDI.ПрикладнойОбъектВEDIНаходитсяВФинальномСтатусе(ПрикладнойОбъект);
	
КонецФункции

#КонецОбласти

#Область ПолучениеДокументовИзСписка

Функция РезультатЗагрузкиОбновленияПрикладныхДокументов(ПараметрыЗагрузки) Экспорт
	
	ПараметрыВыполнения = ДлительныеОперации.ПараметрыВыполненияВФоне(ПараметрыЗагрузки.УникальныйИдентификатор);
	ПараметрыВыполнения.НаименованиеФоновогоЗадания = НСтр("ru = 'Загрузка и обновление документов из сервиса 1С:EDI'");
	ПараметрыВыполнения.ЗапуститьВФоне              = Истина;
	
	ДлительнаяОперация = ДлительныеОперации.ВыполнитьФункцию(ПараметрыВыполнения, 
	                                                         "ДокументыEDIИнтеграция.РезультатЗагрузкиОбновленияПрикладныхДокументов",
	                                                          ПараметрыЗагрузки);
	Возврат ДлительнаяОперация;
	
КонецФункции

Функция РезультатОбновленияДокументовПослеСопоставленияНоменклатуры(ПараметрыОбновления) Экспорт
	
	ИспользуемыеПараметрыОбновления = ОбщегоНазначения.СкопироватьРекурсивно(ПараметрыОбновления);
	
	ИспользуемыеПараметрыОбновления.Вставить("РезультатТребуетсяСопоставление", 
		ПолучитьИзВременногоХранилища(ПараметрыОбновления.АдресДанныхДокументовТребуетсяСопоставление));

	ПараметрыВыполнения = ДлительныеОперации.ПараметрыВыполненияВФоне(ПараметрыОбновления.УникальныйИдентификатор);
	ПараметрыВыполнения.НаименованиеФоновогоЗадания = НСтр("ru = 'Загрузка и обновление документов из сервиса 1С:EDI после сопоставления номенклатуры'");
	ПараметрыВыполнения.ЗапуститьВФоне              = Истина;
	
	ДлительнаяОперация = ДлительныеОперации.ВыполнитьФункцию(ПараметрыВыполнения, 
	                                                         "ДокументыEDIИнтеграция.РезультатОбновленияДокументовПослеСопоставленияНоменклатуры",
	                                                          ИспользуемыеПараметрыОбновления);
	Возврат ДлительнаяОперация;
	
КонецФункции

Функция ОбработатьРезультатСопоставления(АдресВоВременномХранилище, ИдентификаторФормы) Экспорт
	
	РезультатВыполнения = ПолучитьИзВременногоХранилища(АдресВоВременномХранилище);
	РезультатВыполнения.Вставить("АдресДанныхДокументовТребуетсяСопоставление",  ПоместитьВоВременноеХранилище(
		РезультатВыполнения.РезультатТребуетсяСопоставление, ИдентификаторФормы));
	РезультатВыполнения.Удалить("РезультатТребуетсяСопоставление");
	
	Возврат РезультатВыполнения;
	
КонецФункции

#КонецОбласти

#Область ЗагрузкаДокумента

Функция ЗагрузитьДокументИзСервиса(ПараметрыВыполнения) Экспорт
	
	ПараметрыЗапуска = ДлительныеОперации.ПараметрыВыполненияФункции(ПараметрыВыполнения.ИдентификаторФормы);
	ПараметрыЗапуска.НаименованиеФоновогоЗадания = НСтр("ru = 'Загрузка документа из сервисе 1С:EDI'");
	
	Возврат ДлительныеОперации.ВыполнитьФункцию(ПараметрыЗапуска, "ДокументыEDIИнтеграция.ЗагрузитьДокументИзСервиса", ПараметрыВыполнения);
	
КонецФункции

#КонецОбласти

#Область СписокПрикладныхДокументов

Функция ДанныеДляОбновленияИнформацииСписокПрикладныхДокументов(ТипДокумента) Экспорт
	
	Данные = Новый Структура;
	Данные.Вставить("НадписьДокументыКЗагрузке", "");
	
	Данные.НадписьДокументыКЗагрузке = ДокументыEDIИнтеграция.НадписьДокументыКЗагрузке(ТипДокумента);
	
	Возврат Данные; 
	
КонецФункции

#КонецОбласти

#Область ПовторноеПодключениеОрганизации

Функция ТребуетсяПовторноеПодключениеОрганизации(Организация) Экспорт 
	
	Возврат БизнесСеть.ТребуетсяПовторноеПодключениеОрганизации(Организация);
	
КонецФункции

#КонецОбласти

#Область ПроверкаФункциональности

Функция ИспользоватьПодсистему(ТипДокумента) Экспорт
	
	Возврат ДокументыEDIИнтеграция.ИспользоватьПодсистему(ТипДокумента);
	
КонецФункции

#КонецОбласти

#КонецОбласти

#КонецОбласти