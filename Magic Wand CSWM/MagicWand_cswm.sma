/* Yek'-ta */

#include <amxmodx>
#include <reapi>
#include <hamsandwich>
#include <cswm>

#define WAND_NAME "Magic Wand"
#define MINIMUM_DAMAGE 15.0
#define MAXIMUM_DAMAGE 60.0

#define wand_v_model "models/v_wand_cswm.mdl"
#define wand_p_model "models/p_wand_cswm.mdl"
#define wand_w_model "models/w_wand_cswm.mdl"
#define sound "weapon/wand_cswm-1.wav"
#define sound2 "weapon/wand_cswm-2.wav"
#define sound3 "weapon/wand_cswm-3.wav"

#define m_pPlayer 41
new sprite, explose, target, body
new bool:useing[33];
public plugin_init(){
    register_plugin("CSWM Wand", "1.0", "Yek'-ta") //effect SweetMilitary

}
public plugin_precache(){
    sprite = precache_model("sprites/power_spr/laserbeam.spr")
    explose = precache_model("sprites/power_spr/fexplo.spr")
    precache_sound(sound)
    precache_sound(sound2)
    precache_sound(sound3)
    precache_model(wand_v_model)
    precache_model(wand_p_model)
    precache_model(wand_w_model)
    precache_generic( "sprites/weapon_wand_cswm.spr" );
    precache_generic( "sprites/weapon_wand_cswm.txt" );

    new Weapon = CreateWeapon("wand_cswm", Pistol, WAND_NAME);
    new Ammo = CreateAmmo(0, 0, 1);
    SetAmmoName(Ammo, "wandammo");
    BuildWeaponDeploy(Weapon, 7, 1.0);
    BuildWeaponFlags(Weapon, SoloClip);
    BuildWeaponPrimaryAttack(Weapon, 1.0, 15.0, 0.0, 6, 7)
    BuildWeaponModels(Weapon, wand_v_model, wand_p_model, wand_w_model);
    BuildWeaponAmmunition(Weapon, 1, Ammo);
    RegisterWeaponForward(Weapon, WForward_PrimaryAttackPre, "PrimaryAttackPre");
    RegisterWeaponForward(Weapon, WForward_DeployPost, "DeployPost");
    BuildWeaponList(Weapon,"weapon_wand_cswm")


}
public DeployPost(EntityID){
    new id = get_pdata_cbase(EntityID, m_pPlayer);
    play_weapon_anim(id, 3)
}
public PrimaryAttackPre(EntityID){
    new id = get_pdata_cbase(EntityID, m_pPlayer);
    if(useing[id] == false){
        new random = random_num(1,3)
        switch(random)
        {
            case 1:{emit_sound(id, CHAN_AUTO, sound, VOL_NORM, ATTN_NORM, 0, PITCH_NORM);play_weapon_anim(id, 7);}
            case 2:{emit_sound(id, CHAN_AUTO, sound2 , VOL_NORM, ATTN_NORM, 0, PITCH_NORM);play_weapon_anim(id, 6);}
            case 3:{emit_sound(id, CHAN_AUTO, sound3 , VOL_NORM, ATTN_NORM, 0, PITCH_NORM);play_weapon_anim(id, 7);}
        }
        if(get_user_aiming(id, target, body, 9999)) ExecuteHam(Ham_TakeDamage, target, 0, id, random_float(MINIMUM_DAMAGE, MAXIMUM_DAMAGE), 0)
        Maketracer(id)
        useing[id]=true;
        set_task(1.5,"waitbro",id);
    }
}

public waitbro(id){
    useing[id]=false;
}
public Maketracer(id)
    {
    if(!is_user_alive(id))
        return
    if(!is_user_connected(id))
        return
    new vec1[3], vec2[3]
    get_user_origin(id, vec1, 1)
    get_user_origin(id, vec2, 3)
    message_begin(MSG_BROADCAST,SVC_TEMPENTITY)
    write_byte(0)
    write_coord(vec1[0])
    write_coord(vec1[1])
    write_coord(vec1[2])
    write_coord(vec2[0])
    write_coord(vec2[1])
    write_coord(vec2[2])
    write_short(sprite)
    write_byte(1)
    write_byte(5)
    write_byte(2)
    write_byte(20)
    write_byte(13)
    write_byte(0)
    write_byte(255)
    write_byte(0)
    write_byte(200)
    write_byte(150)
    message_end()
    message_begin(MSG_BROADCAST, SVC_TEMPENTITY, vec2);
    write_byte(TE_EXPLOSION);
    write_coord(vec2[0])
    write_coord(vec2[1])
    write_coord(vec2[2])
    write_short(explose);
    write_byte(10);
    write_byte(0);
    write_byte(0);
    message_end();
}


play_weapon_anim(id, numara)
{
    set_entvar(id, var_weaponanim, numara);
    message_begin(MSG_ONE, SVC_WEAPONANIM, {0, 0, 0}, id)
    write_byte(numara)
    write_byte(get_entvar(id, var_body))
    message_end()
}
