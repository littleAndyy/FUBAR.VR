params ["_unit"];

if (isServer && !hasInterface) exitWith {};

if (isPlayer _unit) then {
    if (isNil {_unit getVariable "ANDY1_FUBAR_effectNeck"}) then {
        _unit setVariable ["ANDY1_FUBAR_effectNeck", false, true];
    };
} else {
    if (!isMultiplayer) then {
        _unit setVariable ["ANDY1_FUBAR_status", nil, true];
    };
    _unit setDamage 1;
};

if ((isPlayer _unit && (incapacitatedState _unit) != "UNCONSCIOUS") && !(_unit getVariable "ANDY1_FUBAR_effectNeck")) then {
    _unit setVariable ["ANDY1_FUBAR_effectNeck", true, true];
    _unit spawn {
        _unit = _this;
        // TODO: add bleeding effect - red screen
        // TODO: add arterial bleed & choking SFX
        0 fadeSound 0.8;
        private _randomDelay = (7+random 7);
        [0, "WHITE", 0.05, 0] remoteExec ["BIS_fnc_fadeEffect", _unit];
        sleep 0.09;
        (_randomDelay) fadeSound 0;
        [1, "BLACK", _randomDelay, 0] remoteExec ["BIS_fnc_fadeEffect", _unit];
        sleep _randomDelay;
        _unit setUnconscious true;
    };
};