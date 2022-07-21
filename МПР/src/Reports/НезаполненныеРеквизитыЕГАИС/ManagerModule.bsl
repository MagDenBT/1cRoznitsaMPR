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
	
	НастройкиВарианта = ВариантыОтчетов.ОписаниеВарианта(Настройки, НастройкиОтчета, "Основной");
	НастройкиВарианта.Описание = НСтр("ru='Список номенклатуры с незаполенными обязательными реквизитами,
	|требуемыми для обмена с ЕГАИС.'");
	
	НастройкиВарианта = ВариантыОтчетов.ОписаниеВарианта(Настройки, НастройкиОтчета, "Дополнительный");
	НастройкиВарианта.Размещение.Удалить(Метаданные.Подсистемы.НормативноСправочнаяИнформация.Подсистемы.ЕГАИС);
	НастройкиВарианта.Размещение.Удалить(Метаданные.Подсистемы.ЗапасыИЗакупки.Подсистемы.ЕГАИС);
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли