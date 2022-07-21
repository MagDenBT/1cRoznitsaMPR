
#Область ОбработчикиСобытий

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ТекущийКассир = МенеджерОборудованияКлиентСервер.ТекущийКассирДляФискальныхОпераций();  
	Кассир = ТекущийКассир.Кассир; 
	КассирИНН = ТекущийКассир.КассирИНН;   
	
	ИнкасацияДоступна = МенеджерОборудованияВызовСервера.ДоступноИнкасацияВУправлениеФискальнымУстройством();
	Элементы.ВнесениеДенег.Видимость = ИнкасацияДоступна;     
	Элементы.ВыемкаДенег.Видимость = ИнкасацияДоступна; 
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОперацияЗавершение(РезультатВыполнения, Параметры) Экспорт
	
	Доступность = Истина;
	
	ТекстСообщения = ?(РезультатВыполнения.Результат, НСтр("ru='Операция успешно завершена.'"), РезультатВыполнения.ОписаниеОшибки);
	ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьСмену(Команда)
	
	ВыполнитьОперацию("ОткрытьСмену");
	
КонецПроцедуры

&НаКлиенте
Процедура ЗакрытьСмену(Команда)
	
	ВыполнитьОперацию("ЗакрытьСмену");
	
КонецПроцедуры

&НаКлиенте
Процедура ВнесениеДенег(Команда)
	
	ВыполнитьОперацию("Внесение"); 
	
КонецПроцедуры

&НаКлиенте
Процедура ВыемкаДенег(Команда)
	
	ВыполнитьОперацию("Выемка");     
	
КонецПроцедуры

&НаКлиенте
Процедура ОтчетОТекущемСостоянииРасчетов(Команда)
	
	ВыполнитьОперацию("ОтчетОТекущемСостоянииРасчетов");
	
КонецПроцедуры

&НаКлиенте
Процедура ОтчетБезГашения(Команда)
	
	ВыполнитьОперацию("ОтчетБезГашения");
	
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьОперацию(Команда)
	
	ОчиститьСообщения();
	
	ПоддерживаемыеТипыВО = Новый Массив();
	ПоддерживаемыеТипыВО.Добавить("ФискальныйРегистратор");
	ПоддерживаемыеТипыВО.Добавить("ПринтерЧеков");
	ПоддерживаемыеТипыВО.Добавить("ККТ");
	
	ДополнительныеПараметры = Новый Структура("Команда", Команда);
	
	Если Команда = "Внесение" Или Команда = "Выемка" Тогда
		ОписаниеОповещения = Новый ОписаниеОповещения("ВыполнитьОперациюВыбораУстройстваИнкасация", ЭтотОбъект, ДополнительныеПараметры); 
	Иначе
		ОписаниеОповещения = Новый ОписаниеОповещения("ВыполнитьОперациюВыбораУстройства", ЭтотОбъект, ДополнительныеПараметры); 
	КонецЕсли;
	МенеджерОборудованияКлиент.ВыбратьУстройство(ОписаниеОповещения, ПоддерживаемыеТипыВО,
		НСтр("ru='Выберите фискальное устройство'"), 
		НСтр("ru='Фискальное устройство не подключено.'"), 
		НСтр("ru='Фискальное устройство не выбрано.'"));

КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьОперациюВыбораУстройстваИнкасация(РезультатВыбора, ДополнительныеПараметры) Экспорт
	
	Если НЕ РезультатВыбора.Результат Тогда
		ОбщегоНазначенияКлиент.СообщитьПользователю(РезультатВыбора.ОписаниеОшибки);      
		Возврат;
	КонецЕсли;  
	
	СуммаОперации = 0;
	
	Если ДополнительныеПараметры.Команда = "Внесение" Тогда    
		ЗаголовокОкна = НСтр("ru='Сумма внесения'");       
	Иначе     
		ЗаголовокОкна = НСтр("ru='Сумма выемки'");  
	КонецЕсли;
	
	ПараметрыПослеВводаЧисла = Новый Структура;
	ПараметрыПослеВводаЧисла.Вставить("СуммаОперации", СуммаОперации);
	ПараметрыПослеВводаЧисла.Вставить("ИдентификаторУстройства", РезультатВыбора.ИдентификаторУстройства);  
	ПараметрыПослеВводаЧисла.Вставить("Команда", ДополнительныеПараметры.Команда);
	
	ОповещениеПослеВводеЧисла = Новый ОписаниеОповещения("ИнкасацияЗавершение", ЭтотОбъект, ПараметрыПослеВводаЧисла);
	
	ПоказатьВводЧисла(ОповещениеПослеВводеЧисла, СуммаОперации, ЗаголовокОкна, 15, 2);
	
