/*
Dynamic Blackmarket
Maker / Owner : Agus Samp
Include : a_samp, foreach, a_mysql, zcmd / Pawn.CMD
Note : Ga usah akuin punya anda
*/

#define MAX_BLACKMARKET            (200)

enum bmInfo
{
	cmID,
	cmOwnerID,
	cmOwned,
	Float:cmPosX,
	Float:cmPosY,
	Float:cmPosZ,
	cmPrice,
	cmPickup,
	Text3D:cmText,
};
new BlInfo[MAX_BLACKMARKET][bmInfo];
new Iterator:DyBlackMarket<MAX_BLACKMARKET>;

enum pInfo
{
	pComponent, pActivityTime, PlayerBar:activitybar,    // activity bar,
};
new PlayerInfo[MAX_PLAYERS][pInfo];

epublic: LoadBlackMarket()
{
	//static cmid;
	new string[255];
	new rows;
	rows = cache_num_rows();

	if(rows)
  	{
		for(new i; i < rows; i++)
		{
		    cache_get_value_name_int(i, "id", BlInfo[i][cmID]);
		    cache_get_value_name_int(i, "owned", BlInfo[i][cmOwned]);
			cache_get_value_name_int(i, "owner_id", BlInfo[i][cmID]);

			cache_get_value_name_float(i, "point_x", BlInfo[i][cmPosX]);
			cache_get_value_name_float(i, "point_y", BlInfo[i][cmPosY]);
			cache_get_value_name_float(i, "point_z", BlInfo[i][cmPosZ]);

			cache_get_value_name_int(i, "price", BlInfo[i][cmPrice]);

			Iter_Add(DyBlackMarket, i);
			if(BlInfo[i][cmOwned] == 1)
			{
				BlInfo[i][cmPickup] = CreateDynamicPickup(1239, 23, BlInfo[i][cmPosX], BlInfo[i][cmPosY], BlInfo[i][cmPosZ], 0);
			    format(string, sizeof(string), "[ID:%d]\nDYNAMIC BLACKMARKET \n GUNAKAN /CREATEGUN", i);
				BlInfo[i][cmText] = CreateDynamic3DTextLabel(string, COLOR_WHITE, BlInfo[i][cmPosX], BlInfo[i][cmPosY], BlInfo[i][cmPosZ], 4.0);
			}
			else
			{
	            BlInfo[i][cmPickup] = CreateDynamicPickup(1239, 23, BlInfo[i][cmPosX], BlInfo[i][cmPosY], BlInfo[i][cmPosZ], 0);
			    format(string, sizeof(string), "[ID:%d]\nDYNAMIC BLACKMARKET \n GUNAKAN /CREATEGUN", i);
				BlInfo[i][cmText] = CreateDynamic3DTextLabel(string, COLOR_WHITE, BlInfo[i][cmPosX], BlInfo[i][cmPosY], BlInfo[i][cmPosZ], 4.0);
		    }
		    printf( "[LOAD] DYNAMIC BLACKMARKET");
	    }
	}
	return 1;
}

forward CreateGun(playerid, gunid, ammo);
public CreateGun(playerid, gunid, ammo)
{
	if(!IsPlayerConnected(playerid)) return 0;
	if(gunid == 0 || ammo == 0) return 0;
	if(pData[playerid][pActivityTime] >= 100)
	{
		GivePlayerWeapon(playerid, gunid, ammo);

		Info(playerid, "Anda telah berhasil membuat senjata ilegal.");
		TogglePlayerControllable(playerid, 1);
		InfoTD_MSG(playerid, 8000, "Weapon Created!");
		KillTimer(pData[playerid][pArmsDealer]);
		pData[playerid][pActivityTime] = 0;
		HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
		PlayerTextDrawHide(playerid, ActiveTD[playerid]);
		return 1;
	}
	else if(pData[playerid][pActivityTime] < 100)
	{
		pData[playerid][pActivityTime] += 5;
		SetPlayerProgressBarValue(playerid, pData[playerid][activitybar], pData[playerid][pActivityTime]);
		ApplyAnimation(playerid, "BD_FIRE", "wash_up", 4.1, 0, 0, 0, 0, 0, 1);
	}
	return 1;
}

