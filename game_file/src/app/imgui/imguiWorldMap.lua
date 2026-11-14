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
local isOpenMapScale = false
local getCurrentSceneShowView = function(targetName)
	local currentScene = display.getRunningScene()
	if currentScene.name == "MainScene" then
		if targetName then
			local currentView = currentScene:currentSceneShowView()
			if currentView and currentView.__cname == targetName then
				return currentView
			else
				return nil
			end
		else
			return currentScene:currentSceneShowView()
		end
	end
end
local imguiWorldMap = function()
	imgui.setNextWindowSize(400, 300, imgui.ImGuiCond_FirstUseEver)
	imgui = 300
	imgui.xpcallShowWindow("playerTop编辑器###imguiWorldMap", 300, function()
		local worldMap = getCurrentSceneShowView("worldMapView")
		if not worldMap then
			if imgui.colorButton("进入战场", cc.c4f(0.5, 0.6, 0.7, 0, 0.9), cc.c4f(0.98, 0.65, 0.16, 1), cc.c4f(0.5, 0.6, 0.7, 0, 0.9)) then
				local max = worldMapDefine.getMaxCoordinateByKid(80001)
				SoraDGotoWorldMapPoint(cc.p(max * 0.5, max * 0.5), false, 80001, nil, nil, true)
			end
			return
		end
		if imgui.colorButton("开启无极缩放", cc.c4f(0.5, 0.6, 0.7, 0, 0.9), cc.c4f(0.98, 0.65, 0.16, 1), cc.c4f(0.5, 0.6, 0.7, 0, 0.9)) then
			worldMap.viewScrollView:setMinScale(0)
		end
		if imgui.colorButton("重载地表", cc.c4f(0.5, 0.6, 0.7, 0, 0.9), cc.c4f(0.98, 0.65, 0.16, 1), cc.c4f(0.5, 0.6, 0.7, 0, 0.9)) then
			SoraDSafeCall(function()
				worldMap:getComponent("worldMapComTmxTerrainBg"):reloadTmxBgShader()
			end)
		end
		if imgui.colorButton("重载迷雾", cc.c4f(0.5, 0.6, 0.7, 0, 0.9), cc.c4f(0.98, 0.65, 0.16, 1), cc.c4f(0.5, 0.6, 0.7, 0, 0.9)) then
			SoraDSafeCall(function()
				if worldMapDefine.isInAtlantis() then
					worldMap:getComponent("worldMapComTmxFog"):reloadTmxFogShader()
				else
					worldMap:getComponent("worldMapComNormalFog"):reloadTmxFogShader()
				end
			end)
		end
		if imgui.colorButton("重载联盟领地线", cc.c4f(0.5, 0.6, 0.7, 0, 0.9), cc.c4f(0.98, 0.65, 0.16, 1), cc.c4f(0.5, 0.6, 0.7, 0, 0.9)) then
			SoraDSafeCall(function()
				worldMap:getComponent("worldMapComManorlineNew"):reloadShader()
			end)
		end
		if imgui.colorButton("重载资源带", cc.c4f(0.5, 0.6, 0.7, 0, 0.9), cc.c4f(0.98, 0.65, 0.16, 1), cc.c4f(0.5, 0.6, 0.7, 0, 0.9)) then
			SoraDSafeCall(function()
				worldMap:getComponent("worldMapComResourceBelt"):reloadShader()
			end)
		end
		if imgui.colorButton("重载联盟领地线", cc.c4f(0.5, 0.6, 0.7, 0, 0.9), cc.c4f(0.98, 0.65, 0.16, 1), cc.c4f(0.5, 0.6, 0.7, 0, 0.9)) then
			SoraDSafeCall(function()
				worldMap:getComponent(getfullname("worldMapComManorlineNew")):reloadShader()
			end)
		end
		if imgui.colorButton("重载mesh", cc.c4f(0.5, 0.6, 0.7, 0, 0.9), cc.c4f(0.98, 0.65, 0.16, 1), cc.c4f(0.5, 0.6, 0.7, 0, 0.9)) then
			SoraDSafeCall(function()
				worldMap:reloadAllTestMesh()
			end)
		end
		if imgui.colorButton("显示地图坐标", cc.c4f(0.5, 0.6, 0.7, 0, 0.9), cc.c4f(0.98, 0.65, 0.16, 1), cc.c4f(0.5, 0.6, 0.7, 0, 0.9)) then
			SoraDGotoWorldMapPoint(cc.p(0, 0), false, 80001)
			getCurrentSceneShowView = cc.p(0, 0)
			cc.p(0, 0).msg = "MESSAGE_WORLD_MAP_TOGGLE_DEBUG"
			SoraDSendMessage((cc.p(0, 0)))
		end
		if imgui.colorButton("显示地图2D", cc.c4f(0.5, 0.6, 0.7, 0, 0.9), cc.c4f(0.98, 0.65, 0.16, 1), cc.c4f(0.5, 0.6, 0.7, 0, 0.9)) then
			gEnableWorldMap3D = not gEnableWorldMap3D
			getCurrentSceneShowView = "显示地图2D"
			;("显示地图2D").msg = "MESSAGE_WORLD_MAP_TOGGLE_3D"
			SoraDSendMessage("显示地图2D")
		end
		if imgui.colorButton("隐藏UI和图素", cc.c4f(0.5, 0.6, 0.7, 0, 0.9), cc.c4f(0.98, 0.65, 0.16, 1), cc.c4f(0.5, 0.6, 0.7, 0, 0.9)) then
			local tChild = worldMap:getChildren()
			for k, v in ipairs(tChild) do
				if v:getName() ~= "tiledBg" then
					v:setVisible(false)
				end
			end
			getCurrentSceneShowView = (for generator)
			ipairs(tChild).isHideCurrentSceneView = false
			local ipairs(tChild).isHideMainUI, hideData = true, ipairs(tChild)
			SoraDHideCurrentSceneViewAndMainUI(hideData)
		end
		if worldMap then
			local curScale = worldMap.viewScrollView:getZoomScale()
			local ret, scale = imgui.sliderFloat("世界地图缩放", curScale, 0.1, 1.35)
			if ret and 0.1 < curScale then
				worldMap.viewScrollView:setZoomScale(scale)
			end
			ret, scale = imgui.sliderFloat("世界地图2级lod缩放", curScale * 10, 0.1, 1)
			if ret and scale < 1 then
				worldMap.viewScrollView:setZoomScale(scale * 0.1)
			end
		end
		if imgui.colorButton("显示名字", cc.c4f(0.5, 0.6, 0.7, 0, 0.9), cc.c4f(0.98, 0.65, 0.16, 1), cc.c4f(0.5, 0.6, 0.7, 0, 0.9)) then
			SoraDSafeCall(function()
				local worldMapInstanceLod = include("worldMapInstanceLod")
				function worldMapInstanceLod:setInstanceID(instanceID)
					self.instanceID = instanceID
					self:setName(self.instanceID)
				end
			end)
		end
	end)
end
imgui.addDrawFunc("imguiWorldMap", imguiWorldMap)
