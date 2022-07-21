////////////////////////////////////////////////////////////////////////////////
// ОбменСКонтрагентамиКлиент: механизм обмена электронными документами.
//
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

#Область Настройки

// Включает / отключает использование внутренних документов, с учетом проверки разрешения использования внутренних 
// документов конфигурацией.
//
// Параметры:
//	Использовать - Булево - Истина для включения, Ложь для отключения
//
Процедура УстановитьИспользованиеВнутреннегоЭДО(Использовать) Экспорт
	
	ОбменСКонтрагентамиВызовСервера.УстановитьИспользованиеВнутреннегоЭДО(Использовать);
	
КонецПроцедуры

// Подключает / отключает оповещение о наличии новых электронных документов к получению.
//
// Параметры:
//  Включить - Булево - Истина для включения, Ложь для отключения.	
//
Процедура ИзменитьОповещенияЭДО(Включить = Ложь) Экспорт
	
	ОповещенияОСобытияхЭДОКлиент.ПодключитьОповещенияОНовыхЭлектронныхДокументах(Включить);
	
КонецПроцедуры

// Устарела. Открывает актуальную настройку отправки по переданному объекту учета.
//
//Параметры:
// ОбъектУчета - ОпределяемыйТип.ОснованияЭлектронныхДокументовЭДО - ссылка на объект учета
// Владелец - ФормаКлиентскогоПриложения - владелец для открываемой формы
//            Неопределено - в этом случае форма будет открыта независимо
// ОписаниеОповещенияОЗакрытии - ОписаниеОповещения - обработчик оповещения, который будет вызван при закрытии формы настроек
//
Процедура ОткрытьНастройкуОтправкиОбъектаУчета(ОбъектУчета, Владелец = Неопределено, ОписаниеОповещенияОЗакрытии = Неопределено) Экспорт
	
	КлючНастроек = ОбменСКонтрагентамиВызовСервера.КлючНастроекОтправкиОбъектаУчета(ОбъектУчета);
	
	ПараметрыОткрытияФормы = ОбщегоНазначенияБЭДКлиент.НовыеПараметрыОткрытияФормы();
	ПараметрыОткрытияФормы.Владелец = Владелец;
	ПараметрыОткрытияФормы.ОписаниеОповещенияОЗакрытии = ОписаниеОповещенияОЗакрытии;
	
	НастройкиЭДОКлиент.ОткрытьНастройкуОтправки(КлючНастроек, ПараметрыОткрытияФормы);
	
КонецПроцедуры

#КонецОбласти

#Область РаботаСДокументами

// Создает, утверждает, подписывает и отправляет электронный документ. Выполняются только те действия,
// которые действительно требуются для электронного документа (еще не были выполнены и допустимы). Используется как для
// исходящих, так и для входящих документов.
//
// Параметры:
//  ОбъектУчета        - ОпределяемыйТип.ОснованияЭлектронныхДокументовЭДО - ссылка на объект учета, электронные документы
//  			         которого нужно обработать.
//  ОписаниеОповещения - ОписаниеОповещения - обработчик оповещения, который вызывается по окончании операции.
//                       В качестве результата передается Истина, если удалось выполнить действия хотя бы по одному объекту.
//
Процедура ВыполнитьКомплекснуюОбработкуАктуальногоЭлектронногоДокумента(ОбъектУчета, ОписаниеОповещения = Неопределено) Экспорт
	
	ОбъектыУчета = ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(ОбъектУчета);
	ИнтерфейсДокументовЭДОКлиент.ВыполнитьКомплекснуюОбработкуАктуальныхЭлектронныхДокументовОбъектовУчета(ОбъектыУчета, ОписаниеОповещения);
	
КонецПроцедуры

// Открывает актуальный электронный документ, соответствующий переданному объекту учета.
//
// Параметры:
//  ОбъектУчета - ОпределяемыйТип.ОснованияЭлектронныхДокументовЭДО - ссылка на объект учета
//
Процедура ОткрытьАктуальныйЭлектронныйДокумент(ОбъектУчета) Экспорт

	ИнтерфейсДокументовЭДОКлиент.ОткрытьЭлектронныйДокументОбъектаУчета(ОбъектУчета);
	
КонецПроцедуры

