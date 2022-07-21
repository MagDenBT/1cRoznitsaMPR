#Область СлужебныйПрограммныйИнтерфейс

// Инициализирует структуру передачи данных
// 
// Возвращаемое значение:
// 	Структура - Описание:
// * Ссылка - ОпределяемыйТип.ДокументыИСМП, СправочникСсылка.СтанцииУправленияЗаказамиИСМП - Передаваемый документ
// * Организация - ОпределяемыйТип.Организация - Организация
// * ДальнейшееДействие - ПеречислениеСсылка.ДальнейшиеДействияПоВзаимодействиюИСМП - Дальнейшее действие
Функция ПараметрыОбработкиДокументов() Экспорт
	
	ПараметрыОбработки = Новый Структура;
	ПараметрыОбработки.Вставить("Ссылка");
	ПараметрыОбработки.Вставить("Организация");
	ПараметрыОбработки.Вставить("ДальнейшееДействие");
	ПараметрыОбработки.Вставить("ДополнительныеПараметры");
	
	Возврат ПараметрыОбработки;
	
КонецФункции

// Возвращает структуру параметров обновления статуса.
Функция ПараметрыОбновленияСтатуса(ПараметрыОбновленияСтатуса = Неопределено) Экспорт
	
	Если ПараметрыОбновленияСтатуса = Неопределено Тогда
		ПараметрыОбновленияСтатуса = Новый Структура;
	КонецЕсли;
	
	ПараметрыОбновленияСтатуса.Вставить("Статус");
	ПараметрыОбновленияСтатуса.Вставить("СтатусОбработки");
	ПараметрыОбновленияСтатуса.Вставить("ОперацияКвитанции");
	ПараметрыОбновленияСтатуса.Вставить("ПротоколОбмена");
	ПараметрыОбновленияСтатуса.Вставить("ПараметрыЗапроса");
	
	Возврат ПараметрыОбновленияСтатуса;
	
КонецФункции

// Получает значение свойства переданного констекста
// 
// Параметры:
// 	Контекст - ФормаКлиентскогоПриложения - Передаваемый контекст.
// 	ИмяСвойства - Строка - Имя свойства контекста
// Возвращаемое значение:
// 	Произвольный, Неопределено - Значение свойства контекста.
Функция ЗначениеСвойстваКонтекста(Контекст, ИмяСвойства) Экспорт
	
	ВозвращаемоеЗначение = Неопределено;
	
	ИсточникДанных = Контекст;
	Если ТипЗнч(Контекст) = Тип("ФормаКлиентскогоПриложения") Тогда
		ИсточникДанных = Контекст.Объект;
	КонецЕсли;
		
	Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(ИсточникДанных, ИмяСвойства) Тогда
		ВозвращаемоеЗначение = ИсточникДанных[ИмяСвойства];
	КонецЕсли;
	
	Возврат ВозвращаемоеЗначение;
	
КонецФункции

// Начало GTIN для маркировки остатков.
//
// Возвращаемое значение:
// 	Строка - Определеное в ИСМП значение.
Функция НачалоGTINМаркировкиОстатков() Экспорт

	Возврат "029";

КонецФункции

// Преобразовывает шаблона кода маркировки в вид упаковки
// 
// Параметры:
// 	Шаблон - ПеречислениеСсылка.ШаблоныКодовМаркировкиСУЗ - Шаблон кода маркировки.
// Возвращаемое значение:
// 	ПеречислениеСсылка.ВидыУпаковокИС - Вид упаковки.
Функция ВидУпаковкиПоШаблонуКодаМаркировки(Шаблон) Экспорт
	
	ВозвращаемоеЗначение = Неопределено;
	
	Если Шаблон = ПредопределенноеЗначение("Перечисление.ШаблоныКодовМаркировкиСУЗ.БлокТабачныхПачек")
		Или Шаблон = ПредопределенноеЗначение("Перечисление.ШаблоныКодовМаркировкиСУЗ.АльтернативныйТабакБлок")
		Или Шаблон = ПредопределенноеЗначение("Перечисление.ШаблоныКодовМаркировкиСУЗ.НикотиносодержащаяПродукцияБлок") Тогда
		
		ВозвращаемоеЗначение = ПредопределенноеЗначение("Перечисление.ВидыУпаковокИС.Групповая");
		
	Иначе
		
		ВозвращаемоеЗначение = ПредопределенноеЗначение("Перечисление.ВидыУпаковокИС.Потребительская");
		
	КонецЕсли;
	
	Возврат ВозвращаемоеЗначение;
	
