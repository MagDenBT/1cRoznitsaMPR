#Область СлужебныйПрограммныйИнтерфейс

Процедура ОбработкаПрерыванияОперацииПлатежнойСистемы(Форма, Отказ = Ложь) Экспорт
	
	Если Форма.ПлатежнаяСистема_СанкционированноеЗакрытие Тогда	
		Возврат;
	КонецЕсли;
	
	ДополнительныеПараметры		 = Новый Структура("Форма", Форма);
	ПродолжитьПрерываниеОперации = Новый ОписаниеОповещения("ОбработатьПрерываниеПроцессаЗавершение", 
											ЭтотОбъект, 
											ДополнительныеПараметры);
											
	ПояснениеКОшибке 			 = НСтр("ru = 'Хотите закрыть окно с потерей данных?'"); 
	
	Если ИнтеграцияСПлатежнымиСистемамиРМККлиентСервер.ТекущаяСтраница(Форма.Элементы.ГруппаЗавершение) Тогда
		
		Отказ = Истина;
		
		Если Форма.ПлатежнаяСистема_НоваяЗаявка.ВидОперацииПродажа Тогда
			
			Если ЗначениеЗаполнено(Форма.ПлатежнаяСистема_НоваяЗаявка.СсылочныйНомер) Тогда
			
				ТекстОшибки = НСтр("ru = 'Оплата проведена по платежной системе.'");
			
				Если Форма.ПлатежнаяСистема_НоваяЗаявка.НастройкиИнтеграции.ОтменаОплаты Тогда
				
					ПояснениеКОшибке				= НСтр("ru = 'Необходимо выполнить сторно оплаты.'"); 
					ПродолжитьПрерываниеОперации    = Неопределено;
				
				КонецЕсли;
				
			Иначе
				ТекстОшибки = НСтр("ru = 'При закрытии QR-код станет неактуальным для подтверждения оплаты.'");
			КонецЕсли;
			
		Иначе
			ТекстОшибки = НСтр("ru = 'Возврат проведен по платежной системе.'");
		КонецЕсли;
		
	ИначеЕсли Не Форма.ПлатежнаяСистема_НоваяЗаявка.Оплачивается 
			И (ИнтеграцияСПлатежнымиСистемамиРМККлиентСервер.ТекущаяСтраница(Форма.Элементы.ГруппаВыполняется)
				ИЛИ ИнтеграцияСПлатежнымиСистемамиРМККлиентСервер.ТекущаяСтраница(Форма.Элементы.ГруппаQRКод)) Тогда	
		
		Если Форма.ПлатежнаяСистема_НоваяЗаявка.ВидОперацииПродажа Тогда
			
			ТекстОшибки = НСтр("ru = 'При закрытии QR-код станет неактуальным для проведения оплаты.'");
			Отказ 		= Истина;
		
		КонецЕсли;
		
	ИначеЕсли ИнтеграцияСПлатежнымиСистемамиРМККлиентСервер.ТекущаяСтраница(Форма.Элементы.ГруппаДлительнаяОперация) Тогда	
		
		ТекстОшибки = НСтр("ru = 'Будет прервано выполнение операции.'");
		Отказ 		= Истина;
		
	КонецЕсли;
	
	Если Отказ 
		И ЗначениеЗаполнено(ТекстОшибки) Тогда
			
		ВыводитьПредупреждение = Форма.Элементы.Найти("ГруппаВопросПредупреждение") = Неопределено;
		
		Если ВыводитьПредупреждение Тогда
			
			ТекстОшибки = ТекстОшибки + ?(ЗначениеЗаполнено(ПояснениеКОшибке), Символы.ПС + ПояснениеКОшибке, "");
			
			ПоказатьВопрос(ПродолжитьПрерываниеОперации, 
							ТекстОшибки, 
							РежимДиалогаВопрос.ДаНет,
							,
							, 
							НСтр("ru = 'Обработка прерывания операции'"));
				
		Иначе
				
			ВывестиИнформацию(Форма, ТекстОшибки, ПояснениеКОшибке, "ВопросПредупреждение");
				
		КонецЕсли;
			
	КонецЕсли;
		
КонецПроцедуры

Процедура ЗапуститьФоновыеЗадания(Форма) Экспорт
	
	Форма.Элементы.ФормаЗавершитьОплату.Видимость = Истина;
	
	Если Форма.ПлатежнаяСистема_НоваяЗаявка.ВидОперацииПродажа Тогда
	
		Если ЗначениеЗаполнено(Форма.ПлатежнаяСистема_НоваяЗаявка.ВидОплатыПлатежнойСистемы) Тогда
			
			ИнтеграцияСПлатежнымиСистемамиРМККлиентСервер.УстановитьТекущуюСтраницу(Форма.Элементы.ГруппаДлительнаяОперация);
			
			Форма.Элементы.ФормаЗавершитьОплату.Видимость = Ложь;
			
			Если Форма.ПлатежнаяСистема_НоваяЗаявка.Оплачивается Тогда
				Форма.ПодключитьОбработчикОжидания("ОпределитьСтатусОплаты", 0.1, Истина);
			Иначе
				Форма.ПодключитьОбработчикОжидания("ПолучитьИдентификаторОплаты", 0.1, Истина);
			КонецЕсли;
			
		КонецЕсли;
		
	Иначе
		
		Если ЗначениеЗаполнено(Форма.ПлатежнаяСистема_НоваяЗаявка.ВидОплатыПлатежнойСистемы) Тогда
		
			Если Форма.ПлатежнаяСистема_НоваяЗаявка.Оплачивается Тогда
		
				ИнтеграцияСПлатежнымиСистемамиРМККлиентСервер.УстановитьТекущуюСтраницу(Форма.Элементы.ГруппаДлительнаяОперация);
		
				Форма.Элементы.ФормаЗавершитьОплату.Видимость = Ложь;
			
				Форма.ПодключитьОбработчикОжидания("ОпределитьСтатусВозврата", 0.1, Истина);
				
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЕсли;
	
	ИнтеграцияСПлатежнымиСистемамиРМККлиентСервер.НастроитьФормуПоИнтеграции(Форма);
			
