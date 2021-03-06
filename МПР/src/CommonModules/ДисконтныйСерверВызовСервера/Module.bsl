
#Область ПрограммныйИнтерфейс

// Обновляет продажи в дисконтном сервере
// или записывает задание на обновление продаж в дисконтном сервере
// в зависимости от значения опции ИспользоватьОчередьДляПередачиДокументовДисконтномуСерверу.
//
// Параметры:
//  ДокументСсылка - документ по которому необходимо обновить продажи в дисконтном сервере или
//                   записать задание к обновлению продаж.
//  ЕстьОшибки - Булево - признак ошибок при выполнении операции.
//
Процедура ОтразитьПродажиВДисконтномСервере(ДокументСсылка, ЕстьОшибки) Экспорт
	Если ПолучитьФункциональнуюОпцию("ИспользоватьОчередьДляПередачиДокументовДисконтномуСерверу") Тогда
		ДисконтныйСервер.ЗаписатьЗаданиеНаОбновлениеДисконтногоСервера(ДокументСсылка);
	Иначе
		ОбновленоУспешно = ДисконтныйСервер.ОбновитьДанныеОПродажах(ДокументСсылка, ЕстьОшибки);
		ДисконтныйСервер.ЗаписатьЗаданиеНаОбновлениеДисконтногоСервера(ДокументСсылка, ОбновленоУспешно);
	КонецЕсли;
КонецПроцедуры

#КонецОбласти
