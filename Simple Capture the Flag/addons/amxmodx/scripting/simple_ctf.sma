/* Yek'-ta */

#include <amxmodx>
#include <amxmisc>
#include <reapi>
#include <engine>

#define MENU_COMMAND "amx_menu_sctf"
#define MENU_FLAG ADMIN_RCON

// started Simple Capture the Flag plugin.
#define PLUGIN  "Simple Capture the Flag"
#define VERSION "1.7.4"
#define AUTHOR  "Yek'-ta"

#define FLAG_CLASS "YektaG"
#define NEWFLAG_CLASS "NewYektaG"

#define TEAM_TE 1
#define TEAM_CT 2
#define In_Base_Time 1.0

#define TASK_TEFLAG 100
//There should be 100 values difference between the two fields. For no bugs.
#define TASK_CTFLAG 200

#define is_valid_player(%1) (1 <= %1 <= 32)

new BKMODEL[64]
new TAMODEL[64]

enum _:COORDINATE_NAMES
{
    COOR_CTBASE,
    COOR_TEBASE,
    NEW_COOR_CTBASE,
    NEW_COOR_TEBASE
}
enum _:INT_VALUES_NAMES
{
    holdingflag_CT,
    ent_CTFlag,
    ent_CTFlagBase,
    ent_NEW_CTFlag,
    holdingflag_TE,
    ent_TEFlag,
    ent_TEFlagBase,
    ent_NEW_TEFlag,
    modeldosyasi,
    sirtmodeldosyasi
}

enum _:FORW_VALUES_NAMES
{
    for_forw,
    flag_dropped,
    flag_take,
    flag_backtobase,
    scored,
    forw_inTEFlagBase,
    forw_inCTFlagBase
}
enum _:INDIVIDUAL_BOOLS
{
    in_TEFlagBase,
    in_CTFlagBase,
}

new Float:coordinates[COORDINATE_NAMES][3]
new int_values[INT_VALUES_NAMES]
new forw[FORW_VALUES_NAMES]
new bool:individual[INDIVIDUAL_BOOLS][33]

public plugin_init()
{
    register_plugin(PLUGIN, VERSION, AUTHOR)
    register_clcmd(MENU_COMMAND, "SCTF_MENU" , MENU_FLAG)

    //Events
    register_touch(FLAG_CLASS, "player",  "touch_entity");
    register_event( "DeathMsg" , "Death_MSG" , "a" )
    RegisterHookChain(RG_CSGameRules_RestartRound, "RG_RestartRound", true)

    //Forward
    forw[flag_dropped] = CreateMultiForward("sctf_flag_dropped", ET_IGNORE, FP_CELL,FP_CELL)
    forw[flag_take] = CreateMultiForward("sctf_flag_is_takenoff", ET_IGNORE, FP_CELL,FP_CELL)
    forw[flag_backtobase] = CreateMultiForward("sctf_flag_backtobase", ET_IGNORE, FP_CELL,FP_CELL)
    forw[scored] = CreateMultiForward("sctf_flag_scored", ET_IGNORE, FP_CELL,FP_CELL)
    forw[forw_inTEFlagBase] = CreateMultiForward("sctf_player_entered_TEFlagBase", ET_IGNORE, FP_CELL,FP_CELL)
    forw[forw_inCTFlagBase] = CreateMultiForward("sctf_player_entered_CTFlagBase", ET_IGNORE, FP_CELL,FP_CELL)

}

