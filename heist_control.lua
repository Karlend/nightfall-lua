local global = require("menu/globals/heist_control")
local stats = require("menu/stats/heist_control")
local main = global.main

local active_funcs = {}

local function AddOrRemove(name, val, func)
	if val then
		system.log("debug", "Adding " .. name)
		active_funcs[name] = func
	else
		system.log("debug", "Removing " .. name)
		active_funcs[name] = nil
	end
end

local prefix_base = "MP%s_"
local function GetPrefix()
	local char = globals.get_int(global.char_id)
	return prefix_base:format(char)
end

local function set_stat_int(stat, val)
	local prefix = GetPrefix()
	local mp_stat = prefix .. stat
	local hash = utils.joaat(mp_stat)
	system.log("stats", tostring(mp_stat))
	return STATS.STAT_SET_INT(hash, val, true)
end

local function apply_stats(tbl)
	for _, stat_info in ipairs(tbl) do
		set_stat_int(stat_info[1], stat_info[2])
	end
end

local function add_preset(v, sub)
	if v.stats then
		ui.add_click_option(v.name, sub, function()
			for _, stat_info in ipairs(v.stats) do
				set_stat_int(stat_info[1], stat_info[2])
			end
		end)
	elseif v.func then
		ui.add_bool_option(v.name, sub, v.func)
	end
end

local presets = {
	{name = "Quick 2.5M", cayo = true, func = function(val)
		apply_stats(stats.cayo.only_primary)
		AddOrRemove("cayo 2.5m", val, function()
			globals.set_int(global.cayo.cut_main, 100)
			for i = 1, 3 do
				globals.set_int(global.cayo.cut_main + i, 145)
			end
			if globals.is_script_active("fm_mission_controller_2020") then
				globals.set_local("fm_mission_controller_2020", global.cayo.secondary_reward, 0)
			end
			globals.set_int(main + global.cayo.potential, 2455000)
		end)
	end},
	{name = "Diamonds - Silent", casino = true, stats = stats.casino.diamonds.silent},
	{name = "Diamonds - BigCon", casino = true, stats = stats.casino.diamonds.bigcon},
	{name = "Diamonds - Aggressive", casino = true, stats = stats.casino.diamonds.bigcon},

	{name = "ACT I : The Data Breaches", doomsday = true, stats = stats.doomsday.act1},
	{name = "ACT I : The Data Breaches | 2.5M", doomsday = true, func = function(val)
		apply_stats(stats.doomsday.act1)
		AddOrRemove("doomsday 2.5m", val, function()
			for i = 0, 3 do
				globals.set_int(global.doomsday.cut + i, 313)
			end
		end)
	end},
	{name = "ACT II : The Bogdan Problem", doomsday = true, stats = stats.doomsday.act2},
	{name = "ACT II : The Bogdan Problem | 2.5M", doomsday = true, func = function(val)
		apply_stats(stats.doomsday.act2)
		AddOrRemove("doomsday 2.5m", val, function()
			for i = 0, 3 do
				globals.set_int(global.doomsday.cut + i, 214)
			end
		end)
	end},
	{name = "ACT III : The Doomsday Scenario", doomsday = true, stats = stats.doomsday.act3},
	{name = "ACT III : The Doomsday Scenario | 2.5M", doomsday = true, func = function(val)
		apply_stats(stats.doomsday.act3)
		AddOrRemove("doomsday 2.5m", val, function()
			for i = 0, 3 do
				globals.set_int(global.doomsday.cut + i, 170)
			end
		end)
	end},

	{name = "Fleeca 15M", classic = true, func = function(val)
		AddOrRemove("fleeca", val, function()
			globals.set_int(global.classic.cut, 10434)
			globals.set_int(global.classic.cut + 1, 10434)
		end)
	end},
	{name = "Final 2.4M", contract = true, func = function(val)
		apply_stats(stats.contract.final)
		AddOrRemove("contract final", val, function()
			globals.set_int(main + global.contract.earnings, 2400000)
		end)
	end},
	{name = "Union Depository", tuners = true, stats = stats.tuner.union},
	{name = "The Superdollar Deal", tuners = true, stats = stats.tuner.superdollar},
	{name = "The Bank Contract", tuners = true, stats = stats.tuner.bank_contract},
	{name = "The ECU Job", tuners = true, stats = stats.tuner.ecu},
	{name = "The Prison Contract", tuners = true, stats = stats.tuner.prison},
	{name = "The Agency Deal", tuners = true, stats = stats.tuner.agency},
	{name = "The Lost Contract", tuners = true, stats = stats.tuner.lost},
	{name = "The Data Contract", tuners = true, stats = stats.tuner.data},
	{name = "Reset Gains & Completes", tuners = true, stats = stats.tuner.reset_gains},
	{name = "Complete missions", tuners = true, stats = stats.tuner.complete},
	{name = "The Nightclub (Prep)", contract = true, stats = stats.contract.nightclub},
	{name = "The Marina (Prep)", contract = true, stats = stats.contract.marina},
	{name = "NightLife Leak (Mission)", contract = true, stats = stats.contract.nightlife},
	{name = "The Country Club (Prep)", contract = true, stats = stats.contract.country_club},
	{name = "Guest List (Prep)", contract = true, stats = stats.contract.guest_list},
	{name = "High Society (Mission)", contract = true, stats = stats.contract.high_society},
	{name = "Davis (Prep)", contract = true, stats = stats.contract.davis},
	{name = "The Ballas (Prep)", contract = true, stats = stats.contract.ballas},
	{name = "Agency Studio (Mission)", contract = true, stats = stats.contract.agency_studio},
	{name = "Final Contract: Don't Fuck with Dre", contract = true, stats = stats.contract.final},
}
local function sub_tab(name, sub_id)
	local tab = ui.add_submenu(name)
	ui.add_sub_option(name, sub_id, tab)
	return tab
