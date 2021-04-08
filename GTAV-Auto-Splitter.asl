// GTA V Autosplitter for version 1.27
// Contributors: hoxi, TheStonedTurtle, Crab1k, Gogsi123, FriendlyBaron, burhac, Rake Jyals and other community members
// For any questions, ask in the GTA V Speedrunning Discord: https://discord.gg/3qjGGBM

// Social Club
state("GTA5")
{
	// mission counter
	int m: 0x2A07E70, 0xBDA08;

	// strangers and freaks counter
	int s: 0x2A07E70, 0xBDA20;

	// usj counter
	int u: 0x2A07E70, 0xCE5C0;

	// bridge counter
	int b: 0x2A07EC8, 0x40318;

	// random event counter
	int r: 0x2A07E70, 0xBDA28;

	// hobbies and pasttimes
	int h: 0x2A07E70, 0xBDA10;

	// current cutscene
	string255 c: 0x01CB44A0, 0xB70;

	// current script
	string255 sc: 0x1CB4340;
	
	// loading check
	int loading: 0x2153C30;

	// percentage counter
	float percent: 0x0218FAD8, 0x18068;

	// current golf hole
	int gh: 0x1DE3970;

	// in cutscene
	byte in_c: 0x1CB4472;

	// in mission
	byte in_m: 0x22959C3;

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
	vars.missionScripts = new Dictionary<string,string> {
		{"prologue1", "Prologue"},
		{"armenian1", "Franklin & Lamar"},
		{"armenian2", "Repossesion"},
		{"franklin0", "Chop"},
		{"armenian3", "Complications"},
		{"family1", "Father/Son"},
		{"family3", "Marriage Counseling"},
		{"lester1", "Friend Request"},
		{"family2", "Daddy's Little Girl"},
		{"jewelry_setup1", "Casing the Jewel Store"},
		{"jewelry_prep1b", "Carbine Rifles"},
		{"jewelry_heist", "The Jewel Store Job"},
		{"lamar1", "The Long Stretch"},
		{"trevor1", "Mr. Philips"},
		{"chinese1", "Trevor Philips Industries"},
		{"trevor2", "Nervous Ron"},
		{"chinese2", "Crystal Maze"},
		{"trevor3", "Friends Reunited"},
		{"family4", "Fame or Shame"},
		{"fbi1", "Dead Man Walking"},
		{"fbi2", "Three's Company"},
		{"franklin1", "Hood Safari"},
		{"docks_setup", "Scouting the Port"},
		{"family5", "Did Somebody Say Yoga?"},
		{"fbi3", "By The Book"},
		{"docks_prep1", "Minisub"},
		{"fbi4_intro", "Blitz Play Intro"},
		{"fbi4_prep1", "Garbage Truck"},
		{"fbi4_prep2", "Tow Truck"},
		{"fbi4_prep4", "Masks"},
		{"fbi4_prep5", "Boiler Suits"},
		{"docks_heista", "Merryweather Heist (A)"},
		{"docks_heistb", "Merryweather Heist (B)"},
		{"fbi4", "Blitz Play"},
		{"carsteal1", "I Fought The Law"},
		{"carsteal2", "Eye in the Sky"},
		{"solomon1", "Mr. Richards"},
		{"martin1", "Caida Libre"},
		{"carsteal3", "Deep Inside"},
		{"exile1", "Minor Turbulence"},
		{"rural_bank_setup", "Paleto Score Setup"},
		{"exile2", "Predator"},
		{"rural_bank_prep1", "Military Hardware"},
		{"rural_bank_heist", "Paleto Score"},
		{"exile3", "Derailed"},
		{"fbi5a", "Monkey Business"},
		{"trevor4", "Hang Ten"},
		{"finale_heist1", "Surveying the Score"},
		{"michael1", "Bury the Hatchet"},
		{"carsteal4", "Pack Man"},
		{"michael2", "Fresh Meat"},
		{"solomon2", "Ballad of Rocco"},
		{"agency_heist1", "Cleaning out the Bureau"},
		{"family6", "Reuniting the Family"},
		{"agency_heist2", "Architect's Plans"},
		{"agency_heist3a", "Bureau Raid (A)"},
		{"agency_heist3b", "Bureau Raid (B)"},
		{"solomon3", "Legal Trouble"},
		{"michael3", "The Wrap Up"},
		{"franklin2", "Lamar Down"},
		{"michael4", "Meltdown"},
		{"finale_heist2_intro", "Big Score Intro"},
		{"finale_heist_prepc", "Gauntlet"},
		{"finale_heist_prepa", "Stingers"},
		{"finale_heist2a", "The Big One (A)"},
		{"finale_heist2b", "The Big One (B)"},
		{"assassin_valet", "The Hotel Assassination"},		
		{"assassin_multi", "The Multi-Target Assassination"},		
		{"assassin_hooker", "The Vice Assassination"},
		{"assassin_bus", "The Bus Assassination"},
		{"assassin_construction", "The Construction Assassination"}		
	};

	vars.freaksScripts = new Dictionary<string,string> {		
		{"tonya1", "Pulling Favours"},
		{"tonya2", "Pulling Another Favour"},
		{"tonya3", "Pulling Favours Again"},
		{"tonya4", "Still Pulling Favours"},
		{"tonya5", "Pulling One Last Favour"},
		{"hao1", "Shift Work"},
		{"paparazzo1", "Paparazzo"},
		{"paparazzo2", "Paparazzo - The Sex Tape"},
		{"paparazzo3a", "Paparazzo - The Meltdown"},
		{"paparazzo4", "Paparazzo - Reality Check"},
		{"omega1", "Far Out"},
		{"omega2", "The Final Frontier"},
		{"barry3a", "Grass Roots - The Pickup"},
		{"barry4", "Grass Roots - The Smoke-in"},
		{"extreme1", "Risk Assesstment"},
		{"extreme2", "Liqudity Risk"},
		{"extreme3", "Targeted Risk"},
		{"extreme4", "Uncalculated Risk"},
		{"fanatic3", "Exercising Demons - Franklin"},
		{"dreyfuss1", "A Starlet in Vinewood"}
	};	

	vars.endings = new Dictionary<string,string> {
		{"fin_a_ext", "Something Sensible (Kill Trevor)"},
		{"fin_b_ext", "The Time's Come (Kill Michael)"},
		{"fin_ext_p2", "The Third Way (Deathwish)"}
	};

	// add settings groups
	settings.Add("main", true, "Main");
	settings.Add("collectibles", false, "Collectibles");
	settings.Add("misc", false, "Miscellaneous");
	settings.Add("starters", true, "Auto Starters");
	settings.Add("timerend", true, "Auto Finishers");

	// split on Missions
	settings.Add("missions", true, "Missions", "main");

	// Add missions to setting list
	foreach (var script in vars.missionScripts) {
		settings.Add(script.Key, true, script.Value, "missions");
	}		

	settings.SetToolTip("finale_heist_prepc", "Only splits for the first Gauntlet.");

	// split on Strangers and Freaks
	settings.Add("sf", false, "Strangers and Freaks", "main");

	// Add strangers and freaks to setting list
	foreach (var Script in vars.freaksScripts) {
		settings.Add(Script.Key, true, Script.Value, "sf");
	}	

	// split on 100% completion
	settings.Add("100", false, "100% Completion", "main");
	settings.SetToolTip("100", "Split when the percentage counter reaches 100%."); 

	// split on stunt jumps
	settings.Add("stuntjumps", false, "Stunt Jumps", "collectibles");
	
	// split on under the bridge
	settings.Add("bridges", false, "Under The Bridge", "collectibles");
	
	// split on Random Events
	settings.Add("randomevent", false, "Random Event", "collectibles");
	
	// split on Hobbies and Pasttimes
	settings.Add("hobbies", false, "Hobbies and Pasttimes", "collectibles");

	// split on other collectibles
	settings.Add("other_collectibles", false, "Spaceship Parts/Letters/Monkey Mosaics/Peyotes", "collectibles");

	// Save Warping
	settings.Add("savewarp", true, "Don't Split when save warping", "misc");

	// Golf autosplitter
	settings.Add("golf", false, "Split on every Golf hole", "misc");

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
	settings.SetToolTip("misctimer", "Used for misc. categories");

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
		{"blitz_end", "Blitz Play"},
		{"deep", "Deep Inside"},
		{"paleto_end", "Paleto Score"},
		{"fresh_meat_end", "Fresh Meat"},
		{"bureau_end", "Bureau Raid"}
	};

	// Add actual segments
	foreach(var Segment in vars.segmentsEnd) {
		settings.Add(Segment.Key, true, Segment.Value, "segments_end");
	};
}


