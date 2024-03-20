params ["_unit", ["_partIndex", -1]];

if (isServer && !hasInterface) exitWith {};

// dawg you gotta rewrite this. this is so messy. - past andy to future andy

if (isNil {_unit getVariable "ANDY1_FUBAR_status"}) then {
    _unit setVariable ["ANDY1_FUBAR_status", "NORMAL", true];
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
        [
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
        ]
    ], true];
};

private _bodyPartsHP = _unit getVariable "ANDY1_FUBAR_bodyPartsHP";
switch (_partIndex) do {
    case 0: { //HEAD
        _bodyPartsHP set [_partIndex, ((_bodyPartsHP[_partIndex]) + (random [0.05, 0.6, 1]))];
    };
    case 1: { //NECK
        _bodyPartsHP set [_partIndex, ((_bodyPartsHP[_partIndex]) + (random [0.05, 0.6, 1]))];
    };
    case 2: { //CHEST
        _bodyPartsHP set [_partIndex, ((_bodyPartsHP[_partIndex]) + (random [0.05, 0.2, 1]))];
    };
    case 3: { //ABDOMEN
        _bodyPartsHP set [_partIndex, ((_bodyPartsHP[_partIndex]) + (random [0.05, 0.1, 0.8]))];
    };
    case 4: { //PELVIS
        _bodyPartsHP set [_partIndex, ((_bodyPartsHP[_partIndex]) + (random [0.05, 0.1, 0.8]))];
    };
};
_unit setVariable ["ANDY1_FUBAR_bodyPartsHP", _bodyPartsHP, true];

// TODO: INSTEAD OF THE BELOW, SORT THE BODYPARTS HP ARRAY INTO A TEMPORARY VARIABLE
// THE TEMPORARY VARIABLE WILL STORE THE HIGHEST DAMAGED BODY PART.
// THE HIGHEST DAMAGED BODYPART WILL DETERMINE THE STATUS OF THE PLAYER.
// MAY CHANGE IN FUTURE TO DETERMINE USING TOTAL DAMAGE / A FORMULA RATHER THAN INDIVIDUAL BODY PARTS 
// ^ (AS IT IGNORES IF YOU HAVE MULTIPLE WOUNDED BODYPARTS WHICH WOULD RESULT IN DEATH)
// THEN IT WILL APPLY ADDACTIONS ACCORDINGLY TO TREAT INDIVIDUAL BODYPARTS (IF A MEDKIT IS PRESENT IN INVENTORY)


// function for unconscious chance based on multipler given (usually increase multiplier + limit in more serious conditions)
_ANDY1_fnc_unconsciousChance = {
    params ["_unit", "_multiplier", "_unconsciousLimit"];
    private _unconsciousChance = ((round random 100) * _multiplier); //25/80 = not unconscious. 60/50 = unconscious.
    if (_unconsciousChance > _unconsciousLimit) then {
        _unit setUnconscious true;
    };
    // dead asf
    if (_unconsciousChance > 100) then {
        _unit setDamage 1;
    };
};
_ANDY1_fnc_treatment_applyAddAction = {
    params ["_unit", "_bodyPartName", "_severity"];
    [
        _unit,
        (format ["Treat %1 | CONDITION: %2", _bodyPartName, _severity]),
        "", "",
        "_this distance _target < 3",
        "_caller distance _target < 3",
        {},
        {},
        {
            //TODO: ADD CODE HERE - CHANCE TO SUCCEED. _caller HAS MEDICAL EQUIPMENT? (BASIC FOR NOW)
        },
        {},
        [],
        (round random 7),
        0,
        true,
        false
    ] remoteExecCall ["BIS_fnc_holdActionAdd", [0,-2] select isDedicated, _unit]; // will stay on unit until deleted . . . JIP compatible
};
// finds the most damaged bodypart to determine status of player
private _sorted_BodyPartsHP = _bodyPartsHP;
_sorted_BodyPartsHP sort true;
_damaged_BodyPartHP = (_sorted_BodyPartsHP select 0);
if (_damaged_BodyPartHP >= 1) exitWith {
    _unit setVariable ["ANDY1_FUBAR_status", "FUBAR", true];
    [_unit, 1.5, 50] call _ANDY1_fnc_unconsciousChance;
};
if (_damaged_BodyPartHP >= 0.75) exitWith {
    _unit setVariable ["ANDY1_FUBAR_status", "FUBAR", true];
    _unit setDamage 0.95;
    [_unit, 1.5, 50] call _ANDY1_fnc_unconsciousChance;
};
if (_damaged_BodyPartHP >= 0.65) exitWith {
    _unit setVariable ["ANDY1_FUBAR_status", "CRITICAL", true];
    _unit setDamage 0.9;
    [_unit, 1.25, 60] call _ANDY1_fnc_unconsciousChance;
};
if (_damaged_BodyPartHP >= 0.55) exitWith {
    _unit setVariable ["ANDY1_FUBAR_status", "SEVERE", true];
    _unit setDamage 0.8;
    _unit setUnconscious false;
    [_unit, 1, 70] call _ANDY1_fnc_unconsciousChance;
};
if (_damaged_BodyPartHP >= 0.45) exitWith {
    _unit setVariable ["ANDY1_FUBAR_status", "SERIOUS", true];
    _unit setDamage 0.6;
    _unit setUnconscious false;
    [_unit, 1, 80] call _ANDY1_fnc_unconsciousChance;
};
if (_damaged_BodyPartHP >= 0.25) exitWith {
    _unit setVariable ["ANDY1_FUBAR_status", "MODERATE", true];
    _unit setDamage 0.3;
    _unit setUnconscious false;
    [_unit, 0.75, 90] call _ANDY1_fnc_unconsciousChance;
};
if (_damaged_BodyPartHP >= 0.1) exitWith {
    _unit setVariable ["ANDY1_FUBAR_status", "MINOR", true];
    _unit setDamage 0.1;
    [_unit, 0.5, 90] call _ANDY1_fnc_unconsciousChance;
};
if (_damaged_BodyPartHP >= 0) then {
    _unit setVariable ["ANDY1_FUBAR_status", "NORMAL", true];
    _unit setDamage 0;
    _unit setUnconscious false;
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