# Açıklama

CSDurağı dışında bir sunucuda oyunculara sunuculara girdiklerinde sunucu oyuncuların rate ayarlarını kendilerine göre değiştiriyordu. Hâli ile o sunucudan CSDurağı sunucularına giren oyuncularda ping değişikliği, mermilerin gidişatında bozulma olabiliyordu. Hem bu bozulmanın tespiti için, hemde farklı rate ayarlarını hızlı bir şekilde denemek isteyenler için bir eklenti yazdım.
<br>
Oyuncu sunucuya girdikten 11 saniye sonra, eklenti sunucuya bağlanan oyuncunun rate ayarlarını kontrol ediyor. 14 saniye sonra eklenti, oyuna bağlanan oyuncunun rate ayarları bozuldu ise non-steam/steam fark etmeksizin tespit edip uyarıyor ve otomatik olarak rate menüsünü açıyor.
Olay burada ikiye bölünüyor. Steam olan oyuncularda rate ayarlarının kontrolü çok basit bir şekilde yapıldığı için o oyuncuların rate ayarları eklenti hafızasında tutulabiliyor. Fakat Non-Steam olan oyuncuların rate kontrolü sadece setinfo üzerinden yapıldığı için önemli olan rate kodları öğrenilemiyor. 
Açılan menü ise bu iki ayrıma göre şekilleniyor. Eğer oyuncu Steam ise sunucuya bağlandığı rate ayarları menüde kayıtlı bir şekilde duruyor, rate ayarlarını beğenmez ise geri alabiliyor. Fakat Non-Steam oyuncu menü üzerinden eski ayarlarını hızlı bir şekilde geri alamıyor. Sadece menüde eski ayarlarının bir kısmı yazıyor.

# Komutlar
- say .rate
- say !rate
- say /rate

# 2.5
Tabii daha sonra bu eklentiyi daha da temize çektim ve 2.5 sürümünü çıkarttım. Bu 2.5 sürümünde Türkçe ile birlikte İngilizce de txt ile desteklenebilir halde ve geriye dönük AmxModx 1.8.2 uyumu da mevcuttur. 1.7 'ye göre daha stabil midir onu bilemem ama en temiz hali 2.5'tir. Ve farklı sunucuların oyuncuların rate ayarlarını bozmasını algılamıyor. 2.5 i daha çok yabancı platformlarda paylaşmak için yazmıştım. 2.5 Sürümü 2018 11 Şubatta yazılmıştır.