КонецПроцедуры        

&НаКлиенте
Процедура ИнкасацияЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	СуммаОперации = ?(Результат = Неопределено, ДополнительныеПараметры.СуммаОперации, Результат);
	
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Доступность = Ложь;   
	
	ПараметрыОперации = ОборудованиеЧекопечатающиеУстройстваКлиентСервер.ПараметрыИнкассации();
	ПараметрыОперации.ТипИнкассации = ?(ДополнительныеПараметры.Команда = "Внесение" , 1, 0);    
	ПараметрыОперации.Сумма     = СуммаОперации;   
	ПараметрыОперации.Кассир    = Кассир;   
	ПараметрыОперации.КассирИНН = КассирИНН;
	
	ОповещениеПриЗавершении = Новый ОписаниеОповещения("ОперацияЗавершение", ЭтотОбъект);
	ОборудованиеЧекопечатающиеУстройстваКлиент.НачатьИнкассациюНаФискальномУстройстве(ОповещениеПриЗавершении, УникальныйИдентификатор, 
		ДополнительныеПараметры.ИдентификаторУстройства, ПараметрыОперации);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьОперациюВыбораУстройства(РезультатВыбора, ДополнительныеПараметры) Экспорт
	
	Если НЕ РезультатВыбора.Результат Тогда
		ОбщегоНазначенияКлиент.СообщитьПользователю(РезультатВыбора.ОписаниеОшибки);      
		Возврат;
	КонецЕсли;
	
	ОчиститьСообщения();
	Доступность = Ложь;
	
	ПараметрыОперации = ОборудованиеЧекопечатающиеУстройстваКлиентСервер.ПараметрыОткрытияЗакрытияСмены();
	ПараметрыОперации.Кассир    = Кассир;   
	ПараметрыОперации.КассирИНН = КассирИНН;

	ОповещениеПриЗавершении = Новый ОписаниеОповещения("ОперацияЗавершение", ЭтотОбъект);
	
	Если ДополнительныеПараметры.Команда = "ОткрытьСмену" Тогда
		ОборудованиеЧекопечатающиеУстройстваКлиент.НачатьОткрытиеСменыНаФискальномУстройстве(ОповещениеПриЗавершении, 
			УникальныйИдентификатор, РезультатВыбора.ИдентификаторУстройства, ПараметрыОперации);
	ИначеЕсли ДополнительныеПараметры.Команда = "ЗакрытьСмену" Тогда
		ОборудованиеЧекопечатающиеУстройстваКлиент.НачатьЗакрытиеСменыНаФискальномУстройстве(ОповещениеПриЗавершении, 
			УникальныйИдентификатор, РезультатВыбора.ИдентификаторУстройства, ПараметрыОперации);
	ИначеЕсли ДополнительныеПараметры.Команда = "ОтчетОТекущемСостоянииРасчетов" Тогда
		ОборудованиеЧекопечатающиеУстройстваКлиент.НачатьФормированиеОтчетаОТекущемСостоянииРасчетов(ОповещениеПриЗавершении, 
			УникальныйИдентификатор, РезультатВыбора.ИдентификаторУстройства, ПараметрыОперации);
	ИначеЕсли ДополнительныеПараметры.Команда = "ОтчетБезГашения" Тогда
		ОборудованиеЧекопечатающиеУстройстваКлиент.НачатьФормированиеОтчетаБезГашения(ОповещениеПриЗавершении, 
			УникальныйИдентификатор, РезультатВыбора.ИдентификаторУстройства, ПараметрыОперации);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

