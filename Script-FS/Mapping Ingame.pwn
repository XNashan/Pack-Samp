/*******************************************************************************
*	Mapping InGame By Refki																  			                       *
*	Version: 1.0																									  	                       *
*																																 	                       *
*	Credits:																											                         	*
*	Script FS: Refki Andreas																					 			    	*
*	a_samp: SAMP Team																					                          *
*	zcmd: ZeeX																									  						   *
*	sscanf2: maddinat0r																					 					   	*
*	streamer: Incognito																					 			  		   	*
*	foreach: karimcambridge																					 		      	*
*	Note: ga usah ngaku punya lo setan / jual                           *
********************************************************************************/

#include <a_samp>
#include <sscanf2>
#include <dini>
#include <zcmd>
#include <streamer>

#define MAX_DYNAMIC_OBJECT 2000
#define COLOR_RED 		"{FF0000}"
#define COLOR_BLUE 	"{0000ff}"
#define COLOR_GREEN		"{00ff00}"

enum
{
	DIALOG_HELP1,
	DIALOG_HELP2,
	DIALOG_HELP3,
	DIALOG_CREDITS
}

enum pEnum
{
    pEditObject,
    pSelectedId,
}
new PlayerInfo[MAX_PLAYERS+1][pEnum];

enum ObjectInfo
{
	ObjectID,
	TypeObjectID,
	Float:PosisiObjectX,
	Float:PosisiObjectY,
	Float:PosisiObjectZ,
	Float:PosisiObjectRotX,
	Float:PosisiObjectRotY,
	Float:PosisiObjectRotZ,
	Text3D:ObjectTextId,
}
new InfoMappingInGameByRefki[MAX_DYNAMIC_OBJECT][ObjectInfo];

stock split(const strsrc[], strdest[][], delimiter)
{
    new i, li;
    new aNum;
    new len;
    while(i <= strlen(strsrc))
    {
        if(strsrc[i] == delimiter || i == strlen(strsrc))
        {
            len = strmid(strdest[aNum], strsrc, li, i, 128);
            strdest[aNum][len] = 0;
            li = i+1;
            aNum++;
        }
        i++;
    }
    return 1;
}

stock LoadMappingInGameByRefki()
{
	new garagebyrefki[7][128];
	new string[256];
	new File:file = fopen("DatabasenyaMappinganDariServerByRefki.cfg", io_read);
	if(file)
	{
	    new idx = 0;
		while(idx < MAX_DYNAMIC_OBJECT)
		{
		    fread(file, string);
		    split(string, garagebyrefki, '|');
		    InfoMappingInGameByRefki[idx][TypeObjectID] = strval(garagebyrefki[0]);
			InfoMappingInGameByRefki[idx][PosisiObjectX] = floatstr(garagebyrefki[1]);
			InfoMappingInGameByRefki[idx][PosisiObjectY] = floatstr(garagebyrefki[2]);
			InfoMappingInGameByRefki[idx][PosisiObjectZ] = floatstr(garagebyrefki[3]);
			InfoMappingInGameByRefki[idx][PosisiObjectRotX] = floatstr(garagebyrefki[4]);
			InfoMappingInGameByRefki[idx][PosisiObjectRotY] = floatstr(garagebyrefki[5]);
			InfoMappingInGameByRefki[idx][PosisiObjectRotZ] = floatstr(garagebyrefki[6]);
			if(InfoMappingInGameByRefki[idx][TypeObjectID])
			{
                InfoMappingInGameByRefki[idx][ObjectID] = CreateDynamicObject(InfoMappingInGameByRefki[idx][TypeObjectID], InfoMappingInGameByRefki[idx][PosisiObjectX], InfoMappingInGameByRefki[idx][PosisiObjectY], InfoMappingInGameByRefki[idx][PosisiObjectZ], InfoMappingInGameByRefki[idx][PosisiObjectRotX], InfoMappingInGameByRefki[idx][PosisiObjectRotY], InfoMappingInGameByRefki[idx][PosisiObjectRotZ], 0, 0);
                format(string, sizeof(string), "{ff6600}Index: {33cc33}%d", idx);
				InfoMappingInGameByRefki[idx][ObjectTextId] = CreateDynamic3DTextLabel(string, -1, InfoMappingInGameByRefki[idx][PosisiObjectX], InfoMappingInGameByRefki[idx][PosisiObjectY], InfoMappingInGameByRefki[idx][PosisiObjectZ]+0.5, 1.0);
            }
			idx++;
	    }
	}
	print("Dynamic Object By Refki Successfully Loaded");
	return 1;
}

stock SaveMappingInGameByRefki()
{
	new idx = 0, File:file;
	new string[256];
	while(idx < MAX_DYNAMIC_OBJECT)
	{
	    format(string, sizeof(string), "%d|%f|%f|%f|%f|%f|%f\r\n",
		InfoMappingInGameByRefki[idx][TypeObjectID],
		InfoMappingInGameByRefki[idx][PosisiObjectX],
		InfoMappingInGameByRefki[idx][PosisiObjectY],
		InfoMappingInGameByRefki[idx][PosisiObjectZ],
		InfoMappingInGameByRefki[idx][PosisiObjectRotX],
		InfoMappingInGameByRefki[idx][PosisiObjectRotY],
		InfoMappingInGameByRefki[idx][PosisiObjectRotZ]);
	    if(idx == 0)
	    {
	        file = fopen("DatabasenyaMappinganDariServerByRefki.cfg", io_write);
	    }
	    else
	    {
	    	file = fopen("DatabasenyaMappinganDariServerByRefki.cfg", io_append);
	    }
		fwrite(file, string);
		fclose(file);
		idx++;
	}
	print("Dynamic Object By Refki Successfully Saved");
}

stock CheckFiles()
{
	if(!dini_Exists("DatabasenyaMappinganDariServerByRefki.cfg")) dini_Create("DatabasenyaMappinganDariServerByRefki.cfg");
	if(!dini_Exists("HasilExportDariMappingEditorByRefki.cfg")) dini_Create("HasilExportDariMappingEditorByRefki.cfg");
	if(!dini_Exists("RemoveBuildingFromServer.cfg")) dini_Create("RemoveBuildingFromServer.cfg");
	return 1;
}

public OnFilterScriptInit()
{
	LoadMappingInGameByRefki();
	CheckFiles();
	return 1;
}

public OnFilterScriptExit()
{
	return 1;
}

public OnPlayerConnect(playerid)
{
	PlayerInfo[playerid][pSelectedId] = -1;
	return 1;
}

public OnPlayerEditDynamicObject(playerid, objectid, response, Float:x, Float:y, Float:z, Float:rx, Float:ry, Float:rz)
{
	if(response == EDIT_RESPONSE_FINAL)
	{
		if (PlayerInfo[playerid][pEditObject] != -1)
		{
			new string[128];
			new id = PlayerInfo[playerid][pEditObject];
			InfoMappingInGameByRefki[PlayerInfo[playerid][pEditObject]][PosisiObjectX] = x;
			InfoMappingInGameByRefki[PlayerInfo[playerid][pEditObject]][PosisiObjectY] = y;
			InfoMappingInGameByRefki[PlayerInfo[playerid][pEditObject]][PosisiObjectZ] = z;
			InfoMappingInGameByRefki[PlayerInfo[playerid][pEditObject]][PosisiObjectRotX] = rx;
			InfoMappingInGameByRefki[PlayerInfo[playerid][pEditObject]][PosisiObjectRotY] = ry;
			InfoMappingInGameByRefki[PlayerInfo[playerid][pEditObject]][PosisiObjectRotZ] = rz;

			DestroyDynamicObject(InfoMappingInGameByRefki[id][ObjectID]);
			InfoMappingInGameByRefki[id][ObjectID] = CreateDynamicObject(InfoMappingInGameByRefki[id][TypeObjectID], InfoMappingInGameByRefki[id][PosisiObjectX], InfoMappingInGameByRefki[id][PosisiObjectY], InfoMappingInGameByRefki[id][PosisiObjectZ], InfoMappingInGameByRefki[id][PosisiObjectRotX], InfoMappingInGameByRefki[id][PosisiObjectRotY], InfoMappingInGameByRefki[id][PosisiObjectRotZ], 0, 0);
		
			DestroyDynamic3DTextLabel(InfoMappingInGameByRefki[id][ObjectTextId]);
			format(string, sizeof(string), "{ff6600}Index: {33cc33}%d", id);
			InfoMappingInGameByRefki[id][ObjectTextId] = CreateDynamic3DTextLabel(string, -1, InfoMappingInGameByRefki[id][PosisiObjectX], InfoMappingInGameByRefki[id][PosisiObjectY], InfoMappingInGameByRefki[id][PosisiObjectZ]+0.5, 1.0);
			SaveMappingInGameByRefki();
			
			SendClientMessage(playerid, 0xFFFFFFFF, "{0000ff}[]===================================|| {00ff00}Mapping In Game By Refki{0000ff} ||===================================[]");
			format(string, sizeof(string), "{00ff00}Anda Telah Mengedit Position Object ID:{ffffff} %d.", id);
			SendClientMessage(playerid, 0xFFFFFFFF, string);
			format(string, sizeof(string), "{00ff00}Posisi Object Sekarang Adalah:{ffffff} %f || %f || %f", InfoMappingInGameByRefki[id][PosisiObjectX], InfoMappingInGameByRefki[id][PosisiObjectY], InfoMappingInGameByRefki[id][PosisiObjectZ]);
			SendClientMessage(playerid, 0xFFFFFFFF, string);
		    format(string, sizeof(string), "{00ff00}Rotasi Object Sekarang Adalah:{ffffff} %f || %f || %f", InfoMappingInGameByRefki[id][PosisiObjectRotX], InfoMappingInGameByRefki[id][PosisiObjectRotY], InfoMappingInGameByRefki[id][PosisiObjectRotZ]);
			SendClientMessage(playerid, 0xFFFFFFFF, string);
		}
	}
	return 1;
}

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
	switch(dialogid)
	{
	 case DIALOG_HELP1:
		{
			if(!response)
			{
				ShowHelp2(playerid);
			}
		}
		case DIALOG_HELP2:
		{
			if(response)
			{
				ShowHelp3(playerid);
			}
		}
		case DIALOG_HELP3:
		{
			if(response)
			{
				ShowHelp4(playerid);
			}
		}
		case DIALOG_CREDITS:
		{
			if(response)
			{
				ShowHelp1(playerid);
			}
		}
	}
	return 1;
}

