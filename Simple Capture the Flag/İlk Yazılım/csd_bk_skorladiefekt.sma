
#include <amxmodx>
#include <fakemeta>
#include <csd_bayrakkapmaca>

new spritedosyasi

public plugin_init()
{
    register_plugin("Skorlandi Efekt", "1.0", "Yek'-ta")
}

public plugin_precache() {
    spritedosyasi = precache_model("sprites/fireworks.spr")
    //precache_sound("csd_bayrakkapmaca/havaifisekefektsesi.wav")
}

public csd_bayrak_skorlandi(oyuncu,obje){
    new Float: originF[3]
    pev(obje, pev_origin, originF)

    message_begin(MSG_BROADCAST, SVC_TEMPENTITY);
    write_byte(TE_SPRITE);
    engfunc(EngFunc_WriteCoord, originF[0]+random_float(-5.0, 5.0));
    engfunc(EngFunc_WriteCoord, originF[1]+random_float(-5.0, 5.0));
    engfunc(EngFunc_WriteCoord, originF[2]+200.0);
    write_short(spritedosyasi);
    write_byte(15);
    write_byte(200);
    message_end();
    //emit_sound(obje, CHAN_WEAPON, "csd_bayrakkapmaca/havaifisekefektsesi.wav", 1.0, ATTN_NORM, 0, PITCH_NORM)
}
