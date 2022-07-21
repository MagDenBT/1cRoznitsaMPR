#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
#Область ОбработчикиДлительныхОпераций

Процедура ПодготовитьДанныеНастроекОбмена(Параметры, АдресРезультата) Экспорт
	
	Результат = Новый Структура;
	Результат.Вставить("НастройкиПодготовлены", Ложь);
	
	РасширенныйРежим = ИнтеграцияУРМКСлужебный.ИспользоватьРасширенныйРежимНастройкиУРМК();
	
	Запрос = Новый Запрос;
	ТекстЗапроса = "
		|ВЫБРАТЬ
		|	УРМККассыККМ.Ссылка КАК УРМК,
		|	УРМККассыККМ.КассаККМ КАК КассаККМ,
		|	ВЫБОР
		|		КОГДА НЕ ОбменСУРМК.Код ЕСТЬ NULL
		|			ТОГДА ИСТИНА
		|	КОНЕЦ КАК УзелНастроен
		|ПОМЕСТИТЬ втУРМККассыККМ
		|ИЗ
		|	Справочник.УниверсальныеРабочиеМестаКассиров.КассыККМ КАК УРМККассыККМ
		|		ЛЕВОЕ СОЕДИНЕНИЕ ПланОбмена.ОбменСУРМК КАК ОбменСУРМК
		|		ПО (УРМККассыККМ.Ссылка = ОбменСУРМК.УРМК)
		|ГДЕ
		|	НЕ УРМККассыККМ.Ссылка.ПометкаУдаления
		|	И УРМККассыККМ.Ссылка.ТорговыйОбъект = &ТорговыйОбъект
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ОбменСУРМККассыККМ.КассаККМ КАК КассаККМ
		|ПОМЕСТИТЬ втКассыККМОбменСУРМК
		|ИЗ
		|	ПланОбмена.ОбменСУРМК.КассыККМ КАК ОбменСУРМККассыККМ
		|ГДЕ
		|	НЕ ОбменСУРМККассыККМ.Ссылка.ЭтотУзел
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ РАЗЛИЧНЫЕ ПЕРВЫЕ 1
		|	КассыККМ.Ссылка КАК КассаККМ,
		|	[Организация]
		|	втУРМККассыККМ.УРМК КАК УРМК
		|ИЗ
		|	[КассаККМУРМК] КАК КассыККМ
		|		ЛЕВОЕ СОЕДИНЕНИЕ втУРМККассыККМ КАК втУРМККассыККМ
		|		ПО (втУРМККассыККМ.КассаККМ = КассыККМ.Ссылка)
		|		ЛЕВОЕ СОЕДИНЕНИЕ втКассыККМОбменСУРМК КАК втКассыККМОбменСУРМК
		|		ПО (втКассыККМОбменСУРМК.КассаККМ = КассыККМ.Ссылка)
		|ГДЕ
		|	НЕ КассыККМ.ПометкаУдаления
		|	[ПереопределяемыеОтборы]
		|	И [ТорговыйОбъект] = &ТорговыйОбъект
		|	И втКассыККМОбменСУРМК.КассаККМ ЕСТЬ NULL
		|	И втУРМККассыККМ.УзелНастроен ЕСТЬ NULL
		|	[РасширенныйРежим]
		|";

	МетаданныеКассыККМ = ИнтеграцияУРМКСлужебный.МетаданныеПоОпределяемомуТипу("КассаККМУРМК");
	
	ПустаяСсылкаКассаККМ = Метаданные.ОпределяемыеТипы.КассаККМУРМК.Тип.ПривестиЗначение();
	ПустаяСсылкаТорговыйОбъект = Метаданные.ОпределяемыеТипы.ТорговыйОбъектУРМК.Тип.ПривестиЗначение();
	
	ТорговыйОбъектТипРеквизитаСтрокой = ОбщегоНазначения.СтроковоеПредставлениеТипа(ТипЗнч(ПустаяСсылкаТорговыйОбъект));
	ИмяРеквизитаТорговыйОбъект = ИнтеграцияУРМКСлужебный.ИменаРеквизитовПоТипу(ПустаяСсылкаКассаККМ, Тип(ТорговыйОбъектТипРеквизитаСтрокой));
	
	ПустаяСсылкаОрганизация = Метаданные.ОпределяемыеТипы.ОрганизацияУРМК.Тип.ПривестиЗначение();
	ОрганизацияТипРеквизитаСтрокой = ОбщегоНазначения.СтроковоеПредставлениеТипа(ТипЗнч(ПустаяСсылкаОрганизация));
	ИмяРеквизитаОрганизация = ИнтеграцияУРМКСлужебный.ИменаРеквизитовПоТипу(ПустаяСсылкаКассаККМ, Тип(ОрганизацияТипРеквизитаСтрокой));

	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "[КассаККМУРМК]", МетаданныеКассыККМ.ПолноеИмя());
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "[ТорговыйОбъект]",
		?(ИмяРеквизитаТорговыйОбъект = "","", "КассыККМ." + ИмяРеквизитаТорговыйОбъект));
		
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "[Организация]",
		?(ИмяРеквизитаОрганизация = "","", "КассыККМ." +ИмяРеквизитаОрганизация+ " КАК Организация,"));

	ПереопределяемыеОтборы = ИнтеграцияУРМКПереопределяемый.ОтборыТекстаЗапросовПодготовитьДанныеНастроекОбмена();	
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "[ПереопределяемыеОтборы]", ?(ПереопределяемыеОтборы = "","", ПереопределяемыеОтборы));
	
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "[РасширенныйРежим]", ?(РасширенныйРежим, "И НЕ втУРМККассыККМ.УРМК ЕСТЬ NULL", ""));
		
	Запрос.УстановитьПараметр("ТорговыйОбъект", Параметры.ТорговыйОбъект);
	Запрос.Текст = ТекстЗапроса;
	
	РезультатЗапроса = Запрос.Выполнить();
	Выборка = РезультатЗапроса.Выбрать();
	
	Пока Выборка.Следующий() Цикл
		
		Если ЗначениеЗаполнено(Выборка.УРМК) Тогда
			УРМК = Выборка.УРМК;
		Иначе
			УРМКОбъект = Справочники.УниверсальныеРабочиеМестаКассиров.СоздатьЭлемент();
			
			Нименование = НСтр("ru = 'РМК (%1)'");
			УРМКОбъект.Наименование = СтрШаблон(Нименование, Выборка.КассаККМ.Наименование);
			
			ЗаполнитьЗначенияСвойств(УРМКОбъект, Параметры);
			
			НоваяСтрока = УРМКОбъект.КассыККМ.Добавить();
			НоваяСтрока.КассаККМ = Выборка.КассаККМ;
			
			Попытка
				УРМКОбъект.Записать();
				УРМК = УРМКОбъект.Ссылка;
			Исключение
				УРМК = Справочники.УниверсальныеРабочиеМестаКассиров.ПустаяСсылка();
			КонецПопытки;
		КонецЕсли;

		Сч = 0;
		ПрефиксПриемника = "";
		ВсеСимвольныеПрефиксыЗаняты = Ложь;
		Пока Не ЗначениеЗаполнено(ПрефиксПриемника) Цикл
			Если Сч > 100 Тогда 
				ВсеСимвольныеПрефиксыЗаняты = Истина;
				Если Сч > 200 Тогда // Пора выходить из цикла
					Результат.Вставить("НумерацияЗакончилась");
					Прервать;
				КонецЕсли;
			КонецЕсли;				
			ГСЧ = Новый ГенераторСлучайныхЧисел(ТекущаяУниверсальнаяДатаВМиллисекундах());
			Для Проход = 1 по 2 Цикл
				СлучайныйСимвол = Символ(ГСЧ.СлучайноеЧисло(1040,1060));
				ПрефиксПриемника = ПрефиксПриемника + СлучайныйСимвол;
			КонецЦикла;
			Если ВсеСимвольныеПрефиксыЗаняты Тогда
				СлучайноеЧисло = ГСЧ.СлучайноеЧисло(0,9);
				ПрефиксПриемника = СтрЗаменить(ПрефиксПриемника, Прав(СокрЛП(ПрефиксПриемника), 1), СлучайноеЧисло);
			КонецЕсли;
			Если ЗначениеЗаполнено(ПланыОбмена.ОбменСУРМК.НайтиПоКоду(ПрефиксПриемника)) Тогда
				ПрефиксПриемника = "";
				Сч = Сч + 1;
			КонецЕсли;
		КонецЦикла;
			
		Параметры.Вставить("УРМК", УРМК);
		Параметры.Вставить("КассаККМ", Выборка.КассаККМ);
		Параметры.Вставить("Организация", Выборка.Организация);
		Параметры.Вставить("НаименованиеВторойБазы",  УРМК.Наименование);
		Параметры.Вставить("КодНовогоУзлаВторойБазы", ПрефиксПриемника);
		Параметры.Вставить("КодУзлаКорреспондента",   ПрефиксПриемника);
		Параметры.Вставить("ПрефиксИнформационнойБазыПриемника", ПрефиксПриемника);
		
		Если ЗначениеЗаполнено(ПрефиксПриемника) Тогда
			
			Результат.Вставить("НастройкиПодготовлены", Истина);
			
			Если Параметры.ИспользоватьПараметрыТранспортаFILE Тогда
				
				КаталогНастроек = Параметры.FILEКаталогОбменаИнформацией;
				Параметры.FILEКаталогОбменаИнформацией = ПодкаталогПоПрефиксуПриемника(КаталогНастроек, ПрефиксПриемника, Результат);
				
			ИначеЕсли Параметры.ИспользоватьПараметрыТранспортаFTP Тогда
				
				КаталогНастроек = Параметры.КаталогНастроекПодключенияДляВыгрузки;
				Параметры.КаталогНастроекПодключенияДляВыгрузки = ПодкаталогПоПрефиксуПриемника(КаталогНастроек, ПрефиксПриемника, Результат);

			КонецЕсли;

		КонецЕсли;
		Результат.Вставить("НастройкиОбмена", Параметры);
	КонецЦикла;
	
	ПоместитьВоВременноеХранилище(Результат, АдресРезультата);
	