stock ShowHelp1(playerid)
{
    new line3[3500];
    strcat(line3, ""COLOR_RED"...:::... "COLOR_GREEN"List Command Help Mapping InGame"COLOR_RED"...:::...\n");
    strcat(line3, ""COLOR_GREEN"=> /objectcreate   >> "COLOR_RED"Menambahkan Object Di Server\n");
    strcat(line3, ""COLOR_GREEN"=> /objectdestroy >> "COLOR_RED"Menghapus Dynamic Object Dari Server\n");
	strcat(line3, ""COLOR_GREEN"=> /objectgoto       >> "COLOR_RED"Teleport Ke Dynamic Object\n");
    strcat(line3, ""COLOR_GREEN"=> /objectinfo         >> "COLOR_RED"Melihat Info Dynamic Object\n");
    strcat(line3, ""COLOR_GREEN"=> /objecthelp       >> "COLOR_RED"Melihat Semua Commands Dynamic Object\n");
	strcat(line3, ""COLOR_GREEN"=> /objectchange  >> "COLOR_RED"Mengubah Model Id Dynamic Object\n\n");
    strcat(line3, ""COLOR_GREEN"=> /objectexport   >> "COLOR_RED"Untuk Export Dynamic Object\n");
    strcat(line3, ""COLOR_GREEN"=> /objectselect   >> "COLOR_RED"Untuk Men Select Atau Memilih ID Dynamic Object\n");
    strcat(line3, ""COLOR_GREEN"=> /objectgethere   >> "COLOR_RED"Untuk Teleport OBJECT ID Ke Posisi Kamu\n");
    strcat(line3, ""COLOR_GREEN"=> /objectcopy   >> "COLOR_RED"Untuk MengDuplikat Dynamic Object\n");
    strcat(line3, ""COLOR_GREEN"=> /removebuilding   >> "COLOR_RED"Untuk Menghapus Object Id Bawaan GTA\n");
    strcat(line3, ""COLOR_GREEN"=> /objecteditpos  [PC ONLY]  >> "COLOR_RED"Untuk Mengedit Position Dynamic Object\n");
    strcat(line3, ""COLOR_GREEN"=> /mypos   >> "COLOR_RED"Untuk Melihat Posisi Kamu\n");
    strcat(line3, ""COLOR_GREEN"=> /gotocoords   >> "COLOR_RED"Untuk Teleport Kesuatu Coordinat\n");
    strcat(line3, ""COLOR_RED"=> []=====================================================================[] <=\n");
	strcat(line3, ""COLOR_GREEN"=> /offsetposx >> "COLOR_RED"Menambahkan Offset Posisi X Pada Dynamic Object\n");
    strcat(line3, ""COLOR_GREEN"=> /offsetposy >> "COLOR_RED"Menambahkan Offset Posisi Y Pada Dynamic Object\n");
    strcat(line3, ""COLOR_GREEN"=> /offsetposz >> "COLOR_RED"Menambahkan Offset Posisi Z Pada Dynamic Object\n");
    strcat(line3, ""COLOR_GREEN"=> /offsetrotx >> "COLOR_RED"Menambahkan Offset Rotate X Pada Dynamic Object\n");
    strcat(line3, ""COLOR_GREEN"=> /offsetroty >> "COLOR_RED"Menambahkan Offset Rotate Y Pada Dynamic Object\n");
    strcat(line3, ""COLOR_GREEN"=> /offsetrotz >> "COLOR_RED"Menambahkan Offset Rotate Z Pada Dynamic Object\n\n");
    strcat(line3, ""COLOR_GREEN"=> /setpx >> "COLOR_RED"Memindahkan Posisi X Pada Dynamic Object\n");
    strcat(line3, ""COLOR_GREEN"=> /setpy >> "COLOR_RED"Memindahkan Posisi Y Pada Dynamic Object\n");
    strcat(line3, ""COLOR_GREEN"=> /setpz >> "COLOR_RED"Memindahkan Posisi Z Pada Dynamic Object\n");
    strcat(line3, ""COLOR_GREEN"=> /setrx >> "COLOR_RED"Memindahkan Rotate X Pada Dynamic Object\n");
    strcat(line3, ""COLOR_GREEN"=> /setry >> "COLOR_RED"Memindahkan Rotate Y Pada Dynamic Object\n");
    strcat(line3, ""COLOR_GREEN"=> /setrz >> "COLOR_RED"Memindahkan Rotate Z Pada Dynamic Object\n");
	ShowPlayerDialog(playerid, DIALOG_HELP1, DIALOG_STYLE_MSGBOX, ""COLOR_BLUE"Mapping InGame System By Refki", line3, "Close", "Page 2 =>");
    return 1;
}

stock ShowHelp2(playerid)
{
    new line3[3500];
    strcat(line3, ""COLOR_GREEN"=> /offsetposx         CMD SINGKATNYA: "COLOR_RED"/px\n");
    strcat(line3, ""COLOR_GREEN"=> /offsetposy         CMD SINGKATNYA: "COLOR_RED"/py\n");
    strcat(line3, ""COLOR_GREEN"=> /offsetposz         CMD SINGKATNYA: "COLOR_RED"/pz\n\n");
    strcat(line3, ""COLOR_GREEN"=> /offsetrotx         CMD SINGKATNYA: "COLOR_RED"/rx\n");
    strcat(line3, ""COLOR_GREEN"=> /offsetroty         CMD SINGKATNYA: "COLOR_RED"/ry\n");
    strcat(line3, ""COLOR_GREEN"=> /offsetrotz         CMD SINGKATNYA: "COLOR_RED"/rz\n\n");
    strcat(line3, ""COLOR_RED"=> []==================================================[] <=\n");
    strcat(line3, ""COLOR_GREEN"=> /setpx         CMD SINGKATNYA: "COLOR_RED"/sox\n");
    strcat(line3, ""COLOR_GREEN"=> /setpy         CMD SINGKATNYA: "COLOR_RED"/soy\n");
    strcat(line3, ""COLOR_GREEN"=> /setpz         CMD SINGKATNYA: "COLOR_RED"/soz\n\n");
    strcat(line3, ""COLOR_GREEN"=> /setrx         CMD SINGKATNYA: "COLOR_RED"/srx\n");
    strcat(line3, ""COLOR_GREEN"=> /setry         CMD SINGKATNYA: "COLOR_RED"/sry\n");
    strcat(line3, ""COLOR_GREEN"=> /setrz         CMD SINGKATNYA: "COLOR_RED"/srz\n");
	ShowPlayerDialog(playerid, DIALOG_HELP2, DIALOG_STYLE_MSGBOX, ""COLOR_BLUE"Page 2", line3, "Page 3 =>", "Close");
    return 1;
}

stock ShowHelp3(playerid)
{
    new line3[3500];
    strcat(line3, ""COLOR_GREEN"- Kalau Kalian Udah EXPORT OBJECT Dan gak Tau Lokasinya\n-Lokasinya Itu Ada Di File Yang Bernama HasilExportDariMappingEditorByRefki.cfg\n");
    strcat(line3, ""COLOR_GREEN"- Dan Kalau Kalian Pengen Melihat Database Mappingannya Ada Di File Bernama DatabasenyaMappinganDariServerByRefki.cfg\n");
	ShowPlayerDialog(playerid, DIALOG_HELP3, DIALOG_STYLE_MSGBOX, ""COLOR_BLUE"Page 3", line3, "Page 4 =>", "Close");
    return 1;
}

stock ShowHelp4(playerid)
{
    new line3[3500];
    strcat(line3, ""COLOR_RED"...:::... "COLOR_GREEN"Infomasi OOC From Refki Andreas"COLOR_RED"...:::...\n");
    strcat(line3, ""COLOR_GREEN"- NAMA: {00ff00}Refki Andreas\n");
    strcat(line3, ""COLOR_GREEN"- NO WHATSAPP: {00ff00}082299589582\n");
    strcat(line3, ""COLOR_GREEN"- EMAIL: {00ff00} rrizalarapi@gmail.com\n");
    strcat(line3, ""COLOR_GREEN"- DISCORD: {00ff00} Refki196#4786\n\n");
    strcat(line3, ""COLOR_RED"...:::... "COLOR_GREEN"Notes for you"COLOR_RED"...:::...\n");
    strcat(line3, ""COLOR_GREEN"- Ini FS Real Buatan Refki, Dan Dari FS Ini Ada Beberapa Script Dari Dynamic Door Yang Saya Share Waktu Itu\n");
    strcat(line3, ""COLOR_GREEN"- Kalau Gak Percaya Coba Ada Yang Sama Enggak Script Nya Sama Script Mapping InGame Buatan Refki\n");
    strcat(line3, ""COLOR_GREEN"- Kalau Kalian Menemukan FS Yang Sama Mapping InGame Kayak Buatan Refki, Hubungi WA, EMAIL, ATAU DISCORD\n");
    strcat(line3, ""COLOR_GREEN"- Untuk Memastikan Script Dalam Nya Sama Atau Enggak\n");
    strcat(line3, ""COLOR_GREEN"- Kalau Ada Bug Atau Problem Di FS ini Silahkan Hubungi Refki Melalui WA, DISCORD, Ataupun Email\n\n\n");
    strcat(line3, ""COLOR_RED"...:::... "COLOR_GREEN"Sekian Dari Saya(Refki) Terima Kasih"COLOR_RED"...:::...\n");
	ShowPlayerDialog(playerid, DIALOG_CREDITS, DIALOG_STYLE_MSGBOX, ""COLOR_BLUE"Page 4 [] Infomasi Credits []", line3, "Page 1 <=", "Close");
    return 1;
}

/*===================================|| Command ALIAS Menambah Offset Object ||===================================*/
CMD:ox(playerid, params[])
{
     return cmd_offsetposx(playerid, params);
}
CMD:oy(playerid, params[])
{
     return cmd_offsetposy(playerid, params);
}
CMD:oz(playerid, params[])
{
     return cmd_offsetposz(playerid, params);
}
CMD:rx(playerid, params[])
{
     return cmd_offsetrotx(playerid, params);
}
CMD:ry(playerid, params[])
{
     return cmd_offsetroty(playerid, params);
}
CMD:rz(playerid, params[])
{
     return cmd_offsetrotz(playerid, params);
}
/*===================================|| Command ALIAS MenSET Object ||===================================*/
CMD:sox(playerid, params[])
{
     return cmd_setpx(playerid, params);
}
CMD:soy(playerid, params[])
{
     return cmd_setpy(playerid, params);
}
CMD:soz(playerid, params[])
{
     return cmd_setpz(playerid, params);
}
CMD:srx(playerid, params[])
{
     return cmd_setrx(playerid, params);
}
CMD:sry(playerid, params[])
{
     return cmd_setry(playerid, params);
}
CMD:srz(playerid, params[])
{
     return cmd_setrz(playerid, params);
}

