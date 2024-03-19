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

if (isPlayer _unit && !(_unit getVariable "ANDY1_FUBAR_effectHead")) then {
    _unit setVariable ["ANDY1_FUBAR_effectNeck", true, true];
        _unit spawn {
            _unit = _this;
            0 fadeSound 0.1;
            [0, "WHITE", 0.05, 0] remoteExec ["BIS_fnc_fadeEffect", _unit];
            sleep 0.09;
            private _randomDelay = (7+ random 5);
            [0, "BLACK", _randomDelay, 0] remoteExec ["BIS_fnc_fadeEffect", _unit];
            sleep _randomDelay;
            if ((incapacitatedState _unit) == "UNCONSCIOUS") then {
                while {sleep 3; alive _unit} do {
                    if ((incapacitatedState _unit) != "UNCONSCIOUS" || (_unit getVariable "ANDY1_FUBAR_status" != "CRITICAL") || damage _unit < 0.25) exitWith {
                        //systemChat "no longer unconscious";
                        sleep (1 + random 3);
                        _unit setVariable ["ANDY1_FUBAR_effectNeck", nil, true]; // nil instead of false to save memory ?
                        _unit setUnconscious false;
                        private _randomDelay = (3+ random 7);
                        _randomDelay fadeSound 1;
                        [1, "BLACK", _randomDelay, 1] remoteExec ["BIS_fnc_fadeEffect", _unit];
                        sleep (_randomDelay+1);
                        [_this, "AmovPpneMstpSnonWnonDnon"] remoteExecCall ["playMoveNow", 0];
                    };
                    if ((_unit getVariable "ANDY1_FUBAR_status" == "FUBAR")) exitWith {}; // screen remains black
                    private _randomDelay = (3+ random 1);
                    [1, "BLACK", _randomDelay, 0] remoteExec ["BIS_fnc_fadeEffect", _unit];
                    _randomDelay = (1+ random 3);
                    [0, "BLACK", _randomDelay, 0] remoteExec ["BIS_fnc_fadeEffect", _unit];
                };
            } else {
                if (!alive _unit) then {
                    _unit setVariable ["ANDY1_FUBAR_effectNeck", nil, true];
                    sleep (1 + random 3);
                    private _randomDelay = (7+ random 5);
                    _randomDelay fadeSound 1;
                    [1, "BLACK", _randomDelay, 1] remoteExec ["BIS_fnc_fadeEffect", _unit];
                };
            };
        };