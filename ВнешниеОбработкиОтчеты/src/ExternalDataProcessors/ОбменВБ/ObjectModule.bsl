#Область СлужебныеНастройкиОбработки

Функция СведенияОВнешнейОбработке() Экспорт

	РегистрационныеДанные = Новый Структура;
	РегистрационныеДанные.Вставить("Наименование", "Рабочее место Wildberries");
	РегистрационныеДанные.Вставить("БезопасныйРежим", Ложь);
	РегистрационныеДанные.Вставить("Версия", "1.0.0");
	РегистрационныеДанные.Вставить("Публикация", "Используется");

	РегистрационныеДанные.Вставить("Вид", "ДополнительнаяОбработка");
	РегистрационныеДанные.Вставить("Информация", "Модуль обмена данными с Wildberries");
 
	ТЗКоманд = Новый ТаблицаЗначений;
	ТЗКоманд.Колонки.Добавить("Идентификатор");
	ТЗКоманд.Колонки.Добавить("Представление");
	ТЗКоманд.Колонки.Добавить("Модификатор");
	ТЗКоманд.Колонки.Добавить("ПоказыватьОповещение");
	ТЗКоманд.Колонки.Добавить("Использование");

	СтрокаКоманды = тзКоманд.Добавить();
	СтрокаКоманды.Идентификатор = "ОткрытиеФормыWildberries";
	СтрокаКоманды.Представление = "Рабочее место Wildberries";
	СтрокаКоманды.ПоказыватьОповещение = Истина;
	СтрокаКоманды.Использование = "ОткрытиеФормы";
	

	РегистрационныеДанные.Вставить("Команды", ТЗКоманд);

	Возврат РегистрационныеДанные;
КонецФункции//СведенияОВнешнейОбработке()

Процедура ВыполнитьКоманду(ИдентификаторКоманды, ПараметрыВыполненияКоманды = Неопределено) Экспорт

	Если Не ИдентификаторКоманды = "ОткрытиеФормыWildberries" Тогда
		ВосстановитьНастройкиВМодуле();
	КонецЕсли;

КонецПроцедуры

Процедура ВосстановитьНастройкиВМодуле() Экспорт

	КлючОбъекта  = "РабочееМестоWBДеловыеСистемы";
	МассивИменНастроек = ПолучитьМассивИменНастроек();

	Для Каждого ИмяНастройки Из МассивИменНастроек Цикл

		Попытка

			ЗначениеИзХранилища = ХранилищеОбщихНастроек.Загрузить(КлючОбъекта, ИмяНастройки);
			Если Не ЗначениеИзХранилища = Неопределено Тогда
				ЭтотОбъект[ИмяНастройки] = ЗначениеИзХранилища;
			КонецЕсли;

		Исключение

		КонецПопытки;
	КонецЦикла;
	
	Если Не ЗначениеЗаполнено(АдресСервисаAPIv1) Тогда
		АдресСервисаAPIv1 = "suppliers-stats.wildberries.ru";
	КонецЕсли;

	Если Не ЗначениеЗаполнено(АдресСервисаAPIv2) Тогда
		АдресСервисаAPIv2 = "suppliers-api.wildberries.ru";
	КонецЕсли;

	ДатаПоГлубинеОтбораДней();
	
	ВремяОтлежкиЗаказа = 15;

КонецПроцедуры

Процедура СохранитьНастройкиВМодуле() Экспорт

	КлючОбъекта  = "РабочееМестоWBДеловыеСистемы";
	МассивИменНастроек = ПолучитьМассивИменНастроек();

	Для Каждого ИмяНастройки Из МассивИменНастроек Цикл
		ХранилищеОбщихНастроек.Сохранить(КлючОбъекта, ИмяНастройки, ЭтотОбъект[ИмяНастройки]);
	КонецЦикла;

КонецПроцедуры

Функция ПолучитьМассивИменНастроек()

	Массив = Новый Массив;

	Массив.Добавить("АдресСервисаAPIv2");
	Массив.Добавить("АдресСервисаAPIv1");
	Массив.Добавить("ТокенAPIv2");
	Массив.Добавить("ТокенAPIv1");
	Массив.Добавить("КонтрагентДляПривязкиТоваров");
	Массив.Добавить("НеУчитыватьПоследнийСимволАртикулаWB");
	Массив.Добавить("ГлубинаОтбораДней");

	Возврат Массив;

КонецФункции // ()

#КонецОбласти

#Область РаботаСДаннымиФормы