// Отклоняет актуальный для переданного учетного объекта электронный документ. Если в процессе выполнения метода 
// возникают ошибки, они обрабатываются библиотекой, вызывающей стороне не возвращаются.
//
// Параметры:
//  ОбъектУчета        - ОпределяемыйТип.ОснованияЭлектронныхДокументовЭДО - ссылка на объект учета. Имеет смысл передавать 
//  					 только входящие документы.
//  ОписаниеОповещения - ОписаниеОповещения - оповещение вызывается по окончании выполнения операции. В качестве результата
//                         передается "Истина" в случае, если отклонение выполнено успешно, "Ложь" - в противном случае.
//
Процедура ОтклонитьАктуальныйЭлектронныйДокумент(ОбъектУчета, ОписаниеОповещения = Неопределено) Экспорт

	ОбъектыУчета = ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(ОбъектУчета);
	ИнтерфейсДокументовЭДОКлиент.ОтклонитьАктуальныеЭлектронныеДокументыОбъектовУчета(ОбъектыУчета, ОписаниеОповещения);
	
КонецПроцедуры

// Возвращает пустые параметры создания произвольного документа.
// 
// Возвращаемое значение:
//  Структура - Новые параметры создания произвольного документа:
//  * Организация - ОпределяемыйТип.Организация - организация, от имени которой нужно отправить документ.
//  * Контрагент - ОпределяемыйТип.КонтрагентБЭД - контрагент, которому нужно отправить документ.
//  * Договор - ОпределяемыйТип.ДоговорСКонтрагентомЭДО - договор, по которому отправляется документ.
//  * ВидДокумента - СправочникСсылка.ВидыДокументовЭДО - вид электронного документа. Если не указан, то определяется автоматически.
//  * НомерДокумента - Строка - номер электронного документа.
//  * ДатаДокумента - Дата - дата электронного документа
//  * СуммаДокумента - Число - сумма по документу.
//  * ОбъектыУчета - Массив Из ОпределяемыйТип.ОснованияЭлектронныхДокументовЭДО - учетные объекты, которые нужно проставить в качестве основания.
//  * Подписанты - Массив из ОпределяемыйТип.Пользователь - подписанты электронного документа. Если не указаны, то заполняются из настроек. Если указаны, то устанавливается маршрут подписания См. МаршрутыПодписанияБЭД.МаршрутУказыватьПриСоздании.
//
Функция НовыеПараметрыСозданияЭлектронногоДокументаПоФайлу() Экспорт
	Возврат ЭлектронныеДокументыЭДОКлиентСервер.НовыеПараметрыСозданияДокументаПоФайлу();
КонецФункции

// Конвертирует переданные двоичные данные в произвольный электронный документ.
//
// Параметры:
//  ОповещениеОЗавершении - ОписаниеОповещения - описание процедуры, которая будет вызвана после создания документа:
//  * ЭлектронныйДокумент - Неопределено - если создание отменено пользователем.
//                        - ДокументСсылка.ЭлектронныйДокументИсходящийЭДО - ссылка на созданный документ.
//                          Если документ не создан, то возвращается пустая ссылка.
//  * ДополнительныеПараметры - Произвольный - значение, которое было указано при создании объекта ОписаниеОповещения.
//  ПараметрыСоздания - См. НовыеПараметрыСозданияЭлектронногоДокументаПоФайлу
//  ПараметрыФайла - Структура - описывает файл, который нужно отправить:
//  * ИмяФайла - Строка - имя файла вместе с расширением.
//  * АдресХранилища - Строка - адрес временного хранилища, в котором содержатся двоичные данные файла.
//
Процедура НачатьСозданиеЭлектронногоДокументаПоФайлу(ОповещениеОЗавершении, ПараметрыСоздания, ПараметрыФайла) Экспорт
	
	ИнтерфейсДокументовЭДОКлиент.НачатьСозданиеЭлектронногоДокументаПоФайлу(
		ОповещениеОЗавершении, ПараметрыСоздания, ПараметрыФайла);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийФормУчетныхДокументов

// Конструктор параметров см. ПриОткрытии
// 
// Возвращаемое значение:
//  Структура - параметры, которые необходимо передать в метод ОбменСКонтрагентамиКлиент.ПриОткрытии.
//    * Форма - УправляемаяФорма - форма справочника или документа.
//    * МестоРазмещенияКоманд - ЭлементФормы - элемент формы "группа", в котором должны отображаться команды ЭДО, необязательный параметр.
//    * ЕстьОбработчикОбновитьКомандыЭДО - Булево - нужно устанавливать в Истина в форме прикладного справочника организаций.
//
Функция ПараметрыПриОткрытии() Экспорт

	Возврат ИнтерфейсДокументовЭДОКлиент.ПараметрыПриОткрытииФормы();