CMD:objectcreate(playerid, params[])
{
	new string[128], type;
	if(sscanf(params, "i", type)) return SendClientMessage(playerid, 0xFFFFFFFF, "PENGGUNAAN CMD: /objectcreate [Object ID]");
	for(new idx=0; idx<MAX_DYNAMIC_OBJECT; idx++)
	{
	    if(!InfoMappingInGameByRefki[idx][TypeObjectID])
	    {
		    GetPlayerPos(playerid, InfoMappingInGameByRefki[idx][PosisiObjectX], InfoMappingInGameByRefki[idx][PosisiObjectY], InfoMappingInGameByRefki[idx][PosisiObjectZ]);
		    SetPlayerPos(playerid, InfoMappingInGameByRefki[idx][PosisiObjectX], InfoMappingInGameByRefki[idx][PosisiObjectY]-2, InfoMappingInGameByRefki[idx][PosisiObjectZ]);
    	    InfoMappingInGameByRefki[idx][TypeObjectID] = type;
            InfoMappingInGameByRefki[idx][ObjectID] = CreateDynamicObject(InfoMappingInGameByRefki[idx][TypeObjectID], InfoMappingInGameByRefki[idx][PosisiObjectX], InfoMappingInGameByRefki[idx][PosisiObjectY], InfoMappingInGameByRefki[idx][PosisiObjectZ], 0.0000, 0.0000, 0.0000 , 0, 0);
            format(string, sizeof(string), "{ff6600}Index: {33cc33}%d", idx);
			InfoMappingInGameByRefki[idx][ObjectTextId] = CreateDynamic3DTextLabel(string, -1, InfoMappingInGameByRefki[idx][PosisiObjectX], InfoMappingInGameByRefki[idx][PosisiObjectY], InfoMappingInGameByRefki[idx][PosisiObjectZ]+0.5, 1.0);
			idx = MAX_DYNAMIC_OBJECT;
			SendClientMessage(playerid, 0xFFFFFFFF, "{0000ff}[]===================================|| {00ff00}Mapping In Game By Refki{0000ff} ||===================================[]");
			format(string, sizeof(string), "Anda telah Menambah Object Di Server Dengan Model{00ff00} %d", type); 
	        SendClientMessage(playerid, 0xFFFFFFFF, string);
	        format(string, sizeof(string), "=> CreateDynamicObject(%d, %f, %f, %f, %f, %f, %f);", type, InfoMappingInGameByRefki[idx][PosisiObjectX], InfoMappingInGameByRefki[idx][PosisiObjectY], InfoMappingInGameByRefki[idx][PosisiObjectZ], InfoMappingInGameByRefki[idx][PosisiObjectRotX], InfoMappingInGameByRefki[idx][PosisiObjectRotY], InfoMappingInGameByRefki[idx][PosisiObjectRotZ]); 
	        SendClientMessage(playerid, 0xFFFFFFFF, string);
			SaveMappingInGameByRefki();
		}
	}
	return 1;
}

CMD:objectdestroy(playerid, params[])
{
	new idx, string[128];
	if(sscanf(params, "i", idx)) return SendClientMessage(playerid, 0xFFFFFFFF, "PENGGUNAAN CMD: /objectdestroy [Object ID]");
	if(!InfoMappingInGameByRefki[idx][TypeObjectID]) return SendClientMessage(playerid, 0xFFFFFFFF, "ID Object Tidak Valid Atau Tidak Ada Di Server");
	InfoMappingInGameByRefki[idx][TypeObjectID] = 0;
	InfoMappingInGameByRefki[idx][PosisiObjectX] = 0;
	InfoMappingInGameByRefki[idx][PosisiObjectY] = 0;
	InfoMappingInGameByRefki[idx][PosisiObjectZ] = 0;
	InfoMappingInGameByRefki[idx][PosisiObjectRotX] = 0;
	InfoMappingInGameByRefki[idx][PosisiObjectRotY] = 0;
	InfoMappingInGameByRefki[idx][PosisiObjectRotZ] = 0;
	DestroyDynamicObject(InfoMappingInGameByRefki[idx][ObjectID]);
	DestroyDynamic3DTextLabel(InfoMappingInGameByRefki[idx][ObjectTextId]);
	PlayerInfo[playerid][pSelectedId] = -1;
	SendClientMessage(playerid, 0xFFFFFFFF, "{0000ff}[]===================================|| {00ff00}Mapping In Game By Refki{0000ff} ||===================================[]");
	format(string, sizeof(string), "Anda Berhasil Hapus Object ID:{00ff00} %d.", idx);
	SendClientMessage(playerid, 0xFFFFFFFF, string);
    SaveMappingInGameByRefki();
	return 1;
}

CMD:objectcopy(playerid, params[])
{
	new string[128];
	if(PlayerInfo[playerid][pSelectedId] == -1) return SendClientMessage(playerid, -1, "{ff0000}ERROR: {ffffff}Anda Belum Men Select ID Object Manapun");
	for(new idx=0; idx<MAX_DYNAMIC_OBJECT; idx++)
	{
	    if(!InfoMappingInGameByRefki[idx][TypeObjectID])
	    {
		    GetDynamicObjectPos(InfoMappingInGameByRefki[PlayerInfo[playerid][pSelectedId]][ObjectID], InfoMappingInGameByRefki[idx][PosisiObjectX], InfoMappingInGameByRefki[idx][PosisiObjectY], InfoMappingInGameByRefki[idx][PosisiObjectZ]);
		    GetDynamicObjectRot(InfoMappingInGameByRefki[PlayerInfo[playerid][pSelectedId]][ObjectID], InfoMappingInGameByRefki[idx][PosisiObjectRotX], InfoMappingInGameByRefki[idx][PosisiObjectRotY], InfoMappingInGameByRefki[idx][PosisiObjectRotZ]);
    	    InfoMappingInGameByRefki[idx][TypeObjectID] = InfoMappingInGameByRefki[PlayerInfo[playerid][pSelectedId]][TypeObjectID];
            InfoMappingInGameByRefki[idx][ObjectID] = CreateDynamicObject(InfoMappingInGameByRefki[idx][TypeObjectID], InfoMappingInGameByRefki[idx][PosisiObjectX], InfoMappingInGameByRefki[idx][PosisiObjectY], InfoMappingInGameByRefki[idx][PosisiObjectZ], InfoMappingInGameByRefki[idx][PosisiObjectRotX], InfoMappingInGameByRefki[idx][PosisiObjectRotY], InfoMappingInGameByRefki[idx][PosisiObjectRotZ], 0, 0);
            format(string, sizeof(string), "{ff6600}Index: {33cc33}%d", idx);
			InfoMappingInGameByRefki[idx][ObjectTextId] = CreateDynamic3DTextLabel(string, -1, InfoMappingInGameByRefki[idx][PosisiObjectX], InfoMappingInGameByRefki[idx][PosisiObjectY], InfoMappingInGameByRefki[idx][PosisiObjectZ]+0.5, 1.0);
			idx = MAX_DYNAMIC_OBJECT;
			SendClientMessage(playerid, 0xFFFFFFFF, "{0000ff}[]===================================|| {00ff00}Mapping In Game By Refki{0000ff} ||===================================[]");
			format(string, sizeof(string), "Anda Berhasil Duplikat Object ID{00ff00} %d", PlayerInfo[playerid][pSelectedId]); 
	        SendClientMessage(playerid, 0xFFFFFFFF, string);
	        EditDynamicObject(playerid, InfoMappingInGameByRefki[idx][ObjectID]);
	        PlayerInfo[playerid][pEditObject] = idx;
	        PlayerInfo[playerid][pSelectedId] = -1;
			SaveMappingInGameByRefki();
		}
	}
	return 1;
}

CMD:objectchange(playerid, params[])
{
	new idx, string[128];
    new ChangeObject;
    if(sscanf(params, "ii", idx, ChangeObject)) return SendClientMessage(playerid, 0xFFFFFFFF, "PENGGUNAAN CMD: /objectchange [Object ID] [New ID Object]");
    if(!InfoMappingInGameByRefki[idx][TypeObjectID]) return SendClientMessage(playerid, 0xFFFFFFFF, "ID Object Tidak Valid Atau Tidak Ada Di Server");
    {
		InfoMappingInGameByRefki[idx][TypeObjectID] = ChangeObject;
		DestroyDynamicObject(InfoMappingInGameByRefki[idx][ObjectID]);
		InfoMappingInGameByRefki[idx][ObjectID] = CreateDynamicObject(InfoMappingInGameByRefki[idx][TypeObjectID], InfoMappingInGameByRefki[idx][PosisiObjectX], InfoMappingInGameByRefki[idx][PosisiObjectY], InfoMappingInGameByRefki[idx][PosisiObjectZ], InfoMappingInGameByRefki[idx][PosisiObjectRotX], InfoMappingInGameByRefki[idx][PosisiObjectRotY], InfoMappingInGameByRefki[idx][PosisiObjectRotZ], 0, 0);
		SendClientMessage(playerid, 0xFFFFFFFF, "{0000ff}[]===================================|| {00ff00}Mapping In Game By Refki{0000ff} ||===================================[]");
	    format(string, sizeof(string), "Anda telah Mengubah ID Object %d Menjadi ID Object to %d", idx, ChangeObject);
	    SendClientMessage(playerid, 0xFFFFFFFF, string);
	    SaveMappingInGameByRefki();
    }
	return 1;
}

CMD:objecteditpos(playerid ,params[])
{
    new id, string[256];
    if(sscanf(params, "i", id)) return SendClientMessage(playerid, 0xFFFFFFFF, "PENGGUNAAN CMD: /objecteditpos [Object ID]");
    if(!InfoMappingInGameByRefki[id][TypeObjectID]) return SendClientMessage(playerid, 0xFFFFFFFF, "ID Object Tidak Valid Atau Tidak Ada Di Server");
    {
		EditDynamicObject(playerid, InfoMappingInGameByRefki[id][ObjectID]);
		PlayerInfo[playerid][pEditObject] = id;
		SendClientMessage(playerid, 0xFFFFFFFF, "{0000ff}[]===================================|| {00ff00}Mapping In Game By Refki{0000ff} ||===================================[]");
		format(string, sizeof(string), "{00ff00}Anda Masuk Ke Pengeditan Position Object ID: {ffffff}%d.", id);
		SendClientMessage(playerid, 0xFFFFFFFF, string);
	}
	return 1;
}

CMD:objectexport(playerid, params[])
{
	new idx, File:file;
	new string[256];
	if(sscanf(params, "i", idx)) return SendClientMessage(playerid, 0xFFFFFFFF, "PENGGUNAAN CMD: /objectexport [Object ID]");
	if(!InfoMappingInGameByRefki[idx][TypeObjectID]) return SendClientMessage(playerid, 0xFFFFFFFF, "ID Object Tidak Valid Atau Tidak Ada Di Server");
	{
	    format(string, sizeof(string), "CreateDynamicObject(%d, %f, %f, %f, %f, %f, %f);\n",
        InfoMappingInGameByRefki[idx][TypeObjectID],
		InfoMappingInGameByRefki[idx][PosisiObjectX],
		InfoMappingInGameByRefki[idx][PosisiObjectY],
		InfoMappingInGameByRefki[idx][PosisiObjectZ],
		InfoMappingInGameByRefki[idx][PosisiObjectRotX],
		InfoMappingInGameByRefki[idx][PosisiObjectRotY],
		InfoMappingInGameByRefki[idx][PosisiObjectRotZ]);
	    if(idx == 0)
	    {
	        file = fopen("HasilExportDariMappingEditorByRefki.cfg", io_write);
	    }
	    else
	    {
	    	file = fopen("HasilExportDariMappingEditorByRefki.cfg", io_append);
	    }
		fwrite(file, string);
		fclose(file);
	}
	SendClientMessage(playerid, 0xFFFFFFFF, "{0000ff}[]===================================|| {00ff00}Mapping In Game By Refki{0000ff} ||===================================[]");
	format(string, sizeof(string), "Anda Berhasil Export Dynamic Object {ff6600}Index: {33cc33}%d {ffffff}Buka Di HasilExportDariMappingEditorByRefki.cfg Untuk Mengambil Code Mappingannya", idx);
	SendClientMessage(playerid, 0xFFFFFFFF, string);
	format(string, sizeof(string), "{00ff00} INFO:{ffffff} CreateDynamicObject(%d, %f, %f, %f, %f, %f, %f);", InfoMappingInGameByRefki[idx][TypeObjectID], InfoMappingInGameByRefki[idx][PosisiObjectX], InfoMappingInGameByRefki[idx][PosisiObjectY], InfoMappingInGameByRefki[idx][PosisiObjectZ], InfoMappingInGameByRefki[idx][PosisiObjectRotX], InfoMappingInGameByRefki[idx][PosisiObjectRotY], InfoMappingInGameByRefki[idx][PosisiObjectRotZ]);
	SendClientMessage(playerid, 0xFFFFFFFF, string);
	return 1;
}

