
#Область СлужебныйПрограммныйИнтерфейс

// Устанавливает путь к каталогу временных файлов в операционной системе Windows.
// 
// Параметры:
// 	Путь - Строка
// Возвращаемое значение:
//  Булево - Истина, если установка прошла успешно
Функция УстановитьПутьККаталогуВременныхФайлов(Путь) Экспорт
	
	Если Не ОбщегоНазначенияКлиент.ЭтоWindowsКлиент() Тогда
		ОбщегоНазначенияКлиент.СообщитьПользователю(
			НСтр("ru = 'Установка пути к каталогу временных файлов не поддерживается для данной операционной системы'"));
		Возврат Ложь;
	КонецЕсли;
	
	#Если Не МобильныйКлиент Тогда
		
		Если Не ЗначениеЗаполнено(Путь) Тогда
			ПоказатьПредупреждение(, НСтр("ru = 'Не заполнен путь к каталогу временных файлов'"));
			Возврат Ложь;
		КонецЕсли;
		Оболочка = Новый COMОбъект("Wscript.Shell");
		Оболочка.RegWrite("HKEY_CURRENT_USER\Environment\TMP", Путь, "REG_EXPAND_SZ");
		
		Возврат Истина;
	#КонецЕсли
	
	Возврат Ложь;
	
КонецФункции

// Вызывает РаботаСФайламиКлиент.СохранитьФайлКак() с подготовленными данными файла.
//
// Параметры:
// 	ДанныеФайлаВыгрузки - Структура - см. РаботаСФайламиБЭД.ДанныеФайла().
// 	СсылкаНаДвоичныеДанные - Строка - адрес во временном хранилище, по которому помещены данные.
// 	ОбработчикЗавершения - ОписаниеОповещения, Неопределено - описание процедуры, которая будет вызвана после сохранения.
//
Процедура СохранитьФайлВыгрузкиКак(ДанныеФайлаВыгрузки, СсылкаНаДвоичныеДанныеФайла,
	ОбработчикЗавершения = Неопределено) Экспорт
	
	ДанныеФайла = Новый Структура;
	ДанныеФайла.Вставить("СсылкаНаДвоичныеДанныеФайла", СсылкаНаДвоичныеДанныеФайла);
	ДанныеФайла.Вставить("ОтносительныйПуть", "");
	ДанныеФайла.Вставить("ДатаМодификацииУниверсальная", ОбщегоНазначенияКлиент.ДатаУниверсальная());
	ДанныеФайла.Вставить("ИмяФайла", ДанныеФайлаВыгрузки.ИмяФайла);
	ДанныеФайла.Вставить("Наименование", ДанныеФайлаВыгрузки.ИмяБезРасширения);
	ДанныеФайла.Вставить("Расширение", ДанныеФайлаВыгрузки.Расширение);
	ДанныеФайла.Вставить("Размер", ДанныеФайлаВыгрузки.Размер);
	ДанныеФайла.Вставить("Редактирует", Неопределено);
	ДанныеФайла.Вставить("ПодписанЭП", Ложь);
	ДанныеФайла.Вставить("Зашифрован", Ложь);
	ДанныеФайла.Вставить("ХранитьВерсии", Ложь);
	ДанныеФайла.Вставить("ПометкаУдаления", Ложь);
	ДанныеФайла.Вставить("ДатаЗаема", Неопределено);
	ДанныеФайла.Вставить("ФайлРедактируется", Ложь);
	ДанныеФайла.Вставить("ФайлРедактируетТекущийПользователь", Ложь);
	ДанныеФайла.Вставить("НомерВерсии", 0);
	ДанныеФайла.Вставить("ПолноеНаименованиеВерсии", ДанныеФайлаВыгрузки.ИмяБезРасширения);
	ДанныеФайла.Вставить("ПапкаДляСохранитьКак", Неопределено);
	
	РаботаСФайламиКлиент.СохранитьФайлКак(ДанныеФайла, ОбработчикЗавершения);
	
КонецПроцедуры

#КонецОбласти