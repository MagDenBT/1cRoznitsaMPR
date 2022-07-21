#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Возвращает действующий на указанную дату документ, удостоверяющий личность.
//
// Параметры:
//	Физлицо			- СправочникСсылка.ФизическиеЛица - физическое лицо, для которого необходимо получить документ.
//	Дата			- ДатаВремя - дата, на которую необходимо получить документ.
//
// Возвращаемое значение
//	Строка - представление документа, удостоверяющего личность.
//
Функция ДокументУдостоверяющийЛичностьФизлица(Физлицо, Дата = Неопределено) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Физлицо",	Физлицо);
	Запрос.УстановитьПараметр("ДатаСреза",	Дата);
	
	Запрос.Текст =
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	ДокументыФизическихЛиц.Представление
	|ИЗ
	|	РегистрСведений.ДокументыФизическихЛиц КАК ДокументыФизическихЛиц
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ (ВЫБРАТЬ
	|			МАКСИМУМ(ДокументыФизическихЛиц.Период) КАК Период,
	|			ДокументыФизическихЛиц.Физлицо КАК Физлицо
	|		ИЗ
	|			РегистрСведений.ДокументыФизическихЛиц КАК ДокументыФизическихЛиц
	|		ГДЕ
	|			ДокументыФизическихЛиц.ЯвляетсяДокументомУдостоверяющимЛичность
	|			И ДокументыФизическихЛиц.Физлицо = &Физлицо
	|			" + ?(Дата <> Неопределено, "И ДокументыФизическихЛиц.Период <= &ДатаСреза", "") + "
	|		
	|		СГРУППИРОВАТЬ ПО
	|			ДокументыФизическихЛиц.Физлицо) КАК ДокументыСрез
	|		ПО ДокументыФизическихЛиц.Период = ДокументыСрез.Период
	|			И ДокументыФизическихЛиц.Физлицо = ДокументыСрез.Физлицо
	|			И (ДокументыФизическихЛиц.ЯвляетсяДокументомУдостоверяющимЛичность)";
	Выборка = Запрос.Выполнить().Выбрать();
	
	УдостоверениеЛичности = Новый Структура("Представление, ЕстьУдостоверение");
	
	Если Выборка.Следующий() Тогда
		Возврат Выборка.Представление;
	КонецЕсли;
	
	Возврат "";
	
КонецФункции

// Проверяет, является-ли указанный вид документа документом, удостоверяющим личность для этого физлица.
//
// Параметры:
//	Физлицо			- СправочникСсылка.ФизическиеЛица - физическое лицо, для которого необходимо получить документ.
//	ВидДокумента	- СправочникСсылка.ВидыДокументовФизическихЛиц - вид документа, удостоверяющего личность.
//	Дата			- ДатаВремя - дата, на которую необходимо получить документ.
//
// Возвращаемое значение
//	Является		- булево - является ли указанный вид документа документом, удостоверяющим личность.
//
Функция ЯвляетсяУдостоверениемЛичности(Физлицо, ВидДокумента, Дата) Экспорт
	
	Если Физлицо.Пустая() Или ВидДокумента.Пустая() Или Не ЗначениеЗаполнено(Дата) Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Если ВидДокумента = Справочники.ВидыДокументовФизическихЛиц.ПаспортРФ Тогда
		Возврат Истина;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Физлицо",		Физлицо);
	Запрос.УстановитьПараметр("ВидДокумента",	ВидДокумента);
	Запрос.УстановитьПараметр("ДатаСреза",		Дата);
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	МАКСИМУМ(ДокументыФизическихЛиц.Период) КАК Период,
	|	ДокументыФизическихЛиц.Физлицо КАК Физлицо
	|ПОМЕСТИТЬ ДокументыСрез
	|ИЗ
	|	РегистрСведений.ДокументыФизическихЛиц КАК ДокументыФизическихЛиц
	|ГДЕ
	|	ДокументыФизическихЛиц.Физлицо = &Физлицо
	|	И ДокументыФизическихЛиц.Период < &ДатаСреза
	|	И ДокументыФизическихЛиц.ЯвляетсяДокументомУдостоверяющимЛичность
	|
	|СГРУППИРОВАТЬ ПО
	|	ДокументыФизическихЛиц.Физлицо
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ДокументыФизическихЛиц.ВидДокумента КАК ВидДокумента
	|ИЗ
	|	РегистрСведений.ДокументыФизическихЛиц КАК ДокументыФизическихЛиц
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ДокументыСрез КАК ДокументыСрез
	|		ПО ДокументыФизическихЛиц.Физлицо = ДокументыСрез.Физлицо
	|			И ДокументыФизическихЛиц.Период = ДокументыСрез.Период
	|			И (ДокументыФизическихЛиц.ВидДокумента = &ВидДокумента)";
	Возврат Не Запрос.Выполнить().Пустой();
	
КонецФункции

Функция ДанныеДокументаФизлица(Физлицо, Дата = Неопределено) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Физлицо",	Физлицо);
	Запрос.УстановитьПараметр("ДатаСреза",	Дата);
	
	Запрос.Текст =
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	ДокументыФизическихЛиц.Серия КАК Серия,
	|	ДокументыФизическихЛиц.Номер КАК Номер,
	|	ДокументыФизическихЛиц.Гражданство КАК Гражданство,
	|	ДокументыФизическихЛиц.ВидДокумента КАК ВидДокумента
	|ИЗ
	|	РегистрСведений.ДокументыФизическихЛиц КАК ДокументыФизическихЛиц
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ (ВЫБРАТЬ
	|			МАКСИМУМ(ДокументыФизическихЛиц.Период) КАК Период,
	|			ДокументыФизическихЛиц.Физлицо КАК Физлицо
	|		ИЗ
	|			РегистрСведений.ДокументыФизическихЛиц КАК ДокументыФизическихЛиц
	|		ГДЕ
	|			ДокументыФизическихЛиц.ЯвляетсяДокументомУдостоверяющимЛичность
	|			И ДокументыФизическихЛиц.Физлицо = &Физлицо
	|			" + ?(Дата <> Неопределено, "И ДокументыФизическихЛиц.Период <= &ДатаСреза", "") + "
	|		
	|		СГРУППИРОВАТЬ ПО
	|			ДокументыФизическихЛиц.Физлицо) КАК ДокументыСрез
	|		ПО ДокументыФизическихЛиц.Период = ДокументыСрез.Период
	|			И ДокументыФизическихЛиц.Физлицо = ДокументыСрез.Физлицо
	|			И (ДокументыФизическихЛиц.ЯвляетсяДокументомУдостоверяющимЛичность)";
	Выборка = Запрос.Выполнить().Выбрать();
	
	ДанныеДокумента = Новый Структура("Серия, Номер, Гражданство, ВидДокумента");
	
	Если Выборка.Следующий() Тогда
		ДанныеДокумента.Серия        = Выборка.Серия;
		ДанныеДокумента.Номер        = Выборка.Номер;
		ДанныеДокумента.Гражданство  = Выборка.Гражданство;
		ДанныеДокумента.ВидДокумента = Выборка.ВидДокумента;
	КонецЕсли;
	
	Возврат ДанныеДокумента;
	
КонецФункции

#КонецОбласти

#КонецЕсли
