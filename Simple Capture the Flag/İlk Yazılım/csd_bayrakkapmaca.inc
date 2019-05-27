/*
forum.csduragi.com
Yek'-ta
*/

#if defined _csd_bayrakkapmaca_included
    #endinput
#endif
#define _csd_bayrakkapmaca_included


#define BAYRAK_YERDE -1
#define BAYRAK_ALANDA 0

/**
 * TE Takımında taşıyıcı var ise onun numarasını verir.
 *
 * Örnek; if(csd_tebayrak_tasiyici(oyuncu) == BaskaBirOyuncu)
 * Örnek; if(csd_tebayrak_tasiyici(oyuncu) == 0) // Bayrak alanda mı?
 * Örnek; if(csd_tebayrak_tasiyici(oyuncu) == -1) // Bayrak yere mi düştü?
 *
 * @return      Oyuncu degeri.
 */
 native csd_tebayrak_tasiyici()


/**
 * CT Takımında taşıyıcı var ise onun numarasını verir.
 *
 * Örnek; if(csd_tebayrak_tasiyici(oyuncu) == BaskaBirOyuncu)
 * Örnek; if(csd_tebayrak_tasiyici(oyuncu) == BAYRAK_ALANDA) // Bayrak alanda mı?
 * Örnek; if(csd_tebayrak_tasiyici(oyuncu) == BAYRAK_YERDE) // Bayrak yere mi düştü?
 *
 * @return      Oyuncu degeri.
 */
 native csd_ctbayrak_tasiyici()


/**
 * Oyuncunun TE Alanında mı değil mi sorgusunun cevabını verir
 *
 * Örnek; if(csd_tealanindami(oyuncu))
 *
 * @return      oyuncu eğer içinde ise true verir.
 */
 native csd_tealanindami(oyuncu)


/**
 * Oyuncunun CT Alanında mı değil mi sorgusunun cevabını verir
 *
 * Örnek; if(csd_ctalanindami(oyuncu))
 *
 * @return      oyuncu eğer içinde ise true verir.
 */
 native csd_ctalanindami(oyuncu)

/**
 * TE Alaninin obje degerini verir.
 *
 *
 * @return      TEAlan Değeri
 */
 native csd_obje_tealan()

/**
 * CT Alaninin obje degerini verir.
 *
 *
 * @return      CTAlan Değeri
 */
 native csd_obje_ctalan()

/**
 * TE Bayraginin obje degerini verir.
 *
 *
 * @return      TEBayrak Değeri
 */
 native csd_obje_tebayrak()

/**
 * CT Bayraginin obje degerini verir.
 *
 *
 * @return      CTBayrak Değeri
 */
 native csd_obje_ctbayrak()



/**
 * CT alanına biri girdiği vakit çalışan public
 *
 * @param oyuncu        CT alanına giren oyuncunun numarası.
 */
forward csd_ctalaninagirdi(oyuncu, obje)


/**
 * TE alanına biri girdiği vakit çalışan public
 *
 * @param oyuncu        TE alanına giren oyuncunun numarası.
 */
forward csd_tealaninagirdi(oyuncu, obje)


/**
 * Bayrak yere düştüğü an çalışan public.
 *
 * @param oyuncu        Bayrağı düşüren oyuncunun numarası.
 */
forward csd_bayrak_dustu(oyuncu, obje)


/**
 * Rakip takımın bayrağı yerden alındığı an çalışan public.
 *
 * @param oyuncu        Bayrağı yerden alan oyuncunun numarası.
 */
forward csd_bayrak_alindi(oyuncu, obje)


/**
 * Kendi takımının bayrağını yerden alıp alana gönderdiğinde çalışan public.
 *
 * @param oyuncu        Bayrağı geri taşıyan oyuncunun numarası.
 */
forward csd_bayrak_geri_tasindi(oyuncu, obje)


/**
 * Bir takım +1 skor aldığında çalışan public.
 *
 * @param oyuncu        +1 Skor sağlayan oyuncunun numarası.
 */
forward csd_bayrak_skorlandi(oyuncu, obje)
