/* Yek'-ta */

#include <amxmodx>

#define PLUGIN  "Yeni Eklenti"
#define VERSION "1.0"
#define AUTHOR  "Yek'-ta"

public plugin_init()
{
    register_plugin(PLUGIN, VERSION, AUTHOR)

    set_task(10.0,"taskver")
    set_task(60.0,"taskver")
    set_task(120.0,"taskver")
}
public taskver(){
    server_cmd("semiclip_option transparency 254");
}
