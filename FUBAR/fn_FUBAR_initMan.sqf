params ["_unit"];

if (!isServer) exitWith {};

_unit call ANDY1_fnc_FUBAR_dmgMain;

if (_unit == leader _unit) then {
    _unit setVariable ["ANDY1_FUBAR_isLeader", true];

    _unit addEventHandler ["Killed", {
        params ["_unit", "_killer", "_instigator", "_useEffects"];
        _x setVariable ["ANDY1_FUBAR_isLeader", nil];
    }];
    _unit addEventHandler ["Deleted", {
        _x setVariable ["ANDY1_FUBAR_isLeader", nil];
    }];
    
    if (isNil {group _unit getVariable "ANDY1_FUBAR_groupEHs"}) then {
        private _groupEHs = [];
        _gEH = group _unit addEventHandler ["LeaderChanged", {
            params ["_group", "_newLeader"];
            {
                if (_x getVariable "ANDY1_FUBAR_isLeader") then {
                    _x setVariable ["ANDY1_FUBAR_isLeader", false];
                };
            } forEach units _group;
            _newLeader call ANDY1_fnc_FUBAR_initMan;
        }];
        _groupEHs pushBack _gEH;
        _gEH = group _unit addEventHandler ["EnemyDetected", {
            params ["_group", "_newTarget"];
            {
                if (side _x == side _group) then {
                    ["FUBAR_RadioBeep"] remoteExecCall ["playSound", _x];
                };
            } forEach allPlayers;
            [(leader _group), format ["Contact! Grid %1", mapGridPosition _newTarget]] remoteExecCall ["sideChat", [0,-2] select isDedicated];
        }];
        _groupEHs pushBack _gEH;
        group _unit setVariable ["ANDY1_FUBAR_groupEHs", _groupEHs];
        (group _unit) remoteExec ["ANDY1_fnc_FUBAR_map_iconUnit", [0,-2] select isDedicated, (group _unit)];
    };
};