Процедура ЗаполнитьСопоставлениеНоменклатуры() Экспорт

	Если Не ЗначениеЗаполнено(КонтрагентДляПривязкиТоваров) Тогда
		ПоказатьОшибку("В настройках не указан контрагент для привязки товаров. Привязка невозможна");
		Возврат;
	КонецЕсли;

	СтруктураТовары = ПолучитьТоварыНаWB();

	Если СтруктураТовары.УспехЗапроса Тогда
		
		//Подготовим запросы
		ЗапросНомКонтрагентов =	ЗапросПоНоменклатуреКонтрагентов();
		ЗапросНомКонтрагентов.УстановитьПараметр("Владелец", КонтрагентДляПривязкиТоваров);
		ЗапросВсеТовары = ЗапросПоВсейНоменклатуре();

		СопоставлениеНоменклатуры.Очистить();
		Для Каждого стрWB Из СтруктураТовары.Результат.stocks Цикл

			тчСтрока = СопоставлениеНоменклатуры.Добавить();
			тчСтрока.АртикулWB = стрWB.article;
			тчСтрока.НаименованиеWB = стрWB.name;
			тчСтрока.ШтрихкодWB = стрWB.barcode;
			тчСтрока.БрендWB = стрWB.brand;
			тчСтрока.КатегорияWB = стрWB.subject;
			тчСтрока.IDНоменклатурыWB = Формат(стрWB.nmId, "ЧГ="); 
			
			// Сначала поищем среди уже привязанных товаров
			ЗапросНомКонтрагентов.УстановитьПараметр("Идентификатор", тчСтрока.IDНоменклатурыWB);
			ЗапросНомКонтрагентов.УстановитьПараметр("ШтрихкодКомбинации", стрWB.barcode);
			//@skip-check query-in-loop
			Выборка = ЗапросНомКонтрагентов.Выполнить().Выбрать();

			Если Выборка.Следующий() Тогда
				тчСтрока.Привязано = Истина;
				тчСтрока.Номенклатура = Выборка.Номенклатура;
				тчСтрока.Артикул1с = Выборка.Номенклатура.Артикул;
				Продолжить;
			КонецЕсли;
			
			//Не нашли? Тогда ищем по артикулу среди непривязанных

			Если НеУчитыватьПоследнийСимволАртикулаWB Тогда
				Артикул = Лев(стрWB.article, СтрДлина(стрWB.article) - 1);
				//Дополнение дефисом
				Если СтрНайти(Артикул, "-", , 4, 1) = 0 Тогда
					Артикул = Лев(Артикул, 3) + "-" + Прав(Артикул, СтрДлина(Артикул) - 3);
				КонецЕсли;
			Иначе
				Артикул = стрWB.article;
			КонецЕсли;
			ЗапросВсеТовары.УстановитьПараметр("Артикул", Артикул);
			
			//@skip-check query-in-loop
			Выборка = ЗапросВсеТовары.Выполнить().Выбрать();

			Если Выборка.Следующий() Тогда
				тчСтрока.Номенклатура = Выборка.Номенклатура;
				тчСтрока.Артикул1с = Выборка.Номенклатура.Артикул;
			КонецЕсли;

		КонецЦикла;
	КонецЕсли;

КонецПроцедуры

Процедура ЗаполнитьТаблицуЗаказов() Экспорт

	Если Не ЗначениеЗаполнено(НачальнаяДата) Тогда
		ПоказатьОшибку("Не указана дата начала выборки заказов с Wildberries");
		Возврат;
	КонецЕсли;

	Если Не ЗначениеЗаполнено(КонтрагентДляПривязкиТоваров) Тогда
		ПоказатьОшибку("В настройках не указан контрагент для привязки товаров. Привязка невозможна");
		Возврат;
	КонецЕсли;

	СтруктураЗаказы = ПолучитьЗаказыНаWBv1();

	Если СтруктураЗаказы.УспехЗапроса Тогда

		ЗаказыWB.Очистить();
		ТоварыПоЗаказуWB.Очистить();
			
		//Чуток производительности
		ПоследнийIDЗаказа = "";
		ПоследнийЗаказ = Неопределено;
		ПоследнийШтрихкод = "";
		ПоследняяНоменклатура = Неопределено;
		ЗапросПривязНомен = ЗапросПоНоменклатуреКонтрагентов();
		ЗапросПривязНомен.УстановитьПараметр("Владелец", КонтрагентДляПривязкиТоваров);
	

		Для Каждого Заказ Из СтруктураЗаказы.Результат Цикл

			Если Заказ.isCancel Тогда
				Продолжить;
			КонецЕсли;
			
			ДатаЗаказа = ДатаИзRFC3339(Заказ.date);
			
			Если ДатаЗаказа < ТекущаяДатаСеанса() + ВремяОтлежкиЗаказа*60 Тогда
				Продолжить;
			КонецЕсли;
			

			стрТЧ = ЗаказыWB.Добавить();
			стрТЧ.ДатаЗаказаWB = ДатаИзRFC3339(Заказ.date);
			стрТЧ.IdЗаказаWB = Заказ.gNumber;
			стрТЧ.IdПозицииWB = ?(ЗначениеЗаполнено(Заказ.odid),Заказ.odid ,Заказ.srid);
			
			Если ПоследнийIDЗаказа = Заказ.gNumber Тогда
				стрТЧ.Заказ1с = ПоследнийЗаказ;
			Иначе
				стрТЧ.Заказ1с = НайтиЗаказВ1с(стрТЧ.IdЗаказаWB);
				ПоследнийЗаказ = стрТЧ.Заказ1с;
				ПоследнийIDЗаказа = Заказ.gNumber;
			КонецЕсли;
			стрТЧ.СуммаТовараWB = Заказ.totalPrice - Заказ.totalPrice / 100 * Заказ.discountPercent;
			стрТЧ.ТоварWB = Заказ.subject + ", " + Заказ.brand + ", Арт." + Заказ.supplierArticle;
			стрТЧ.СкладWB = Заказ.warehouseName;
			стрТЧ.СтикерТовараWB = Заказ.sticker;
			стрТЧ.АртикулWB = Заказ.supplierArticle;
			стрТЧ.ШтрихкодWB = Заказ.barcode;
			Если ПоследнийШтрихкод = Заказ.barcode Тогда
				стрТЧ.Номенклатура = ПоследняяНоменклатура;
			Иначе
				ЗапросПривязНомен.УстановитьПараметр("ШтрихкодКомбинации", Заказ.barcode);
				Выборка = ЗапросПривязНомен.Выполнить().Выбрать();
				Если Выборка.Следующий() Тогда
					стрТЧ.Номенклатура =   Выборка.Номенклатура;
					ПоследняяНоменклатура = Выборка.Номенклатура;
					ПоследнийШтрихкод = Заказ.barcode;
				КонецЕсли;
			КонецЕсли;
		КонецЦикла;

	КонецЕсли;

КонецПроцедуры

