
///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2022, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Процедура получает и заполняет рабочее место в параметр сеанса и на форме.
//
// Параметры
//  Форма - ФормаКлиентскогоПриложения.
//
Процедура ЗаполнитьРабочееМесто(Форма) Экспорт
	
	ОбщегоНазначенияРМКРТКлиент.ЗаполнитьРабочееМесто(Форма);
	
КонецПроцедуры

// Процедура заполняет таблицу оплат на форме рабочего места кассира.
//
// Параметры
//  Форма - ФормаКлиентскогоПриложения.
//
Процедура ЗаполнитьТаблицуОплат(Форма) Экспорт
	
	ОбщегоНазначенияРМКРТКлиент.ЗаполнитьТаблицуОплат(Форма);
	
КонецПроцедуры

// Процедура сохраняет выбранный вид платежной карты в случае, если видов ПК несколько.
//
// Параметры
//  Форма - ФормаКлиентскогоПриложения - форма рабочего места кассира.
//  ИмяКоманды - Строка - наименование переданной команды вида оплаты.
//
Процедура ЗаполнитьВыбранныйВидОплаты(Форма, ИмяКоманды) Экспорт
	
	ОбщегоНазначенияРМКРТКлиент.ЗаполнитьВыбранныйВидОплаты(Форма, ИмяКоманды);
	
КонецПроцедуры

// Возвращает вид операции чека ККМ.
//
// Параметры:
//  ЭтоВозврат - Булево - признак того, что нужно вернуть вид операции возврат.
//  ЭтоСкупка - Булево - признак того, что нужно вернуть вид операции скупка.
//
// ВозвращаемоеЗначение:
//  ПеречислениеСсылка - вид операции чека ККМ (Продажа, Возврат, Скупка, ВозвратСкупки).
//
Функция ВидОперацииЧекаККМ(ЭтоВозврат = Ложь, ЭтоСкупка = Ложь) Экспорт
	
	Возврат ОбщегоНазначенияРМКРТКлиент.ВидОперацииЧекаККМ(ЭтоВозврат, ЭтоСкупка);
	
КонецФункции

// Возвращает признак того, является ли операция продажей.
//
// Параметры:
//  ВидОперации - ПеречислениеСсылка - текущий вид операции.
//
// ВозвращаемоеЗначение:
//  Булево - Истина, если текущий вид операции продажа.
//
Функция ВидОперацииПродажа(ВидОперации) Экспорт
	
	Возврат ОбщегоНазначенияРМКРТКлиент.ВидОперацииПродажа(ВидОперации);
	
КонецФункции

// Возвращает пустую ссылку на документ чекККМ.
//
// ВозвращаемоеЗначение:
//  ДокументСсылка - пустая ссылка на документ чекККМ.
//
Функция ПустаяСсылкаНаЧекККМ() Экспорт
	
	Возврат ОбщегоНазначенияРМКРТКлиент.ПустаяСсылкаНаЧекККМ();
	
КонецФункции

// Возвращает пустую ссылку на справочник серии номенклатуры.
//
// ВозвращаемоеЗначение:
//  СправочникСсылка - пустая ссылка на справочник серии номенклатуры.
//
Функция ПустаяСсылкаНаСерию() Экспорт
	
	Возврат ОбщегоНазначенияРМКРТКлиент.ПустаяСсылкаНаСерию();
	
КонецФункции

// Процедура производит закрытие смены.
//
// Параметры
//  Форма - ФормаКлиентскогоПриложения - форма РМК.
//  ЗакрытиеСменыПереопределено - Булево - признак того, что используется прикладной механизм закрытия смены. Значение по умолчанию Ложь.
//
Процедура ЗакрытьСмену(Форма, ЗакрытиеСменыПереопределено) Экспорт
	
	ОбщегоНазначенияРМКРТКлиент.ЗакрытьСмену(Форма, ЗакрытиеСменыПереопределено);
	
КонецПроцедуры

