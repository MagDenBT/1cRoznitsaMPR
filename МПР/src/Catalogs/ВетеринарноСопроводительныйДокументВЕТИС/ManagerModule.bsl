
#Область ОбработчикиСобытий

Процедура ОбработкаПолученияПредставления(Данные, Представление, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если Данные.ТребуетсяЗагрузка = Истина Тогда
		Представление = НСтр("ru = 'не загружено'");
	ИначеЕсли ЗначениеЗаполнено(Данные.Дата) Тогда
		Представление = Строка(Данные.Идентификатор) + " " + Строка(Данные.Продукция) + " от " + Формат(Данные.Дата, "ДЛФ=D");
	Иначе
		Представление = Строка(Данные.Идентификатор) + " " + Строка(Данные.Продукция);
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаПолученияПолейПредставления(Поля, СтандартнаяОбработка)
	
	Поля.Добавить("Форма");
	Поля.Добавить("Дата");
	
	Поля.Добавить("Ссылка");
	Поля.Добавить("Наименование");
	Поля.Добавить("ТребуетсяЗагрузка");
	
	Поля.Добавить("Идентификатор");
	Поля.Добавить("Продукция");
	СтандартнаяОбработка = Ложь;
	
КонецПроцедуры

#КонецОбласти

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

Функция НайтиПоДаннымXDTO(ОбъектXDTO, ПараметрыОбмена) Экспорт
	
	СправочникСсылка = ИнтеграцияВЕТИС.СсылкаПоИдентификатору(ПараметрыОбмена, "ВетеринарноСопроводительныйДокументВЕТИС", ОбъектXDTO.uuid);
	Если ЗначениеЗаполнено(СправочникСсылка) Тогда
		Возврат СправочникСсылка;
	КонецЕсли;
	
	ТекстЗапроса = 
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	ВетеринарноСопроводительныйДокументВЕТИС.Ссылка КАК Ссылка
	|ИЗ
	|	Справочник.ВетеринарноСопроводительныйДокументВЕТИС КАК ВетеринарноСопроводительныйДокументВЕТИС
	|ГДЕ
	|	ВетеринарноСопроводительныйДокументВЕТИС.СерияБланкаСтрогойОтчетности = &СерияБланкаСтрогойОтчетности
	|	И ВетеринарноСопроводительныйДокументВЕТИС.НомерБланкаСтрогойОтчетности = &НомерБланкаСтрогойОтчетности
	|	И ВетеринарноСопроводительныйДокументВЕТИС.Дата = &Дата";
	
	Запрос = Новый Запрос(ТекстЗапроса);
	Запрос.УстановитьПараметр("СерияБланкаСтрогойОтчетности", ОбъектXDTO.issueSeries);
	Запрос.УстановитьПараметр("НомерБланкаСтрогойОтчетности", ОбъектXDTO.issueNumber);
	Запрос.УстановитьПараметр("Дата", ОбъектXDTO.issueDate);
	
	Результат = Запрос.Выполнить();
	Если Результат.Пустой() Тогда
		Возврат Справочники.ВетеринарноСопроводительныйДокументВЕТИС.ПустаяСсылка();
	КонецЕсли;
	
	Выборка = Результат.Выбрать();
	
	Выборка.Следующий();
	
	Возврат Выборка.Ссылка;
	
КонецФункции
 
#Область ПроцедурыИФункцииПечатиФормы

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - см. УправлениеПечатью.СоздатьКоллекциюКомандПечати.
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
	// ВСД расширенная этикетка
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.МенеджерПечати = "Обработка.ПечатьЭтикетокВЕТИС";
	КомандаПечати.Идентификатор = "ВСДРасширеннаяЭтикетка";
	КомандаПечати.Представление = НСтр("ru = 'Сжатое представление с расширенной информацией'");
	УправлениеПечатью.ДобавитьУсловиеВидимостиКоманды(КомандаПечати,"Тип",Перечисления.ТипыВетеринарныхДокументовВЕТИС.Производственный,ВидСравнения.НеРавно);
	УправлениеПечатью.ДобавитьУсловиеВидимостиКоманды(КомандаПечати,"Идентификатор","",ВидСравненияКомпоновкиДанных.Заполнено);
	
	// ВСД сжатая этикетка
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.МенеджерПечати = "Обработка.ПечатьЭтикетокВЕТИС";
	КомандаПечати.Идентификатор = "ВСДСжатаяЭтикетка";
	КомандаПечати.Представление = НСтр("ru = 'Сжатое представление'");
	УправлениеПечатью.ДобавитьУсловиеВидимостиКоманды(КомандаПечати,"Тип",Перечисления.ТипыВетеринарныхДокументовВЕТИС.Производственный,ВидСравнения.НеРавно);
	УправлениеПечатью.ДобавитьУсловиеВидимостиКоманды(КомандаПечати,"Идентификатор","",ВидСравненияКомпоновкиДанных.Заполнено);

КонецПроцедуры

Функция ПолучитьДанныеДляПечатнойФормыРасширеннойЭтикеткиВСД(ПараметрыПечати, МассивОбъектов) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Ссылка",МассивОбъектов);
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ВетеринарноСопроводительныйДокументВЕТИС.Ссылка                                              КАК Ссылка,
	|	ВетеринарноСопроводительныйДокументВЕТИС.Форма                                               КАК Форма,
	|	ВетеринарноСопроводительныйДокументВЕТИС.Дата                                                КАК ДатаДокумента,
	|	ВетеринарноСопроводительныйДокументВЕТИС.Статус                                              КАК Статус,
	|	ВетеринарноСопроводительныйДокументВЕТИС.ГрузоотправительХозяйствующийСубъект                КАК Грузоотправитель,
	|	ВетеринарноСопроводительныйДокументВЕТИС.ГрузоотправительХозяйствующийСубъект.Контрагент.ИНН КАК ГрузоотправительИНН,
	|	ВетеринарноСопроводительныйДокументВЕТИС.ТипТТН                                              КАК ТипТТН,
	|	ВетеринарноСопроводительныйДокументВЕТИС.СерияТТН                                            КАК СерияТТН,
	|	ВетеринарноСопроводительныйДокументВЕТИС.НомерТТН                                            КАК НомерТТН,
	|	ВетеринарноСопроводительныйДокументВЕТИС.ДатаТТН                                             КАК ДатаТТН,
	|	ВетеринарноСопроводительныйДокументВЕТИС.ГрузополучательХозяйствующийСубъект                 КАК Грузополучатель,
	|	ВетеринарноСопроводительныйДокументВЕТИС.ГрузополучательХозяйствующийСубъект.Контрагент.ИНН  КАК ГрузополучательИНН,
	|	ВетеринарноСопроводительныйДокументВЕТИС.ГрузополучательПредприятие                          КАК ГрузополучательПредприятие,
	|	ВетеринарноСопроводительныйДокументВЕТИС.ГрузополучательПредприятие.АдресПредставление       КАК ГрузополучательПредприятиеАдрес,
	|	ВетеринарноСопроводительныйДокументВЕТИС.Идентификатор                                       КАК Идентификатор,
	|	ВетеринарноСопроводительныйДокументВЕТИС.Продукция                                           КАК Продукция,
	|	ВетеринарноСопроводительныйДокументВЕТИС.КоличествоВЕТИС                                     КАК Количество,
	|	ВетеринарноСопроводительныйДокументВЕТИС.ЕдиницаИзмеренияВЕТИС                               КАК ЕдиницаИзмерения,
	|	ВетеринарноСопроводительныйДокументВЕТИС.ДатаПроизводстваСтрока                              КАК ДатаПроизводстваСтрока,
	|	ВетеринарноСопроводительныйДокументВЕТИС.ДатаПроизводстваТочностьЗаполнения                  КАК ДатаПроизводстваТочностьЗаполнения,
	|	ВетеринарноСопроводительныйДокументВЕТИС.ДатаПроизводстваНачалоПериода                       КАК ДатаПроизводстваНачалоПериода,
	|	ВетеринарноСопроводительныйДокументВЕТИС.ДатаПроизводстваКонецПериода                        КАК ДатаПроизводстваКонецПериода,
	|	ВетеринарноСопроводительныйДокументВЕТИС.Производители.(
	|		Производитель                    КАК ПроизводительПредприятие,
	|		Производитель.АдресПредставление КАК ПроизводительПредприятиеАдрес)                      КАК Производители
	|ИЗ
	|	Справочник.ВетеринарноСопроводительныйДокументВЕТИС КАК ВетеринарноСопроводительныйДокументВЕТИС
	|ГДЕ
	|	ВетеринарноСопроводительныйДокументВЕТИС.Ссылка В(&Ссылка)
	|ИТОГИ ПО
	|	Ссылка";
	Возврат Запрос.Выполнить();
	
КонецФункции

Функция ПолучитьДанныеДляПечатнойФормыСжатойЭтикеткиВСД(ПараметрыПечати, МассивОбъектов) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Ссылка",МассивОбъектов);
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ВетеринарноСопроводительныйДокументВЕТИС.Ссылка                                              КАК Ссылка,
	|	ВетеринарноСопроводительныйДокументВЕТИС.ГрузоотправительХозяйствующийСубъект                КАК Грузоотправитель,
	|	ВетеринарноСопроводительныйДокументВЕТИС.ГрузоотправительХозяйствующийСубъект.Контрагент.ИНН КАК ГрузоотправительИНН,
	|	ВетеринарноСопроводительныйДокументВЕТИС.Идентификатор                                       КАК Идентификатор
	|ИЗ
	|	Справочник.ВетеринарноСопроводительныйДокументВЕТИС КАК ВетеринарноСопроводительныйДокументВЕТИС
	|ГДЕ
	|	ВетеринарноСопроводительныйДокументВЕТИС.Ссылка В(&Ссылка)
	|ИТОГИ ПО
	|	Ссылка";
	Возврат Запрос.Выполнить();
	
КонецФункции

#КонецОбласти

#КонецОбласти

#КонецЕсли

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныйПрограммныйИнтерфейс



#КонецОбласти

#Область СлужебныеПроцедурыИФункции



#КонецОбласти

#КонецЕсли