КонецПроцедуры

Функция ПрерватьОперацию(Форма) Экспорт
	
	Отказ = Ложь;
	
	ОтменитьОперацию(Форма, , Отказ);
		
	Форма.ПлатежнаяСистема_СанкционированноеЗакрытие = Истина;
	
	Возврат Не Отказ;
	
КонецФункции

Процедура ВывестиИнформацию(Форма, 
								ЗаголовокИнформации, 
								ТекстИнформации, 
								СтраницаФормы = Неопределено, 
								ОбработчикОповещения = Неопределено, 
								ОтветПоУмолчанию = "Нет") Экспорт
	
	Форма.Элементы["ДекорацияЗаголовок" + СтраницаФормы].Заголовок = ЗаголовокИнформации;
	Форма.Элементы["ДекорацияТекст" + СтраницаФормы].Заголовок     = ТекстИнформации;
		
	ИнтеграцияСПлатежнымиСистемамиРМККлиентСервер.УстановитьТекущуюСтраницу(Форма.Элементы["Группа" + СтраницаФормы]);
	
КонецПроцедуры

Процедура ПриОткрытии(Форма, Отказ) Экспорт
	
	ЗапуститьФоновыеЗадания(Форма);
	
КонецПроцедуры

Процедура ОбработатьПрерываниеПроцессаЗавершение(РезультатОткрытияФормы, ДополнительныеПараметры) Экспорт
	
	Если НЕ РезультатОткрытияФормы = Неопределено 
		И ВРЕГ(РезультатОткрытияФормы) = "ДА"  Тогда
		
		Форма = ДополнительныеПараметры.Форма;
	
		Если ПрерватьОперацию(Форма) Тогда
			Форма.Закрыть();
		КонецЕсли;
		
	КонецЕсли;

КонецПроцедуры

Процедура ПечатьПречека(Форма, ПовторнаяПечатьЧека = Ложь, ИдентификаторУстройстваФР = Неопределено) Экспорт
	
	Форма.Доступность 				 = Ложь;
	СтруктураСФормой				 = Новый Структура("Форма", Форма);
	ОписаниеОповещениеПриЗавершении  = Новый ОписаниеОповещения("ПечатьПречекаЗавершение", ЭтотОбъект, СтруктураСФормой);
	
	Если НЕ ПовторнаяПечатьЧека
		И ОборудованиеДисплеиПокупателяКлиент.ПодключенныеДисплеиПокупателяВыводятQRКод() Тогда
		
		ПараметрыОперации = ОборудованиеДисплеиПокупателяКлиент.ПараметрыОперацииДисплейПокупателя();
		ПараметрыОперации.ЗначениеQRКода = Форма.ПлатежнаяСистема_НоваяЗаявка.ИдентификаторQRКода;
		ПараметрыОперации.КартинкаQRКода = Форма.ПлатежнаяСистема_НоваяЗаявка.КартинкаQRКода;
		
		ОборудованиеДисплеиПокупателяКлиент.НачатьВыводQRКодаНаДисплейПокупателя(ОписаниеОповещениеПриЗавершении, 
																					Новый УникальныйИдентификатор, 
																					Неопределено, 
																					ПараметрыОперации);
		
	Иначе
		
		ПараметрыОперации = ОборудованиеЧекопечатающиеУстройстваКлиентСервер.ПараметрыПечатиQRКодаНаФискальномУстройстве();
		
		ПараметрыОперации.СуммаОперации		  = Форма.ПлатежнаяСистема_НоваяЗаявка.ИтогПоОрганизации;
		ПараметрыОперации.ТипПлатежнойСистемы = Форма.ПлатежнаяСистема_НоваяЗаявка.ТипПлатежнойСистемы;
		ПараметрыОперации.QRКод.ЗначениеКода  = Форма.ПлатежнаяСистема_НоваяЗаявка.ИдентификаторQRКода;
		ПараметрыОперации.QRКод.ТекстПользователя = НСтр("ru='Для совершения платежа отсканируйте QR-код'");
	
		ОборудованиеЧекопечатающиеУстройстваКлиент.НачатьПечатьQRКодаНаФискальномУстройстве(ОписаниеОповещениеПриЗавершении, 
																								Новый УникальныйИдентификатор, 
																								ИдентификаторУстройстваФР, 
																								ПараметрыОперации); 
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ПечатьПречекаЗавершение(РезультатВыполнения, Параметры) Экспорт
	
	Форма			  = Параметры.Форма;
	Форма.Доступность = Истина;
	
	Если НЕ РезультатВыполнения.Результат Тогда  
		
		ЗаголовокИнформации	= НСтр("ru = 'Печать последнего слип чека'");
		ТекстИнформации		= РезультатВыполнения.ОписаниеОшибки;
		
		ВыводитьПредупреждение = Форма.Элементы.Найти("ГруппаОшибкаПредупреждение") = Неопределено;
		
		Если ВыводитьПредупреждение Тогда
			ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстИнформации);
		Иначе
			ВывестиИнформацию(Форма, ЗаголовокИнформации, ТекстИнформации, "ОшибкаПредупреждение");
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ПолучитьИдентификаторОплаты(Форма, ОповещениеОЗавершении) Экспорт
	
	ИнтеграцияСПлатежнымиСистемамиРМККлиентСервер.УстановитьТекущуюСтраницу(Форма.Элементы.ГруппаДлительнаяОперация);
	
	ИнтеграцияСПлатежнымиСистемамиРМККлиентСервер.НастроитьФормуПоИнтеграции(Форма);
		
	ПараметрыОжидания 	= ДлительныеОперацииКлиент.ПараметрыОжидания(Форма);
	ПараметрыОжидания.ВыводитьОкноОжидания = Ложь;
	
	ЗаявкаНаОплату 	  	= НоваяЗаявка(Форма);
	РезультатВыполнения = ИнтеграцияСПлатежнымиСистемамиРМКВызовСервера.ПолучитьИдентификаторОплаты(ЗаявкаНаОплату, 
																										Форма.УникальныйИдентификатор);
	
	Форма.ПлатежнаяСистема_НоваяЗаявка.ИдентификаторЗаданияФормированияQRКода = РезультатВыполнения.ИдентификаторЗадания;
	
	СтруктураСФормой	= Новый Структура();
	СтруктураСФормой.Вставить("Форма", 					   Форма);
	СтруктураСФормой.Вставить("ИдентификаторУстройстваФР", Форма.ПлатежнаяСистема_НоваяЗаявка.ПодключаемоеОборудование);
	
	ОповещениеОЗавершении = Новый ОписаниеОповещения("ПолучитьИдентификаторОплатыЗавершение", 
									ЭтотОбъект, 
									СтруктураСФормой);
	
	Если РезультатВыполнения.Статус = "Выполнено" Тогда
		ПолучитьИдентификаторОплатыЗавершение(РезультатВыполнения, СтруктураСФормой);
		Возврат;
	КонецЕсли;
	
	ДлительныеОперацииКлиент.ОжидатьЗавершение(
		РезультатВыполнения,
		ОповещениеОЗавершении,
		ПараметрыОжидания);
	
