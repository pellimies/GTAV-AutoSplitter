// GTA V Autosplitter for version 1.27
// Contributors: hoxi, TheStonedTurtle, Parik, Crab1k, Gogsi123, FriendlyBaron, burhac, Rake Jyals and other community members
// For any questions, ask in the GTA V Speedrunning Discord: https://discord.gg/3qjGGBM

// Social Club
state("GTA5")
{
/* 	// mission counter
	int m: 0x2A07E70, 0xBDA08;

	// strangers and freaks counter
	int s: 0x2A07E70, 0xBDA20; */

	// usj counter
	int u: 0x2A07E70, 0xCE5C0;

/* 	// bridge counter
	int b: 0x2A07E70, 0x30318; */

	// random event counter
	int r: 0x2A07E70, 0xBDA28;

	// hobbies and pasttimes
	int h: 0x2A07E70, 0xBDA10;

	// current cutscene
	string255 c: 0x01CB44A0, 0xB70;

	// current script
	string255 sc: 0x1CB4340;
	
	// loading check
	int loading: 0x2AC7CF4;

	// percentage counter
	float percent: 0x0218FAD8, 0x18068;

	// current golf hole
	int gh: 0x1DE3970;

	// in cutscene
	byte in_c: 0x1CB4472;

	// in mission
	byte in_m: 0x1DD6CB9;

	// no player control? - used in ending A splitting and countryside
	byte noControl: 0x1DD034D;

	// some kind of debug text - used for prologue autostart
	string255 debug_string: 0x2295A10, 0x0;

	// mission passed screen
	int mpassed: 0x2A07D48, 0xA60, 0x13C0;

	// collectible screen
	int collectible: 0x2AC7BA0, 0xD97A8;
}

