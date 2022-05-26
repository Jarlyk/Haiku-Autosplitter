state("Haiku") {}

startup {
	vars.Log = (Action<object>)(output => print("[] " + output));
    vars.Unity = Assembly.Load(File.ReadAllBytes(@"Components\UnityASL.bin")).CreateInstance("UnityASL.Unity");
	vars.Unity.LoadSceneManager = true;
	
	vars.chips = new[] {
		"Ferromagnetic",
		"Gyro-Accelerator",
		"Coolant Soluble",
		"Power Processor",
		"Map Sweeper",
		"Extractor",
		"Auto Modifier",
		"Infinity Edge",
		"Agile Alloy",
		"Electro-Emitter",
		"Sword Extension",
		"Bulb Relation",
		"Shock Wave",
		"Shock Projectile",
		"Protector's Capsule",
		"Pocket Magnet",
		"Self-Detonation",
		"Tungestn Steel",
		"Nomad's Plate",
		"Sawblade",
		"Amplifying Transputer",
		"Quick Repair",
		"Magnetic Footing",
		"Power Enhancer",
		"Auto Repair",
		"Heat Drive",
		"Electric Orbs",
		"Space Disturbance"
	};
	
	settings.Add("startConditions", true, "Start Conditions");
	settings.Add("onFileSelect", false, "On File Select", "startConditions");
	settings.Add("onHaikuWake", true, "On Haiku Wake", "startConditions");	
	
	settings.Add("abilities", true, "Abilities");
	settings.Add("bomb", true, "Bomb", "abilities");
	//settings.Add("dash", true, "Dash", "abilities");
	settings.Add("doubleJump", false, "Double Jump", "abilities");
	settings.Add("grapple", true, "Grapple", "abilities");
	settings.Add("heal", false, "Wrench (Heal)", "abilities");
	settings.Add("roll", true, "Ball", "abilities");
	settings.Add("teleport", true, "Blink", "abilities");
	settings.Add("wallJump", true, "Magnet", "abilities");
	settings.Add("fireRes", false, "Fire Sealant", "abilities");
	settings.Add("waterRes", false, "Water Sealant", "abilities");
	settings.Add("lightBulb", true, "Bulblet", "abilities");
	
	settings.Add("bosses", true, "Bosses");
	settings.Add("boss0", false, "Garbage Magnet", "bosses");
	settings.Add("boss1", false, "Mother Tire", "bosses");
	settings.Add("boss2", false, "Bulbhive", "bosses");
	settings.Add("boss3", false, "Buzzsaw", "bosses");
	settings.Add("boss4", true, "Electron", "bosses");
	settings.Add("boss5", true, "Proton", "bosses");
	settings.Add("boss6", true, "Neutron", "bosses");
	settings.Add("boss7", false, "Virus", "bosses");
	settings.Add("boss8", false, "Scuba Heads", "bosses");
	settings.Add("boss9", false, "Big Brother", "bosses");
	settings.Add("boss10", false, "Mischievous Mechanic", "bosses");
	settings.Add("boss11", false, "Big Drill", "bosses");
	settings.Add("boss12", false, "Car Battery", "bosses");
	settings.Add("boss13", false, "Door Boss", "bosses");
	settings.Add("boss14", false, "Creator Trio", "bosses");
	
	settings.Add("chips", false, "Chips");
	for (int i=0; i < vars.chips.Length; i++) {
		settings.Add("chip" + i, false, vars.chips[i], "chips");
	}
	
	//settings.Add("misc", false, "Misc");
	//settings.Add("powercell", false, "Power Cell Pickup", "misc");
	
	settings.Add("fragments", false, "Fragments");
	settings.Add("totalFragments", false, "Any Fragment", "fragments");
	settings.Add("OnBuiltFragment", false, "Build Vial Fragment", "fragments");
	
	settings.Add("transitions", true, "Transitions");
	vars.transFrom = new[] { 69, 93, 90, 170};
	vars.transTo = new[] { 68, 171, 100, 66};
	vars.transNames = new string[vars.transFrom.Length];
	vars.transDone = new bool[vars.transFrom.Length];
	for (int i=0; i < vars.transNames.Length; i++) {
		vars.transNames[i] = vars.transFrom[i] + "_" + vars.transTo[i];
	}
	settings.Add("69_68", true, "Exit Car Battery", "transitions");
	settings.Add("93_171", false, "Enter Factory Left", "transitions");
	settings.Add("90_100", true, "Enter Factory Right", "transitions");	
	settings.Add("170_66", false, "Leave Quatern with Emitter", "transitions");

	settings.Add("endings", true, "Endings");
	settings.Add("ending_any", true, "Any% Ending", "endings");
	settings.Add("ending_te", false, "True Ending", "endings");
}

