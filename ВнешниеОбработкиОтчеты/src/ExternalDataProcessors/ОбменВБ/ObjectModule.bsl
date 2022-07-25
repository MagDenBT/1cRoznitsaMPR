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
	
	
//	СтрокаКоманды = тзКоманд.Добавить();
//	СтрокаКоманды.Идентификатор = "ВыгрузкаЗаявокВСервис";
//	СтрокаКоманды.Представление = "Выгрузка заявок в ЛогДеп";
//	СтрокаКоманды.ПоказыватьОповещение = Истина;
//	СтрокаКоманды.Использование = "ВызовСерверногоМетода";
//	
//	СтрокаКоманды = тзКоманд.Добавить();
//	СтрокаКоманды.Идентификатор = "СинхронизацияЗаявокВСервисе";
//	СтрокаКоманды.Представление = "Выгрузка заявок и удаление отмененных в ЛогДепе";
//	СтрокаКоманды.ПоказыватьОповещение = Истина;
//	СтрокаКоманды.Использование = "ВызовСерверногоМетода";
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
		АдресСервисаAPIv1 = "wildberries-tech.github.io";
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(АдресСервисаAPIv2) Тогда
		АдресСервисаAPIv2 = "suppliers-api.wildberries.ru";
	КонецЕсли; 
	
	ПериодЗаказов.Вариант = ВариантСтандартногоПериода.Сегодня;

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
			ЗапросНомКонтрагентов.УстановитьПараметр("Владелец", КонтрагентДляПривязкиТоваров);
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
	
	Если НЕ ЗначениеЗаполнено(ПериодЗаказов.ДатаНачала) ИЛИ НЕ ЗначениеЗаполнено(ПериодЗаказов.ДатаОкончания)  Тогда
		       ПоказатьОшибку("Не указан период выборки заказов с Wildberries");
	           Возврат ;
	КонецЕсли;


	ИнициализацияТаблицыТоваров();
	
	СтруктураЗаказы = ПолучитьЗаказыНаWB();

	Если СтруктураЗаказы.УспехЗапроса Тогда
		
		ЗаказыWB.Очистить();
		ТоварыПоЗаказуWB.Очистить();
		
		//Вопрос(!). Если мы рассматриваем товары в корзине, как один заказ, тогда данные с WB нужно группировать по orderUID и он же будет его идентификатором
		//Если же каждая позиция в корзине - отдельный заказ, тогда идентификатором будет orderId и группировать ничего не нужно
		
		Для Каждого Заказ Из СтруктураЗаказы.Результат.orders Цикл
			
			стрТЧ = ЗаказыWB.Добавить();
			стрТЧ.ДатаЗаказаWB = ДатаИзRFC3339(Заказ.dateCreated);
				
			//поработать над датой
			стрТЧ.СтатусЗаказаWB = Заказ.status;
			стрТЧ.СуммаЗаказаWB = Заказ.convertedPrice; // Вопрос по политике валютных платежей(!). Цена продажи с учетом скидок, сконвертированная в рубли по курсу на момент создания заказа
			стрТЧ.ТипДоставки = Заказ.deliveryType;
						//стрТЧ.Заказ1с = Заказ.аааааа; //ToDo
						//стрТЧ.СуммаЗаказа1с = стрТЧ.Заказ1с.СуммаДокумента; //ToDo
				
			//Складируем инфо по товарам для дальнейщей работы. Здесь та же дилема -  orderUID(Группируем) 	или orderId	(Не группируем)
			Товар = ТоварыПоЗаказуWB.Добавить();
			
			Товар.ЗаказID = Заказ.orderId;
			Товар.ШтрихкодWB = Заказ.barcode;
			Товар.Количество = 1; //ToDo. В данных не прилетают количества товаров. Что с этим делать?
			Товар.Сумма = Заказ.convertedPrice;
			
			
		КонецЦикла;

	КонецЕсли;

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
	|	НоменклатураКонтрагентовБЭД.Идентификатор,
	|	НоменклатураКонтрагентовБЭД.ШтрихкодКомбинации,
	|	НоменклатураКонтрагентовБЭД.Номенклатура
	|ИЗ
	|	РегистрСведений.НоменклатураКонтрагентовБЭД КАК НоменклатураКонтрагентовБЭД
	|ГДЕ
	|	НоменклатураКонтрагентовБЭД.Владелец = &Владелец
	|	И НоменклатураКонтрагентовБЭД.Идентификатор = &Идентификатор
	|	И НоменклатураКонтрагентовБЭД.ШтрихкодКомбинации = &ШтрихкодКомбинации";
	Возврат Запрос
КонецФункции

Процедура ИнициализацияТаблицыТоваров()
	
	Если ТоварыПоЗаказуWB.Колонки.Количество() > 0 Тогда
		Возврат;
	КонецЕсли;
	
	ТипСтрока = новый ОписаниеТипов("Строка", новый КвалификаторыСтроки(255));
	ТипЧисло = новый ОписаниеТипов("Число");
	
	ТоварыПоЗаказуWB.Колонки.Добавить("ЗаказID",ТипСтрока,"ЗаказID" );
	ТоварыПоЗаказуWB.Колонки.Добавить("ШтрихкодWB",ТипСтрока,"ШтрихкодWB");
	ТоварыПоЗаказуWB.Колонки.Добавить("Количество",ТипЧисло,"Количество" );
	ТоварыПоЗаказуWB.Колонки.Добавить("Сумма",ТипЧисло,"Сумма" );
	
КонецПроцедуры

#КонецОбласти

#Область РаботаСapi

Функция ПолучитьТоварыНаWB()

	Заголовки = ЗаголовкиПоУмолчанию();
	Заголовки.Вставить("Authorization", ТокенAPIv2);
	ЗаготовкаАдресРесурса = "/api/v2/stocks?";
	
	Возврат ОтправитьЗапросСПагинацией("GET", ЗаготовкаАдресРесурса, "stocks",100);
	
КонецФункции

Функция ПолучитьЗаказыНаWB()
		
	ДатаНачало = ДатаRFC3339Кодированная(ПериодЗаказов.ДатаНачала);
	ДатаКонец = ДатаRFC3339Кодированная(ПериодЗаказов.ДатаОкончания);
	ЗаготовкаАдресРесурса = "/api/v2/orders?date_start=" + ДатаНачало + "&date_end=" + ДатаКонец  + "&";
	Возврат ОтправитьЗапросСПагинацией("GET", ЗаготовкаАдресРесурса,"orders",1000);
	
КонецФункции

Функция ОтправитьЗапросСПагинацией(Метод,ЗаготовкаАдресРесурса,ИмяСтруктурыОтвета, Порция = 100)

	//Определим версию API 
	Если СтрНайти(ЗаготовкаАдресРесурса,"/api/v2/") > 0 Тогда
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
	ГлавныйОтвет = ЗапросНаСерверWB("GET",АдресСервера, АдресРесурса, Заголовки);
	
	Если ГлавныйОтвет.УспехЗапроса Тогда

		Получено = Добрать;
		ВсегоДанных = 	ГлавныйОтвет.Результат.Total;
		Добрать = ?(ВсегоДанных < Порция, ВсегоДанных - Получено, Порция);

		Пока Добрать > 0 Цикл

			АдресРесурса = ЗаготовкаАдресРесурса + "skip=" + Получено + "&take=" + Добрать;
			Ответ = ЗапросНаСерверWB("GET",АдресСервера, АдресРесурса, Заголовки);

			Если Ответ.УспехЗапроса Тогда
				Получено = Получено + Добрать;
				ОстатокКДобору = ВсегоДанных - Получено;
				Добрать = ?(ОстатокКДобору < Добрать, ОстатокКДобору, Добрать);
				ОбщегоНазначенияКлиентСервер.ДополнитьМассив(ГлавныйОтвет.Результат[ИмяСтруктурыОтвета], Ответ.Результат[ИмяСтруктурыОтвета],
					Истина);
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

Функция ДатаИзRFC3339(ДатаСтрока)
	ДатаСтрока = СтрЗаменить(ДатаСтрока,"T","");
	ДатаСтрока = СтрЗаменить(ДатаСтрока,"-","");
	ДатаСтрока = СтрЗаменить(ДатаСтрока,":","");
	НачПозицияМС = СтрНайти(ДатаСтрока,".");
	ДатаСтрока = Лев(ДатаСтрока, НачПозицияМС -1 );    
	Возврат Дата(ДатаСтрока) ;
КонецФункции  

Функция ДатаRFC3339Кодированная(Дата)
	ДатаСтрока = Формат(Дата,"ДФ=yyyy-MM-ddTчч:мм:сс+03:00;");
	Возврат КодироватьСтроку(ДатаСтрока,СпособКодированияСтроки.КодировкаURL);
КонецФункции 


Процедура ПоказатьОшибку(Текст)
	Сообщение = Новый СообщениеПользователю;
	Сообщение.Текст = Текст;
	Сообщение.УстановитьДанные(ЭтотОбъект);
	Сообщение.Сообщить();
КонецПроцедуры

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

	ОтветСтруктурой = Новый Структура("Результат,УспехЗапроса", Результат, НЕ Ошибка);

	Возврат ОтветСтруктурой;

КонецФункции

Функция ЗаголовкиПоУмолчанию()
	
	Заголовки = Новый Соответствие;
	Заголовки.Вставить("Accept", "application/json");
	Возврат Заголовки;
КонецФункции

#КонецОбласти