// Проверяет является ли вид оплаты наличной формой оплаты.
//
// Параметры:
//  ВидОплаты - СправочникСсылка.ВидыОплат - вид оплаты.
//
// Возвращаемое значение:
//  Булево - Истина, если переданный вид оплаты является наличной формой оплаты.
//
Функция ЭтоОплатаНаличными(ВидОплаты) Экспорт
	
	Возврат ОбщегоНазначенияРМКРТКлиент.ЭтоОплатаНаличными(ВидОплаты);
	
КонецФункции

// Проверяет является ли вид оплаты безналичной формой оплаты.
//
// Параметры:
//  ВидОплаты - СправочникСсылка.ВидыОплат - вид оплаты.
//
// Возвращаемое значение:
//  Булево - Истина, если переданный вид оплаты является безналичной формой оплаты.
//
Функция ЭтоОплатаПлатежнойКартой(ВидОплаты) Экспорт
	
	Возврат ОбщегоНазначенияРМКРТКлиент.ЭтоОплатаПлатежнойКартой(ВидОплаты);
	
КонецФункции

// Возвращает данные текущего экваайрингового терминала.
//
// Параметры:
//  Форма - ФормаКлиентскогоПриложения - форма РМК.
//
// ВозвращаемоеЗначение:
//  ДанныеФормыЭлементКоллекции - найденная строка данных ЭТ.
//
Функция ДанныеТекущегоЭТ(Форма) Экспорт
	
	Возврат ОбщегоНазначенияРМКРТКлиент.ДанныеТекущегоЭТ(Форма);
	
КонецФункции

// Возвращает текст предупреждения о неназначенном сотруднике
//
// Возвращаемое значение:
//  Результат - Строка - текст оповещения
//
Функция ТекстОповещенияОНеназначенномКассире() Экспорт

	Возврат ОбщегоНазначенияРМКРТКлиент.ТекстОповещенияОНеназначенномКассире();

КонецФункции


// Возвращает данные текущих эквайринговых терминалов.
//
// Параметры:
//  Форма - ФормаКлиентскогоПриложения - форма РМК.
//
// ВозвращаемоеЗначение:
//  ДанныеФормыЭлементКоллекции - массив:
//		* ЭлементКоллекции - найденная строка данных ЭТ.
//
Функция ТекущиеЭквайринговыеТерминалы(Форма) Экспорт

	Результат = Новый Массив;
	
	ТекущиеЭквайринговыеТерминалы = ОбщегоНазначенияРМКРТКлиент.ТекущиеЭквайринговыеТерминалы(Форма);
	Если ЗначениеЗаполнено(ТекущиеЭквайринговыеТерминалы) Тогда
		Результат = ТекущиеЭквайринговыеТерминалы;
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

// Процедура производит выемку денежных средств из кассы ККМ.
//
// Параметры
//  Форма - ФормаКлиентскогоПриложения - форма РМК.
//
Процедура ВыполнитьОперациюВыемка(Форма) Экспорт
	
	ОбщегоНазначенияРМКРТКлиент.ВыполнитьОперациюВыемка(Форма);
	
КонецПроцедуры

// Процедура производит внесение денежных средств в кассу ККМ.
//
// Параметры
//  Форма - ФормаКлиентскогоПриложения - форма РМК.
//
Процедура ВыполнитьОперациюВнесение(Форма) Экспорт
	
	ОбщегоНазначенияРМКРТКлиент.ВыполнитьОперациюВнесение(Форма);
	
КонецПроцедуры

// Возвращает признак будет ли использоваться стандарнтый интерфейс внесения ДС.
//
// ВозвращаемоеЗначение:
//  Булево - Истина, если будет использоваться стандартны интерфейс внесения ДС.
//
Функция ИспользоватьСтандартныйИнтерфейсВнесения() Экспорт
	
	Возврат ОбщегоНазначенияРМКРТКлиент.ИспользоватьСтандартныйИнтерфейсВнесения();
	
