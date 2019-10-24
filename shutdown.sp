#include <sourcemod>

#define SERVER_TAG "[SM]"

#pragma semicolon 1
#pragma newdecls required

char g_sLogs[PLATFORM_MAX_PATH + 1];
int g_Time = 10;
Handle g_Timer = null;
bool g_bStopTimer = false;

public Plugin myinfo = 
{
    name = "[CSGO] Server Restart Countdown",
    author = "Cruze",
    description = "Restarts server after countdown.",
    version = "1.1",
    url = "http://steamcommunity.com/profiles/76561198132924835"
};

public void OnPluginStart()
{
	RegAdminCmd("sm_shutdown",	CMD_ShutDown,	ADMFLAG_ROOT,	"Command to restart server");
	RegAdminCmd("sm_serverrestart",	CMD_ShutDown,	ADMFLAG_ROOT,	"Command to restart server");
	RegAdminCmd("sm_restartserver",	CMD_ShutDown,	ADMFLAG_ROOT,	"Command to restart server");
	RegAdminCmd("sm_cancelrestartserver",	CMD_Cancel,	ADMFLAG_ROOT,	"Cancel restart server timer.");
	RegAdminCmd("sm_cancelrestart",	CMD_Cancel,	ADMFLAG_ROOT,	"Cancel restart server timer.");
	RegAdminCmd("sm_crs",	CMD_Cancel,	ADMFLAG_ROOT,	"Cancel restart server timer.");
	RegAdminCmd("sm_rcs",	CMD_Cancel,	ADMFLAG_ROOT,	"Cancel restart server timer.");
	
	BuildPath(Path_SM, g_sLogs, sizeof(g_sLogs), "cruze_shutdown.log"); //I think server restart required for log file to be created
}

public void OnMapStart()
{
	g_bStopTimer = false;
}
 
public Action CMD_ShutDown(int client, int args)
{
	if(g_bStopTimer)
	{
		ReplyToCommand(client, "[SM] There is already a restart timer running! Type !crs to cancel it.");
		return Plugin_Handled;
	}
	char info[55];
	Format(info, sizeof(info), "Are you sure about this %N?", client);
	Menu menu = new Menu(Handle_AreYouSure);
	menu.SetTitle(info);
	menu.AddItem("", "Warning! Don't use this until you know what you're doing!", ITEMDRAW_DISABLED);
	menu.AddItem("", "No");
	menu.AddItem("", "No");
	menu.AddItem("", "Yes");
	menu.AddItem("", "No");
	menu.Display(client, 10);

	return Plugin_Handled;
}

public int Handle_AreYouSure(Menu menu, MenuAction action, int param1, int param2)
{
	if(action == MenuAction_Select)
	{
		switch(param2)
		{
			case 1:
			{
				PrintToChat(param1, "%s \x05Okay!\x09 Good thing this menu was there right?", SERVER_TAG);
				LogToFile(g_sLogs,"%N tried using restart server command and pressed 1st No", param1);
			}
			case 2:
			{
				PrintToChat(param1, "%s \x05Okay!\x09 Good thing this menu was there right?", SERVER_TAG);
				LogToFile(g_sLogs,"%N tried using restart server command and pressed 2nd No", param1);
			}
			case 3:
			{
				g_Time = 10;
				SetHudTextParams(0.35, 0.3, 10.0, 0, 0, 255, 255, 1, 1.00, 0.3, 0.3);
				for (int i = 1; i <= MaxClients; i++)
				{
					if (!IsClientInGame(i) || IsFakeClient(i))
						continue;

					ShowHudText(i, -1, "Server going to restart in 10 seconds!");
				}
				PrintToChatAll(" \x04 ***** \x07Server going to restart in 10 seconds! \x04*****");
				LogToFile(g_sLogs,"%N started restart server timer!", param1);
				g_Timer = CreateTimer(1.0, Timer_Shutdown, param1, TIMER_REPEAT | TIMER_FLAG_NO_MAPCHANGE);
			}
			case 4:
			{
				PrintToChat(param1, "%s \x05Okay!\x09 Good thing this menu was there right?", SERVER_TAG);
				LogToFile(g_sLogs,"%N tried using restart server command and pressed 3rd No", param1);
			}
		}
	}
	else if(action == MenuAction_End)
	{
		delete menu;
	}
}

public Action Timer_Shutdown(Handle Timer, any client)
{
	if(g_bStopTimer)
	{
		g_bStopTimer = false;
		return Plugin_Stop;
	}
	g_Time--;
	if(g_Time)
	{
		PrintToChatAll(" \x04***** \x07 %d \x04*****", g_Time);
	}
	else
	{
		for(int i = 1; i <= MaxClients; i++)
		{
			if(IsClientInGame(i))
			{
				KickClient(i, "Thanks for understanding! ^_^\n\nReconnect after 30 seconds - 1 minute!!");
			}
		}
		if(IsClientInGame(client))
			LogToFile(g_sLogs,"%N restarted server by using restart command!", client);
		ServerCommand("sv_cheats 1;crash");
		ClearTimer(g_Timer);
		return Plugin_Stop;
	}
	return Plugin_Continue;
}

public Action CMD_Cancel(int client, int args)
{
	g_bStopTimer = true;
	LogToFile(g_sLogs,"%N cancelled the restart server timer!", client);
	ReplyToCommand(client, "%s Successfully turned off restart timer!", SERVER_TAG);
	return Plugin_Handled;
}

stock void ClearTimer(Handle timer)
{
	if(timer != null)
	{
		delete timer;
	}
}
