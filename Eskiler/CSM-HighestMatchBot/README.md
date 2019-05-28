Counter Strike 1.6 Gelişmiş Maç Botu. Kendi sunucum için geliştirdiğim maç botunu paylaşıyorum, internette bu kadar gelişmişini bulmanız zor, hatta imkansız. Maç botunda KFTeleport, özel log tutma, durum, oto pw koyma hatta daha fazlası mevcuttur. Maç botunda hiç hata yoktur bu sayede sorunsuz bir maç keyfi yaşarsınız. Normalde parayla sattığım maç botunu burada sma dosyası ile paylaşıyorum.

## Yönetici Komutları
| Komut                      | Açıklama                                  |
| :----------------------| :--------------------------------------------- |
| menu    | Hızlı Menü          |                                     
| 335     | Maç için geri sayım yapar ve 3-3-5 saniyelik restart atar ve ardından maç başlar. [Maç esnasında yapılan belirli ayarları panel üzerinden kapatıp açabilirsiniz - Oto PW koyma, Duck kapama vs..] | 
| baslat  | Maç için geri sayım yapar ve 3 saniyelik restart atar ardından maç başlar. [Maç esnasında yapılan belirli ayarları panel üzerinden kapatıp açabilirsiniz- Oto PW koyma, Duck kapama vs..]         |     
| bitir	| Maçı bitirir, pub ayarlarını devreye sokar, serverdaki şifreyi kaldırır.  | 
| mac	| Maç ayarlarını yükler. | 
| pub	Public ayarlarını yükler. | 
| kf   | 	Knife Round başlatır. [Genellikle turnuvalarda takım belirleme amaçlı kullanılır.] | 
| kr  | Knife Round başlatır. [Genellikle turnuvalarda takım belirleme amaçlı kullanılır.] | 
| kfteleport  |  Knife Round'ta belirli haritalarda belirli yerlere teleportlanmayı açar/kapar. | 
| tt           |  Taktik ayarlarını yükler.       | 
| nott  |  Taktik ayarlarını kapatır.     | 
| slapt            |  T Takımını tokatlar.[0]           | 
| slapct  |  CT Takımını tokatlar.[0]            | 
| slapall  |  Bütün oyuncuları tokatlar.[0]          | 
| slayt  |  T Takımını öldürür.            | 
| slayct  |  CT Takımını öldürür.             | 
| slayall  |  Bütün oyuncuları öldürür.             | 
| kickt  |  T Takımını oyundan atar.             | 
| kickct  |  CT Takımını oyundan atar.             | 
| kickspec  |  Spec Takımını oyundan atar.                      | 
| kickall  |  Bütün oyuncuları oyundan atar.           | 
| bant  |  T Takımını banlar.          | 
| banct  |  CT Takımını banlar.          |  
| banspec  |  Spec Takımını banlar.        |    
| banall  |  Bütün oyuncuları banlar. | 
| quitt  |  T Takımının oyununu kapatır.|           
| quitct  |  CT Takımının oyununu kapatır. |         
| quitall  |  Bütün oyuncuların oyununu kapatır.|            
| unban      |  Ban Silme menüsünü açar.          |  
| bansil  |  Ban Silme menüsünü açar. | 
| on            |  AmxModx açar. | 
| of  |  AmxModx kapar. | 
| pause  |  Oyunu dondurur. | 
| maps  |  Harita değiştirme menüsünü açar. | 
| restart  |  Oynanılan haritayı yeniden açar.    | 
| pw                  |  Servera şifre koymanızı sağlar. [Örnek : !pw 1234] | 
| nopw            |  Serverdaki şifreyi kaldırır. | 
| hs  |  Sadece kafadan öldürmeyi açar/kapar.                                 | 
| say  |  Say konuşmalarını açar/kapar. | 
| cptsay    |  Kaptan Say konuşmalarını açar/kapar. [CPT tagını alanlar say kapalı olsa bile say üzerinden konuşabilir.] | 
| duck  |  Duck yapmayı açar/kapar. | 
| renklisay  |  Maç botunun say üzerinden yazdığı yazıları renkli/normal yapar.                                   |                                   
| onay  | Ready komutunu açar/kapar. [Serverdaki oyuncu sayısı kadar hazır komutu geldiğinde maç başlar.] | 
| ses  |  Oyun içerisinde olan maç botu seslerini açar/kapar. | 
| hosgeldin  |  Oyuncu servera geldiğinde hoşgeldin mesajını açar/kapar. |  
| paralarigoster    |  Bütün oyuncuların say üzerinden paralarını yazmasını açar/kapar. | 
| ff  |  Dost Ateşi (Friendly Fire) açar/kapar.  | 
| talk  |  Alltalk açar/kapar.  | 
| degis  |  Takımları yer değiştirir. |  
| takim  |  Takım değiştirmeyi kilitler. | 
| sxe  |  Sxe açar. | 
| nosxe  |  Sxe kapar. | 
| sxeop  |  Sxe opsiyonel yapar. | 
| rr         |  1 saniyelik restart atar.       | 
| rr3  |  3 saniyelik restart atar. | 
| rr5  |  5 saniyelik restart atar. | 
| res  |  1 saniyelik restart atar. | 
| res3  |  3 saniyelik restart atar. | 
| res5  |  5 saniyelik restart atar. | 