КонецПроцедуры

Функция ПодкаталогПоПрефиксуПриемника(КаталогНастроек, ПрефиксПриемника, Результат)
	
	Каталог = ОбщегоНазначенияКлиентСервер.ДобавитьКонечныйРазделительПути(КаталогНастроек) + ПрефиксПриемника;
	
	СоздатьКаталог(Каталог);
	
	КаталогНаДиске = Новый Файл(Каталог);
    Если Не КаталогНаДиске.Существует() Тогда
		Результат.Вставить("НастройкиПодготовлены", Ложь);
		Результат.Вставить("ОшибкаСозданияКаталога");
	Иначе
		Возврат Каталог;
	КонецЕсли;

	Возврат "";
	
КонецФункции

Процедура ЗарегистрироватьДанныеДляНачальнойВыгрузки(Параметры, АдресРезультата) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);

	ОбменДаннымиСервер.ЗарегистрироватьДанныеДляНачальнойВыгрузки(Параметры.УзелОбмена);
	
	Результат = Новый Структура;
	Результат.Вставить("ДанныеЗарегистрированы", Истина);
	
	ПоместитьВоВременноеХранилище(Результат, АдресРезультата);
	
	УстановитьПривилегированныйРежим(Ложь);
	
КонецПроцедуры

Процедура ВыгрузитьДанные(Параметры, АдресРезультата) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	УзелОбмена = Параметры.УзелОбмена;
	КаталогОбмена = Параметры.КаталогОбмена;
	ДействиеПриОбмене = Перечисления.ДействияПриОбмене.ВыгрузкаДанных;
	
	КодОтправителя = ОбменДаннымиСервер.ИдентификаторЭтогоУзлаДляОбмена(УзелОбмена);
	КодПолучателя  = ОбменДаннымиСервер.ИдентификаторУзлаКорреспондентаДляОбмена(УзелОбмена);

	ИмяФайла = ИмяФайлаСообщенияОбмена(КодОтправителя, КодПолучателя);
	ИмяФайлаДляВыгрузки = ОбщегоНазначенияКлиентСервер.ПолучитьПолноеИмяФайла(
		КаталогОбмена, ИмяФайла + ".xml");
	
	ЗафиксироватьНачалоОбмена(УзелОбмена, ДействиеПриОбмене);
	
	Попытка
		ОбработкаКонвертацииXDTO = Обработки.КонвертацияОбъектовXDTO.Создать();
	
		ОбработкаКонвертацииXDTO.РежимОбмена = "Выгрузка";
		ОбработкаКонвертацииXDTO.УзелДляОбмена = УзелОбмена;
		ОбработкаКонвертацииXDTO.ИмяФайлаОбмена = ИмяФайлаДляВыгрузки;
		ОбработкаКонвертацииXDTO.КлючСообщенияЖурналаРегистрации = ОбменДаннымиСервер.КлючСообщенияЖурналаРегистрации(УзелОбмена, ДействиеПриОбмене);
		
		ОбработкаКонвертацииXDTO.ВыполнитьВыгрузкуДанных();
		
		Если РезультатВыполненияОбменаВыполнено(ОбработкаКонвертацииXDTO.РезультатВыполненияОбмена()) Тогда
			
			Результат = Новый Структура;
			Результат.Вставить("ДанныеВыгружены", Истина);
			
			ПоместитьВоВременноеХранилище(Результат, АдресРезультата);

		Иначе
			ВызватьИсключение ОбработкаКонвертацииXDTO.СтрокаСообщенияОбОшибке();
		КонецЕсли;
		
		ЗафиксироватьЗавершениеОбмена(
			УзелОбмена,
			ДействиеПриОбмене,
			ОбработкаКонвертацииXDTO.РезультатВыполненияОбмена());
	Исключение
		ЗафиксироватьЗавершениеОбмена(
			УзелОбмена,
			ДействиеПриОбмене,
			Перечисления.РезультатыВыполненияОбмена.Ошибка);
		ВызватьИсключение;
	КонецПопытки;
		
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ЗафиксироватьНачалоОбмена(УзелОбмена, ДействиеПриОбмене)
	
	СтруктураЗаписи = Новый Структура;
	СтруктураЗаписи.Вставить("УзелИнформационнойБазы", УзелОбмена);
	СтруктураЗаписи.Вставить("ДействиеПриОбмене",      ДействиеПриОбмене);
	СтруктураЗаписи.Вставить("ДатаНачала",             ТекущаяДатаСеанса());
	
	РегистрыСведений.СостоянияОбменовДанными.ОбновитьЗапись(СтруктураЗаписи);
	
