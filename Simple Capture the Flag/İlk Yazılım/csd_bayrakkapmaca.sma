/* Yek'-ta */

#include <amxmodx>
#include <amxmisc>
#include <reapi>
#include <engine>

#define PLUGIN  "Bayrak Kapmaca"
#define VERSION "1.7"
#define AUTHOR  "Yek'-ta"
#define MENUKOMUTU "csd_bayrakkapmaca"


#define SINIF "Yekta"
#define YENI_SINIF "haritaninyenibayraklari"

#define TETAKIMI 1
#define CTTAKIMI 2
#define AlanIcerisindeKalinanSure 1.0

#define AlanTESureKoy 100
//İki alan arasında 100 değer fark olmalıdır.
#define AlanCTSureKoy 200

#define is_valid_player(%1) (1 <= %1 <= 32)

new BKMODEL[64]
new TAMODEL[64]

enum _:KOORDINATISIMLERI
{
    YER_CTALAN,
    YER_TEALAN,
    YER_YENI_CTALAN,
    YER_YENI_TEALAN
}
enum _:TEKLIDEGISKENLER
{
    tasiyici_CT,
    obje_CTBayrak,
    obje_CTAlan,
    obje_YENI_CTBayrak,
    tasiyici_TE,
    obje_TEBayrak,
    obje_TEAlan,
    obje_YENI_TEBayrak,
    modeldosyasi,
    sirtmodeldosyasi
}

enum _:FORWDEGISKENLERI
{
    donusdegeri,
    bayrakdustu,
    bayrakalindi,
    bayrakgeritasindi,
    skorlandi,
    tebayrakalaninagirdi,
    ctbayrakalaninagirdi
}
enum _:BIREYSELDEGISKENLER
{
    tealaniicerisinde,
    ctalaniicerisinde,
}

new Float:koordinatlar[KOORDINATISIMLERI][3]
new degiskenler[TEKLIDEGISKENLER]
new forw[FORWDEGISKENLERI]
new bool:bireysel[BIREYSELDEGISKENLER][33]

public plugin_init()
{
    register_plugin(PLUGIN, VERSION, AUTHOR)
    register_clcmd(MENUKOMUTU, "BayrakKapmacaMenu" , ADMIN_RCON)

    //Olaylar
    register_touch(SINIF, "player",  "OBJEDOKUNMASI");
    register_event( "DeathMsg" , "olunce" , "a" )
    RegisterHookChain(RG_CSGameRules_RestartRound, "RestartAtildi", true)

    //Forward
    forw[bayrakdustu] = CreateMultiForward("csd_bayrak_dustu", ET_IGNORE, FP_CELL,FP_CELL)
    forw[bayrakalindi] = CreateMultiForward("csd_bayrak_alindi", ET_IGNORE, FP_CELL,FP_CELL)
    forw[bayrakgeritasindi] = CreateMultiForward("csd_bayrak_geri_tasindi", ET_IGNORE, FP_CELL,FP_CELL)
    forw[skorlandi] = CreateMultiForward("csd_bayrak_skorlandi", ET_IGNORE, FP_CELL,FP_CELL)
    forw[tebayrakalaninagirdi] = CreateMultiForward("csd_tealaninagirdi", ET_IGNORE, FP_CELL,FP_CELL)
    forw[ctbayrakalaninagirdi] = CreateMultiForward("csd_ctalaninagirdi", ET_IGNORE, FP_CELL,FP_CELL)

}

public plugin_precache()
{
    formatex(BKMODEL,charsmax(BKMODEL),"models/csd_bk/csd_bayrak2019.mdl");
    formatex(TAMODEL,charsmax(TAMODEL),"models/csd_bk/csd_tasinanbayrak.mdl");


    BayrakKoordinatlariniAl()

    degiskenler[modeldosyasi] = precache_model(BKMODEL)
    degiskenler[sirtmodeldosyasi] = precache_model(TAMODEL)


    OBJELERIOLUSTUR() //Objeleri Oluştur

}

