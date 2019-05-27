#include <amxmodx>
#include <reapi>

#define MesajTipi1 0
#define UyariMesajiKirmizi 1
#define UyariMesajiMavi 2
#define MesajTipi2 5 //Zafer Sesli


public plugin_init(){
    register_plugin( "Skor Sifirlama", "1.1", "Yek'-ta" );

    register_clcmd("say /reset", "skorsifirla")
    register_clcmd("say !reset", "skorsifirla")
    register_clcmd("say .reset", "skorsifirla")
    register_clcmd("say /rs", "skorsifirla")
    register_clcmd("say !rs", "skorsifirla")
    register_clcmd("say .rs", "skorsifirla")

    register_clcmd("say_team /reset", "skorsifirla")
    register_clcmd("say_team !reset", "skorsifirla")
    register_clcmd("say_team .reset", "skorsifirla")
    register_clcmd("say_team /rs", "skorsifirla")
    register_clcmd("say_team !rs", "skorsifirla")
    register_clcmd("say_team .rs", "skorsifirla")
}
public skorsifirla(id){
    set_entvar(id, var_frags, 0.0);
    set_member(id, m_iDeaths, 0);
    tutor_mesaj_olustur(id, "Skorunuzu Sifirladiniz^nIyi Fraglar", MesajTipi1, true, 3)
    //id kişi demek
    //Mesaj tipleri define lar şeklinde yukarıda yazıyor.
    //true olarak gösterdiğim evet hayır olayı ses çıksın mı çıkmasın mı sorusu, false yazılırsa oyunda ses çıkmaz.
    //Buradaki 3 te kaç saniye ekranda kalacağı.

    //Fragların hemen işlenmesi için aşağıdakiler yazılmıştır.
    message_begin(MSG_ALL, 85);
    write_byte(id);
    write_short(0); write_short(0); write_short(0); write_short(0);
    message_end();


    return PLUGIN_HANDLED; //reset yazdığı çıkmasın diye.
}
public plugin_precache() {
    precache_sound( "events/enemy_died.wav" );
    precache_sound( "events/friend_died.wav" );
    precache_sound( "events/task_complete.wav" );
    precache_sound( "events/tutor_msg.wav" );

    precache_generic( "resource/TutorScheme.res" );
    precache_generic( "resource/UI/TutorTextWindow.res" );

    precache_generic( "gfx/career/icon_!.tga" );
    precache_generic( "gfx/career/icon_!-bigger.tga" );
    precache_generic( "gfx/career/icon_i.tga" );
    precache_generic( "gfx/career/icon_i-bigger.tga" );
    precache_generic( "gfx/career/icon_skulls.tga" );
    precache_generic( "gfx/career/round_corner_ne.tga" );
    precache_generic( "gfx/career/round_corner_nw.tga" );
    precache_generic( "gfx/career/round_corner_se.tga" );
    precache_generic( "gfx/career/round_corner_sw.tga" );
}





stock tutor_mesaj_olustur(id, mesaj[], stil, bool:ses, sure){

    if (ses){
        switch(stil){
            case 1: emit_sound(id, CHAN_ITEM, "events/friend_died.wav", VOL_NORM, ATTN_NORM, 0, PITCH_HIGH)
            case 2: emit_sound(id, CHAN_ITEM, "events/enemy_died.wav", VOL_NORM, ATTN_NORM, 0, PITCH_LOW)
            case 5: emit_sound(id, CHAN_ITEM, "events/task_complete.wav", VOL_NORM, ATTN_NORM, 0, PITCH_NORM)
            default: emit_sound(id, CHAN_ITEM, "events/tutor_msg.wav", VOL_NORM, ATTN_NORM, 0, PITCH_NORM)
        }
    }

    message_begin(MSG_ONE_UNRELIABLE , get_user_msgid("TutorClose"), {0, 0, 0}, id)
    message_end()

    message_begin(MSG_ONE_UNRELIABLE , get_user_msgid("TutorText"), {0, 0, 0}, id)
    write_string(mesaj)
    write_byte(0)
    write_short(0)
    write_short(0)
    write_short(1<<stil)
    message_end()

    remove_task(id)
    set_task(sure+0.0, "tutorkaldir", id)

}

public tutorkaldir(id){
    if( is_user_connected( id ) ) {
        message_begin(MSG_ONE_UNRELIABLE , get_user_msgid("TutorClose"), {0, 0, 0}, id)
        message_end()
    }
}



