////////////////////////////////////////////////////////////////////////////////
// РаботаСФормуламиПереопределяемый содержит процедуры и функции для работы 
// с формулами и обработки действий пользователя с формулами.
//  
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Формирует списки доступных операндов, операторов.
// Возвращает дерево операторов, возможных для ввода в формулах.
//
// Возвращаемое значение:
//  ДеревоЗначение - дерево операторов.
//
Функция ПостроитьДеревоОператоров() Экспорт
	
	Дерево = РаботаСФормуламиВызовСервера.ПолучитьПустоеДеревоОператоров();
	
	ГруппаОператоров = РаботаСФормуламиВызовСервера.ДобавитьГруппуОператоров(Дерево, НСтр("ru = 'Операторы'"));
	РаботаСФормуламиВызовСервера.ДобавитьОператор(Дерево, ГруппаОператоров, "+", " + ");
	РаботаСФормуламиВызовСервера.ДобавитьОператор(Дерево, ГруппаОператоров, "-", " - ");
	РаботаСФормуламиВызовСервера.ДобавитьОператор(Дерево, ГруппаОператоров, "*", " * ");
	РаботаСФормуламиВызовСервера.ДобавитьОператор(Дерево, ГруппаОператоров, "/", " / ");
	
	ГруппаОператоров = РаботаСФормуламиВызовСервера.ДобавитьГруппуОператоров(Дерево, НСтр("ru = 'Логические операторы и константы'"));
	РаботаСФормуламиВызовСервера.ДобавитьОператор(Дерево, ГруппаОператоров, "<", " < ");
	РаботаСФормуламиВызовСервера.ДобавитьОператор(Дерево, ГруппаОператоров, ">", " > ");
	РаботаСФормуламиВызовСервера.ДобавитьОператор(Дерево, ГруппаОператоров, "<=", " <= ");
	РаботаСФормуламиВызовСервера.ДобавитьОператор(Дерево, ГруппаОператоров, ">=", " >= ");
	РаботаСФормуламиВызовСервера.ДобавитьОператор(Дерево, ГруппаОператоров, "=", " = ");
	РаботаСФормуламиВызовСервера.ДобавитьОператор(Дерево, ГруппаОператоров, "<>", " <> ");
	РаботаСФормуламиВызовСервера.ДобавитьОператор(Дерево, ГруппаОператоров, НСтр("ru = 'И'"), " И ");
	РаботаСФормуламиВызовСервера.ДобавитьОператор(Дерево, ГруппаОператоров, НСтр("ru = 'ИЛИ'"), " ИЛИ ");
	РаботаСФормуламиВызовСервера.ДобавитьОператор(Дерево, ГруппаОператоров, НСтр("ru = 'НЕ'"), " НЕ ");
	РаботаСФормуламиВызовСервера.ДобавитьОператор(Дерево, ГруппаОператоров, НСтр("ru = 'ИСТИНА'"), " ИСТИНА ");
	РаботаСФормуламиВызовСервера.ДобавитьОператор(Дерево, ГруппаОператоров, НСтр("ru = 'ЛОЖЬ'"), " ЛОЖЬ ");
	
	ГруппаОператоров = РаботаСФормуламиВызовСервера.ДобавитьГруппуОператоров(Дерево, НСтр("ru = 'Функции'"));
	РаботаСФормуламиВызовСервера.ДобавитьОператор(Дерево, ГруппаОператоров, НСтр("ru = 'Максимум'"), "Макс(,)", 2);
	РаботаСФормуламиВызовСервера.ДобавитьОператор(Дерево, ГруппаОператоров, НСтр("ru = 'Минимум'"), "Мин(,)", 2);
	РаботаСФормуламиВызовСервера.ДобавитьОператор(Дерево, ГруппаОператоров, НСтр("ru = 'Округление'"), "Окр(,)", 2);
	РаботаСФормуламиВызовСервера.ДобавитьОператор(Дерево, ГруппаОператоров, НСтр("ru = 'Целая часть'"), "Цел()", 1);
	РаботаСФормуламиВызовСервера.ДобавитьОператор(Дерево, ГруппаОператоров, НСтр("ru = 'Условие'"), "?(,,)", 3);
	
	Возврат Дерево;
		
КонецФункции // ПостроитьДеревоОператоров()

#КонецОбласти