/*================================================================================
 [Bayrak Koordinatlarını Okuma]
=================================================================================*/
public BayrakKoordinatlariniAl(){
    new cfgdir[32], mapname[32], filepath[100], linedata[64]
    get_configsdir(cfgdir, charsmax(cfgdir))
    new file
    new key[40], value[64]

    formatex(filepath, charsmax(filepath), "%s/csd_bayrakkapmaca.ini", cfgdir)

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

                if (equal(key[3], "BAYRAK MODELI"))
                {
                    formatex(BKMODEL,charsmax(BKMODEL),value);
                    server_print("[ CSDuragi ] Bayrak Modeli %s olarak degistirildi.", value)
                }
                else if (equal(key[3], "BAYRAK SIRT MODELI"))
                {
                    formatex(TAMODEL,charsmax(TAMODEL),value);
                    server_print("[ CSDuragi ] Sirt Bayrak Modeli %s olarak degistirildi.", value)
                }
                else {
                    server_cmd("%s",key[3])
                }
                continue;
            }
        }
        if (file) fclose(file)
    }

    //Bayraklar

    get_mapname(mapname, charsmax(mapname))
    formatex(filepath, charsmax(filepath), "maps/%s.cctf.cfg", mapname)

    if (!file_exists(filepath))
    {
        server_print("[ CSDuragi ] %s dosyasi bulunamadi. Bayraklar olusturulamadi.", filepath)
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

            if (equal(key[3], "TEBayrakX"))
            {
                koordinatlar[YER_TEALAN][0] = floatstr(value)
            }
            else if (equal(key[3], "TEBayrakY"))
            {
                koordinatlar[YER_TEALAN][1] = floatstr(value)
            }
            else if (equal(key[3], "TEBayrakZ"))
            {
                koordinatlar[YER_TEALAN][2] = floatstr(value)
            }

            else if (equal(key[3], "CTBayrakX"))
            {
                koordinatlar[YER_CTALAN][0] = floatstr(value)
            }
            else if (equal(key[3], "CTBayrakY"))
            {
                koordinatlar[YER_CTALAN][1] = floatstr(value)
            }
            else if (equal(key[3], "CTBayrakZ"))
            {
                koordinatlar[YER_CTALAN][2] = floatstr(value)
            }
            continue;
        }
    }
    if (file) fclose(file)
    server_print("[ CSDuragi ] %s dosyasindan bayrak bilgileri cekildi.", filepath)

    koordinatlar[YER_YENI_TEALAN][0] = koordinatlar[YER_TEALAN][0]
    koordinatlar[YER_YENI_TEALAN][1] = koordinatlar[YER_TEALAN][1]
    koordinatlar[YER_YENI_TEALAN][2] = koordinatlar[YER_TEALAN][2]

    koordinatlar[YER_YENI_CTALAN][0] = koordinatlar[YER_CTALAN][0]
    koordinatlar[YER_YENI_CTALAN][1] = koordinatlar[YER_CTALAN][1]
    koordinatlar[YER_YENI_CTALAN][2] = koordinatlar[YER_CTALAN][2]
}
/*================================================================================
 [Native]
=================================================================================*/
public plugin_natives()
{
    register_native("csd_tebayrak_tasiyici", "native_te_takimi_tasiyici", 1)
    register_native("csd_ctbayrak_tasiyici", "native_ct_takimi_tasiyici", 1)
    register_native("csd_obje_tealan", "native_obje_tealan", 1)
    register_native("csd_obje_ctalan", "native_obje_ctalan", 1)
    register_native("csd_obje_tebayrak", "native_obje_tebayrak", 1)
    register_native("csd_obje_ctbayrak", "native_obje_ctbayrak", 1)
    register_native("csd_ctalanindami", "native_ct_alanindami", 1)
    register_native("csd_tealanindami", "native_te_alanindami", 1)
}
public native_te_takimi_tasiyici()
{
    return degiskenler[tasiyici_TE];
}
public native_ct_takimi_tasiyici()
{
    return degiskenler[tasiyici_CT];
}
public native_obje_tealan()
{
    return degiskenler[obje_TEAlan];
}
public native_obje_ctalan()
{
    return degiskenler[obje_CTAlan];
}
public native_obje_tebayrak()
{
    return degiskenler[obje_TEBayrak];
}
public native_obje_ctbayrak()
{
    return degiskenler[obje_CTBayrak];
}
public native_ct_alanindami(oyuncu)
{
    return bireysel[ctalaniicerisinde][oyuncu];
}
public native_te_alanindami(oyuncu)
{
    return bireysel[tealaniicerisinde][oyuncu];
}
/*================================================================================
 [Olaylar]
=================================================================================*/
public client_disconnected(oyuncu){
    if(degiskenler[tasiyici_TE] == oyuncu){
        BAYRAGIGERIGOTUR(degiskenler[obje_CTBayrak])
    }
    else if(degiskenler[tasiyici_CT] == oyuncu){
        BAYRAGIGERIGOTUR(degiskenler[obje_TEBayrak])
    }
}
public olunce(){
    new olen = read_data( 2 );

    new Float:originf[3]
    get_entvar(olen, var_origin, originf);
    if(degiskenler[tasiyici_CT] == olen){

        entity_set_origin(degiskenler[obje_TEBayrak], originf)
        entity_set_int(degiskenler[obje_TEBayrak],EV_INT_movetype,MOVETYPE_TOSS)
        set_entvar(degiskenler[obje_TEBayrak],var_aiment,-1)
        set_entvar(degiskenler[obje_TEBayrak], var_body, 2)
        set_entvar(degiskenler[obje_TEBayrak], var_gravity, 1.5)
        set_entvar(degiskenler[obje_TEBayrak], var_velocity, {0.0,0.0,-50.0});
        Set_ObjeModeli(degiskenler[obje_TEBayrak],1);
        Set_Entity_Anim(degiskenler[obje_TEBayrak], 1,0);
        degiskenler[tasiyici_CT] = -1;
        ExecuteForward(forw[bayrakdustu], forw[donusdegeri], olen,degiskenler[obje_TEBayrak]);
    }
    else if(degiskenler[tasiyici_TE] == olen){
        entity_set_origin(degiskenler[obje_CTBayrak], originf)
        entity_set_int(degiskenler[obje_CTBayrak],EV_INT_movetype,MOVETYPE_TOSS)
        set_entvar(degiskenler[obje_CTBayrak],var_aiment,-1)
        set_entvar(degiskenler[obje_CTBayrak], var_body, 1)
        set_entvar(degiskenler[obje_CTBayrak], var_gravity, 1.5)
        set_entvar(degiskenler[obje_CTBayrak], var_velocity, {0.0,0.0,-50.0});
        Set_ObjeModeli(degiskenler[obje_CTBayrak],1);
        Set_Entity_Anim(degiskenler[obje_CTBayrak], 1,0);
        degiskenler[tasiyici_TE] = -1;
        ExecuteForward(forw[bayrakdustu], forw[donusdegeri], olen,degiskenler[obje_CTBayrak]);

    }
}
public RestartAtildi(){
    BAYRAGIGERIGOTUR(degiskenler[obje_CTBayrak])
    BAYRAGIGERIGOTUR(degiskenler[obje_TEBayrak])
}
public BAYRAGIGERIGOTUR(obje){
    set_entvar(obje,var_aiment,0)
    set_entvar(obje,var_movetype,6)

    new Float:originf[3]
    Set_Entity_Anim(obje, 0,0);
    Set_ObjeModeli(obje,1);
    if(obje==degiskenler[obje_TEBayrak]){
        originf = koordinatlar[YER_TEALAN]
        originf[2] = originf[2]-30.0
        degiskenler[tasiyici_CT] = 0
        set_entvar(obje, var_body, 2)
    }
    else {
        originf = koordinatlar[YER_CTALAN]
        originf[2] = originf[2]-30.0
        degiskenler[tasiyici_TE] = 0
        set_entvar(obje, var_body, 1)
    }
    entity_set_origin(obje, originf)

    get_entvar(obje, var_angles, originf);
    originf[0] = 360.0
    originf[2] = 0.0
    set_entvar(obje, var_angles, originf);
}
public OBJEDOKUNMASI(obje, oyuncu){
    if(!is_entity(obje))
        return

    if(!is_valid_player(oyuncu))
        return
    if(!is_user_connected(oyuncu))
        return
    if(!is_user_alive(oyuncu) || is_user_bot(oyuncu))
        return

    if(degiskenler[obje_TEAlan] == obje || degiskenler[obje_CTAlan] == obje){
        if(degiskenler[obje_TEAlan] == obje && degiskenler[tasiyici_CT] == 0 && get_user_team(oyuncu) == TETAKIMI && degiskenler[tasiyici_TE] == oyuncu){
            BAYRAGIGERIGOTUR(degiskenler[obje_CTBayrak])
            ExecuteForward(forw[skorlandi], forw[donusdegeri], oyuncu,obje);
            rg_update_teamscores(0,1,true);
            set_entvar(degiskenler[obje_TEAlan], var_body, 4)
            Set_Entity_Anim(degiskenler[obje_TEAlan], 2,0);
            remove_task(degiskenler[obje_TEAlan]);
            set_task(10.0,"Set_SkorlaKaldir",degiskenler[obje_TEAlan]);
        }
        else if(degiskenler[obje_CTAlan] == obje && degiskenler[tasiyici_TE] == 0 && get_user_team(oyuncu) == CTTAKIMI && degiskenler[tasiyici_CT] == oyuncu){
            BAYRAGIGERIGOTUR(degiskenler[obje_TEBayrak])
            ExecuteForward(forw[skorlandi], forw[donusdegeri], oyuncu,obje);
            rg_update_teamscores(1,0,true);
            set_entvar(degiskenler[obje_CTAlan], var_body, 4)
            Set_Entity_Anim(degiskenler[obje_CTAlan], 2,0);
            remove_task(degiskenler[obje_CTAlan]);
            set_task(10.0,"Set_SkorlaKaldir",degiskenler[obje_CTAlan]);
        }
        else if(degiskenler[obje_TEAlan] == obje){
            if(!task_exists(oyuncu+AlanTESureKoy)){
                bireysel[tealaniicerisinde][oyuncu] = true
                ExecuteForward(forw[tebayrakalaninagirdi], forw[donusdegeri], oyuncu, obje);
            }
            remove_task(oyuncu+AlanTESureKoy);
            set_task(AlanIcerisindeKalinanSure,"degerisifirla",oyuncu+AlanTESureKoy)
        }
        else if(degiskenler[obje_CTAlan] == obje){
            if(!task_exists(oyuncu+AlanCTSureKoy)){
                bireysel[ctalaniicerisinde][oyuncu] = true
                ExecuteForward(forw[ctbayrakalaninagirdi], forw[donusdegeri], oyuncu, obje);
            }
            remove_task(oyuncu+AlanCTSureKoy);
            set_task(AlanIcerisindeKalinanSure,"degerisifirla",oyuncu+AlanCTSureKoy)
        }
    }
    if(degiskenler[obje_TEBayrak] == obje || degiskenler[obje_CTBayrak] == obje){
        if(degiskenler[obje_TEBayrak] == obje && is_valid_player(degiskenler[tasiyici_CT]))
            return
        if(degiskenler[obje_CTBayrak] == obje && is_valid_player(degiskenler[tasiyici_TE]))
            return


        new geciciobje[3]
        if(degiskenler[obje_TEBayrak] == obje){
            geciciobje[0] = degiskenler[obje_TEBayrak]
            geciciobje[2] = TETAKIMI
            geciciobje[1] = 0
            //client_print_color(oyuncu, oyuncu, "^3TE Bayragina dokundun.")
        }
        else{
            geciciobje[0] = degiskenler[obje_CTBayrak]
            geciciobje[2] = CTTAKIMI
            geciciobje[1] = 1
            //client_print_color(oyuncu, oyuncu, "^3CT Bayragina dokundun.")
        }


        if(get_user_team(oyuncu) == geciciobje[2]){
            if((geciciobje[1] ? degiskenler[tasiyici_TE] : degiskenler[tasiyici_CT])  == -1){
                BAYRAGIGERIGOTUR(geciciobje[0])
                ExecuteForward(forw[bayrakgeritasindi], forw[donusdegeri], oyuncu,geciciobje[0]);
                return
            }
        }
        else{
            entity_set_int(geciciobje[0], EV_INT_movetype, MOVETYPE_FOLLOW);
            entity_set_edict(geciciobje[0], EV_ENT_aiment, oyuncu);
            Set_ObjeModeli(geciciobje[0],0);
            set_entvar(geciciobje[0], var_body, geciciobje[1])
            if(get_user_team(oyuncu) == TETAKIMI){
                degiskenler[tasiyici_TE] = oyuncu
            }
            else {
                degiskenler[tasiyici_CT] = oyuncu
            }
            ExecuteForward(forw[bayrakalindi], forw[donusdegeri], oyuncu,geciciobje[0]);

        }
    }
}
/*================================================================================
 [Objeleri Oluşturma]
=================================================================================*/
public OBJELERIOLUSTUR(){

    degiskenler[obje_CTAlan] = rg_create_entity("info_target")

    entity_set_string(degiskenler[obje_CTAlan],EV_SZ_classname, SINIF)
    set_entvar(degiskenler[obje_CTAlan], var_model, BKMODEL);
    set_entvar(degiskenler[obje_CTAlan], var_modelindex, degiskenler[modeldosyasi]);
    set_entvar(degiskenler[obje_CTAlan], var_angles, Float:{360.0, 0.0, 0.0});
    entity_set_origin(degiskenler[obje_CTAlan], koordinatlar[YER_CTALAN])
    entity_set_int(degiskenler[obje_CTAlan],EV_INT_movetype,6)
    entity_set_int(degiskenler[obje_CTAlan],EV_INT_solid,1)
    set_entvar(degiskenler[obje_CTAlan], var_gravity, 1.5)
    entity_set_size(degiskenler[obje_CTAlan],Float:{-25.0,-25.0,-5.0},Float:{25.0,25.0,25.0})
    set_entvar(degiskenler[obje_CTAlan], var_body, 3)
    Set_Entity_Anim(degiskenler[obje_CTAlan], 0,0);
    set_entvar(degiskenler[obje_CTAlan], var_globalname, "CT Alani")
//---------------------------------------------------------------
    degiskenler[obje_TEAlan] = rg_create_entity("info_target")

    entity_set_string(degiskenler[obje_TEAlan],EV_SZ_classname, SINIF)
    set_entvar(degiskenler[obje_TEAlan], var_model, BKMODEL);
    set_entvar(degiskenler[obje_TEAlan], var_modelindex, degiskenler[modeldosyasi]);
    set_entvar(degiskenler[obje_TEAlan], var_angles, Float:{360.0, 0.0, 0.0});
    entity_set_origin(degiskenler[obje_TEAlan], koordinatlar[YER_TEALAN])
    entity_set_int(degiskenler[obje_TEAlan],EV_INT_movetype,6)
    entity_set_int(degiskenler[obje_TEAlan],EV_INT_solid,1)
    set_entvar(degiskenler[obje_TEAlan], var_gravity, 1.5)
    entity_set_size(degiskenler[obje_TEAlan],Float:{-25.0,-25.0,-5.0},Float:{25.0,25.0,25.0})
    set_entvar(degiskenler[obje_TEAlan], var_body, 3)
    Set_Entity_Anim(degiskenler[obje_TEAlan], 0,0);
    set_entvar(degiskenler[obje_TEAlan], var_globalname, "TE Alani")
//---------------------------------------------------------------
    degiskenler[obje_CTBayrak] = rg_create_entity("info_target")

    entity_set_string(degiskenler[obje_CTBayrak],EV_SZ_classname, SINIF)
    set_entvar(degiskenler[obje_CTBayrak], var_model, BKMODEL);
    set_entvar(degiskenler[obje_CTBayrak], var_modelindex, degiskenler[modeldosyasi]);
    set_entvar(degiskenler[obje_CTBayrak], var_angles, Float:{360.0, 0.0, 0.0});
    entity_set_origin(degiskenler[obje_CTBayrak], koordinatlar[YER_CTALAN])
    entity_set_int(degiskenler[obje_CTBayrak],EV_INT_movetype,6)
    entity_set_int(degiskenler[obje_CTBayrak],EV_INT_solid,1)
    set_entvar(degiskenler[obje_CTBayrak], var_gravity, 1.5)
    entity_set_size(degiskenler[obje_CTBayrak],Float:{-2.0,-2.0,-2.0},Float:{5.0,5.0,50.0})
    set_entvar(degiskenler[obje_CTBayrak], var_body, 1)
    Set_Entity_Anim(degiskenler[obje_CTBayrak], 0,0);
    set_entvar(degiskenler[obje_CTBayrak], var_globalname, "CT Bayrak")
    set_entvar(degiskenler[obje_CTBayrak], var_team, 2)
//---------------------------------------------------------------
    degiskenler[obje_TEBayrak] = rg_create_entity("info_target")

    entity_set_string(degiskenler[obje_TEBayrak],EV_SZ_classname, SINIF)
    set_entvar(degiskenler[obje_TEBayrak], var_model, BKMODEL);
    set_entvar(degiskenler[obje_TEBayrak], var_modelindex, degiskenler[modeldosyasi]);
    set_entvar(degiskenler[obje_TEBayrak], var_angles, Float:{360.0, 0.0, 0.0});
    entity_set_origin(degiskenler[obje_TEBayrak], koordinatlar[YER_TEALAN])
    entity_set_int(degiskenler[obje_TEBayrak],EV_INT_movetype,6)
    entity_set_int(degiskenler[obje_TEBayrak],EV_INT_solid,1)
    set_entvar(degiskenler[obje_TEBayrak], var_gravity, 1.5)
    entity_set_size(degiskenler[obje_TEBayrak],Float:{-2.0,-2.0,-2.0},Float:{5.0,5.0,50.0})
    set_entvar(degiskenler[obje_TEBayrak], var_body, 2)
    Set_Entity_Anim(degiskenler[obje_TEBayrak], 0,0);
    set_entvar(degiskenler[obje_TEBayrak], var_globalname, "TE Bayrak")
    set_entvar(degiskenler[obje_TEBayrak], var_team, 1)

    return PLUGIN_HANDLED
}

