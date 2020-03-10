//1. Create units move into --> MH-6
//2. Set waypoints for units accordingly at random pos within 1500m radius of player (pilot)
//3. On event wp complete, select new dest (eventually object detection will be integrated)
//4. repeat steps 1-3 until script exit..

_endEvent = player addEventHandler ["killed", {hint "**Crash**"}];
_veh = createVehicle ["B_Heli_Light_01_F", position player, [], 0, "FLY"];
player moveInDriver _veh;

//spawn units and to move into vehicle
_grp = [getMarkerPos "squadSpawn", side player, (configfile >> "CfgGroups" >> "West" >> "BLU_F" >> "Infantry" >> "BUS_InfTeam")] call BIS_fnc_spawnGroup;
{_x moveInAny _veh} forEach units _grp;
/_playerGroup = group player;
hint str _playerGroup;
sleep 2;
//Generate a marker within a 1.5km radius of the player.

// this while condition will change, will set to wp complete event
while { true } do {
	hint "Creating marker";
	_randomPosAroundPlayer = [[[position player, 1500]],[]] call BIS_fnc_randomPos;
	_marker1 = createMarker ["Marker1", _randomPosAroundPlayer];
	_marker1 setMarkerType "hd_dot";

		//pilot waypoint logic
		_wpa = _playerGroup addWaypoint [getMarkerPos "Marker1", 0];
		_wpa setWaypointType "TR UNLOAD";
		[_playerGroup, 2] setWaypointCompletionRadius 10;

		//fire team waypoint logic
		_wpb = _grp addWaypoint [getMarkerPos "Marker1", 0];
		_wpb setWaypointType "GETOUT";
		_wpb setWaypointSpeed "LIMITED";
		_wpb setWaypointBehaviour "SAFE";
    	[_grp, 2] setWaypointCompletionRadius 10;


		deleteMarker "Marker1";
		deleteWaypoint [_grp, 0];
		deleteWaypoint [_playerGroup, 0];
		
	sleep 20;
};







