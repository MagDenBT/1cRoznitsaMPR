
#Область ПрограммныйИнтерфейс

// См. СПАРКРискиКлиентСерверПереопределяемый.ПриОпределенииСвойствКонтрагентаВОбъекте
//
Процедура ПриОпределенииСвойствКонтрагентаВОбъекте(КонтрагентОбъект, Форма, СвойстваКонтрагента) Экспорт
	
	СвойстваКонтрагента.ИНН 			 = КонтрагентОбъект.ИНН; 
	СвойстваКонтрагента.ВидКонтрагента 	 = ВидКонтрагентаСПАРКРиски(КонтрагентОбъект.ЮрФизЛицо);
	
	Если ТипЗнч(КонтрагентОбъект.Ссылка) = Тип("СправочникСсылка.Контрагенты") Тогда
		
		СвойстваКонтрагента.ПодлежитПроверке = ЭтоЮридическоеЛицо(КонтрагентОбъект.ЮрФизЛицо)
																	Или ЭтоИндивидуальныйПредприниматель(КонтрагентОбъект.ЮрФизЛицо);
			
	Иначе
		
		СвойстваКонтрагента.ПодлежитПроверке = ЭтоЮридическоеЛицо(КонтрагентОбъект.ЮрФизЛицо)
												Или ЭтоИндивидуальныйПредприниматель(КонтрагентОбъект.ЮрФизЛицо);
		СвойстваКонтрагента.СвояОрганизация  = Истина;
		
	КонецЕсли;
	
КонецПроцедуры

// Определяет способ получения данных о контрагенте.
//
// Параметры:
//  КонтрагентЮрФизЛицо - СправочникСсылка.Контрагенты, ПеречислениеСсылка.ЮрФизЛицо
// 
// Возвращаемое значение:
//   - ПеречислениеСсылка.ВидыКонтрагентовСПАРКРиски
//
Функция ВидКонтрагентаСПАРКРиски(КонтрагентЮрФизЛицо) Экспорт
	
	Если Не ЗначениеЗаполнено(КонтрагентЮрФизЛицо) Тогда
		ЮрФизЛицо = ПредопределенноеЗначение("Перечисление.ЮрФизЛицо.ПустаяСсылка");
	ИначеЕсли ТипЗнч(КонтрагентЮрФизЛицо) = Тип("СправочникСсылка.Контрагенты") Тогда
		ЮрФизЛицо = ОбщегоНазначенияРТВызовСервера.ЗначениеРеквизитаОбъекта(КонтрагентЮрФизЛицо, "ЮрФизЛицо");
	ИначеЕсли ТипЗнч(КонтрагентЮрФизЛицо) = Тип("ПеречислениеСсылка.ЮрФизЛицо") Тогда
		ЮрФизЛицо = КонтрагентЮрФизЛицо;
	Иначе
		ЮрФизЛицо = ПредопределенноеЗначение("Перечисление.ЮрФизЛицо.ПустаяСсылка");
	КонецЕсли;
	
	Если ЭтоЮридическоеЛицо(ЮрФизЛицо) Тогда
		Возврат ПредопределенноеЗначение("Перечисление.ВидыКонтрагентовСПАРКРиски.ЮридическоеЛицо");
	ИначеЕсли ЭтоИндивидуальныйПредприниматель(ЮрФизЛицо) Тогда
		Возврат ПредопределенноеЗначение("Перечисление.ВидыКонтрагентовСПАРКРиски.ИндивидуальныйПредприниматель");
	Иначе
		Возврат ПредопределенноеЗначение("Перечисление.ВидыКонтрагентовСПАРКРиски.ПустаяСсылка");
	КонецЕсли;
	
КонецФункции

#Область ИндексыСПАРККонтрагента