public plugin_precache()
{
    formatex(BKMODEL,charsmax(BKMODEL),"models/sctf/flag2019.mdl");
    formatex(TAMODEL,charsmax(TAMODEL),"models/sctf/playerflag2019.mdl");

    SCTF_Files()

    int_values[modeldosyasi] = precache_model(BKMODEL)
    int_values[sirtmodeldosyasi] = precache_model(TAMODEL)
}
public plugin_cfg(){
    if(coordinates[COOR_TEBASE][0] == 0.0 && coordinates[COOR_TEBASE][1] == 0.0 && coordinates[COOR_TEBASE][2] == 0.0 && coordinates[COOR_CTBASE][0] == 0.0 && coordinates[COOR_CTBASE][1] == 0.0 && coordinates[COOR_CTBASE][2] == 0.0){
        new iFindSpawn = find_ent_by_class(get_member_game(m_nMaxPlayers), "info_player_deathmatch")
        if(iFindSpawn){
            get_entvar(iFindSpawn, var_origin, coordinates[NEW_COOR_TEBASE]);
            while(point_contents(coordinates[NEW_COOR_TEBASE]) == CONTENTS_EMPTY)
                coordinates[NEW_COOR_TEBASE][2] -= 1.0
            coordinates[NEW_COOR_TEBASE][2] += 35.0
        }
        else{
            server_print("[ SCTF ] There is a problem about TESpawnPoints")
            return;
        }
        iFindSpawn = find_ent_by_class(get_member_game(m_nMaxPlayers), "info_player_start")
        if(iFindSpawn){
            get_entvar(iFindSpawn, var_origin, coordinates[NEW_COOR_CTBASE]);
            while(point_contents(coordinates[NEW_COOR_CTBASE]) == CONTENTS_EMPTY)
                coordinates[NEW_COOR_CTBASE][2] -= 1.0
            coordinates[NEW_COOR_CTBASE][2] += 35.0
        }
        else{
            server_print("[ SCTF ] There is a problem about CTSpawnPoints")
            return;
        }
        Write_new_Coordinates();
        server_print("[ SCTF ] Wrote new coordinates for map.")
        SCTF_Files()
    }
    CREATE_ENTITY()
}
/*================================================================================
 [read flag coord]
=================================================================================*/
public SCTF_Files(){
    new cfgdir[32], mapname[32], filepath[100], linedata[128]
    get_configsdir(cfgdir, charsmax(cfgdir))
    new file
    new key[40], value[64]

    formatex(filepath, charsmax(filepath), "%s/sctf_config.ini", cfgdir)

    if (file_exists(filepath))
    {
        file = fopen(filepath, "rt")

        while (file && !feof(file))
        {
            fgets(file, linedata, charsmax(linedata))

            replace(linedata, charsmax(linedata), "^n", "")

            if( linedata[ 0 ] == ';' || linedata[ 0 ] == '/' || !strlen( linedata ) )
                continue;

            if (linedata[0] == '-' && linedata[1] == '-' && linedata[2] == '>'){

                strtok(linedata, key, charsmax(key), value, charsmax(value), '=')
                trim(key)
                trim(value)

                if (equal(key[3], "FLAG MODEL"))
                {
                    formatex(BKMODEL,charsmax(BKMODEL),value);
                    server_print("[ SCTF ] Flag model changed to %s ", value)
                }
                else if (equal(key[3], "PLAYER'S FLAG MODEL"))
                {
                    formatex(TAMODEL,charsmax(TAMODEL),value);
                    server_print("[ SCTF ] Player's Flag model changed to %s ", value)
                }
                else {
                    server_cmd("%s",key[3])
                }
                continue;
            }
        }
        if (file) fclose(file)
    }

    //Flags

    get_mapname(mapname, charsmax(mapname))
    formatex(filepath, charsmax(filepath), "maps/%s.sctf.cfg", mapname)

    if (!file_exists(filepath))
    {
        server_print("[ SCTF ] There is no flag values in %s ", filepath)
        return;
    }

    file = fopen(filepath, "rt")

    while (file && !feof(file))
    {
        fgets(file, linedata, charsmax(linedata))

        replace(linedata, charsmax(linedata), "^n", "")

        if( linedata[ 0 ] == ';' || linedata[ 0 ] == '/' || !strlen( linedata ) )
            continue;

        if (linedata[0] == '-' && linedata[1] == '-' && linedata[2] == '>'){

            strtok(linedata, key, charsmax(key), value, charsmax(value), '=')
            trim(key)
            trim(value)

            if (equal(key[3], "TEX"))
            {
                coordinates[COOR_TEBASE][0] = floatstr(value)
            }
            else if (equal(key[3], "TEY"))
            {
                coordinates[COOR_TEBASE][1] = floatstr(value)
            }
            else if (equal(key[3], "TEZ"))
            {
                coordinates[COOR_TEBASE][2] = floatstr(value)
            }

            else if (equal(key[3], "CTX"))
            {
                coordinates[COOR_CTBASE][0] = floatstr(value)
            }
            else if (equal(key[3], "CTY"))
            {
                coordinates[COOR_CTBASE][1] = floatstr(value)
            }
            else if (equal(key[3], "CTZ"))
            {
                coordinates[COOR_CTBASE][2] = floatstr(value)
            }
            continue;
        }
    }
    if (file) fclose(file)
    server_print("[ SCTF ] read in %s .", filepath)

    coordinates[NEW_COOR_TEBASE][0] = coordinates[COOR_TEBASE][0]
    coordinates[NEW_COOR_TEBASE][1] = coordinates[COOR_TEBASE][1]
    coordinates[NEW_COOR_TEBASE][2] = coordinates[COOR_TEBASE][2]

    coordinates[NEW_COOR_CTBASE][0] = coordinates[COOR_CTBASE][0]
    coordinates[NEW_COOR_CTBASE][1] = coordinates[COOR_CTBASE][1]
    coordinates[NEW_COOR_CTBASE][2] = coordinates[COOR_CTBASE][2]
}
/*================================================================================
 [Native]
=================================================================================*/
public plugin_natives()
{
    register_native("sctf_who_TEflagger", "native_who_TEflagger", 1)
    register_native("sctf_who_CTflagger", "native_who_CTflagger", 1)
    register_native("sctf_ent_TEFlagBase", "native_ent_TEFlagBase", 1)
    register_native("sctf_ent_CTFlagBase", "native_ent_CTFlagBase", 1)
    register_native("sctf_ent_TEFlag", "native_ent_TEFlag", 1)
    register_native("sctf_ent_CTFlag", "native_ent_CTFlag", 1)
    register_native("is_user_inCTFlagBase", "native_is_user_inCTFlagBase", 1)
    register_native("is_user_inTEFlagBase", "native_is_user_inTEFlagBase", 1)
}
public native_who_TEflagger()
{
    return int_values[holdingflag_TE];
}
public native_who_CTflagger()
{
    return int_values[holdingflag_CT];
}
public native_ent_TEFlagBase()
{
    return int_values[ent_TEFlagBase];
}
public native_ent_CTFlagBase()
{
    return int_values[ent_CTFlagBase];
}
public native_ent_TEFlag()
{
    return int_values[ent_TEFlag];
}
public native_ent_CTFlag()
{
    return int_values[ent_CTFlag];
}
public native_is_user_inCTFlagBase(id)
{
    return individual[in_CTFlagBase][id];
}
public native_is_user_inTEFlagBase(id)
{
    return individual[in_TEFlagBase][id];
}
/*================================================================================
 [Events]
=================================================================================*/
public client_disconnected(id){
    if(int_values[holdingflag_TE] == id){
        MOVEBACK_FLAG(int_values[ent_CTFlag])
    }
    else if(int_values[holdingflag_CT] == id){
        MOVEBACK_FLAG(int_values[ent_TEFlag])
    }
}
public Death_MSG(){
    new victim = read_data( 2 );
    if(int_values[holdingflag_CT] == victim){
        new Float:originf[3]
        get_entvar(victim, var_origin, originf);
        entity_set_origin(int_values[ent_TEFlag], originf)
        entity_set_int(int_values[ent_TEFlag],EV_INT_movetype,MOVETYPE_TOSS)
        set_entvar(int_values[ent_TEFlag],var_aiment,-1)
        set_entvar(int_values[ent_TEFlag], var_body, 2)
        set_entvar(int_values[ent_TEFlag], var_gravity, 1.5)
        set_entvar(int_values[ent_TEFlag], var_velocity, {0.0,0.0,-50.0});
        Set_Entity_Model(int_values[ent_TEFlag],1);
        Set_Entity_Anim(int_values[ent_TEFlag], 1,0);
        int_values[holdingflag_CT] = -1;
        ExecuteForward(forw[flag_dropped], forw[for_forw], victim,int_values[ent_TEFlag]);
    }
    else if(int_values[holdingflag_TE] == victim){
        new Float:originf[3]
        get_entvar(victim, var_origin, originf);
        entity_set_origin(int_values[ent_CTFlag], originf)
        entity_set_int(int_values[ent_CTFlag],EV_INT_movetype,MOVETYPE_TOSS)
        set_entvar(int_values[ent_CTFlag],var_aiment,-1)
        set_entvar(int_values[ent_CTFlag], var_body, 1)
        set_entvar(int_values[ent_CTFlag], var_gravity, 1.5)
        set_entvar(int_values[ent_CTFlag], var_velocity, {0.0,0.0,-50.0});
        Set_Entity_Model(int_values[ent_CTFlag],1);
        Set_Entity_Anim(int_values[ent_CTFlag], 1,0);
        int_values[holdingflag_TE] = -1;
        ExecuteForward(forw[flag_dropped], forw[for_forw], victim,int_values[ent_CTFlag]);

    }
}
public RG_RestartRound(){
    MOVEBACK_FLAG(int_values[ent_CTFlag])
    MOVEBACK_FLAG(int_values[ent_TEFlag])
}
public MOVEBACK_FLAG(enti){
    set_entvar(enti,var_aiment,0)
    set_entvar(enti,var_movetype,6)

    new Float:originf[3]
    Set_Entity_Anim(enti, 0,0);
    Set_Entity_Model(enti,1);
    if(enti==int_values[ent_TEFlag]){
        originf = coordinates[COOR_TEBASE]
        originf[2] = originf[2]-30.0
        int_values[holdingflag_CT] = 0
        set_entvar(enti, var_body, 2)
    }
    else {
        originf = coordinates[COOR_CTBASE]
        originf[2] = originf[2]-30.0
        int_values[holdingflag_TE] = 0
        set_entvar(enti, var_body, 1)
    }
    entity_set_origin(enti, originf)

    get_entvar(enti, var_angles, originf);
    originf[0] = 360.0
    originf[2] = 0.0
    set_entvar(enti, var_angles, originf);
}
public touch_entity(enti, id){
    if(!is_entity(enti))
        return

    if(!is_valid_player(id))
        return
    if(!is_user_connected(id))
        return
    if(!is_user_alive(id) || is_user_bot(id))
        return

    if(int_values[ent_TEFlagBase] == enti || int_values[ent_CTFlagBase] == enti){
        if(int_values[ent_TEFlagBase] == enti && int_values[holdingflag_CT] == 0 && get_user_team(id) == TEAM_TE && int_values[holdingflag_TE] == id){
            MOVEBACK_FLAG(int_values[ent_CTFlag])
            ExecuteForward(forw[scored], forw[for_forw], id,enti);
            rg_update_teamscores(0,1,true);
            set_entvar(int_values[ent_TEFlagBase], var_body, 4)
            Set_Entity_Anim(int_values[ent_TEFlagBase], 2,0);
            remove_task(int_values[ent_TEFlagBase]);
            set_task(10.0,"Set_RemoveScored",int_values[ent_TEFlagBase]);
        }
        else if(int_values[ent_CTFlagBase] == enti && int_values[holdingflag_TE] == 0 && get_user_team(id) == TEAM_CT && int_values[holdingflag_CT] == id){
            MOVEBACK_FLAG(int_values[ent_TEFlag])
            ExecuteForward(forw[scored], forw[for_forw], id,enti);
            rg_update_teamscores(1,0,true);
            set_entvar(int_values[ent_CTFlagBase], var_body, 4)
            Set_Entity_Anim(int_values[ent_CTFlagBase], 2,0);
            remove_task(int_values[ent_CTFlagBase]);
            set_task(10.0,"Set_RemoveScored",int_values[ent_CTFlagBase]);
        }
        else if(int_values[ent_TEFlagBase] == enti){
            if(!task_exists(id+TASK_TEFLAG)){
                individual[in_TEFlagBase][id] = true
                ExecuteForward(forw[forw_inTEFlagBase], forw[for_forw], id, enti);
            }
            remove_task(id+TASK_TEFLAG);
            set_task(In_Base_Time,"set_reset_value",id+TASK_TEFLAG)
        }
        else if(int_values[ent_CTFlagBase] == enti){
            if(!task_exists(id+TASK_CTFLAG)){
                individual[in_CTFlagBase][id] = true
                ExecuteForward(forw[forw_inCTFlagBase], forw[for_forw], id, enti);
            }
            remove_task(id+TASK_CTFLAG);
            set_task(In_Base_Time,"set_reset_value",id+TASK_CTFLAG)
        }
    }
    if(int_values[ent_TEFlag] == enti || int_values[ent_CTFlag] == enti){
        if(int_values[ent_TEFlag] == enti && is_valid_player(int_values[holdingflag_CT]))
            return
        if(int_values[ent_CTFlag] == enti && is_valid_player(int_values[holdingflag_TE]))
            return


        new casual_ent[3]
        if(int_values[ent_TEFlag] == enti){
            casual_ent[0] = int_values[ent_TEFlag]
            casual_ent[2] = TEAM_TE
            casual_ent[1] = 0
            //client_print_color(id, id, "^3TE Bayragina dokundun.") // You did touch the TE flag
        }
        else{
            casual_ent[0] = int_values[ent_CTFlag]
            casual_ent[2] = TEAM_CT
            casual_ent[1] = 1
            //client_print_color(id, id, "^3CT Bayragina dokundun.") // You did touch the CT flag
        }


        if(get_user_team(id) == casual_ent[2]){
            if((casual_ent[1] ? int_values[holdingflag_TE] : int_values[holdingflag_CT])  == -1){
                MOVEBACK_FLAG(casual_ent[0])
                ExecuteForward(forw[flag_backtobase], forw[for_forw], id,casual_ent[0]);
                return
            }
        }
        else{
            entity_set_int(casual_ent[0], EV_INT_movetype, MOVETYPE_FOLLOW);
            entity_set_edict(casual_ent[0], EV_ENT_aiment, id);
            Set_Entity_Model(casual_ent[0],0);
            set_entvar(casual_ent[0], var_body, casual_ent[1])
            if(get_user_team(id) == TEAM_TE){
                int_values[holdingflag_TE] = id
            }
            else {
                int_values[holdingflag_CT] = id
            }
            ExecuteForward(forw[flag_take], forw[for_forw], id,casual_ent[0]);

        }
    }
}
/*================================================================================
 [Creating Entity]
=================================================================================*/
public CREATE_ENTITY(){

    int_values[ent_CTFlagBase] = rg_create_entity("info_target")

    entity_set_string(int_values[ent_CTFlagBase],EV_SZ_classname, FLAG_CLASS)
    set_entvar(int_values[ent_CTFlagBase], var_model, BKMODEL);
    set_entvar(int_values[ent_CTFlagBase], var_modelindex, int_values[modeldosyasi]);
    set_entvar(int_values[ent_CTFlagBase], var_angles, Float:{360.0, 0.0, 0.0});
    entity_set_origin(int_values[ent_CTFlagBase], coordinates[COOR_CTBASE])
    entity_set_int(int_values[ent_CTFlagBase],EV_INT_movetype,6)
    entity_set_int(int_values[ent_CTFlagBase],EV_INT_solid,1)
    set_entvar(int_values[ent_CTFlagBase], var_gravity, 1.5)
    entity_set_size(int_values[ent_CTFlagBase],Float:{-25.0,-25.0,-5.0},Float:{25.0,25.0,25.0})
    set_entvar(int_values[ent_CTFlagBase], var_body, 3)
    Set_Entity_Anim(int_values[ent_CTFlagBase], 0,0);
    set_entvar(int_values[ent_CTFlagBase], var_globalname, "CT Flag Base")
//---------------------------------------------------------------
    int_values[ent_TEFlagBase] = rg_create_entity("info_target")

    entity_set_string(int_values[ent_TEFlagBase],EV_SZ_classname, FLAG_CLASS)
    set_entvar(int_values[ent_TEFlagBase], var_model, BKMODEL);
    set_entvar(int_values[ent_TEFlagBase], var_modelindex, int_values[modeldosyasi]);
    set_entvar(int_values[ent_TEFlagBase], var_angles, Float:{360.0, 0.0, 0.0});
    entity_set_origin(int_values[ent_TEFlagBase], coordinates[COOR_TEBASE])
    entity_set_int(int_values[ent_TEFlagBase],EV_INT_movetype,6)
    entity_set_int(int_values[ent_TEFlagBase],EV_INT_solid,1)
    set_entvar(int_values[ent_TEFlagBase], var_gravity, 1.5)
    entity_set_size(int_values[ent_TEFlagBase],Float:{-25.0,-25.0,-5.0},Float:{25.0,25.0,25.0})
    set_entvar(int_values[ent_TEFlagBase], var_body, 3)
    Set_Entity_Anim(int_values[ent_TEFlagBase], 0,0);
    set_entvar(int_values[ent_TEFlagBase], var_globalname, "TE Flag Base")
//---------------------------------------------------------------
    int_values[ent_CTFlag] = rg_create_entity("info_target")

    entity_set_string(int_values[ent_CTFlag],EV_SZ_classname, FLAG_CLASS)
    set_entvar(int_values[ent_CTFlag], var_model, BKMODEL);
    set_entvar(int_values[ent_CTFlag], var_modelindex, int_values[modeldosyasi]);
    set_entvar(int_values[ent_CTFlag], var_angles, Float:{360.0, 0.0, 0.0});
    entity_set_origin(int_values[ent_CTFlag], coordinates[COOR_CTBASE])
    entity_set_int(int_values[ent_CTFlag],EV_INT_movetype,6)
    entity_set_int(int_values[ent_CTFlag],EV_INT_solid,1)
    set_entvar(int_values[ent_CTFlag], var_gravity, 1.5)
    entity_set_size(int_values[ent_CTFlag],Float:{-2.0,-2.0,-2.0},Float:{5.0,5.0,50.0})
    set_entvar(int_values[ent_CTFlag], var_body, 1)
    Set_Entity_Anim(int_values[ent_CTFlag], 0,0);
    set_entvar(int_values[ent_CTFlag], var_globalname, "CT Flag")
    set_entvar(int_values[ent_CTFlag], var_team, 2)
//---------------------------------------------------------------
    int_values[ent_TEFlag] = rg_create_entity("info_target")

    entity_set_string(int_values[ent_TEFlag],EV_SZ_classname, FLAG_CLASS)
    set_entvar(int_values[ent_TEFlag], var_model, BKMODEL);
    set_entvar(int_values[ent_TEFlag], var_modelindex, int_values[modeldosyasi]);
    set_entvar(int_values[ent_TEFlag], var_angles, Float:{360.0, 0.0, 0.0});
    entity_set_origin(int_values[ent_TEFlag], coordinates[COOR_TEBASE])
    entity_set_int(int_values[ent_TEFlag],EV_INT_movetype,6)
    entity_set_int(int_values[ent_TEFlag],EV_INT_solid,1)
    set_entvar(int_values[ent_TEFlag], var_gravity, 1.5)
    entity_set_size(int_values[ent_TEFlag],Float:{-2.0,-2.0,-2.0},Float:{5.0,5.0,50.0})
    set_entvar(int_values[ent_TEFlag], var_body, 2)
    Set_Entity_Anim(int_values[ent_TEFlag], 0,0);
    set_entvar(int_values[ent_TEFlag], var_globalname, "TE Flag")
    set_entvar(int_values[ent_TEFlag], var_team, 1)

    return PLUGIN_HANDLED
}

