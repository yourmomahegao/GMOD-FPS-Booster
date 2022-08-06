net.Receive("DoFPSBooster", function()
	if file.Exists("ymafpsconfig/ymafpsbooster.json", "DATA") then
		local f = file.Open("ymafpsconfig/ymafpsbooster.json", "r", "DATA")
			local FPSBoosterConfig = util.JSONToTable(f:Read())

			if IsValid(hooksList) and hooksList != nil then
				for i, sts in pairs(FPSBoosterConfig) do
					if sts == true then
						for i, hk in pairs(hooksList[i]) do
							if i != "name" then
								hook.Remove(hk[1], hk[2])
							end
						end
					end
				end
			end
		f:Close()
	end
end)

surface.CreateFont( "fpsMenuText", {
	font = "Arial",
	extended = false,
	size = 24,
	weight = 1500,
	antialias = true,
} )

hooksList = {
	{
		{"RenderScreenspaceEffects", "RenderColorModify"},
	 	{"RenderScreenspaceEffects", "RenderBloom"},
	 	{"RenderScreenspaceEffects", "RenderToyTown"},
	 	{"RenderScreenspaceEffects", "RenderTexturize"},
		{"RenderScreenspaceEffects", "RenderSunbeams"},
		{"RenderScreenspaceEffects", "RenderSobel"},
		{"RenderScreenspaceEffects", "RenderSharpen"},
		{"RenderScreenspaceEffects", "RenderMaterialOverlay"},
		{"RenderScreenspaceEffects", "RenderMotionBlur"},
		{"RenderScreenspaceEffects", "RenderBokeh"},
		name = "Отключение постобработки"
	},

	{
		{"RenderScene", "RenderStereoscopy"},
		{"RenderScene", "RenderSuperDoF"},
		{"GUIMousePressed", "SuperDOFMouseDown"},
		{"GUIMouseReleased", "SuperDOFMouseUp"},
		{"PreventScreenClicks", "SuperDOFPreventClicks"},
		{"PostRender", "RenderFrameBlend"},
		{"PreRender", "PreRenderFrameBlend"},
		{"Think", "DOFThink"},
		{"NeedsDepthPass", "NeedsDepthPass_Bokeh"},
		name = "Отключение размытия"
	}
}

