params ["_unit", ["_partIndex", -1]];

//if (isServer && !hasInterface) exitWith {};

// dawg you gotta rewrite this. this is so messy. - past andy to future andy

if (isNil {_unit getVariable "ANDY1_FUBAR_status"}) then {
    _unit setVariable ["ANDY1_FUBAR_status", "NORMAL", true];
} else {
    private _status = _unit getVariable "ANDY1_FUBAR_status";
    if ((_status != "FUBAR") && (_status != "CRITICAL") && (_status != "SEVERE")) then {
        [_unit, 0.5, 90] call ANDY1_fnc_FUBAR_chanceUncon;
    };
};
if (isNil {_unit getVariable "ANDY1_FUBAR_bodyPartsHP"}) then {
    /*
    
    0 - head 
    1 - neck

    2 - chest 
    3 - abdomen
    4 - pelvis

    5 - left arm
    6 - right arm
    7 - left hand 
    8 - right hand

    9 - left leg
    10 - right leg
    11 - left foot
    12 - right foot
    
    */
    _unit setVariable ["ANDY1_FUBAR_bodyPartsHP", [
        0, // 0 - head
        0, // 1 - neck

        0, // 2 - chest
        0, // 3 - abdomen
        0, // 4 - pelvis
        
        0, // 5 - left arm
        0, // 6 - right arm
        0, // 7 - left hand
        0, // 8 - right hand

        0, // 9 - left leg
        0, // 10 - right leg
        0, // 11 - left foot
        0  // 12 - right foot
    ], true];
};