CMD:objectgethere(playerid, params[])
{
	new Float:posx, Float:posy, Float:posz, Float:rotx, Float:roty, Float:rotz, idx, string[128];
    if(sscanf(params, "i", idx))
	{
		SendClientMessage(playerid, 0xFFFF0000, "{00ff00}INFO: {0000cc}PENGGUNAAN CMD: /objectgethere [{ffff00}Object ID{0000cc}]");
	}
	GetPlayerPos(playerid, posx, posy, posz);
	GetDynamicObjectRot(InfoMappingInGameByRefki[idx][ObjectID], rotx, roty, rotz);
	InfoMappingInGameByRefki[idx][PosisiObjectX] = posx;
	InfoMappingInGameByRefki[idx][PosisiObjectY] = posy;
	InfoMappingInGameByRefki[idx][PosisiObjectZ] = posz;
	InfoMappingInGameByRefki[idx][PosisiObjectRotX] = rotx;
	InfoMappingInGameByRefki[idx][PosisiObjectRotY] = roty;
	InfoMappingInGameByRefki[idx][PosisiObjectRotZ] = rotz;
	
	DestroyDynamicObject(InfoMappingInGameByRefki[idx][ObjectID]);
	InfoMappingInGameByRefki[idx][ObjectID] = CreateDynamicObject(InfoMappingInGameByRefki[idx][TypeObjectID], InfoMappingInGameByRefki[idx][PosisiObjectX], InfoMappingInGameByRefki[idx][PosisiObjectY], InfoMappingInGameByRefki[idx][PosisiObjectZ], InfoMappingInGameByRefki[idx][PosisiObjectRotX], InfoMappingInGameByRefki[idx][PosisiObjectRotY], InfoMappingInGameByRefki[idx][PosisiObjectRotZ], 0, 0);
	
	DestroyDynamic3DTextLabel(InfoMappingInGameByRefki[idx][ObjectTextId]);
	format(string, sizeof(string), "{ff6600}Index: {33cc33}%d", idx);
	InfoMappingInGameByRefki[idx][ObjectTextId] = CreateDynamic3DTextLabel(string, -1, InfoMappingInGameByRefki[idx][PosisiObjectX], InfoMappingInGameByRefki[idx][PosisiObjectY], InfoMappingInGameByRefki[idx][PosisiObjectZ]+0.5, 1.0);
	SaveMappingInGameByRefki();
	SendClientMessage(playerid, 0xFFFFFFFF, "{0000ff}[]===================================|| {00ff00}Mapping In Game By Refki{0000ff} ||===================================[]");
    format(string, sizeof(string), "Anda Berhasil Telepport ID Object %d {ffffff}Ke Posisi Kamu", idx);
	SendClientMessage(playerid, 0xFFFFFFFF, string);
  	return 1;
}


CMD:objectinfo(playerid, params[])
{
	new idx, string[128];
	if(sscanf(params, "i", idx)) return SendClientMessage(playerid, 0xFFFFFFFF, "PENGGUNAAN CMD: /objectinfo [Object ID]");
	if(!InfoMappingInGameByRefki[idx][TypeObjectID]) return SendClientMessage(playerid, 0xFFFFFFFF, "ID Object Tidak Valid Atau Tidak Ada Di Server");
	
	SendClientMessage(playerid, 0xFFFFFFFF, "{0000ff}[]===================================|| {00ff00}Mapping In Game By Refki{0000ff} ||===================================[]");
	format(string, sizeof(string), "{00ff00}OBJECT ID:{ffffff} %d.", idx);
	SendClientMessage(playerid, 0xFFFFFFFF, string);
	format(string, sizeof(string), "{00ff00}MODEL OBJECT:{ffffff} %d.", InfoMappingInGameByRefki[idx][TypeObjectID]);
	SendClientMessage(playerid, 0xFFFFFFFF, string);
	format(string, sizeof(string), "{00ff00}POSISI OBJECT:{ffffff} %f || %f || %f", InfoMappingInGameByRefki[idx][PosisiObjectX], InfoMappingInGameByRefki[idx][PosisiObjectY], InfoMappingInGameByRefki[idx][PosisiObjectZ]);
	SendClientMessage(playerid, 0xFFFFFFFF, string);
    format(string, sizeof(string), "{00ff00}ROTASI OBJECT:{ffffff} %f || %f || %f", InfoMappingInGameByRefki[idx][PosisiObjectRotX], InfoMappingInGameByRefki[idx][PosisiObjectRotY], InfoMappingInGameByRefki[idx][PosisiObjectRotZ]);
	SendClientMessage(playerid, 0xFFFFFFFF, string);
	format(string, sizeof(string), "CreateDynamicObject(%d, %f, %f, %f, %f, %f, %f);", InfoMappingInGameByRefki[idx][TypeObjectID], InfoMappingInGameByRefki[idx][PosisiObjectX], InfoMappingInGameByRefki[idx][PosisiObjectY], InfoMappingInGameByRefki[idx][PosisiObjectZ], InfoMappingInGameByRefki[idx][PosisiObjectRotX], InfoMappingInGameByRefki[idx][PosisiObjectRotY], InfoMappingInGameByRefki[idx][PosisiObjectRotZ]);
	SendClientMessage(playerid, 0xFFFFFFFF, string);
	
	return 1;
}

CMD:objectgoto(playerid, params[])
{
    new idx, string[128];
	if(sscanf(params, "i", idx)) return SendClientMessage(playerid, 0xFFFFFFFF, "PENGGUNAAN CMD: /objectgoto [Object ID]");
	if(!InfoMappingInGameByRefki[idx][TypeObjectID]) return SendClientMessage(playerid, 0xFFFFFFFF, "ID Object Tidak Valid Atau Tidak Ada Di Server");
	SetPlayerPos(playerid, InfoMappingInGameByRefki[idx][PosisiObjectX]+2, InfoMappingInGameByRefki[idx][PosisiObjectY]+2, InfoMappingInGameByRefki[idx][PosisiObjectZ]);
	SendClientMessage(playerid, 0xFFFFFFFF, "{0000ff}[]===================================|| {00ff00}Mapping In Game By Refki{0000ff} ||===================================[]");
	format(string, sizeof(string), "Anda telah berteleportasi ke Object ID {00ff00}%d.", idx);
	SendClientMessage(playerid, 0xFFFFFFFF, string);
	return 1;
}

CMD:objectselect(playerid ,params[])
{
    new id, string[256];
    if(sscanf(params, "i", id)) return SendClientMessage(playerid, 0xFFFFFFFF, "PENGGUNAAN CMD: /objectselect [Object ID]");
    if(!InfoMappingInGameByRefki[id][TypeObjectID]) return SendClientMessage(playerid, 0xFFFFFFFF, "ID Object Tidak Valid Atau Tidak Ada Di Server");
    {
		PlayerInfo[playerid][pSelectedId] = id;
		SendClientMessage(playerid, 0xFFFFFFFF, "{0000ff}[]===================================|| {00ff00}Mapping In Game By Refki{0000ff} ||===================================[]");
		format(string, sizeof(string), "{00ff00}Anda Berhasil Men Select Object ID:{ffffff} %d.", id);
		SendClientMessage(playerid, 0xFFFFFFFF, string);
	}
	return 1;
}

CMD:gotocoords(playerid, params[])
{
	new Float:x, Float:y, Float:z, interiorid;
	if(sscanf(params, "fffI(0)", x, y, z, interiorid))
	{
	    return SendClientMessage(playerid, -1, "Usage: /gotocoords [x] [y] [z] [int (optional)]");
	}
	SetPlayerPos(playerid, x, y, z);
	SetPlayerInterior(playerid, interiorid);
	return 1;
}

CMD:objecthelp(playerid)
{
    ShowHelp1(playerid);
	return 1;
}

CMD:removebuilding(playerid, params[])
{
	new str[128], idobj, Float:x, Float:y, Float:z, distance;
    if(sscanf(params, "ifffd", idobj, x, y, z, distance)) return SendClientMessage(playerid, 0xFFFF0000, "{00ff00}INFO: {0000cc}USAGE: /removebuilding [{ffff00}Id Object{0000cc}] [{ffff00}Pos X{0000cc}] [{ffff00}Pos Y{0000cc}] [{ffff00}Pos Z{0000cc}] [{ffff00}Distance{0000cc}]");
    {
		for(new i; i < MAX_PLAYERS; i ++)
		{
			RemoveBuildingForPlayer(i, idobj, x, y, z, distance);
		}
		format(str,256,"\nRemoveBuildingForPlayer(playerid, %d, %f, %f, %f, %d);",idobj, x, y, z, distance);
	    SendClientMessage(playerid,-1 ,str);
	    SendClientMessage(playerid, -1 ,"{00ff00}INFO: {ffffff}Ambil Code RemoveBuildingForPlayer Itu Di RemoveBuildingFromServer.cfg Jika Ingin Di Save Atau Di Tanam Di GM");
	    new File:fhandle;
	    fhandle = fopen("RemoveBuildingFromServer.cfg",io_append);
	    fwrite(fhandle,str);
	    fclose(fhandle);
    }
	return 1;
}

CMD:mypos(playerid, params[])
{
    new myString2[128], Float:x, Float:y, Float:z;
    GetPlayerPos(playerid, x, y, z);
    format(myString2, sizeof(myString2), "Your position is: %f, %f, %f", x, y, z);
    SendClientMessage(playerid, 0xFFFFFFFF, myString2);
    return 1;
}

CMD:offsetposx(playerid, params[])
{
	new Float:offset, string[128];
	if(PlayerInfo[playerid][pSelectedId] == -1) return SendClientMessage(playerid, -1, "{ff0000}ERROR: {ffffff}Anda Belum Men Select ID Object Manapun");
    if(sscanf(params, "f", offset))
	{
		SendClientMessage(playerid, 0xFFFF0000, "{00ff00}INFO: {0000cc}PENGGUNAAN CMD: /offsetposx [{ffff00}value{0000cc}]");
	}
	InfoMappingInGameByRefki[PlayerInfo[playerid][pSelectedId]][PosisiObjectX] += offset;
	DestroyDynamicObject(InfoMappingInGameByRefki[PlayerInfo[playerid][pSelectedId]][ObjectID]);
	InfoMappingInGameByRefki[PlayerInfo[playerid][pSelectedId]][ObjectID] = CreateDynamicObject(InfoMappingInGameByRefki[PlayerInfo[playerid][pSelectedId]][TypeObjectID], InfoMappingInGameByRefki[PlayerInfo[playerid][pSelectedId]][PosisiObjectX], InfoMappingInGameByRefki[PlayerInfo[playerid][pSelectedId]][PosisiObjectY], InfoMappingInGameByRefki[PlayerInfo[playerid][pSelectedId]][PosisiObjectZ], InfoMappingInGameByRefki[PlayerInfo[playerid][pSelectedId]][PosisiObjectRotX], InfoMappingInGameByRefki[PlayerInfo[playerid][pSelectedId]][PosisiObjectRotY], InfoMappingInGameByRefki[PlayerInfo[playerid][pSelectedId]][PosisiObjectRotZ], 0, 0);
	DestroyDynamic3DTextLabel(InfoMappingInGameByRefki[PlayerInfo[playerid][pSelectedId]][ObjectTextId]);
	format(string, sizeof(string), "{ff6600}Index: {33cc33}%d", PlayerInfo[playerid][pSelectedId]);
	InfoMappingInGameByRefki[PlayerInfo[playerid][pSelectedId]][ObjectTextId] = CreateDynamic3DTextLabel(string, -1, InfoMappingInGameByRefki[PlayerInfo[playerid][pSelectedId]][PosisiObjectX], InfoMappingInGameByRefki[PlayerInfo[playerid][pSelectedId]][PosisiObjectY], InfoMappingInGameByRefki[PlayerInfo[playerid][pSelectedId]][PosisiObjectZ]+0.5, 1.0);
	SendClientMessage(playerid, 0xFFFFFFFF, "{0000ff}[]===================================|| {00ff00}Mapping In Game By Refki{0000ff} ||===================================[]");
	format(string, sizeof(string), "Anda telah Menambah Offset Posisi X{00ff00} ID Object %d {ffffff}Dengan Value %f", PlayerInfo[playerid][pSelectedId], offset); 
	SendClientMessage(playerid, 0xFFFFFFFF, string);
	format(string, sizeof(string), "Sekarang Posisi X{00ff00} ID Object %d Adalah: {ffffff}%f", PlayerInfo[playerid][pSelectedId], InfoMappingInGameByRefki[PlayerInfo[playerid][pSelectedId]][PosisiObjectX]); 
	SendClientMessage(playerid, 0xFFFFFFFF, string);
	format(string, sizeof(string), "Sekarang Posisi Object{00ff00} ID %d {ffffff}Adalah:{00ff00} %f || %f || %f", PlayerInfo[playerid][pSelectedId], InfoMappingInGameByRefki[PlayerInfo[playerid][pSelectedId]][PosisiObjectX], InfoMappingInGameByRefki[PlayerInfo[playerid][pSelectedId]][PosisiObjectY], InfoMappingInGameByRefki[PlayerInfo[playerid][pSelectedId]][PosisiObjectZ]); 
	SendClientMessage(playerid, 0xFFFFFFFF, string);
	SaveMappingInGameByRefki();
  	return 1;
}

CMD:offsetposy(playerid, params[])
{
	new Float:offset, string[128];
	if(PlayerInfo[playerid][pSelectedId] == -1) return SendClientMessage(playerid, -1, "{ff0000}ERROR: {ffffff}Anda Belum Men Select ID Object Manapun");
    if(sscanf(params, "f", offset))
	{
		SendClientMessage(playerid, 0xFFFF0000, "{00ff00}INFO: {0000cc}PENGGUNAAN CMD: /offsetposy [{ffff00}value{0000cc}]");
	}
	InfoMappingInGameByRefki[PlayerInfo[playerid][pSelectedId]][PosisiObjectY] += offset;
	DestroyDynamicObject(InfoMappingInGameByRefki[PlayerInfo[playerid][pSelectedId]][ObjectID]);
	InfoMappingInGameByRefki[PlayerInfo[playerid][pSelectedId]][ObjectID] = CreateDynamicObject(InfoMappingInGameByRefki[PlayerInfo[playerid][pSelectedId]][TypeObjectID], InfoMappingInGameByRefki[PlayerInfo[playerid][pSelectedId]][PosisiObjectX], InfoMappingInGameByRefki[PlayerInfo[playerid][pSelectedId]][PosisiObjectY], InfoMappingInGameByRefki[PlayerInfo[playerid][pSelectedId]][PosisiObjectZ], InfoMappingInGameByRefki[PlayerInfo[playerid][pSelectedId]][PosisiObjectRotX], InfoMappingInGameByRefki[PlayerInfo[playerid][pSelectedId]][PosisiObjectRotY], InfoMappingInGameByRefki[PlayerInfo[playerid][pSelectedId]][PosisiObjectRotZ], 0, 0);
	DestroyDynamic3DTextLabel(InfoMappingInGameByRefki[PlayerInfo[playerid][pSelectedId]][ObjectTextId]);
	format(string, sizeof(string), "{ff6600}Index: {33cc33}%d", PlayerInfo[playerid][pSelectedId]);
	InfoMappingInGameByRefki[PlayerInfo[playerid][pSelectedId]][ObjectTextId] = CreateDynamic3DTextLabel(string, -1, InfoMappingInGameByRefki[PlayerInfo[playerid][pSelectedId]][PosisiObjectX], InfoMappingInGameByRefki[PlayerInfo[playerid][pSelectedId]][PosisiObjectY], InfoMappingInGameByRefki[PlayerInfo[playerid][pSelectedId]][PosisiObjectZ]+0.5, 1.0);
	SendClientMessage(playerid, 0xFFFFFFFF, "{0000ff}[]===================================|| {00ff00}Mapping In Game By Refki{0000ff} ||===================================[]");
    format(string, sizeof(string), "Anda telah Menambah Offset Posisi Y{00ff00} ID Object %d {ffffff}Dengan Value %f", PlayerInfo[playerid][pSelectedId], offset);
	SendClientMessage(playerid, 0xFFFFFFFF, string);
	format(string, sizeof(string), "Sekarang Posisi Y{00ff00} ID Object %d Adalah: {ffffff}%f", PlayerInfo[playerid][pSelectedId], InfoMappingInGameByRefki[PlayerInfo[playerid][pSelectedId]][PosisiObjectY]); 
	SendClientMessage(playerid, 0xFFFFFFFF, string);
	format(string, sizeof(string), "Sekarang Posisi Object{00ff00} ID %d {ffffff}Adalah:{00ff00} %f || %f || %f", PlayerInfo[playerid][pSelectedId], InfoMappingInGameByRefki[PlayerInfo[playerid][pSelectedId]][PosisiObjectX], InfoMappingInGameByRefki[PlayerInfo[playerid][pSelectedId]][PosisiObjectY], InfoMappingInGameByRefki[PlayerInfo[playerid][pSelectedId]][PosisiObjectZ]); 
	SendClientMessage(playerid, 0xFFFFFFFF, string);
	SaveMappingInGameByRefki();
  	return 1;
}

CMD:offsetposz(playerid, params[])
{
	new Float:offset, string[128];
	if(PlayerInfo[playerid][pSelectedId] == -1) return SendClientMessage(playerid, -1, "{ff0000}ERROR: {ffffff}Anda Belum Men Select ID Object Manapun");
    if(sscanf(params, "f", offset))
	{
		SendClientMessage(playerid, 0xFFFF0000, "{00ff00}INFO: {0000cc}PENGGUNAAN CMD: /offsetposy [{ffff00}value{0000cc}]");
	}
	InfoMappingInGameByRefki[PlayerInfo[playerid][pSelectedId]][PosisiObjectZ] += offset;
	DestroyDynamicObject(InfoMappingInGameByRefki[PlayerInfo[playerid][pSelectedId]][ObjectID]);
	InfoMappingInGameByRefki[PlayerInfo[playerid][pSelectedId]][ObjectID] = CreateDynamicObject(InfoMappingInGameByRefki[PlayerInfo[playerid][pSelectedId]][TypeObjectID], InfoMappingInGameByRefki[PlayerInfo[playerid][pSelectedId]][PosisiObjectX], InfoMappingInGameByRefki[PlayerInfo[playerid][pSelectedId]][PosisiObjectY], InfoMappingInGameByRefki[PlayerInfo[playerid][pSelectedId]][PosisiObjectZ], InfoMappingInGameByRefki[PlayerInfo[playerid][pSelectedId]][PosisiObjectRotX], InfoMappingInGameByRefki[PlayerInfo[playerid][pSelectedId]][PosisiObjectRotY], InfoMappingInGameByRefki[PlayerInfo[playerid][pSelectedId]][PosisiObjectRotZ], 0, 0);
	DestroyDynamic3DTextLabel(InfoMappingInGameByRefki[PlayerInfo[playerid][pSelectedId]][ObjectTextId]);
	format(string, sizeof(string), "{ff6600}Index: {33cc33}%d", PlayerInfo[playerid][pSelectedId]);
	InfoMappingInGameByRefki[PlayerInfo[playerid][pSelectedId]][ObjectTextId] = CreateDynamic3DTextLabel(string, -1, InfoMappingInGameByRefki[PlayerInfo[playerid][pSelectedId]][PosisiObjectX], InfoMappingInGameByRefki[PlayerInfo[playerid][pSelectedId]][PosisiObjectY], InfoMappingInGameByRefki[PlayerInfo[playerid][pSelectedId]][PosisiObjectZ]+0.5, 1.0);
	SendClientMessage(playerid, 0xFFFFFFFF, "{0000ff}[]===================================|| {00ff00}Mapping In Game By Refki{0000ff} ||===================================[]");
    format(string, sizeof(string), "Anda telah Menambah Offset Posisi Z{00ff00} ID Object %d {ffffff}Dengan Value %f", PlayerInfo[playerid][pSelectedId], offset);
	SendClientMessage(playerid, 0xFFFFFFFF, string);
	format(string, sizeof(string), "Sekarang Posisi Z{00ff00} ID Object %d Adalah: {ffffff}%f", PlayerInfo[playerid][pSelectedId], InfoMappingInGameByRefki[PlayerInfo[playerid][pSelectedId]][PosisiObjectZ]); 
	SendClientMessage(playerid, 0xFFFFFFFF, string);
	format(string, sizeof(string), "Sekarang Posisi Object{00ff00} ID %d {ffffff}Adalah:{00ff00} %f || %f || %f", PlayerInfo[playerid][pSelectedId], InfoMappingInGameByRefki[PlayerInfo[playerid][pSelectedId]][PosisiObjectX], InfoMappingInGameByRefki[PlayerInfo[playerid][pSelectedId]][PosisiObjectY], InfoMappingInGameByRefki[PlayerInfo[playerid][pSelectedId]][PosisiObjectZ]); 
	SendClientMessage(playerid, 0xFFFFFFFF, string);
	SaveMappingInGameByRefki();
  	return 1;
}

