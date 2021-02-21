/* Yek'-ta */

#include <amxmodx>
#include <reapi>
#define PLUGIN  "Efektli Yeni Para Sistemi"
#define VERSION "1.0"
#define AUTHOR  "Yek'-ta"

new yeni_oyuncununparasi[MAX_PLAYERS];
new eski_oyuncununparasi[MAX_PLAYERS];
#define BASLANGICPARASI 1000
#define ADAMOLDURUNCEGELEN 50
#define REHINEOLDURUNCE -15

public plugin_init()
{
    register_plugin(PLUGIN, VERSION, AUTHOR)
    RegisterHookChain(RG_CBasePlayer_AddAccount, "CBasePlayer_AddAccount", true);
}
public CBasePlayer_AddAccount(const this, amount, RewardType:type, bool:bTrackChange){

   if(type != RT_NONE){
      switch(type){
         case RT_ENEMY_KILLED:{
            yeni_oyuncununparasi[this] = yeni_oyuncununparasi[this]+ADAMOLDURUNCEGELEN
         }
         case RT_HOSTAGE_KILLED:{
            yeni_oyuncununparasi[this] = yeni_oyuncununparasi[this]+REHINEOLDURUNCE
         }
      }
      rg_add_account(this, eski_oyuncununparasi[this], AS_SET, false);
      //client_print_color(0,0, "Gelen Para %i - %i", amount , type)
      remove_task(this);
      guncelle(this);
   }
}

public client_putinserver(id){
   if(!is_user_bot(id)){
      yeni_oyuncununparasi[id] = BASLANGICPARASI;
      eski_oyuncununparasi[id] = yeni_oyuncununparasi[id]
   }
}

public guncelle(id){
   if(!is_user_connected(id)){
      return;
   }
   if(yeni_oyuncununparasi[id] > eski_oyuncununparasi[id]){
      eski_oyuncununparasi[id]++;
      rg_add_account(id, eski_oyuncununparasi[id], AS_SET, false);
   }
   else if(yeni_oyuncununparasi[id] < eski_oyuncununparasi[id]){
      eski_oyuncununparasi[id]--
      rg_add_account(id, eski_oyuncununparasi[id], AS_SET, false);
   }
   switch(abs(yeni_oyuncununparasi[id] - eski_oyuncununparasi[id])){
        case 0: {
            return;
        }
        case 1: {
            set_task(0.8,"guncelle",id);
        }
        case 2..5: {
            set_task(0.5,"guncelle",id);
        }
        case 6..11:{
            set_task(0.3,"guncelle",id);
        }
        case 12..19:{
            set_task(0.15,"guncelle",id);
        }
        default: {
            set_task(0.01,"guncelle",id);
        }
   }
}
public plugin_natives()
{
    register_native("ms_yenipara", "YeniParaAyarla", 1)
    register_native("ms_paraogren", "ParaOgren", 1)
}
public YeniParaAyarla(this, miktar){
   rg_add_account(this, eski_oyuncununparasi[this], AS_SET, false);
   yeni_oyuncununparasi[this] = yeni_oyuncununparasi[this]+miktar;
   remove_task(this);
   guncelle(this);
}
public ParaOgren(this){
   return yeni_oyuncununparasi[this];
}
