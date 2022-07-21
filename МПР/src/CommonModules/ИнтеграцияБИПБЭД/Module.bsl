
#Область СлужебныйПрограммныйИнтерфейс

// Получение билета на сайте интернет-поддержки.
//
// Параметры:
//  ИнтернетПоддержкаПользователейПодключена - Булево - в данную переменную возвращается Истина, если 
//	                                                    интернет-поддержку удалось подключить
//  ПоказыватьОшибки - Булево - признак показа ошибок.
//  ПоказыватьОшибкуАутентификацииПриОтсутствииДанных - Булево - определяет, показывать ли ошибку аутентификации
//                                                      в случае, если не указан логин и пароль.
//  КонтекстОперации - Структура - Контекст операции, см. ОбработкаНеисправностейБЭД.НовыйКонтекстДиагностики.
// 
// Возвращаемое значение:
//  Строка - контрольная строка для авторизации.
//
Функция БилетНаСайтПоддержки(ИнтернетПоддержкаПользователейПодключена, ПоказыватьОшибки = Истина,
	ПоказыватьОшибкуАутентификацииПриОтсутствииДанных = Истина, КонтекстОперации = Неопределено) Экспорт
	
	Билет = "";
	ИнтернетПоддержкаПользователейПодключена = Истина;
	
	ВидОперации = НСтр("ru = 'Подключение к порталу интернет-поддержки'");
	ТекстЗаголовкаСообщения = НСтр("ru = 'Невозможно подключиться к порталу интернет-поддержки по причине:'");
	
	Если ОбщегоНазначения.РазделениеВключено()
		И ОбщегоНазначения.ДоступноИспользованиеРазделенныхДанных() Тогда
	
		Если ОбщегоНазначения.ПодсистемаСуществует("ТехнологияСервиса.УправлениеТарифами") Тогда
			
			МодульТарификация = ОбщегоНазначения.ОбщийМодуль("Тарификация");
			Если Не МодульТарификация.ЗарегистрированаЛицензияБезлимитнойУслуги(
				ИнтеграцияБИПБЭДКлиентСервер.ИдентификаторПоставщикаУслугПортал1СИТС(),
				ИнтеграцияБИПБЭДКлиентСервер.ИдентификаторУслугиОбменаЭлектроннымиДокументами()) Тогда
			
				ОписаниеОшибки = НСтр("ru = 'Услуга ""Обмен электронными документами"" не подключена.
											|Необходимо:
											|Проверить наличие ИТС по рег. номеру;
											|Проверить окончание срока действия договора ИТС на портале.'");
				
				ТекстСообщенияДляЖурналаРегистрации = ТекстЗаголовкаСообщения + Символы.ПС + ОписаниеОшибки;
				ТекстСообщенияДляПользователя = "";
				Если ПоказыватьОшибки Тогда
					ТекстСообщенияДляПользователя = ТекстСообщенияДляЖурналаРегистрации;
				КонецЕсли;
				
				ОбработкаНеисправностейБЭД.ОбработатьОшибку(ВидОперации,
					ОбщегоНазначенияБЭДКлиентСервер.ПодсистемыБЭД().ЭлектронноеВзаимодействие,
					ТекстСообщенияДляЖурналаРегистрации,
					ТекстСообщенияДляПользователя);
					
				Возврат Билет;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
	Если Не ОбщегоНазначения.ПодсистемаСуществует("ИнтернетПоддержкаПользователей") Тогда
		ОписаниеОшибки =
			НСтр("ru = 'Библиотека интернет поддержки пользователей не внедрена в конфигурацию.'");
		ТекстСообщения = ТекстЗаголовкаСообщения + Символы.ПС + ОписаниеОшибки;
		
		Ошибка = ОбработкаНеисправностейБЭД.НоваяОшибка(ВидОперации,
			ИнтеграцияБИПБЭДКлиентСервер.ВидОшибкиИнтернетПоддержка(), ОписаниеОшибки, ТекстСообщения);
		ОбработкаНеисправностейБЭД.ДобавитьОшибку(КонтекстОперации, Ошибка, ОбщегоНазначенияБЭДКлиентСервер.ПодсистемыБЭД().ЭлектронноеВзаимодействие);
			
		Возврат Билет;
	КонецЕсли;
	
	МодульИнтернетПоддержкаПользователей = ОбщегоНазначения.ОбщийМодуль("ИнтернетПоддержкаПользователей");
	УстановитьПривилегированныйРежим(Истина);
	Результат = МодульИнтернетПоддержкаПользователей.ТикетАутентификацииНаПорталеПоддержки("1C-EDO");
	УстановитьПривилегированныйРежим(Ложь);
	
	Если ЗначениеЗаполнено(Результат.КодОшибки) Тогда
		Если Результат.КодОшибки = "НеверныйЛогинИлиПароль" Тогда
			ИнтернетПоддержкаПользователейПодключена = Ложь;
		КонецЕсли;
		
		ТекстСообщения = "";
		Если ПоказыватьОшибки Тогда
			УстановитьПривилегированныйРежим(Истина);
			ДанныеАутентификации = МодульИнтернетПоддержкаПользователей.ДанныеАутентификацииПользователяИнтернетПоддержки();
			УстановитьПривилегированныйРежим(Ложь);
			
			Если Не (Не ПоказыватьОшибкуАутентификацииПриОтсутствииДанных И Результат.КодОшибки = "НеверныйЛогинИлиПароль"
						И ДанныеАутентификации = Неопределено) Тогда
				ТекстСообщения = ТекстЗаголовкаСообщения + Символы.ПС + Результат.СообщениеОбОшибке;
			КонецЕсли;
			
		КонецЕсли;
		
		Если Результат.КодОшибки = "ОшибкаПодключения" Тогда
			ВидОшибки = ИнтернетСоединениеБЭДКлиентСервер.ВидОшибкиИнтернетСоединение();
		ИначеЕсли Результат.КодОшибки = "НеверныйЛогинИлиПароль" Тогда
			ВидОшибки = ИнтеграцияБИПБЭДКлиентСервер.ВидОшибкиИнтернетПоддержка();
		Иначе
			ВидОшибки = ОбработкаНеисправностейБЭДКлиентСервер.ВидОшибкиНеизвестнаяОшибка();
		КонецЕсли;
		
		Если ЗначениеЗаполнено(ВидОшибки) И Не ЗначениеЗаполнено(ТекстСообщения) Тогда
			ТекстСообщения = ТекстЗаголовкаСообщения + Символы.ПС + Результат.СообщениеОбОшибке;
		КонецЕсли;
		Ошибка = ОбработкаНеисправностейБЭД.НоваяОшибка(ВидОперации, ВидОшибки,
			Результат.СообщениеОбОшибке, ТекстСообщения);
		ОбработкаНеисправностейБЭД.ДобавитьОшибку(КонтекстОперации, Ошибка, ОбщегоНазначенияБЭДКлиентСервер.ПодсистемыБЭД().ЭлектронноеВзаимодействие);
	Иначе
		Билет = Результат.Тикет;
	КонецЕсли;
	
	Возврат Билет;
	
КонецФункции

#КонецОбласти