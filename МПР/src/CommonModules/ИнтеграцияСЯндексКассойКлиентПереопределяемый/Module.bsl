////////////////////////////////////////////////////////////////////////////////
// ИнтеграцияСЯндексКассойКлиентПереопределяемый: механизм интеграции с Яндекс.Кассой.
//
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

#Область ФормаНастроекЯндексКассы

// Обработчик события ПриИзменении добавленного элемента формы настроек Яндекс.Кассы.
// См. ИнтеграцияСЯндексКассойПереопределяемый.ПриСозданииФормыНастроекЯндексКассы.
//
// Параметры:
//  Контекст - Структура - контекст выполнения метода:
//   * Форма - ФормаКлиентскогоПриложения - форма настроек Яндекс.Кассы.
//   * Префикс - Строка - префикс имен добавленных реквизитов, команд и элементов формы.
//   * НоваяНастройка - Булево - признак редактирования новой настройки.
//   * Организация - ОпределяемыТип.Организация - организация, для которой производится настройка.
//   * СДоговором - Булево - признак варианта использования сервиса "С договором". Если Ложь, то "Без договора".
//  Элемент - ЭлементФормы - см. описание параметра события элемента формы.
//
Процедура ЭлементФормыНастроекПриИзменении(Контекст, Элемент) Экспорт
	
КонецПроцедуры

// Обработчик события Создание добавленного элемента формы настроек Яндекс.Кассы.
// См. ИнтеграцияСЯндексКассойПереопределяемый.ПриСозданииФормыНастроекЯндексКассы.
//
// Параметры:
//  Контекст - Структура - контекст выполнения метода:
//   * Форма - ФормаКлиентскогоПриложения - форма настроек Яндекс.Кассы.
//   * Префикс - Строка - префикс имен добавленных реквизитов, команд и элементов формы.
//   * НоваяНастройка - Булево - признак редактирования новой настройки.
//   * Организация - ОпределяемыТип.Организация - организация, для которой производится настройка.
//   * СДоговором - Булево - признак варианта использования сервиса "С договором". Если Ложь, то "Без договора".
//  Элемент - ЭлементФормы - см. описание параметра события элемента формы.
//  СтандартнаяОбработка - Булево - см. описание параметра события элемента формы.
//
Процедура ЭлементФормыНастроекСоздание(Контекст, Элемент, СтандартнаяОбработка) Экспорт
	
	ИнтеграцияСЯндексКассойРТКлиент.ЭлементФормыНастроекСоздание(Контекст, Элемент, СтандартнаяОбработка);
	
КонецПроцедуры

// Обработчик события НачалоВыбора добавленного элемента формы настроек Яндекс.Кассы.
// См. ИнтеграцияСЯндексКассойПереопределяемый.ПриСозданииФормыНастроекЯндексКассы.
//
// Параметры:
//  Контекст - Структура - контекст выполнения метода. Аналогично методу ЭлементФормыНастроекПриИзменении.
//  Элемент - ЭлементФормы - см. описание параметра события элемента формы.
//  ДанныеВыбора - СписокЗначений - см. описание параметра события элемента формы.
//  СтандартнаяОбработка - Булево - см. описание параметра события элемента формы.
//
Процедура ЭлементФормыНастроекНачалоВыбора(Контекст, Элемент, ДанныеВыбора, СтандартнаяОбработка) Экспорт
	
КонецПроцедуры

// Обработчик события ОбработкаВыбора добавленного элемента формы настроек Яндекс.Кассы.
// См. ИнтеграцияСЯндексКассойПереопределяемый.ПриСозданииФормыНастроекЯндексКассы.
//
// Параметры:
//  Контекст - Структура - контекст выполнения метода. Аналогично методу ЭлементФормыНастроекПриИзменении.
//  Элемент - ЭлементФормы - см. описание параметра события элемента формы.
//  ВыбранноеЗначение - Произвольный - см. описание параметра события элемента формы.
//  СтандартнаяОбработка - Булево - см. описание параметра события элемента формы.
//
Процедура ЭлементФормыНастроекОбработкаВыбора(Контекст, Элемент, ВыбранноеЗначение, СтандартнаяОбработка) Экспорт
	
	ИнтеграцияСЯндексКассойРТКлиент.ЭлементФормыНастроекОбработкаВыбора(Контекст, Элемент, ВыбранноеЗначение, СтандартнаяОбработка);
	
КонецПроцедуры

// Обработчик события Нажатие добавленного элемента формы настроек Яндекс.Кассы.
// См. ИнтеграцияСЯндексКассойПереопределяемый.ПриСозданииФормыНастроекЯндексКассы.
//
// Параметры:
//  Контекст - Структура - контекст выполнения метода. Аналогично методу ЭлементФормыНастроекПриИзменении.
//  Элемент - ЭлементФормы - см. описание параметра события элемента формы.
//
Процедура ЭлементФормыНастроекНажатие(Контекст, Элемент) Экспорт
	
КонецПроцедуры

// Выполняет действие подключаемой команды формы настроек Яндекс.Кассы.
// См. ИнтеграцияСЯндексКассойПереопределяемый.ПриСозданииФормыНастроекЯндексКассы.
//
// Параметры:
//  Контекст - Структура - контекст выполнения метода. Аналогично методу ЭлементФормыНастроекПриИзменении.
//  Команда - КомандаФормы - см. описание параметра действия команды формы.
//
Процедура КомандаФормыНастроекДействие(Контекст, Команда) Экспорт
	
КонецПроцедуры

#КонецОбласти

#Область РаботаССообщениями

// Заполняет параметры сообщения электронной почты, отправляемого без шаблона.
// Применяется в случае, если шаблоны сообщений не используются.
// 
// Параметры:
//  ПараметрыСообщения - Структура - Параметры сообщения электронной почты:
//   * Получатель - СписокЗначений - Список адресов электронной почты.
//   * Предмет - Произвольный - Ссылка на основание платежа.
//   * ПлатежнаяСсылка - Строка - Платежная ссылка, отправляемая в сообщении.
//   * Тема - Строка - Тема сообщения.
//   * Текст - Строка - Текст сообщения.
//
Процедура ЗаполнитьПараметрыСообщенияБезШаблона(ПараметрыСообщения) Экспорт
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

