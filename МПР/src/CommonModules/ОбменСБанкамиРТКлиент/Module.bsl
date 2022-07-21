
////////////////////////////////////////////////////////////////////////////////
// ОбменСБанкамиКлиентПереопределяемый: механизм обмена электронными документами с банками.
//
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Открывает форму разбора банковской выписки.
//
// Параметры:
//   СообщениеОбмена - ДокументСсылка.СообщениеОбменСБанками - сообщение с выпиской банка.
//
Процедура РазобратьВыпискуБанка(СообщениеОбмена) Экспорт
	
	Перем СсылкаНаХранилище, Организация, НастройкаОбмена, МассивСчетов;

	ДенежныеСредстваВызовСервера.ПолучитьДанныеВыпискиБанкаТекстовыйФормат(
		СообщениеОбмена, СсылкаНаХранилище, МассивСчетов, Организация, НастройкаОбмена);
	Если НЕ ЗначениеЗаполнено(СсылкаНаХранилище) Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыОткрытия = Новый Структура;
	ПараметрыОткрытия.Вставить("Организация",             Организация);
	ПараметрыОткрытия.Вставить("ЭлектроннаяВыпискаБанка", СообщениеОбмена);
	ПараметрыОткрытия.Вставить("СоглашениеПрямогоОбменаСБанками", НастройкаОбмена);
	Если МассивСчетов.Количество()>0 Тогда
		ПараметрыОткрытия.Вставить("БанковскийСчет", МассивСчетов[0]);
	КонецЕсли;
	
	ОткрытьФорму("Обработка.КлиентБанк.Форма.Форма");
	Оповестить("РазобратьВыпискуБанка", ПараметрыОткрытия);
	
КонецПроцедуры

#КонецОбласти