КонецФункции

// Процедура производит выбор документа для продажи по заказу.
//
// Параметры
//  Форма - ФормаКлиентскогоПриложения - форма РМК.
//
Процедура ВыбратьДокументЗаказПокупателя(Форма) Экспорт
	
	ОбщегоНазначенияРМКРТКлиент.ВыбратьДокументЗаказПокупателя(Форма);
	
КонецПроцедуры

// Процедура производит выбор документа безналичной оплаты.
//
// Параметры
//  Форма - ФормаКлиентскогоПриложения - форма РМК.
//
Процедура ВыбратьДокументБезналичнойОплаты(Форма) Экспорт
	
	ОбщегоНазначенияРМКРТКлиент.ВыбратьДокументБезналичнойОплаты(Форма);
	
КонецПроцедуры

// Процедура выполняет дополнительные действия после того, как прошла оплата по карте.
//
// Параметры
//  Форма - ФормаКлиентскогоПриложения.
//
Процедура ДозаполнитьДанныеПослеОплатыПоКарте(Форма) Экспорт
	
	ОбщегоНазначенияРМКРТКлиент.ДозаполнитьДанныеПослеОплатыПоКарте(Форма);
	
КонецПроцедуры

// Проверяет является ли вид оплаты рассрочкой.
//
// Параметры:
//  ВидОплаты - СправочникСсылка.ВидыОплат - вид оплаты.
//
// Возвращаемое значение:
//  Булево - Истина, если переданный вид оплаты является рассрочкой.
//
Функция ЭтоОплатаВРассрочку(ВидОплаты) Экспорт
	
	Возврат ОбщегоНазначенияРМКРТКлиент.ЭтоОплатаВРассрочку(ВидОплаты);
	
КонецФункции

// Процедура производит выбор документа расчета.
//
// Параметры:
//  Форма - ФормаКлиентскогоПриложения - форма РМК.
//
Процедура ВыбратьДокументРасчета(Форма) Экспорт
	
	ОбщегоНазначенияРМКРТКлиент.ВыбратьДокументРасчета(Форма);
	
КонецПроцедуры

// Процедура формирует и устанавливает заголовок программы.
//
// Параметры:
//  ТекстЗаголовка - Строка - текст заголовка программы.
//  Форма - ФормаКлиентскогоПриложения - форма РМК.
//
Процедура СформироватьЗаголовокПрограммы(ТекстЗаголовка, Форма) Экспорт
	
	ОбщегоНазначенияРМКРТКлиент.СформироватьЗаголовокПрограммы(ТекстЗаголовка, Форма);
	
КонецПроцедуры

// Процедура открывает форму подбора товаров в рабочем месте кассира.
//
// Параметры:
//  Форма - ФормаКлиентскогоПриложения - форма РМК.
//
Процедура ОткрытьФормуПодбораТоваров(Форма) Экспорт
	
	ОбщегоНазначенияРМКРТКлиент.ОткрытьФормуПодбораТоваров(Форма);
	
КонецПроцедуры

// Процедура анализирует данные выбранные пользователем и дозаполняет при необходимости.
// В массив данных необходимо добавить выбранные значения из формы подбора. Т.к возможна
// ситуация, когда в форме подбора реализован множественный выбор строк.
//
// Параметры:
//  ДанныеВыбора - Структура - выбранные данные в форме ручного подбора.
//                 Обязательно должна содержать ключи Номенклатура, Цена.
//                 При необходимости - Характеристика, Упаковка.
//  МассивДанных - Массив - массив, в который нужно добавить выбранные данные.
//  Форма - ФормаКлиентскогоПриложения - форма РМК.
//
Процедура ДозаполнитьДанныеРучногоВыбора(ДанныеВыбора, МассивДанных, Форма) Экспорт
	
	ОбщегоНазначенияРМКРТКлиент.ДозаполнитьДанныеРучногоВыбора(ДанныеВыбора, МассивДанных, Форма);
	