Процедура СоздатьЗаказыПоТЧ() Экспорт

	Если Не ЗначениеЗаполнено(КонтрагентДляПривязкиТоваров) Тогда
		ПоказатьОшибку("Не указан контрагент для привязки");
		Возврат;
	КонецЕсли; 
	  
		//Вопрос(!). Если мы рассматриваем товары в корзине, как один заказ, тогда данные с WB нужно группировать по orderUID и он же будет его идентификатором
		//Если же каждая позиция в корзине - отдельный заказ, тогда идентификатором будет orderId и группировать ничего не нужно
 
	СгруппированныеЗаказы = ЗаказыWB.Выгрузить(,"IdЗаказаWB");
	СгруппированныеЗаказы.Свернуть("IdЗаказаWB");
 
	Для Каждого ЗаказID Из СгруппированныеЗаказы Цикл

		Если ЗначениеЗаполнено(НайтиЗаказВ1с(ЗаказID.IdЗаказаWB)) Тогда //Спорное решение. Если обработка будет несколькими пользователям, то нельзя допустить задублирования заказов
			Продолжить;
		КонецЕсли;
		ЗаказСсылка = СоздатьЗаказ(ЗаказID.IdЗаказаWB);
		
		//Добавим новый заказ в ТЧ
		Если ЗначениеЗаполнено(ЗаказСсылка) Тогда
			строкиТЧ = ЗаказыWB.НайтиСтроки(новый Структура("IdЗаказаWB",ЗаказID.IdЗаказаWB ));
			Для Каждого стр Из строкиТЧ Цикл
				стр.Заказ1с = ЗаказСсылка;
			КонецЦикла;
		КонецЕсли;
		
	КонецЦикла;
  
КонецПроцедуры

Процедура СвязатьТовары() Экспорт

	Если СопоставлениеНоменклатуры.Количество() = 0 Тогда
		ПоказатьОшибку("Таблица товаров пуста. Сначала заполните ее");
		Возврат;
	КонецЕсли;
	Для Каждого стр Из СопоставлениеНоменклатуры Цикл

		Если Стр.Привязано Или Не ЗначениеЗаполнено(Стр.Номенклатура) Тогда
			Продолжить;
		КонецЕсли;

		МенеджерЗаписи = РегистрыСведений.НоменклатураКонтрагентовБЭД.СоздатьМенеджерЗаписи();
		МенеджерЗаписи.Владелец = КонтрагентДляПривязкиТоваров;
		МенеджерЗаписи.Артикул = стр.АртикулWB;
		МенеджерЗаписи.Идентификатор = стр.IDНоменклатурыWB;
		МенеджерЗаписи.ШтрихкодКомбинации = стр.ШтрихкодWB;
		МенеджерЗаписи.Наименование = стр.НаименованиеWB;
		МенеджерЗаписи.ЕдиницаИзмерения = "нд";
		МенеджерЗаписи.Номенклатура = стр.Номенклатура;

		МенеджерЗаписи.Записать(Истина);
		Стр.Привязано = Истина;

	КонецЦикла;

КонецПроцедуры

Функция ЗапросПоВсейНоменклатуре()
	Перем Запрос;
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	Товары.Ссылка КАК Номенклатура
	|ИЗ
	|	Справочник.Номенклатура КАК Товары
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.НоменклатураКонтрагентовБЭД КАК НоменклатураКонтрагентовБЭД
	|		ПО (НоменклатураКонтрагентовБЭД.Номенклатура = Товары.Ссылка)
	|ГДЕ
	|	НоменклатураКонтрагентовБЭД.Номенклатура ЕСТЬ NULL
	|	И Товары.Артикул = &Артикул";
	Возврат Запрос
КонецФункции

Функция ЗапросПоНоменклатуреКонтрагентов()
	Перем Запрос;
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	НоменклатураКонтрагентовБЭД.Идентификатор КАК Идентификатор,
	|	НоменклатураКонтрагентовБЭД.ШтрихкодКомбинации КАК ШтрихкодКомбинации,
	|	НоменклатураКонтрагентовБЭД.Номенклатура КАК Номенклатура
	|ИЗ
	|	РегистрСведений.НоменклатураКонтрагентовБЭД КАК НоменклатураКонтрагентовБЭД
	|ГДЕ
	|	НоменклатураКонтрагентовБЭД.Владелец = &Владелец
	|	И ВЫБОР
	|		КОГДА НЕ &Идентификатор = НЕОПРЕДЕЛЕНО
	|			ТОГДА НоменклатураКонтрагентовБЭД.Идентификатор = &Идентификатор
	|		ИНАЧЕ ИСТИНА
	|	КОНЕЦ
	|	И ВЫБОР
	|		КОГДА НЕ &ШтрихкодКомбинации = НЕОПРЕДЕЛЕНО
	|			ТОГДА НоменклатураКонтрагентовБЭД.ШтрихкодКомбинации = &ШтрихкодКомбинации
	|		ИНАЧЕ ИСТИНА
	|	КОНЕЦ
	|	И ВЫБОР
	|		КОГДА &ШтрихкодКомбинации = НЕОПРЕДЕЛЕНО
	|		И &Идентификатор = НЕОПРЕДЕЛЕНО
	|			ТОГДА ЛОЖЬ
	|		ИНАЧЕ ИСТИНА
	|	КОНЕЦ";
	
	Запрос.УстановитьПараметр("Идентификатор", Неопределено);
	Запрос.УстановитьПараметр("ШтрихкодКомбинации", Неопределено);
	
	Возврат Запрос
КонецФункции

Процедура ДатаПоГлубинеОтбораДней() Экспорт
	НачальнаяДата = НачалоДня(ТекущаяДатаСеанса()) - ГлубинаОтбораДней * 60 * 60 * 24;