init
{
	// Checks if name is enabled in settings and returns true if the diff is exactly one
	Func<string, int, bool> shouldSplit = (name, diff) => {
		// Check if anything changed and if this type of split is enabled
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

	if (vars.justStarted || vars.justSplit || hasChangedPhase) {
		vars.loadHistory.Clear();
		vars.miscFlag = false;
		if (!vars.justSplit) {
			vars.splits.Clear();
		}
	}

	vars.justStarted = false;
	vars.justSplit = false;
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
	bool scriptNameCheck = settings.ContainsKey(current.sc) && settings[current.sc] && !vars.splits.Contains(current.sc);

	// check if mission counter increased
	bool mCounterCheck = vars.shouldSplit("missions", current.m - old.m);
	bool missionCheck = scriptNameCheck && mCounterCheck;

	// check if strangers and freaks counter increased
	bool sfCounterCheck = vars.shouldSplit("sf", current.s - old.s);
	bool sfCheck = scriptNameCheck && sfCounterCheck;

	// check if stunt jumps counter increased
	bool stuntCheck = vars.shouldSplit("stuntjumps", current.u - old.u);

	// check if bridges counter changed
	bool bridgeCheck = vars.shouldSplit("bridges", current.b - old.b);

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
	bool collectibleCheck = settings["other_collectibles"] && current.collectible == 1 && current.collectible != old.collectible && current.b == old.b;

	// Segment end splits
	// Trevor%
	bool trevisCheck = settings["trevis"] && current.mpassed == 1 && current.mpassed != old.mpassed && current.sc == "jewelry_heist";

	// Countryside
	bool countryCheck = settings["country_end"] && current.mpassed == 1 && current.mpassed != old.mpassed && current.sc == "trevor3";

	// Blitz Play
	bool blitzCheck = settings["blitz_end"] && current.mpassed == 1 && current.mpassed != old.mpassed && current.sc == "fbi4";
	
	// Deep Inside
	bool deepCheck = settings["deep"] && current.mpassed == 1 && current.mpassed != old.mpassed && current.sc == "carsteal3";

	// Paleto Score
	bool paletoCheck = settings["paleto_end"] && current.mpassed == 1 && current.mpassed != old.mpassed && current.sc == "rural_bank_heist"; 

	// Fresh Meat
	bool freshCheck = settings["fresh_meat_end"] && current.mpassed == 1 && current.mpassed != old.mpassed && current.sc == "michael2"; 

	// Bureau Raid
	bool raidCheck = settings["bureau_end"] && current.mpassed == 1 && current.mpassed != old.mpassed && current.sc.StartsWith("agency_heist3"); 

	// Return true if any of the above flags are true.
	vars.justSplit = missionCheck || sfCheck || stuntCheck || bridgeCheck || eventCheck || hobbyCheck || hundoCheck || golfCheck || endingCheck || endingACheck || trevisCheck || countryCheck || blitzCheck || deepCheck || paletoCheck || freshCheck || raidCheck || collectibleCheck;

	return vars.justSplit;
}
