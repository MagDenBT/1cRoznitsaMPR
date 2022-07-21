#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ДополнительныеСвойства.Вставить("ЭтоНовый",    ЭтоНовый());
	ДополнительныеСвойства.Вставить("РежимЗаписи", РежимЗаписи);
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	Если Товары.Количество() = 0  Тогда
		Отказ = Истина;
		Возврат;	
	КонецЕсли; 
	ПроведениеСервер.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства, РежимПроведения);
	
	Документы.ОтчетКомитентуОПродажах.ИнициализироватьДанныеДокумента(Ссылка, ДополнительныеСвойства);
	
	ПроведениеСервер.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	ДенежныеСредстваСервер.ОтразитьРасчетыСПоставщиками(ДополнительныеСвойства, Движения, Отказ);
	ДенежныеСредстваСервер.ОтразитьРасчетыСКлиентами(ДополнительныеСвойства, Движения, Отказ);
	ЗапасыСервер.ОтразитьТоварыКОформлениюОтчетовКомитенту(ДополнительныеСвойства, Движения, Отказ);
	СформироватьСписокРегистровДляКонтроля(); 
	
	ПроведениеСервер.ЗаписатьНаборыЗаписей(ЭтотОбъект);
	
	ПроведениеСервер.ВыполнитьКонтрольРезультатовПроведения(ЭтотОбъект, Отказ);
	
	ПроведениеСервер.ОчиститьДополнительныеСвойстваДляПроведения(ДополнительныеСвойства);
	
	ДополнительныеСвойства.Вставить("Отказ", Отказ);
	
	
КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка)
	
	ИнициализироватьДокумент(ДанныеЗаполнения);
	ОбщегоНазначенияРТ.ПроверитьИспользованиеОрганизации(,,Организация);
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Если ЗакупкиСервер.НайтиПересекающиесяПериодыОтчетов(ЭтотОбъект, "ОтчетКомитентуОПродажах") Тогда
		Отказ = Истина;
	КонецЕсли;
	
	МассивНепроверяемыхРеквизитов = Новый Массив;
	
	ОбработкаТабличнойЧастиТоварыСервер.ПроверитьЗаполнениеХарактеристик(ЭтотОбъект,
	МассивНепроверяемыхРеквизитов,
	Отказ);
	
	МассивНепроверяемыхРеквизитов.Добавить("ЭтапыОплат.ВидПлатежа");
	МассивНепроверяемыхРеквизитов.Добавить("ЭтапыОплат.ДатаПлатежа");
	МассивНепроверяемыхРеквизитов.Добавить("ЭтапыОплат.ДокументВзаимозачета");
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты,МассивНепроверяемыхРеквизитов);
	
	ЗакупкиСервер.СортироватьТабличнуюЧастьЭтапыОплат(ЭтотОбъект, Отказ);
	ЗакупкиСервер.ПроверитьТабличнуюЧастьЭтапыОплат(ЭтотОбъект, Отказ);
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	Товары.Очистить();
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Инициализирует документ
//
Процедура ИнициализироватьДокумент(ДанныеЗаполнения = Неопределено)
	
	Ответственный = Пользователи.ТекущийПользователь();
	Магазин = ЗначениеНастроекПовтИсп.МагазинПоУмолчанию(Магазин);
	Организация = ЗначениеНастроекПовтИсп.ОрганизацияПоУмолчанию(Организация,Ответственный);
	Склад = ЗначениеНастроекПовтИсп.СкладПоступленияПоУмолчанию(Магазин,,Склад, Ответственный);
	Контрагент = ЗначениеНастроекПовтИсп.ПоставщикПоУмолчанию(Ответственный, Контрагент);
	БанковскийСчетОрганизации = ЗначениеНастроекПовтИсп.БанковскийСчетОрганизацииПоУмолчанию(Организация,,БанковскийСчетОрганизации);
	ТекущаяДата = ТекущаяДатаСеанса();
	КонецПериода = НачалоМесяца(ТекущаяДата) - 1;
	НачалоПериода  = НачалоМесяца(КонецПериода);
	
КонецПроцедуры

// Процедура формирует массив имен регистров для контроля проведения.
//
Процедура СформироватьСписокРегистровДляКонтроля()
	
	Массив = Новый Массив;
	
	// При проведении выполняется контроль превышения остатков на складах.
	Если ДополнительныеСвойства.РежимЗаписи = РежимЗаписиДокумента.Проведение Тогда
		Массив.Добавить(Движения.ТоварыКОформлениюОтчетовКомитенту);
	КонецЕсли;
	
	ДополнительныеСвойства.ДляПроведения.Вставить("РегистрыДляКонтроля", Массив);
	ДополнительныеСвойства.ДляПроведения.Вставить("ПопыткиПродажПревышающихОстаток");
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
