#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныйПрограммныйИнтерфейс

// Загружает данные информационной базы.
//
// Параметры:
//	Контейнер - ОбработкаОбъект.ВыгрузкаЗагрузкаДанныхМенеджерКонтейнера - менеджер
//		контейнера, используемый в процессе выгрузи данных. Подробнее см. комментарий
//		к программному интерфейсу обработки ВыгрузкаЗагрузкаДанныхМенеджерКонтейнера.
//	Обработчики - ОбщийМодуль
//				- ОбработкаМенеджер
//	ПолноеИмяПервогоЗагружаемогоОбъектаМетаданных - Строка - полное имя объекта метаданных
//															 с которого необходимо начать загрузку.
// Возвращаемое значение:
//	ОбработкаОбъект.ВыгрузкаЗагрузкаДанныхМенеджерЗагрузкиДанныхИнформационнойБазы
//
Функция ЗагрузитьДанныеИнформационнойБазы(Контейнер, Обработчики, ПолноеИмяПервогоЗагружаемогоОбъектаМетаданных = Неопределено) Экспорт
	
	ЗагружаемыеТипы = Контейнер.ПараметрыЗагрузки().ЗагружаемыеТипы;
	ИсключаемыеТипы = ВыгрузкаЗагрузкаДанныхСлужебныйСобытия.ПолучитьТипыИсключаемыеИзВыгрузкиЗагрузки();
	
	МенеджерЗагрузки = Создать();
	МенеджерЗагрузки.Инициализировать(
		Контейнер,
		ЗагружаемыеТипы,
		ИсключаемыеТипы,
		Обработчики,
		ПолноеИмяПервогоЗагружаемогоОбъектаМетаданных);
	МенеджерЗагрузки.ЗагрузитьДанные();
	
	Возврат МенеджерЗагрузки.ТекущийПотокЗаменыСсылок();
	
КонецФункции

#КонецОбласти

#КонецЕсли
