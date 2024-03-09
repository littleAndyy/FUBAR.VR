class CfgFunctions
{
	class andy1
	{
		class FUBAR
		{
            file = "FUBAR";
			class FUBAR_initMan {};
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
    class FUBAR_RadioIn
    {
        name = "FUBAR_RadioIn";
        sound[] = {"FUBAR\FUBAR_RadioBeep.ogg", 1, 1};
        titles[] = {};
    };
};