init {
	current.Scene = -1;
	
    vars.Unity.TryOnLoad = (Func<dynamic, bool>)(helper =>
    {
        var gm = helper.GetClass("Assembly-CSharp", "GameManager");
        
        vars.Unity.Make<bool>(gm.Static, gm["instance"], gm["gameLoaded"]).Name = "gameLoaded";
        vars.Unity.Make<bool>(gm.Static, gm["instance"], gm["canBomb"]).Name = "canBomb";
        vars.Unity.Make<bool>(gm.Static, gm["instance"], gm["canDash"]).Name = "canDash";
        vars.Unity.Make<bool>(gm.Static, gm["instance"], gm["canDoubleJump"]).Name = "canDoubleJump";
        vars.Unity.Make<bool>(gm.Static, gm["instance"], gm["canGrapple"]).Name = "canGrapple";
        vars.Unity.Make<bool>(gm.Static, gm["instance"], gm["canHeal"]).Name = "canHeal";
        vars.Unity.Make<bool>(gm.Static, gm["instance"], gm["canRoll"]).Name = "canRoll";
        vars.Unity.Make<bool>(gm.Static, gm["instance"], gm["canTeleport"]).Name = "canTeleport";
        vars.Unity.Make<bool>(gm.Static, gm["instance"], gm["canWallJump"]).Name = "canWallJump";
        vars.Unity.Make<bool>(gm.Static, gm["instance"], gm["fireRes"]).Name = "fireRes";
        vars.Unity.Make<bool>(gm.Static, gm["instance"], gm["waterRes"]).Name = "waterRes";
        vars.Unity.Make<bool>(gm.Static, gm["instance"], gm["lightBulb"]).Name = "lightBulb";
		
		vars.Unity.Make<bool>(gm.Static, gm["instance"], gm["bosses"], 0x20 + 0*16 + 8).Name = "boss0";
		vars.Unity.Make<bool>(gm.Static, gm["instance"], gm["bosses"], 0x20 + 1*16 + 8).Name = "boss1";
		vars.Unity.Make<bool>(gm.Static, gm["instance"], gm["bosses"], 0x20 + 2*16 + 8).Name = "boss2";
		vars.Unity.Make<bool>(gm.Static, gm["instance"], gm["bosses"], 0x20 + 3*16 + 8).Name = "boss3";
		vars.Unity.Make<bool>(gm.Static, gm["instance"], gm["bosses"], 0x20 + 4*16 + 8).Name = "boss4";
		vars.Unity.Make<bool>(gm.Static, gm["instance"], gm["bosses"], 0x20 + 5*16 + 8).Name = "boss5";
		vars.Unity.Make<bool>(gm.Static, gm["instance"], gm["bosses"], 0x20 + 6*16 + 8).Name = "boss6";
		vars.Unity.Make<bool>(gm.Static, gm["instance"], gm["bosses"], 0x20 + 7*16 + 8).Name = "boss7";
		vars.Unity.Make<bool>(gm.Static, gm["instance"], gm["bosses"], 0x20 + 8*16 + 8).Name = "boss8";
		vars.Unity.Make<bool>(gm.Static, gm["instance"], gm["bosses"], 0x20 + 9*16 + 8).Name = "boss9";
		vars.Unity.Make<bool>(gm.Static, gm["instance"], gm["bosses"], 0x20 + 10*16 + 8).Name = "boss10";
		vars.Unity.Make<bool>(gm.Static, gm["instance"], gm["bosses"], 0x20 + 11*16 + 8).Name = "boss11";
		vars.Unity.Make<bool>(gm.Static, gm["instance"], gm["bosses"], 0x20 + 12*16 + 8).Name = "boss12";
		vars.Unity.Make<bool>(gm.Static, gm["instance"], gm["bosses"], 0x20 + 13*16 + 8).Name = "boss13";
		vars.Unity.Make<bool>(gm.Static, gm["instance"], gm["bosses"], 0x20 + 14*16 + 8).Name = "boss14";
		
        vars.Unity.Make<bool>(gm.Static, gm["instance"], gm["showCredits"]).Name = "showCredits";
        vars.Unity.Make<bool>(gm.Static, gm["instance"], gm["introPlayed"]).Name = "introPlayed";
        vars.Unity.Make<int>(gm.Static, gm["instance"], gm["savePointSceneIndex"]).Name = "savePointSceneIndex";
		
		
		
		/* Create variables for each slot of the Inventory, itemSLotId's are:
			0 - keys
			1 - electric key
			2 - goldcrest whistle
			3 - capsule fragment
			4 - kill switch sword
			5 - adjustable wrench
			6 - cassette tape
			7 - green skull
			8 - red skull
		*/
		for (int i = 0; i < 9; i++) {
			vars.Unity.Make<int>(gm.Static, gm["instance"], gm["itemSlots"], 0x20 + i*24 + 8).Name = "itemSlotsID" + i;
		}
		for (int i = 0; i < 9; i++) {
			vars.Unity.Make<int>(gm.Static, gm["instance"], gm["itemSlots"], 0x20 + i*24 + 12).Name = "itemSlotsQuantity" + i;
		}
		vars.Unity.Make<int>(gm.Static, gm["instance"], gm["maxHealth"]).Name = "maxHealth";
		
		
		var ps = helper.GetClass("Assembly-CSharp", "PlayerScript");
        vars.Unity.Make<bool>(ps.Static, ps["instance"], ps["disableControls"]).Name = "disableControls";
		
		var cb = helper.GetClass("Assembly-CSharp", "CameraBehavior");
		vars.Unity.Make<bool>(cb.Static, cb["instance"], cb["isTransitioning"]).Name = "isTransitioning";
		
		for (int i=0; i < vars.chips.Length; i++) {
			vars.Unity.Make<bool>(gm.Static, gm["instance"], gm["chip"], 0x20 + i*48 + 40).Name = vars.chips[i];
		}
		
        return true;
    });

    vars.Unity.Load(game);
}

