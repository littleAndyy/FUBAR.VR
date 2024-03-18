params ["_unit"];

if (isServer && !hasInterface) exitWith {};

if (isPlayer _unit) then {
    if (isNil {_unit getVariable "ANDY1_FUBAR_effectHead"}) then {
        _unit setVariable ["ANDY1_FUBAR_effectHead", false, true];
    };
    //_unit setVariable ["ANDY1_FUBAR_status", "CRITICAL", true];
    if (round random 5 != 5) then {
        _unit setVariable ["ANDY1_FUBAR_status", "FUBAR", true];
    } else {
        _unit setVariable ["ANDY1_FUBAR_status", "CRITICAL", true];
    };
} else {
    if (!isMultiplayer) then {
        _unit setVariable ["ANDY1_FUBAR_status", nil, true];
    };
    _unit setDamage 1;
};

if ((isPlayer _unit && ((incapacitatedState _unit) != "UNCONSCIOUS")) && !(_unit getVariable "ANDY1_FUBAR_effectHead")) then {
    _unit setVariable ["ANDY1_FUBAR_effectHead", true, true];
    _unit spawn {
        _unit = _this;
        0 fadeSound 0.1;
        //[0, "WHITE", 0.1, 0] remoteExec ["BIS_fnc_fadeEffect", _unit];
        sleep 0.1;
        //[0, "BLACK", 0.01, 0] remoteExec ["BIS_fnc_fadeEffect", _unit];
        if ((incapacitatedState _unit) == "UNCONSCIOUS") then {
            while {sleep 3; alive _unit} do {
                systemChat str (_unit getVariable "ANDY1_FUBAR_status");
                if ((incapacitatedState _unit) != "UNCONSCIOUS" || (_unit getVariable "ANDY1_FUBAR_status" != "CRITICAL") || damage _unit < 0.25) exitWith {
                    //systemChat "no longer unconscious";
                    sleep (1 + random 3);
                    _unit setVariable ["ANDY1_FUBAR_status", "SERIOUS", true];
                    _unit setVariable ["ANDY1_FUBAR_effectHead", false, true];
                    _unit setUnconscious false;
                    private _randomDelay = (3+ random 7);
                    _randomDelay fadeSound 1;
                    [1, "BLACK", _randomDelay, 1] remoteExec ["BIS_fnc_fadeEffect", _unit];
                    sleep (_randomDelay+1);
                    [_this, "AmovPpneMstpSnonWnonDnon"] remoteExecCall ["playMoveNow", 0];
                };
            };
        } else {
            if (!alive _unit) then {
                _unit setVariable ["ANDY1_FUBAR_effectHead", nil, true];
                sleep (1 + random 3);
                private _randomDelay = (7+ random 5);
                _randomDelay fadeSound 1;
                [1, "BLACK", _randomDelay, 1] remoteExec ["BIS_fnc_fadeEffect", _unit];
            };
        };
    };
};