КонецФункции

// Преобразовывает вид упаковки в шаблон кода маркировки по виду продукции
// 
// Параметры:
// 	ВидУпаковки  - ПеречислениеСсылка.ВидыУпаковокИС  - Вид упаковки.
// 	ВидПродукции - ПеречислениеСсылка.ВидыПродукцииИС - Вид продукции.
// Возвращаемое значение:
// 	ПеречислениеСсылка.ШаблоныКодовМаркировкиСУЗ - Шаблон кода маркировки.
Функция ШаблонКодаМаркировкиПоВидуУпаковки(ВидУпаковки, ВидПродукции) Экспорт
	
	ВозвращаемоеЗначение = Неопределено;
	
	Если ВидУпаковки = ПредопределенноеЗначение("Перечисление.ВидыУпаковокИС.Групповая") Тогда
		
		Если ВидПродукции = ПредопределенноеЗначение("Перечисление.ВидыПродукцииИС.Духи") Тогда
			ВозвращаемоеЗначение = ПредопределенноеЗначение("Перечисление.ШаблоныКодовМаркировкиСУЗ.ДухиКомплект");
		ИначеЕсли ВидПродукции = ПредопределенноеЗначение("Перечисление.ВидыПродукцииИС.ЛегкаяПромышленность") Тогда
			ВозвращаемоеЗначение = ПредопределенноеЗначение("Перечисление.ШаблоныКодовМаркировкиСУЗ.ЛегкаяПромышленностьКомплект")
		ИначеЕсли ВидПродукции = ПредопределенноеЗначение("Перечисление.ВидыПродукцииИС.Фотоаппараты") Тогда
			ВозвращаемоеЗначение = ПредопределенноеЗначение("Перечисление.ШаблоныКодовМаркировкиСУЗ.ФотоаппаратыКомплект");
		ИначеЕсли ВидПродукции = ПредопределенноеЗначение("Перечисление.ВидыПродукцииИС.Табак") Тогда
			ВозвращаемоеЗначение = ПредопределенноеЗначение("Перечисление.ШаблоныКодовМаркировкиСУЗ.БлокТабачныхПачек");
		ИначеЕсли ВидПродукции = ПредопределенноеЗначение("Перечисление.ВидыПродукцииИС.АльтернативныйТабак") Тогда
			ВозвращаемоеЗначение = ПредопределенноеЗначение("Перечисление.ШаблоныКодовМаркировкиСУЗ.АльтернативныйТабакБлок");
		ИначеЕсли ВидПродукции = ПредопределенноеЗначение("Перечисление.ВидыПродукцииИС.НикотиносодержащаяПродукция") Тогда
			ВозвращаемоеЗначение = ПредопределенноеЗначение("Перечисление.ШаблоныКодовМаркировкиСУЗ.НикотиносодержащаяПродукцияБлок");
		КонецЕсли;
		
	ИначеЕсли ВидУпаковки = ПредопределенноеЗначение("Перечисление.ВидыУпаковокИС.Потребительская") Тогда
		
		Если ВидПродукции = ПредопределенноеЗначение("Перечисление.ВидыПродукцииИС.Духи") Тогда
			ВозвращаемоеЗначение = ПредопределенноеЗначение("Перечисление.ШаблоныКодовМаркировкиСУЗ.Духи");
		ИначеЕсли ВидПродукции = ПредопределенноеЗначение("Перечисление.ВидыПродукцииИС.ЛегкаяПромышленность") Тогда
			ВозвращаемоеЗначение = ПредопределенноеЗначение("Перечисление.ШаблоныКодовМаркировкиСУЗ.ЛегкаяПромышленность")
		ИначеЕсли ВидПродукции = ПредопределенноеЗначение("Перечисление.ВидыПродукцииИС.Фотоаппараты") Тогда
			ВозвращаемоеЗначение = ПредопределенноеЗначение("Перечисление.ШаблоныКодовМаркировкиСУЗ.Фотоаппараты");
		ИначеЕсли ВидПродукции = ПредопределенноеЗначение("Перечисление.ВидыПродукцииИС.Велосипеды") Тогда
			ВозвращаемоеЗначение = ПредопределенноеЗначение("Перечисление.ШаблоныКодовМаркировкиСУЗ.Велосипеды");
		ИначеЕсли ВидПродукции = ПредопределенноеЗначение("Перечисление.ВидыПродукцииИС.КреслаКоляски") Тогда
			ВозвращаемоеЗначение = ПредопределенноеЗначение("Перечисление.ШаблоныКодовМаркировкиСУЗ.КреслаКоляски");
		ИначеЕсли ВидПродукции = ПредопределенноеЗначение("Перечисление.ВидыПродукцииИС.Шины") Тогда
			ВозвращаемоеЗначение = ПредопределенноеЗначение("Перечисление.ШаблоныКодовМаркировкиСУЗ.Шины");
		ИначеЕсли ВидПродукции = ПредопределенноеЗначение("Перечисление.ВидыПродукцииИС.МолочнаяПродукцияПодконтрольнаяВЕТИС") Тогда
			ВозвращаемоеЗначение = ПредопределенноеЗначение("Перечисление.ШаблоныКодовМаркировкиСУЗ.МолочнаяПродукцияПодконтрольнаяВЕТИС");
		ИначеЕсли ВидПродукции = ПредопределенноеЗначение("Перечисление.ВидыПродукцииИС.Обувь") Тогда
			ВозвращаемоеЗначение = ПредопределенноеЗначение("Перечисление.ШаблоныКодовМаркировкиСУЗ.Обувь");
		ИначеЕсли ВидПродукции = ПредопределенноеЗначение("Перечисление.ВидыПродукцииИС.Табак") Тогда
			ВозвращаемоеЗначение = ПредопределенноеЗначение("Перечисление.ШаблоныКодовМаркировкиСУЗ.ТабачнаяПачка");
		ИначеЕсли ВидПродукции = ПредопределенноеЗначение("Перечисление.ВидыПродукцииИС.АльтернативныйТабак") Тогда
			ВозвращаемоеЗначение = ПредопределенноеЗначение("Перечисление.ШаблоныКодовМаркировкиСУЗ.АльтернативныйТабакБлок");
		ИначеЕсли ВидПродукции = ПредопределенноеЗначение("Перечисление.ВидыПродукцииИС.УпакованнаяВода") Тогда
			ВозвращаемоеЗначение = ПредопределенноеЗначение("Перечисление.ШаблоныКодовМаркировкиСУЗ.УпакованнаяВода");
		ИначеЕсли ВидПродукции = ПредопределенноеЗначение("Перечисление.ВидыПродукцииИС.МолочнаяПродукцияБезВЕТИС") Тогда
			ВозвращаемоеЗначение = ПредопределенноеЗначение("Перечисление.ШаблоныКодовМаркировкиСУЗ.МолочнаяПродукцияБезВЕТИС");
		ИначеЕсли ВидПродукции = ПредопределенноеЗначение("Перечисление.ВидыПродукцииИС.Антисептики") Тогда
			ВозвращаемоеЗначение = ПредопределенноеЗначение("Перечисление.ШаблоныКодовМаркировкиСУЗ.Антисептики");
		ИначеЕсли ВидПродукции = ПредопределенноеЗначение("Перечисление.ВидыПродукцииИС.БАДы") Тогда
			ВозвращаемоеЗначение = ПредопределенноеЗначение("Перечисление.ШаблоныКодовМаркировкиСУЗ.БАДы");
		ИначеЕсли ВидПродукции = ПредопределенноеЗначение("Перечисление.ВидыПродукцииИС.НикотиносодержащаяПродукция") Тогда
			ВозвращаемоеЗначение = ПредопределенноеЗначение("Перечисление.ШаблоныКодовМаркировкиСУЗ.НикотиносодержащаяПродукцияПачка");
		ИначеЕсли ВидПродукции = ПредопределенноеЗначение("Перечисление.ВидыПродукцииИС.Пиво") Тогда
			ВозвращаемоеЗначение = ПредопределенноеЗначение("Перечисление.ШаблоныКодовМаркировкиСУЗ.Пиво");
		КонецЕсли;
		
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(ВозвращаемоеЗначение) Тогда
		ВызватьИсключение СтрШаблон(
			НСтр("ru = 'Внутренняя ошибка. Не определен шаблон кода маркировки по виду упаковки %1 для вида продукции %2'"),
			ВидУпаковки,
			ВидПродукции);
	КонецЕсли;
	
	Возврат ВозвращаемоеЗначение;
	
