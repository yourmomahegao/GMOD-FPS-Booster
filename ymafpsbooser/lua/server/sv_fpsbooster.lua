print( "-----------------------" )
print( "YMA FPS Booster is loading..." )

util.AddNetworkString("OpenFPSBoosterMenu")

hook.Add("PlayerSay", "OnPlayerSay", function(sender, txt, teamChat)
	local TextMessage = txt

	if string.lower(TextMessage) == "!fps" then
		net.Start("OpenFPSBoosterMenu")
		net.Send(sender)
	end
end)