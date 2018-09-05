#include <sourcemod>

#define SERVER_TAG "[SM]"

#pragma semicolon 1
#pragma newdecls required

char g_sLogs[PLATFORM_MAX_PATH + 1];

public Plugin myinfo = 
{
    name = "[CSGO] SERVER SHUTDOWN COUNTDOWN",
    author = "Cruze",
    description = "",
    version = "1.0",
    url = ""
};

public void OnPluginStart()
{
	RegAdminCmd("sm_shutdown",	CMD_ShutDown,	ADMFLAG_ROOT,	"Start a kick all but admins timer!");
	SetHudTextParams(-1.0, 0.32, 10.0, 0, 255, 255, 255, 0, 0.1, 0.3, 0.3);
	
	BuildPath(Path_SM, g_sLogs, sizeof(g_sLogs), "cruze_shutdown.log"); //I think server restart required for log file to be created
}

public int Handle_AreYouSure(Menu menu, MenuAction action, int param1, int param2)
{
	if(action == MenuAction_Select)
	{
		int client = param1;
		char szName2[MAX_NAME_LENGTH];
		GetClientName(client, szName2, sizeof(szName2));
		switch(param2)
		{
			case 0:
			{
				//
			}
			case 1:
			{
				PrintToChat(client, "%s \x05Okay!\x09 Good thing this menu was there right?", SERVER_TAG);
				LogToFile(g_sLogs,"%s %s tried using sm_shutdown command and pressed 3rd No", SERVER_TAG, szName2);
			}
			case 2:
			{
				PrintToChat(client, "%s \x05Okay!\x09 Good thing this menu was there right?", SERVER_TAG);
				LogToFile(g_sLogs,"%s %s tried using sm_shutdown command and pressed 2nd No", SERVER_TAG, szName2);
			}
			case 3:
			{
				CreateTimer(1.0, Timer_9);
				CreateTimer(2.0, Timer_8); 
				CreateTimer(3.0, Timer_7);
				CreateTimer(4.0, Timer_6);
				CreateTimer(5.0, Timer_5); 
				CreateTimer(6.0, Timer_4);
				CreateTimer(7.0, Timer_3); 
				CreateTimer(8.0, Timer_2);
				CreateTimer(9.0, Timer_1);
				CreateTimer(10.0, Timer_0);
	
				LogToFile(g_sLogs,"%s shut down the server by using sm_shutdown command!", szName2);
				PrintToChatAll(" \x04 ***** \x07Server going for maintenance in 10 seconds! \x04*****");
				if(IsClientInGame(client) && !IsFakeClient(client))
					ShowHudText(client, -1, "Server going for maintenance in 10 seconds!");
			}
			case 4:
			{
				PrintToChat(client, "%s \x05Okay!\x09 Good thing this menu was there right?", SERVER_TAG);
				LogToFile(g_sLogs,"%s %s tried using sm_shutdown command and pressed 3rd No", SERVER_TAG, szName2);
			}
		}
	}
}
 
public Action CMD_ShutDown(int client, int args)
{
	char info[55];
	char szName[MAX_NAME_LENGTH];
	GetClientName(client, szName, sizeof(szName));
	
	Format(info, sizeof(info), "Are you sure about this %s?", szName);
	Menu menu = new Menu(Handle_AreYouSure);
	SetMenuExitButton(menu, false);
	SetMenuPagination(menu, MENU_NO_PAGINATION);
	menu.SetTitle(info);
	menu.AddItem("", "Warning! Don't use this until you know what you're doing!", ITEMDRAW_DISABLED);
	menu.AddItem("2", "No");
	menu.AddItem("3", "No");
	menu.AddItem("4", "Yes");
	menu.AddItem("5", "No");
	menu.Display(client, 20);

	return Plugin_Handled;
}  
public Action Timer_9(Handle Timer)
{
	PrintToChatAll(" \x04***** \x07 9 \x04*****");
}
public Action Timer_8(Handle Timer)
{
	PrintToChatAll(" \x04***** \x07 8 \x04*****");
}
public Action Timer_7(Handle Timer)
{
	PrintToChatAll(" \x04***** \x07 7 \x04*****");
}
public Action Timer_6(Handle Timer)
{
	PrintToChatAll(" \x04***** \x07 6 \x04*****");
}
public Action Timer_5(Handle Timer)
{
	PrintToChatAll(" \x04***** \x07 5 \x04*****");
}
public Action Timer_4(Handle Timer)
{
	PrintToChatAll(" \x04***** \x07 4 \x04*****");
}
public Action Timer_3(Handle Timer)
{
	PrintToChatAll(" \x04 ***** \x07 3 \x04*****");
}
public Action Timer_2(Handle Timer)
{
	PrintToChatAll(" \x04***** \x07 2 \x04*****");
}
public Action Timer_1(Handle Timer)
{
	PrintToChatAll(" \x04***** \x07 1 \x04*****");
}
public Action Timer_0(Handle Timer)
{
	for(int i = 1; i <= MaxClients; ++i)
	{
		if(IsClientInGame(i))
		{
			KickClient(i, "Thanks for Playing/Testing in our server! ^__^");
		}
	}
	ServerCommand("quit");
}