end

local heist_tab = ui.add_main_submenu("Heist control")
ui.add_bool_option("Infinite lives in missions", heist_tab, function(val)
	AddOrRemove("infinite lives", val, function()
		if globals.is_script_active("fm_mission_controller") then
			globals.set_local("fm_mission_controller", global.casino.lives, 2147483646)
		end
		if globals.is_script_active("fm_mission_controller_2020") then
			globals.set_local("fm_mission_controller_2020", global.cayo.lives, 2147483646)
		end
	end)
end)

local cayo = sub_tab("Cayo", heist_tab)
local cayo_presets = sub_tab("Presets", cayo)
for k, v in ipairs(presets) do
	if v.cayo then
		add_preset(v, cayo_presets)
	end
end

local cayo_fee = sub_tab("Fee", cayo)
ui.add_bool_option("Remove Pavel fee", cayo_fee, function(val)
	AddOrRemove("cayo remove pavel", val, function()
		globals.set_int(main + global.cayo.fee[1], -0.1)
	end)
end)
ui.add_bool_option("Remove escape fee", cayo_fee, function(val)
	AddOrRemove("cayo remove escape", val, function()
		globals.set_int(main + global.cayo.fee[2], -0.02)
	end)
end)
ui.add_bool_option("Autofinish primary target", cayo, function(val)
	AddOrRemove("cayo skip half", val, function()
		if globals.is_script_active("fm_mission_controller_2020") then
			globals.set_local("fm_mission_controller_2020", global.cayo.finish.bit_check, 3)
			globals.set_local("fm_mission_controller_2020", global.cayo.finish.cutter_stage, 5)
		end
	end)
end)
ui.add_bool_option("Instant fingerprint crack", cayo, function(val)
	AddOrRemove("cayo fingerprint", val, function()
		if globals.is_script_active("fm_mission_controller_2020") then
			globals.set_local("fm_mission_controller_2020", global.cayo.fingerprint, 5)
		end
	end)
end)
ui.add_bool_option("Infinite voltage timer", cayo, function(val)
	AddOrRemove("cayo voltage", val, function()
		if globals.is_script_active("fm_mission_controller_2020") then
			globals.set_local("fm_mission_controller_2020", global.cayo.voltage_time, 1)
		end
	end)
end)

local drainage = 2997331308
ui.add_click_option("Remove Drainage Pipe", cayo, function()
	local objects = entities.get_objects()
	for _, ent in ipairs(objects) do
		local model = ENTITY.GET_ENTITY_MODEL(ent)
		if model == drainage then
			ENTITY.SET_ENTITY_AS_MISSION_ENTITY(ent, true, true)
			entities.delete(ent)
		end
	end
end)

local casino = sub_tab("Casino", heist_tab)
local casino_presets = sub_tab("Presets", casino)
for k, v in ipairs(presets) do
	if v.casino then
		add_preset(v, casino_presets)
	end
