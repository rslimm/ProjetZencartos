import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:zencartos/sqlite/Payement.dart';
import 'package:zencartos/sqlite/contribuable.dart';
import 'package:intl/intl.dart' show DateFormat;

final format2 = DateFormat("yyyy-MM-dd ");
class TestPrint {
  BlueThermalPrinter bluetooth = BlueThermalPrinter.instance;

   Future<int> sample(String pathImage,Contribuable contribuable,Payement payement) async {
    //SIZE
    // 0- normal size text
    // 1- only bold text
    // 2- bold with medium text
    // 3- bold with large text
    //ALIGN
    // 0- ESC_ALIGN_LEFT
    // 1- ESC_ALIGN_CENTER
    // 2- ESC_ALIGN_RIGHT
    int  result=0;
    bool connection= await bluetooth.isConnected;
     if (connection) {
        double total=payement.montant;
        bluetooth.printNewLine();
        bluetooth.printCustom("ZENCARTOS",3,1);
        bluetooth.printNewLine();
        bluetooth.printImage(pathImage);   //path of your image/logo
        bluetooth.printNewLine();
      bluetooth.printLeftRight("DATE", "${format2.format(payement.datePaye)}", 0);
        bluetooth.printLeftRight("Name", "${contribuable.name}", 0);
         bluetooth.printLeftRight("SIGLE", "${contribuable.sigle}", 0);
          bluetooth.printLeftRight("NUI", "${contribuable.niu}", 0);
             bluetooth.printLeftRight("ACTIVIT", "${contribuable.activite}", 0);
       /* bluetooth.printLeftRight("LEFT", "RIGHT",0);
        bluetooth.printLeftRight("LEFT", "RIGHT",1);
        bluetooth.printNewLine();
        bluetooth.printLeftRight("LEFT", "RIGHT",2);
        bluetooth.printLeftRight("LEFT", "RIGHT",3);
        bluetooth.printLeftRight("LEFT", "RIGHT",4);
        bluetooth.printCustom("Body left",1,0);
        bluetooth.printCustom("Body right",0,2);
        bluetooth.printNewLine();
        bluetooth.printCustom("Thank You",2,1);
        bluetooth.printNewLine();*/
        
          bluetooth.printLeftRight("MONTANT", "$total", 0);
             bluetooth.printNewLine();
   
        bluetooth.printQRcode("Insert Your Own Text to Generate", 200, 200, 1);
      
      
        bluetooth.printNewLine();
        bluetooth.printCustom("AMH CONSULTING",0,1);
          bluetooth.printNewLine();
          bluetooth.printNewLine();
           bluetooth.printNewLine();
          bluetooth.printNewLine();
       

        bluetooth.paperCut();
        result=1;
        
      }

   return result;
  }
}