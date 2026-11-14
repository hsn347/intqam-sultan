local sultansBackSettingPop = class("sultansBackSettingPop", function(target)
	if target and tolua.type(target) == "string" then
		target = SoraDCreateTouchPanel(target)
	end
	return target or SoraDCreateTouchPanel("sultansBackSettingPop")
end)
function sultansBackSettingPop:onExitPanel()
	if self.nowShowFlag ~= self.originShowFlag then
		_ENV = nil
		;(nil).byUID = true
		SoraDConfigSet("Game:sultansBackView:showInMainUITop~bool", self.nowShowFlag, nil)
		_ENV = "Game:sultansBackView:showInMainUITop~bool"
		;("Game:sultansBackView:showInMainUITop~bool").msg = "MESSAGE_SULTANSBACK_SETTING_REFRESH"
		SoraDSendMessage("Game:sultansBackView:showInMainUITop~bool")
	end
end
function sultansBackSettingPop:ctor(properties)
	_ENV = nil
	;(nil).byUID = true
	self.originShowFlag = SoraDConfigGet("Game:sultansBackView:showInMainUITop~bool", nil)
	self.nowShowFlag = self.originShowFlag
	self.commonPopBoxNode = SoraDGetExtendChildFromCCSByName(self, "CCS_commonPopBox")
	self.commonPopBoxNode:setTitleName(i18n("sudan_back_text01"))
	self.nodeGameSettingCommonSwitch = SoraDGetExtendChildFromCCSByName(self, "CCS_gameSettingCommonSwitch_switch")
	self.nodeGameSettingCommonSwitch:setCallBack(handler(self, self.changeSetting))
	self.textContent = SoraDGetChildByName(self, "textContent")
	self.textContent:setString(i18n("sudan_back_text02"))
	self.nodeGameSettingCommonSwitch:setVal(self.originShowFlag)
end
function sultansBackSettingPop:changeSetting(nowShowFlag, tag)
	self.nowShowFlag = nowShowFlag
end
return sultansBackSettingPop