КонецПроцедуры

Процедура ПолучитьИдентификаторОплатыЗавершение(РезультатВыполнения, ДополнительныеПараметры) Экспорт
	
	Если РезультатВыполнения = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Форма		    			= ДополнительныеПараметры.Форма;
	ИдентификаторУстройстваФР   = ДополнительныеПараметры.ИдентификаторУстройстваФР;
	
	Если Форма.ПлатежнаяСистема_СанкционированноеЗакрытие Тогда // уже на актуально
		Возврат;
	КонецЕсли;
	
	Если РезультатВыполнения.Статус = "Выполнено" Тогда
		
		РезультатОперации = ПолучитьИзВременногоХранилища(РезультатВыполнения.АдресРезультата);
		
		Если Не ЗначениеЗаполнено(Форма.ПлатежнаяСистема_НоваяЗаявка.ДокументОплаты) Тогда
			Форма.ПлатежнаяСистема_НоваяЗаявка.ДокументОплаты = РезультатОперации.ДокументОплаты;
		КонецЕсли;
		
		Если ЗначениеЗаполнено(РезультатОперации.КодОшибки) Тогда
			
			ИнтеграцияСПлатежнымиСистемамиРМККлиентСервер.УстановитьТекущуюСтраницу(Форма.Элементы.ГруппаОшибка);
			
			ИнтеграцияСПлатежнымиСистемамиРМККлиентСервер.НастроитьФормуПоИнтеграции(Форма, РезультатОперации.СообщениеОбОшибке);
				
		Иначе
				
			ИнтеграцияСПлатежнымиСистемамиРМККлиентСервер.УстановитьТекущуюСтраницу(Форма.Элементы.ГруппаQRКод);
			
			Интеграция		= Форма.ПлатежнаяСистема_НоваяЗаявка.Интеграция;
			СтруктураQRКода = ИнтеграцияСПлатежнымиСистемамиРМКВызовСервера.СформироватьДанныеQRКода(Интеграция, 
																										РезультатОперации.QRКод, 
																										Форма.УникальныйИдентификатор);
			
			ЗаполнитьЗначенияСвойств(Форма.ПлатежнаяСистема_НоваяЗаявка, СтруктураQRКода);
			
			Форма.ПлатежнаяСистема_ДанныеQRКода = Форма.ПлатежнаяСистема_НоваяЗаявка.ДанныеQRКода;
			
			ПечатьПречека(Форма, , ИдентификаторУстройстваФР);
			
			ИнтеграцияСПлатежнымиСистемамиРМККлиентСервер.НастроитьФормуПоИнтеграции(Форма);
				
			Форма.ПодключитьОбработчикОжидания("ОпределитьСтатусОплаты", 0.1, Истина);
			
		КонецЕсли;
		
	ИначеЕсли РезультатВыполнения.Статус = "Ошибка" Тогда
		
		ИнтеграцияСПлатежнымиСистемамиРМККлиентСервер.УстановитьТекущуюСтраницу(Форма.Элементы.ГруппаОшибка);
			
		ИнтеграцияСПлатежнымиСистемамиРМККлиентСервер.НастроитьФормуПоИнтеграции(Форма);
			
	КонецЕсли;
	
КонецПроцедуры