CMD:offsetrotx(playerid, params[])
{
	new Float:offset, string[128];
	if(PlayerInfo[playerid][pSelectedId] == -1) return SendClientMessage(playerid, -1, "{ff0000}ERROR: {ffffff}Anda Belum Men Select ID Object Manapun");
    if(sscanf(params, "f", offset))
	{
		SendClientMessage(playerid, 0xFFFF0000, "{00ff00}INFO: {0000cc}PENGGUNAAN CMD: /offsetrosx [{ffff00}value{0000cc}]");
	}
	InfoMappingInGameByRefki[PlayerInfo[playerid][pSelectedId]][PosisiObjectRotX] += offset;
	DestroyDynamicObject(InfoMappingInGameByRefki[PlayerInfo[playerid][pSelectedId]][ObjectID]);
	InfoMappingInGameByRefki[PlayerInfo[playerid][pSelectedId]][ObjectID] = CreateDynamicObject(InfoMappingInGameByRefki[PlayerInfo[playerid][pSelectedId]][TypeObjectID], InfoMappingInGameByRefki[PlayerInfo[playerid][pSelectedId]][PosisiObjectX], InfoMappingInGameByRefki[PlayerInfo[playerid][pSelectedId]][PosisiObjectY], InfoMappingInGameByRefki[PlayerInfo[playerid][pSelectedId]][PosisiObjectZ], InfoMappingInGameByRefki[PlayerInfo[playerid][pSelectedId]][PosisiObjectRotX], InfoMappingInGameByRefki[PlayerInfo[playerid][pSelectedId]][PosisiObjectRotY], InfoMappingInGameByRefki[PlayerInfo[playerid][pSelectedId]][PosisiObjectRotZ], 0, 0);
	DestroyDynamic3DTextLabel(InfoMappingInGameByRefki[PlayerInfo[playerid][pSelectedId]][ObjectTextId]);
	format(string, sizeof(string), "{ff6600}Index: {33cc33}%d", PlayerInfo[playerid][pSelectedId]);
	InfoMappingInGameByRefki[PlayerInfo[playerid][pSelectedId]][ObjectTextId] = CreateDynamic3DTextLabel(string, -1, InfoMappingInGameByRefki[PlayerInfo[playerid][pSelectedId]][PosisiObjectX], InfoMappingInGameByRefki[PlayerInfo[playerid][pSelectedId]][PosisiObjectY], InfoMappingInGameByRefki[PlayerInfo[playerid][pSelectedId]][PosisiObjectZ]+0.5, 1.0);
	SendClientMessage(playerid, 0xFFFFFFFF, "{0000ff}[]===================================|| {00ff00}Mapping In Game By Refki{0000ff} ||===================================[]");
    format(string, sizeof(string), "Anda telah Menambah Offset Rotate X{00ff00} ID Object %d {ffffff}Dengan Value %f", PlayerInfo[playerid][pSelectedId], offset);
	SendClientMessage(playerid, 0xFFFFFFFF, string);
	format(string, sizeof(string), "Sekarang Rotate X{00ff00} ID Object %d Adalah: {ffffff}%f", PlayerInfo[playerid][pSelectedId], InfoMappingInGameByRefki[PlayerInfo[playerid][pSelectedId]][PosisiObjectRotX]); 
	SendClientMessage(playerid, 0xFFFFFFFF, string);
	format(string, sizeof(string), "Sekarang Rotate Object{00ff00} ID %d {ffffff}Adalah:{00ff00} %f || %f || %f", PlayerInfo[playerid][pSelectedId], InfoMappingInGameByRefki[PlayerInfo[playerid][pSelectedId]][PosisiObjectRotX], InfoMappingInGameByRefki[PlayerInfo[playerid][pSelectedId]][PosisiObjectRotY], InfoMappingInGameByRefki[PlayerInfo[playerid][pSelectedId]][PosisiObjectRotZ]); 
	SendClientMessage(playerid, 0xFFFFFFFF, string);
	SaveMappingInGameByRefki();
  	return 1;
}

CMD:offsetroty(playerid, params[])
{
	new Float:offset, string[128];
	if(PlayerInfo[playerid][pSelectedId] == -1) return SendClientMessage(playerid, -1, "{ff0000}ERROR: {ffffff}Anda Belum Men Select ID Object Manapun");
    if(sscanf(params, "f", offset))
	{
		SendClientMessage(playerid, 0xFFFF0000, "{00ff00}INFO: {0000cc}PENGGUNAAN CMD: /offsetroty [{ffff00}value{0000cc}]");
	}
	InfoMappingInGameByRefki[PlayerInfo[playerid][pSelectedId]][PosisiObjectRotY] += offset;
	DestroyDynamicObject(InfoMappingInGameByRefki[PlayerInfo[playerid][pSelectedId]][ObjectID]);
	InfoMappingInGameByRefki[PlayerInfo[playerid][pSelectedId]][ObjectID] = CreateDynamicObject(InfoMappingInGameByRefki[PlayerInfo[playerid][pSelectedId]][TypeObjectID], InfoMappingInGameByRefki[PlayerInfo[playerid][pSelectedId]][PosisiObjectX], InfoMappingInGameByRefki[PlayerInfo[playerid][pSelectedId]][PosisiObjectY], InfoMappingInGameByRefki[PlayerInfo[playerid][pSelectedId]][PosisiObjectZ], InfoMappingInGameByRefki[PlayerInfo[playerid][pSelectedId]][PosisiObjectRotX], InfoMappingInGameByRefki[PlayerInfo[playerid][pSelectedId]][PosisiObjectRotY], InfoMappingInGameByRefki[PlayerInfo[playerid][pSelectedId]][PosisiObjectRotZ], 0, 0);
	DestroyDynamic3DTextLabel(InfoMappingInGameByRefki[PlayerInfo[playerid][pSelectedId]][ObjectTextId]);
	format(string, sizeof(string), "{ff6600}Index: {33cc33}%d", PlayerInfo[playerid][pSelectedId]);
	InfoMappingInGameByRefki[PlayerInfo[playerid][pSelectedId]][ObjectTextId] = CreateDynamic3DTextLabel(string, -1, InfoMappingInGameByRefki[PlayerInfo[playerid][pSelectedId]][PosisiObjectX], InfoMappingInGameByRefki[PlayerInfo[playerid][pSelectedId]][PosisiObjectY], InfoMappingInGameByRefki[PlayerInfo[playerid][pSelectedId]][PosisiObjectZ]+0.5, 1.0);
	SendClientMessage(playerid, 0xFFFFFFFF, "{0000ff}[]===================================|| {00ff00}Mapping In Game By Refki{0000ff} ||===================================[]");
    format(string, sizeof(string), "Anda telah Menambah Offset Rotate Y{00ff00} ID Object %d {ffffff}Dengan Value %f", PlayerInfo[playerid][pSelectedId], offset);
	SendClientMessage(playerid, 0xFFFFFFFF, string);
	format(string, sizeof(string), "Sekarang Rotate Y{00ff00} ID Object %d Adalah: {ffffff}%f", PlayerInfo[playerid][pSelectedId], InfoMappingInGameByRefki[PlayerInfo[playerid][pSelectedId]][PosisiObjectRotY]); 
	SendClientMessage(playerid, 0xFFFFFFFF, string);
	format(string, sizeof(string), "Sekarang Rotate Object{00ff00} ID %d {ffffff}Adalah:{00ff00} %f || %f || %f", PlayerInfo[playerid][pSelectedId], InfoMappingInGameByRefki[PlayerInfo[playerid][pSelectedId]][PosisiObjectRotX], InfoMappingInGameByRefki[PlayerInfo[playerid][pSelectedId]][PosisiObjectRotY], InfoMappingInGameByRefki[PlayerInfo[playerid][pSelectedId]][PosisiObjectRotZ]); 
	SendClientMessage(playerid, 0xFFFFFFFF, string);
	
	SaveMappingInGameByRefki();
  	return 1;
}

CMD:offsetrotz(playerid, params[])
{
	new Float:offset, string[128];
	if(PlayerInfo[playerid][pSelectedId] == -1) return SendClientMessage(playerid, -1, "{ff0000}ERROR: {ffffff}Anda Belum Men Select ID Object Manapun");
    if(sscanf(params, "f", offset))
	{
		SendClientMessage(playerid, 0xFFFF0000, "{00ff00}INFO: {0000cc}PENGGUNAAN CMD: /offsetrotz [{ffff00}value{0000cc}]");
	}
	InfoMappingInGameByRefki[PlayerInfo[playerid][pSelectedId]][PosisiObjectRotZ] += offset;
	DestroyDynamicObject(InfoMappingInGameByRefki[PlayerInfo[playerid][pSelectedId]][ObjectID]);
	InfoMappingInGameByRefki[PlayerInfo[playerid][pSelectedId]][ObjectID] = CreateDynamicObject(InfoMappingInGameByRefki[PlayerInfo[playerid][pSelectedId]][TypeObjectID], InfoMappingInGameByRefki[PlayerInfo[playerid][pSelectedId]][PosisiObjectX], InfoMappingInGameByRefki[PlayerInfo[playerid][pSelectedId]][PosisiObjectY], InfoMappingInGameByRefki[PlayerInfo[playerid][pSelectedId]][PosisiObjectZ], InfoMappingInGameByRefki[PlayerInfo[playerid][pSelectedId]][PosisiObjectRotX], InfoMappingInGameByRefki[PlayerInfo[playerid][pSelectedId]][PosisiObjectRotY], InfoMappingInGameByRefki[PlayerInfo[playerid][pSelectedId]][PosisiObjectRotZ], 0, 0);
	DestroyDynamic3DTextLabel(InfoMappingInGameByRefki[PlayerInfo[playerid][pSelectedId]][ObjectTextId]);
	format(string, sizeof(string), "{ff6600}Index: {33cc33}%d", PlayerInfo[playerid][pSelectedId]);
	InfoMappingInGameByRefki[PlayerInfo[playerid][pSelectedId]][ObjectTextId] = CreateDynamic3DTextLabel(string, -1, InfoMappingInGameByRefki[PlayerInfo[playerid][pSelectedId]][PosisiObjectX], InfoMappingInGameByRefki[PlayerInfo[playerid][pSelectedId]][PosisiObjectY], InfoMappingInGameByRefki[PlayerInfo[playerid][pSelectedId]][PosisiObjectZ]+0.5, 1.0);
	SendClientMessage(playerid, 0xFFFFFFFF, "{0000ff}[]===================================|| {00ff00}Mapping In Game By Refki{0000ff} ||===================================[]");
    format(string, sizeof(string), "Anda telah Menambah Offset Rotate Z{00ff00} ID Object %d {ffffff}Dengan Value %f", PlayerInfo[playerid][pSelectedId], offset);
	SendClientMessage(playerid, 0xFFFFFFFF, string);
	format(string, sizeof(string), "Sekarang Rotate Z{00ff00} ID Object %d Adalah: {ffffff}%f", PlayerInfo[playerid][pSelectedId], InfoMappingInGameByRefki[PlayerInfo[playerid][pSelectedId]][PosisiObjectRotZ]); 
	SendClientMessage(playerid, 0xFFFFFFFF, string);
	format(string, sizeof(string), "Sekarang Rotate Object{00ff00} ID %d {ffffff}Adalah:{00ff00} %f || %f || %f", PlayerInfo[playerid][pSelectedId], InfoMappingInGameByRefki[PlayerInfo[playerid][pSelectedId]][PosisiObjectRotX], InfoMappingInGameByRefki[PlayerInfo[playerid][pSelectedId]][PosisiObjectRotY], InfoMappingInGameByRefki[PlayerInfo[playerid][pSelectedId]][PosisiObjectRotZ]); 
	SendClientMessage(playerid, 0xFFFFFFFF, string);
	SaveMappingInGameByRefki();
  	return 1;
}