КонецФункции

// Вызывается из обработчика события "ПриОткрытии" формы списка и формы учетных документов.
// Параметры:
//  Параметры - см. ПараметрыПриОткрытии.
//            - ФормаКлиентскогоПриложения   
//
Процедура ПриОткрытии(Параметры) Экспорт
	
	ИнтерфейсДокументовЭДОКлиент.ПриОткрытииФормы(Параметры);
	
КонецПроцедуры

// Конструктор параметров см. ОбработкаОповещения_ФормаДокумента
//
// Возвращаемое значение:
//  Структура - параметры, которые нужно передавать в метод ОбменСКонтрагентамиКлиент.ОбработкаОповещения_ФормаДокумента:
//    * Форма - ФормаКлиентскогоПриложения - форма учетного документа.
//    * ДокументСсылка - ОпределяемыйТип.ОснованияЭлектронныхДокументовЭДО - ссылка на учетный документ.
//    * КонтроллерСостояниеЭДО - ЭлементФормы - элемент формы с типом "декорация" или "поле надписи", в котором будет 
//                               отображаться состояние ЭДО.
//    * ГруппаСостояниеЭДО - ЭлементФормы - элемент формы типа "группа", которому может принадлежать КонтроллерСостояниеЭДО, 
//                           необязательный параметр.
//    * МестоРазмещенияКоманд - ЭлементФормы - подменю, в котором отображаются команды ЭДО.
//                            - Массив из ЭлементФормы - набор подменю, в которых отображаются команды ЭДО.
//
Функция ПараметрыОповещенияЭДО_ФормаДокумента() Экспорт
	
	Возврат ИнтерфейсДокументовЭДОКлиент.ПараметрыОповещенияЭДО_ФормаДокумента();
	
КонецФункции

// Обработчик события "ОбработкаОповещения" формы учетного документа.
//
// Параметры:
//  ИмяСобытия - Строка - Имя события.
//  Параметр - Произвольный - Параметр сообщения. Могут быть переданы любые необходимые данные.
//  Источник - Произвольный - Источник события. Например, в качестве источника может быть указана другая форма.
//  ПараметрыОповещения - Структура - см. ОбменСКонтрагентамиКлиент.ПараметрыОповещенияЭДО_ФормаДокумента.
//  РезультатыОбработкиОповещения - Структура - Выходной параметр. Содержит ключи:
//    * ИзменилосьСостояниеЭДО - Булево - Истина, если произошло изменение состояния ЭДО объекта учета, отображаемого 
//                                        в вызывающей форме. 
//
Процедура ОбработкаОповещения_ФормаДокумента(ИмяСобытия, Параметр, Источник, ПараметрыОповещения,
	РезультатыОбработкиОповещения = Неопределено) Экспорт
	
	ИнтерфейсДокументовЭДОКлиент.ОбработкаОповещения_ФормаДокумента(ИмяСобытия, Параметр, Источник, ПараметрыОповещения,
		РезультатыОбработкиОповещения);
	
КонецПроцедуры

// Конструктор параметров см. ОбработкаОповещения_ФормаСписка
//
// Возвращаемое значение:
//  Структура - параметры, которые нужно передавать в метод см. ОбработкаОповещения_ФормаДокумента.
//    * Форма - ФормаКлиентскогоПриложения - форма списка учетного документа.
//    * ИмяДинамическогоСписка - Строка - Наименование динамического списка формы, отображающего "СостояниеЭД".
//                               Возможно указание нескольких списков через ("СписокИсходящий, СписокВходящий").
//    * МестоРазмещенияКоманд - ЭлементФормы - подменю, в котором отображаются команды ЭДО.
//                            - Массив из ЭлементФормы - набор подменю, в которых отображаются команды ЭДО.
//    * ЕстьОбработчикОбновитьКомандыЭДО - Булево - нужно устанавливать в Истина в форме прикладного справочника организаций.
//    * ЕстьОбработчикОбновленияВидимостиСостоянияЭДО - Булево - нужно устанавливать в Истина в формах списка внутрених документов ЭДО.
//
Функция ПараметрыОповещенияЭДО_ФормаСписка() Экспорт
	
	Возврат ИнтерфейсДокументовЭДОКлиент.ПараметрыОповещенияЭДО_ФормаСписка();
	
КонецФункции