КонецФункции

// Формирует список возможных операций вывода из оборота по виду продукции
// 
// Параметры:
// 	ВидПродукции - Перечисление.ВидыПродукцииИС - ВидПродукции
// Возвращаемое значение:
// 	СписокЗначений - Список операций с представлениями.
Функция ОперацииВыводаИзОборотаПоВидуПродукции(ВидПродукции) Экспорт
	
	ВозвращаемоеЗначение = Новый СписокЗначений();
	
	Если ИнтеграцияИСКлиентСервер.ЭтоМолочнаяПродукцияИСМП(ВидПродукции) Тогда
		
		ВозвращаемоеЗначение.Добавить(
			ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.ВыводИзОборотаРозничнаяПродажа"),
			НСтр("ru = 'Розничная продажа'"));
		ВозвращаемоеЗначение.Добавить(
			ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.ВыводИзОборотаЭкспортВСтраныЕАЭС"),
			НСтр("ru = 'Экспорт в страны ЕАЭС'"));
		ВозвращаемоеЗначение.Добавить(
			ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.ВыводИзОборотаЭкспортЗаПределыСтранЕАЭС"),
			НСтр("ru = 'Экспорт за пределы стран ЕАЭС'"));
		ВозвращаемоеЗначение.Добавить(
			ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.ВыводИзОборотаПродажаПоОбразцамДистанционнаяПродажа"),
			НСтр("ru = 'Продажа по образцам, дистанционная продажа'"));
		ВозвращаемоеЗначение.Добавить(
			ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.ВыводИзОборотаУтратаПовреждениеТовара"),
			НСтр("ru = 'Порча, утеря товара'"));
		ВозвращаемоеЗначение.Добавить(
			ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.ВыводИзОборотаУничтожениеТовара"),
			НСтр("ru = 'Уничтожение товара'"));
		ВозвращаемоеЗначение.Добавить(
			ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.ВыводИзОборотаКонфискацияТовара"),
			НСтр("ru = 'Конфискация товара'"));
		ВозвращаемоеЗначение.Добавить(
			ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.ВыводИзОборотаЛиквидацияПредприятия"),
			НСтр("ru = 'Банкротство, ликвидация'"));
		ВозвращаемоеЗначение.Добавить(
			ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.ВыводИзОборотаИспользованиеДляСобственныхНуждПредприятия"),
			НСтр("ru = 'Для собственных нужд предприятия'"));
		
	ИначеЕсли ИнтеграцияИСКлиентСервер.ЭтоПродукцияМОТП(ВидПродукции) Тогда
		
		ВозвращаемоеЗначение.Добавить(
			ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.ВыводИзОборотаУтратаПовреждениеТовара"),
			НСтр("ru = 'Утеря, недостача товара'"));
		ВозвращаемоеЗначение.Добавить(
			ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.ВыводИзОборотаУничтожениеТовара"),
			НСтр("ru = 'Уничтожение товара'"));
		ВозвращаемоеЗначение.Добавить(
			ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.ВыводИзОборотаКонфискацияТовара"),
			НСтр("ru = 'Конфискация товара'"));
		ВозвращаемоеЗначение.Добавить(
			ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.ВыводИзОборотаЛиквидацияПредприятия"),
			НСтр("ru = 'Банкротство, ликвидация'"));
		ВозвращаемоеЗначение.Добавить(
			ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.ВыводИзОборотаПродажаПоОбразцамДистанционнаяПродажа"),
			НСтр("ru = 'Продажа по образцам'"));
		ВозвращаемоеЗначение.Добавить(
			ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.ВыводИзОборотаБрак"),
			НСтр("ru = 'Брак, порча товара'"));
		ВозвращаемоеЗначение.Добавить(
			ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.ВыводИзОборотаИстечениеСрокаГодности"),
			НСтр("ru = 'Истечение срока годности'"));
		ВозвращаемоеЗначение.Добавить(
			ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.ВыводИзОборотаЛабораторныеОбразцы"),
			НСтр("ru = 'Лабораторные образцы'"));
		ВозвращаемоеЗначение.Добавить(
			ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.ВыводИзОборотаОтзывСРынка"),
			НСтр("ru = 'Отзыв с рынка'"));
		ВозвращаемоеЗначение.Добавить(
			ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.ВыводИзОборотаРекламации"),
			НСтр("ru = 'Рекламации'"));
		ВозвращаемоеЗначение.Добавить(
			ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.ВыводИзОборотаТестированиеПродукта"),
			НСтр("ru = 'Тестирование продукта'"));
		ВозвращаемоеЗначение.Добавить(
			ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.ВыводИзОборотаДругиеПричины"),
			НСтр("ru = 'Другие причины'"));
		
	Иначе
		
		ВозвращаемоеЗначение.Добавить(
			ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.ВыводИзОборотаРозничнаяПродажа"),
			НСтр("ru = 'Розничная продажа'"));
		ВозвращаемоеЗначение.Добавить(
			ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.ВыводИзОборотаЭкспортВСтраныЕАЭС"),
			НСтр("ru = 'Экспорт в страны ЕАЭС'"));
		ВозвращаемоеЗначение.Добавить(
			ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.ВыводИзОборотаЭкспортЗаПределыСтранЕАЭС"),
			НСтр("ru = 'Экспорт за пределы стран ЕАЭС'"));
		ВозвращаемоеЗначение.Добавить(
			ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.ВыводИзОборотаВозвратФизическомуЛицу"),
			НСтр("ru = 'Возврат физическому лицу'"));
		ВозвращаемоеЗначение.Добавить(
			ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.ВыводИзОборотаПродажаПоОбразцамДистанционнаяПродажа"),
			НСтр("ru = 'Продажа по образцам, дистанционная продажа'"));
		ВозвращаемоеЗначение.Добавить(
			ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.ВыводИзОборотаУтратаПовреждениеТовара"),
			НСтр("ru = 'Порча, утеря товара'"));
		ВозвращаемоеЗначение.Добавить(
			ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.ВыводИзОборотаУничтожениеТовара"),
			НСтр("ru = 'Уничтожение товара'"));
		ВозвращаемоеЗначение.Добавить(
			ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.ВыводИзОборотаКонфискацияТовара"),
			НСтр("ru = 'Конфискация товара'"));
		ВозвращаемоеЗначение.Добавить(
			ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.ВыводИзОборотаЛиквидацияПредприятия"),
			НСтр("ru = 'Банкротство, ликвидация'"));
		ВозвращаемоеЗначение.Добавить(
			ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.ВыводИзОборотаИспользованиеДляСобственныхНуждПредприятия"),
			НСтр("ru = 'Для собственных нужд предприятия'"));
		
	КонецЕсли;
	
	Возврат ВозвращаемоеЗначение;
	
