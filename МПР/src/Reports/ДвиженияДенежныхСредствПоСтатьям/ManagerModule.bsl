
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныйПрограммныйИнтерфейс

// Настройки размещения в панели отчетов.
//
// Параметры:
//   Настройки - Коллекция - Используется для описания настроек отчетов и вариантов
//       см. описание к ВариантыОтчетов.ДеревоНастроекВариантовОтчетовКонфигурации().
//   НастройкиОтчета - СтрокаДереваЗначений - Настройки размещения всех вариантов отчета.
//       См. "Реквизиты для изменения" функции ВариантыОтчетов.ДеревоНастроекВариантовОтчетовКонфигурации().
//
Процедура НастроитьВариантыОтчета(Настройки, НастройкиОтчета) Экспорт
	
	НастройкиВариантаОборотДДС = ВариантыОтчетов.ОписаниеВарианта(Настройки, НастройкиОтчета, "ОборотДДС");
	НастройкиВариантаОборотДДС.Описание = 
		НСтр("ru = 'Информация о движении денежных средств в разрезе организаций и статей движения'");
	
	НастройкиВариантаОборотДДСПоМесяцам = ВариантыОтчетов.ОписаниеВарианта(Настройки, НастройкиОтчета, "ОборотДДСПоМесяцам");
	НастройкиВариантаОборотДДСПоМесяцам.Описание =
		НСтр("ru = 'Информация о движении денежных средств в разрезе организаций и статей движения (по месяцам)'");
	
	НастройкиВариантаОборотДДСПоМагазинам = ВариантыОтчетов.ОписаниеВарианта(Настройки, НастройкиОтчета, "ОборотДДСПоМагазинам");
	НастройкиВариантаОборотДДСПоМагазинам.ВидимостьПоУмолчанию = Ложь;
	НастройкиВариантаОборотДДСПоМагазинам.Описание =
		НСтр("ru = 'Информация о движении денежных средств в разрезе магазинов и статей движения'");
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