КонецПроцедуры

#КонецОбласти

#Область РаботаСЗаказами1с

Функция НайтиЗаказВ1с(НомерЗаказаНаСайте)

	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ЗаказыПокупателей.Заказ
	|ИЗ
	|	РегистрНакопления.ЗаказыПокупателей КАК ЗаказыПокупателей
	|ГДЕ
	|	ЗаказыПокупателей.Заказ.НомерЗаказаНаСайте = &НомерЗаказаНаСайте";

	Запрос.УстановитьПараметр("НомерЗаказаНаСайте", НомерЗаказаНаСайте);

	РезультатЗапроса = Запрос.Выполнить();

	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();

	Если ВыборкаДетальныеЗаписи.Следующий() Тогда
		Возврат ВыборкаДетальныеЗаписи.Заказ;
	Иначе
		Возврат Документы.ЗаказПокупателя.ПустаяСсылка();
	КонецЕсли;

КонецФункции

Функция СоздатьЗаказ(IDЗаказа)

	ПроводитьДокументы = True;     //ToDo
	СсылкаНаЗаказ = Документы.ЗаказПокупателя.ПустаяСсылка();
	
	ТоварыПоЗаказу = ЗаказыWB.НайтиСтроки(Новый Структура("IdЗаказаWB", IDЗаказа));
	Если ЗначениеЗаполнено(ТоварыПоЗаказу[0].Заказ1с) Тогда
		Возврат ТоварыПоЗаказу[0].Заказ1с;
	КонецЕсли;
	НачатьТранзакцию();
	Попытка
		Док = Документы.ЗаказПокупателя.СоздатьДокумент();
		ЗаполнитьРеквизитыЗаказа(Док, ТоварыПоЗаказу[0]);
		ЗаполнитьСтрокуЗаказа(Док, ТоварыПоЗаказу);
		док.СуммаДокумента = ПолучитьСуммуЗаказанныхСтрок(Док);

		Если ПроводитьДокументы Тогда
			Док.Записать(РежимЗаписиДокумента.Проведение, ?(НачалоДня(Док.Дата) = НачалоДня(ТекущаяДата()),
				РежимПроведенияДокумента.Оперативный, РежимПроведенияДокумента.Неоперативный));
		Иначе
			Док.Записать(РежимЗаписиДокумента.Запись);
		КонецЕсли;

		ЗафиксироватьТранзакцию();
		СсылкаНаЗаказ = Док.Ссылка;
	Исключение
		ПоказатьОшибку(ОписаниеОшибки());
		Если ТранзакцияАктивна() Тогда
			ОтменитьТранзакцию();
		КонецЕсли;
	КонецПопытки;
	
	Возврат СсылкаНаЗаказ;
	
КонецФункции

Процедура ЗаполнитьРеквизитыЗаказа(Док, Шапка)
	
	Док.Дата = ?(Док.ЭтоНовый(),ТекущаяДатаСеанса() , Док.Дата);
	Док.НомерЗаказаНаСайте	= Шапка.IdЗаказаWB; 
	Док.ДатаЗаказаНаСайте	= Шапка.ДатаЗаказаWB; 	

	Док.Контрагент			 = КонтрагентДляПривязкиТоваров;  

	//	Док.ЖелаемаяДатаПродажи    = строкаТЧ.ВремяДоставки;     //ToDo
	док.Статус = 	Перечисления.СтатусыЗаказовПокупателей.Согласован;
	док.ИнтернетЗаказ = Истина;

	Док.Склад	= ПолучитьСкладПоИД(); //Пока нет привязки по ИД, поэтому берется первый попавший же склад	
	Док.Магазин = Док.Склад.Магазин;

	Док.Организация				= ПолучитьОрганизациюПоИД(); ////Пока нет привязки по ИД, поэтому берется первая организация
	Док.ЦенаВключаетНДС			= Истина;

	док.Продавец = Пользователи.ТекущийПользователь();
	Док.АдресДоставки = Шапка.СкладWB; 

	

КонецПроцедуры

Функция ПолучитьСкладПоИД()

	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	Склады.Ссылка КАК Склад
	|ИЗ
	|	Справочник.Склады КАК Склады
	|ГДЕ
	|	НЕ Склады.ЭтоГруппа
	|	И НЕ Склады.ПометкаУдаления";

	РезультатЗапроса = Запрос.Выполнить();

	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();

	Если ВыборкаДетальныеЗаписи.Следующий() Тогда
		Возврат ВыборкаДетальныеЗаписи.Склад;
	КонецЕсли;
	Возврат Справочники.Склады.ПустаяСсылка();

КонецФункции // ПолучитьСкладПоИД()

Функция ПолучитьОрганизациюПоИД()
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	Организации.Ссылка КАК Организация
	|ИЗ
	|	Справочник.Организации КАК Организации
	|ГДЕ
	|	НЕ Организации.ПометкаУдаления";

	РезультатЗапроса = Запрос.Выполнить();

	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();

	Если ВыборкаДетальныеЗаписи.Следующий() Тогда
		Возврат ВыборкаДетальныеЗаписи.Организация;
	КонецЕсли;
	Возврат Справочники.Организации.ПустаяСсылка();
КонецФункции // ПолучитьОрганизациюПоИД()

Функция ПолучитьСуммуЗаказанныхСтрок(Док)
	//функция скопирована из общего модуля конфигурации, во избежании
	//проблем связанных с переименованием общего модуля.	
	СуммаЗаказанныхСтрок = 0;
	НайденныеСтроки = Док.Товары.НайтиСтроки(Новый Структура("Отменено", Ложь));
	Если НайденныеСтроки.Количество() <> 0 Тогда
		Строки = Док.Товары.Выгрузить(НайденныеСтроки, "Сумма");
		Строки.Свернуть( , "Сумма");
		СуммаЗаказанныхСтрок = Строки[0].Сумма;
	КонецЕсли;
	Возврат СуммаЗаказанныхСтрок;