stock MySQLConnect()
{
	mysql_tquery(mMysql, "SELECT * FROM `bmdb`", "LoadBlackMarket");
	return 1;
}

CMD:createbm(playerid, params[])
{
	extract params -> new priceDyBlackMarket; else return Info(playerid, "/createbm [harga]");

	//new String[1024];
	new idx = Iter_Free(DyBlackMarket);

	new Cache:result;

 	new Float:X, Float:Y, Float:Z;
    GetPlayerPos(playerid, X, Y, Z);
    BlInfo[idx][cmPosX] = X;
    BlInfo[idx][cmPosY] = Y;
	BlInfo[idx][cmPosZ] = Z;
	BlInfo[idx][cmPrice] = priceDyBlackMarket;
	BlInfo[idx][cmOwned] = 0;

	new fmt_text[1280];
	format
	(
		fmt_text, sizeof fmt_text,
		"INSERT INTO DyBlackMarket \
		(owned, point_x, point_y, point_z, price)\
		VALUES ('0', '%f', '%f', '%f', '%d')",
		X,
		Y,
		Z,
		priceDyBlackMarket
	);

	result = mysql_query(mMysql, fmt_text, true);

	BlInfo[idx][cmID] = cache_insert_id();

	cache_delete(result);

    Iter_Add(DyBlackMarket, idx);

    BlInfo[idx][cmPickup] = CreateDynamicPickup(1239, 23, X, Y, Z, 0);
	format(String, sizeof(String), "[ID:%d]\nDYNAMIC BLACKMARKET \n GUNAKAN /CREATEGUN", idx);
	BlInfo[idx][cmText] = CreateDynamic3DTextLabel(String, COLOR_WHITE, X, Y, Z, 4.0);
	format(String, sizeof(String), "AdmWarn: %s has created Dynamic BlackMarket ID %d.", pData[playerid][pAname], idx);
	SendAdminMessage(COLOR_RED, String);
	return 1;
}