public YENI_OBJELERIOLUSTUR(TAKIM){
    if(TAKIM == CTTAKIMI){
        if(get_entvar(degiskenler[obje_YENI_CTBayrak], var_body) == 1){
            entity_set_origin(degiskenler[obje_YENI_CTBayrak], koordinatlar[YER_YENI_CTALAN])
        }
        else{
            degiskenler[obje_YENI_CTBayrak] = rg_create_entity("info_target")

            entity_set_string(degiskenler[obje_YENI_CTBayrak],EV_SZ_classname, YENI_SINIF)
            set_entvar(degiskenler[obje_YENI_CTBayrak], var_model, BKMODEL);
            set_entvar(degiskenler[obje_YENI_CTBayrak], var_modelindex, degiskenler[modeldosyasi]);
            set_entvar(degiskenler[obje_YENI_CTBayrak], var_angles, Float:{360.0, 0.0, 0.0});
            entity_set_origin(degiskenler[obje_YENI_CTBayrak], koordinatlar[YER_YENI_CTALAN])
            set_entvar(degiskenler[obje_YENI_CTBayrak], var_gravity, 0.5)
            entity_set_size(degiskenler[obje_YENI_CTBayrak],Float:{-25.0,-25.0,-5.0},Float:{25.0,25.0,25.0})
            set_entvar(degiskenler[obje_YENI_CTBayrak], var_body, 1)
            Set_Entity_Anim(degiskenler[obje_YENI_CTBayrak], 2,0);
        }
    }
    else {
        if(get_entvar(degiskenler[obje_YENI_TEBayrak], var_body) == 2){
            entity_set_origin(degiskenler[obje_YENI_TEBayrak], koordinatlar[YER_YENI_TEALAN])
        }
        else{
            degiskenler[obje_YENI_TEBayrak] = rg_create_entity("info_target")

            entity_set_string(degiskenler[obje_YENI_TEBayrak],EV_SZ_classname, YENI_SINIF)
            set_entvar(degiskenler[obje_YENI_TEBayrak], var_model, BKMODEL);
            set_entvar(degiskenler[obje_YENI_TEBayrak], var_modelindex, degiskenler[modeldosyasi]);
            set_entvar(degiskenler[obje_YENI_TEBayrak], var_angles, Float:{360.0, 0.0, 0.0});
            entity_set_origin(degiskenler[obje_YENI_TEBayrak], koordinatlar[YER_YENI_TEALAN])
            set_entvar(degiskenler[obje_YENI_TEBayrak], var_gravity, 0.5)
            entity_set_size(degiskenler[obje_YENI_TEBayrak],Float:{-25.0,-25.0,-5.0},Float:{25.0,25.0,25.0})
            set_entvar(degiskenler[obje_YENI_TEBayrak], var_body, 2)
            Set_Entity_Anim(degiskenler[obje_YENI_TEBayrak], 2,0);
        }
    }
}
/*================================================================================
 [BayrakKapmaca Menü]
=================================================================================*/
public BayrakKapmacaMenu(id, level, cid){
    if( !cmd_access( id, level, cid, 1 ) )
        return PLUGIN_HANDLED;

    new menu, Menuz[512]

    formatex(Menuz, charsmax(Menuz), "\y [ CSD Bayrak Kapmaca \dv\r%s \y]^n\wBy:\r %s", VERSION, AUTHOR );

    menu = menu_create(Menuz, "c_BayrakKapmacaMenu")

    formatex(Menuz, charsmax(Menuz), "\wCT Bayraginin Konumunu Belirle^n\w-------------->\y[\r%.0f\y] [\r%.0f\y] [\r%.0f\y]" ,koordinatlar[YER_YENI_CTALAN][0],koordinatlar[YER_YENI_CTALAN][1],koordinatlar[YER_YENI_CTALAN][2]);
    menu_additem(menu, Menuz, "1")
    formatex(Menuz, charsmax(Menuz), "\wTE Bayraginin Konumunu Belirle^n\w-------------->\y[\r%.0f\y] [\r%.0f\y] [\r%.0f\y]^n^n" ,koordinatlar[YER_YENI_TEALAN][0],koordinatlar[YER_YENI_TEALAN][1],koordinatlar[YER_YENI_TEALAN][2]);
    menu_additem(menu, Menuz, "2")

    formatex(Menuz, charsmax(Menuz), "\wKaydet" );
    menu_additem(menu, Menuz, "3")

    menu_display(id, menu, 0)

    return PLUGIN_HANDLED
}
public c_BayrakKapmacaMenu(iId, menu, item)
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

            koordinatlar[YER_YENI_CTALAN][0] = originf[0]
            koordinatlar[YER_YENI_CTALAN][1] = originf[1]
            koordinatlar[YER_YENI_CTALAN][2] = originf[2]

            YENI_OBJELERIOLUSTUR(CTTAKIMI)

            client_cmd(iId,MENUKOMUTU)
        }
        case 2:
        {
            new Float:originf[3]
            get_entvar(iId, var_origin, originf);

            koordinatlar[YER_YENI_TEALAN][0] = originf[0]
            koordinatlar[YER_YENI_TEALAN][1] = originf[1]
            koordinatlar[YER_YENI_TEALAN][2] = originf[2]

            YENI_OBJELERIOLUSTUR(TETAKIMI)

            client_cmd(iId,MENUKOMUTU)
        }

        case 3:
        {
            YeniKoordinatlariYaz();
            client_print_color(iId, iId, "Kaydedildi...")
        }
    }
    return PLUGIN_HANDLED;

}
/*================================================================================
 [Hızlı Ayarlar]
=================================================================================*/
public degerisifirla(oyuncu){
    if(oyuncu < AlanTESureKoy+50){
        bireysel[tealaniicerisinde][oyuncu-AlanTESureKoy] = false
    }
    else{
        bireysel[ctalaniicerisinde][oyuncu-AlanCTSureKoy] = false
    }
}
public Set_ObjeModeli(obje,deger){
    if(deger==1){
        set_entvar(obje, var_model, BKMODEL);
        set_entvar(obje, var_modelindex, degiskenler[modeldosyasi]);
    }
    else{
        set_entvar(obje, var_model, TAMODEL);
        set_entvar(obje, var_modelindex, degiskenler[sirtmodeldosyasi]);
    }
}
public Set_SkorlaKaldir(obje){
    set_entvar(obje, var_body, 3)
    Set_Entity_Anim(obje, 0,0);
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


public YeniKoordinatlariYaz(){
    new mapname[32], filepath[100]
    get_mapname(mapname, charsmax(mapname))
    formatex(filepath, charsmax(filepath), "maps/%s.cctf.cfg", mapname)

    if (file_exists(filepath))
        delete_file(filepath)

    new szBuffer[150]

    formatex(szBuffer, charsmax(szBuffer), "-->TEBayrakX = %.0f^n-->TEBayrakY = %.0f^n-->TEBayrakZ = %.0f^n-->CTBayrakX = %.0f^n-->CTBayrakY = %.0f^n-->CTBayrakZ = %.0f^n",koordinatlar[YER_YENI_TEALAN][0],koordinatlar[YER_YENI_TEALAN][1],koordinatlar[YER_YENI_TEALAN][2],koordinatlar[YER_YENI_CTALAN][0],koordinatlar[YER_YENI_CTALAN][1],koordinatlar[YER_YENI_CTALAN][2])
    write_file(filepath,szBuffer)
}