КонецФункции

Функция ОперацииМаркировки(Операция) Экспорт
	
	ОперацииМаркировки = Новый Структура;
	ОперацииМаркировки.Вставить("ЭтоПроизводствоРФ", Ложь);
	ОперацииМаркировки.Вставить("ЭтоПроизводствоПоДоговору", Ложь);
	ОперацииМаркировки.Вставить("ЭтоПроизводствоПоДоговоруНаСторонеЗаказчика", Ложь);
	ОперацииМаркировки.Вставить("ЭтоПроизводствоВнеЕАЭС", Ложь);
	ОперацииМаркировки.Вставить("ЭтоИмпортСФТС", Ложь);
	ОперацииМаркировки.Вставить("ЭтоПолучениеПродукцииОтФизическихЛиц", Ложь);
	ОперацииМаркировки.Вставить("ЭтоМаркировкаОстатков", Ложь);
	ОперацииМаркировки.Вставить("ЭтоТрансграничнаяТорговля", Ложь);
	ОперацииМаркировки.Вставить("ЭтоАгрегация", Ложь);
	ОперацииМаркировки.Вставить("ЭтоВводВОборот", Ложь);
	ОперацииМаркировки.Вставить("ЭтоКонтрактноеПроизводство", Ложь);
	ОперацииМаркировки.Вставить("ЭтоОперацияНанесения", Ложь);
	ОперацииМаркировки.Вставить("ТребуетсяЗаполнениеИдентификаторовПримененияВЕТИС", Ложь);
	ОперацииМаркировки.Вставить("ЭтоИмпорт", Ложь);
	
	Если Операция = ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.ВводВОборотПроизводствоРФ") Тогда
		ОперацииМаркировки.ЭтоПроизводствоРФ = Истина;
	ИначеЕсли Операция = ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.ВводВОборотПроизводствоРФПоДоговору") Тогда
		ОперацииМаркировки.ЭтоПроизводствоПоДоговору = Истина;
	ИначеЕсли Операция = ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.ВводВОборотПроизводствоРФПоДоговоруНаСторонеЗаказчика") Тогда
		ОперацииМаркировки.ЭтоПроизводствоПоДоговоруНаСторонеЗаказчика = Истина;
	ИначеЕсли Операция = ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.ВводВОборотПроизводствоВнеЕАЭС") Тогда
		ОперацииМаркировки.ЭтоПроизводствоВнеЕАЭС = Истина;
	ИначеЕсли Операция = ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.ВводВОборотИмпортСФТС") Тогда
		ОперацииМаркировки.ЭтоИмпортСФТС = Истина;
	ИначеЕсли Операция = ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.ВводВОборотПолучениеПродукцииОтФизическихЛиц") Тогда
		ОперацииМаркировки.ЭтоПолучениеПродукцииОтФизическихЛиц = Истина;
	ИначеЕсли Операция = ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.ВводВОборотМаркировкаОстатков") Тогда
		ОперацииМаркировки.ЭтоМаркировкаОстатков = Истина;
	ИначеЕсли Операция = ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.ВводВОборотТрансграничнаяТорговля") Тогда
		ОперацииМаркировки.ЭтоТрансграничнаяТорговля = Истина;
	ИначеЕсли Операция = ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.Агрегация") Тогда
		ОперацииМаркировки.ЭтоАгрегация = Истина;
	КонецЕсли;
	
	ОперацииМаркировки.ЭтоОперацияНанесения = ИнтеграцияИСМПКлиентСервер.ОперацииНанесенияКодовМаркировки().Найти(Операция) <> Неопределено;
	
	ОперацииМаркировки.ЭтоВводВОборот =
		  Не ОперацииМаркировки.ЭтоОперацияНанесения
		И Не ОперацииМаркировки.ЭтоАгрегация
		И Не ОперацииМаркировки.ЭтоМаркировкаОстатков
		И Не ОперацииМаркировки.ЭтоПолучениеПродукцииОтФизическихЛиц;
	
	ОперацииМаркировки.ЭтоКонтрактноеПроизводство =
		ОперацииМаркировки.ЭтоПроизводствоПоДоговору
		Или ОперацииМаркировки.ЭтоПроизводствоПоДоговоруНаСторонеЗаказчика;
	
	ОперацииМаркировки.ТребуетсяЗаполнениеИдентификаторовПримененияВЕТИС =
		Операция = ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.ВводВОборотПроизводствоРФ")
		Или Операция = ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.ВводВОборотПроизводствоВнеЕАЭС")
		Или Операция = ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.ВводВОборотТрансграничнаяТорговля")
		Или Операция = ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.ВводВОборотИмпортСФТС")
		Или ОперацииМаркировки.ЭтоКонтрактноеПроизводство;

	ОперацииМаркировки.ЭтоИмпорт =
		ОперацииМаркировки.ЭтоТрансграничнаяТорговля 
		Или ОперацииМаркировки.ЭтоПроизводствоВнеЕАЭС
		Или ОперацииМаркировки.ЭтоИмпортСФТС;
	
	Возврат ОперацииМаркировки;
	
КонецФункции

#КонецОбласти
