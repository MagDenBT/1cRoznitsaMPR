////////////////////////////////////////////////////////////////////////////////
// СкладскиеОперацииКлиентСерверПовтИсп содержит процедуры и функции для работы 
// со складскими операциями и обработки действий пользователя со складскими операциями.
//  
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Получает параметры для анализа пересортицы по умолчанию.
//
// Возвращаемое значение:
//  Массив - массив параметров для анализа пересортицы.
//
Функция МассивПараметровАнализаПересортицыПоУмолчанию() Экспорт
	
	МассивПараметров = Новый Массив;
	МассивПараметров.Добавить(НСтр("ru = 'Одинаковые позиции номенклатуры'"));
	МассивПараметров.Добавить(НСтр("ru = 'Данные предыдущих пересортиц'"));
	МассивПараметров.Добавить(НСтр("ru = 'Наименование одной из позиции включает наименование другой'"));
	МассивПараметров.Добавить(НСтр("ru = 'Совпадение первого слова в наименованиях'"));
	МассивПараметров.Добавить(НСтр("ru = 'Принадлежность к одной группе номенклатуры'"));
	МассивПараметров.Добавить(НСтр("ru = 'Принадлежность к одной товарной группе'"));
	Если АссортиментВызовСервера.ИспользоватьТоварныеКатегорииИКвотыАссортимента() Тогда
		МассивПараметров.Добавить(НСтр("ru = 'Принадлежность к одной товарной категории'"));
	КонецЕсли;
	
	Возврат МассивПараметров;
	
КонецФункции

#КонецОбласти