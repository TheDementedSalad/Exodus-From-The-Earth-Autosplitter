// Exodus From the Earth Load Remover & Autosplitter Version 1.0.0 03/02/2022
// Supports Load Remover IGT
// Supports full chapter splits
// Splits can be obtained from 
// Script by TheDementedSalad, Ellie & SabulineHorizon
// Cutscene/inGamePause addresses found by TheDementedSalad
// XYZ pointers & Chap ID found by nikvel
// Map clusters added by Ellie
// Original Load Remover by Deluxyze



state("efte")
{
    bool 		inGame			: 0x96FDA8, 0x38, 0x4C;
	bool		inGamePause		: 0x95E521;
	bool		Cutscene		: 0x9A8D04;
	int			Chapter			: 0x992948, 0x4AC;
	float 		X				: 0x978CE0, 0x0, 0x228;
	float 		Y				: 0x978CE0, 0x0, 0x238;
	float 		Z				: 0x978CE0, 0x0, 0x248;
}

startup
{
	if (timer.CurrentTimingMethod == TimingMethod.RealTime)
// Asks user to change to game time if LiveSplit is currently set to Real Time.
    {        
        var timingMessage = MessageBox.Show (
            "This game uses Time without Loads (Game Time) as the main timing method.\n"+
            "LiveSplit is currently set to show Real Time (RTA).\n"+
            "Would you like to set the timing method to Game Time?",
            "LiveSplit | Exodus from the Earth",
            MessageBoxButtons.YesNo,MessageBoxIcon.Question
        );

        if (timingMessage == DialogResult.Yes)
        {
            timer.CurrentTimingMethod = TimingMethod.GameTime;
        }
    }
	
	vars.completedSplits = new List<int>();
	vars.end = 0;
	vars.chap14 = 0;
	
	settings.Add("Chap", false, "Chapters");
	vars.Levels = new Dictionary<string,string>
	{
		{"278","Welcome to the A.X"}, 
		{"73","Alarm"}, 
		{"147","The Alternative Route"}, 
		{"407","The Melting Workshop"}, 
		{"104","The Warehouse"}, 
		{"348","A Hot Place"}, 
		{"57","The Administrative Complex, Office Facilities"}, 
		{"264","Frank Was Here"}, 
		{"350","Warehouse II: Logistics A-La Frank"}, 
		{"4","Container Jungles"}, 
		{"193","A Dream?"}, 
		{"270","The Transport Tunnel"}, 
		{"14Start","Project ZERO: Testing Area"}, 
		{"524","Early Loss - START HERE IF DOING CH13 SKIP"}, 
		{"470","Following the Old Tracks"}, 
		{"341","Escape"}, 
		{"626","Breakthrough"}, 
		{"145","Race With Troubles"}, 
		{"867","The Dam"}, 
		{"1140","The Way to the Cosmoport"}, 
		{"650","The Finishing Spurt"}, 
		{"585","To the Stars"}, 
		{"266","Soft Landing"}, 
		{"21","The A.X Plantation"}, 
		{"248","The A.X Extraction Complex"}, 
		{"531","The Hardening Plant"}, 
		{"109","The Moment of Truth"}, 
		{"130","Explosive Temper"}, 
		{"177","Caution! Loaded!"},
		{"123","Time To Get Out"},
	};
		
	foreach (var Tag in vars.Levels){
		settings.Add(Tag.Key, false, Tag.Value, "Chap");
    };

	settings.CurrentDefaultParent = null;
	
	settings.Add("End", true, "He Who Laughs Last - Always Active");
}

init
{
	vars.ChapID = new List<int>()
	{278,73,147,104,348,57,264,350,4,193,270,524,470,341,626,145,867,1140,650,585,266,21,248,531,109,130,177,123};
}

update
{
	if(timer.CurrentPhase == TimerPhase.NotRunning)
	{
		vars.completedSplits.Clear();
		vars.end = 0;
		vars.chap14 = 0;
		
	vars.ChapID = new List<int>()
	{278,73,147,104,348,57,264,350,4,193,270,524,470,341,626,145,867,1140,650,585,266,21,248,531,109,130,177,123};
	}
}

start
{
	// Timer starts if the "Game Saved" text is visible while the player is at the starting XYZ coordinates
	return !current.inGamePause && old.inGamePause && current.Chapter == 144;
}

onStart
{
    // This makes sure the timer always starts at 0.00
    timer.IsGameTimePaused = true;
}

split
{
	vars.ChapStr = current.Chapter.ToString();
	
	if(!current.inGamePause && vars.ChapID.Contains(current.Chapter) && !vars.completedSplits.Contains(current.Chapter) && settings["" + current.Chapter]){
			vars.ChapID.Remove(current.Chapter);
			vars.completedSplits.Add(current.Chapter);
			return true;
		}
	
	if(vars.chap14 == 0){
		if(settings["14Start"] && current.inGamePause && current.X > 6 && current.X < 9 && current.Y > -4 && current.Y < 0 && current.Z > 17 && current.Z < 21){
			vars.chap14++;
			return true;
		}
	}
	
	if(vars.end == 0){
		if(!current.Cutscene && current.X > 100 && current.X < 105 && current.Y > 11 && current.Y < 13 && current.Z > 10 && current.Z < 16){
			vars.end++;
			return true;
		}
	}
}

isLoading
{
    return !current.inGame;
}

exit
{
    //pauses timer if the game crashes
	timer.IsGameTimePaused = true;
}

reset
{
	return current.inGame && !old.inGame && current.X > 6 && current.X < 9 && current.Y > 3 && current.Y < 5 && current.Z > -62 && current.Z < -57;
}