startup
{
	vars.missionList = new List<string>();
	vars.freaksList = new List<string>();

	vars.missionWatchers = new MemoryWatcherList();
	vars.freaksWatchers = new MemoryWatcherList();
	vars.flagsWatchers = new MemoryWatcherList();
	vars.collectibleAddressWatchers = new MemoryWatcherList();
	vars.collectibleValueWatchers = new MemoryWatcherList();

	// mission ids taken from here https://github.com/Sainan/GTA-V-Decompiled-Scripts/blob/245d1611c36454ccce2e1c047026f817f7f29f33/decompiled_scripts/standard_global_init.c#L1653
	vars.missions = new Dictionary<string, Dictionary<int, string>> {
		{"Trevor%", new Dictionary<int, string> {
			{53, "Prologue"},
			{0, "Franklin & Lamar"},
			{1, "Repossession"},
			{40, "Chop"},
			{2, "Complications"},
			{17, "Father/Son"},
			{19, "Marriage Counseling"},
			{44, "Friend Request"},
			{18, "Daddy's Little Girl"},
			{86, "Casing the Jewel Store"},
			{89, "Carbine Rifles"},
			{90, "The Jewel Store Job"}
		}},
		{"Countryside", new Dictionary<int, string> {
			{43, "The Long Stretch"},
			{62, "Mr. Philips"},
			{12, "Trevor Philips Industries"},
			{63, "Nervous Ron"},
			{13, "Crystal Maze"},
			{64, "Friends Reunited"}
		}},
		{"Blitz Play", new Dictionary<int, string> {
			{20, "Fame or Shame"},
			{29, "Dead Man Walking"},
			{30, "Three's Company"},
			{41, "Hood Safari"},
			{71, "Scouting the Port"},
			{21, "Did Somebody Say Yoga?"},
			{31, "By The Book"},
			{72, "Minisub"},
			{32, "Blitz Play Intro"},
			{33, "Garbage Truck"},
			{34, "Tow Truck"},
			{36, "Masks"},
			{37, "Boiler Suits"},
			{73, "Cargobob (Merryweather Heist)"},
			{74, "Merryweather Heist (Freighter)"},
			{75, "Merryweather Heist (Offshore)"},
			{38, "Blitz Play Finale"}
		}},
		{"Deep Inside", new Dictionary<int, string> {
			{8, "I Fought The Law"},
			{9, "Eye in the Sky"},
			{59, "Mr. Richards"},
			{45, "Caida Libre"},
			{10, "Deep Inside"}
		}},
		{"Paleto Score", new Dictionary<int, string> {
			{14, "Minor Turbulence"},
			{91, "Paleto Score Setup"},
			{15, "Predator"},
			{92, "Military Hardware"},
			{93, "Paleto Score"}
		}},
		{"Fresh Meat", new Dictionary<int, string> {
			{16, "Derailed"},
			{39, "Monkey Business"},
			{65, "Hang Ten"},
			{76, "Surveying the Score"},
			{46, "Bury the Hatchet"},
			{11, "Pack Man"},
			{47, "Fresh Meat"}
		}},
		{"Bureau Raid", new Dictionary<int, string> {
			{60, "Ballad of Rocco"},
			{66, "Cleaning out the Bureau"},
			{22, "Reuniting the Family"},
			{67, "Architect's Plans"},
			{68, "Fire Truck (Bureau Raid)"},
			{69, "Bureau Raid (Covert)"},
			{70, "Bureau Raid (Roof)"}
		}},
		{"Third Way", new Dictionary<int, string> {
			{61, "Legal Trouble"},
			{48, "The Wrap Up"},
			{42, "Lamar Down"},
			{49, "Meltdown"},
			{77, "Big Score Intro"},
			{80, "Gauntlet A"},
			{81, "Gauntlet B"},
			{82, "Gauntlet C"},
			{78, "Stingers"},
			{79, "Driller"},
			{83, "Sidetracked"},
			{84, "Big Score (Subtle)"},
			{85, "Big Score (Obvious)"}
		}},
		{"Lester's Assassinations", new Dictionary<int, string> {
			{3, "The Hotel Assassination"},
			{4, "The Multi-Target Assassination"},
			{5, "The Vice Assassination"},
			{6, "The Bus Assassination"},
			{7, "The Construction Assassination"}
		}},
	};

	// Add mission memory watchers
	foreach (var address in vars.missions) {
		foreach (var m in address.Value) {
			vars.missionWatchers.Add(new MemoryWatcher<int>(new DeepPointer("GTA5.exe", 0x2A07E70, (0xCD1F8 + (48 * m.Key)))) { Name = m.Value });
		}
	}


	// Inserts split into settings and adds the mission to our separate list.
	Action<string, bool> addMissionChain = (missions, defaultValue) => {
		var parent = missions;
		foreach (var address in vars.missions[missions]) {
			settings.Add(address.Value, defaultValue, address.Value, parent + " segment");
			vars.missionList.Add(address.Value);
		}
	};
	
	// Inserts header (i.e. mission giver) into settings.
	Action<string, bool, string> addMissionHeader = (missions, defaultValue, header) => {
		var parent = missions;
		settings.Add(parent + " segment", defaultValue, header);
		addMissionChain(missions, defaultValue);
	};


	Action<string, bool> addFreaksChain = (missions, defaultValue) => {
		var parent = missions;
		foreach (var address in vars.freaks[missions]) {
			settings.Add(address.Value, defaultValue, address.Value, parent + " segment");
			vars.freaksList.Add(address.Value);
		}
	};
	

	Action<string, bool, string> addFreaksHeader = (missions, defaultValue, header) => {
		var parent = missions;
		settings.Add(parent + " segment", defaultValue, header);
		addFreaksChain(missions, defaultValue);
	};

	vars.freaks = new Dictionary<string, Dictionary<int,string>> {
		{"Franklin", new Dictionary <int,string> {
			{58, "Pulling Favours"},
			{59, "Pulling Another Favour"},
			{60, "Pulling Favours Again"},
			{61, "Still Pulling Favours"},
			{62, "Pulling One Last Favour"},
			{24, "Shift Work"},
			{46, "Paparazzo"},
			{47, "Paparazzo - The Sex Tape"},
			{49, "Paparazzo - The Meltdown"},
			{50, "Paparazzo - The Highness"},
			{51, "Paparazzo - Reality Check"},
			{44, "Far Out"},
			{45, "The Final Frontier"},
			{4, "Grass Roots - Franklin"},
			{5, "Grass Roots - The Pickup"},
			{6, "Grass Roots - The Drag"},
			{7, "Grass Roots - The Smoke-in"},
			{17, "Risk Assesstment"},
			{18, "Liqudity Risk"},
			{19, "Targeted Risk"},
			{20, "Uncalculated Risk"},
			{23, "Exercising Demons - Franklin"},
			{8, "A Starlet in Vinewood"},
			{57, "The Last One"}
		}},
		{"Michael", new Dictionary<int, string> {
			{2, "Grass Roots - Michael"},
			{21, "Exercising Demons - Michael"},
			{0, "Death At Sea"},
			{1, "What Lies Beneath"},
			{9, "Seeking the Truth"},
			{10, "Accepting the Truth"},
			{11, "Assuming the Truth"},
			{12, "Chasing the Truth"},
			{13, "Bearing the Truth"},
			{14, "Delivering the Truth"},
			{15, "Exercising the Truth"},
			{16, "Unknowing the Truth"}
			// Extra Epsilon splits added later
		}},
		{"Trevor", new Dictionary<int, string> {
			{3, "Grass Roots - Trevor"},
			{22, "Exercising Demons - Trevor"},
			{52, "Rampage 1"},
			{53, "Rampage 2"},
			{54, "Rampage 3"},
			{55, "Rampage 4"},
			{56, "Rampage 5"},
			{25, "Target Practice"},
			{26, "Fair Game"},
			{32, "The Civil Border Patrol"},
			{33, "An American Welcome"},
			{34, "Minute Man Blues"},
			{31, "Special Bonds"},
			{37, "Nigel and Mrs. Thornhill"},
			{38, "Vinewood Souvenirs - Willie"},
			{39, "Vinewood Souvenirs - Tyler"},
			{40, "Vinewood Souvenirs - Kerry"},
			{41, "Vinewood Souvenirs - Mark"},
			{42, "Vinewood Souvenirs - Al Di Napoli"},
			{43, "Vinewood Souvenirs - The Last Act"},
			{27, "Extra Commission"},
			{28, "Closing the Deal"},
			{29, "Surreal Estate"},
			{30, "Breach of Contract"},
			{35, "Mrs. Philips"},
			{36, "Damaged Goods"}
		}}
	};	

	// Add mission memory watchers
	foreach (var address in vars.freaks) {
		foreach (var m in address.Value) {
			vars.freaksWatchers.Add(new MemoryWatcher<byte>(new DeepPointer("GTA5.exe", 0x2A07E70, 0xDF030 + (48 * m.Key))) { Name = m.Value });
		}
	}

	vars.michaelEpsilonMissions = new Dictionary<string,string> {
		{"donated500", "Seeking the Truth (donated 500$)"},
		{"donated5k", "Accepting the Truth (donated 5000$)"},
		{"donated10k", "Assuming the Truth (all cars collected)"},
		{"carsdelivered", "Chasing the Truth (donated 10000$)"},
		{"robe10days", "Bearing the Truth (10 days with robe passed)"},
		{"desertdone", "Exercising the Truth (after pilgrimage done)"},
	};

	vars.epsilonFlags = new Dictionary<int, string> {
		{87, "donated500"},
		{88, "donated5k"},
		{89, "donated10k"},
		{90, "carsdelivered"},
		{92, "robe10days"},
		{94, "desertdone"}
	};

	foreach(var flag in vars.epsilonFlags) {
		vars.flagsWatchers.Add(new MemoryWatcher<int>(new DeepPointer("GTA5.exe", 0x2A07E70, 0xCCCA0 + (flag.Key * 8))) { Name = flag.Value });
	}


	vars.endings = new Dictionary<string,string> {
		{"fin_a_ext", "Something Sensible (Kill Trevor)"},
		{"fin_b_ext", "The Time's Come (Kill Michael)"},
		{"fin_ext_p2", "The Third Way (Deathwish)"}
	};

	vars.collectibleIDs = new Dictionary<int, string> {
		{0x4FD4, "Under the Bridges"},
		{0x2B6C, "Letter Scraps"},
		{0x1A1, "Spaceship Parts"},
		{0x4B59, "Nuclear Waste"}
	};

	foreach(var collectible in vars.collectibleIDs) {
		vars.collectibleAddressWatchers.Add(new MemoryWatcher<ulong>(new DeepPointer("GTA5.exe", 0x22B54E0 + 8, collectible.Key * 16 + 8)) { Name = collectible.Value });
		vars.collectibleValueWatchers.Add(new MemoryWatcher<ulong>(new DeepPointer("GTA5.exe", 0x22B54E0 + 8, collectible.Key * 16 + 8, 0x10)) { Name = collectible.Value });
	}



	// add settings groups
	settings.Add("main", true, "Main");
	settings.Add("collectibles", false, "Collectibles");
	settings.Add("misc", false, "Miscellaneous");
	settings.Add("starters", true, "Auto Starters");
	settings.Add("timerend", true, "Auto Finishers");


	// Add missions to setting list
	settings.Add("missions", true, "Missions", "main");
	settings.CurrentDefaultParent = "missions";
	addMissionHeader("Trevor%", true, "Trevor%");
	addMissionHeader("Countryside", true, "Countryside");
	addMissionHeader("Blitz Play", true, "Blitz Play");
	addMissionHeader("Deep Inside", true, "Deep Inside");
	addMissionHeader("Paleto Score", true, "Paleto Score");
	addMissionHeader("Fresh Meat", true, "Fresh Meat");
	addMissionHeader("Bureau Raid", true, "Bureau Raid");
	addMissionHeader("Third Way", true, "Third Way");
	addMissionHeader("Lester's Assassinations", true, "Lester's Assassinations");

	// Add strangers and freaks to setting list
	settings.Add("sf", true, "Strangers and Freaks", "main");
	settings.CurrentDefaultParent = "sf";
	addFreaksHeader("Franklin", true, "Franklin");
	addFreaksHeader("Michael", true, "Michael");
	addFreaksHeader("Trevor", true, "Trevor");

	foreach (var mission in vars.michaelEpsilonMissions) {
		settings.Add(mission.Key, true, mission.Value, "Michael segment");
		vars.freaksList.Add(mission.Value);
	}


	// split on 100% completion
	settings.Add("100", false, "100% Completion", "main");
	settings.SetToolTip("100", "Split when the percentage counter reaches 100%.");
	// split on stunt jumps
	settings.Add("stuntjumps", false, "Stunt Jumps", "collectibles");
	// split on Random Events
	settings.Add("randomevent", false, "Random Event", "collectibles");
	// split on Hobbies and Pasttimes
	settings.Add("hobbies", false, "Hobbies and Pasttimes", "collectibles");

	foreach(var collectible in vars.collectibleIDs) {
		settings.Add(collectible.Value, false, collectible.Value, "collectibles");
	}
	
	// split on other collectibles
	settings.Add("other_collectibles", false, "Spaceship Parts/Letters/Monkey Mosaics/Peyotes/Signs/Property Purchases", "collectibles");
	// Save Warping
	settings.Add("savewarp", true, "Don't Split when save warping", "misc");
	// Golf autosplitter
	settings.Add("golf", false, "Split on every Golf hole", "misc");

	// Option to increase refresh rate
	settings.Add("highRefreshRate", false, "Increase script refresh rate (higher cpu load)", "misc");
	settings.SetToolTip("highRefreshRate", "Checks to determine whether to increase splitting accuracy. Enabling this setting will use more processing power because code is running more often.");

	vars.segmentsStart = new Dictionary<string,string> {
		{"countryside", "Countryside"},
		{"fam_4_int_alt1", "Blitz Play"},
		{"car_1_int_concat", "Deep Inside"},
		{"paleto_score" , "Paleto Score"},
		{"exile_3_int", "Fresh Meat"},
		{"ah_1_int", "Bureau Raid"},
		{"sol_2_int_alt1", "Third Way"}
	};

	// Add segments to autostart
	settings.Add("segments_start", false, "Segments", "starters");
	settings.SetToolTip("segments_start", "For Trevor% segment, use the Start the timer on the Prologue start option.");

	// Add actual segments
	foreach(var Segment in vars.segmentsStart) {
		settings.Add(Segment.Key, true, Segment.Value, "segments_start");
	};

	// Prologue timer start
	settings.Add("prologuetimer", true, "Start the timer on the Prologue start", "starters");

	// misc category auto starter
	settings.Add("misctimer", false, "Start the timer after Prologue ends", "starters");

	// Golf timer start
	settings.Add("golftimer", false, "Start the timer on the first hole in Golf", "starters");

	// Endings timer end
	settings.Add("endings", true, "Endings", "timerend");

	// Add endings to settings
	foreach(var Ending in vars.endings) {
		settings.Add(Ending.Key, true, Ending.Value, "endings");
	};

	settings.Add("segments_end", false, "Segments", "timerend");
	settings.SetToolTip("segments_end", "For Third Way segment, use the Ending C auto finisher.");

	// used only for settings, will need to check for them manually
	vars.segmentsEnd = new Dictionary<string,string> {
		{"trevis", "Trevor%"},
		{"country_end", "Countryside"},
		{"deep", "Deep Inside"},
		{"paleto_end", "Paleto Score"},
		{"fresh_meat_end", "Fresh Meat"},
		{"bureau_end", "Bureau Raid"},
		{"epsilon_end", "Epsilon Program"},
		{"asf_end", "All Strangers and Freaks"}
	};

	// Add segment ends to settings list
	foreach(var Segment in vars.segmentsEnd) {
		settings.Add(Segment.Key, true, Segment.Value, "segments_end");
	};
}