КонецПроцедуры

Процедура ЗафиксироватьЗавершениеОбмена(УзелОбмена, ДействиеПриОбмене, РезультатВыполнения)
	
	СтруктураЗаписи = Новый Структура;
	СтруктураЗаписи.Вставить("УзелИнформационнойБазы",    УзелОбмена);
	СтруктураЗаписи.Вставить("ДействиеПриОбмене",         ДействиеПриОбмене);
	СтруктураЗаписи.Вставить("ДатаОкончания",             ТекущаяДатаСеанса());
	СтруктураЗаписи.Вставить("РезультатВыполненияОбмена", РезультатВыполнения);
	
	РегистрыСведений.СостоянияОбменовДанными.ОбновитьЗапись(СтруктураЗаписи);
	
	Если РезультатВыполненияОбменаВыполнено(РезультатВыполнения) Тогда
		РегистрыСведений.СостоянияУспешныхОбменовДанными.ДобавитьЗапись(СтруктураЗаписи);
	КонецЕсли;
	
КонецПроцедуры

Функция РезультатВыполненияОбменаВыполнено(РезультатВыполненияОбмена)
	
	Возврат РезультатВыполненияОбмена = Неопределено
		Или РезультатВыполненияОбмена = Перечисления.РезультатыВыполненияОбмена.Выполнено
		Или РезультатВыполненияОбмена = Перечисления.РезультатыВыполненияОбмена.ВыполненоСПредупреждениями;
	