Процедура ОпределитьСтатусОплаты(Форма, ОповещениеЗавершитьОплату) Экспорт
	
	Если Форма.ПлатежнаяСистема_НоваяЗаявка.Оплачивается Тогда
		ИнтеграцияСПлатежнымиСистемамиРМККлиентСервер.УстановитьТекущуюСтраницу(Форма.Элементы.ГруппаДлительнаяОперация);
	ИначеЕсли Не Форма.ПлатежнаяСистема_НоваяЗаявка.ВидОперацииПродажа Тогда
		ИнтеграцияСПлатежнымиСистемамиРМККлиентСервер.УстановитьТекущуюСтраницу(Форма.Элементы.ГруппаДлительнаяОперация);
		ТекстДлительнойОперации			= НСтр("ru = 'Получение подтверждения оплаты. Пожалуйста, подождите...'");
	Иначе
		ИнтеграцияСПлатежнымиСистемамиРМККлиентСервер.УстановитьТекущуюСтраницу(Форма.Элементы.ГруппаQRКод);
	КонецЕсли;
	
	ИнтеграцияСПлатежнымиСистемамиРМККлиентСервер.НастроитьФормуПоИнтеграции(Форма, , ТекстДлительнойОперации);
	
	ПараметрыОжидания = ДлительныеОперацииКлиент.ПараметрыОжидания(Форма);
	ПараметрыОжидания.ВыводитьОкноОжидания = Ложь;
	ПараметрыОжидания.Интервал = 1;
	
	ДокументОплаты		  = Форма.ПлатежнаяСистема_НоваяЗаявка.ДокументОплаты;
	Интеграция			  = Форма.ПлатежнаяСистема_НоваяЗаявка.Интеграция;
	РезультатВыполнения   = ИнтеграцияСПлатежнымиСистемамиРМКВызовСервера.ОпределитьСтатусОплатыОплаты(ДокументОплаты, 
																											Интеграция, 
																											Форма.УникальныйИдентификатор);
	
	Форма.ПлатежнаяСистема_НоваяЗаявка.ИдентификаторЗаданияПроверкиСтатуса = РезультатВыполнения.ИдентификаторЗадания;
	
	ПараметрыЗавершения	  = Новый Структура("Форма, ОповещениеЗавершитьОплату", Форма, ОповещениеЗавершитьОплату);	
	ОповещениеОЗавершении = Новый ОписаниеОповещения("ОпределитьСтатусОплатыЗавершение", ЭтотОбъект, ПараметрыЗавершения);
	
	Если РезультатВыполнения.Статус = "Выполнено" Тогда
		ОпределитьСтатусОплатыЗавершение(РезультатВыполнения, ПараметрыЗавершения);
		Возврат;
	КонецЕсли;
	
	ДлительныеОперацииКлиент.ОжидатьЗавершение(
		РезультатВыполнения,
		ОповещениеОЗавершении,
		ПараметрыОжидания);
	
КонецПроцедуры

Процедура ОпределитьСтатусОплатыЗавершение(РезультатВыполнения, ДополнительныеПараметры) Экспорт
	
	Если РезультатВыполнения = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Форма		      			= ДополнительныеПараметры.Форма;
	ОповещениеЗавершитьОплату   = ДополнительныеПараметры.ОповещениеЗавершитьОплату;
	СообщениеОбОшибке 			= "";
	
	Если Форма.ПлатежнаяСистема_СанкционированноеЗакрытие Тогда // уже на актуально
		Возврат;
	КонецЕсли;
	
	Если РезультатВыполнения.Статус = "Выполнено" Тогда
		
		РезультатОперации 			= ПолучитьИзВременногоХранилища(РезультатВыполнения.АдресРезультата);
		
		СтатусОперацииВыполняется 	= ИнтеграцияСПлатежнымиСистемамиКлиентСервер.СтатусОперацииВыполняется();
		СтатусОперацииВыполнена		= ИнтеграцияСПлатежнымиСистемамиКлиентСервер.СтатусОперацииВыполнена();
		СтатусОперацииОтменена		= ИнтеграцияСПлатежнымиСистемамиКлиентСервер.СтатусОперацииОтменена();
		СтатусОперацииОшибка		= ИнтеграцияСПлатежнымиСистемамиКлиентСервер.СтатусОперацииОшибка();
		
		Если РезультатОперации.СтатусОперации = СтатусОперацииВыполняется Тогда
			
			Если Не Форма.ПлатежнаяСистема_НоваяЗаявка.ВидОперацииПродажа Тогда
				ТекущаяСтраница		= Форма.Элементы.ГруппаОшибка;
				СообщениеОбОшибке 	= НСтр("ru = 'Не определен идентификатор оплаты в платежной системе'");
			Иначе
				ТекущаяСтраница 	= Форма.Элементы.ГруппаВыполняется;
			КонецЕсли;
			
			ИнтеграцияСПлатежнымиСистемамиРМККлиентСервер.УстановитьТекущуюСтраницу(ТекущаяСтраница);
			ИнтеграцияСПлатежнымиСистемамиРМККлиентСервер.НастроитьФормуПоИнтеграции(Форма, СообщениеОбОшибке);
			
		ИначеЕсли РезультатОперации.СтатусОперации = СтатусОперацииВыполнена Тогда
			
			Если Не Форма.ПлатежнаяСистема_НоваяЗаявка.ВидОперацииПродажа Тогда
				ВозвратОплаты(Форма, ОповещениеЗавершитьОплату);
			Иначе
			
				ИнтеграцияСПлатежнымиСистемамиРМККлиентСервер.УстановитьТекущуюСтраницу(Форма.Элементы.ГруппаЗавершение);
				ИнтеграцияСПлатежнымиСистемамиРМККлиентСервер.НастроитьФормуПоИнтеграции(Форма);
			
				ВыполнитьОбработкуОповещения(ОповещениеЗавершитьОплату, "ДобавитьВидОплаты");
				
			КонецЕсли;
			
		ИначеЕсли РезультатОперации.СтатусОперации = СтатусОперацииОтменена Тогда
			
			СообщениеОбОшибке = НСтр("ru = 'Операция отменена. Истек срок действия QR-кода или операция была отклонена СБП.'");
			ТекущаяСтраница	  = Форма.Элементы.ГруппаОшибка;
			
			ИнтеграцияСПлатежнымиСистемамиРМККлиентСервер.УстановитьТекущуюСтраницу(ТекущаяСтраница);
			ИнтеграцияСПлатежнымиСистемамиРМККлиентСервер.НастроитьФормуПоИнтеграции(Форма, СообщениеОбОшибке);
			
		ИначеЕсли РезультатОперации.СтатусОперации = СтатусОперацииОшибка Тогда
			
			СообщениеОбОшибке = РезультатОперации.СообщениеОбОшибке;
			
			Если Не Форма.ПлатежнаяСистема_НоваяЗаявка.ВидОперацииПродажа Тогда
				ТекущаяСтраница = Форма.Элементы.ГруппаОшибка;
			Иначе
				ТекущаяСтраница = Форма.Элементы.ГруппаОшибкаПолученияСтатуса;
			КонецЕсли;
			
			ИнтеграцияСПлатежнымиСистемамиРМККлиентСервер.УстановитьТекущуюСтраницу(ТекущаяСтраница);
			ИнтеграцияСПлатежнымиСистемамиРМККлиентСервер.НастроитьФормуПоИнтеграции(Форма, СообщениеОбОшибке);
		
		КонецЕсли;
		
	ИначеЕсли РезультатВыполнения.Статус = "Ошибка" Тогда
		
		СообщениеОбОшибке = РезультатВыполнения.КраткоеПредставлениеОшибки;
		ТекущаяСтраница	  = Форма.Элементы.ГруппаОшибкаПолученияСтатуса;
		
		ИнтеграцияСПлатежнымиСистемамиРМККлиентСервер.УстановитьТекущуюСтраницу(ТекущаяСтраница);
		ИнтеграцияСПлатежнымиСистемамиРМККлиентСервер.НастроитьФормуПоИнтеграции(Форма, СообщениеОбОшибке);
	
	КонецЕсли;
	