## Oyuncu Komutları
| Komut                      | Açıklama                                  |
| :----------------------| :--------------------------------------------- |
| ready | Ready komutu uygulanmış ve menü gelmediyse oyuncuda menünün açılmasını sağlar.  | 
| pass  | Serverdaki şifre durumunu söyler. Serverda şifre varsa şifreyi gösterir.  | 
| demo	| Record almayı aktifleştirirsiniz. [ Kullanımı; "say demo deneme", record dosyasını cstrike klasörüne deneme olarak kaydeder] | 
| stop	| Record almayı durdurur.  | 
| para	| Say üzerinden paranızı yazmanızı sağlar.  | 
| skor	| Skoru say üzerinden gösterir.  | 
| durum   | Sunucudaki sXe Injected anti hile durumunu, Dost Ateşi (FF) durumunu  ve sunucudaki alltalk değeri gösterir.  | 
| frag	| skor tablosunu açar ve ss çeker.  | 


## Özellikler
- Yöneticiler için kolay menü.
- Belirli haritalarda KF Round başlatıldığında belli yerlere ışınlanma (de_dust2 || de_inferno).
- KF Round sonunda yapılan oylamayı kaybeden takım görmez.
- Maç başlayınca otomatik şifre koyma(Sma içerisinden değiştirilebilir).
- Maç başladığında birisi düştüğünde otomatik şifreyi kaldırır.
- Server sahibi serverda olmadığı zaman kimin hangi tarihte ve saatte maçı başlatıp durdurduğunu log dosyalarına bakarak görebilir.
- Say yazılarını renkli/renksiz yapma.
- Durum eklentisi.
- Say kapatıp açma (CPT say içindedir).
- Ready (hazır) eklentisi.
- Duck açma/kapama.
- Her tur başı bütün oyuncular say üzerinden parasını otomatik yazar (Açılır/Kapanır).
- Sorunsuz password koyma.
- !335 ve !baslat komutları farklı(Yönetici Komutlarında açıklaması vardır).
- Maç botunun sesini açıp kapatabilirsiniz.
- Yöneticiler quit atabilir (Fixlenip hatalar giderilmiştir).
- 15-15 berabere kalındığında otomatik uzatmalar devreye girer ve 4 tur alan takım otomatik kazanır.
- Maç botunu kendi oyun panelime göre yaptım. Bu yüzden panele girmeniz gereken bazı komutlar var  (Panelle Birleştirme kısmına bakınız.).
- Aklıma gelmeyen başka özelliklerde olabilir.

## Panelle Birleştirme
Şekilli falan olsun diye bir kaç komutu kendi panelime taşıdım, aslında bunları cvar olarak yapabilirdim ama gerek duymadım. Panelinizin maç botu kısmına bu komutları isterseniz girebilirsiniz istersenizde girmeyebilirsiniz bir sorun olmaz;

- Servera "pxecsm_1 1" komutu gönderildiğinde Maç başladığında chat konuşmalarını otomatik kapatmayı açar.
- Servera "pxecsm_1 0" komutu gönderildiğinde Maç başladığında chat konuşmalarını ellemez.
- Servera "pxecsm_2 1" komutu gönderildiğinde Maç başladığında duck engellemeyi otomatik kapatmayı açar.
- Servera "pxecsm_2 0" komutu gönderildiğinde Maç başladığında duck engellemeyi ellemez.
- Servera "pxecsm_3 1" komutu gönderildiğinde Maç başladığında otomatik şifre koymayı açar.
- Servera "pxecsm_3 0" komutu gönderildiğinde Maç başladığında otomatik şifre koymayı ellemez.
- Servera "pxecsm_4 1" komutu gönderildiğinde Maç başladığında otomatik olarak takım değiştirmeyi engeller.
- Servera "pxecsm_4 0" komutu gönderildiğinde Maç başladığında takım değiştirmeyi ellemez.

