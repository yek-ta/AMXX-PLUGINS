
#include <amxmodx>
#include <fakemeta>
#include <simple_ctf>

new spritedosyasi

public plugin_init()
{
    register_plugin("SCTF Firework Effect", "1.0", "Yek'-ta")
}

public plugin_precache() {
    spritedosyasi = precache_model("sprites/fireworks.spr")
    precache_sound("simple_ctf/fireworks.wav")
}

public sctf_flag_scored(player,ent){
    new Float: originF[3]
    pev(ent, pev_origin, originF)

    message_begin(MSG_BROADCAST, SVC_TEMPENTITY);
    write_byte(TE_SPRITE);
    engfunc(EngFunc_WriteCoord, originF[0]+random_float(-5.0, 5.0));
    engfunc(EngFunc_WriteCoord, originF[1]+random_float(-5.0, 5.0));
    engfunc(EngFunc_WriteCoord, originF[2]+200.0);
    write_short(spritedosyasi);
    write_byte(15);
    write_byte(200);
    message_end();
    emit_sound(ent, CHAN_WEAPON, "simple_ctf/fireworks.wav", 1.0, ATTN_NORM, 0, PITCH_NORM)
}