КонецФункции

Процедура ЗаполнитьСтрокуЗаказа(Док, ТоварыПоЗаказу)

	Для Каждого стрДанных Из ТоварыПоЗаказу Цикл

		Если Не ЗначениеЗаполнено(стрДанных.Номенклатура) Тогда
			ВызватьИсключение ("Cтрока " + стрДанных.НомерСтроки + ". " + стрДанных.ТоварWB + 
				 " нет привязанной номенклатуры в 1с.Заказ создать невозможно. Сначала сделайте привязку");
		КонецЕсли;

		СтрДок 								= Док.Товары.Добавить();
		СтрДок.Номенклатура 				= стрДанных.Номенклатура;
		СтрДок.Упаковка 					= стрДанных.Номенклатура.ЕдиницаИзмерения;
		СтрДок.КоличествоУпаковок 			= 1;
		СтрДок.Количество 					= СтрДок.КоличествоУпаковок * ПолучитьКоэффициентУпаковкиОтБазовойЕдиницы(
			СтрДок.Номенклатура, СтрДок.Упаковка);  //ToDo	

		СтрДок.Продавец						= Пользователи.ТекущийПользователь();

		ЗаполнитьСтавкуНДСВСтрокеТЧ(СтрДок, Док.Дата);

		СтрДок.Цена 						= ?(Док.ЦенаВключаетНДС, стрДанных.СуммаТовараWB, стрДанных.СуммаТовараWB
			/ (1 + ПолучитьСтавкуНДС(СтрДок.СтавкаНДС) / 100));

		СтрДок.ПроцентАвтоматическойСкидки 	= 0;
		СтрДок.СуммаАвтоматическойСкидки 	= 0;

		СтрДок.Резервировать = Истина;

		СтрДок.Сумма = стрДанных.СуммаТовараWB;
		СтрДок.СуммаНДС = РассчитатьСуммуНДС(СтрДок.Сумма, СтрДок.СтавкаНДС);
		СтрДок.Сумма	= ?(Док.ЦенаВключаетНДС, СтрДок.Сумма, СтрДок.Сумма - СтрДок.СуммаНДС);

		Если СтрДок.Упаковка = СтрДок.Номенклатура.ЕдиницаИзмерения Тогда
			СтрДок.Упаковка = Неопределено;
		КонецЕсли;
		СтрДок.IDПозицииWB = стрДанных.IdПозицииWB;

	КонецЦикла;
КонецПроцедуры

Функция ПолучитьКоэффициентУпаковкиОтБазовойЕдиницы(Номенклатура, Упаковка)
	//товар продан в Упаковка, которая может быть либо упаковкой, либо одной из единиц
	//необходимо вернуть коэффициент сколько единиц хранения включено в Упаковку	
	Коэффициент = 1;	
	//у номенклатуры только единица хранения и упаковки,
	Если Упаковка = Номенклатура.ЕдиницаИзмерения Тогда
	Иначе
		Коэффициент = ?(Упаковка.Пустая(), 1, Упаковка.Коэффициент);
	КонецЕсли;

	Возврат Коэффициент;

КонецФункции

Процедура ЗаполнитьСтавкуНДСВСтрокеТЧ(ТекущаяСтрока, ДатаДокумента)

	СтавкаНДС = ТекущаяСтрока.Номенклатура.СтавкаНДС;
	СкорректироватьСтавкуНДС(СтавкаНДС, ДатаДокумента);
	ТекущаяСтрока.СтавкаНДС = СтавкаНДС;

КонецПроцедуры

// Заменяет переданную ставку НДС на актуальную на указанную дату.
//
// Параметры:
//  СтавкаНДС - ПеречислениеСсылка.СтавкиНДС - значение ставки НДС, которое необходимо скорректировать
//  Дата - Дата - дата на которую необходимо получить актуальную ставку НДС.
//
// Возвращаемое значение:
//  Булево - Истина, если значение ставки НДС было заменено.
//
Функция СкорректироватьСтавкуНДС(СтавкаНДС, Дата)

	Результат = Ложь;

	Если Метаданные.Перечисления.СтавкиНДС.ЗначенияПеречисления.Найти("НДС20") <> Неопределено Тогда
		Если СтавкаНДС = Перечисления.СтавкиНДС.НДС18 Или СтавкаНДС = Перечисления.СтавкиНДС.НДС18_118 Или СтавкаНДС
			= Перечисления.СтавкиНДС.НДС20 Или СтавкаНДС = Перечисления.СтавкиНДС.НДС20_120 Тогда
			СтавкаНДСПоУмолчанию = СтавкаНДСПоУмолчанию(Дата, СтавкаНДС = Перечисления.СтавкиНДС.НДС18_118
				Или СтавкаНДС = Перечисления.СтавкиНДС.НДС20_120);
			Если СтавкаНДС <> СтавкаНДСПоУмолчанию Тогда
				СтавкаНДС = СтавкаНДСПоУмолчанию;
				Результат = Истина;
			КонецЕсли;
		КонецЕсли;
	Иначе
		Если СтавкаНДС = Перечисления.СтавкиНДС.НДС18 Или СтавкаНДС = Перечисления.СтавкиНДС.НДС18_118 Тогда
			СтавкаНДСПоУмолчанию = СтавкаНДСПоУмолчанию(Дата, СтавкаНДС = Перечисления.СтавкиНДС.НДС18_118);
			Если СтавкаНДС <> СтавкаНДСПоУмолчанию Тогда
				СтавкаНДС = СтавкаНДСПоУмолчанию;
				Результат = Истина;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;

	Возврат Результат;

