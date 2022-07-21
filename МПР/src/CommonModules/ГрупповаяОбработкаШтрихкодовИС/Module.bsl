#Область ПрограммныйИнтерфейс

// Результат серверной обработки полученных из ТСД штрихкодов.
//
// Параметры:
//   ИдентификаторСтроки - Число - идентификатор текущей проверяемой упаковки формы проверки и подбора.
//
// Возвращаемое значение:
//   Структура - результат обработки:
//    * ТребуетсяАвторизация      - Булево - Если Истина, то обработка не выполнена: требуется авторизация во внешнем сервисе
//    * ШтрихкодыДляСопоставления - Массив - Если заполнен, то обработка не выполнена: обнаружены неизвестные штрихкоды номенклатуры
//    * ЕстьОшибкиВДереве         - Булево - Если Истина, то обработка не выполнена: модуль штрихкодирования вернул эту ошибку
//    * АдресДереваУпаковок       - Строка, Неопределено - адрес дерева упаковок для отображения ошибки
//    * ОбщаяОшибка               - Булево - Если Истина, то обработка не выполнена: модуль штрихкодирования вернул эту ошибку
//    * ТекстОбщейОшибки          - Строка - Расшифровка общей ошибки
//
//    * Счетчик      - Число  - Количество штрихкодов обработанных на сервере (не переданы на клиент)
//    * Обработано   - Число  - Количество обработанных штрихкодов в текущем наборе
//    * Всего        - Число  - Количество штрихкодов требующих обработки
//    * ШтрихкодыТСД - Массив из Структура - Штрихкоды требующие обработки
//
//    * ПредложитьЗагрузитьВУпаковке - Булево - можно предложить пользователю загрузить данные ТСД в одной упаковке
//    * ТекстПредложенияОЗагрузке    - Строка - доступная распознанная структура иерархии
//    * ПроверяемаяУпаковка          - Число, Неопределено - открытая до начала групповой обработки упаковка (идентификатор).
//
//    * ДобавленныеСтроки         - Массив - Добавленные строки документа
//    * ИзмененныеСтроки          - Массив - Измененные строки документа
//
Функция РезультатЗагрузкиШтрихкодовИзТСД(ИдентификаторСтроки = Неопределено) Экспорт
	
	Результат = Новый Структура;
	
	// Результат: ошибка загрузки
	Результат.Вставить("ТребуетсяАвторизация",                Ложь);
	Результат.Вставить("ШтрихкодыДляСопоставления",           Новый Массив);
	Результат.Вставить("АдресУточнениеКоэффициентовУпаковок", Неопределено);
	Результат.Вставить("ЕстьОшибкиВДереве",                   Ложь);
	Результат.Вставить("АдресДереваУпаковок",                 Неопределено);
	Результат.Вставить("ОбщаяОшибка",                         Ложь);
	Результат.Вставить("ТекстОбщейОшибки",                    "");
	
	// Результат: произведена частичная или полная загрузка
	Результат.Вставить("Счетчик",      0); // количество обработанных кодов не требующих передачи на клиент
	Результат.Вставить("Обработано",   0);
	Результат.Вставить("Всего",        0);
	Результат.Вставить("ШтрихкодыТСД", Новый Массив);
	
	// Формы проверки и подбора
	Результат.Вставить("ПредложитьЗагрузитьВУпаковке",                    Ложь);
	Результат.Вставить("ТекстПредложенияОЗагрузке",                       "");
	Результат.Вставить("ПроверяемаяУпаковка",                             ИдентификаторСтроки);
	Результат.Вставить("ЭтоВосстановлениеВложенностиУпаковок",            Ложь);
	Результат.Вставить("ДанныеДляВосстановлениеВложенности",              Неопределено);
	Результат.Вставить("ПересчитыватьИтогиВДеревеМаркированнойПродукции", Ложь);
	
	// Предложение сменить детализацию на рекомендуемую на основе статистики
	Результат.Вставить("ПредложитьИзменитьДетализацию",        Ложь);
	Результат.Вставить("РекомендуемыеДетализации",             Неопределено);
	Результат.Вставить("ОписаниеРекомендацииСменыДетализации", "");
	
	// Обработанные строки
	Результат.Вставить("ДобавленныеСтроки", Новый Массив);
	Результат.Вставить("ИзмененныеСтроки",  Новый Массив);
	
	Возврат Результат;
	
КонецФункции

// Удаляет из массива штрихкодов обработанные для уменьшения объема данных к передаче на клиент
// 
// Параметры:
// 	РезультатЗагрузки - См. РезультатЗагрузкиШтрихкодовИзТСД
Процедура ОставитьНеобработанныеДанные(РезультатЗагрузки) Экспорт
	
	Если РезультатЗагрузки.Обработано > 0 Тогда
		РезультатЗагрузки.Счетчик = РезультатЗагрузки.Счетчик + РезультатЗагрузки.Обработано;
		ШтрихкодыТСД = Новый Массив;
		Для Индекс = РезультатЗагрузки.Обработано По РезультатЗагрузки.Всего - 1 Цикл
			ШтрихкодыТСД.Добавить(РезультатЗагрузки.ШтрихкодыТСД[Индекс]);
		КонецЦикла;
		РезультатЗагрузки.ШтрихкодыТСД = ШтрихкодыТСД;
		РезультатЗагрузки.Всего        = РезультатЗагрузки.Всего - РезультатЗагрузки.Обработано;
		РезультатЗагрузки.Обработано   = 0;
	КонецЕсли;
	
КонецПроцедуры