// Обработчик события "ОбработкаОповещения" формы списка документов.
//
// Параметры:
//  ИмяСобытия - Строка - имя события.
//  Параметр - Произвольный - параметр сообщения, могут быть переданы любые необходимые данные.
//  Источник - Произвольный - источник события. Например, в качестве источника может быть указана другая форма.
//  ПараметрыОповещения - Структура - см. ПараметрыОповещенияЭДО_ФормаСписка.
//
Процедура ОбработкаОповещения_ФормаСписка(ИмяСобытия, Параметр, Источник, ПараметрыОповещения) Экспорт
	
	ИнтерфейсДокументовЭДОКлиент.ОбработкаОповещения_ФормаСписка(ИмяСобытия, Параметр, Источник, ПараметрыОповещения);
	
КонецПроцедуры

// Конструктор параметров см. ОбработкаОповещения_ФормаСправочника
//
// Возвращаемое значение:
//  Структура - параметры, которые нужно передавать в метод ОбработкаОповещения_ФормаСправочника.
//    * Форма - ФормаКлиентскогоПриложения - форма справочника.
//    * МестоРазмещенияКоманд - ЭлементФормы - подменю, в котором отображаются команды ЭДО.
//                            - Массив из ЭлементФормы - набор подменю, в которых отображаются команды ЭДО.
//    * ЕстьОбработчикОбновитьКомандыЭДО - Булево - нужно устанавливать в Истина в форме прикладного справочника организаций.
//
Функция ПараметрыОповещенияЭДО_ФормаСправочника() Экспорт
	
	Возврат ИнтерфейсДокументовЭДОКлиент.ПараметрыОповещенияЭДО_ФормаСправочника();
	
КонецФункции

// Обработчик события "ОбработкаОповещения" формы списка документов.
//
// Параметры:
//  ИмяСобытия - Строка - имя события.
//  Параметр - Произвольный - параметр сообщения, могут быть переданы любые необходимые данные.
//  Источник - Произвольный - источник события. Например, в качестве источника может быть указана другая форма.
//  ПараметрыОповещения - Структура - см. ОбменСКонтрагентамиКлиент.ПараметрыОповещенияЭДО_ФормаСправочника.
//
Процедура ОбработкаОповещения_ФормаСправочника(ИмяСобытия, Параметр, Источник, ПараметрыОповещения) Экспорт
	
	ИнтерфейсДокументовЭДОКлиент.ОбработкаОповещения_ФормаСправочника(ИмяСобытия, Параметр, Источник, ПараметрыОповещения);
	
КонецПроцедуры

// Конструктор параметров см. ОбработчикОжиданияЭДО
//
// Возвращаемое значение:
//  Структура - параметры, которые нужно передавать в метод "ОбменСКонтрагентамиКлиент.ОбработчикОжиданияЭДО".
//    * МестоРазмещенияКоманд - ЭлементФормы - подменю, в котором отображаются команды ЭДО.
//                            - Массив из ЭлементФормы - набор подменю, в которых отображаются команды ЭДО.
//
Функция ПараметрыОжиданияЭДО() Экспорт
	
	Возврат ИнтерфейсДокументовЭДОКлиент.ПараметрыОжиданияЭДО();
	
КонецФункции

// Обработчик ожидания событий ЭДО.
//
// Параметры:
//  Форма - ФормаКлиентскогоПриложения - форма, к которой подключается обработчик;
//  ПараметрыОжиданияЭДО - см. ПараметрыОжиданияЭДО
//
Процедура ОбработчикОжиданияЭДО(Форма, ПараметрыОжиданияЭДО = Неопределено) Экспорт
	
	ИнтерфейсДокументовЭДОКлиент.ОбработчикОжиданияЭДО(Форма, ПараметрыОжиданияЭДО);
	
КонецПроцедуры

// Обработчик события "ПослеЗаписи" формы документа.
// При встраивании метода в форму документа необходимо доработать реализацию
// метода см. ОбменСКонтрагентамиПереопределяемый.ПриОпределенииДокументовСПоддержкойДиагностикиОшибок.
//
// Параметры:
//  Форма - ФормаКлиентскогоПриложения - форма учетного документа.
//  ПараметрыЗаписи - Структура - см. параметр события формы ПослеЗаписи.
//
Процедура ПослеЗаписи_ФормаДокумента(Форма, ПараметрыЗаписи) Экспорт
	
	ИнтерфейсДокументовЭДОКлиент.ПослеЗаписи_ФормаДокумента(Форма, ПараметрыЗаписи);
	
