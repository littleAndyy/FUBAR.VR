params ["_unit"];

if (!isServer) exitWith {};
if (_unit == leader _unit) then {
    _unit setVariable ["ANDY1_FUBAR_isLeader", true];

    group _unit addEventHandler ["LeaderChanged", {
        params ["_group", "_newLeader"];
        {
            if (_x getVariable "ANDY1_FUBAR_isLeader") then {
                _x setVariable ["ANDY1_FUBAR_isLeader", false];
            };
        } forEach _group;
        _newLeader setVariable ["ANDY1_FUBAR_isLeader", true];
    }];
    
    group _unit addEventHandler ["EnemyDetected", {
        params ["_group", "_newTarget"];
        [(leader _group), format ["Contact! Grid %1", mapGridPosition _newTarget]] remoteExecCall ["sideChat", [0,-2] select isDedicated];
    }];
};