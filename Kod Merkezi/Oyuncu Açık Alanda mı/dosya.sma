#include <amxmodx>
#include <reapi>
#include <fakemeta>

public plugin_init(){
    register_plugin("Acik Alanda mi Sorgusu", "Test", "Yek'ta");
    register_clcmd("say /test", "test");
}

public test(index){ 
    if( get_entvar(index, var_flags) & FL_ONGROUND && adamdisaridami(index) ){ // FL_ONGROUND yerde olup olmadığını sorgulamak için
        client_print_color(index, index, "Suan Acik Alandasin.") 
    }
    else{
        client_print_color(index, index, "Suan Acik Alanda Degilsin.")
    }
}


stock Float:adamdisaridami(id)
{
    new Float:vOrigin[3], Float:fDist;
    get_entvar(id, var_origin, vOrigin)

    fDist = vOrigin[2];

    while(engfunc(EngFunc_PointContents, vOrigin) == CONTENTS_EMPTY)
        vOrigin[2] += 5.0;
//forum.csduragi.com
    if(engfunc(EngFunc_PointContents, vOrigin) == CONTENTS_SKY)
        return (vOrigin[2] - fDist);

    return 0.0;
}