КонецПроцедуры

// Возвращает признак использования в конфигурации внешнего события при получении данных с торгового оборудования.
//
// ВозвращаемоеЗначение:
//  Булево - Истина, если будет использоваться внешнее событие.
//
Функция ИспользоватьВнешнееСобытие() Экспорт
	
	Возврат ОбщегоНазначенияРМКРТКлиент.ИспользоватьВнешнееСобытие();
	
КонецФункции

// Проверяет данные дисконтной карты на ошибки.
//
// Параметры:
//  Форма - ФормаКлиентскогоПриложения - форма РМК.
//
// Возвращаемое значение:
//  Булево - Истина, если есть ошибки заполнения данных дисконтной карты.
//
Функция ЕстьОшибкиЗаполненияДанныхДисконтнойКарты(Форма) Экспорт
	
	Возврат ОбщегоНазначенияРМКРТКлиент.ЕстьОшибкиЗаполненияДанныхДисконтнойКарты(Форма);
	
КонецФункции

// Возвращает значение нужно ли локально создавать карту лояльности.
//
// ВозвращаемоеЗначение:
//  Булево - Истина, если используется локальное создание карт лояльности.
//
Функция СоздаватьЛокальноКартуЛояльности() Экспорт
	
	Возврат ОбщегоНазначенияРМКРТКлиент.СоздаватьЛокальноКартуЛояльности();
	
КонецФункции

// Возвращает признак нужно ли запрашивает данные сертификата через сервис лояльности.
//
// ВозвращаемоеЗначение:
//  Булево - Истина, если требуется запрос через сервис лояльности.
//
Функция НуженЗапросСертификата() Экспорт
	
	Возврат ОбщегоНазначенияРМКРТКлиент.НуженЗапросСертификата();
	
КонецФункции

// Возвращает признак нужно ли запрашивать данные бонусов через сервис лояльности.
//
// Возвращаемое значение:
//  Булево - Истина, если требуется запрос через сервис лояльности.
//
Функция НуженЗапросБонусов() Экспорт
	
	Возврат ОбщегоНазначенияРМКРТКлиент.НуженЗапросБонусов();
	
КонецФункции

// Возвращает признак является ли переданное значение документом безналичной оплаты.
//
// Параметры:
//  ДокументСсылка - ДокументСсылка - ссылка на документ.
//
// ВозвращаемоеЗначение:
//  Булево - Истина, если документ является.
//
Функция ЭтоДокументБезналичнойОплаты(ДокументСсылка) Экспорт
	
	Возврат ОбщегоНазначенияРМКРТКлиент.ЭтоДокументБезналичнойОплаты(ДокументСсылка);
	
КонецФункции

// Процедура заполняет массив особенностями учета номенклатуры, для которых необходима проверка возраста.
//
// Параметры:
//  МассивДанных - Массив - массив, который нужно заполнить.
//
Процедура ЗаполнитьМассивДляПроверкиВозраста(МассивДанных) Экспорт
	
	ОбщегоНазначенияРМКРТКлиент.ЗаполнитьМассивДляПроверкиВозраста(МассивДанных);
	
КонецПроцедуры

// Возвращает пустую ссылку на особенность учета номенклатуры.
//
// ВозвращаемоеЗначение:
//  ОпределяемыйТип.ОсобенностиУчетаНоменклатурыРМК - пустая ссылка на особенность учета номенклатуры.
//
Функция ПустаяСсылкаНаОсобенностьУчетаНоменклатуры() Экспорт
	
	Возврат ОбщегоНазначенияРМКРТКлиент.ПустаяСсылкаНаОсобенностьУчетаНоменклатуры();
	
КонецФункции

// Возвращает пустую ссылку на вид номенклатуры.
//
// ВозвращаемоеЗначение:
//  ОпределяемыйТип.ВидНоменклатурыРМК - пустая ссылка на вид номенклатуры.
//
Функция ПустаяСсылкаНаВидНоменклатуры() Экспорт
	
	Возврат ОбщегоНазначенияРМКРТКлиент.ПустаяСсылкаНаВидНоменклатуры();
	