// Серверная часть обработки штрихкодов при их загрузке из ТСД в формы документов (без иерархической проверки)
//
// Параметры:
//   Форма                 - ФормаКлиентскогоПриложения - источник вызова
//   ШтрихкодыТСД          - Массив Из Структура - данные ТСД с преобразованными в Base64 штрихкодами
//   ПараметрыСканирования - См. ШтрихкодированиеИС.ПараметрыСканирования
//
// Возвращаемое значение:
//   См. РезультатЗагрузкиШтрихкодовИзТСД
Функция ОбработатьПолученныеДанныеТСДВДокументе(Форма, ШтрихкодыТСД, ПараметрыСканирования, ТолькоКодыМаркировки = Истина) Экспорт
	
	Результат = РезультатЗагрузкиШтрихкодовИзТСД();
	
	ДополнитьУпорядочитьДанныеТСД(ШтрихкодыТСД);
	
	ДанныеШтрихкодов            = Новый Массив;
	МассивПропущенныхШтрихкодов = Новый Массив;
	КешДанныхРазбора            = Новый Соответствие;
	
	ПользовательскиеПараметрыРазбораКодаМаркировки = РазборКодаМаркировкиИССлужебныйКлиентСервер.ПользовательскиеПараметрыРазбораКодаМаркировки();
	ПользовательскиеПараметрыРазбораКодаМаркировки.ПроверятьАлфавитЭлементов = ПараметрыСканирования.ПроверятьАлфавитКодовМаркировки;
	
	Если ШтрихкодированиеИС.ПрисутствуетТабачнаяПродукция(ПараметрыСканирования.ДопустимыеВидыПродукции)
		Или ШтрихкодированиеИС.ПрисутствуетПродукцияИСМП(ПараметрыСканирования.ДопустимыеВидыПродукции) Тогда
		ПользовательскиеПараметрыРазбораКодаМаркировки.РасширеннаяДетализация = ПараметрыСканирования.СохранятьКодыМаркировкиВПулИСМП;
	КонецЕсли;
	
	ПредставлениеДопустимыхВидовПродукции = СтрСоединить(ПараметрыСканирования.ДопустимыеВидыПродукции, ", ");
	Для Каждого СтрокаДанныхТСД Из ШтрихкодыТСД Цикл
		
		Штрихкод = ШтрихкодированиеИСКлиентСервер.Base64ВШтрихкод(СтрокаДанныхТСД.Штрихкод);
		ДанныеРазбора = ВидУпаковкиИПредставлениеШтрихкода(
			Штрихкод, ПараметрыСканирования.ДопустимыеВидыПродукции, КешДанныхРазбора,, ПользовательскиеПараметрыРазбораКодаМаркировки);
		
		Если ДанныеРазбора.ВидУпаковки = Неопределено Тогда
			
			Если ТолькоКодыМаркировки Тогда
				
				ОбщегоНазначения.СообщитьПользователю(
					СтрШаблон(
						НСтр("ru = 'Код %1 не является штрихкодом потребительской, групповой или логистической
						           |упаковки для вида продукции: %2. Пропущен.'"),
						Штрихкод, ПредставлениеДопустимыхВидовПродукции));
				
				МассивПропущенныхШтрихкодов.Добавить(СтрокаДанныхТСД);
				Продолжить;
				
			Иначе
				СтрокаДанныхТСД.Вставить("НормализованныйШтрихкод", Штрихкод);
				СтрокаДанныхТСД.Вставить("ШтрихкодСОшибкой", Ложь);
			КонецЕсли;
			
		Иначе
			
			СтрокаДанныхТСД.Вставить("НормализованныйШтрихкод", ДанныеРазбора.НормализованныйШтрихкод);
			СтрокаДанныхТСД.Вставить("ШтрихкодСОшибкой", Ложь);
			
		КонецЕсли;
		
		ДанныеШтрихкода = Новый Структура(
			"Штрихкод, ШтрихкодBase64, Количество",
			Штрихкод, СтрокаДанныхТСД.Штрихкод, СтрокаДанныхТСД.Количество);
		ДанныеШтрихкодов.Добавить(ДанныеШтрихкода);
		
	КонецЦикла;
	
	Если МассивПропущенныхШтрихкодов.Количество() Тогда
		Для Каждого ЭлементМассива Из МассивПропущенныхШтрихкодов Цикл
			ПорядковыйНомер = ШтрихкодыТСД.Найти(ЭлементМассива);
			Если ПорядковыйНомер <> Неопределено Тогда
				ШтрихкодыТСД.Удалить(ПорядковыйНомер);
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	ШтрихкодированиеИС.ПоместитьДанныеДокументаВКэшМаркируемойПродукции(Форма, ПараметрыСканирования);
	
	ПараметрыСканированияДляГрупповойОбработки = ОбщегоНазначения.СкопироватьРекурсивно(ПараметрыСканирования, Ложь);
	
	Если Не ПараметрыСканированияДляГрупповойОбработки.Свойство("ВидОперацииИСМП")
		Или ПараметрыСканированияДляГрупповойОбработки.ВидОперацииИСМП <> Перечисления["ВидыОперацийИСМП"]["ЗаказНаЭмиссиюКодовМаркировки"] Тогда
		ПараметрыСканированияДляГрупповойОбработки.ПроверятьДублиКодовМаркировки = "Иерархия";
	КонецЕсли;
	
	РезультатОбработкиШтрихкодов = ШтрихкодированиеИС.ОбработатьШтрихкоды(
		ДанныеШтрихкодов, ПараметрыСканированияДляГрупповойОбработки, Неопределено, Форма, КешДанныхРазбора);
	
	// 1. Авторизация
	ТребуетсяАвторизация = Ложь;
	Для Каждого КлючИЗначение Из РезультатОбработкиШтрихкодов.РезультатыОбработки Цикл
		РезультатОбработки = КлючИЗначение.Значение;
		Если РезультатОбработки.Свойство("ТребуетсяАвторизацияИСМП")
				И РезультатОбработки.ТребуетсяАвторизацияИСМП Тогда
			ТребуетсяАвторизация = Истина;
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
	Результат.ТребуетсяАвторизация = ТребуетсяАвторизация;
	Если ТребуетсяАвторизация Тогда
		Возврат Результат;
	КонецЕсли;
	
	УпорядочитьДанныеТСДПоРезультатамОбработкиШтрихкодов(
		ШтрихкодыТСД, РезультатОбработкиШтрихкодов.РезультатыОбработки);
	
	// 2. Проверка на ошибки
	Результат.ШтрихкодыТСД = ШтрихкодыТСД;
	ПроверитьНаОшибкиРезультатОбработкиДанныхТСД(Результат, Форма, ПараметрыСканирования);
	
	Если Результат.ОбщаяОшибка
		Или Результат.ШтрихкодыДляСопоставления.Количество() Тогда
		Возврат Результат;
	КонецЕсли;
	
	// 3. Обработка всех строк, не требующих вмешательства пользователя
	ШтрихкодыТребующиеОбработкиПользователем = Новый Массив;
	
	ДеревоУпаковокОбработано = Ложь;
	ОбработанныеШтрихкоды    = Новый Соответствие;
	МенеджерОбработки        = ОбщегоНазначения.МенеджерОбъектаПоПолномуИмени(Форма.ИмяФормы);
	
	ПропущенныеШтрихкодыИзДереваУпаковок = Новый Массив;
	
	Для Каждого СтрокаШтрихкод Из ШтрихкодыТСД Цикл
		
		Если СтрокаШтрихкод.ШтрихкодСОшибкой Тогда
			Продолжить;
		ИначеЕсли СтрокаШтрихкод.РезультатОбработки.ТребуетсяУточнениеДанных
			Или СтрокаШтрихкод.РезультатОбработки.ТребуетсяУточнениеСоставаУпаковки Тогда
			ШтрихкодыТребующиеОбработкиПользователем.Добавить(СтрокаШтрихкод);
		ИначеЕсли ОбработанныеШтрихкоды.Получить(СтрокаШтрихкод.НормализованныйШтрихкод) <> Неопределено Тогда
			Продолжить;
		Иначе
			
			Если Не ШтрихкодированиеИСКлиентСервер.ЭтоEANИлиGTIN(СтрокаШтрихкод.НормализованныйШтрихкод) Тогда
				ОбработанныеШтрихкоды.Вставить(СтрокаШтрихкод.НормализованныйШтрихкод, Истина);
			КонецЕсли;
			
			ДанныеВДеревеУпаковок = ЗначениеЗаполнено(СтрокаШтрихкод.РезультатОбработки.АдресДереваУпаковок);
			Если ДанныеВДеревеУпаковок И Не ДеревоУпаковокОбработано Тогда
				
				ВложенныеШтрихкоды = ШтрихкодированиеИС.ИнициализацияВложенныхШтрихкодов();
				ВложенныеШтрихкоды.ДеревоУпаковок = ПолучитьИзВременногоХранилища(СтрокаШтрихкод.РезультатОбработки.АдресДереваУпаковок);
				ДанныеШтрихкода = СтрокаШтрихкод.РезультатОбработки.ДанныеШтрихкода;
				
				РезультатДобавления = МенеджерОбработки.ОбработатьДанныеШтрихкода(Форма, ДанныеШтрихкода, ПараметрыСканирования, ВложенныеШтрихкоды);
				Если РезультатДобавления <> Неопределено Тогда
					Если РезультатДобавления.ЕстьОшибки Или РезультатДобавления.ЕстьОшибкиВДеревеУпаковок Тогда
						ОбщегоНазначения.СообщитьПользователю(
							СтрШаблон("(%1)%2",СтрокаШтрихкод.НормализованныйШтрихкод, РезультатДобавления.ТекстОшибки));
					КонецЕсли;
					ПеренестиДобавленныеИзмененныеСтроки(Результат, РезультатДобавления);
				КонецЕсли;
				
				ДеревоУпаковокОбработано = Истина;
				
			КонецЕсли;
			
			Если Не ДанныеВДеревеУпаковок Тогда
				
				ДанныеШтрихкода = СтрокаШтрихкод.РезультатОбработки.ДанныеШтрихкода;
				Если ДанныеШтрихкода.НайденВоВложенныхУпаковках Тогда
					ПропущенныеШтрихкодыИзДереваУпаковок.Добавить(ДанныеШтрихкода);
					Продолжить;
				КонецЕсли;
				
				РезультатДобавления = МенеджерОбработки.ОбработатьДанныеШтрихкода(Форма, ДанныеШтрихкода, ПараметрыСканирования);
				Если РезультатДобавления <> Неопределено Тогда
					ПеренестиДобавленныеИзмененныеСтроки(Результат, РезультатДобавления);
				КонецЕсли;
				
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЦикла;
	
	// На текущий момент все коды обрабатываются через получение ДереваУпаковок
	// и для всех кодов потребительских упаковок НайденВоВложенныхУпаковках = Истина
	Если Не ДеревоУпаковокОбработано Тогда
		Для Каждого ДанныеШтрихкода Из ПропущенныеШтрихкодыИзДереваУпаковок Цикл
			
			РезультатДобавления = МенеджерОбработки.ОбработатьДанныеШтрихкода(Форма, ДанныеШтрихкода, ПараметрыСканирования);
			Если РезультатДобавления <> Неопределено Тогда
				ПеренестиДобавленныеИзмененныеСтроки(Результат, РезультатДобавления);
			КонецЕсли;
			
		КонецЦикла;
	КонецЕсли;
	
	Результат.ШтрихкодыТСД = ШтрихкодыТребующиеОбработкиПользователем;
	Результат.Всего        = ШтрихкодыТребующиеОбработкиПользователем.Количество();
	
	Возврат Результат;
	
КонецФункции

Функция ВидУпаковкиИПредставлениеШтрихкода(Знач Штрихкод, ВидПродукции, КешДанныхРазбора = Неопределено,
	НастройкиРазбораКодовМаркировки = Неопределено, ПользовательскиеПараметрыРазбораКодаМаркировки = Неопределено) Экспорт
	
	Результат = Новый Структура;
	Результат.Вставить("ВидУпаковки",                                  Неопределено);
	Результат.Вставить("НормализованныйШтрихкод",                      Штрихкод);
	Результат.Вставить("КодМаркировкиСоответствуетНесколькимШаблонам", Ложь);
	
	ДанныеРазбораИРезультат = КешДанныхРазбора[Штрихкод];
	Если ДанныеРазбораИРезультат <> Неопределено Тогда
		ДанныеРазбора = ДанныеРазбораИРезультат.ДанныеРазбора;
		Если ДанныеРазбора <> Неопределено Тогда
			Результат.ВидУпаковки = ДанныеРазбораИРезультат.ДанныеРазбора.ВидУпаковки;
			Результат.НормализованныйШтрихкод = ДанныеРазбораИРезультат.ДанныеРазбора.НормализованныйКодМаркировки;
		КонецЕсли;
		Возврат Результат;
	КонецЕсли;
	
	РезультатРазбора            = Неопределено;
	ПримечаниеКРазборуШтрихкода = Неопределено;
	
	Если НайтиНедопустимыеСимволыXML(Штрихкод) > 0 Тогда
		РезультатРазбора = МенеджерОборудованияМаркировкаКлиентСервер.РазобратьСтрокуШтрихкодаGS1(Штрихкод);
		ДанныеРазбора = РазборКодаМаркировкиИССлужебный.РазобратьКодМаркировки(
			РезультатРазбора, ВидПродукции, ПримечаниеКРазборуШтрихкода,
			НастройкиРазбораКодовМаркировки, ПользовательскиеПараметрыРазбораКодаМаркировки);
	Иначе
		ДанныеРазбора = РазборКодаМаркировкиИССлужебный.РазобратьКодМаркировки(
			Штрихкод, ВидПродукции, ПримечаниеКРазборуШтрихкода,
			НастройкиРазбораКодовМаркировки, ПользовательскиеПараметрыРазбораКодаМаркировки);
	КонецЕсли;
	
	ВидУпаковки = Неопределено;
	Если ДанныеРазбора = Неопределено Тогда
		Если РезультатРазбора <> Неопределено И РезультатРазбора.Разобран Тогда
			НормализованныйШтрихкод = РезультатРазбора.ПредставлениеШтрихкода;
		Иначе
			НормализованныйШтрихкод = Штрихкод;
		КонецЕсли;
	Иначе
		ВидУпаковки             = ДанныеРазбора.ВидУпаковки;
		НормализованныйШтрихкод = ДанныеРазбора.НормализованныйКодМаркировки;
	КонецЕсли;
	
	ДанныеРазбораИРезультат = Новый Структура;
	ДанныеРазбораИРезультат.Вставить("ДанныеРазбора",               ДанныеРазбора);
	ДанныеРазбораИРезультат.Вставить("ПримечаниеКРазборуШтрихкода", ПримечаниеКРазборуШтрихкода);
	КешДанныхРазбора.Вставить(Штрихкод, ДанныеРазбораИРезультат);
	
	Результат.ВидУпаковки                                  = ВидУпаковки;
	Результат.НормализованныйШтрихкод                      = НормализованныйШтрихкод;
	Результат.КодМаркировкиСоответствуетНесколькимШаблонам = ПримечаниеКРазборуШтрихкода <> Неопределено
		И (ПримечаниеКРазборуШтрихкода.ИдентификаторОшибки = РазборКодаМаркировкиИССлужебныйКлиентСервер.ИдентификаторыОшибокРазбораКодаМаркировки().КодМаркировкиСоответствуетНесколькимШаблонам);
	
	Возврат Результат;
	
КонецФункции

// Подготовливает параметр сканирования ДополнительныеВариантыСопоставленияНоменклатуры
//
// Параметры:
//  ПараметрыСканирования - См. ШтрихкодированиеИС.ПараметрыСканирования
//  ПодобраннаяМаркируемаяПродукция - ДанныеФормыКоллекция Из ДанныеФормыСтруктура - Таблица ПодобраннаяМаркируемаяПродукция из формы проверки и подбора:
//    * GTIN - Строка - GTIN
//    * Номенклатура - ОпределяемыйТип.Номенклатура - Номенклатура
//    * Характеристика - ОпределяемыйТип.ХарактеристикаНоменклатуры - Характеристика номенклатуры
//    * Серия - ОпределяемыйТип.СерияНоменклатуры - Серия номенклатуры
//
Процедура ПодготовитьДополнительныеВариантыСопоставленияНоменклатуры(ПараметрыСканирования, ПодобраннаяМаркируемаяПродукция) Экспорт
	
	ПараметрыСканирования.ДополнительныеВариантыСопоставленияНоменклатуры = Новый Соответствие;
	
	ТаблицаСопоставленияПоGTIN = ПодобраннаяМаркируемаяПродукция.Выгрузить(, "GTIN, Номенклатура, Характеристика, Серия");
	ТаблицаСопоставленияПоGTIN.Свернуть("GTIN, Номенклатура, Характеристика, Серия");
	
	Для Каждого СтрокаТаблицы Из ТаблицаСопоставленияПоGTIN Цикл
		
		ШтрихкодEAN = ШтрихкодированиеИСКлиентСервер.ШтрихкодEANИзGTIN(СтрокаТаблицы.GTIN);
		
		ВариантыСопоставления = ПараметрыСканирования.ДополнительныеВариантыСопоставленияНоменклатуры.Получить(ШтрихкодEAN);
		Если ВариантыСопоставления = Неопределено Тогда
			ВариантыСопоставления = Новый Массив;
		КонецЕсли;
		
		ВариантСопоставления = Новый Структура("Номенклатура, Характеристика, Серия");
		ЗаполнитьЗначенияСвойств(ВариантСопоставления, СтрокаТаблицы);
		ВариантыСопоставления.Добавить(ВариантСопоставления);
		
		ПараметрыСканирования.ДополнительныеВариантыСопоставленияНоменклатуры.Вставить(ШтрихкодEAN, ВариантыСопоставления);
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ЗагрузкаИзФормДокументов

// При необходимости изменяет данные поступившие из ТСД по правилам: вложение упаковки всегда должно 
// быть в массиве после строки самой упаковки; если строки с штрихкодом упаковки нет - она добавляется.
//
// Параметры:
//  ДанныеТСД - Массив - данные поступившие с ТСД (изменяемый параметр)
//
// Возвращаемое значение:
//  Булево - в данных ТСД есть иерархия
//
Функция ДополнитьУпорядочитьДанныеТСД(ДанныеТСД) Экспорт
	
	ТипЧисло  = Тип("Число");
	ТипСтрока = Тип("Строка");
	
	// 1. Дополнить данные поступившие из ТСД / внешних источников (в формате ТСД)
	ВсеШтрихкоды = Новый Соответствие;
	Для Каждого ЭлементМассива Из ДанныеТСД Цикл
		ВсеШтрихкоды.Вставить(ЭлементМассива.Штрихкод, Истина);
	КонецЦикла;
	Для Каждого ЭлементМассива Из ДанныеТСД Цикл
		ШтрихкодУпаковки = "";
		Если Не ЭлементМассива.Свойство("ШтрихкодУпаковки", ШтрихкодУпаковки) Тогда
			Продолжить;
		ИначеЕсли Не ЗначениеЗаполнено(ШтрихкодУпаковки) Тогда
			Продолжить;
		ИначеЕсли ВсеШтрихкоды[ШтрихкодУпаковки] = Неопределено Тогда
			ВсеШтрихкоды.Вставить(ШтрихкодУпаковки, Истина);
			НовыйЭлемент = ОбщегоНазначения.СкопироватьРекурсивно(ЭлементМассива, Ложь);
			Для Каждого КлючИЗначение Из НовыйЭлемент Цикл
				Ключ = КлючИЗначение.Ключ;
				ТипКолонки = ТипЗнч(ЭлементМассива[Ключ]);
				Если ТипКолонки = ТипСтрока Тогда
					НовыйЭлемент[Ключ] = "";
				ИначеЕсли ТипКолонки = ТипЧисло Тогда
					НовыйЭлемент[Ключ] = 0;
				Иначе
					НовыйЭлемент[Ключ] = Неопределено;
				КонецЕсли;
			КонецЦикла;
			НовыйЭлемент.Штрихкод         = ШтрихкодУпаковки;
			НовыйЭлемент.ШтрихкодУпаковки = "";
			ДанныеТСД.Добавить(НовыйЭлемент);
		КонецЕсли;
	КонецЦикла;
	
	// 2. Сортировать данные
	ТаблицаСоответствия = Новый ТаблицаЗначений;
	ТаблицаСоответствия.Колонки.Добавить("ШтрихкодУпаковки", Новый ОписаниеТипов("Строка"));
	ТаблицаСоответствия.Колонки.Добавить("Штрихкод",         Новый ОписаниеТипов("Строка"));
	ТаблицаСоответствия.Колонки.Добавить("Обновлять",        Новый ОписаниеТипов("Булево"));
	ТаблицаСоответствия.Колонки.Добавить("Уровень",          ОбщегоНазначения.ОписаниеТипаЧисло(2, 0, ДопустимыйЗнак.Неотрицательный));
	ТаблицаСоответствия.Колонки.Добавить("НовыйУровень",     ОбщегоНазначения.ОписаниеТипаЧисло(2, 0, ДопустимыйЗнак.Неотрицательный));
	ТаблицаСоответствия.Колонки.Добавить("Элемент");
	
	ДобавленныеЭлементы = Новый Соответствие;
	
	Для Каждого ЭлементМассива Из ДанныеТСД Цикл
		
		ШтрихкодУпаковки = "";
		ЭлементМассива.Свойство("ШтрихкодУпаковки", ШтрихкодУпаковки);
		
		КлючПоиска = СтрШаблон("%1-%2", ЭлементМассива.Штрихкод, ШтрихкодУпаковки);
		РезультатПоиска = ДобавленныеЭлементы[КлючПоиска];
		Если РезультатПоиска <> Неопределено Тогда
			Если РезультатПоиска.Свойство("Количество")
				И ШтрихкодированиеИСКлиентСервер.ЭтоEANИлиGTIN(ЭлементМассива.Штрихкод) Тогда
				РезультатПоиска.Количество = РезультатПоиска.Количество + 1;
			КонецЕсли;
			Продолжить;
		КонецЕсли;
		ДобавленныеЭлементы.Вставить(КлючПоиска, ЭлементМассива);
		
		НоваяСтрока = ТаблицаСоответствия.Добавить();
		НоваяСтрока.ШтрихкодУпаковки = ШтрихкодУпаковки;
		НоваяСтрока.Штрихкод         = ЭлементМассива.Штрихкод;
		НоваяСтрока.Уровень          = 0;
		НоваяСтрока.Элемент          = ЭлементМассива;
		
	КонецЦикла;
	
	ТаблицаСоответствия.Индексы.Добавить("Уровень");
	ТаблицаСоответствия.Индексы.Добавить("Обновлять");
	ТаблицаСоответствия.Индексы.Добавить("Уровень, Штрихкод");
	
	СтруктураПоискаУровень         = Новый Структура("Уровень");
	СтруктураПоискаОбновлять       = Новый Структура("Обновлять", Истина);
	СтруктураПоискаУровеньШтрихкод = Новый Структура("Уровень, Штрихкод");
	
	Уровень = 0;
	СчитатьИерархию = Истина;
	СтрокТаблицы    = ТаблицаСоответствия.Количество();
	Пока СчитатьИерархию И Уровень <= СтрокТаблицы Цикл
		СчитатьИерархию = Ложь;
		СтруктураПоискаУровень.Уровень = Уровень;
		СтрокиУровня = ТаблицаСоответствия.НайтиСтроки(СтруктураПоискаУровень);
		Для Каждого СтрокаТЧ Из СтрокиУровня Цикл
			Если ПустаяСтрока(СтрокаТЧ.ШтрихкодУпаковки) Тогда
				Продолжить;
			КонецЕсли;
			СтруктураПоискаУровеньШтрихкод.Уровень  = Уровень;
			СтруктураПоискаУровеньШтрихкод.Штрихкод = СтрокаТЧ.ШтрихкодУпаковки;
			Упаковки = ТаблицаСоответствия.НайтиСтроки(СтруктураПоискаУровеньШтрихкод);
			Если Упаковки.Количество() Тогда
				СчитатьИерархию = Истина;
				СтрокаТЧ.НовыйУровень = Уровень + 1;
				СтрокаТЧ.Обновлять    = Истина;
			КонецЕсли;
		КонецЦикла;
		
		СтрокиУровня = ТаблицаСоответствия.НайтиСтроки(СтруктураПоискаОбновлять);
		Для Каждого СтрокаТЧ Из СтрокиУровня Цикл
			СтрокаТЧ.Уровень      = СтрокаТЧ.НовыйУровень;
			СтрокаТЧ.НовыйУровень = 0;
			СтрокаТЧ.Обновлять    = Ложь;
		КонецЦикла;
		
		Уровень = Уровень + 1;
	КонецЦикла;
	
	Если Уровень > СтрокТаблицы Тогда
		ДанныеТСД = Новый Массив;
		ВызватьИсключение НСтр("ru = 'Получены некорректные данные из ТСД или внешнего файла: обнаружено зацикливание упаковок'");
	КонецЕсли;
	
	ТаблицаСоответствия.Сортировать("Уровень ВОЗР");
	
	СортированныйМассив = Новый Массив;
	Для Каждого СтрокаТЧ Из ТаблицаСоответствия Цикл
		ЭлементДанных = СтрокаТЧ.Элемент;
		ЭлементДанных.Вставить("Уровень", СтрокаТЧ.Уровень);
		СортированныйМассив.Добавить(ЭлементДанных);
	КонецЦикла;
	ДанныеТСД = СортированныйМассив;
	
	Возврат Уровень > 1;
	
КонецФункции

Процедура УпорядочитьДанныеТСДПоРезультатамОбработкиШтрихкодов(ДанныеТСД, РезультатыОбработки, ЗаменыШтрихкодов = Неопределено) Экспорт
	
	ТаблицаСоответствия = Новый ТаблицаЗначений;
	ТаблицаСоответствия.Колонки.Добавить("Уровень",            Новый ОписаниеТипов("Число"));
	ТаблицаСоответствия.Колонки.Добавить("ТребуетсяУточнение", Новый ОписаниеТипов("Булево"));
	ТаблицаСоответствия.Колонки.Добавить("Элемент");
	
	ТаблицаСоответствия.Колонки.Добавить("Номенклатура",   Метаданные.ОпределяемыеТипы.Номенклатура.Тип);
	ТаблицаСоответствия.Колонки.Добавить("Характеристика", Метаданные.ОпределяемыеТипы.ХарактеристикаНоменклатуры.Тип);
	ТаблицаСоответствия.Колонки.Добавить("Серия",          Метаданные.ОпределяемыеТипы.СерияНоменклатуры.Тип);
	ТаблицаСоответствия.Колонки.Добавить("GTIN",           Метаданные.ОпределяемыеТипы.GTIN.Тип);
	ТаблицаСоответствия.Колонки.Добавить("МРЦ",            Новый ОписаниеТипов("Число"));
	ТаблицаСоответствия.Колонки.Добавить("ГоденДо",        Новый ОписаниеТипов("Дата"));
	
	ЗаполнятьМРЦ     = Неопределено;
	ЗаполнятьГоденДо = Неопределено;
	
	Для Каждого ЭлементМассива Из ДанныеТСД Цикл
		
		РезультатОбработки = РезультатыОбработки.Получить(ЭлементМассива.НормализованныйШтрихкод);
		Если РезультатОбработки = Неопределено
			И ЗаменыШтрихкодов <> Неопределено Тогда
			ПервичныйШтрихкод = ЗаменыШтрихкодов[ЭлементМассива.НормализованныйШтрихкод];
			Если ПервичныйШтрихкод <> Неопределено Тогда
				РезультатОбработки = РезультатыОбработки.Получить(ПервичныйШтрихкод);
			КонецЕсли;
		КонецЕсли;
		
		Если РезультатОбработки = Неопределено Тогда
			Продолжить;
		КонецЕсли;
		
		ДанныеШтрихкода = РезультатОбработки.ДанныеШтрихкода;
		
		НоваяСтрока = ТаблицаСоответствия.Добавить();
		НоваяСтрока.Уровень = ЭлементМассива.Уровень;
		НоваяСтрока.Элемент = ЭлементМассива;
		
		Если ДанныеШтрихкода <> Неопределено
			И Не РезультатОбработки.ТребуетсяОбработкаШтрихкода Тогда
			
			НоваяСтрока.Номенклатура   = ДанныеШтрихкода.Номенклатура;
			НоваяСтрока.Характеристика = ДанныеШтрихкода.Характеристика;
			НоваяСтрока.Серия          = ДанныеШтрихкода.Серия;
			НоваяСтрока.GTIN           = ДанныеШтрихкода.GTIN;
			
			Если ЗаполнятьМРЦ = Неопределено Тогда
				ЗаполнятьМРЦ = ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(РезультатОбработки.ДанныеШтрихкода, "МРЦ");
			КонецЕсли;
			
			Если ЗаполнятьГоденДо = Неопределено Тогда
				ЗаполнятьГоденДо = ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(РезультатОбработки.ДанныеШтрихкода, "ГоденДо");
			КонецЕсли;
			
			Если ЗаполнятьМРЦ Тогда
				НоваяСтрока.МРЦ = ДанныеШтрихкода.МРЦ;
			КонецЕсли;
			
			Если ЗаполнятьГоденДо Тогда
				НоваяСтрока.ГоденДо = ДанныеШтрихкода.ГоденДо;
			КонецЕсли;
			
		КонецЕсли;
		
		ЭлементМассива.Вставить("РезультатОбработки", РезультатОбработки);
		
	КонецЦикла;
	
	ПоляИндекса = Новый Массив;
	ПоляИндекса.Добавить("Уровень");
	ПоляИндекса.Добавить("Номенклатура");
	ПоляИндекса.Добавить("Характеристика");
	ПоляИндекса.Добавить("Серия");
	ПоляИндекса.Добавить("GTIN");
	Если ЗаполнятьМРЦ <> Неопределено И ЗаполнятьМРЦ Тогда
		ПоляИндекса.Добавить("МРЦ");
	КонецЕсли;
	Если ЗаполнятьГоденДо <> Неопределено И ЗаполнятьГоденДо Тогда
		ПоляИндекса.Добавить("ГоденДо");
	КонецЕсли;
	ТаблицаСоответствия.Индексы.Добавить(СтрСоединить(ПоляИндекса, ","));
	
	ПоляСортировки = Новый Массив;
	ПоляСортировки.Добавить("Уровень ВОЗР");
	ПоляСортировки.Добавить("Номенклатура УБЫВ");
	ПоляСортировки.Добавить("Характеристика УБЫВ");
	ПоляСортировки.Добавить("Серия УБЫВ");
	ПоляСортировки.Добавить("GTIN ВОЗР");
	Если ЗаполнятьМРЦ <> Неопределено И ЗаполнятьМРЦ Тогда
		ПоляСортировки.Добавить("МРЦ УБЫВ");
	КонецЕсли;
	Если ЗаполнятьГоденДо <> Неопределено И ЗаполнятьГоденДо Тогда
		ПоляСортировки.Добавить("ГоденДо УБЫВ");
	КонецЕсли;
	ТаблицаСоответствия.Сортировать(СтрСоединить(ПоляСортировки, ","));
	
	СортированныйМассив = Новый Массив;
	Для Каждого СтрокаТЧ Из ТаблицаСоответствия Цикл
		СортированныйМассив.Добавить(СтрокаТЧ.Элемент);
	КонецЦикла;
	
	ДанныеТСД = СортированныйМассив;
	
КонецПроцедуры

//Переносит массивы добавленных и измененных строк по обработанному штрихкоду в общие массивы.
//
//Параметры:
//   Приемник - См. РезультатЗагрузкиШтрихкодовИзТСД
//   Источник - См. ШтрихкодированиеИС.ИнициализироватьРезультатОбработкиШтрихкода
//
Процедура ПеренестиДобавленныеИзмененныеСтроки(Приемник, Источник) Экспорт
	
	Для Каждого СтрокаТовары Из Источник.ДобавленныеСтроки Цикл
		Если Приемник.ДобавленныеСтроки.Найти(СтрокаТовары) = Неопределено Тогда
			Приемник.ДобавленныеСтроки.Добавить(СтрокаТовары);
		КонецЕсли;
	КонецЦикла;
	Источник.ДобавленныеСтроки.Очистить();
	
	Для Каждого СтрокаТовары Из Источник.ИзмененныеСтроки Цикл
		Если Приемник.ИзмененныеСтроки.Найти(СтрокаТовары) = Неопределено
			И Приемник.ДобавленныеСтроки.Найти(СтрокаТовары) = Неопределено Тогда
			Приемник.ИзмененныеСтроки.Добавить(СтрокаТовары);
		КонецЕсли;
	КонецЦикла;
	Источник.ИзмененныеСтроки.Очистить();
	
КонецПроцедуры

// Переносит ошибки при обработке отдельных штрихкодов в общую ошибку
//
// Параметры:
//   РезультатОбработки - См. РезультатЗагрузкиШтрихкодовИзТСД
Процедура ПроверитьНаОшибкиРезультатОбработкиДанныхТСД(РезультатОбработки, Форма, ПараметрыСканирования) Экспорт
	
	ТребуетсяСопоставлениеНоменклатуры = Ложь;
	
	Для Каждого Элемент Из РезультатОбработки.ШтрихкодыТСД Цикл
		
		Если Элемент.РезультатОбработки = Неопределено Тогда
			Элемент.ШтрихкодСОшибкой = Истина;
			Продолжить;
		КонецЕсли;
		
		Если Элемент.РезультатОбработки.ТребуетсяСопоставлениеНоменклатуры Тогда
			ТребуетсяСопоставлениеНоменклатуры = Истина;
		КонецЕсли;
		
		Если Элемент.РезультатОбработки.ТребуетсяУточнениеКоэффициентовУпаковок Тогда
			РезультатОбработки.АдресУточнениеКоэффициентовУпаковок = Элемент.РезультатОбработки.АдресУточнениеКоэффициентовУпаковок;
		КонецЕсли;
		
		Если Элемент.РезультатОбработки.ОбщаяОшибка Тогда
			РезультатОбработки.ОбщаяОшибка      = Истина;
			РезультатОбработки.ТекстОбщейОшибки = Элемент.РезультатОбработки.ТекстОшибки;
		КонецЕсли;
		
		Если Элемент.РезультатОбработки.ЕстьОшибкиВДеревеУпаковок Тогда
			РезультатОбработки.ЕстьОшибкиВДереве   = Истина;
			РезультатОбработки.АдресДереваУпаковок = Элемент.РезультатОбработки.АдресДереваУпаковок;
			Элемент.ШтрихкодСОшибкой = Истина;
		КонецЕсли;
		
		Если ЗначениеЗаполнено(Элемент.РезультатОбработки.ТекстОшибки) Тогда
			Элемент.ШтрихкодСОшибкой = Истина;
		КонецЕсли;
		
	КонецЦикла;
	
	Если РезультатОбработки.ОбщаяОшибка Тогда
		Возврат;
	КонецЕсли;
	
	Если ТребуетсяСопоставлениеНоменклатуры
		И ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(Форма, "КэшМаркируемойПродукции") Тогда
		
		ДанныеДляУточненияСведений = ШтрихкодированиеИСВызовСервера.ДанныеДляУточненияСведенийПользователя(Форма.КэшМаркируемойПродукции);
		Если ДанныеДляУточненияСведений.Операция = "СопоставлениеНоменклатуры" Тогда
			РезультатОбработки.ШтрихкодыДляСопоставления = ДанныеДляУточненияСведений.Данные.ШтрихкодыКСопоставлению;
		КонецЕсли;
		
		Возврат;
		
	КонецЕсли;
	
	ДанныеШтрихкодовСОшибками = Новый Массив;
	Для Каждого Элемент Из РезультатОбработки.ШтрихкодыТСД Цикл
		
		Если Элемент.РезультатОбработки = Неопределено Тогда
			Продолжить;
		КонецЕсли;
		
		Если Элемент.ШтрихкодСОшибкой
			И ТипЗнч(Элемент.РезультатОбработки.ДанныеШтрихкода) = Тип("Структура") Тогда
				ДанныеШтрихкодовСОшибками.Добавить(
					Элемент.РезультатОбработки.ДанныеШтрихкода);
		КонецЕсли;
		
	КонецЦикла;
	
	Если ДанныеШтрихкодовСОшибками.Количество() = 0 И Не РезультатОбработки.ЕстьОшибкиВДереве Тогда
		Возврат;
	КонецЕсли;
	
	Если РезультатОбработки.ЕстьОшибкиВДереве И ДанныеШтрихкодовСОшибками.Количество() > 0 Тогда
		
		ДеревоУпаковок = ПолучитьИзВременногоХранилища(РезультатОбработки.АдресДереваУпаковок);
		
		Для Каждого ДанныеШтрихкода Из ДанныеШтрихкодовСОшибками Цикл
			
			Отбор = Новый Структура(
				"НормализованныйШтрихкод", ДанныеШтрихкода.НормализованныйШтрихкод);
			НайденныеСтроки = ДеревоУпаковок.Строки.НайтиСтроки(Отбор);
			Если НайденныеСтроки.Количество() = 0 Тогда
				НоваяСтрокаДерева = ДеревоУпаковок.Строки.Добавить();
				ЗаполнитьЗначенияСвойств(НоваяСтрокаДерева, ДанныеШтрихкода);
				НоваяСтрокаДерева.ЕстьОшибки = Истина;
			КонецЕсли;
			
		КонецЦикла;
		
		ПоместитьВоВременноеХранилище(ДеревоУпаковок, РезультатОбработки.АдресДереваУпаковок);
		
	ИначеЕсли ДанныеШтрихкодовСОшибками.Количество() > 0 Тогда
		
		РезультатОбработки.ЕстьОшибкиВДереве = Истина;
		ДеревоУпаковок = ИнициализироватьДеревоУпаковок(ПараметрыСканирования);
		
		Для Каждого ДанныеШтрихкода Из ДанныеШтрихкодовСОшибками Цикл
			НоваяСтрокаДерева = ДеревоУпаковок.Строки.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрокаДерева, ДанныеШтрихкода);
			НоваяСтрокаДерева.ЕстьОшибки = Истина;
		КонецЦикла;
		
		РезультатОбработки.АдресДереваУпаковок = ПоместитьВоВременноеХранилище(ДеревоУпаковок, Новый УникальныйИдентификатор);
		
	КонецЕсли;
	
