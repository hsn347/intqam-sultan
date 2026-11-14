local _ENV, testFuncMap
local imgui = _G.imgui
local switchOpen = function(funcName)
	if not testFuncMap[funcName] then
		testFuncMap = testFuncMap[funcName]
		testFuncMap[funcName].func = require("app.imgui.tests." .. funcName)
		testFuncMap[funcName], testFuncMap[funcName].opened = testFuncMap[funcName], false
	end
	local opened = not testFuncMap[funcName].opened
	testFuncMap[funcName].opened = opened
	if opened then
		imgui.addDrawFunc(funcName, testFuncMap[funcName].func)
	else
		imgui.removeDrawFunc(funcName)
	end
end
local toogleWindow = function(name)
	local panel = SoraDSearchPanelFromManagerByName(name)
	if not panel then
		SoraDCreatePanel(name):show()
	else
		panel:removeFromParent()
	end
end
local imguiTestPanel = function()
	imgui.setNextWindowSize(400, 300, imgui.ImGuiCond_FirstUseEver)
	imgui = 300
	imgui.xpcallShowWindow("imgui测试界面###imguiTestPanel", 300, function()
		if imgui.colorButton("打开作弊界面", cc.c4f(0.5, 0.6, 0.7, 0, 0.9), cc.c4f(0.98, 0.65, 0.16, 1), cc.c4f(0.5, 0.6, 0.7, 0, 0.9)) then
			uiManager:show("CheatView")
		end
		imgui.sameLine()
		if imgui.colorButton("遗迹之战", cc.c4f(0.5, 0.6, 0.7, 0, 0.9), cc.c4f(0.98, 0.65, 0.16, 1), cc.c4f(0.5, 0.6, 0.7, 0, 0.9)) then
			toogleWindow("remainsWarActivity")
		end
		imgui.separator()
		if imgui.colorButton("打印UI堆栈", cc.c4f(0.5, 0.6, 0.7, 0, 0.9), cc.c4f(0.98, 0.65, 0.16, 1), cc.c4f(0.5, 0.6, 0.7, 0, 0.9)) then
		end
		if imgui.colorButton("测试 Imgui Table", cc.c4f(0.5, 0.6, 0.7, 0, 0.9), cc.c4f(0.98, 0.65, 0.16, 1), cc.c4f(0.5, 0.6, 0.7, 0, 0.9)) then
			switchOpen("imguiTestTable")
		end
		if imgui.colorButton("测试点击按钮效果", cc.c4f(0.5, 0.6, 0.7, 0, 0.9), cc.c4f(0.98, 0.65, 0.16, 1), cc.c4f(0.5, 0.6, 0.7, 0, 0.9)) then
			print("点击按钮--可以做一些处理")
		end
	end)
end
imgui.addDrawFunc("imguiTestPanel", imguiTestPanel)