КонецФункции

// Возвращает ссылку на особенность учета номенклатуры алкоголь.
//
// ВозвращаемоеЗначение:
//  ОпределяемыйТип.ОсобенностиУчетаНоменклатурыРМК - ссылка на особенность учета номенклатуры алкоголь.
//
Функция ОсобенностьУчетаАлкоголь() Экспорт
	
	Возврат ОбщегоНазначенияРМКРТКлиент.ОсобенностьУчетаАлкоголь();
	
КонецФункции

// Возвращает ссылку на особенность учета номенклатуры табак.
//
// ВозвращаемоеЗначение:
//  ОпределяемыйТип.ОсобенностиУчетаНоменклатурыРМК - ссылка на особенность учета номенклатуры табак.
//
Функция ОсобенностьУчетаТабак() Экспорт
	
	Возврат ОбщегоНазначенияРМКРТКлиент.ОсобенностьУчетаТабак();
	
КонецФункции

// Возвращает ссылку на особенность учета номенклатуры алкоголь.
//
// ВозвращаемоеЗначение:
//  ОпределяемыйТип.ОсобенностиУчетаНоменклатурыРМК - ссылка на особенность учета номенклатуры ГИСМ.
//
Функция ОсобенностьУчетаГИСМ() Экспорт
	
	Возврат ОбщегоНазначенияРМКРТКлиент.ОсобенностьУчетаГИСМ();
	
КонецФункции

// Возвращает ссылку на тип номенклатуры подарочный сертификат.
//
// ВозвращаемоеЗначение:
//  ПеречислениеСсылка.ТипыНоменклатуры - ссылка на тип номенклатуры подарочный сертификат.
//
Функция ТипНоменклатурыПодарочныйСертификат() Экспорт
	
	Возврат ОбщегоНазначенияРМКРТКлиент.ТипНоменклатурыПодарочныйСертификат();
	
КонецФункции

// Процедура производит обработку выбранного значения при подборе
// номенклатуры в таблицу быстрых товаров.
//
// Параметры:
//  Форма - ФормаКлиентскогоПриложения - форма настроек рабочего места кассира.
//  ВыбранноеЗначение - Структура - данные для обработки.
//  СтандартнаяОбработка - Булево - признак использования стандартной обработки.
//
Процедура ОбработатьВыбранноеЗначениеБыстрыхТоваров(Форма, ВыбранноеЗначение, СтандартнаяОбработка) Экспорт
	
	ОбщегоНазначенияРМКРТКлиент.ОбработатьВыбранноеЗначениеБыстрыхТоваров(Форма,
		ВыбранноеЗначение,
		СтандартнаяОбработка);
	
КонецПроцедуры

// Открывает форму настроек распределения продаж по кассам ККМ
//
Процедура ОткрытьНастройкиРаспределенияПродаж() Экспорт
	
	ОбщегоНазначенияРМКРТКлиент.ОткрытьНастройкиРаспределенияПродаж();
	
КонецПроцедуры

// Процедура производит действия после открытия чека в очереди.
//
// Параметры:
//  ПараметрыВыполнения - Структура - параметры пробития чека на ККТ.
//  ДополнительныеПараметры - Структура - дополнительные параметры процедуры.
//
Процедура ПослеОткрытияЧека(ПараметрыВыполнения, ДополнительныеПараметры) Экспорт
	
	ОбщегоНазначенияРМКРТКлиент.ПослеОткрытияЧека(ПараметрыВыполнения, ДополнительныеПараметры);
	
КонецПроцедуры

