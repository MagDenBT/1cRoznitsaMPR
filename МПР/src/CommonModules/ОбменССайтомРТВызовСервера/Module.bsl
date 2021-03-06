
Функция ПолучитьСтруктуруГотовностиКУдаленнойФискализации(КассаККМ) Экспорт
	
	ГотовностьКУдаленнойФискализации = Ложь;
	ПодключенаСистемаВзаимодействия = СистемаВзаимодействия.ИспользованиеДоступно();
	ВыбранаКассаККМ = ЗначениеЗаполнено(КассаККМ);
	ККТСПередачейОФД = Ложь;
	НастроенаКассаККМ = Ложь;
	ПодключаемоеОборудование = Ложь;
	
	Если ВыбранаКассаККМ Тогда
		ККТСПередачейОФД = КассаККМ.ТипКассы = Перечисления.ТипыКассККМ.ФискальныйРегистратор;
		ПодключаемоеОборудование = КассаККМ.ПодключаемоеОборудование;
		НастроенаКассаККМ = ПодключаемоеОборудование.УстройствоИспользуется И ПодключаемоеОборудование.АвтоматическаяФискализация;
	КонецЕсли;
	
	Результат = Новый Структура;
	Результат.Вставить("ГотовностьКУдаленнойФискализации", ПодключенаСистемаВзаимодействия И НастроенаКассаККМ);
	Результат.Вставить("ПодключенаСистемаВзаимодействия", ПодключенаСистемаВзаимодействия);
	Результат.Вставить("ВыбранаКассаККМ", ВыбранаКассаККМ);
	Результат.Вставить("ККТСПередачейОФД", ККТСПередачейОФД);
	Результат.Вставить("НастроенаКассаККМ", НастроенаКассаККМ);
	Результат.Вставить("ПодключаемоеОборудование", ПодключаемоеОборудование);
	
	Возврат Результат;
	
КонецФункции

Процедура ЗаписатьСостояниеОплатыЗаказаПокупателя(ЗаказПокупателя, ДокументДвижения) Экспорт
	
	ОбменССайтомРТ.ЗаписатьСостояниеОплатыЗаказаПокупателя(ЗаказПокупателя, ДокументДвижения);
	
КонецПроцедуры