#Область СлужебныйПрограммныйИнтерфейс

// Событие возникает при записи нового вида электронного документа.
// 
// Параметры:
// 	ВидДокумента - СправочникСсылка.ВидыДокументовЭДО - ссылка на вид электронного документа.
// 	Отказ - Булево - признак отказа от записи.
Процедура ПриЗаписиНовогоВидаДокумента(ВидДокумента, Отказ) Экспорт
	КриптографияБЭД.ДобавитьПодписываемыйВидДокумента(ВидДокумента);
КонецПроцедуры

// Событие возникает при записи нового исходящего электронного документа.
// Выполняется в одной транзакции с записью электронного документа.
// 
// Параметры:
// 	ЭлектронныйДокумент - ДокументСсылка.ЭлектронныйДокументИсходящийЭДО - ссылка исходящего документа.
// 	СостояниеЭДО - ПеречислениеСсылка.СостоянияДокументовЭДО - состояние электронного документа.
// 	НаборОбъектовУчета - Массив из см. ИнтеграцияЭДОКлиентСервер.НовыйОбъектУчета
// 	КонтекстДиагностики - См. ОбработкаНеисправностейБЭД.НовыйКонтекстДиагностики.
Процедура ПриФормированииЭлектронногоДокумента(ЭлектронныйДокумент, СостояниеЭДО, НаборОбъектовУчета, КонтекстДиагностики) Экспорт
	ИнтеграцияЭДО.ПриФормированииЭлектронногоДокумента(ЭлектронныйДокумент, СостояниеЭДО, НаборОбъектовУчета);
КонецПроцедуры

// Событие возникает после формирования электронного документа.
// Выполняется вне транзакции.
// 
// Параметры:
// 	ЭлектронныйДокумент - ДокументСсылка.ЭлектронныйДокументИсходящийЭДО - ссылка исходящего ПараметрыДокумента	КонтекстДиагностики - См. ОбработкаНеисправностейБЭД.НовыйКонтекстДиагностики.
// 	КонтекстДиагностики - См. ОбработкаНеисправностейБЭД.НовыйКонтекстДиагностики.
Процедура ПослеФормированияЭлектронногоДокумента(ЭлектронныйДокумент, КонтекстДиагностики) Экспорт
	ИнтеграцияЭДО.ПослеФормированияЭлектронногоДокумента(ЭлектронныйДокумент, КонтекстДиагностики) 
КонецПроцедуры

// Событие возникает после утверждения электронного документа.
// Выполняется вне транзакции.
// 
// Параметры:
// 	ЭлектронныйДокумент - ДокументСсылка.ЭлектронныйДокументИсходящийЭДО - ссылка исходящего документа.
// 	КонтекстДиагностики - См. ОбработкаНеисправностейБЭД.НовыйКонтекстДиагностики.
Процедура ПослеУтвержденияЭлектронногоДокумента(ЭлектронныйДокумент, КонтекстДиагностики) Экспорт
	ИнтеграцияЭДО.ПослеУтвержденияЭлектронногоДокумента(ЭлектронныйДокумент, КонтекстДиагностики) 
КонецПроцедуры

// Событие возникает после полного подписания электронного документа.
// Выполняется вне транзакции.
// 
// Параметры:
// 	ЭлектронныйДокумент - ДокументСсылка.ЭлектронныйДокументИсходящийЭДО - ссылка исходящего документа.
// 	КонтекстДиагностики - См. ОбработкаНеисправностейБЭД.НовыйКонтекстДиагностики.
Процедура ПослеПодписанияЭлектронногоДокумента(ЭлектронныйДокумент, КонтекстДиагностики) Экспорт
	ИнтеграцияЭДО.ПослеПодписанияЭлектронногоДокумента(ЭлектронныйДокумент, КонтекстДиагностики) 
КонецПроцедуры