update {
    if (!vars.Unity.Loaded) return false;

    vars.Unity.Update();

	current.gameLoaded = vars.Unity["gameLoaded"].Current;
	current.canBomb = vars.Unity["canBomb"].Current;
	current.canDash = vars.Unity["canDash"].Current;
	current.canDoubleJump = vars.Unity["canDoubleJump"].Current;
	current.canGrapple = vars.Unity["canGrapple"].Current;
	current.canHeal = vars.Unity["canHeal"].Current;
	current.canRoll = vars.Unity["canRoll"].Current;
	current.canTeleport = vars.Unity["canTeleport"].Current;
	current.canWallJump = vars.Unity["canWallJump"].Current;
	current.fireRes = vars.Unity["fireRes"].Current;
	current.waterRes = vars.Unity["waterRes"].Current;
	current.lightBulb = vars.Unity["lightBulb"].Current;
	current.showCredits = vars.Unity["showCredits"].Current;
	current.boss0 = vars.Unity["boss0"].Current;
	current.boss1 = vars.Unity["boss1"].Current;
	current.boss2 = vars.Unity["boss2"].Current;
	current.boss3 = vars.Unity["boss3"].Current;
	current.boss4 = vars.Unity["boss4"].Current;
	current.boss5 = vars.Unity["boss5"].Current;
	current.boss6 = vars.Unity["boss6"].Current;
	current.boss7 = vars.Unity["boss7"].Current;
	current.boss8 = vars.Unity["boss8"].Current;
	current.boss9 = vars.Unity["boss9"].Current;
	current.boss10 = vars.Unity["boss10"].Current;
	current.boss11 = vars.Unity["boss11"].Current;
	current.boss12 = vars.Unity["boss12"].Current;	
	current.boss13 = vars.Unity["boss13"].Current;	
	current.boss14 = vars.Unity["boss14"].Current;	
	
	current.totalFragments = 0;
	for (int i = 0; i < 9; i++) {
		if (vars.Unity["itemSlotsID" + i].Current == 3) {
			current.totalFragments = vars.Unity["itemSlotsQuantity" + i].Current;
			print(current.totalFragments.ToString() + " " +old.totalFragments.ToString());
		}
	}
	current.maxHealthChange = vars.Unity["maxHealth"].Current;
	
	current.chips = new bool[vars.chips.Length];
	for (int i=0; i < vars.chips.Length; i++) {
		current.chips[i] = vars.Unity[vars.chips[i]].Current;
	}
	
	current.introPlayed = vars.Unity["introPlayed"].Current;
	current.savePointSceneIndex = vars.Unity["savePointSceneIndex"].Current;
	current.disableControls = vars.Unity["disableControls"].Current;
	current.isTransitioning = vars.Unity["isTransitioning"].Current;
	
	var scId = vars.Unity.Scenes.Active.Index;
	if (scId > 0)
		current.Scene = scId;
}

