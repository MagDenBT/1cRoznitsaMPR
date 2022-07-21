#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Инициализирует таблицы значений, содержащие данные табличных частей документа.
// Таблицы значений сохраняет в свойствах структуры "ДополнительныеСвойства".
//
// Параметры:
//  ДокументСсылка - ДокументСсылка.АктОРасхожденияхПриПриемкеТоваров - документ для инициализации данных.
//  ДополнительныеСвойства - Структура - структура дополнительных свойств.
//
Процедура ИнициализироватьДанныеДокумента(ДокументСсылка, ДополнительныеСвойства) Экспорт

	Запрос = Новый Запрос(
	// 0 ТаблицаЦеныНоменклатуры
	"ВЫБРАТЬ
	|	ds_УстановкаКатегорийНоменклатурыТовары.Номенклатура КАК Номенклатура,
	|	ds_УстановкаКатегорийНоменклатурыТовары.Цена КАК Цена,
	|	ds_УстановкаКатегорийНоменклатурыТовары.Ссылка.Категория КАК КатегорияНоменклатуры,
	|	ds_УстановкаКатегорийНоменклатурыТовары.Ссылка.ДатаНачала КАК Период,
	|	ds_УстановкаКатегорийНоменклатурыТовары.Ссылка.ДатаОкончания КАК ДатаОкончания,
	|	ds_УстановкаКатегорийНоменклатурыТовары.Ссылка.Магазин КАК Магазин
	|ИЗ
	|	Документ.ds_УстановкаКатегорийНоменклатуры.Товары КАК ds_УстановкаКатегорийНоменклатурыТовары
	|ГДЕ
	|	ds_УстановкаКатегорийНоменклатурыТовары.Ссылка = &Ссылка");

	Запрос.УстановитьПараметр("Ссылка", ДокументСсылка);
	Результат = Запрос.ВыполнитьПакет();
	
	ДополнительныеСвойства.ТаблицыДляДвижений.Вставить("ТаблицаЦеныНоменклатуры", Результат[0].Выгрузить());

КонецПроцедуры

#КонецОбласти

#КонецЕсли