// Событие возникает после завершения регламента по электронному документу.
// Выполняется вне транзакции.
// 
// Параметры:
// 	ЭлектронныйДокумент - ДокументСсылка.ЭлектронныйДокументИсходящийЭДО - ссылка исходящего документа.
// 	КонтекстДиагностики - См. ОбработкаНеисправностейБЭД.НовыйКонтекстДиагностики.
Процедура ПослеЗавершенияОбменаЭлектроннымДокументом(ЭлектронныйДокумент, КонтекстДиагностики) Экспорт
	ИнтеграцияЭДО.ПослеЗавершенияОбменаЭлектроннымДокументом(ЭлектронныйДокумент, КонтекстДиагностики) 
КонецПроцедуры

// Событие возникает после аннулирования электронного документа.
// Выполняется вне транзакции.
// 
// Параметры:
// 	ЭлектронныйДокумент - ДокументСсылка.ЭлектронныйДокументИсходящийЭДО - ссылка исходящего документа.
// 	КонтекстДиагностики - См. ОбработкаНеисправностейБЭД.НовыйКонтекстДиагностики.
Процедура ПослеАннулированияЭлектронногоДокумента(ЭлектронныйДокумент, КонтекстДиагностики) Экспорт
	ИнтеграцияЭДО.ПослеАннулированияЭлектронногоДокумента(ЭлектронныйДокумент, КонтекстДиагностики);
КонецПроцедуры

// Событие возникает при изменении состояния существующего электронного документа.
// Выполняется в одной транзакции с записью электронного документа.
// 
// Параметры:
// 	ЭлектронныйДокумент - ДокументСсылка.ЭлектронныйДокументИсходящийЭДО - ссылка исходящего документа.
// 	СостояниеЭДО - ПеречислениеСсылка.СостоянияДокументовЭДО - состояние электронного документа.
// 	КонтекстДиагностики - См. ОбработкаНеисправностейБЭД.НовыйКонтекстДиагностики.
Процедура ПриИзмененииСостоянияЭлектронногоДокумента(ЭлектронныйДокумент, СостояниеЭДО, КонтекстДиагностики) Экспорт
	ИнтеграцияЭДО.ПриИзмененииСостоянияЭлектронногоДокумента(ЭлектронныйДокумент, СостояниеЭДО, КонтекстДиагностики);
КонецПроцедуры

// Событие возникает при загрузке нового входящего электронного документа.
// Выполняется в одной транзакции с записью электронного документа.
// 
// Параметры:
// 	ЭлектронныйДокумент - ДокументСсылка.ЭлектронныйДокументВходящийЭДО - ссылка на входящий электронный документ.
// 	ВидДокумента - СправочникСсылка.ВидыДокументовЭДО - ссылка на вид электронного документа.
// 	СостояниеЭДО - ПеречислениеСсылка.СостоянияДокументовЭДО - состояние входящего электронного документа.
// 	ИсправленнаяВерсияДокумента - ДокументСсылка.ЭлектронныйДокументВходящийЭДО - ссылка на исправленную версию входящего электронного документа.
// 	КонтекстДиагностики - См. ОбработкаНеисправностейБЭД.НовыйКонтекстДиагностики.
Процедура ПриЗагрузкеНовогоЭлектронногоДокумента(ЭлектронныйДокумент, ВидДокумента, СостояниеЭДО, ИсправленнаяВерсияДокумента, КонтекстДиагностики) Экспорт
	ИнтеграцияЭДО.ПриЗагрузкеНовогоЭлектронногоДокумента(ЭлектронныйДокумент, ВидДокумента, СостояниеЭДО,
		ИсправленнаяВерсияДокумента, КонтекстДиагностики);
КонецПроцедуры

// Событие возникает при загрузке документа.
// Выполняется в одной транзакции.
// 
// Параметры:
// 	Сообщение - ДокументСсылка.СообщениеЭДО - ссылка на сообщение ЭДО.
// 	ДанныеСообщения - СтрокаТаблицыЗначений из См. СинхронизацияЭДО.НовыеДанныеОбъектов - данные документа для загрузки.
// 	КонтекстДиагностики - См. ОбработкаНеисправностейБЭД.НовыйКонтекстДиагностики.
Процедура ПриЗагрузкеСообщения(Сообщение, ДанныеСообщения, КонтекстДиагностики) Экспорт
	
	СинхронизацияЭДО.ПриЗагрузкеОбъекта(Сообщение, ДанныеСообщения, КонтекстДиагностики);
	
