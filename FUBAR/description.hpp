class CfgFunctions
{
	class andy1
	{
		class FUBAR
		{
            file = "FUBAR";
			class FUBAR_initMan {};
            class FUBAR_map_iconUnit {};
            class FUBAR_map_projectiles {};
            class FUBAR_dmgMain {};
            class FUBAR_dmgPart_head {};
            class FUBAR_dmgCheck {};
            class FUBAR_treatment_action {};
            class FUBAR_getBodyPart {};
            class FUBAR_chanceUncon {};
		};
	};
};

class Extended_Init_EventHandlers
{
    class CAManBase
    {
        class ANDY1_FUBAR_initServer {
            serverInit = "_this call ANDY1_fnc_FUBAR_initMan;";
        };
    };
};

class cfgSounds 
{
    sounds[] = {};
    class FUBAR_RadioBeep
    {
        name = "FUBAR_RadioBeep";
        sound[] = {"FUBAR\radioBeep.ogg", 0.25, 1};
        titles[] = {};
    };
};