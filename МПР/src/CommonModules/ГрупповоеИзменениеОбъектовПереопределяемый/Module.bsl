///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2022, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Определить объекты метаданных, в формах списков которых
// будут выведены команды объединения дублей и замены ссылок
// см. ПоискИУдалениеДублейКлиент.ОбъединитьВыделенные и ПоискИУдалениеДублейКлиент.ЗаменитьВыделенные
// 
// Параметры:
//  Объекты - Массив из ОбъектМетаданных
//
// Пример:
//	Объекты.Добавить(Метаданные.Справочники._ДемоНоменклатура);
//	Объекты.Добавить(Метаданные.Справочники._ДемоКонтрагенты);
//
Процедура ПриОпределенииОбъектовСКомандойГрупповогоИзмененияОбъектов(Объекты) Экспорт

	

КонецПроцедуры

// Определить объекты метаданных, в модулях менеджеров которых ограничивается возможность 
// редактирования реквизитов при групповом изменении.
//
// Параметры:
//   Объекты - Соответствие из КлючИЗначение - в качестве ключа указать полное имя объекта метаданных,
//                            подключенного к подсистеме "Групповое изменение объектов". 
//                            Дополнительно в значении могут быть перечислены имена экспортных функций:
//                            "РеквизитыНеРедактируемыеВГрупповойОбработке",
//                            "РеквизитыРедактируемыеВГрупповойОбработке".
//                            Каждое имя должно начинаться с новой строки.
//                            Если указано "*", значит, в модуле менеджера определены обе функции.
//
// Пример: 
//   Объекты.Вставить(Метаданные.Документы.ЗаказПокупателя.ПолноеИмя(), "*"); // определены обе функции.
//   Объекты.Вставить(Метаданные.БизнесПроцессы.ЗаданиеСРолевойАдресацией.ПолноеИмя(), "РеквизитыРедактируемыеВГрупповойОбработке");
//   Объекты.Вставить(Метаданные.Справочники.Партнеры.ПолноеИмя(), "РеквизитыРедактируемыеВГрупповойОбработке
//		|РеквизитыНеРедактируемыеВГрупповойОбработке");
//
Процедура ПриОпределенииОбъектовСРедактируемымиРеквизитами(Объекты) Экспорт
	
	Объекты.Вставить(Метаданные.ПланыОбмена.АвтономнаяРабота.ПолноеИмя(), "РеквизитыНеРедактируемыеВГрупповойОбработке");
	Объекты.Вставить(Метаданные.БизнесПроцессы.Задание.ПолноеИмя(), "РеквизитыРедактируемыеВГрупповойОбработке");
	Объекты.Вставить(Метаданные.Задачи.ЗадачаИсполнителя.ПолноеИмя(), "РеквизитыРедактируемыеВГрупповойОбработке");
	Объекты.Вставить(Метаданные.ПланыВидовХарактеристик.ДополнительныеРеквизитыИСведения.ПолноеИмя(), "РеквизитыРедактируемыеВГрупповойОбработке");
	Объекты.Вставить(Метаданные.ПланыВидовХарактеристик.ОбъектыАдресацииЗадач.ПолноеИмя(), "РеквизитыНеРедактируемыеВГрупповойОбработке");
	Объекты.Вставить(Метаданные.Справочники.ВариантыОтчетов.ПолноеИмя(), "РеквизитыРедактируемыеВГрупповойОбработке");
	Объекты.Вставить(Метаданные.Справочники.ВерсииФайлов.ПолноеИмя(), "РеквизитыРедактируемыеВГрупповойОбработке");
	Объекты.Вставить(Метаданные.Справочники.ВидыКонтактнойИнформации.ПолноеИмя(), "РеквизитыНеРедактируемыеВГрупповойОбработке");
	Объекты.Вставить(Метаданные.Справочники.ВидыОплатЧекаККМ.ПолноеИмя(), "РеквизитыНеРедактируемыеВГрупповойОбработке");
	Объекты.Вставить(Метаданные.Справочники.ВнешниеПользователи.ПолноеИмя(), "РеквизитыНеРедактируемыеВГрупповойОбработке");
	Объекты.Вставить(Метаданные.Справочники.ГруппыВнешнихПользователей.ПолноеИмя(), "РеквизитыНеРедактируемыеВГрупповойОбработке");
	Объекты.Вставить(Метаданные.Справочники.ГруппыДоступа.ПолноеИмя(), "РеквизитыНеРедактируемыеВГрупповойОбработке");
	Объекты.Вставить(Метаданные.Справочники.ГруппыИсполнителейЗадач.ПолноеИмя(), "РеквизитыНеРедактируемыеВГрупповойОбработке");
	Объекты.Вставить(Метаданные.Справочники.ДополнительныеОтчетыИОбработки.ПолноеИмя(), "РеквизитыРедактируемыеВГрупповойОбработке");
	Объекты.Вставить(Метаданные.Справочники.Заметки.ПолноеИмя(), "РеквизитыРедактируемыеВГрупповойОбработке");
	Объекты.Вставить(Метаданные.Справочники.ЗначенияСвойствОбъектов.ПолноеИмя(), "РеквизитыРедактируемыеВГрупповойОбработке");
	Объекты.Вставить(Метаданные.Справочники.ЗначенияСвойствОбъектовИерархия.ПолноеИмя(), "РеквизитыРедактируемыеВГрупповойОбработке");
	Объекты.Вставить(Метаданные.Справочники.ИдентификаторыОбъектовМетаданных.ПолноеИмя(), "РеквизитыРедактируемыеВГрупповойОбработке");
	Объекты.Вставить(Метаданные.Справочники.ИнформационныеКарты.ПолноеИмя(), "РеквизитыНеРедактируемыеВГрупповойОбработке");
	Объекты.Вставить(Метаданные.Справочники.КассыККМ.ПолноеИмя(), "РеквизитыРедактируемыеВГрупповойОбработке");
	Объекты.Вставить(Метаданные.Справочники.КлассификаторБанков.ПолноеИмя(), "РеквизитыНеРедактируемыеВГрупповойОбработке");
	Объекты.Вставить(Метаданные.Справочники.Магазины.ПолноеИмя(), "РеквизитыРедактируемыеВГрупповойОбработке");
	Объекты.Вставить(Метаданные.Справочники.НаборыДополнительныхРеквизитовИСведений.ПолноеИмя(), "РеквизитыРедактируемыеВГрупповойОбработке");
	Объекты.Вставить(Метаданные.Справочники.Номенклатура.ПолноеИмя(), "РеквизитыРедактируемыеВГрупповойОбработке, РеквизитыНеРедактируемыеВГрупповойОбработке");
	Объекты.Вставить(Метаданные.Справочники.НоменклатураПрисоединенныеФайлы.ПолноеИмя(), "РеквизитыРедактируемыеВГрупповойОбработке");
	Объекты.Вставить(Метаданные.Справочники.Организации.ПолноеИмя(), "РеквизитыНеРедактируемыеВГрупповойОбработке");
	Объекты.Вставить(Метаданные.Справочники.ПапкиФайлов.ПолноеИмя(), "РеквизитыРедактируемыеВГрупповойОбработке");
	Объекты.Вставить(Метаданные.Справочники.Пользователи.ПолноеИмя(), "РеквизитыНеРедактируемыеВГрупповойОбработке");
	Объекты.Вставить(Метаданные.Справочники.ПользовательскиеНастройкиОтчетов.ПолноеИмя(), "РеквизитыРедактируемыеВГрупповойОбработке");
	Объекты.Вставить(Метаданные.Справочники.ПредопределенныеВариантыОтчетов.ПолноеИмя(), "РеквизитыРедактируемыеВГрупповойОбработке");
	Объекты.Вставить(Метаданные.Справочники.ПрограммыЭлектроннойПодписиИШифрования.ПолноеИмя(), "РеквизитыРедактируемыеВГрупповойОбработке");
	Объекты.Вставить(Метаданные.Справочники.ПрофилиГруппДоступа.ПолноеИмя(), "РеквизитыНеРедактируемыеВГрупповойОбработке");
	Объекты.Вставить(Метаданные.Справочники.РассылкиОтчетов.ПолноеИмя(), "РеквизитыНеРедактируемыеВГрупповойОбработке");
	Объекты.Вставить(Метаданные.Справочники.РолиИсполнителей.ПолноеИмя(), "РеквизитыНеРедактируемыеВГрупповойОбработке");
	Объекты.Вставить(Метаданные.Справочники.СегментыНоменклатуры.ПолноеИмя(), "РеквизитыРедактируемыеВГрупповойОбработке");
	Объекты.Вставить(Метаданные.Справочники.СертификатыКлючейЭлектроннойПодписиИШифрования.ПолноеИмя(), "РеквизитыНеРедактируемыеВГрупповойОбработке");
	Объекты.Вставить(Метаданные.Справочники.СкидкиНаценки.ПолноеИмя(), "РеквизитыРедактируемыеВГрупповойОбработке");
	Объекты.Вставить(Метаданные.Справочники.СообщенияСистемы.ПолноеИмя(), "РеквизитыНеРедактируемыеВГрупповойОбработке");
	Объекты.Вставить(Метаданные.Справочники.СтраныМира.ПолноеИмя(), "РеквизитыНеРедактируемыеВГрупповойОбработке");
	Объекты.Вставить(Метаданные.Справочники.СценарииОбменовДанными.ПолноеИмя(), "РеквизитыНеРедактируемыеВГрупповойОбработке");
	Объекты.Вставить(Метаданные.Справочники.СчетчикиПодсчетаПосетителей.ПолноеИмя(), "РеквизитыРедактируемыеВГрупповойОбработке");
	Объекты.Вставить(Метаданные.Справочники.ТомаХраненияФайлов.ПолноеИмя(), "РеквизитыРедактируемыеВГрупповойОбработке");
	Объекты.Вставить(Метаданные.Справочники.УчетныеЗаписиЭлектроннойПочты.ПолноеИмя(), "РеквизитыРедактируемыеВГрупповойОбработке");
	Объекты.Вставить(Метаданные.Справочники.Файлы.ПолноеИмя(), "РеквизитыРедактируемыеВГрупповойОбработке");
	Объекты.Вставить(Метаданные.Справочники.ФизическиеЛица.ПолноеИмя(), "РеквизитыРедактируемыеВГрупповойОбработке");
	
КонецПроцедуры

#КонецОбласти
