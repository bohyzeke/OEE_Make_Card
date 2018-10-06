## OEE Make_Card
  Make Card je utilitka na jednoduchsie vytvorenie SD karty pre pouzitie Automation pluss. Utilitka kombinuje
   - vytvaranie SD-karty (nakopirovanie potrebnych suborov na kartu)
   - nastavenie dolezitych suborov(config.ini) na karte a
   - umoznuje spustenie diagnostickych programov(ping, FTP, IPAssign, ConnectPlus ) pre overenie spojenia alebo overenie nastavenia jednotlivych ILC zariadeni uz pripojenych na siet.

# Instalacia

 - ConnectPlus musi byt v adresary
      C:\Program Files (x86)\Phoenix Contact\Connect Plus\ConnectPlus.exe
 - IPAssign musi byt v adresary
      @ScriptDir &"\Source\IPAssign.exe"
 - subor CONFIG.XML musi byt v adresary
      @ScriptDir & "\temp\CONFIG.XML"
  
   Z drojove subory musia lezat :

    - @ScriptDir & "\Source\ilc170\*.*"
    - @ScriptDir & "\Source\ilc191\*.*"
    - @ScriptDir & "\Source\ilc191mssql\*.*"
    - @ScriptDir & "\Source\ilc191mysql\*.*"
