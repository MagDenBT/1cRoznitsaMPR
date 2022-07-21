#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Инициализирует таблицы значений, содержащие данные документа.
// Таблицы значений сохраняет в свойствах структуры "ДополнительныеСвойства".
//
// Параметры:
//  ДокументСсылка - ДокументСсылка.АктОРасхожденияхПриПриемкеТоваров - документ для инициализации данных.
//  ДополнительныеСвойства - Структура - структура дополнительных свойств.
//
Процедура ИнициализироватьДанныеДокумента(ДокументСсылка, ДополнительныеСвойства) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Ссылка", ДокументСсылка);
	Запрос.Текст ="ВЫБРАТЬ
	|	ДанныеДокумента.Ссылка  КАК Ссылка
	|ИЗ
	|	Документ.РегистрацияПодсчетаПосетителей КАК ДанныеДокумента
	|ГДЕ
	|	ДанныеДокумента.Ссылка = &Ссылка";
	Реквизиты = Запрос.Выполнить().Выбрать();
	Реквизиты.Следующий();
		
	Запрос.УстановитьПараметр("Ссылка", Реквизиты.Ссылка);
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ВложенныйЗапрос.СчетчикПодсчетаПосетителей,
	|	ВложенныйЗапрос.ВремяРегистрации,
	|	ВложенныйЗапрос.КоличествоВходящих,
	|	ВложенныйЗапрос.КоличествоВыходящих,
	|	ВложенныйЗапрос.КоличествоПроходов,
	|	ДОБАВИТЬКДАТЕ(ДОБАВИТЬКДАТЕ(ДОБАВИТЬКДАТЕ(НАЧАЛОПЕРИОДА(ВложенныйЗапрос.Дата, ДЕНЬ), ЧАС, ЧАС(ВложенныйЗапрос.ВремяРегистрации)), МИНУТА, МИНУТА(ВложенныйЗапрос.ВремяРегистрации)), СЕКУНДА, СЕКУНДА(ВложенныйЗапрос.ВремяРегистрации)) КАК Период,
	|	(ВложенныйЗапрос.КоличествоВходящих + ВложенныйЗапрос.КоличествоВыходящих - ВложенныйЗапрос.КоличествоПроходов) / 2 КАК Количество,
	|	ДЕНЬНЕДЕЛИ(ВложенныйЗапрос.Дата) КАК ДеньНедели,
	|	ЧАС(ВложенныйЗапрос.ВремяРегистрации) КАК Час
	|ИЗ
	|	(ВЫБРАТЬ
	|		ВложенныйЗапрос.СчетчикПодсчетаПосетителей КАК СчетчикПодсчетаПосетителей,
	|		ВложенныйЗапрос.ВремяРегистрации КАК ВремяРегистрации,
	|		СУММА(ВложенныйЗапрос.КоличествоВходящих) КАК КоличествоВходящих,
	|		СУММА(ВложенныйЗапрос.КоличествоВыходящих) КАК КоличествоВыходящих,
	|		СУММА(ВложенныйЗапрос.КоличествоПроходов) КАК КоличествоПроходов,
	|		ВложенныйЗапрос.Дата КАК Дата
	|	ИЗ
	|		(ВЫБРАТЬ
	|			ДанныеПодсчета.Ссылка.СчетчикПодсчетаПосетителей КАК СчетчикПодсчетаПосетителей,
	|			ДанныеПодсчета.ВремяРегистрации КАК ВремяРегистрации,
	|			ДанныеПодсчета.КоличествоВходящих КАК КоличествоВходящих,
	|			ДанныеПодсчета.КоличествоВыходящих КАК КоличествоВыходящих,
	|			0 КАК КоличествоПроходов,
	|			ДанныеПодсчета.Ссылка.Дата КАК Дата
	|		ИЗ
	|			Документ.РегистрацияПодсчетаПосетителей.ДанныеПодсчета КАК ДанныеПодсчета
	|		ГДЕ
	|			ДанныеПодсчета.Ссылка = &Ссылка
	|		
	|		ОБЪЕДИНИТЬ ВСЕ
	|		
	|		ВЫБРАТЬ
	|			СтатистикаПодсчета.Ссылка.СчетчикПодсчетаПосетителей,
	|			СтатистикаПодсчета.ВремяРегистрации,
	|			0,
	|			0,
	|			СтатистикаПодсчета.КоличествоПроходов,
	|			СтатистикаПодсчета.Ссылка.Дата
	|		ИЗ
	|			Документ.РегистрацияПодсчетаПосетителей.СтатистикаПодсчетаСотрудников КАК СтатистикаПодсчета
	|		ГДЕ
	|			СтатистикаПодсчета.Ссылка = &Ссылка) КАК ВложенныйЗапрос
	|	
	|	СГРУППИРОВАТЬ ПО
	|		ВложенныйЗапрос.СчетчикПодсчетаПосетителей,
	|		ВложенныйЗапрос.ВремяРегистрации,
	|		ВложенныйЗапрос.Дата) КАК ВложенныйЗапрос
	|ГДЕ
	|	(ВложенныйЗапрос.КоличествоВходящих + ВложенныйЗапрос.КоличествоВыходящих - ВложенныйЗапрос.КоличествоПроходов) / 2 <> 0";
	
	Результат          = Запрос.ВыполнитьПакет();
	ТаблицыДляДвижений = ДополнительныеСвойства.ТаблицыДляДвижений;
	ТаблицыДляДвижений.Вставить("ТаблицаПосетители", Результат[0].Выгрузить());
			
КонецПроцедуры

// Определяет настройки объекта для подсистемы ВерсионированиеОбъектов.
//
// Параметры:
//  Настройки - Структура - настройки подсистемы.
Процедура ПриОпределенииНастроекВерсионированияОбъектов(Настройки) Экспорт
	
КонецПроцедуры

// СтандартныеПодсистемы.УправлениеДоступом

// См. УправлениеДоступомПереопределяемый.ПриЗаполненииСписковСОграничениемДоступа.
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт

	Ограничение.Текст =
	"РазрешитьЧтениеИзменение
	|ГДЕ
	|	ЗначениеРазрешено(Магазин)";

КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

#КонецОбласти

#КонецЕсли