// Процедура производит действия после ошибки печати чека в очереди.
//
// Параметры:
//  ПараметрыВыполнения - Структура - параметры пробития чека на ККТ.
//  ДополнительныеПараметры - Структура - дополнительные параметры процедуры.
//
Процедура ПослеОшибкиПечатиЧека(ПараметрыВыполнения, ДополнительныеПараметры) Экспорт
	
	ОбщегоНазначенияРМКРТКлиент.ПослеОшибкиПечатиЧека(ПараметрыВыполнения, ДополнительныеПараметры);
	
КонецПроцедуры

// Переопределяет доступное ККТ для фискализации чека
// Параметры:
//  РеквизитыЧека - Структура - реквизиты фискального чека
//  СписокУстройств - Массив - список доступных ККТ для фискализации
//  ИдентификаторУстройстваККТ - СправочникСсылка.ПодключаемоеОборудование - выбранное ККТ для фискализации
//  СтандартнаяОбработка - Булево - выполнение стандартной обработки
//
Процедура ДоступноеККТДляФискализации(РеквизитыЧека, СписокУстройств, ИдентификаторУстройстваККТ, СтандартнаяОбработка = Истина) Экспорт
	
	ОбщегоНазначенияРМКРТКлиент.ДоступноеККТДляФискализации(РеквизитыЧека,
		СписокУстройств,
		ИдентификаторУстройстваККТ,
		СтандартнаяОбработка);
	
КонецПроцедуры

// Перечень особенностей учета, поддерживающих возврат товаров без марок
//
// Возвращаемое значение:
//   Результат - Массив из ПеречислениеСсылка.ОсобенностиУчетаНоменклатуры
//
Функция ОсобенностиУчетаДопускающиеВозвратБезМарки() Экспорт
	
	Возврат ОбщегоНазначенияРМКРТКлиент.ОсобенностиУчетаДопускающиеВозвратБезМарки();
	
КонецФункции

// Заполняет параметры выбора для отбора характеристик по владельцу.
//
// Параметры:
//  ПараметрыВыбора - Структура - параметры для отбора характеристик.
//  Номенклатура - ОпределяемыйТип.НоменклатураРМК - владелец характеристик.
//  СтандартнаяОбработка - Булево - признак использования стандартной обработки.
//
Процедура ЗаполнитьПараметрыВыбораХарактеристик(ПараметрыВыбора, Номенклатура, СтандартнаяОбработка) Экспорт
	
	ОбщегоНазначенияРМКРТКлиент.ЗаполнитьПараметрыВыбораХарактеристик(ПараметрыВыбора,
		Номенклатура,
		СтандартнаяОбработка);
	
КонецПроцедуры

// Открывает форму помощника настройки обмена 1С:РМК с другими системами.
//
Процедура ОткрытьПомощникНастройкиОбмена() Экспорт
	
	ОбщегоНазначенияРМКРТКлиент.ОткрытьПомощникНастройкиОбмена();
	
КонецПроцедуры

// Возвращает пустую ссылку на справочник партий номенклатуры.
//
// ВозвращаемоеЗначение:
//  СправочникСсылка - пустая ссылка на справочник партий номенклатуры.
//
Функция ПустаяСсылкаНаПартию() Экспорт
	
	Возврат ОбщегоНазначенияРМКРТКлиент.ПустаяСсылкаНаПартию();
	
КонецФункции

// Возвращает признак необходимости заполнения контрагента при операциях предоплаты и зачете авансов.
//
// ВозвращаемоеЗначение:
//  Булево - Истина, если необходимо запретить операции без контрагента.
//
Функция ЗапрещенаПредоплатаБезКонтрагента() Экспорт
	
	Возврат ОбщегоНазначенияРМКРТКлиент.ЗапрещенаПредоплатаБезКонтрагента();
	
КонецФункции

// Возвращает признак того, является ли операция возвратом продажи.
//
// Параметры:
//  ВидОперации - ПеречислениеСсылка - текущий вид операции.
//
// ВозвращаемоеЗначение:
//  Булево - Истина, если текущий вид операции возврат продажи.
//
Функция ВидОперацииВозвратПродажи(ВидОперации) Экспорт
	
	Возврат ОбщегоНазначенияРМКРТКлиент.ВидОперацииВозвратПродажи(ВидОперации);
	