КонецПроцедуры

// Событие возникает после загрузки всех сообщений для новых документов.
// 
// Параметры:
// 	ЗагруженныйДокумент - См. ЭлектронныеДокументыЭДО.НовыеСведенияЗагруженногоДокумента
// 	КонтекстДиагностики - См. ОбработкаНеисправностейБЭД.НовыйКонтекстДиагностики.
Процедура ПослеЗагрузкиНовогоЭлектронногоДокумента(ЗагруженныйДокумент, КонтекстДиагностики) Экспорт
	ИнтеграцияЭДО.ПослеЗагрузкиНовогоЭлектронногоДокумента(ЗагруженныйДокумент, КонтекстДиагностики);
КонецПроцедуры

// Событие возникает после загрузки документов: подтверждения даты получения оператором (ПДП),
// подтверждения даты отправки оператором (ПДО), извещение о получении покупателя (ИОП),
// подтверждения даты отправки оператором извещение о получении покупателя (ИОППДО)
// по документообороту счета-фактуры.
// Выполняется вне транзакции.
// 
// Параметры:
// 	ЭлектронныйДокумент - ДокументСсылка.ЭлектронныйДокументИсходящийЭДО, ДокументСсылка.ЭлектронныйДокументВходящийЭДО - ссылка на ЭлектронныйДокумент.
// 	ДокументыПодтверждения - ТаблицаЗначений - Описание:
// 	  * ТипЭлементаРегламента - ПеречислениеСсылка.ТипыЭлементовРегламентаЭДО - тип элемента регламентов;
// 	  * Дата - Дата - дата формирования документа;
// 	  * Текущий - Булево - признак текущего загруженного документа.
// 	КонтекстДиагностики - См. ОбработкаНеисправностейБЭД.НовыйКонтекстДиагностики.
Процедура ПослеЗагрузкиПодтвержденияПоСчетуФактуре(ЭлектронныйДокумент, ДокументыПодтверждения, КонтекстДиагностики) Экспорт
	
	ИнтеграцияЭДО.ПослеЗагрузкиПодтвержденияПоСчетуФактуре(ЭлектронныйДокумент, ДокументыПодтверждения, КонтекстДиагностики);
	
КонецПроцедуры

// Событие возникает при установки /снятии пометки удаления электронного документа.
// 
// Параметры:
// 	ЭлектронныйДокумент - ДокументСсылка.ЭлектронныйДокументВходящийЭДО, ДокументСсылка.ЭлектронныйДокументИсходящийЭДО - Ссылка на электронный документ.
// 	ПометкаУдаления - Булево - признак установки / снятия пометки.
// 	Отказ - Булево - признак отказа от установки пометки удаления.
Процедура ПриУстановкеПометкиУдаленияДокумента(ЭлектронныйДокумент, ПометкаУдаления, Отказ) Экспорт
	ИнтеграцияЭДО.ПриУстановкеПометкиУдаленияДокумента(ЭлектронныйДокумент, ПометкаУдаления, Отказ);
КонецПроцедуры

// Событие возникает перед непосредственным удалением электронного документа из базы данных.
// 
// Параметры:
// 	ЭлектронныйДокумент - ДокументСсылка.ЭлектронныйДокументВходящийЭДО, ДокументСсылка.ЭлектронныйДокументИсходящийЭДО - Ссылка на электронный документ.
// 	Отказ - Булево - признак отказа от удаления электронного документа.
//
Процедура ПередУдалениемДокумента(ЭлектронныйДокумент, Отказ) Экспорт
	
КонецПроцедуры

#КонецОбласти