КонецПроцедуры

Функция ИнициализироватьДеревоУпаковок(ПараметрыСканирования) Экспорт
	
	Модуль = ОбщегоНазначения.ОбщийМодуль("ШтрихкодированиеИС");
	ДеревоУпаковок = Модуль.ИнициализироватьДеревоУпаковок();
	
	Если ОбщегоНазначения.ПодсистемаСуществует("ГосИС.ИСМП") Тогда
		
		Если ШтрихкодированиеИС.ДопустимаТабачнаяПродукция(ПараметрыСканирования) Тогда
			Модуль = ОбщегоНазначения.ОбщийМодуль("ШтрихкодированиеМОТП");
			Модуль.НормализоватьСвойстваКоллекцииВложенныхШтрихкодов(ДеревоУпаковок, ПараметрыСканирования);
		КонецЕсли;
		
		Для Каждого ВидПродукции Из ИнтеграцияИСКлиентСервер.ВидыПродукцииИСМП() Цикл
			Если ШтрихкодированиеИСКлиентСервер.ДопустимВидПродукции(ПараметрыСканирования, ВидПродукции) Тогда
				Модуль = ОбщегоНазначения.ОбщийМодуль("ШтрихкодированиеИСМПСлужебный");
				Модуль.НормализоватьСвойстваКоллекцииВложенныхШтрихкодов(ДеревоУпаковок, ПараметрыСканирования);
				Прервать;
			КонецЕсли;
		КонецЦикла;
		
	КонецЕсли;
	
	Если ОбщегоНазначения.ПодсистемаСуществует("ГосИС.ЕГАИС")
		И ШтрихкодированиеИСКлиентСервер.ДопустимВидПродукции(ПараметрыСканирования, Перечисления.ВидыПродукцииИС.Алкогольная) Тогда
		Модуль = ОбщегоНазначения.ОбщийМодуль("ШтрихкодированиеЕГАИС");
		Модуль.НормализоватьКолонкиДереваУпаковок(ДеревоУпаковок);
	КонецЕсли;
	
	Возврат ДеревоУпаковок;
	
КонецФункции

#КонецОбласти

#Область СохраненныйВыборДляГрупповойОбработки

Процедура ОбработатьУточнениеДанных(СохраненныйВыбор, ОбновляемыеШтрихкодыУпаковок, ПараметрыСканирования) Экспорт
	
	КэшированныеЗначения = Неопределено;
	РезультатВыбора = Новый Структура("ДанныеВыбора, ЗапомнитьВыбор", СохраненныйВыбор, Ложь);
	Для Каждого ОбновляемыйЭлемент Из ОбновляемыеШтрихкодыУпаковок Цикл 
		РезультатОбработки = ОбновляемыйЭлемент.РезультатОбработки;
		РезультатОбработки.ДанныеШтрихкода.Номенклатура = Неопределено; //Сбросим для перезаписи
		ШтрихкодированиеИС.ОбработатьУточнениеДанныхДляФормыПроверкиИПодбора(РезультатВыбора, РезультатОбработки, ПараметрыСканирования, КэшированныеЗначения);
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти
