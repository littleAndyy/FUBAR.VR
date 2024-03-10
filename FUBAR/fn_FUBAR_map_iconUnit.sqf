params ["_group"];

if (isNil "ANDY1_FUBAR_grpArray") then {ANDY1_FUBAR_grpArray = []};

sleep (1 + (random 1));

ANDY1_FUBAR_grpArray pushBack _group;

findDisplay 12 displayCtrl 51 ctrlAddEventHandler ["Draw", {
	{_this select 0 drawIcon [
		"\A3\ui_f\data\map\markers\nato\b_inf.paa",
		([side _x, false] call BIS_fnc_sideColor),
		getPosASLVisual (leader _x),
		18,
		18,
		0,
		(groupId _x),
		1,
		0.03,
		"RobotoCondensedLight",
		"right"
	]}
    forEach ANDY1_FUBAR_grpArray;
}];