КонецПроцедуры

Процедура ВозвратОплаты(Форма, ОповещениеЗавершитьОплату) Экспорт
	
	ИнтеграцияСПлатежнымиСистемамиРМККлиентСервер.УстановитьТекущуюСтраницу(Форма.Элементы.ГруппаДлительнаяОперация);
	
	ИнтеграцияСПлатежнымиСистемамиРМККлиентСервер.НастроитьФормуПоИнтеграции(Форма);
	
	ПараметрыОжидания = ДлительныеОперацииКлиент.ПараметрыОжидания(Форма);
	ПараметрыОжидания.ВыводитьОкноОжидания = Ложь;
	
	ЗаявкаНаВозврат 	= НоваяЗаявка(Форма);
	РезультатВыполнения = ИнтеграцияСПлатежнымиСистемамиРМКВызовСервера.ВозвратОплаты(ЗаявкаНаВозврат, 
																						Форма.УникальныйИдентификатор);
	
	Форма.ПлатежнаяСистема_НоваяЗаявка.ИдентификаторЗаданияВозврата = РезультатВыполнения.ИдентификаторЗадания;
	ПараметрыЗавершения	  = Новый Структура("Форма, ОповещениеЗавершитьОплату", Форма, ОповещениеЗавершитьОплату);
	ОповещениеОЗавершении = Новый ОписаниеОповещения("ВозвратОплатыЗавершение", ЭтотОбъект, ПараметрыЗавершения);
	
	Если РезультатВыполнения.Статус = "Выполнено" Тогда
		ВозвратОплатыЗавершение(РезультатВыполнения, ПараметрыЗавершения);
		Возврат;
	КонецЕсли;
	
	ДлительныеОперацииКлиент.ОжидатьЗавершение(
		РезультатВыполнения,
		ОповещениеОЗавершении,
		ПараметрыОжидания);
	
КонецПроцедуры

Процедура ВозвратОплатыЗавершение(РезультатВыполнения, ДополнительныеПараметры) Экспорт
	
	Если РезультатВыполнения = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Форма		      			= ДополнительныеПараметры.Форма;
	ОповещениеЗавершитьОплату	= ДополнительныеПараметры.ОповещениеЗавершитьОплату;
	
	Если Форма.ПлатежнаяСистема_СанкционированноеЗакрытие Тогда // уже на актуально
		Возврат;
	КонецЕсли;
	
	Если РезультатВыполнения.Статус = "Выполнено" Тогда
		
		РезультатОперации = ПолучитьИзВременногоХранилища(РезультатВыполнения.АдресРезультата);
		
		Если Не ЗначениеЗаполнено(Форма.ПлатежнаяСистема_НоваяЗаявка.ДокументВозврата) Тогда
			Форма.ПлатежнаяСистема_НоваяЗаявка.ДокументВозврата = РезультатОперации.ДокументВозврата;
		КонецЕсли;
		
		ОбработатьСтатусВозврата(Форма, РезультатОперации, ОповещениеЗавершитьОплату);
		
	ИначеЕсли РезультатВыполнения.Статус = "Ошибка" Тогда
		
		ИнтеграцияСПлатежнымиСистемамиРМККлиентСервер.УстановитьТекущуюСтраницу(Форма.Элементы.ГруппаОшибка);
		
		ИнтеграцияСПлатежнымиСистемамиРМККлиентСервер.НастроитьФормуПоИнтеграции(Форма);
			
	КонецЕсли;
	