start {
	if (settings["onFileSelect"])
		return current.gameLoaded && !old.gameLoaded;
		
	if (settings["onHaikuWake"])
		return (current.Scene == current.savePointSceneIndex) && !current.disableControls;
		
	return false;
}

onStart {
	for (int i=0; i < vars.transDone.Length; i++) {
		vars.transDone[i] = false;
	}
}

split {
	if (settings["bomb"] && current.canBomb && !old.canBomb) return true;
	//if (settings["dash"] && current.canDash && !old.canDash) return true;
	if (settings["doubleJump"] && current.canDoubleJump && !old.canDoubleJump) return true;
	if (settings["grapple"] && current.canGrapple && !old.canGrapple) return true;
	if (settings["heal"] && current.canHeal && !old.canHeal) return true;
	if (settings["roll"] && current.canRoll && !old.canRoll) return true;
	if (settings["teleport"] && current.canTeleport && !old.canTeleport) return true;
	if (settings["wallJump"] && current.canWallJump && !old.canWallJump) return true;
	if (settings["fireRes"] && current.fireRes && !old.fireRes) return true;
	if (settings["waterRes"] && current.waterRes && !old.waterRes) return true;
	if (settings["lightBulb"] && current.lightBulb && !old.lightBulb) return true;
	
	if (settings["boss0"] && current.boss0 && !old.boss0) return true;
	if (settings["boss1"] && current.boss1 && !old.boss1) return true;
	if (settings["boss2"] && current.boss2 && !old.boss2) return true;
	if (settings["boss3"] && current.boss3 && !old.boss3) return true;
	if (settings["boss4"] && current.boss4 && !old.boss4) return true;
	if (settings["boss5"] && current.boss5 && !old.boss5) return true;
	if (settings["boss6"] && current.boss6 && !old.boss6) return true;
	if (settings["boss7"] && current.boss7 && !old.boss7) return true;
	if (settings["boss8"] && current.boss8 && !old.boss8) return true;
	if (settings["boss9"] && current.boss9 && !old.boss9) return true;
	if (settings["boss10"] && current.boss10 && !old.boss10) return true;
	if (settings["boss11"] && current.boss11 && !old.boss11) return true;
	if (settings["boss12"] && current.boss12 && !old.boss12) return true;
	if (settings["boss13"] && current.boss13 && !old.boss13) return true;
	if (settings["boss14"] && current.boss14 && !old.boss14) return true;
	
	if (settings["totalFragments"] && current.totalFragments > old.totalFragments) return true;
	if (settings["OnBuiltFragment"] && current.maxHealthChange > old.maxHealthChange) return true;
	
	
	if (old.chips != null) {	
		for (int i=0; i < current.chips.Length; i++) {
			if (settings["chip" + i] && current.chips[i] && !old.chips[i]) return true;
		}
	}
	
	for (int i=0; i < vars.transFrom.Length; i++) {
		var name = vars.transNames[i];
		if (settings[name] && !vars.transDone[i] && i == 3 && current.chips[9] && !old.chips[9] && current.Scene == vars.transTo[i] && old.Scene == vars.transFrom[i]) {
			vars.transDone[i] = true;
			return true;
		}
		if (settings[name] && !vars.transDone[i] && current.Scene == vars.transTo[i] && old.Scene == vars.transFrom[i]) {
			vars.transDone[i] = true;
			return true;
		}
	}
	
	if (settings["ending_any"] && current.showCredits && current.Scene == 3 && old.Scene != 3) return true;
	if (settings["ending_te"] && current.Scene == 6 && old.Scene != 6) return true;
	
    return false;
}

isLoading {
    if (!vars.Unity.Loaded) return false;
	return vars.Unity.Scenes.Count > 1 && current.Scene != 144;
}

exit {
    vars.Unity.Reset();
}

shutdown {
    vars.Unity.Reset();
}