CMD:creategun(playerid, params[])
{
	new idx;
    if(IsPlayerInRangeOfPoint(playerid, 5.0, BlInfo[idx][cmPosX], BlInfo[idx][cmPosY], BlInfo[idx][cmPosZ]))

	new Dstring[1280];
	format(Dstring, sizeof(Dstring), "Weapon\tCompo\n\
	Silenced Pistol(ammo 800)\t250\n");
	format(Dstring, sizeof(Dstring), "%sShotgun(ammo 100)\t2000\n", Dstring);
	format(Dstring, sizeof(Dstring), "%sDesert Eagle(ammo 200)\t3500\n", Dstring);
	format(Dstring, sizeof(Dstring), "%sAK-47(ammo 1000)\t7000\n", Dstring);
	format(Dstring, sizeof(Dstring), "%sMP5(ammo 1200)\t4500\n", Dstring);
	Dialog(playerid, DIALOG_ARMS_GUN, DIALOG_STYLE_TABLIST_HEADERS, "Create Gun", Dstring, "Create", "Cancel");
	return 1;
}

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
	//ARMS Dealer
	if(dialogid == DIALOG_ARMS_GUN)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0: //slc pistol
				{
					if(pData[playerid][pActivityTime] > 5) return Error(playerid, "Anda masih memiliki activity progress!");
					if(pData[playerid][pComponent] < 250) return Error(playerid, "Component tidak cukup!(Butuh: 250).");

					pData[playerid][pComponent] -= 250;

					TogglePlayerControllable(playerid, 0);
					Info(playerid, "Anda membuat senjata ilegal dengan 250 component!");
					ApplyAnimation(playerid, "BD_FIRE", "wash_up", 4.1, 0, 0, 0, 0, 0, 1);
					pData[playerid][pArmsDealer] = SetTimerEx("CreateGun", 1000, true, "idd", playerid, WEAPON_SILENCED, 800);
					PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Creating...");
					PlayerTextDrawShow(playerid, ActiveTD[playerid]);
					ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
				}
				case 1: //colt45 9mm
				{
					if(pData[playerid][pActivityTime] > 5) return Error(playerid, "Anda masih memiliki activity progress!");
					if(pData[playerid][pComponent] < 2000) return Error(playerid, "Component tidak cukup!(Butuh: 2000).");

					pData[playerid][pComponent] -= 2000;

					TogglePlayerControllable(playerid, 0);
					Info(playerid, "Anda membuat senjata ilegal dengan 2000 component");
					ApplyAnimation(playerid, "BD_FIRE", "wash_up", 4.1, 0, 0, 0, 0, 0, 1);
					pData[playerid][pArmsDealer] = SetTimerEx("CreateGun", 1000, true, "idd", playerid, 25, 100);
					PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Creating...");
					PlayerTextDrawShow(playerid, ActiveTD[playerid]);
					ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
				}
				case 2: //deagle
				{
					if(pData[playerid][pActivityTime] > 5) return Error(playerid, "Anda masih memiliki activity progress!");
					if(pData[playerid][pComponent] < 3500) return Error(playerid, "Component tidak cukup!(Butuh: 3500).");

					pData[playerid][pComponent] -= 3500;

					TogglePlayerControllable(playerid, 0);
					Info(playerid, "Anda membuat senjata ilegal dengan 3500 component!");
					ApplyAnimation(playerid, "BD_FIRE", "wash_up", 4.1, 0, 0, 0, 0, 0, 1);
					pData[playerid][pArmsDealer] = SetTimerEx("CreateGun", 1000, true, "idd", playerid, WEAPON_DEAGLE, 200);
					PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Creating...");
					PlayerTextDrawShow(playerid, ActiveTD[playerid]);
					ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
				}
				case 3: //AK47
				{
					if(pData[playerid][pActivityTime] > 5) return Error(playerid, "Anda masih memiliki activity progress!");
					if(pData[playerid][pComponent] < 7000) return Error(playerid, "Component tidak cukup!(Butuh: 700).");

					pData[playerid][pComponent] -= 7000;

					TogglePlayerControllable(playerid, 0);
					Info(playerid, "Anda membuat senjata ilegal dengan 7000 component!");
					ApplyAnimation(playerid, "BD_FIRE", "wash_up", 4.1, 0, 0, 0, 0, 0, 1);
					pData[playerid][pArmsDealer] = SetTimerEx("CreateGun", 1000, true, "idd", playerid, 30, 1000);
					PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Creating...");
					PlayerTextDrawShow(playerid, ActiveTD[playerid]);
					ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
				}
				case 4: //MP5
				{
					if(pData[playerid][pActivityTime] > 5) return Error(playerid, "Anda masih memiliki activity progress!");
					if(pData[playerid][pComponent] < 4500) return Error(playerid, "Component tidak cukup!(Butuh: 4500).");

					pData[playerid][pComponent] -= 4500;

					TogglePlayerControllable(playerid, 0);
					Info(playerid, "Anda membuat senjata ilegal dengan 4500 component!");
					ApplyAnimation(playerid, "BD_FIRE", "wash_up", 4.1, 0, 0, 0, 0, 0, 1);
					pData[playerid][pArmsDealer] = SetTimerEx("CreateGun", 1000, true, "idd", playerid, 29, 1200);
					PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Creating...");
					PlayerTextDrawShow(playerid, ActiveTD[playerid]);
					ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
				}
			}
		}
		return 1;
	}
	return 1;
}