КонецПроцедуры

Процедура ОпределитьСтатусВозврата(Форма, ОповещениеЗавершитьОплату) Экспорт
	
	ИнтеграцияСПлатежнымиСистемамиРМККлиентСервер.УстановитьТекущуюСтраницу(Форма.Элементы.ГруппаДлительнаяОперация);
	
	ИнтеграцияСПлатежнымиСистемамиРМККлиентСервер.НастроитьФормуПоИнтеграции(Форма);
	
	ПараметрыОжидания = ДлительныеОперацииКлиент.ПараметрыОжидания(Форма);
	ПараметрыОжидания.ВыводитьОкноОжидания 	= Ложь;
	ПараметрыОжидания.Интервал 				= 1;
	
	ДокументВозврата 	= Форма.ПлатежнаяСистема_НоваяЗаявка.ДокументВозврата;
	Интеграция			= Форма.ПлатежнаяСистема_НоваяЗаявка.Интеграция;
	
	РезультатВыполнения = ИнтеграцияСПлатежнымиСистемамиРМКВызовСервера.ОпределитьСтатусВозврата(ДокументВозврата, 
																									Интеграция, 
																									Форма.УникальныйИдентификатор);
	
	Форма.ПлатежнаяСистема_НоваяЗаявка.ИдентификаторЗаданияПроверкиСтатуса = РезультатВыполнения.ИдентификаторЗадания;
	СтруктураСФормой					= Новый Структура("Форма, ОповещениеЗавершитьОплату", Форма, ОповещениеЗавершитьОплату);
	
	ОповещениеОЗавершении = Новый ОписаниеОповещения("ОпределитьСтатусВозвратаЗавершение", ЭтотОбъект, СтруктураСФормой);
	
	Если РезультатВыполнения.Статус = "Выполнено" Тогда
		ОпределитьСтатусВозвратаЗавершение(РезультатВыполнения, Новый Структура("Форма, ОповещениеЗавершитьОплату", Форма, ОповещениеЗавершитьОплату));
		Возврат;
	КонецЕсли;
	
	ДлительныеОперацииКлиент.ОжидатьЗавершение(
		РезультатВыполнения,
		ОповещениеОЗавершении,
		ПараметрыОжидания);
	
КонецПроцедуры

Процедура ОпределитьСтатусВозвратаЗавершение(РезультатВыполнения, ДополнительныеПараметры) Экспорт
	
	Если РезультатВыполнения = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Форма						= ДополнительныеПараметры.Форма;
	ОповещениеЗавершитьОплату   = ДополнительныеПараметры.ОповещениеЗавершитьОплату;
	
	Если Форма.ПлатежнаяСистема_СанкционированноеЗакрытие Тогда // уже на актуально
		Возврат;
	КонецЕсли;
	
	Если РезультатВыполнения.Статус = "Выполнено" Тогда
		
		РезультатОперации = ПолучитьИзВременногоХранилища(РезультатВыполнения.АдресРезультата);
		
		ОбработатьСтатусВозврата(Форма, РезультатОперации, ОповещениеЗавершитьОплату, Ложь);
		
	ИначеЕсли РезультатВыполнения.Статус = "Ошибка" Тогда
		
		ИнтеграцияСПлатежнымиСистемамиРМККлиентСервер.УстановитьТекущуюСтраницу(Форма.Элементы.ГруппаОшибкаПолученияСтатуса);
		
		ИнтеграцияСПлатежнымиСистемамиРМККлиентСервер.НастроитьФормуПоИнтеграции(Форма, РезультатВыполнения.КраткоеПредставлениеОшибки);
			
	КонецЕсли;
	
КонецПроцедуры

Процедура ПодтвердитьВозврат(Форма, ОповещениеЗавершитьОплату) Экспорт
	
	ДокументВозврата = Форма.ПлатежнаяСистема_НоваяЗаявка.ДокументВозврата;
	Интеграция		 = Форма.ПлатежнаяСистема_НоваяЗаявка.Интеграция;
	
	РезультатОперации = ИнтеграцияСПлатежнымиСистемамиРМКВызовСервера.ПодтвердитьВозврат(ДокументВозврата, Интеграция);
		
	ОбработатьСтатусВозврата(Форма, РезультатОперации, ОповещениеЗавершитьОплату);
	
КонецПроцедуры

Процедура ОтменитьОперацию(Форма, ОповещениеЗавершитьОплату, Отказ = Ложь) Экспорт
	
	ДокументОплаты 							= Форма.ПлатежнаяСистема_НоваяЗаявка.ДокументОплаты;
	Интеграция 								= Форма.ПлатежнаяСистема_НоваяЗаявка.Интеграция;
	ИдентификаторЗаданияФормированияQRКода 	= Форма.ПлатежнаяСистема_НоваяЗаявка.ИдентификаторЗаданияФормированияQRКода;
	ИдентификаторЗаданияПроверкиСтатуса 	= Форма.ПлатежнаяСистема_НоваяЗаявка.ИдентификаторЗаданияПроверкиСтатуса;
	ИдентификаторЗаданияВозврата			= Форма.ПлатежнаяСистема_НоваяЗаявка.ИдентификаторЗаданияВозврата;
	
	Результат = ИнтеграцияСПлатежнымиСистемамиРМКВызовСервера.ОтменитьОперацию(ДокументОплаты, 
																				Интеграция, 
																				ИдентификаторЗаданияФормированияQRКода, 
																				ИдентификаторЗаданияПроверкиСтатуса, 
																				ИдентификаторЗаданияВозврата);
	
	Если Результат <> Неопределено
		И ЗначениеЗаполнено(Результат.КодОшибки) Тогда
		
		Отказ 			= Истина;
		ИнтеграцияСПлатежнымиСистемамиРМККлиентСервер.УстановитьТекущуюСтраницу(Форма.Элементы.ГруппаОшибка);
		
		ИнтеграцияСПлатежнымиСистемамиРМККлиентСервер.НастроитьФормуПоИнтеграции(Форма, Результат.СообщениеОбОшибке);
		
	КонецЕсли;
	
	Если Не Отказ Тогда
		Форма.ПлатежнаяСистема_СанкционированноеЗакрытие = Истина;
		ВыполнитьОбработкуОповещения(ОповещениеЗавершитьОплату, "ОтменитьОплату");
	КонецЕсли;
	
