if SERVER then
	include( "server/sv_fpsbooster.lua" )
	AddCSLuaFile( "client/cl_fpsbooster.lua" )
end

if CLIENT then
	include( "client/cl_fpsbooster.lua" )
end

print( "YMA FPS Booster loading done." )
print( "-----------------------" )