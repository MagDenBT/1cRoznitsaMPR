&НаКлиенте
Процедура ЗаполнитьGUID(Команда)
	
	Объект.GUID = GUID(Объект.Ссылка);
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция GUID(Ссылка)
	
	Возврат Ссылка.УникальныйИдентификатор();

КонецФункции