public CREATE_NEW_FLAG(TEAM){
    if(TEAM == TEAM_CT){
        if(get_entvar(int_values[ent_NEW_CTFlag], var_body) == 1){
            entity_set_origin(int_values[ent_NEW_CTFlag], coordinates[NEW_COOR_CTBASE])
        }
        else{
            int_values[ent_NEW_CTFlag] = rg_create_entity("info_target")

            entity_set_string(int_values[ent_NEW_CTFlag],EV_SZ_classname, NEWFLAG_CLASS)
            set_entvar(int_values[ent_NEW_CTFlag], var_model, BKMODEL);
            set_entvar(int_values[ent_NEW_CTFlag], var_modelindex, int_values[modeldosyasi]);
            set_entvar(int_values[ent_NEW_CTFlag], var_angles, Float:{360.0, 0.0, 0.0});
            entity_set_origin(int_values[ent_NEW_CTFlag], coordinates[NEW_COOR_CTBASE])
            set_entvar(int_values[ent_NEW_CTFlag], var_gravity, 0.5)
            entity_set_size(int_values[ent_NEW_CTFlag],Float:{-25.0,-25.0,-5.0},Float:{25.0,25.0,25.0})
            set_entvar(int_values[ent_NEW_CTFlag], var_body, 1)
            Set_Entity_Anim(int_values[ent_NEW_CTFlag], 2,0);
        }
    }
    else {
        if(get_entvar(int_values[ent_NEW_TEFlag], var_body) == 2){
            entity_set_origin(int_values[ent_NEW_TEFlag], coordinates[NEW_COOR_TEBASE])
        }
        else{
            int_values[ent_NEW_TEFlag] = rg_create_entity("info_target")

            entity_set_string(int_values[ent_NEW_TEFlag],EV_SZ_classname, NEWFLAG_CLASS)
            set_entvar(int_values[ent_NEW_TEFlag], var_model, BKMODEL);
            set_entvar(int_values[ent_NEW_TEFlag], var_modelindex, int_values[modeldosyasi]);
            set_entvar(int_values[ent_NEW_TEFlag], var_angles, Float:{360.0, 0.0, 0.0});
            entity_set_origin(int_values[ent_NEW_TEFlag], coordinates[NEW_COOR_TEBASE])
            set_entvar(int_values[ent_NEW_TEFlag], var_gravity, 0.5)
            entity_set_size(int_values[ent_NEW_TEFlag],Float:{-25.0,-25.0,-5.0},Float:{25.0,25.0,25.0})
            set_entvar(int_values[ent_NEW_TEFlag], var_body, 2)
            Set_Entity_Anim(int_values[ent_NEW_TEFlag], 2,0);
        }
    }
}
/*================================================================================
 [SCTF Menu]
=================================================================================*/
public SCTF_MENU(id, level, cid){
    if( !cmd_access( id, level, cid, 1 ) )
        return PLUGIN_HANDLED;

    new menu, Menuz[512]

    formatex(Menuz, charsmax(Menuz), "\y [ Simple Capture the Flag \dv\r%s \y]^n\wBy:\r %s", VERSION, AUTHOR );

    menu = menu_create(Menuz, "c_SCTF_MENU")

    formatex(Menuz, charsmax(Menuz), "\wNew CT Flag Coordinates^n\w-------------->\y[\r%.0f\y] [\r%.0f\y] [\r%.0f\y]" ,coordinates[NEW_COOR_CTBASE][0],coordinates[NEW_COOR_CTBASE][1],coordinates[NEW_COOR_CTBASE][2]);
    menu_additem(menu, Menuz, "1")
    formatex(Menuz, charsmax(Menuz), "\wNew TE Flag Coordinates^n\w-------------->\y[\r%.0f\y] [\r%.0f\y] [\r%.0f\y]^n^n" ,coordinates[NEW_COOR_TEBASE][0],coordinates[NEW_COOR_TEBASE][1],coordinates[NEW_COOR_TEBASE][2]);
    menu_additem(menu, Menuz, "2")

    formatex(Menuz, charsmax(Menuz), "\wSave" );
    menu_additem(menu, Menuz, "3")

    menu_display(id, menu, 0)

    return PLUGIN_HANDLED
}
public c_SCTF_MENU(iId, menu, item)
{
    if (item == MENU_EXIT)
    {
        menu_destroy(menu)

        return PLUGIN_HANDLED;
    }
    new data[6], iName[64]
    new access, callback
    menu_item_getinfo(menu, item, access, data,5, iName, 63, callback)

    new key = str_to_num(data)

    switch(key)
    {
        case 1:
        {
            new Float:originf[3]
            get_entvar(iId, var_origin, originf);

            coordinates[NEW_COOR_CTBASE][0] = originf[0]
            coordinates[NEW_COOR_CTBASE][1] = originf[1]
            coordinates[NEW_COOR_CTBASE][2] = originf[2]

            CREATE_NEW_FLAG(TEAM_CT)

            client_cmd(iId,MENU_COMMAND)
        }
        case 2:
        {
            new Float:originf[3]
            get_entvar(iId, var_origin, originf);

            coordinates[NEW_COOR_TEBASE][0] = originf[0]
            coordinates[NEW_COOR_TEBASE][1] = originf[1]
            coordinates[NEW_COOR_TEBASE][2] = originf[2]

            CREATE_NEW_FLAG(TEAM_TE)

            client_cmd(iId,MENU_COMMAND)
        }

        case 3:
        {
            Write_new_Coordinates();
            client_print_color(iId, iId, "Saved...")
        }
    }
    return PLUGIN_HANDLED;

}
/*================================================================================
 [Fast commands]
=================================================================================*/
public set_reset_value(id){
    if(id < TASK_TEFLAG+50){
        individual[in_TEFlagBase][id-TASK_TEFLAG] = false
    }
    else{
        individual[in_CTFlagBase][id-TASK_CTFLAG] = false
    }
}
public Set_Entity_Model(enti,deger){
    if(deger==1){
        set_entvar(enti, var_model, BKMODEL);
        set_entvar(enti, var_modelindex, int_values[modeldosyasi]);
    }
    else{
        set_entvar(enti, var_model, TAMODEL);
        set_entvar(enti, var_modelindex, int_values[sirtmodeldosyasi]);
    }
}
public Set_RemoveScored(enti){
    set_entvar(enti, var_body, 3)
    Set_Entity_Anim(enti, 0,0);
}
stock Set_Entity_Anim(ent, Anim, ResetFrame)
{
    if(!is_entity(ent))
        return

    set_entvar(ent, var_animtime, get_gametime())
    set_entvar(ent, var_framerate, 1.0)
    set_entvar(ent, var_sequence, Anim)
    if(ResetFrame) set_entvar(ent, var_frame, 0.0)
}

public Write_new_Coordinates(){
    new mapname[32], filepath[100]
    get_mapname(mapname, charsmax(mapname))
    formatex(filepath, charsmax(filepath), "maps/%s.sctf.cfg", mapname)

    if (file_exists(filepath))
        delete_file(filepath)

    new szBuffer[150]

    formatex(szBuffer, charsmax(szBuffer), "-->TEX = %.0f^n-->TEY = %.0f^n-->TEZ = %.0f^n-->CTX = %.0f^n-->CTY = %.0f^n-->CTZ = %.0f^n",coordinates[NEW_COOR_TEBASE][0],coordinates[NEW_COOR_TEBASE][1],coordinates[NEW_COOR_TEBASE][2],coordinates[NEW_COOR_CTBASE][0],coordinates[NEW_COOR_CTBASE][1],coordinates[NEW_COOR_CTBASE][2])
    write_file(filepath,szBuffer)
}
