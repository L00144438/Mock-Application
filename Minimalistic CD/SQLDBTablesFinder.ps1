#import-module sqlps -disablenamechecking;

clear
$srv = new-object microsoft.sqlserver.management.smo.server '.';
foreach ($db in $srv.databases.where{$_.Name -eq 'MockDB'} ) {
   foreach ($tbl in $db.tables) {
      #$tbl | select parent, name
        foreach ($column in $tbl.Columns){
            $column | select * #parent, Name
        }      
   }
}