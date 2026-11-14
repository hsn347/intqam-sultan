local baseFguiPanel = require("fgui.base.baseFguiPanel")
local MainCityGuideTestPanel = class("MainCityGuideTestPanel", baseFguiPanel)
function MainCityGuideTestPanel:ctor(...)
	self.super.ctor(self, ...)
	print("MainCityGuideTestPanel:ctor", self.viewName)
end
function MainCityGuideTestPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function MainCityGuideTestPanel:onInit()
	print("=======MainCityGuideTestPanel:onInit")
	self.fields.stepInput:setText("810100")
	self.fields.start:setTitle("开始")
	self.fields.start:addClickEventListener(handler(self, self.clickStart))
	self.fields.endBtn:setTitle("结束至")
	self.fields.endBtn:addClickEventListener(handler(self, self.clickEnd))
	self.fields.closeBtn:addClickEventListener(handler(self, self.clickClose))
	self.fields.stepInput:setText(self.param.startStep)
	self.mainCityGuideManager = self.param.guideManager
end
function MainCityGuideTestPanel:onShow()
	print("=======MainCityGuideTestPanel:onShow")
end
function MainCityGuideTestPanel:clickStart()
	local guideStep = self.fields.stepInput:getText()
	self.mainCityGuideManager:startGuide(guideStep)
end
function MainCityGuideTestPanel:clickEnd()
	SoraDPlaySound()
	local gametop = gModuleMgr.getObject("gametop")
	local guideCtrl = gametop.playertop_:getModule("guideCtrl")
	local _ENV, actionArray = gametop.playertop_, gametop.playertop_
	local guideStep = self.fields.stepInput2:getText()
	for i, v in ipairs(gMainCityGuideModule) do
		if tonumber(v) < tonumber(guideStep) then
			table.insert(actionArray, ffa.delay(0.3))
			table.insert(actionArray, ffa.callFunc(function(...)
				guideCtrl:testCompleteGuide(v)
			end))
		end
	end
	table.insert(actionArray, ffa.delay(1))
	table.insert(actionArray, ffa.callFunc(function(...)
		self.mainCityGuideManager:startGuide(guideStep)
	end))
	self:getParent():runAction(ffa.seq(actionArray))
end
function MainCityGuideTestPanel:clickClose()
	SoraDPlaySound()
	local gametop = gModuleMgr.getObject("gametop")
	local guideCtrl = gametop.playertop_:getModule("guideCtrl")
	local _ENV, actionArray = gametop.playertop_, gametop.playertop_
	for i, v in ipairs(gMainCityGuideModule) do
		table.insert(actionArray, ffa.delay(0.3))
		table.insert(actionArray, ffa.callFunc(function(...)
			guideCtrl:testCompleteGuide(v)
		end))
	end
	table.insert(actionArray, ffa.delay(1))
	table.insert(actionArray, ffa.callFunc(function(...)
		_ENV = nil
		;(nil).msg = "MESSAGE_MAINCITYGUIDE_ALLEND"
		SoraDSendMessage(nil)
	end))
	self:setVisible(false)
	self:getParent():runAction(ffa.seq(actionArray))
	self.mainCityGuideManager:closeUI()
end
return MainCityGuideTestPanel
