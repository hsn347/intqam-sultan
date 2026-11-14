local imgui = _G.imgui
_UPVALUE2_ = nil
;(nil)[1] = cc.c4f(0.5, 0.6, 0.7, 0, 0.9)
;(nil)[2] = cc.c4f(0.98, 0.65, 0.16, 1)
;(nil)[3] = cc.c4f(0.5, 0.6, 0.7, 0, 0.9)
;(nil)[4] = cc.c4f(0.5, 0.6, 0.7, 0, 0.9)
;(nil)[5] = cc.c4f(0.5, 0.6, 0.7, 0, 0.9)
;(nil)[6] = cc.c4f(0.5, 0.6, 0.7, 0, 0.9)
;(nil)[7] = cc.c4f(0.5, 0.6, 0.7, 0, 0.9)
local (nil)[8], btnColor_1 = cc.c4f(0.5, 0.6, 0.7, 0, 0.9)
local imguiNormalButtom = function(btnText)
	return imgui.colorButton(btnText, btnColor_1[1], btnColor_1[2], btnColor_1[3])
end
local imguiPlayerPanel = function()
	imgui.setNextWindowSize(400, 300, imgui.ImGuiCond_FirstUseEver)
	imgui = 300
	imgui.xpcallShowWindow("playerTop编辑器###imguiPlayerPanel", 300, function()
		if imgui.TreeNode("遗迹之战") then
			if imguiNormalButtom("查看数据###btn_data_showprops") then
				local gametop = gModuleMgr.getObject("gametop")
				if gametop and gametop.playertop_ then
					local remainsWarCtrl = gametop.playertop_:getModule("remainsWarCtrl")
					if remainsWarCtrl and remainsWarCtrl:getRemainsWarData() then
						imgui.visualDump(remainsWarCtrl:getRemainsWarData(), "remainsWarData")
					end
				end
			end
			imgui.TreePop()
		end
	end)
end
imgui.addDrawFunc("imguiPlayerPanel", imguiPlayerPanel)
