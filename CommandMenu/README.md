# Açıklama : 
- Her yetkilinin tek tek yüklemesi gereken commandmenu dosyası yerine yazılmıştır. CFGLER klasörü içerisine CommandMenu de olan komutlar CFG uzantılı bir şekilde yüklenir. Daha sonra Tanimlandirma.ini içerisine CFG dosyasının ismi yazılır. Oyun içerisinde ADMIN_BAN yetkisine sahip olan kişiler konsola amx_cmenu yazarak Tanimlandirma.ini dosyasına erişir ve orada yazan CFG dosyalarını seçerek kullanır.
- CSM PubBot eklentisi kullanıyorsanız say'den cmenu yazarakta menüye giriş yapabilirsiniz.
- CFG dosyalarının içini değiştirdiğinizde oyundan çekilende anlık değişir. Ama Tanimlandirma.ini içerisinde yaptığınız değişikliklerin geçerli olması için haritanın değişmesi gerekmektedir.
- Tanimlandirma.ini içerisinde yazılan CFG dosyalarının başına ; koyarsanız o CFG dosyası menüde gösterilmez.
- Menü içerisindeki CFG sırası Tanimlandirma.ini dosyasına yazdığınız sıra ile aynıdır.
- Örnek olması açısında içerisinde tanımlandırdığım CFG dosyaları vardır. Burada dikkatinizi çekmek istediğim nokta komutlardan önce veya sonra wait;wait; eklemem. Bunun sebebi, göndermiş olduğunuz komut makine hızında gider, yani işleme hızı yüksektir ve bu wait; komutları olmaz ise flood(serverı yazı ile doldurmayın) hatası alırsınız. (temel bilgi olması açısından, sadece sunucuya gönderdiğiniz komutlar için geçerlidir.)

# Komutlar :
- amx_cmenu
