
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	ФормаЖурнала = ОткрытьФорму("ЖурналДокументов.СогласияНаОбработкуПерсональныхДанных.Форма.ФормаСписка");
	ФормаЖурнала.Заголовок = "Сотрудники";
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(ФормаЖурнала.Список,"Субъект.Сотрудник",Истина, ВидСравненияКомпоновкиДанных.Равно);
КонецПроцедуры