КонецФункции

Функция ИмяФайлаСообщенияОбмена(КодУзлаОтправителя, КодУзлаПолучателя)
	
	ШаблонИмени = "[Префикс]_[УзелОтправитель]_[УзелПолучатель]";
	ШаблонИмени = СтрЗаменить(ШаблонИмени, "[Префикс]",         "Message");
	ШаблонИмени = СтрЗаменить(ШаблонИмени, "[УзелОтправитель]", КодУзлаОтправителя);
	ШаблонИмени = СтрЗаменить(ШаблонИмени, "[УзелПолучатель]",  КодУзлаПолучателя);
	
	Возврат ШаблонИмени;
	
КонецФункции

#КонецОбласти

#Область Печать

Функция СформироватьПечатнуюФормуКодыПодключения(ТаблицаНастройкиПечати) Экспорт
	
	ТабличныйДокумент = Новый ТабличныйДокумент;
	
	ТабличныйДокумент.АвтоМасштаб = Истина;
	ТабличныйДокумент.ПолеСправа  = 2;
	ТабличныйДокумент.ПолеСлева   = 2;
	
	МакетКодыПодключения = УправлениеПечатью.МакетПечатнойФормы("Обработка.ПомощникНастройкиОбменаУРМК.КодыПодключения");
	ОбластьКодПодключения = МакетКодыПодключения.ПолучитьОбласть("Строка");
	
	ПользовательОбмена = Пользователи.ТекущийПользователь();
	
	Для каждого СтрокаНастроекПечати Из ТаблицаНастройкиПечати Цикл
		ОбластьКодПодключения.Параметры.УРМК = СтрокаНастроекПечати.УРМК;
		ОбластьКодПодключения.Параметры.КодУзла = СтрокаНастроекПечати.КодУзла;
		ОбластьКодПодключения.Параметры.АдресПубликации = СтрокаНастроекПечати.АдресПубликации;
		
		РисунокШтрихкод = ОбластьКодПодключения.Рисунки.ШтрихкодПечать;
		
		ПараметрыКартинки = Новый Структура;
		ПараметрыКартинки.Вставить("Ширина", 175);
		ПараметрыКартинки.Вставить("Высота", 175);
		
		СтрокаДляКодирования = СтрокаНастроекПечати.АдресПубликации + ";"
			+ СтрокаНастроекПечати.КодУзла + ";"
			+ ПользовательОбмена.Наименование;

		РезультатГенерацииШтрихкода = ИнтеграцияУРМКСлужебный.ПолучитьКартинкуQRКода(
			ПараметрыКартинки,
			СтрокаДляКодирования);
			
		Если РезультатГенерацииШтрихкода.Картинка <> Неопределено Тогда
			РисунокШтрихкод.Картинка = РезультатГенерацииШтрихкода.Картинка;
		Иначе
			ОбщегоНазначения.СообщитьПользователю(НСтр("ru = 'При генерации картинки штрихкода произошла ошибка'"));
		КонецЕсли;

		ТабличныйДокумент.Вывести(ОбластьКодПодключения);
	КонецЦикла;
	
	Возврат ТабличныйДокумент;
	
КонецФункции

#КонецОбласти

#КонецЕсли