init
{
	// Checks if name is enabled in settings and returns true if the diff is exactly one
	Func<string, int, bool> shouldSplit = (name, diff) => {
		// Check if anything changed and if this type of split is enabled, probably can get removed
		if (diff == 0 || !settings[name]) {
			return false;
		}

		// Experimental save warping
		if (settings["savewarp"]) {
			if (diff == 1 && vars.loadHistory.Contains(name)) {
				vars.loadHistory.Remove(name);
				return false;
			}

			if (diff == -1) {
				vars.loadHistory.Add(name);
				return false;
			}
		}

		return diff == 1;
	};
	vars.shouldSplit = shouldSplit;

	vars.miscFlag = false;
	vars.justStarted = false;
	vars.justSplit = false;
	vars.phase = timer.CurrentPhase;
	vars.loadHistory = new HashSet<string>();
	vars.currentHole = 1;

	//empty list of done splits
	vars.splits = new List<string>();
}

update
{

	var oldPhase = vars.phase;
	vars.phase = timer.CurrentPhase;
	bool hasChangedPhase = oldPhase != vars.phase;

	vars.collectibleAddressWatchers.UpdateAll(game);
	vars.collectibleValueWatchers.UpdateAll(game);
	vars.flagsWatchers.UpdateAll(game);
	vars.missionWatchers.UpdateAll(game);
	vars.freaksWatchers.UpdateAll(game);

	if (vars.justStarted || vars.justSplit || hasChangedPhase) {
		vars.loadHistory.Clear();
		vars.miscFlag = false;
		if (!vars.justSplit) {
			vars.splits.Clear();
		}
	}

	vars.justStarted = false;
	vars.justSplit = false;

	if (settings["highRefreshRate"]) {
    	refreshRate = 120;
		}
	else {
    	refreshRate = 60;
		}

		
}

