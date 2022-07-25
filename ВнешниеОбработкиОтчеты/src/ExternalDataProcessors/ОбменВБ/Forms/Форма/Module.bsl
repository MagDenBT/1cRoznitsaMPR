
&НаКлиенте
Процедура ОтобразитьЗаказыWB(Команда)
	ОтобразитьЗаказыWBНаСервере();
КонецПроцедуры

&НаСервере
Процедура ОтобразитьЗаказыWBНаСервере()
		
  	об = РеквизитФормыВЗначение("Объект");
  	об.ЗаполнитьТаблицуЗаказов();
	ЗначениеВРеквизитФормы(об,"Объект" );
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	ПриОткрытииНаСервере();
КонецПроцедуры

&НаСервере
Процедура ПриОткрытииНаСервере()
	об = РеквизитФормыВЗначение("Объект");
  	об.ВосстановитьНастройкиВМодуле();
  	ЗначениеВРеквизитФормы(Об , "Объект")
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	ПередЗакрытиемНаСервере();
КонецПроцедуры

&НаСервере
Процедура ПередЗакрытиемНаСервере()
		об = РеквизитФормыВЗначение("Объект");
  	об.СохранитьНастройкиВМодуле();
КонецПроцедуры


&НаКлиенте
Процедура ОтобразитьТоварыWB(Команда)
	 ОтобразитьТоварыWBНаСервере()
	
КонецПроцедуры

&НаСервере
Процедура ОтобразитьТоварыWBНаСервере()
	
  	об = РеквизитФормыВЗначение("Объект");
  	об.ЗаполнитьСопоставлениеНоменклатуры();
	ЗначениеВРеквизитФормы(об,"Объект" );
	
КонецПроцедуры


&НаКлиенте
Процедура СвязатьТовары(Команда)
	СвязатьТоварыНаСервере();
КонецПроцедуры

&НаСервере
Процедура СвязатьТоварыНаСервере()
	  	об = РеквизитФормыВЗначение("Объект");
  	об.СвязатьТовары();
	ЗначениеВРеквизитФормы(об,"Объект" );
КонецПроцедуры