private _bodyPartsHP = _unit getVariable "ANDY1_FUBAR_bodyPartsHP";
if (_partIndex != -1) then {
    switch (_partIndex) do {
        case 0: { //HEAD
            _bodyPartsHP set [_partIndex, ((_bodyPartsHP#_partIndex) + (round random [1, 8, 10]))];
        };
        case 1: { //NECK
            _bodyPartsHP set [_partIndex, ((_bodyPartsHP#_partIndex) + (round random [1, 6, 10]))];
        };
        case 2: { //CHEST
            _bodyPartsHP set [_partIndex, ((_bodyPartsHP#_partIndex) + (round random [1, 2, 10]))];
        };
        case 3: { //ABDOMEN
            _bodyPartsHP set [_partIndex, ((_bodyPartsHP#_partIndex) + (round random [1, 2, 8]))];
        };
        case 4: { //PELVIS
            _bodyPartsHP set [_partIndex, ((_bodyPartsHP#_partIndex) + (round random [1, 2, 8]))];
        };
        default {};
    };
    systemChat str _bodyPartsHP; // DEBUG
    _unit setVariable ["ANDY1_FUBAR_bodyPartsHP", _bodyPartsHP, true];
};

// TODO: INSTEAD OF THE BELOW, SORT THE BODYPARTS HP ARRAY INTO A TEMPORARY VARIABLE
// THE TEMPORARY VARIABLE WILL STORE THE HIGHEST DAMAGED BODY PART.
// THE HIGHEST DAMAGED BODYPART WILL DETERMINE THE STATUS OF THE PLAYER.
// MAY CHANGE IN FUTURE TO DETERMINE USING TOTAL DAMAGE / A FORMULA RATHER THAN INDIVIDUAL BODY PARTS 
// ^ (AS IT IGNORES IF YOU HAVE MULTIPLE WOUNDED BODYPARTS WHICH WOULD RESULT IN DEATH)
// THEN IT WILL APPLY ADDACTIONS ACCORDINGLY TO TREAT INDIVIDUAL BODYPARTS (IF A MEDKIT IS PRESENT IN INVENTORY)
if (isNil {_unit getVariable "ANDY1_FUBAR_actions"}) then {
    _unit setVariable ["ANDY1_FUBAR_actions", [], true];
} else {
    {
        [_unit,_x] call BIS_fnc_holdActionRemove;
    } forEach (_unit getVariable "ANDY1_FUBAR_actions");
    _unit setVariable ["ANDY1_FUBAR_actions", nil, true];
};
{
    private _bodyPartName = [_forEachIndex] call ANDY1_fnc_FUBAR_getBodyPart;
    private _severity = "";
    if (_x >= 0) then {
        _severity = "NORMAL";
    };
    if (_x >= 1) then {
        _severity = "MINOR";
    };
    if (_x >= 2.5) then {
        _severity = "MODERATE";
    };
    if (_x >= 4.5) then {
        _severity = "SERIOUS";
    };
    if (_x >= 5.5) then {
        _severity = "SEVERE";
    };
    if (_x >= 6.5) then {
        _severity = "CRITICAL";
    };
    if (_x >= 7.5) then {
        _severity = "CRITICAL";
    };
    if (_x >= 10) then {
        _severity = "MISSING";
    };
    [_unit, (_forEachIndex), _bodyPartName, _severity] remoteExecCall ["ANDY1_fnc_FUBAR_treatment_action", [0,-2] select isDedicated];
} forEach _bodyPartsHP;

// finds the most damaged bodypart to determine status of player
// do not use sort false; it will not work as expected due to REFERENCE
private _sorted_BodyPartsHP = [_bodyPartsHP, [], {_x}, "DESCEND"] call BIS_fnc_sortBy;
systemChat str _sorted_BodyPartsHP; // DEBUG
_damaged_BodyPartHP = (_sorted_BodyPartsHP select 0);
[_unit, _damaged_BodyPartHP] spawn {
    _unit = _this select 0;
    _damaged_BodyPartHP = _this select 1;
    sleep 0.5;
    if (_damaged_BodyPartHP >= 10) exitWith {
        _unit setVariable ["ANDY1_FUBAR_status", "FUBAR", true];
        [_unit, 3, 25] call ANDY1_fnc_FUBAR_chanceUncon;
    };
    if (_damaged_BodyPartHP >= 8) exitWith {
        _unit setVariable ["ANDY1_FUBAR_status", "FUBAR", true];
        _unit setDamage 0.95;
        [_unit, 1.5, 35] call ANDY1_fnc_FUBAR_chanceUncon;
    };
    if (_damaged_BodyPartHP >= 6.5) exitWith {
        _unit setVariable ["ANDY1_FUBAR_status", "CRITICAL", true];
        _unit setDamage 0.9;
        [_unit, 1.25, 50] call ANDY1_fnc_FUBAR_chanceUncon;
    };
    if (_damaged_BodyPartHP >= 5.5) exitWith {
        _unit setVariable ["ANDY1_FUBAR_status", "SEVERE", true];
        _unit setDamage 0.8;
        _unit setUnconscious false;
        [_unit, 1, 60] call ANDY1_fnc_FUBAR_chanceUncon;
    };
    if (_damaged_BodyPartHP >= 4.5) exitWith {
        _unit setVariable ["ANDY1_FUBAR_status", "SERIOUS", true];
        _unit setDamage 0.6;
        _unit setUnconscious false;
        [_unit, 1, 70] call ANDY1_fnc_FUBAR_chanceUncon;
    };
    if (_damaged_BodyPartHP >= 2.5) exitWith {
        _unit setVariable ["ANDY1_FUBAR_status", "MODERATE", true];
        _unit setDamage 0.3;
        _unit setUnconscious false;
        [_unit, 0.75, 80] call ANDY1_fnc_FUBAR_chanceUncon;
    };
    if (_damaged_BodyPartHP >= 1) exitWith {
        _unit setVariable ["ANDY1_FUBAR_status", "MINOR", true];
        _unit setDamage 0.1;
        [_unit, 0.5, 90] call ANDY1_fnc_FUBAR_chanceUncon;
    };
    if (_damaged_BodyPartHP >= 0) then {
        _unit setVariable ["ANDY1_FUBAR_status", "NORMAL", true];
        _unit setDamage 0;
        if (incapacitatedState _unit == "UNCONSCIOUS") then {
            _unit setUnconscious false;
            [_unit, "AmovPpneMstpSnonWnonDnon"] remoteExecCall ["playMoveNow", 0];
        };
    };
};

/*
{
    if (_x >= 0.95) exitWith {
        _unit setVariable ["ANDY1_FUBAR_status", "FUBAR", true];
    };
    if (_x >= 0.9) exitWith {
        _unit setVariable ["ANDY1_FUBAR_status", "CRITICAL", true];
    };
    if (_x >= 0.8) exitWith {
        _unit setVariable ["ANDY1_FUBAR_status", "SEVERE", true];
    };
    if (_x >= 0.6) exitWith {
        _unit setVariable ["ANDY1_FUBAR_status", "SERIOUS", true];
    };
    if (_x >= 0.3) exitWith {
        _unit setVariable ["ANDY1_FUBAR_status", "MODERATE", true];
    };
    if (_x >= 0.1) exitWith {
        _unit setVariable ["ANDY1_FUBAR_status", "MINOR", true];
    };
    if (_x >= 0) then {
        _unit setVariable ["ANDY1_FUBAR_status", "NORMAL", true];
    };
} forEach (_unit getVariable "ANDY1_FUBAR_bodyPartsHP");

_ANDY1_fnc_setDamage = {
    params ["_unit"];
    switch (_unit getVariable "ANDY1_FUBAR_status") do {
        case "FUBAR": {
            _unit spawn {
                // i guess that's it for you
                // TODO: heartbeat sound (die)
                sleep 7;
                _this setDamage 1;
            };
        };
        case "CRITICAL": {
            _unit setDamage 0.95;
        };
        case "SEVERE": {
            _unit setDamage 0.9;
        };
        case "SERIOUS": {
            _unit setDamage 0.8;
        };
        case "MODERATE": {
            _unit setDamage 0.6;
        };
        case "MINOR": {
            _unit setDamage 0.3;
        };
        case "NORMAL": {
            _unit setDamage 0;
        };
    };
};
*/
/*if (damage _unit >= 0.95) exitWith {
    _unit setVariable ["ANDY1_FUBAR_status", "FUBAR", true];
    _unit call _ANDY1_fnc_setDamage;
};
if (damage _unit >= 0.9) exitWith {
    _unit setVariable ["ANDY1_FUBAR_status", "CRITICAL", true];
    _unit call _ANDY1_fnc_setDamage;
};
if (damage _unit >= 0.8) exitWith {
    _unit setVariable ["ANDY1_FUBAR_status", "SEVERE", true];
    _unit call _ANDY1_fnc_setDamage;
};
if (damage _unit >= 0.6) exitWith {
    _unit setVariable ["ANDY1_FUBAR_status", "SERIOUS", true];
    _unit call _ANDY1_fnc_setDamage;
};
if (damage _unit >= 0.3) exitWith {
    _unit setVariable ["ANDY1_FUBAR_status", "MODERATE", true];
    _unit call _ANDY1_fnc_setDamage;
};
if (damage _unit >= 0.1) exitWith {
    _unit setVariable ["ANDY1_FUBAR_status", "MINOR", true];
    _unit call _ANDY1_fnc_setDamage;
};
if (damage _unit == 0) exitWith {
    _unit setVariable ["ANDY1_FUBAR_status", "NORMAL", true];
    _unit call _ANDY1_fnc_setDamage;
};*/