КонецПроцедуры

// Обработчик события "ПриАктивизацииСтроки" формы списка, на которой подключено обновление команд ЭДО. 
//
// Параметры:
//  Форма - ФормаКлиентскогоПриложения - форма списка.
//
Процедура ПриАктивизацииСтроки_ФормаСписка(Форма) Экспорт
	
	ИнтерфейсДокументовЭДОКлиент.ПриАктивизацииСтроки_ФормаСписка(Форма);

КонецПроцедуры

// Обновляет список команд ЭДО в зависимости от текущего контекста.
//
// Параметры:
//   Форма - ФормаКлиентскогоПриложения - форма, для которой требуется обновление команд.
//   Источник - ДанныеФормыСтруктура - основной объект формы (если вызывается из формы объекта).
//   			ТаблицаФормы - таблица, содержащая список (если вызывается из формы списка).
//
Процедура ОбновитьКоманды(Форма, Источник) Экспорт
	
	ПодключаемыеКомандыЭДОКлиент.ОбновитьКоманды(Форма, Источник);
	
КонецПроцедуры

// Обработчик нажатия на гиперссылку "СостояниеЭДО" в форме документа
//
// Параметры:
//  Форма - ФормаКлиентскогоПриложения - форма учетного документа.
//  СтандартнаяОбработка - Булево - Признак стандартной обработки нажатия на гиперссылку.
//
Процедура СостояниеЭДОНажатие_ФормаДокумента(Форма, СтандартнаяОбработка = Ложь) Экспорт
	
	ИнтерфейсДокументовЭДОКлиент.КонтроллерСостояниеЭДОНажатие(Форма, СтандартнаяОбработка);
	
КонецПроцедуры

// Обработчик нажатия на гиперссылку "СостояниеЭДО" в форме списка документа.
//
// Параметры:
//  ОбъектУчета - ОпределяемыйТип.ОснованияЭлектронныхДокументовЭДО - ссылка на объект учета.
//  СтандартнаяОбработка - Булево - признак стандартной обработки нажатия на гиперссылку.
//
Процедура СостояниеЭДОНажатие_ФормаСписка(ОбъектУчета, СтандартнаяОбработка = Ложь) Экспорт
	
	ИнтерфейсДокументовЭДОКлиент.ДекорацияСостояниеЭДОФормаСпискаНажатие(ОбъектУчета, СтандартнаяОбработка);

КонецПроцедуры

// Обработчик обновления видимости состояния ЭДО.
//
// Параметры:
//  Форма - ФормаКлиентскогоПриложения - форма, к которой подключается обработчик.
//  КолонкаСостояния - ЭлементФормы - колонка состояния.
//
Процедура ОбработчикОбновленияВидимостьСостоянияЭДО(Форма, КолонкаСостояния) Экспорт
	
	ИнтерфейсДокументовЭДОКлиент.ОбработчикОбновленияВидимостьСостоянияЭДО(Форма, КолонкаСостояния);	
	
КонецПроцедуры

#КонецОбласти

#Область Интеграция1СЭДОИ1СОтчетности

// Открывает форму настройки регистрации в сервисе ЭДО.
//
// Параметры:
//  Настройки - Строка - настройки регистрации.
//                       См. ОбменСКонтрагентами.ИнициализироватьНастройкиПодключенияЭДО.
//                       См. ОбменСКонтрагентами.ИнициализироватьНастройкиПереизданияСертификатаЭДО.
//  ВыполняемоеОповещение - ОписаниеОповещения - описание процедуры, которая будет вызвана при закрытии формы со следующими параметрами:
//   * Настройки - Строка - измененные настройки регистрации.
//               - Неопределено - пользователь отказался от редактирования настроек.
//   * ДополнительныеПараметры - Произвольный - значение, которое было указано при создании объекта ОписаниеОповещения.
//
Процедура ОткрытьФормуНастроекРегистрацииЭДО(Знач Настройки, Знач ВыполняемоеОповещение) Экспорт
	
	ИнтеграцияБРОЭДОКлиент.ОткрытьФормуНастроекРегистрацииЭДО(Настройки, ВыполняемоеОповещение);
	
КонецПроцедуры