КонецФункции

Функция РассчитатьСуммуНДС(Сумма, СтавкаНДС, ЦенаВключаетНДС = Истина)
	ПроцентНДС = ПолучитьСтавкуНДС(СтавкаНДС) / 100;
	Если ЦенаВключаетНДС Тогда
		СуммаНДС = Сумма * ПроцентНДС / (ПроцентНДС + 1);
	Иначе
		СуммаНДС = Сумма * ПроцентНДС;
	КонецЕсли;
	Возврат СуммаНДС;
КонецФункции

Функция ПолучитьСтавкуНДС(СтавкаНДС)
	Если СтавкаНДС = Перечисления.СтавкиНДС.НДС10 Или СтавкаНДС = Перечисления.СтавкиНДС.НДС10_110 Тогда
		Возврат 10;
	ИначеЕсли СтавкаНДС = Перечисления.СтавкиНДС.НДС18 Или СтавкаНДС = Перечисления.СтавкиНДС.НДС18_118 Тогда
		Возврат 18;
	ИначеЕсли Метаданные.Перечисления.СтавкиНДС.ЗначенияПеречисления.Найти("НДС20") <> Неопределено И (СтавкаНДС
		= Перечисления.СтавкиНДС.НДС20 Или СтавкаНДС = Перечисления.СтавкиНДС.НДС20_120) Тогда
		Возврат 20;
	КонецЕсли;
	Возврат 0;
КонецФункции

// Возвращает значение ставки НДС по умолчанию.
//
// Параметры:
//  Дата - Дата - дата на которую необходимо получить ставку НДС по умолчанию,
//               если дата пустая, то будет получена ставка НДС на текущую дату
//  РасчетнаяСтавка - Булево - указывает необходимость получения расчетной ставки НДС X/(100 + X).
//
// Возвращаемое значение:
//  ПеречислениеСсылка.СтавкиНДС - значение ставки НДС.
//
Функция СтавкаНДСПоУмолчанию(Дата = Неопределено, РасчетнаяСтавка = Ложь) Экспорт

	ДатаПолучения = ?(ЗначениеЗаполнено(Дата), Дата, ТекущаяДатаСеанса());

	Если ДатаПолучения >= '20190101' И Метаданные.Перечисления.СтавкиНДС.ЗначенияПеречисления.Найти("НДС20")
		<> Неопределено Тогда
		Возврат ?(РасчетнаяСтавка, Перечисления.СтавкиНДС.НДС20_120, Перечисления.СтавкиНДС.НДС20);
	Иначе
		Возврат ?(РасчетнаяСтавка, Перечисления.СтавкиНДС.НДС18_118, Перечисления.СтавкиНДС.НДС18);
	КонецЕсли;

КонецФункции

#КонецОбласти

#Область РаботаСapi

Функция ПолучитьТоварыНаWB()

	Заголовки = ЗаголовкиПоУмолчанию();
	Заголовки.Вставить("Authorization", ТокенAPIv2);
	ЗаготовкаАдресРесурса = "/api/v2/stocks?";
	Ответ = ОтправитьЗапросСПагинацией("GET", ЗаготовкаАдресРесурса, "stocks", 100);
	ПроверитьОтветНаОшибки(Ответ);
	Возврат Ответ;

КонецФункции

Функция ПолучитьЗаказыНаWBv2()

	ДатаНачало = ДатаRFC3339Кодированная(НачальнаяДата);
	ЗаготовкаАдресРесурса = "/api/v2/orders?date_start=" + ДатаНачало + "&";
	Ответ = ОтправитьЗапросСПагинацией("GET", ЗаготовкаАдресРесурса, "orders", 1000);
	ПроверитьОтветНаОшибки(Ответ);
	Возврат Ответ;

КонецФункции

Функция ПолучитьЗаказыНаWBv1()
	Заголовки = ЗаголовкиПоУмолчанию();
	Заголовки.Вставить("ApiKey", ТокенAPIv1);

	ДатаНачало = ДатаRFC3339Кодированная(НачальнаяДата);
	АдресРесурса = "/api/v1/supplier/orders?key=" + ТокенAPIv1 + "&dateFrom=" + ДатаНачало;
	Ответ = ЗапросНаСерверWB("GET", АдресСервисаAPIv1, АдресРесурса, Заголовки);
	ПроверитьОтветНаОшибки(Ответ);
	Возврат Ответ;
КонецФункции

Функция ОтправитьЗапросСПагинацией(Метод, ЗаготовкаАдресРесурса, ИмяСтруктурыОтвета, Порция = 100)
	
	//Определим версию API 
	Если СтрНайти(ЗаготовкаАдресРесурса, "/api/v2/") > 0 Тогда
		ХедерПоляТокен = "Authorization";
		Токен = ТокенAPIv2;
		АдресСервера = АдресСервисаAPIv2;
	Иначе
		ХедерПоляТокен = "ApiKey";
		Токен = ТокенAPIv1;
		АдресСервера = АдресСервисаAPIv1;
	КонецЕсли;

	Заголовки = ЗаголовкиПоУмолчанию();
	Заголовки.Вставить(ХедерПоляТокен, Токен);

	Получено = 0;
	Добрать = 1;
	АдресРесурса = ЗаготовкаАдресРесурса + "skip=" + Получено + "&take=" + Добрать;
	ГлавныйОтвет = ЗапросНаСерверWB("GET", АдресСервера, АдресРесурса, Заголовки);

	Если ГлавныйОтвет.УспехЗапроса Тогда

		Получено = Добрать;
		ВсегоДанных = 	ГлавныйОтвет.Результат.Total;
		Добрать = ?(ВсегоДанных < Порция, ВсегоДанных - Получено, Порция);

		Пока Добрать > 0 Цикл

			АдресРесурса = ЗаготовкаАдресРесурса + "skip=" + Получено + "&take=" + Добрать;
			Ответ = ЗапросНаСерверWB("GET", АдресСервера, АдресРесурса, Заголовки);

			Если Ответ.УспехЗапроса Тогда
				Получено = Получено + Добрать;
				ОстатокКДобору = ВсегоДанных - Получено;
				Добрать = ?(ОстатокКДобору < Добрать, ОстатокКДобору, Добрать);
				ОбщегоНазначенияКлиентСервер.ДополнитьМассив(ГлавныйОтвет.Результат[ИмяСтруктурыОтвета],
					Ответ.Результат[ИмяСтруктурыОтвета], Истина);
			Иначе
				ПоказатьОшибку(Ответ.Результат.errorText);
				ГлавныйОтвет.УспехЗапроса = Ложь;
				Прервать;
			КонецЕсли;

		КонецЦикла;

	Иначе
		ПоказатьОшибку(ГлавныйОтвет.Результат.errorText);
	КонецЕсли;

	Возврат ГлавныйОтвет;
КонецФункции
#КонецОбласти

#Область ВспомогательныеМетоды

Процедура ПроверитьОтветНаОшибки(Ответ)
	Если НЕ Ответ.УспехЗапроса Тогда
		ПоказатьОшибку(Ответ.Результат.errorText);
	КонецЕсли;
КонецПроцедуры

Функция ДатаИзRFC3339(ДатаСтрока)
	ДатаСтрока = СтрЗаменить(ДатаСтрока, "T", "");
	ДатаСтрока = СтрЗаменить(ДатаСтрока, "-", "");
	ДатаСтрока = СтрЗаменить(ДатаСтрока, ":", "");
	НачПозицияМС = СтрНайти(ДатаСтрока, ".");
	Если НачПозицияМС > 0 Тогда
		ДатаСтрока = Лев(ДатаСтрока, НачПозицияМС - 1);	
	КонецЕсли;
	Возврат Дата(ДатаСтрока);
КонецФункции

Функция ДатаRFC3339Кодированная(Дата)
	ДатаСтрока = Формат(Дата, "ДФ=yyyy-MM-ddTчч:мм:сс+03:00;");
	Возврат КодироватьСтроку(ДатаСтрока, СпособКодированияСтроки.КодировкаURL);
КонецФункции

Процедура ПоказатьОшибку(Текст)
	Сообщение = Новый СообщениеПользователю;
	Сообщение.Текст = Текст;
	Сообщение.УстановитьДанные(ЭтотОбъект);
	Сообщение.Сообщить();
КонецПроцедуры

Процедура ИнициализацияКартыСтатусовWB_1с()
	ТипЧисло = Новый ОписаниеТипов("Число");
	ТипСтрока = Новый ОписаниеТипов("Строка", Новый КвалификаторыСтроки(200));

	КартаСтатусовWB_1с.Колонки.Добавить("СтатусWB", ТипЧисло);
	КартаСтатусовWB_1с.Колонки.Добавить("СтатусWBРасшифровка", ТипСтрока);
	КартаСтатусовWB_1с.Колонки.Добавить("Статус1с", Новый ОписаниеТипов("ПеречислениеСсылка.ds_СтатусыИнтернетЗаказов"));

	КартаСтатусовWB_1с.Добавить().СтатусWB = 0;
	КартаСтатусовWB_1с.Добавить().СтатусWBРасшифровка = "Новый заказ";
	КартаСтатусовWB_1с.Добавить().СтатусWB = Перечисления.ds_СтатусыИнтернетЗаказов.ВПути;

	КартаСтатусовWB_1с.Добавить().СтатусWB = 1;
	КартаСтатусовWB_1с.Добавить().СтатусWBРасшифровка = "Принял заказ";
	КартаСтатусовWB_1с.Добавить().СтатусWB = Перечисления.ds_СтатусыИнтернетЗаказов.ВПути;

	КартаСтатусовWB_1с.Добавить().СтатусWB = 2;
	КартаСтатусовWB_1с.Добавить().СтатусWBРасшифровка = "Сборочное задание завершено";
	КартаСтатусовWB_1с.Добавить().СтатусWB = Перечисления.ds_СтатусыИнтернетЗаказов.ВПути;

	КартаСтатусовWB_1с.Добавить().СтатусWB = 3;
	КартаСтатусовWB_1с.Добавить().СтатусWBРасшифровка = "Сборочное задание отклонено";
	КартаСтатусовWB_1с.Добавить().СтатусWB = Перечисления.ds_СтатусыИнтернетЗаказов.ВПути;

	КартаСтатусовWB_1с.Добавить().СтатусWB = 5;
	КартаСтатусовWB_1с.Добавить().СтатусWBРасшифровка = "На доставке курьером";
	КартаСтатусовWB_1с.Добавить().СтатусWB = Перечисления.ds_СтатусыИнтернетЗаказов.ВПути;

	КартаСтатусовWB_1с.Добавить().СтатусWB = 6;
	КартаСтатусовWB_1с.Добавить().СтатусWBРасшифровка = "Курьер довез и клиент принял товар";
	КартаСтатусовWB_1с.Добавить().СтатусWB = Перечисления.ds_СтатусыИнтернетЗаказов.ВПути;

	КартаСтатусовWB_1с.Добавить().СтатусWB = 7;
	КартаСтатусовWB_1с.Добавить().СтатусWBРасшифровка = "Клиент не принял товар";
	КартаСтатусовWB_1с.Добавить().СтатусWB = Перечисления.ds_СтатусыИнтернетЗаказов.ВПути;

	КартаСтатусовWB_1с.Добавить().СтатусWB = 8;
	КартаСтатусовWB_1с.Добавить().СтатусWBРасшифровка = "Товар для самовывоза из магазина принят к работе";
	КартаСтатусовWB_1с.Добавить().СтатусWB = Перечисления.ds_СтатусыИнтернетЗаказов.ВПути;

	КартаСтатусовWB_1с.Добавить().СтатусWB = 9;
	КартаСтатусовWB_1с.Добавить().СтатусWBРасшифровка = "Товар для самовывоза из магазина готов к выдаче";
	КартаСтатусовWB_1с.Добавить().СтатусWB = Перечисления.ds_СтатусыИнтернетЗаказов.ВПути;
