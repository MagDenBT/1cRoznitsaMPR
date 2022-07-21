#Область ОбработчикиСобытий

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	УникальныйИдентификатор = Новый УникальныйИдентификатор();
	ОписаниеОповещения = Новый ОписаниеОповещения("ВыполнитьОперациюЗавершение", ЭтотОбъект);
	ОборудованиеПлатежныеСистемыКлиент.НачатьВыполнениеСверкиИтоговНаЭквайринговомТерминале(ОписаниеОповещения, УникальныйИдентификатор)
	
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьОперациюЗавершение(РезультатВыполнения, Параметры) Экспорт
	
	Если РезультатВыполнения.Результат Тогда
		ТекстСообщения = НСтр("ru = 'Операция выполнена успешно.'");
	Иначе
		ТекстСообщения = РезультатВыполнения.ОписаниеОшибки;
	КонецЕсли;
	
	ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения);
	
КонецПроцедуры

#КонецОбласти