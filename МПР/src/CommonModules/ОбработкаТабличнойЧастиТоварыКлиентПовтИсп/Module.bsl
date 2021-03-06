////////////////////////////////////////////////////////////////////////////////
// ОбработкаТабличнойЧастиТоварыКлиентПовтИсп содержит процедуры и функции 
// для работы с табличными частями товаров документов.
//  
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Возвращает числовое значение ставки НДС по значению перечисления.
//
// Параметры:
//  СтавкаНДС - ПеречислениеСсылка.СтавкиНДС - значение перечисления СтавкиНДС.
//
// Возвращаемое значение:
//  Число - ставка ндс.
//
Функция СтавкаНДСЧислом(Знач СтавкаНДС) Экспорт
	
	Если СтавкаНДС = ПредопределенноеЗначение("Перечисление.СтавкиНДС.НДС10")
		ИЛИ СтавкаНДС = ПредопределенноеЗначение("Перечисление.СтавкиНДС.НДС10_110") Тогда
		
		Возврат 0.1;
	ИначеЕсли СтавкаНДС = ПредопределенноеЗначение("Перечисление.СтавкиНДС.НДС18")
		ИЛИ СтавкаНДС = ПредопределенноеЗначение("Перечисление.СтавкиНДС.НДС18_118") Тогда
		
		Возврат 0.18;
	ИначеЕсли СтавкаНДС = ПредопределенноеЗначение("Перечисление.СтавкиНДС.НДС20")
		ИЛИ СтавкаНДС = ПредопределенноеЗначение("Перечисление.СтавкиНДС.НДС20_120") Тогда
		
		Возврат 0.2;
	Иначе
		Возврат 0;
	КонецЕсли;
	
КонецФункции

#КонецОбласти