// Запускает отправку данных оператору ЭДО, согласно переданным настройкам.
// Поддерживается подключение к ЭДО и переиздание сертификата.
//
// Параметры:
//  Настройки - Строка - настройки регистрации.
//                       См. ОбменСКонтрагентами.ИнициализироватьНастройкиПодключенияЭДО.
//                       См. ОбменСКонтрагентами.ИнициализироватьНастройкиПереизданияСертификатаЭДО.
//  Сертификат - СертификатКриптографии - сертификат криптографии для регистрации у оператора ЭДО.
//  ВыполняемоеОповещение - ОписаниеОповещения - описание процедуры, которая будет вызвана при окончании отправки данных со следующими параметрами:
//   * Результат - Структура - результат отправки со следующими свойствами:
//    ** Выполнено - Булево - Истина, если настройка ЭДО завешена успешна и продолжения не требует.
//    ** Настройка - Строка - настройки для повторной попытки, если операция не была завершена.
//                 - Неопределено - операция завершена успешно.
//   * ДополнительныеПараметры - Произвольный - значение, которое было указано при создании объекта ОписаниеОповещения.
//
Процедура ОткрытьФормуОтправкиДанныхОператоруЭДО(Знач Настройки, Знач Сертификат ,Знач ВыполняемоеОповещение) Экспорт
	
	ИнтеграцияБРОЭДОКлиент.ОткрытьФормуОтправкиДанныхОператоруЭДО(Настройки, Сертификат, ВыполняемоеОповещение);
	
КонецПроцедуры

#КонецОбласти

#Область ТекущиеДелаЭДО

// Запускает рабочее место "Текущие дела ЭДО".
// 
// Параметры:
// 	ПараметрыОтбора - см. ОбменСКонтрагентамиКлиентСервер.ПараметрыОтбораТекущихДелЭДО.
//  ОповещениеОЗакрытии - ОписаниеОповещения - обработчик оповещения, который будет вызван при закрытии.
Процедура ОткрытьТекущиеДелаЭДО(ПараметрыОтбора = Неопределено, ОповещениеОЗакрытии = Неопределено) Экспорт
	
	ПараметрыЗапуска = ИнтерфейсДокументовЭДОКлиент.ПараметрыЗапускаТекущихДелЭДО();
	ПараметрыЗапуска.РежимОтображения         = ПараметрыОтбора.РежимОтображения;
	ПараметрыЗапуска.Раздел                   = ПараметрыОтбора.Раздел;
	ПараметрыЗапуска.ОтборВходящихДокументов  = ПараметрыОтбора.ОтборВходящихЭлектронныхДокументов;
	Для Каждого ЭлементОтбора Из ПараметрыЗапуска.ОтборВходящихДокументов Цикл
		ЭлементОтбора.Поле = "ЭлектронныйДокумент." + ЭлементОтбора.Поле;
	КонецЦикла;
	ПараметрыЗапуска.ОтборИсходящихДокументов = ПараметрыОтбора.ОтборИсходящихЭлектронныхДокументов;
	Для Каждого ЭлементОтбора Из ПараметрыЗапуска.ОтборИсходящихДокументов Цикл
		ЭлементОтбора.Поле = "ЭлектронныйДокумент." + ЭлементОтбора.Поле;
	КонецЦикла;
	ПараметрыЗапуска.ОтборУчетныхДокументов   = ПараметрыОтбора.ОтборВРазделеСоздать;
	Для Каждого ЭлементОтбора Из ПараметрыЗапуска.ОтборУчетныхДокументов Цикл
		ЭлементОтбора.Поле = "Документ." + ЭлементОтбора.Поле;
	КонецЦикла;
	ИнтерфейсДокументовЭДОКлиент.ОткрытьТекущиеДелаЭДО(ПараметрыЗапуска, ОповещениеОЗакрытии);
	
КонецПроцедуры

#КонецОбласти

#Область Прочее

// Запускает мастер-помощник по подключению организации к сервису 1С-ЭДО.
//
Процедура ПомощникПодключенияКСервису1СЭДО(Организация = Неопределено) Экспорт
	
	ПараметрыСозданияЗаписи = СинхронизацияЭДОКлиент.НовыеПараметрыСозданияУчетнойЗаписи();
	ПараметрыСозданияЗаписи.СпособыОбмена.Добавить(ПредопределенноеЗначение("Перечисление.СпособыОбменаЭД.ЧерезСервис1СЭДО"));
	ПараметрыСозданияЗаписи.Организация = Организация;
	СинхронизацияЭДОКлиент.СоздатьУчетнуюЗапись(ПараметрыСозданияЗаписи);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти