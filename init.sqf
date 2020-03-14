
_scriptStart = true;
_playerGroup = group player;
_grp = [getMarkerPos "squadSpawn", side player, (configfile >> "CfgGroups" >> "West" >> "BLU_F" >> "Infantry" >> "BUS_InfTeam")] call BIS_fnc_spawnGroup;
_veh = createVehicle ["B_Heli_Light_01_F", position player, [], 0, "FLY"];
_cntGroup = count units _grp;
player moveInDriver _veh;

while { (alive player) and (_scriptStart) } do {
	_u = units _grp;
	_freeCargoPositions = vehicle player emptyPositions "cargo";
	sleep 0.5;

	//If humming bird is empty, then move units into cargo not co-pilot
	if (_freeCargoPositions == 6) then {
		sleep 10;
		_c = fullCrew [vehicle player, "turret", true];
		_countTurret = count fullCrew [vehicle player, "turret", true];
	
		for [{_i = 0}, {_i < _cntGroup}, {_i = _i + 1}] do {
			_selUnit = (_u select _i);
			_selPos = ((_c select _i) select 2);
			
			if (_selPos != -1) then { _selUnit moveInCargo [_veh, _i]; }
			else { _selUnit moveInCargo _veh; };
		};

	//Create marker on map at Safe POS
    hint parseText "<t size='2.0' color='#6beb34'>Creating marker...</t>";// Displays text twice as large as the default one
	_getBestPos = [player, 500, 700, 3, 0, 0.3, 0] call BIS_fnc_findSafePos;
	_bestMarker = createMarker ["bestMarker", _getBestPos];
	_bestMarker setMarkerType "hd_dot";

	//Pilot way-point logic
	_wpa = _playerGroup addWaypoint [getMarkerPos "bestMarker", 0];
	_wpa setWaypointType "TR UNLOAD";
	_wpA setWaypointStatements ["true", "(vehicle this) land 'GET OUT'"];
	[_playerGroup, 2] setWaypointCompletionRadius 10;

	//Fire team way-point logic
	_wpb = _grp addWaypoint [getMarkerPos "bestMarker", 0];
	_wpb setWaypointType "GETOUT";
	_wpb setWaypointBehaviour "COMBAT";
    [_grp, 2] setWaypointCompletionRadius 10;
    sleep 20;

	deleteMarker "bestMarker";
	deleteWaypoint [_grp, 0];
	deleteWaypoint [_playerGroup, 0];
	};
};