КонецПроцедуры

Функция ОпределитьПараметрыОплатыПоОперациямДокумента(Форма, ВидыОплат, ДокументОперации) Экспорт
	
	ПараметрыОплаты	= Новый Структура("ВидОплаты, ПлатежнаяСистема, ИдентификаторПС");
	
	ТорговыеТочки 	= ИнтеграцияСПлатежнымиСистемамиРМКВызовСервера.ТорговыеТочкиОперации(ДокументОперации);
	
	Для Каждого Интеграция Из ТорговыеТочки Цикл
		
		СтрокиОплаты = ВидыОплат.НайтиСтроки(Новый Структура("Интеграция", Интеграция));
		
		Если СтрокиОплаты.Количество() Тогда
			ПараметрыОплаты.ВидОплаты		 = СтрокиОплаты[0].ВидОплаты;
			ПараметрыОплаты.ПлатежнаяСистема = СтрокиОплаты[0].ПлатежнаяСистема;
			ПараметрыОплаты.ИдентификаторПС	 = СтрокиОплаты[0].ИдентификаторПС;
			Прервать;
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат ПараметрыОплаты;
	
КонецФункции

Функция ОпределитьПлатежнуюСистему(Форма, ВидыОплат, ВыбраннаяОрганизация = Неопределено) Экспорт
	
	Ключ = Новый Структура("ИдентификаторПС", Форма.ПлатежнаяСистема_НоваяЗаявка.ИдентификаторПС);
	
	Если ВыбраннаяОрганизация <> Неопределено Тогда
		Ключ.Вставить("Организация",  ВыбраннаяОрганизация);
	КонецЕсли;
	
	СтрокиОплаты = ВидыОплат.НайтиСтроки(Ключ);
		
	Если СтрокиОплаты.Количество() Тогда
		ПлатежнаяСистема = СтрокиОплаты[0].ПлатежнаяСистема;
	КонецЕсли;
	
	Возврат ПлатежнаяСистема;
	
КонецФункции

Функция ОпределитьВидОплаты(Форма, ВидыОплат) Экспорт
	
	Ключ = Новый Структура("ИдентификаторПС", Форма.ПлатежнаяСистема_ИдентификаторПС);
	
	СтрокиОплаты = ВидыОплат.НайтиСтроки(Ключ);
		
	Если СтрокиОплаты.Количество() Тогда
		ВидОплаты = СтрокиОплаты[0].ВидОплаты;
	КонецЕсли;
	
	Возврат ВидОплаты;
	
КонецФункции

Функция ОпределитьСпособОплаты(Форма, ВидыОплат, ВыбраннаяОрганизация = Неопределено) Экспорт
	
	Ключ = Новый Структура("ИдентификаторПС", Форма.ПлатежнаяСистема_ИдентификаторПС);
	
	Если ВыбраннаяОрганизация <> Неопределено Тогда
		Ключ.Вставить("Организация",  ВыбраннаяОрганизация);
	КонецЕсли;
	
	СтрокиОплаты = ВидыОплат.НайтиСтроки(Ключ);
		
	Если СтрокиОплаты.Количество() Тогда
		СпособОплаты = СтрокиОплаты[0].СпособОплаты;
	КонецЕсли;
	
	Возврат СпособОплаты;
	
КонецФункции

