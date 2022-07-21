#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

// Инициализирует таблицы значений, содержащие данные табличных частей документа.
// Таблицы значений сохраняет в свойствах структуры "ДополнительныеСвойства".
//
Процедура ИнициализироватьДанныеДокумента(Ссылка, ДополнительныеСвойства) Экспорт

	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	СписаниеПроданныхПодарочныхСертификатовПодарочныеСертификаты.НомерСтроки КАК НомерСтроки,
	|	СписаниеПроданныхПодарочныхСертификатовПодарочныеСертификаты.Ссылка.Дата КАК ПериодДокумента,
	|	СписаниеПроданныхПодарочныхСертификатовПодарочныеСертификаты.ПодарочныйСертификат КАК ПодарочныйСертификат,
	|	СписаниеПроданныхПодарочныхСертификатовПодарочныеСертификаты.СерийныйНомер КАК СерийныйНомер,
	|	СписаниеПроданныхПодарочныхСертификатовПодарочныеСертификаты.Остаток КАК ОстатокСертификата
	|ПОМЕСТИТЬ ПодарочныеСертификаты
	|ИЗ
	|	Документ.СписаниеПроданныхПодарочныхСертификатов.ПодарочныеСертификаты КАК СписаниеПроданныхПодарочныхСертификатовПодарочныеСертификаты
	|ГДЕ
	|	СписаниеПроданныхПодарочныхСертификатовПодарочныеСертификаты.Ссылка = &Ссылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВременнаяТаблицаПодарочныеСертификаты.ПодарочныйСертификат КАК ПодарочныйСертификат,
	|	ВременнаяТаблицаПодарочныеСертификаты.СерийныйНомер КАК СерийныйНомер,
	|	МАКСИМУМ(ДвиженияСерийныхНомеров.Период) КАК Период,
	|	ВременнаяТаблицаПодарочныеСертификаты.ПериодДокумента КАК ПериодДокумента
	|ПОМЕСТИТЬ ПоследниеДвиженияСерийныхНомеров
	|ИЗ
	|	ПодарочныеСертификаты КАК ВременнаяТаблицаПодарочныеСертификаты
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ДвиженияСерийныхНомеров КАК ДвиженияСерийныхНомеров
	|		ПО ВременнаяТаблицаПодарочныеСертификаты.ПодарочныйСертификат = ДвиженияСерийныхНомеров.Номенклатура
	|			И ВременнаяТаблицаПодарочныеСертификаты.СерийныйНомер = ДвиженияСерийныхНомеров.СерийныйНомер
	|
	|СГРУППИРОВАТЬ ПО
	|	ВременнаяТаблицаПодарочныеСертификаты.ПодарочныйСертификат,
	|	ВременнаяТаблицаПодарочныеСертификаты.СерийныйНомер,
	|	ВременнаяТаблицаПодарочныеСертификаты.ПериодДокумента
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ПоследниеДвиженияСерийныхНомеров.ПериодДокумента КАК Период,
	|	ПоследниеДвиженияСерийныхНомеров.ПодарочныйСертификат КАК Номенклатура,
	|	ПоследниеДвиженияСерийныхНомеров.СерийныйНомер КАК СерийныйНомер,
	|	1 КАК Количество,
	|	ЗНАЧЕНИЕ(Справочник.АналитикаХозяйственныхОпераций.ПогашениеПодарочныхСертификатов) КАК АналитикаХозяйственнойОперации,
	|	ВЫБОР
	|		КОГДА НЕ ДвиженияСерийныхНомеров.Отправитель = ЗНАЧЕНИЕ(Справочник.Склады.ПустаяСсылка)
	|			ТОГДА ДвиженияСерийныхНомеров.Отправитель
	|		КОГДА НЕ ДвиженияСерийныхНомеров.Получатель = ЗНАЧЕНИЕ(Справочник.Склады.ПустаяСсылка)
	|			ТОГДА ДвиженияСерийныхНомеров.Получатель
	|	КОНЕЦ КАК Получатель,
	|	ДвиженияСерийныхНомеров.Организация КАК Организация
	|ИЗ
	|	ПоследниеДвиженияСерийныхНомеров КАК ПоследниеДвиженияСерийныхНомеров
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.ДвиженияСерийныхНомеров КАК ДвиженияСерийныхНомеров
	|		ПО ПоследниеДвиженияСерийныхНомеров.Период = ДвиженияСерийныхНомеров.Период
	|			И ПоследниеДвиженияСерийныхНомеров.ПодарочныйСертификат = ДвиженияСерийныхНомеров.Номенклатура
	|			И ПоследниеДвиженияСерийныхНомеров.СерийныйНомер = ДвиженияСерийныхНомеров.СерийныйНомер
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ПодарочныеСертификаты.ПериодДокумента КАК Период,
	|	ЗНАЧЕНИЕ(ВидДвиженияНакопления.Расход) КАК ВидДвижения,
	|	ПодарочныеСертификаты.ПодарочныйСертификат КАК ПодарочныйСертификат,
	|	ПодарочныеСертификаты.СерийныйНомер КАК НомерСертификата,
	|	ПодарочныеСертификаты.ОстатокСертификата КАК Сумма
	|ИЗ
	|	ПодарочныеСертификаты КАК ПодарочныеСертификаты
	|ГДЕ
	|	ПодарочныеСертификаты.ОстатокСертификата > 0
	|	И (ПодарочныеСертификаты.ПодарочныйСертификат.ЧастичноеПогашение
	|			ИЛИ ПодарочныеСертификаты.ПодарочныйСертификат.ПроизвольныйНоминал)";
	
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	
	МассивРезультатов = Запрос.ВыполнитьПакет();
	
	ДополнительныеСвойства.ТаблицыДляДвижений.Вставить("ТаблицаСерийныхНомеров", МассивРезультатов[2].Выгрузить());
	ДополнительныеСвойства.ТаблицыДляДвижений.Вставить("ТаблицаПодарочныхСертификатов", МассивРезультатов[3].Выгрузить());
	
КонецПроцедуры // ИнициализироватьДанныеДокумента()

#КонецЕсли