local function toggleFPSMenu()
	FPSEnableList = {}
	local scrw, scrh = ScrW(), ScrH()

	if IsValid(FPSMenu) then
		return
	end

	local FPSMenu = vgui.Create("DFrame")
	FPSMenu:SetTitle("")
	FPSMenu:SetSize(scrw / 3, 10 + table.Count(hooksList) * 40 + 100)
	FPSMenu:Center()
	
	FPSMenu:MakePopup()
	FPSMenu:RequestFocus()
	FPSMenu:ShowCloseButton(false)
	FPSMenu:SetDraggable(true)
	local FPSX, FPSY = FPSMenu:GetSize()

	FPSMenu.Paint = function(self,w,h)
		draw.RoundedBox( 10, 0, 0, w, h, Color( 35, 35, 35, 199 ) )
		draw.SimpleText( "МЕНЮ - FPS BOOSTER", "fpsMenuText", FPSX / 2, 25, Color( 255, 255, 255, 235 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end

	local FPSClose = vgui.Create("DButton", FPSMenu)
	FPSClose:SetText("")
	FPSClose:SetSize(20, 20)
	FPSClose:SetPos((FPSX - 30), 10)
	local FPSCloseX, FPSCloseY = FPSClose:GetSize()
	FPSClose.Paint = function(self,w,h)
		draw.RoundedBox( 10, 0, 0, w, h, Color( 255, 100, 100, 155 ) )
		draw.RoundedBox( FPSClose:GetWide()/2, 5, 5, w - 10, h - 10, Color( 255, 100, 100, 255 ) )
	end

	FPSClose.DoClick = function()
		if IsValid(FPSMenu) then
			FPSMenu:Remove()
		end
	end

	for i, hk in pairs(hooksList) do
		local FPSEnable = FPSMenu:Add("DCheckBox")
		FPSEnable:SetPos( 25, 10 + (40 * i) )
		FPSEnable:SetSize(FPSX, 30)
		FPSEnable:SetValue( true )
		local FPSEnableX, FPSEnableY = FPSEnable:GetSize()

		if file.Exists("ymafpsconfig/ymafpsbooster.json", "DATA") then
			local f = file.Open("ymafpsconfig/ymafpsbooster.json", "r", "DATA")
				local FPSBoosterConfig = util.JSONToTable(f:Read())

				FPSEnable:SetChecked(FPSBoosterConfig[i])
			f:Close()
		end

		table.insert(FPSEnableList, i, FPSEnable)

		FPSEnable.Paint = function(self,w,h)
			if FPSEnable:GetChecked() then
				draw.RoundedBox( 15, 5, 5 - 2, (FPSEnableY * 2) - 6, FPSEnableY - 6, Color( 100, 255, 100, 100 ) )
				draw.RoundedBox( 15, 5 + 2  + FPSEnableY, 5, FPSEnableY - 10, FPSEnableY - 10, Color( 255, 255, 255, 255 ) )
				draw.SimpleText(hk['name'], "fpsMenuText", 65, FPSEnableY / 2, Color( 255, 255, 255, 235 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
			else
				draw.RoundedBox( 15, 5, 5 - 2, (FPSEnableY * 2) - 6, FPSEnableY - 6, Color( 100, 100, 100, 100 ) )
				draw.RoundedBox( 15, 5 + 2, 5 + 2 - 2, FPSEnableY - 10, FPSEnableY - 10, Color( 255, 255, 255, 255 ) )
				draw.SimpleText(hk['name'], "fpsMenuText", 65, FPSEnableY / 2, Color( 255, 255, 255, 235 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
			end
		end
	end

	local FPSSave = vgui.Create("DButton", FPSMenu)
	FPSSave:SetText("")
	FPSSave:SetSize(150, 50)
	FPSSave:SetPos(FPSX / 2 - 60 - 10, FPSY - 50 - 10)
	local FPSSaveX, FPSSaveY = FPSSave:GetSize()
	FPSSave.Paint = function(self,w,h)
		draw.RoundedBox( 10, 0, 0, w, h, Color( 100, 255, 100, 155 ) )
		draw.SimpleText("Сохранить", "fpsMenuText", FPSSaveX / 2, FPSSaveY / 2 - 1, Color( 255, 255, 255, 235 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end

	FPSSave.DoClick = function()
		if IsValid(FPSMenu) then
			if !file.Exists("ymafpsconfig", "DATA") then
				file.CreateDir("ymafpsconfig")
			end

			local FPSEnableListBoolean = {}
			for i, p in pairs(FPSEnableList) do
				table.insert(FPSEnableListBoolean, p:GetChecked())
			end

			if file.Exists("ymafpsconfig/ymafpsbooster.json", "DATA") then
				-- print(table.ToString(FPSEnableListBoolean, "FPSEnableList", true))
				local f = file.Open("ymafpsconfig/ymafpsbooster.json", "w", "DATA")
					f:Write(util.TableToJSON(FPSEnableListBoolean, true))
				f:Close()
			else
				-- print(table.ToString(FPSEnableListBoolean, "FPSEnableList", true))
				file.Write("ymafpsconfig/ymafpsbooster.json", util.TableToJSON(FPSEnableListBoolean, true))
			end

			for i, p in pairs(FPSEnableList) do
				if IsValid(p) and p != nil and p:GetChecked() == true then
					for i, hk in pairs(hooksList[i]) do
						if i != "name" then
							hook.Remove(hk[1], hk[2])
						end
					end
				end
			end
		end

		FPSMenu:Close()
	end
end

net.Receive("OpenFPSBoosterMenu", function()
	toggleFPSMenu()
end)