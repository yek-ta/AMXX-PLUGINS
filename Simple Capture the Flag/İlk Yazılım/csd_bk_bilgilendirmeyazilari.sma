#include <amxmodx>
#include <csd_bayrakkapmaca>

new isim[32]

public plugin_init()
{
    register_plugin("Bayrak Kapmaca Yazilari", "1.0", "Yek'-ta")
    set_task(15.0,"bayrakkapmacahosgeldiniz")
}
public bayrakkapmacahosgeldiniz(){
    client_cmd(0, "play ^"csd_bayrakkapmaca/bayrakkapmacayahosgeldiniz^"")
}
public csd_bayrak_dustu(oyuncu,obje){
    if(get_user_team(oyuncu) == 1){
        set_hudmessage( 0, 50, 160, -1.0, 0.25, 1, 6.0, 3.0, 0.1, 3.0 );
        show_hudmessage(0, "%s CT Bayragini Dusurdu..",isimogren(oyuncu))
    }
    else {
        set_hudmessage( 160, 50, 0, -1.0, 0.25, 1, 6.0, 3.0, 0.1, 3.0 );
        show_hudmessage(0, "%s TE Bayragini Dusurdu..",isimogren(oyuncu))
    }
}
public csd_bayrak_alindi(oyuncu,obje){
    if(get_user_team(oyuncu) == 1){
        set_hudmessage( 160, 50, 0, -1.0, 0.25, 1, 6.0, 3.0, 0.1, 3.0 );
        show_hudmessage(0, "%s CT Bayragini Sirtladi..",isimogren(oyuncu))
    }
    else {
        set_hudmessage( 0, 50, 160, -1.0, 0.25, 1, 6.0, 3.0, 0.1, 3.0 );
        show_hudmessage(0, "%s TE Bayragini Sirtladi..",isimogren(oyuncu))
    }
}
public csd_bayrak_geri_tasindi(oyuncu,obje){
    if(get_user_team(oyuncu) == 1){
        set_hudmessage( 160, 50, 0, -1.0, 0.25, 1, 6.0, 3.0, 0.1, 3.0 );
        show_hudmessage(0, "%s Takiminin Bayragini Geri Tasidi.",isimogren(oyuncu))
    }
    else {
        set_hudmessage( 0, 50, 160, -1.0, 0.25, 1, 6.0, 3.0, 0.1, 3.0 );
        show_hudmessage(0, "%s Takiminin Bayragini Geri Tasidi.",isimogren(oyuncu))
    }
}
public csd_bayrak_skorlandi(oyuncu,obje){
    if(get_user_team(oyuncu) == 1){
        set_hudmessage( 160, 50, 0, -1.0, 0.25, 1, 6.0, 3.0, 0.1, 3.0 );
        show_hudmessage(0, "%s Takimina +1 Skor Kazandirdi.",isimogren(oyuncu))
    }
    else {
        set_hudmessage( 0, 50, 160, -1.0, 0.25, 1, 6.0, 3.0, 0.1, 3.0 );
        show_hudmessage(0, "%s Takimina +1 Skor Kazandirdi.",isimogren(oyuncu))
    }
    sesver(oyuncu);
}
public sesver(takim){
    if(get_user_team(takim) == 1){
        client_cmd(0, "play ^"csd_bayrakkapmaca/kirmizitakimskorladi^"")
    }
    else{
        client_cmd(0, "play ^"csd_bayrakkapmaca/mavitakimskorladi^"")
    }
}
public isimogren(oyuncu){
    get_user_name(oyuncu, isim, 31)
    return isim;
}
public plugin_precache()
{
    precache_sound("csd_bayrakkapmaca/kirmizitakimskorladi.wav")
    precache_sound("csd_bayrakkapmaca/bayrakkapmacayahosgeldiniz.wav")
    precache_sound("csd_bayrakkapmaca/mavitakimskorladi.wav")
}