КонецПроцедуры

Процедура ИнициализацияТаблицыТоваров()

	Если ТоварыПоЗаказуWB.Колонки.Количество() > 0 Тогда
		Возврат;
	КонецЕсли;

	ТипСтрока = Новый ОписаниеТипов("Строка", Новый КвалификаторыСтроки(250));
	ТипЧисло = Новый ОписаниеТипов("Число");

	ТоварыПоЗаказуWB.Колонки.Добавить("gNumber", ТипСтрока, "ID заказа (корзина)");
	ТоварыПоЗаказуWB.Колонки.Добавить("barcode", ТипСтрока, "Штрихкод WB");
	ТоварыПоЗаказуWB.Колонки.Добавить("sticker", ТипСтрока, "Стикер для сборки");
	ТоварыПоЗаказуWB.Колонки.Добавить("isCancel", ТипЧисло, "Отменен покупателем");
	ТоварыПоЗаказуWB.Колонки.Добавить("Сумма", ТипЧисло, "Сумма");
	ТоварыПоЗаказуWB.Колонки.Добавить("Сумма", ТипЧисло, "Сумма");
	ТоварыПоЗаказуWB.Колонки.Добавить("Сумма", ТипЧисло, "Сумма");
	ТоварыПоЗаказуWB.Колонки.Добавить("Сумма", ТипЧисло, "Сумма");
	ТоварыПоЗаказуWB.Колонки.Добавить("Сумма", ТипЧисло, "Сумма");
	ТоварыПоЗаказуWB.Колонки.Добавить("Сумма", ТипЧисло, "Сумма");

КонецПроцедуры

Функция МассивСтруктурВТЗ(Данные)
	тзДанные = Новый ТаблицаЗначений;

	Для Каждого ЭлементМассива Из Данные Цикл
		Для Каждого Элемент Из ЭлементМассива Цикл
			тзДанные.Колонки.Добавить(СокрЛП(Элемент.Ключ));
		КонецЦикла;
		Прервать;
	КонецЦикла;

	Для Каждого ЭлементМассива Из Данные Цикл
		Строка = тзДанные.Добавить();
		Для Каждого Элемент Из ЭлементМассива Цикл
			Строка[СокрЛП(Элемент.Ключ)] = СокрЛП(Элемент.Значение);
		КонецЦикла;
	КонецЦикла;

	Возврат тзДанные;
КонецФункции
#КонецОбласти

#Область ПостроительHTTPЗапроса

Функция ЗапросНаСерверWB(Метод, АдресСервиса, АдресРесурса, Заголовки, ДанныеДляJSON = Неопределено)

	Соединение = Новый HTTPСоединение(АдресСервиса, , , , , Истина);

	Запрос = Новый HTTPЗапрос;
	Запрос.АдресРесурса = АдресРесурса;
	Запрос.Заголовки = Заголовки;

	Если ЗначениеЗаполнено(ДанныеДляJSON) Тогда
		// формирование запроса
		ЗаписьJSON = Новый ЗаписьJSON;
		ЗаписьJSON.УстановитьСтроку();
		ЗаписатьJSON(ЗаписьJSON, ДанныеДляJSON);
		ТекстТелаЗапроса = ЗаписьJSON.Закрыть();
		Запрос.УстановитьТелоИзСтроки(ТекстТелаЗапроса);
	КонецЕсли;
	ОтветСтруктурой = ВызватьМетодЗапроса(Запрос, Соединение, Метод);
	Возврат ОтветСтруктурой;

КонецФункции

Функция ВызватьМетодЗапроса(Запрос, Соединение, Метод)
	Попытка

		Если Метод = "DELETE" Тогда
			РезультатЗапрос = Соединение.Удалить(Запрос);
		Иначе
			РезультатЗапрос = Соединение.ВызватьHTTPМетод(Метод, Запрос);
		КонецЕсли;

		РезультатСтрокой = РезультатЗапрос.ПолучитьТелоКакСтроку();

		Если РезультатСтрокой = "Not Found" Тогда
			ВызватьИсключение "На WB нет данных";
		КонецЕсли;

		Чтение = Новый ЧтениеJSON;

		Чтение.УстановитьСтроку(РезультатСтрокой);
		Результат = ПрочитатьJSON(Чтение);
		Если ТипЗнч(Результат) = Тип("Структура") Тогда
			Ошибка = Результат.Свойство("error");
		Иначе
			Ошибка = Ложь;
		КонецЕсли;

	Исключение
		Инфо = ИнформацияОбОшибке();
		Результат = Новый Структура("errorText", Инфо.Описание);
		Ошибка = Истина;
	КонецПопытки;

	ОтветСтруктурой = Новый Структура("Результат,УспехЗапроса", Результат, Не Ошибка);

	Возврат ОтветСтруктурой;

КонецФункции

Функция ЗаголовкиПоУмолчанию()

	Заголовки = Новый Соответствие;
	Заголовки.Вставить("Accept", "application/json");
	Возврат Заголовки;
КонецФункции

#КонецОбласти