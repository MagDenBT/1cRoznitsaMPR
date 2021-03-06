
////////////////////////////////////////////////////////////////////////////////
// Подсистема "Сервис доставки".
// ОбщийМодуль.СервисДоставкиКлиентПереопределяемый.
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Устанавливает имя формы выбора объекта, если она отличается от формы выбора по умолчанию.
//
// Параметры:
//  ИмяОбъекта - Строка - имя объекта метаданных.
//  ИмяФормыВыбора - Строка - полное имя формы выбора объекта. Например, "Документ.ЗаказПокупателя.ФормаВыбора".
//
Процедура УстановитьИмяФормыВыбораОбъектаПоИмени(ИмяОбъекта, ИмяФормыВыбора) Экспорт
	
	СервисДоставкиРТКлиент.УстановитьИмяФормыВыбораОбъектаПоИмени(ИмяОбъекта, ИмяФормыВыбора);
КонецПроцедуры

// Открытие формы нового заказа на доставку, создаваемого на основании переданного объекта
// в параметре "МассивСсылок". Вызывается из подсистемы "ПодключаемыеКоманды".
//
// Параметры:
//  МассивСсылок - Массив из ЛюбаяСсылка - объект или список объектов.
//  ПараметрыВыполнения - см. ПодключаемыеКомандыКлиентСервер.ПараметрыВыполненияКоманды
//
Процедура ЗаказНаДоставкуСоздатьНаОсновании(МассивСсылок, ПараметрыВыполнения) Экспорт
	
	ПараметрыВыполненияКоманды = Новый Структура("Источник, Уникальность, Окно, НавигационнаяСсылка");
	ЗаполнитьЗначенияСвойств(ПараметрыВыполненияКоманды, ПараметрыВыполнения.ОписаниеКоманды.ДополнительныеПараметры);
	
	ПараметрыОткрытия = Новый Структура();
	ПараметрыОткрытия.Вставить("ПараметрыВыполненияКоманды", ПараметрыВыполненияКоманды);
	
	Если ТипЗнч(МассивСсылок) = Тип("Массив") И МассивСсылок.Количество() > 0 Тогда
		ДокументОснование = МассивСсылок[0];
	Иначе
		ДокументОснование = МассивСсылок;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ДокументОснование) Тогда
		ПараметрыОткрытия.Вставить("ДокументОснование", ДокументОснование);
	КонецЕсли;
		
	СервисДоставкиКлиент.ОткрытьФормуКарточкиЗаказаНаДоставку(ПараметрыОткрытия);
	
КонецПроцедуры

// Открытие формы нового заказа на доставку, создаваемого на основании документа.
//
// Параметры:
//  Форма - ФормаКлиентскогоПриложения - Форма документа.
//
Процедура ОткрытьФормуНовогоЗаказаНаДоставку(Форма) Экспорт
	
	// Запись в форме объекта.
	Если Не Форма.Объект.Проведен 
		ИЛИ Форма.Модифицированность Тогда
			
		ТекстВопроса = НСтр("ru = 'Для создания заказа на доставку
			|документ будет проведен. Продолжить?'");
		
		Кнопки = Новый СписокЗначений;
		Кнопки.Добавить(КодВозвратаДиалога.ОК, НСтр("ru = 'Провести и продолжить'"));
		Кнопки.Добавить(КодВозвратаДиалога.Отмена);
		
		Обработчик = Новый ОписаниеОповещения("ПродолжитьВыполнениеКомандыОткрытьФормуНовогоЗаказаНаДоставку", ЭтотОбъект, Форма);
		
		ПоказатьВопрос(Обработчик, ТекстВопроса, Кнопки);
		Возврат;
		
	КонецЕсли;
	
	ЗавершитьВыполнениеКомандыОткрытьФормуНовогоЗаказаНаДоставку(Форма);
	
КонецПроцедуры

// Обработка выбора заказа на доставку из списка выбора заказов.
//
// Параметры:
//  Форма - ФормаКлиентскогоПриложения - Форма документа.
//  ВыбранныйЗаказ - ДанныеФормыЭлементКоллекции, Неопределено - Строка списка заказов.
//  ИмяПроцедурыОбработки - Строка - Имя процедуры обработки выбора заказа в списке заказов.
//
Процедура ОбработатьРезультатВыбораЗаказаНаДоставку(Форма, ВыбранныйЗаказ, ИмяПроцедурыОбработки) Экспорт
	
КонецПроцедуры

// Перейти к списку платежных документов.
//
Процедура ПерейтиКСпискуПлатежныхДокументов() Экспорт
	
КонецПроцедуры

// Открывает форму настроек, если требуется
//
Процедура ОткрытьФормуНастройкиСозданиеПлатежныхДокументов() Экспорт
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

#Область НаложенныеПлатежи

// Заполняет перечень типов документов-оснований, для которых можно оформить оплату доставки наложенным платежом.
//  
// Параметры:
//	КоллекцияТиповДокументов - Массив из ОписаниеТипов
Процедура ТипыОснованийДляНаложенногПлатежа(КоллекцияТиповДокументов) Экспорт
	
КонецПроцедуры

#КонецОбласти

Процедура ЗавершитьВыполнениеКомандыОткрытьФормуНовогоЗаказаНаДоставку(Форма)
	
	ПараметрыОткрытия = Новый Структура();
	
	Если ЗначениеЗаполнено(Форма.Объект.Ссылка) Тогда
		ПараметрыОткрытия.Вставить("ДокументОснование", Форма.Объект.Ссылка);
	КонецЕсли;
		
	СервисДоставкиКлиент.ОткрытьФормуКарточкиЗаказаНаДоставку(ПараметрыОткрытия);
	
КонецПроцедуры

Процедура ПродолжитьВыполнениеКомандыОткрытьФормуНовогоЗаказаНаДоставку(Ответ, Форма) Экспорт
	
	Если Ответ = КодВозвратаДиалога.ОК Тогда
		ОчиститьСообщения();
		
		РежимЗаписи = РежимЗаписиДокумента.Проведение;
		Форма.Записать(Новый Структура("РежимЗаписи", РежимЗаписи));
		
		Если Не Форма.Объект.Проведен 
			ИЛИ Форма.Модифицированность Тогда
			Возврат; // Проведение не удалось, сообщения о причинах выводит платформа.
		КонецЕсли;
	Иначе
		Возврат;
	КонецЕсли;
	
	ЗавершитьВыполнениеКомандыОткрытьФормуНовогоЗаказаНаДоставку(Форма);
	
КонецПроцедуры

#КонецОбласти