КонецФункции

// Возвращает признак того, является ли операция скупкой.
//
// Параметры:
//  ВидОперации - ПеречислениеСсылка - текущий вид операции.
//
// ВозвращаемоеЗначение:
//  Булево - Истина, если текущий вид операции скупка.
//
Функция ВидОперацииСкупка(ВидОперации) Экспорт
	
	Возврат ОбщегоНазначенияРМКРТКлиент.ВидОперацииСкупка(ВидОперации);
	
КонецФункции

// Возвращает признак того, является ли операция возвратом скупки.
//
// Параметры:
//  ВидОперации - ПеречислениеСсылка - текущий вид операции.
//
// ВозвращаемоеЗначение:
//  Булево - Истина, если текущий вид операции возврат скупки.
//
Функция ВидОперацииВозвратСкупки(ВидОперации) Экспорт
	
	Возврат ОбщегоНазначенияРМКРТКлиент.ВидОперацииВозвратСкупки(ВидОперации);
	
КонецФункции

// Возвращает вид оплаты "Платежная карта" с привязкой к платежной системе "Сертификат НСПК".
//
Функция ВидОплатыПлатежнаяКартаНСПК() Экспорт
	
	Возврат ОбщегоНазначенияРМКРТКлиент.ВидОплатыПлатежнаяКартаНСПК();
	
КонецФункции

// Проверяет является ли вид оплаты оплатой через зачет аванса.
//
// Параметры:
//  ВидОплаты - СправочникСсылка.ВидыОплат - вид оплаты.
//
// Возвращаемое значение:
//  Булево - Истина, если переданный вид оплаты является оплатой через зачет аванса.
//
Функция ЭтоОплатаЗачетомАванса(ВидОплаты) Экспорт
	
	Возврат ОбщегоНазначенияРМКРТКлиент.ЭтоОплатаЗачетомАванса(ВидОплаты);
	
КонецФункции

// Проверяет является ли вид оплаты оплатой безналом.
//
// Параметры:
//  ВидОплаты - СправочникСсылка.ВидыОплат - вид оплаты.
//
// Возвращаемое значение:
//  Булево - Истина, если переданный вид оплаты является оплатой безналом.
//
Функция ЭтоОплатаБезналом(ВидОплаты) Экспорт
	
	Возврат ОбщегоНазначенияРМКРТКлиент.ЭтоОплатаБезналом(ВидОплаты);
	
КонецФункции

// Проверяет является ли вид оплаты встречным предоставлением.
//
// Параметры:
//  ВидОплаты - СправочникСсылка.ВидыОплат - вид оплаты.
//
// Возвращаемое значение:
//  Булево - Истина, если переданный вид оплаты является наличной формой оплаты.
//
Функция ЭтоОплатаВстречнымПредоставлением(ВидОплаты) Экспорт
	Возврат ОбщегоНазначенияРМКРТКлиент.ЭтоОплатаВстречнымПредоставлением(ВидОплаты);
КонецФункции

// Процедура выполняет дополнительные действия при открытии каталога товаров.
//
// Параметры:
//  Форма - ФормаКлиентскогоПриложения - форма РМК.
//
Процедура ПриОткрытииКаталогаТоваров(Форма) Экспорт
	
	ОбщегоНазначенияРМКРТКлиент.ПриОткрытииКаталогаТоваров(Форма);
	
КонецПроцедуры

// Определяет необходимость дополнительного подтверждения пользователем ввода алкогольной марки.
// 
// Возвращаемое значение:
//  Булево - если Истина, то марка безусловно добавляется в чек. Если Ложь, то после ввода марки алкогольной продукции
//           пользователю будет задан вопрос на подтверждение ее добавления.
//
Функция ДобавлятьМаркуАлкоголяБезПодтверждения() Экспорт
	
	Возврат ОбщегоНазначенияРМКРТКлиент.ДобавлятьМаркуАлкоголяБезПодтверждения();
	