Функция ОпределитьКомиссию(Форма, ВидыОплат, Организация, ВидОперацииПродажа) Экспорт
	
	Ключ = Новый Структура();
	Ключ.Вставить("ИдентификаторПС", 	Форма.ПлатежнаяСистема_ИдентификаторПС);
	Ключ.Вставить("Организация", 		Организация);
	
	СтрокиОплаты = ВидыОплат.НайтиСтроки(Ключ);
		
	Если СтрокиОплаты.Количество() Тогда
		Комиссия = ?(ВидОперацииПродажа, СтрокиОплаты[0].ПроцентКомиссии, СтрокиОплаты[0].ПроцентКомиссииПриВозврате);
	Иначе
		Комиссия = 0;
	КонецЕсли;
	
	Возврат Комиссия;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ОбработатьСтатусВозврата(Форма, РезультатОперации, ОповещениеЗавершитьОплату, ЗапускПроверкиСтатуса = Истина)
	
	ПлатежнаяСистема    				 = Форма.ПлатежнаяСистема_БанкКлиента;
	СтатусОперацииТребуетсяПодтверждение = ИнтеграцияСПлатежнымиСистемамиКлиентСервер.СтатусОперацииТребуетсяПодтверждение();
	СтатусОперацииВыполняется			 = ИнтеграцияСПлатежнымиСистемамиКлиентСервер.СтатусОперацииВыполняется();
	СтатусОперацииВыполнена				 = ИнтеграцияСПлатежнымиСистемамиКлиентСервер.СтатусОперацииВыполнена();
	
	Если РезультатОперации.СтатусОперации = СтатусОперацииТребуетсяПодтверждение Тогда
		
		Если ЗначениеЗаполнено(РезультатОперации.Подтверждение.НомерТелефона)
			И ЗначениеЗаполнено(РезультатОперации.Подтверждение.НомерСчета) Тогда
		
			Форма.Элементы.ДекорацияПодтверждение.Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Денежные средства будут переведены %1 (номер телефона %2) в %3 на расчетный счет %4. 
							|Проверьте реквизиты и подтвердите перевод.'"),
					РезультатОперации.Подтверждение.ФИО,
					РезультатОперации.Подтверждение.НомерТелефона,
					Форма.Элементы.ПлатежнаяСистема.СписокВыбора.НайтиПоЗначению(ПлатежнаяСистема).Представление,
					РезультатОперации.Подтверждение.НомерСчета);
				
		Иначе
				
			Форма.Элементы.ДекорацияПодтверждение.Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Денежные средства будут переведены %1 в %2 на расчетный счет. 
							|Проверьте реквизиты и подтвердите перевод.'"),
				
					РезультатОперации.Подтверждение.ФИО,
					Форма.Элементы.ПлатежнаяСистема.СписокВыбора.НайтиПоЗначению(ПлатежнаяСистема).Представление);
					
		КонецЕсли;
			
		ИнтеграцияСПлатежнымиСистемамиРМККлиентСервер.УстановитьТекущуюСтраницу(Форма.Элементы.ГруппаПодтверждение);
		ИнтеграцияСПлатежнымиСистемамиРМККлиентСервер.НастроитьФормуПоИнтеграции(Форма);
			
	ИначеЕсли РезультатОперации.СтатусОперации = СтатусОперацииВыполняется Тогда
		
		Если ЗапускПроверкиСтатуса Тогда
			Форма.ПодключитьОбработчикОжидания("ОпределитьСтатусВозврата", 0.1, Истина);
		Иначе
			ИнтеграцияСПлатежнымиСистемамиРМККлиентСервер.УстановитьТекущуюСтраницу(Форма.Элементы.ГруппаВыполняется);
			ИнтеграцияСПлатежнымиСистемамиРМККлиентСервер.НастроитьФормуПоИнтеграции(Форма);
		КонецЕсли;
		
	ИначеЕсли РезультатОперации.СтатусОперации = СтатусОперацииВыполнена Тогда
		
		ИнтеграцияСПлатежнымиСистемамиРМККлиентСервер.УстановитьТекущуюСтраницу(Форма.Элементы.ГруппаЗавершение);
		ИнтеграцияСПлатежнымиСистемамиРМККлиентСервер.НастроитьФормуПоИнтеграции(Форма, РезультатОперации.СообщениеОбОшибке);

		ВыполнитьОбработкуОповещения(ОповещениеЗавершитьОплату, "ДобавитьВидОплаты");
		
	Иначе
		
		ИнтеграцияСПлатежнымиСистемамиРМККлиентСервер.УстановитьТекущуюСтраницу(Форма.Элементы.ГруппаОшибка);
		ИнтеграцияСПлатежнымиСистемамиРМККлиентСервер.НастроитьФормуПоИнтеграции(Форма, РезультатОперации.СообщениеОбОшибке);
		
	КонецЕсли;
	
КонецПроцедуры

Функция НоваяЗаявка(Форма) 
	
	ТекущаяДата = ОбщегоНазначенияКлиент.ДатаСеанса();
	
	Заявка = Новый Структура;
	Заявка.Вставить("ДокументОплаты", 	   		Форма.ПлатежнаяСистема_НоваяЗаявка.ДокументОплаты);
	Заявка.Вставить("ИтогПоЧеку", 		   		Форма.ПлатежнаяСистема_НоваяЗаявка.ИтогПоОрганизации);
	Заявка.Вставить("НомерДокумента", 	   		Форма.ПлатежнаяСистема_НоваяЗаявка.НомерДокумента);
	Заявка.Вставить("Дата",				   		ТекущаяДата);
	Заявка.Вставить("Интеграция", 				Форма.ПлатежнаяСистема_НоваяЗаявка.Интеграция);
	Заявка.Вставить("Организация",    	   		Форма.ПлатежнаяСистема_НоваяЗаявка.Организация);
	
	Если Не Форма.ПлатежнаяСистема_НоваяЗаявка.ВидОперацииПродажа Тогда
		
		Заявка.Вставить("ДокументОплаты",		Форма.ПлатежнаяСистема_НоваяЗаявка.ДокументОплаты); 
		Заявка.Вставить("ДокументВозврата", 	Форма.ПлатежнаяСистема_НоваяЗаявка.ДокументВозврата);
		Заявка.Вставить("ИдентификаторОплаты", 	Форма.ПлатежнаяСистема_НоваяЗаявка.ИдентификаторОплаты);
		Заявка.Вставить("ПлатежнаяСистема",    	?(ЗначениеЗаполнено(Форма.ПлатежнаяСистема_БанкКлиента),
													Форма.ПлатежнаяСистема_БанкКлиента,
													Неопределено));
		
	Иначе
		Заявка.Вставить("Товары", Форма.ПлатежнаяСистема_НоваяЗаявка.Товары);
	КонецЕсли;
	
	Возврат Заявка;
	
КонецФункции

#КонецОбласти

