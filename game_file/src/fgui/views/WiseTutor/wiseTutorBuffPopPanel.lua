local wiseTutorRead = include("wiseTutorRead")
local basePanel = require("fgui.base.baseFguiPanel")
local wiseTutorBuffPopPanel = class("wiseTutorBuffPopPanel", basePanel)
function wiseTutorBuffPopPanel:ctor(...)
	self.super.ctor(self, ...)
	self.debug = true
end
function wiseTutorBuffPopPanel:getPackageList()
	if not self._packageList then
		_UPVALUE4_ = self._packageList
		self._packageList, self._packageList[1] = self._packageList, "WiseTutor"
		self._packageList, self._packageList[2] = self._packageList, "CommonNew"
		self._packageList, self._packageList[3] = self._packageList, "CommonUI0"
		self._packageList, self._packageList[4] = self._packageList, "CommonUI1"
	end
	return self._packageList
end
function wiseTutorBuffPopPanel:onInit()
	self.fields.panel_normal:setTitle(i18n("activity_name_9001368"))
	self.fields.Button_Go:addClickListener(handler(self, self.onClickGo))
	self.fields.Button_Go:setString(i18n("common_text_477"))
	self.fields.Text_Tips:setColorinfo("#70C723", "#B4AA87")
	self.fields.Text_Tips:setEndHandle(function()
		if self then
			SoraDRemoveAllAfterPanelFromManager(self)
		end
	end)
end
function wiseTutorBuffPopPanel:onShow()
	local effectInfo = wiseTutorRead.getNowEffectInfo(SoraDGetCastleLv())
	self.fields.Buff_Item1:initData(effectInfo.EffectIcon[1] .. ".png", effectInfo.PrivilegeEffect[1], true)
	self.fields.Buff_Item2:initData(effectInfo.EffectIcon[2] .. ".png", effectInfo.PrivilegeEffect[2], true)
end
function wiseTutorBuffPopPanel:onClickGo()
	SoraDPlaySound()
	uiManager:show("wiseTutorMain")
	self:removeFromParent()
end
return wiseTutorBuffPopPanel
