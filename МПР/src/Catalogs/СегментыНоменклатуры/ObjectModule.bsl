#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	Если ЭтоГруппа Тогда
		Возврат;
	КонецЕсли;
	
	// Установить ответственного по умолчанию.
	Если НЕ ЗначениеЗаполнено(Ответственный) Тогда
		Ответственный = Пользователи.ТекущийПользователь();
	КонецЕсли;

	// установить дату создания
	Если НЕ ЗначениеЗаполнено(ДатаСоздания) Тогда
		ДатаСоздания = ТекущаяДатаСеанса();
	КонецЕсли;
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ)
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
КонецПроцедуры

Процедура ПередУдалением(Отказ)

	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если ЭтоГруппа Тогда
		Возврат;
	КонецЕсли;
	
	Если СпособФормирования <> 
			Перечисления.СпособыФормированияСегментов.ФормироватьДинамически Тогда
		СегментыВызовСервера.Очистить(Ссылка);
	КонецЕсли;

КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если ЭтоГруппа Тогда
		Возврат;
	КонецЕсли;
	
	Если СпособФормирования =
			Перечисления.СпособыФормированияСегментов.ФормироватьДинамически Тогда
		СегментыВызовСервера.Очистить(Ссылка);
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#КонецЕсли