КонецФункции

// Метод реализует собственную логику в конфигурации потребителе по созданию документов списания алкогольной продукции.
//
Процедура СписатьАлкогольнуюПродукцию(Форма) Экспорт
	
	ОбщегоНазначенияРМКРТКлиент.СписатьАлкогольнуюПродукцию(Форма);
	
КонецПроцедуры

// Метод для обработки событий элементов формы добавленных программным способом.
//
// Параметры:
//  Форма - ФормаКлиентскогоПриложения - ОбщаяФорма.НастройкиРабочегоМестаКассира.
//  Элемент - ПолеФормы - Имя элемента.
//
Процедура ПроизвольнаяНастройкаПриИзменении(Форма, Элемент) Экспорт
	
	ОбщегоНазначенияРМКРТКлиент.ПроизвольнаяНастройкаПриИзменении(Форма, Элемент);
	
КонецПроцедуры

// Стандартный обработчик события формы см. вызов из Обработки.РабочееМестоКассира.Формы.ФормаРМК
// с возможностью вернуть во входящий параметр ОбработатьОповещениеНаСервере значение Истина, если
// далее требуется обработать событие на сервере.
// Дополнительно см. метод ОбщегоНазначенияРМКПереопределяемый.ОбработкаОповещения.
//
Процедура ОбработкаОповещения(Форма, ИмяСобытия, Параметр, Источник, ОбработатьОповещениеНаСервере) Экспорт
	
	ОбщегоНазначенияРМКРТКлиент.ОбработкаОповещения(Форма, ИмяСобытия, Параметр, Источник, ОбработатьОповещениеНаСервере);
	
КонецПроцедуры

// Открывает форму опроса владельца карты.
//
// Параметры:
//  Форма - ФормаКлиентскогоПриложения - форма РМК.
//
Процедура ПровестиОпросВладельцаКарты(Форма) Экспорт
	
	ОбщегоНазначенияРМКРТКлиент.ПровестиОпросВладельцаКарты(Форма);
	
КонецПроцедуры

// Проверяет корректность заполнения оплат перед пробитием чека
//
// Параметры:
//  ОплатаЗаполненаВерно - Булево - признак верно заполненной оплаты
//  СтруктураОшибки - Структура - текст заголовка и ошибки.
//  Форма - ФормаКлиентскогоПриложения - форма РМК.
//
Процедура ПроверитьЗаполнениеОплатПередПробитиемЧека(ОплатаЗаполненаВерно, СтруктураОшибки, Форма) Экспорт
	
	ОбщегоНазначенияРМКРТКлиент.ПроверитьЗаполнениеОплатПередПробитиемЧека(ОплатаЗаполненаВерно, СтруктураОшибки, Форма);
	
КонецПроцедуры

// Настраивает элементы формы настроек РМК по разделу SMS подтверждение
//
// Параметры:
//  Форма - ФормаКлиентскогоПриложения - форма настроек РМК.
//  СтандартнаяОбработка - Булево - признак использования стандартной обработки.
//
Процедура НастроитьЭлементыSMSПодтвержденияНаФормеНастроек(Форма, СтандартнаяОбработка) Экспорт
	
	ОбщегоНазначенияРМКРТКлиент.НастроитьЭлементыSMSПодтвержденияНаФормеНастроек(Форма, СтандартнаяОбработка);
	
КонецПроцедуры

// Возвращает признак использования автоматических скидок/бонусных программ
// 
// Возвращаемое значение:
//  ИспользоватьАвтоматическиеСкидки - Булево
//
Функция ОпределитьИспользованиеАвтоматическихСкидок() Экспорт
	
	Возврат ОбщегоНазначенияРМКРТВызовСервера.ОпределитьИспользованиеАвтоматическихСкидок();
	
КонецФункции

#КонецОбласти