end
ui.add_bool_option("Modded cuts", casino, function(val)
	AddOrRemove("casino cuts", val, function()
		globals.set_int(global.casino.cut, 42)
		for i = 1, 3 do
			globals.set_int(global.casino.cut + i, 102)
		end
	end)
end)
ui.add_bool_option("Modded potential", casino, function(val)
	AddOrRemove("casino potential", val, function()
		for i, v in ipairs(global.casino.potential) do
			globals.set_int(main + v, 1410065408)
		end
	end)
end)
ui.add_bool_option("Instant vault door laser", casino, function(val)
	AddOrRemove("casino vault door", val, function()
		if globals.is_script_active("fm_mission_controller") then
			local need = globals.get_local_int("fm_mission_controller", global.casino.vault_door.need)
			globals.set_local("fm_mission_controller", global.casino.vault_door.cur, need)
		end
	end)
end)
ui.add_bool_option("Instant fingerprint crack", casino, function(val)
	AddOrRemove("casino fingerprint", val, function()
		if globals.is_script_active("fm_mission_controller") then
			local fingerprint = globals.get_local_int("fm_mission_controller", global.casino.fingerprint)
			if fingerprint == 1 then
				return
			end
			globals.set_local("fm_mission_controller", global.casino.fingerprint, 5)
		end
	end)
end)
ui.add_bool_option("Instant doors crack", casino, function(val)
	AddOrRemove("casino doors", val, function()
		if globals.is_script_active("fm_mission_controller") then
			local doors = globals.get_local_int("fm_mission_controller", global.casino.doors)
			if doors == 0 then
				return
			end
			globals.set_local("fm_mission_controller", global.casino.doors, 5)
		end
	end)
end)

local doom = sub_tab("Doomsday", heist_tab)
local doom_presets = sub_tab("Presets", doom)
for k, v in ipairs(presets) do
	if v.doomsday then
		add_preset(v, doom_presets)
	end
end

local classic = sub_tab("Classic heists", heist_tab)
for k, v in ipairs(presets) do
	if v.classic then
		add_preset(v, classic)
	end
end

local tuners = sub_tab("Tuners - LS Robbery", heist_tab)
local tuners_presets = sub_tab("Presets", tuners)
for k, v in ipairs(presets) do
	if v.tuners then
		add_preset(v, tuners_presets)
	end
end
ui.add_bool_option("1M payout", tuners, function(val)
	AddOrRemove("tuners 1m", val, function()
		for i = 0, 8 do
			globals.set_int(main + global.tuner.earnings + i, 1000000)
		end
	end)
end)
ui.add_bool_option("Remove IA fee", tuners, function(val)
	AddOrRemove("tuners fee", val, function()
		globals.set_int(main + global.tuner.fee[1], 0)
	end)
end)

local contract = sub_tab("Contract", heist_tab)
local contract_presets = sub_tab("Presets", contract)
for k, v in ipairs(presets) do
	if v.contract then
		add_preset(v, contract_presets)
	end
end
ui.add_bool_option("Remove cooldowns", contract, function(val)
	AddOrRemove("contract cooldowns", val, function()
		for k, v in ipairs(global.contract.cd_hit) do
			globals.set_int(main + v, 0)
		end
		globals.set_int(main + global.contract.cd[1], 0)
		globals.set_int(global.contract.call_cd, 0)
	end)
end)

local cameras = {
	[utils.joaat("prop_cctv_cam_06a")] = true,
	[utils.joaat("prop_cctv_cam_04a")] = true,
	[utils.joaat("prop_cctv_cam_05a")] = true,
	[utils.joaat("prop_cctv_cam_02a")] = true,
	[utils.joaat("prop_cctv_cam_01a")] = true,
	[utils.joaat("prop_cctv_cam_07a")] = true,
	[utils.joaat("prop_cctv_cam_03a")] = true,
	[utils.joaat("prop_cctv_cam_01b")] = true,
	[utils.joaat("prop_cctv_cam_04c")] = true,
	[utils.joaat("prop_cs_cctv")] = true,
	[utils.joaat("hei_prop_bank_cctv_01")] = true,
	[utils.joaat("hei_prop_bank_cctv_02")] = true,
	[utils.joaat("p_cctv_s")] = true,
	[3061645218] = true
}

ui.add_click_option("Delete cameras", heist_tab, function()
	local objects = entities.get_objects()
	for _, ent in ipairs(objects) do
		local model = ENTITY.GET_ENTITY_MODEL(ent)
		if cameras[model] then
			system.log("Camera", "Requesting control for camera " .. tostring(ent) .. " with model " .. tostring(model))
			entities.request_control(ent, function()
				system.log("Camera", "Deleting camera " .. tostring(ent) .. " with model " .. tostring(model))
				entities.delete(ent)
			end)
		end
	end
end)

ui.add_click_option("Teleport pickups to me", heist_tab, function()
	local me = PLAYER.PLAYER_PED_ID()
	local pos = ENTITY.GET_ENTITY_COORDS(me, true)
	local pickups = entities.get_pickups()
	for _, ent in pairs(pickups) do
		entities.request_control(ent, function()
			ENTITY.SET_ENTITY_COORDS(ent, pos.x, pos.y, pos.z, false, false, false, false)
		end)
	end
end)


while true do
	for k, v in pairs(active_funcs) do
		v()
	end
	system.yield(0)
end