CMD:setpx(playerid, params[])
{
	new Float:offset, string[128];
	if(PlayerInfo[playerid][pSelectedId] == -1) return SendClientMessage(playerid, -1, "{ff0000}ERROR: {ffffff}Anda Belum Men Select ID Object Manapun");
    if(sscanf(params, "f", offset))
	{
		SendClientMessage(playerid, 0xFFFF0000, "{00ff00}INFO: {0000cc}PENGGUNAAN CMD: /setpx [{ffff00}value{0000cc}]");
	}
	InfoMappingInGameByRefki[PlayerInfo[playerid][pSelectedId]][PosisiObjectX] = offset;
	DestroyDynamicObject(InfoMappingInGameByRefki[PlayerInfo[playerid][pSelectedId]][ObjectID]);
	InfoMappingInGameByRefki[PlayerInfo[playerid][pSelectedId]][ObjectID] = CreateDynamicObject(InfoMappingInGameByRefki[PlayerInfo[playerid][pSelectedId]][TypeObjectID], InfoMappingInGameByRefki[PlayerInfo[playerid][pSelectedId]][PosisiObjectX], InfoMappingInGameByRefki[PlayerInfo[playerid][pSelectedId]][PosisiObjectY], InfoMappingInGameByRefki[PlayerInfo[playerid][pSelectedId]][PosisiObjectZ], InfoMappingInGameByRefki[PlayerInfo[playerid][pSelectedId]][PosisiObjectRotX], InfoMappingInGameByRefki[PlayerInfo[playerid][pSelectedId]][PosisiObjectRotY], InfoMappingInGameByRefki[PlayerInfo[playerid][pSelectedId]][PosisiObjectRotZ], 0, 0);
	DestroyDynamic3DTextLabel(InfoMappingInGameByRefki[PlayerInfo[playerid][pSelectedId]][ObjectTextId]);
	format(string, sizeof(string), "{ff6600}Index: {33cc33}%d", PlayerInfo[playerid][pSelectedId]);
	InfoMappingInGameByRefki[PlayerInfo[playerid][pSelectedId]][ObjectTextId] = CreateDynamic3DTextLabel(string, -1, InfoMappingInGameByRefki[PlayerInfo[playerid][pSelectedId]][PosisiObjectX], InfoMappingInGameByRefki[PlayerInfo[playerid][pSelectedId]][PosisiObjectY], InfoMappingInGameByRefki[PlayerInfo[playerid][pSelectedId]][PosisiObjectZ]+0.5, 1.0);
	SendClientMessage(playerid, 0xFFFFFFFF, "{0000ff}[]===================================|| {00ff00}Mapping In Game By Refki{0000ff} ||===================================[]");
    format(string, sizeof(string), "Anda telah Menambah Offset Posisi X{00ff00} ID Object %d {ffffff}Dengan Value %f", PlayerInfo[playerid][pSelectedId], offset); 
	SendClientMessage(playerid, 0xFFFFFFFF, string);
	format(string, sizeof(string), "Sekarang Posisi Object{00ff00} ID %d {ffffff}Adalah:{00ff00} %f || %f || %f", PlayerInfo[playerid][pSelectedId], InfoMappingInGameByRefki[PlayerInfo[playerid][pSelectedId]][PosisiObjectX], InfoMappingInGameByRefki[PlayerInfo[playerid][pSelectedId]][PosisiObjectY], InfoMappingInGameByRefki[PlayerInfo[playerid][pSelectedId]][PosisiObjectZ]); 
	SendClientMessage(playerid, 0xFFFFFFFF, string);
	SaveMappingInGameByRefki();
  	return 1;
}

CMD:setpy(playerid, params[])
{
	new Float:offset, string[128];
	if(PlayerInfo[playerid][pSelectedId] == -1) return SendClientMessage(playerid, -1, "{ff0000}ERROR: {ffffff}Anda Belum Men Select ID Object Manapun");
    if(sscanf(params, "f", offset))
	{
		SendClientMessage(playerid, 0xFFFF0000, "{00ff00}INFO: {0000cc}PENGGUNAAN CMD: /setpy [{ffff00}value{0000cc}]");
	}
	InfoMappingInGameByRefki[PlayerInfo[playerid][pSelectedId]][PosisiObjectY] = offset;
	DestroyDynamicObject(InfoMappingInGameByRefki[PlayerInfo[playerid][pSelectedId]][ObjectID]);
	InfoMappingInGameByRefki[PlayerInfo[playerid][pSelectedId]][ObjectID] = CreateDynamicObject(InfoMappingInGameByRefki[PlayerInfo[playerid][pSelectedId]][TypeObjectID], InfoMappingInGameByRefki[PlayerInfo[playerid][pSelectedId]][PosisiObjectX], InfoMappingInGameByRefki[PlayerInfo[playerid][pSelectedId]][PosisiObjectY], InfoMappingInGameByRefki[PlayerInfo[playerid][pSelectedId]][PosisiObjectZ], InfoMappingInGameByRefki[PlayerInfo[playerid][pSelectedId]][PosisiObjectRotX], InfoMappingInGameByRefki[PlayerInfo[playerid][pSelectedId]][PosisiObjectRotY], InfoMappingInGameByRefki[PlayerInfo[playerid][pSelectedId]][PosisiObjectRotZ], 0, 0);
	DestroyDynamic3DTextLabel(InfoMappingInGameByRefki[PlayerInfo[playerid][pSelectedId]][ObjectTextId]);
	format(string, sizeof(string), "{ff6600}Index: {33cc33}%d", PlayerInfo[playerid][pSelectedId]);
	InfoMappingInGameByRefki[PlayerInfo[playerid][pSelectedId]][ObjectTextId] = CreateDynamic3DTextLabel(string, -1, InfoMappingInGameByRefki[PlayerInfo[playerid][pSelectedId]][PosisiObjectX], InfoMappingInGameByRefki[PlayerInfo[playerid][pSelectedId]][PosisiObjectY], InfoMappingInGameByRefki[PlayerInfo[playerid][pSelectedId]][PosisiObjectZ]+0.5, 1.0);
	SendClientMessage(playerid, 0xFFFFFFFF, "{0000ff}[]===================================|| {00ff00}Mapping In Game By Refki{0000ff} ||===================================[]");
    format(string, sizeof(string), "Anda telah Menambah Offset Posisi Y{00ff00} ID Object %d {ffffff}Dengan Value %f", PlayerInfo[playerid][pSelectedId], offset);
	SendClientMessage(playerid, 0xFFFFFFFF, string);
	format(string, sizeof(string), "Sekarang Posisi Object{00ff00} ID %d {ffffff}Adalah:{00ff00} %f || %f || %f", PlayerInfo[playerid][pSelectedId], InfoMappingInGameByRefki[PlayerInfo[playerid][pSelectedId]][PosisiObjectX], InfoMappingInGameByRefki[PlayerInfo[playerid][pSelectedId]][PosisiObjectY], InfoMappingInGameByRefki[PlayerInfo[playerid][pSelectedId]][PosisiObjectZ]); 
	SendClientMessage(playerid, 0xFFFFFFFF, string);
	SaveMappingInGameByRefki();
  	return 1;
}

CMD:setpz(playerid, params[])
{
	new Float:offset, string[128];
	if(PlayerInfo[playerid][pSelectedId] == -1) return SendClientMessage(playerid, -1, "{ff0000}ERROR: {ffffff}Anda Belum Men Select ID Object Manapun");
    if(sscanf(params, "f", offset))
	{
		SendClientMessage(playerid, 0xFFFF0000, "{00ff00}INFO: {0000cc}PENGGUNAAN CMD: /setpz [{ffff00}value{0000cc}]");
	}
	InfoMappingInGameByRefki[PlayerInfo[playerid][pSelectedId]][PosisiObjectZ] = offset;
	DestroyDynamicObject(InfoMappingInGameByRefki[PlayerInfo[playerid][pSelectedId]][ObjectID]);
	InfoMappingInGameByRefki[PlayerInfo[playerid][pSelectedId]][ObjectID] = CreateDynamicObject(InfoMappingInGameByRefki[PlayerInfo[playerid][pSelectedId]][TypeObjectID], InfoMappingInGameByRefki[PlayerInfo[playerid][pSelectedId]][PosisiObjectX], InfoMappingInGameByRefki[PlayerInfo[playerid][pSelectedId]][PosisiObjectY], InfoMappingInGameByRefki[PlayerInfo[playerid][pSelectedId]][PosisiObjectZ], InfoMappingInGameByRefki[PlayerInfo[playerid][pSelectedId]][PosisiObjectRotX], InfoMappingInGameByRefki[PlayerInfo[playerid][pSelectedId]][PosisiObjectRotY], InfoMappingInGameByRefki[PlayerInfo[playerid][pSelectedId]][PosisiObjectRotZ], 0, 0);
	DestroyDynamic3DTextLabel(InfoMappingInGameByRefki[PlayerInfo[playerid][pSelectedId]][ObjectTextId]);
	format(string, sizeof(string), "{ff6600}Index: {33cc33}%d", PlayerInfo[playerid][pSelectedId]);
	InfoMappingInGameByRefki[PlayerInfo[playerid][pSelectedId]][ObjectTextId] = CreateDynamic3DTextLabel(string, -1, InfoMappingInGameByRefki[PlayerInfo[playerid][pSelectedId]][PosisiObjectX], InfoMappingInGameByRefki[PlayerInfo[playerid][pSelectedId]][PosisiObjectY], InfoMappingInGameByRefki[PlayerInfo[playerid][pSelectedId]][PosisiObjectZ]+0.5, 1.0);
	SendClientMessage(playerid, 0xFFFFFFFF, "{0000ff}[]===================================|| {00ff00}Mapping In Game By Refki{0000ff} ||===================================[]");
    format(string, sizeof(string), "Anda telah Menambah Offset Posisi Z{00ff00} ID Object %d {ffffff}Dengan Value %f", PlayerInfo[playerid][pSelectedId], offset);
	SendClientMessage(playerid, 0xFFFFFFFF, string);
	format(string, sizeof(string), "Sekarang Posisi Object{00ff00} ID %d {ffffff}Adalah:{00ff00} %f || %f || %f", PlayerInfo[playerid][pSelectedId], InfoMappingInGameByRefki[PlayerInfo[playerid][pSelectedId]][PosisiObjectX], InfoMappingInGameByRefki[PlayerInfo[playerid][pSelectedId]][PosisiObjectY], InfoMappingInGameByRefki[PlayerInfo[playerid][pSelectedId]][PosisiObjectZ]); 
	SendClientMessage(playerid, 0xFFFFFFFF, string);
	SaveMappingInGameByRefki();
  	return 1;
}

