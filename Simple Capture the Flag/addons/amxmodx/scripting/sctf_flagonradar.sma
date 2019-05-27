#include <amxmodx>
#include <engine>
#include <simple_ctf>

new gMsg_HostagePos, gMsg_HostageK
public plugin_init()
{
    register_plugin("Flag on Radar", "1.0", "Yek'-ta")
    gMsg_HostagePos = get_user_msgid("HostagePos")
    gMsg_HostageK = get_user_msgid("HostageK")

    register_message(gMsg_HostageK, "msg_block")
    register_message(gMsg_HostagePos, "msg_block")

    set_task(10.0,"yonlendir")
}
public yonlendir(){
    new iOrigin[3]

    new Float:fOrigin[3]
    for(new oyuncu = 1; oyuncu <= 32; oyuncu++){
        if(is_user_connected(oyuncu) && is_user_alive(oyuncu)){
            if(get_user_team(oyuncu) == 1){
                entity_get_vector(sctf_ent_TEFlag(), EV_VEC_origin, fOrigin)
                FVecIVec(fOrigin, iOrigin)
                FVecIVec(fOrigin, iOrigin)

                message_begin(MSG_ONE_UNRELIABLE, gMsg_HostagePos,.player=oyuncu)
                write_byte(oyuncu)
                write_byte(2)
                write_coord(iOrigin[0])
                write_coord(iOrigin[1])
                write_coord(iOrigin[2])
                message_end()

                message_begin(MSG_ONE_UNRELIABLE, gMsg_HostageK,.player=oyuncu)
                write_byte(2)
                message_end()
            }
            else if(get_user_team(oyuncu) == 2){
                entity_get_vector(sctf_ent_CTFlag(), EV_VEC_origin, fOrigin)
                FVecIVec(fOrigin, iOrigin)
                FVecIVec(fOrigin, iOrigin)

                message_begin(MSG_ONE_UNRELIABLE, gMsg_HostagePos,.player=oyuncu)
                write_byte(oyuncu)
                write_byte(1)
                write_coord(iOrigin[0])
                write_coord(iOrigin[1])
                write_coord(iOrigin[2])
                message_end()

                message_begin(MSG_ONE_UNRELIABLE, gMsg_HostageK,.player=oyuncu)
                write_byte(1)
                message_end()
            }
        }
    }
    set_task(2.0,"yonlendir")
}


public msg_block()
    return PLUGIN_HANDLED