start
{
	bool startFlag = false;
	if (settings["misctimer"]) {
		if (current.c == "armenian_1_int" && current.in_c == 1 && current.in_c != old.in_c) {
			startFlag = true;
		}	
	}


	// generic segment timer start
	if (settings.ContainsKey(current.c) && settings[current.c]) {
		if (current.in_c == 0 && current.in_c != old.in_c && current.in_m == 1) {
			startFlag = true;
		}
	}

	// exception for countryside
	if (settings["countryside"]) {
		if (current.c == "trevor_1_int" && current.in_m == 1 && current.in_c == 0 && current.loading == 0 && current.loading != old.loading && current.noControl == 0) {
			startFlag = true;
		}
	}

	// exception for paleto score
	if (settings["paleto_score"]) {
		if (current.sc == "exile1" && current.loading == 0 && current.loading != old.loading && current.in_m == 1) {
			startFlag = true;
		}
	}

	bool golfFlag = settings["golftimer"] && current.gh == 1 && current.gh != old.gh;
	
	bool prologueFlag = settings["prologuetimer"] && current.debug_string == "PRO_SETTING" && current.debug_string != old.debug_string;

	vars.justStarted = startFlag || golfFlag || prologueFlag;

	return vars.justStarted;
}

split
{
	// Should we split on this Mission/Stranger and Freaks script name?
	bool scriptNameCheck = settings.ContainsKey(current.sc) && settings[current.sc] && !vars.splits.Contains(current.sc); //Checks if the current script is turned on in settings and the splits don't contain the

/* 	// check if mission counter increased
	bool mCounterCheck = vars.shouldSplit("missions", current.m - old.m);
	bool missionCheck = scriptNameCheck && mCounterCheck;

	// check if strangers and freaks counter increased
	/* bool sfCounterCheck = vars.shouldSplit("sf", current.s - old.s);
	bool sfCheck = scriptNameCheck && sfCounterCheck; */

	// check if in_mission changed from true to false
/* 	bool missionScriptEnd = current.in_m == 0 && old.in_m == 1 && current.noControl == 0;
	bool altScriptNameCheck = settings.ContainsKey(current.sc) && settings[current.sc] && !vars.splits.Contains(current.sc) && vars.freaksScriptsMichael.ContainsKey(current.sc) || vars.freaksScriptsTrevor.ContainsKey(current.sc) || vars.freaksScriptsFranklin.ContainsKey(current.sc);
	bool altSfCheck = altScriptNameCheck && missionScriptEnd; */

	// check if stunt jumps counter increased
	bool stuntCheck = vars.shouldSplit("stuntjumps", current.u - old.u);

/* 	// check if bridges counter changed
	bool bridgeCheck = vars.shouldSplit("bridges", current.b - old.b); */

	// check if random event increased
	bool eventCheck = vars.shouldSplit("randomevent", current.r - old.r);

	// check if hobbies and pastimes increased
	bool hobbyCheck = vars.shouldSplit("hobbies", current.h - old.h);

	// check if they just reached 100% completion
	bool hundoCheck = settings["100"] && current.percent == 100 && current.percent != old.percent;
	
	// check if split on this ending
	bool endingCheck = settings.ContainsKey(current.c) && settings[current.c] && current.in_c == 1 && current.in_c != old.in_c && current.in_m == 1;

	// ending A check
	bool endingACheck = settings["fin_a_ext"] && current.c == "fin_a_ext" && current.noControl == 1 && current.noControl != old.noControl && current.in_m == 1;

	// Golf hole split. Checks > 1 so we don't split on golf start.
	bool golfCheck = current.gh > 1 && current.gh != old.gh && vars.shouldSplit("golf", current.gh - vars.currentHole);
	// golf hole value changes to 0 inbetween holes, (walking to shot/scoreboard after hole)
	if (current.gh > 0) {
		vars.currentHole = current.gh;
	}

	// check if collectible is picked and if under the bridges wasn't increased
	bool collectibleCheck = settings["other_collectibles"] && current.collectible == 1 && current.collectible != old.collectible && current.b == old.b && !settings["customCollect" + current.sc];

	// Segment end splits
	// Trevor%
	bool trevisCheck = settings["trevis"] && current.mpassed == 1 && current.mpassed != old.mpassed && current.sc == "jewelry_heist";

	// Countryside
	bool countryCheck = settings["country_end"] && current.mpassed == 1 && current.mpassed != old.mpassed && current.sc == "trevor3";
	
	// Deep Inside
	bool deepCheck = settings["deep"] && current.mpassed == 1 && current.mpassed != old.mpassed && current.sc == "carsteal3";

	// Paleto Score
	bool paletoCheck = settings["paleto_end"] && current.mpassed == 1 && current.mpassed != old.mpassed && current.sc == "rural_bank_heist"; 

	// Fresh Meat
	bool freshCheck = settings["fresh_meat_end"] && current.mpassed == 1 && current.mpassed != old.mpassed && current.sc == "michael2";

	// Bureau Raid
	bool raidCheck = settings["bureau_end"] && current.mpassed == 1 && current.mpassed != old.mpassed && current.sc.StartsWith("agency_heist3");

	// Epsilon Program
	bool epsilonCheck = settings["epsilon_end"] && current.mpassed == 1 && current.mpassed != old.mpassed && current.sc == "epsilon8";

	// All Strangers and Freaks
	bool asfCheck = settings["asf_end"] && current.mpassed == 1 && current.mpassed != old.mpassed && current.sc == "fanatic1";

	// Return true if any of the above flags are true.
	vars.justSplit = /* missionCheck  || /* sfCheck ||  altSfCheck || */ stuntCheck /* || bridgeCheck */ || eventCheck || hobbyCheck || hundoCheck || golfCheck || endingCheck || endingACheck || trevisCheck || countryCheck || deepCheck || paletoCheck || freshCheck || raidCheck || collectibleCheck || epsilonCheck || asfCheck;

	foreach (var collectible in vars.collectibleIDs) {
		vars.currentValue = (vars.collectibleAddressWatchers[collectible.Value].Current + 0x10 & 0xFFFFFFFF) ^ vars.collectibleValueWatchers[collectible.Value].Current;
		vars.oldValue = (vars.collectibleAddressWatchers[collectible.Value].Old + 0x10 & 0xFFFFFFFF) ^ vars.collectibleValueWatchers[collectible.Value].Old;
		if (settings[collectible.Value] && (vars.currentValue > vars.oldValue))
		{
			vars.justSplit = true;
		}
	};

	foreach (var flag in vars.epsilonFlags) {
		if (settings[flag.Value] && (vars.flagsWatchers[flag.Value].Current > vars.flagsWatchers[flag.Value].Old) && !vars.splits.Contains(flag.Value)) {
			vars.justSplit = true;
			vars.splits.Add(flag.Value);
		}
	}

	foreach (var mission in vars.missionList) {
		if (settings[mission] && (vars.missionWatchers[mission].Current > vars.missionWatchers[mission].Old) && !vars.splits.Contains(mission)) {
			vars.justSplit = true;
			vars.splits.Add(mission);
		}
	}

	foreach (var freaks in vars.freaksList) {
		if (settings.ContainsKey(freaks) && settings[freaks] && (((vars.freaksWatchers[freaks].Current >> 3) & 1) > ((vars.freaksWatchers[freaks].Old >> 3) & 1)) && !vars.splits.Contains(freaks)) {
			vars.justSplit = true;
			vars.splits.Add(freaks);
		}
	}

	return vars.justSplit;
}