CMD:setrx(playerid, params[])
{
	new Float:offset, string[128];
	if(PlayerInfo[playerid][pSelectedId] == -1) return SendClientMessage(playerid, -1, "{ff0000}ERROR: {ffffff}Anda Belum Men Select ID Object Manapun");
    if(sscanf(params, "f", offset))
	{
		SendClientMessage(playerid, 0xFFFF0000, "{00ff00}INFO: {0000cc}PENGGUNAAN CMD: /setrx [{ffff00}value{0000cc}]");
	}
	InfoMappingInGameByRefki[PlayerInfo[playerid][pSelectedId]][PosisiObjectRotX] = offset;
	DestroyDynamicObject(InfoMappingInGameByRefki[PlayerInfo[playerid][pSelectedId]][ObjectID]);
	InfoMappingInGameByRefki[PlayerInfo[playerid][pSelectedId]][ObjectID] = CreateDynamicObject(InfoMappingInGameByRefki[PlayerInfo[playerid][pSelectedId]][TypeObjectID], InfoMappingInGameByRefki[PlayerInfo[playerid][pSelectedId]][PosisiObjectX], InfoMappingInGameByRefki[PlayerInfo[playerid][pSelectedId]][PosisiObjectY], InfoMappingInGameByRefki[PlayerInfo[playerid][pSelectedId]][PosisiObjectZ], InfoMappingInGameByRefki[PlayerInfo[playerid][pSelectedId]][PosisiObjectRotX], InfoMappingInGameByRefki[PlayerInfo[playerid][pSelectedId]][PosisiObjectRotY], InfoMappingInGameByRefki[PlayerInfo[playerid][pSelectedId]][PosisiObjectRotZ], 0, 0);
	DestroyDynamic3DTextLabel(InfoMappingInGameByRefki[PlayerInfo[playerid][pSelectedId]][ObjectTextId]);
	format(string, sizeof(string), "{ff6600}Index: {33cc33}%d", PlayerInfo[playerid][pSelectedId]);
	InfoMappingInGameByRefki[PlayerInfo[playerid][pSelectedId]][ObjectTextId] = CreateDynamic3DTextLabel(string, -1, InfoMappingInGameByRefki[PlayerInfo[playerid][pSelectedId]][PosisiObjectX], InfoMappingInGameByRefki[PlayerInfo[playerid][pSelectedId]][PosisiObjectY], InfoMappingInGameByRefki[PlayerInfo[playerid][pSelectedId]][PosisiObjectZ]+0.5, 1.0);
	SendClientMessage(playerid, 0xFFFFFFFF, "{0000ff}[]===================================|| {00ff00}Mapping In Game By Refki{0000ff} ||===================================[]");
    format(string, sizeof(string), "Anda telah Menambah Offset Rotate X{00ff00} ID Object %d {ffffff}Dengan Value %f", PlayerInfo[playerid][pSelectedId], offset);
	SendClientMessage(playerid, 0xFFFFFFFF, string);
	format(string, sizeof(string), "Sekarang Rotate Object{00ff00} ID %d {ffffff}Adalah:{00ff00} %f || %f || %f", PlayerInfo[playerid][pSelectedId], InfoMappingInGameByRefki[PlayerInfo[playerid][pSelectedId]][PosisiObjectRotX], InfoMappingInGameByRefki[PlayerInfo[playerid][pSelectedId]][PosisiObjectRotY], InfoMappingInGameByRefki[PlayerInfo[playerid][pSelectedId]][PosisiObjectRotZ]); 
	SendClientMessage(playerid, 0xFFFFFFFF, string);
	SaveMappingInGameByRefki();
  	return 1;
}

CMD:setry(playerid, params[])
{
	new Float:offset, string[128];
	if(PlayerInfo[playerid][pSelectedId] == -1) return SendClientMessage(playerid, -1, "{ff0000}ERROR: {ffffff}Anda Belum Men Select ID Object Manapun");
    if(sscanf(params, "f", offset))
	{
		SendClientMessage(playerid, 0xFFFF0000, "{00ff00}INFO: {0000cc}PENGGUNAAN CMD: /setry [{ffff00}value{0000cc}]");
	}
	InfoMappingInGameByRefki[PlayerInfo[playerid][pSelectedId]][PosisiObjectRotY] = offset;
	DestroyDynamicObject(InfoMappingInGameByRefki[PlayerInfo[playerid][pSelectedId]][ObjectID]);
	InfoMappingInGameByRefki[PlayerInfo[playerid][pSelectedId]][ObjectID] = CreateDynamicObject(InfoMappingInGameByRefki[PlayerInfo[playerid][pSelectedId]][TypeObjectID], InfoMappingInGameByRefki[PlayerInfo[playerid][pSelectedId]][PosisiObjectX], InfoMappingInGameByRefki[PlayerInfo[playerid][pSelectedId]][PosisiObjectY], InfoMappingInGameByRefki[PlayerInfo[playerid][pSelectedId]][PosisiObjectZ], InfoMappingInGameByRefki[PlayerInfo[playerid][pSelectedId]][PosisiObjectRotX], InfoMappingInGameByRefki[PlayerInfo[playerid][pSelectedId]][PosisiObjectRotY], InfoMappingInGameByRefki[PlayerInfo[playerid][pSelectedId]][PosisiObjectRotZ], 0, 0);
	DestroyDynamic3DTextLabel(InfoMappingInGameByRefki[PlayerInfo[playerid][pSelectedId]][ObjectTextId]);
	format(string, sizeof(string), "{ff6600}Index: {33cc33}%d", PlayerInfo[playerid][pSelectedId]);
	InfoMappingInGameByRefki[PlayerInfo[playerid][pSelectedId]][ObjectTextId] = CreateDynamic3DTextLabel(string, -1, InfoMappingInGameByRefki[PlayerInfo[playerid][pSelectedId]][PosisiObjectX], InfoMappingInGameByRefki[PlayerInfo[playerid][pSelectedId]][PosisiObjectY], InfoMappingInGameByRefki[PlayerInfo[playerid][pSelectedId]][PosisiObjectZ]+0.5, 1.0);
	SendClientMessage(playerid, 0xFFFFFFFF, "{0000ff}[]===================================|| {00ff00}Mapping In Game By Refki{0000ff} ||===================================[]");
    format(string, sizeof(string), "Anda telah Menambah Offset Rotate Y{00ff00} ID Object %d {ffffff}Dengan Value %f", PlayerInfo[playerid][pSelectedId], offset);
	SendClientMessage(playerid, 0xFFFFFFFF, string);
	format(string, sizeof(string), "Sekarang Rotate Object{00ff00} ID %d {ffffff}Adalah:{00ff00} %f || %f || %f", PlayerInfo[playerid][pSelectedId], InfoMappingInGameByRefki[PlayerInfo[playerid][pSelectedId]][PosisiObjectRotX], InfoMappingInGameByRefki[PlayerInfo[playerid][pSelectedId]][PosisiObjectRotY], InfoMappingInGameByRefki[PlayerInfo[playerid][pSelectedId]][PosisiObjectRotZ]); 
	SendClientMessage(playerid, 0xFFFFFFFF, string);
	SaveMappingInGameByRefki();
  	return 1;
}

CMD:setrz(playerid, params[])
{
	new Float:offset, string[128];
	if(PlayerInfo[playerid][pSelectedId] == -1) return SendClientMessage(playerid, -1, "{ff0000}ERROR: {ffffff}Anda Belum Men Select ID Object Manapun");
    if(sscanf(params, "f", offset))
	{
		SendClientMessage(playerid, 0xFFFF0000, "{00ff00}INFO: {0000cc}PENGGUNAAN CMD: /setrz [{ffff00}value{0000cc}]");
	}
	InfoMappingInGameByRefki[PlayerInfo[playerid][pSelectedId]][PosisiObjectRotZ] = offset;
	DestroyDynamicObject(InfoMappingInGameByRefki[PlayerInfo[playerid][pSelectedId]][ObjectID]);
	InfoMappingInGameByRefki[PlayerInfo[playerid][pSelectedId]][ObjectID] = CreateDynamicObject(InfoMappingInGameByRefki[PlayerInfo[playerid][pSelectedId]][TypeObjectID], InfoMappingInGameByRefki[PlayerInfo[playerid][pSelectedId]][PosisiObjectX], InfoMappingInGameByRefki[PlayerInfo[playerid][pSelectedId]][PosisiObjectY], InfoMappingInGameByRefki[PlayerInfo[playerid][pSelectedId]][PosisiObjectZ], InfoMappingInGameByRefki[PlayerInfo[playerid][pSelectedId]][PosisiObjectRotX], InfoMappingInGameByRefki[PlayerInfo[playerid][pSelectedId]][PosisiObjectRotY], InfoMappingInGameByRefki[PlayerInfo[playerid][pSelectedId]][PosisiObjectRotZ], 0, 0);
	DestroyDynamic3DTextLabel(InfoMappingInGameByRefki[PlayerInfo[playerid][pSelectedId]][ObjectTextId]);
	format(string, sizeof(string), "{ff6600}Index: {33cc33}%d", PlayerInfo[playerid][pSelectedId]);
	InfoMappingInGameByRefki[PlayerInfo[playerid][pSelectedId]][ObjectTextId] = CreateDynamic3DTextLabel(string, -1, InfoMappingInGameByRefki[PlayerInfo[playerid][pSelectedId]][PosisiObjectX], InfoMappingInGameByRefki[PlayerInfo[playerid][pSelectedId]][PosisiObjectY], InfoMappingInGameByRefki[PlayerInfo[playerid][pSelectedId]][PosisiObjectZ]+0.5, 1.0);
	SendClientMessage(playerid, 0xFFFFFFFF, "{0000ff}[]===================================|| {00ff00}Mapping In Game By Refki{0000ff} ||===================================[]");
    format(string, sizeof(string), "Anda telah Menambah Offset Rotate Z{00ff00} ID Object %d {ffffff}Dengan Value %f", PlayerInfo[playerid][pSelectedId], offset);
	SendClientMessage(playerid, 0xFFFFFFFF, string);
	format(string, sizeof(string), "Sekarang Rotate Object{00ff00} ID %d {ffffff}Adalah:{00ff00} %f || %f || %f", PlayerInfo[playerid][pSelectedId], InfoMappingInGameByRefki[PlayerInfo[playerid][pSelectedId]][PosisiObjectRotX], InfoMappingInGameByRefki[PlayerInfo[playerid][pSelectedId]][PosisiObjectRotY], InfoMappingInGameByRefki[PlayerInfo[playerid][pSelectedId]][PosisiObjectRotZ]); 
	SendClientMessage(playerid, 0xFFFFFFFF, string);
	SaveMappingInGameByRefki();
  	return 1;
}