// Выводит информацию об индексах СПАРК Риски в элемент управления.
// В случае, если информации нет в кэше, то инициируется фоновое задание.
// Если передан ИНН, то информация получается напрямую из веб-сервиса без фонового задания.
//
// Параметры:
//  РезультатИндексыКонтрагента - Структура - ключи описаны в СПАРКРискиКлиентСервер.НовыйДанныеИндексов();
//  КонтрагентОбъект            - Объект, Неопределено - заполняется в том случае, если форма - это форма элемента справочника, а не форма документа.
//  Контрагент                  - ОпределяемыйТип.КонтрагентБИП, Строка - Контрагент или ИНН контрагента;
//  Форма                       - ФормаКлиентскогоПриложения - форма, в которой необходимо вывести информацию об индексах СПАРК Риски.
//  ИспользованиеРазрешено      - Булево - признак разрешения использования функциональности;
//  Параметры                   - Структура - прочие параметры;
//  СтандартнаяОбработка        - Булево - если вернуть сюда Ложь, то стандартная обработка не будет происходить.
//
//@skip-warning
Процедура ОтобразитьИндексыСПАРК(
			РезультатИндексыКонтрагента,
			КонтрагентОбъект,
			Контрагент,
			Форма,
			ИспользованиеРазрешено,
			Параметры,
			СтандартнаяОбработка) Экспорт
	
	СтандартнаяОбработка = Истина;

	Если Форма.ИмяФормы = "Справочник.Контрагенты.Форма.ФормаЭлемента" Тогда
		
		// На форме должно быть несколько элементов управления:
		// - ДекорацияИндексыСПАРКРискиСтрока1Заголовок;
		// - ДекорацияИндексыСПАРКРискиСтрока1Значение;
		// - ДекорацияИндексыСПАРКРискиСтрока2Заголовок;
		// - ДекорацияИндексыСПАРКРискиСтрока2Значение;
		// - ДекорацияИндексыСПАРКРискиСтрока3Заголовок;
		// - ДекорацияИндексыСПАРКРискиСтрока3Значение;
		// - ДекорацияИндексыСПАРКРискиСтрока4Заголовок;
		// - ДекорацияИндексыСПАРКРискиСтрока4Значение;
		// - КартинкаОжиданиеЗагрузкиИндексовСПАРКРиски.

		СтандартнаяОбработка = Ложь;
		Элементы = Форма.Элементы;
		Если Не ИспользованиеРазрешено Тогда
			Элементы.ГруппаИндексыСПАРКРиски.Видимость = Ложь;
			Возврат;
		КонецЕсли;
		
		Если РезультатИндексыКонтрагента.ПодлежитПроверке Тогда
			Элементы.ГруппаИндексыСПАРКРиски.Видимость = Истина;
			Элементы.ДекорацияИндексыСПАРКРискиСтрока1Заголовок.Заголовок = Новый ФорматированнаяСтрока(
				НСтр("ru='1СПАРК Риски'"),
				Новый Шрифт(Элементы.ДекорацияИндексыСПАРКРискиСтрока1Заголовок.Шрифт, , , Истина)); // Жирный шрифт;
			Элементы.ДекорацияИндексыСПАРКРискиСтрока1Заголовок.Видимость = Истина;
			Элементы.ДекорацияИндексыСПАРКРискиСтрока1Значение.Видимость  = Ложь;
			Элементы.КартинкаОжиданиеЗагрузкиИндексовСПАРКРиски.Видимость = Ложь;

			ЦветСтиляЦветОсобогоТекста = ОбщегоНазначенияВызовСервера.ЦветСтиля("ЦветОсобогоТекста");

			ЕстьОшибкаПодключения = Истина;

			ВидОшибки               = РезультатИндексыКонтрагента.ВидОшибки;
			СостояниеВыводаДанных   = РезультатИндексыКонтрагента.СостояниеВыводаДанных;
			СостояниеЗагрузкиДанных = РезультатИндексыКонтрагента.СостояниеЗагрузкиДанных;

			Если (ВидОшибки = ПредопределенноеЗначение("Перечисление.ВидыОшибокСПАРКРиски.ВнутренняяОшибкаСервиса"))
					ИЛИ (ВидОшибки = ПредопределенноеЗначение("Перечисление.ВидыОшибокСПАРКРиски.ИнтернетПоддержкаНеПодключена"))
					ИЛИ (ВидОшибки = ПредопределенноеЗначение("Перечисление.ВидыОшибокСПАРКРиски.ИспользованиеЗапрещено"))
					ИЛИ (ВидОшибки = ПредопределенноеЗначение("Перечисление.ВидыОшибокСПАРКРиски.НеизвестнаяОшибка"))
					ИЛИ (ВидОшибки = ПредопределенноеЗначение("Перечисление.ВидыОшибокСПАРКРиски.НекорректныйЗапрос"))
					ИЛИ (ВидОшибки = ПредопределенноеЗначение("Перечисление.ВидыОшибокСПАРКРиски.НеПодлежитПроверке"))
					ИЛИ (ВидОшибки = ПредопределенноеЗначение("Перечисление.ВидыОшибокСПАРКРиски.ОшибкаПодключения"))
					ИЛИ (ВидОшибки = ПредопределенноеЗначение("Перечисление.ВидыОшибокСПАРКРиски.ПревышеноКоличествоПопытокАутентификации"))
					ИЛИ (ВидОшибки = ПредопределенноеЗначение("Перечисление.ВидыОшибокСПАРКРиски.ТребуетсяОплатаИлиПревышенЛимит")) Тогда
				// Эти виды ошибок никак не отображаются на форме.
			ИначеЕсли ВидОшибки = ПредопределенноеЗначение("Перечисление.ВидыОшибокСПАРКРиски.НеизвестныйИНН") Тогда
				ЕстьОшибкаПодключения = Ложь;
				Элементы.ДекорацияИндексыСПАРКРискиСтрока2Заголовок.Заголовок = НСтр("ru='Нет информации о контрагенте'");
				Элементы.ДекорацияИндексыСПАРКРискиСтрока2Заголовок.Видимость = Истина;
				Элементы.ДекорацияИндексыСПАРКРискиСтрока2Значение.Видимость  = Ложь;
				Элементы.ДекорацияИндексыСПАРКРискиСтрока3Заголовок.Видимость = Ложь;
				Элементы.ДекорацияИндексыСПАРКРискиСтрока3Значение.Видимость  = Ложь;
				Элементы.ДекорацияИндексыСПАРКРискиСтрока4Заголовок.Видимость = Ложь;
				Элементы.ДекорацияИндексыСПАРКРискиСтрока4Значение.Видимость  = Ложь;
				Элементы.ДекорацияИндексыСПАРКРискиСтрока5Заголовок.Видимость = Ложь;
				Элементы.ДекорацияИндексыСПАРКРискиСтрока5Значение.Видимость  = Ложь;
				Элементы.КартинкаОжиданиеЗагрузкиИндексовСПАРКРиски.Видимость = Ложь;
			ИначеЕсли ВидОшибки = ПредопределенноеЗначение("Перечисление.ВидыОшибокСПАРКРиски.НекорректныйИНН") Тогда
				// Оба состояния должны обрабатываться одинаково (вывести сообщение об ошибке):
				// - пустой ИНН;
				// - некорректный ИНН.
				ЕстьОшибкаПодключения = Ложь;
				Элементы.ДекорацияИндексыСПАРКРискиСтрока2Заголовок.Заголовок =
					Новый ФорматированнаяСтрока(НСтр("ru='Нет информации о контрагенте'"),
					,
					ЦветСтиляЦветОсобогоТекста);
				Элементы.ДекорацияИндексыСПАРКРискиСтрока2Заголовок.Видимость = Истина;
				Элементы.ДекорацияИндексыСПАРКРискиСтрока2Значение.Видимость  = Ложь;
				Элементы.ДекорацияИндексыСПАРКРискиСтрока3Заголовок.Видимость = Ложь;
				Элементы.ДекорацияИндексыСПАРКРискиСтрока3Значение.Видимость  = Ложь;
				Элементы.ДекорацияИндексыСПАРКРискиСтрока4Заголовок.Видимость = Ложь;
				Элементы.ДекорацияИндексыСПАРКРискиСтрока4Значение.Видимость  = Ложь;
				Элементы.ДекорацияИндексыСПАРКРискиСтрока5Заголовок.Видимость = Ложь;
				Элементы.ДекорацияИндексыСПАРКРискиСтрока5Значение.Видимость  = Ложь;
				Элементы.КартинкаОжиданиеЗагрузкиИндексовСПАРКРиски.Видимость = Ложь;
			Иначе // Пустое поле - ошибок нет.
				ЕстьОшибкаПодключения = Ложь;
				ЕстьОшибкаПолученияДанных = Ложь;

				ТекстОшибки = "";
				ЦветТекстаОшибки = ЦветСтиляЦветОсобогоТекста;
				Если СостояниеВыводаДанных = ПредопределенноеЗначение("Перечисление.СостоянияВыводаИндексовСПАРКРиски.ВКэшеНетДанных") Тогда
					ЕстьОшибкаПолученияДанных = Истина;
					Если СостояниеЗагрузкиДанных = ПредопределенноеЗначение("Перечисление.СостоянияЗагрузкиИндексовСПАРКРиски.ЗапущеноФоновоеЗадание") Тогда
						ТекстОшибки = НСтр("ru='Получение данных...'");
						ЦветТекстаОшибки = Неопределено; // Авто
					ИначеЕсли СостояниеЗагрузкиДанных = ПредопределенноеЗначение("Перечисление.СостоянияЗагрузкиИндексовСПАРКРиски.ОтменаФоновогоЗадания") Тогда
						ТекстОшибки = НСтр("ru='Ошибка получения данных (слишком медленное соединение или отменено администратором)'");
					ИначеЕсли СостояниеЗагрузкиДанных = ПредопределенноеЗначение("Перечисление.СостоянияЗагрузкиИндексовСПАРКРиски.ОшибкаФоновогоЗадания") Тогда
						ТекстОшибки = НСтр("ru='Ошибка получения данных'");
					Иначе // Загрузка завершена или не осуществлялась.
						ТекстОшибки = НСтр("ru='Ошибка получения данных (данные не получены)'");
					КонецЕсли;
				ИначеЕсли СостояниеВыводаДанных = ПредопределенноеЗначение("Перечисление.СостоянияВыводаИндексовСПАРКРиски.ВКэшеУстаревшиеДанные") Тогда
				ИначеЕсли СостояниеВыводаДанных = ПредопределенноеЗначение("Перечисление.СостоянияВыводаИндексовСПАРКРиски.НеправильныйИНН") Тогда
					ЕстьОшибкаПолученияДанных = Истина;
					ТекстОшибки = НСтр("ru='Нет информации о контрагенте'");
				ИначеЕсли СостояниеВыводаДанных = ПредопределенноеЗначение("Перечисление.СостоянияВыводаИндексовСПАРКРиски.ПолученоИзКэша") Тогда
				ИначеЕсли СостояниеВыводаДанных = ПредопределенноеЗначение("Перечисление.СостоянияВыводаИндексовСПАРКРиски.ПолученоИзФоновогоЗадания") Тогда
				Иначе
					ЕстьОшибкаПолученияДанных = Истина;
					ТекстОшибки = НСтр("ru='Неопределенная ошибка'");
				КонецЕсли;

				Если СостояниеЗагрузкиДанных = ПредопределенноеЗначение("Перечисление.СостоянияЗагрузкиИндексовСПАРКРиски.ЗапущеноФоновоеЗадание") Тогда
					Элементы.КартинкаОжиданиеЗагрузкиИндексовСПАРКРиски.Видимость = Истина;
				Иначе
					Элементы.КартинкаОжиданиеЗагрузкиИндексовСПАРКРиски.Видимость = Ложь;
				КонецЕсли;

				Если ЕстьОшибкаПолученияДанных = Истина Тогда
					Элементы.ДекорацияИндексыСПАРКРискиСтрока2Заголовок.Заголовок =
						Новый ФорматированнаяСтрока(ТекстОшибки, , ЦветТекстаОшибки);
					Элементы.ДекорацияИндексыСПАРКРискиСтрока2Заголовок.Видимость = Истина;
					Элементы.ДекорацияИндексыСПАРКРискиСтрока2Значение.Видимость  = Ложь;
					Элементы.ДекорацияИндексыСПАРКРискиСтрока3Заголовок.Видимость = Ложь;
					Элементы.ДекорацияИндексыСПАРКРискиСтрока3Значение.Видимость  = Ложь;
					Элементы.ДекорацияИндексыСПАРКРискиСтрока4Заголовок.Видимость = Ложь;
					Элементы.ДекорацияИндексыСПАРКРискиСтрока4Значение.Видимость  = Ложь;
					Элементы.ДекорацияИндексыСПАРКРискиСтрока5Заголовок.Видимость = Ложь;
					Элементы.ДекорацияИндексыСПАРКРискиСтрока5Значение.Видимость  = Ложь;
				Иначе
					
					// Если контрагент не активен, вывести сообщение "Контрагент прекратил деятельность %ДатаСтатуса%".
					Если (РезультатИндексыКонтрагента.Активен <> Истина) Тогда
						Элементы.ДекорацияИндексыСПАРКРискиСтрока2Заголовок.Заголовок = Новый ФорматированнаяСтрока(
								СтрШаблон(
									НСтр("ru='Контрагент прекратил деятельность %1'"),
									Формат(РезультатИндексыКонтрагента.ДатаСтатуса, "ДЛФ=D")),
								,
								ЦветСтиляЦветОсобогоТекста);
						Элементы.ДекорацияИндексыСПАРКРискиСтрока2Значение.Видимость  = Ложь;
						Элементы.ДекорацияИндексыСПАРКРискиСтрока3Заголовок.Видимость = Ложь;
						Элементы.ДекорацияИндексыСПАРКРискиСтрока3Значение.Видимость  = Ложь;
						Элементы.ДекорацияИндексыСПАРКРискиСтрока4Заголовок.Видимость = Ложь;
						Элементы.ДекорацияИндексыСПАРКРискиСтрока4Значение.Видимость  = Ложь;
						Элементы.ДекорацияИндексыСПАРКРискиСтрока5Заголовок.Видимость = Ложь;
						Элементы.ДекорацияИндексыСПАРКРискиСтрока5Значение.Видимость  = Ложь;
					Иначе

						Строка2Заполнена = Ложь;
						Строка3Заполнена = Ложь;
						Строка4Заполнена = Ложь;
						Строка5Заполнена = Ложь;
						МассивСтрок = Новый Массив;

						ИнформацияВыведена = Ложь;

						// Если есть событие, вывести его. В противном случае - индексы.
						Если РезультатИндексыКонтрагента.Свойство("ОтображатьСтатус")
							И РезультатИндексыКонтрагента.ОтображатьСтатус = Истина
							И НЕ ПустаяСтрока(РезультатИндексыКонтрагента.СтатусНазвание) Тогда
							Элементы.ДекорацияИндексыСПАРКРискиСтрока2Заголовок.Заголовок = Новый ФорматированнаяСтрока(
								РезультатИндексыКонтрагента.СтатусНазвание,
								,
								ЦветСтиляЦветОсобогоТекста);
							Элементы.ДекорацияИндексыСПАРКРискиСтрока2Значение.Видимость = Ложь;
							Строка2Заполнена = Истина;
							ИнформацияВыведена = Истина;
						КонецЕсли;

						Если (РезультатИндексыКонтрагента.ИндексДолжнойОсмотрительности >= 0)
								И (РезультатИндексыКонтрагента.ИндексДолжнойОсмотрительности <= 100) Тогда
							МассивСтрок.Добавить(Новый Структура("Заголовок, Значение",
								Новый ФорматированнаяСтрока(
									НСтр("ru='Индекс должной осмотрительности:'")),
								Новый ФорматированнаяСтрока(
									СтрШаблон(
										НСтр("ru='%1 (%2)'"),
										РезультатИндексыКонтрагента.ИндексДолжнойОсмотрительности,
										НРег(РезультатИндексыКонтрагента.ИДОГрадация)),
									, // Шрифт
									СПАРКРискиКлиентСервер.ЦветИндекса(
										РезультатИндексыКонтрагента.ИндексДолжнойОсмотрительности,
										"ИндексДолжнойОсмотрительности"),
									, // ЦветФона
									"SPARK:WhatIsIndexOfDueDiligence")));
							ИнформацияВыведена = Истина;
						КонецЕсли;

						Если (РезультатИндексыКонтрагента.ИндексФинансовогоРиска >= 0)
								И (РезультатИндексыКонтрагента.ИндексФинансовогоРиска <= 100) Тогда
							МассивСтрок.Добавить(Новый Структура("Заголовок, Значение",
								Новый ФорматированнаяСтрока(
									НСтр("ru='Индекс финансового риска:'")),
								Новый ФорматированнаяСтрока(
									СтрШаблон(
										НСтр("ru='%1 (%2)'"),
										РезультатИндексыКонтрагента.ИндексФинансовогоРиска,
										НРег(РезультатИндексыКонтрагента.ИФРГрадация)),
									, // Шрифт
									СПАРКРискиКлиентСервер.ЦветИндекса(
										РезультатИндексыКонтрагента.ИндексФинансовогоРиска,
										"ИндексФинансовогоРиска"),
									, // ЦветФона
									"SPARK:WhatIsFailureScore")));
							ИнформацияВыведена = Истина;
						КонецЕсли;

						Если (РезультатИндексыКонтрагента.ИндексПлатежнойДисциплины >= 0)
								И (РезультатИндексыКонтрагента.ИндексПлатежнойДисциплины <= 100) Тогда
							МассивСтрок.Добавить(Новый Структура("Заголовок, Значение",
								Новый ФорматированнаяСтрока(
									НСтр("ru='Индекс платежной дисциплины:'")),
								Новый ФорматированнаяСтрока(
									СтрШаблон(
										НСтр("ru='%1 (%2)'"),
										РезультатИндексыКонтрагента.ИндексПлатежнойДисциплины,
										НРег(РезультатИндексыКонтрагента.ИПДГрадация)),
									, // Шрифт
									СПАРКРискиКлиентСервер.ЦветИндекса(
										РезультатИндексыКонтрагента.ИндексПлатежнойДисциплины,
										"ИндексПлатежнойДисциплины"),
									, // ЦветФона
									"SPARK:WhatIsPaymentIndex")));
							ИнформацияВыведена = Истина;
						КонецЕсли;

						// Вывести первые строки индексов.
						Для Каждого ТекущиеДанные Из МассивСтрок Цикл
							Если Строка2Заполнена = Ложь Тогда
								// Заполнить данными
								Элементы.ДекорацияИндексыСПАРКРискиСтрока2Заголовок.Заголовок = ТекущиеДанные.Заголовок;
								Элементы.ДекорацияИндексыСПАРКРискиСтрока2Значение.Заголовок  = ТекущиеДанные.Значение;
								Элементы.ДекорацияИндексыСПАРКРискиСтрока2Заголовок.Видимость = Истина;
								Элементы.ДекорацияИндексыСПАРКРискиСтрока2Значение.Видимость  = Истина;
								Строка2Заполнена = Истина;
							ИначеЕсли Строка3Заполнена = Ложь Тогда
								// Заполнить данными
								Элементы.ДекорацияИндексыСПАРКРискиСтрока3Заголовок.Заголовок = ТекущиеДанные.Заголовок;
								Элементы.ДекорацияИндексыСПАРКРискиСтрока3Значение.Заголовок  = ТекущиеДанные.Значение;
								Элементы.ДекорацияИндексыСПАРКРискиСтрока3Заголовок.Видимость = Истина;
								Элементы.ДекорацияИндексыСПАРКРискиСтрока3Значение.Видимость  = Истина;
								Строка3Заполнена = Истина;
							ИначеЕсли Строка4Заполнена = Ложь Тогда
								// Заполнить данными
								Элементы.ДекорацияИндексыСПАРКРискиСтрока4Заголовок.Заголовок = ТекущиеДанные.Заголовок;
								Элементы.ДекорацияИндексыСПАРКРискиСтрока4Значение.Заголовок  = ТекущиеДанные.Значение;
								Элементы.ДекорацияИндексыСПАРКРискиСтрока4Заголовок.Видимость = Истина;
								Элементы.ДекорацияИндексыСПАРКРискиСтрока4Значение.Видимость  = Истина;
								Строка4Заполнена = Истина;
							ИначеЕсли Строка5Заполнена = Ложь Тогда
								// Заполнить данными
								Элементы.ДекорацияИндексыСПАРКРискиСтрока5Заголовок.Заголовок = ТекущиеДанные.Заголовок;
								Элементы.ДекорацияИндексыСПАРКРискиСтрока5Значение.Заголовок  = ТекущиеДанные.Значение;
								Элементы.ДекорацияИндексыСПАРКРискиСтрока5Заголовок.Видимость = Истина;
								Элементы.ДекорацияИндексыСПАРКРискиСтрока5Значение.Видимость  = Истина;
								Строка5Заполнена = Истина;
							КонецЕсли;
						КонецЦикла;

						Если Строка2Заполнена = Ложь Тогда
							Элементы.ДекорацияИндексыСПАРКРискиСтрока2Заголовок.Видимость = Ложь;
							Элементы.ДекорацияИндексыСПАРКРискиСтрока2Значение.Видимость  = Ложь;
						КонецЕсли;
						Если Строка3Заполнена = Ложь Тогда
							Элементы.ДекорацияИндексыСПАРКРискиСтрока3Заголовок.Видимость = Ложь;
							Элементы.ДекорацияИндексыСПАРКРискиСтрока3Значение.Видимость  = Ложь;
						КонецЕсли;
						Если Строка4Заполнена = Ложь Тогда
							Элементы.ДекорацияИндексыСПАРКРискиСтрока4Заголовок.Видимость = Ложь;
							Элементы.ДекорацияИндексыСПАРКРискиСтрока4Значение.Видимость  = Ложь;
						КонецЕсли;
						Если Строка5Заполнена = Ложь Тогда
							Элементы.ДекорацияИндексыСПАРКРискиСтрока5Заголовок.Видимость = Ложь;
							Элементы.ДекорацияИндексыСПАРКРискиСтрока5Значение.Видимость  = Ложь;
						КонецЕсли;
						
						Если ИнформацияВыведена <> Истина Тогда // Ничего не выведено - вывести "Нет информации о контрагенте".
							Элементы.ДекорацияИндексыСПАРКРискиСтрока2Заголовок.Заголовок = НСтр("ru='Нет информации о контрагенте'");
							Элементы.ДекорацияИндексыСПАРКРискиСтрока2Заголовок.Видимость = Истина;
							Элементы.ДекорацияИндексыСПАРКРискиСтрока2Значение.Видимость  = Ложь;
							Элементы.ДекорацияИндексыСПАРКРискиСтрока3Заголовок.Видимость = Ложь;
							Элементы.ДекорацияИндексыСПАРКРискиСтрока3Значение.Видимость  = Ложь;
							Элементы.ДекорацияИндексыСПАРКРискиСтрока4Заголовок.Видимость = Ложь;
							Элементы.ДекорацияИндексыСПАРКРискиСтрока4Значение.Видимость  = Ложь;
							Элементы.ДекорацияИндексыСПАРКРискиСтрока5Заголовок.Видимость = Ложь;
							Элементы.ДекорацияИндексыСПАРКРискиСтрока5Значение.Видимость  = Ложь;
							Элементы.КартинкаОжиданиеЗагрузкиИндексовСПАРКРиски.Видимость = Ложь;
						КонецЕсли;

					КонецЕсли;

				КонецЕсли;
			КонецЕсли;

			Если ЕстьОшибкаПодключения = Истина Тогда

				Элементы.КартинкаОжиданиеЗагрузкиИндексовСПАРКРиски.Видимость = Ложь;
				Элементы.ДекорацияИндексыСПАРКРискиСтрока1Заголовок.Заголовок = НСтр("ru='1СПАРК Риски'");
				Элементы.ДекорацияИндексыСПАРКРискиСтрока1Заголовок.Шрифт = Новый Шрифт(Элементы.ДекорацияИндексыСПАРКРискиСтрока1Заголовок.Шрифт, , , Истина);
				Элементы.ДекорацияИндексыСПАРКРискиСтрока1Значение.Видимость = Ложь;

				Элементы.ДекорацияИндексыСПАРКРискиСтрока2Заголовок.Заголовок = НСтр("ru='Оценка надежности контрагентов.'");
				Элементы.ДекорацияИндексыСПАРКРискиСтрока2Значение.Видимость = Ложь;

				Элементы.ДекорацияИндексыСПАРКРискиСтрока3Заголовок.Заголовок = Новый ФорматированнаяСтрока(
					НСтр("ru='Подробнее о сервисе'"),
					,
					,
					,
					"SPARK:About");
				Элементы.ДекорацияИндексыСПАРКРискиСтрока3Значение.Видимость = Ложь;

				Элементы.ДекорацияИндексыСПАРКРискиСтрока2Заголовок.Видимость = Истина;
				Элементы.ДекорацияИндексыСПАРКРискиСтрока2Значение.Видимость  = Ложь;
				Элементы.ДекорацияИндексыСПАРКРискиСтрока3Заголовок.Видимость = Истина;
				Элементы.ДекорацияИндексыСПАРКРискиСтрока3Значение.Видимость  = Ложь;
				Элементы.ДекорацияИндексыСПАРКРискиСтрока4Заголовок.Видимость = Ложь;
				Элементы.ДекорацияИндексыСПАРКРискиСтрока4Значение.Видимость  = Ложь;
				Элементы.ДекорацияИндексыСПАРКРискиСтрока5Заголовок.Видимость = Ложь;
				Элементы.ДекорацияИндексыСПАРКРискиСтрока5Значение.Видимость  = Ложь;
				
			КонецЕсли;

		Иначе
			Элементы.ГруппаИндексыСПАРКРиски.Видимость = Ложь;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ЭтоЮридическоеЛицо(ЮрФизЛицо)
	
	Возврат ЮрФизЛицо = ПредопределенноеЗначение("Перечисление.ЮрФизЛицо.ЮрЛицо");
	
КонецФункции

Функция ЭтоИндивидуальныйПредприниматель(ЮрФизЛицо)
	
	Возврат ЮрФизЛицо = ПредопределенноеЗначение("Перечисление.ЮрФизЛицо.ИндивидуальныйПредприниматель");
	
КонецФункции

#КонецОбласти