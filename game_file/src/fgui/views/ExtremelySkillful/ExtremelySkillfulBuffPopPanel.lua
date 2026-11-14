local extremelySkillfulRead = include("extremelySkillfulRead")
local buffltCtrl = gModuleMgr.sharedMgr("buffltCtrl")
local ExtremelySkillfulCtrl = SoraDGetCtrl("ExtremelySkillfulCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local ExtremelySkillfulBuffPopPanel = class("ExtremelySkillfulBuffPopPanel", baseFguiPanel)
function ExtremelySkillfulBuffPopPanel:ctor(...)
	self.super.ctor(self, ...)
	print("ExtremelySkillfulBuffPopPanel:ctor", self.viewName)
end
function ExtremelySkillfulBuffPopPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function ExtremelySkillfulBuffPopPanel:onInit()
	print("=======ExtremelySkillfulBuffPopPanel:onInit")
	self.fields.panel_normal:setTitle(i18n("activity_name_9001488"))
	self.fields.Button_Go:addClickListener(handler(self, self.onClickGo))
	self.fields.Button_Go:setString(i18n("common_text_477"))
	self.fields.Text_Tips:setEndHandle(function()
		if self then
			SoraDRemoveAllAfterPanelFromManager(self)
		end
	end)
	self.fields.BuffList:setItemRenderer(handler(self, self.onBuffItemRenderer))
end
function ExtremelySkillfulBuffPopPanel:onShow()
	print("=======ExtremelySkillfulBuffPopPanel:onShow")
	self:initData()
end
function ExtremelySkillfulBuffPopPanel:initData()
	local buffIndex = ExtremelySkillfulCtrl:getBuffIndex()
	self.valueList, ExtremelySkillfulCtrl = ExtremelySkillfulCtrl, ExtremelySkillfulCtrl
	self.effectInfo = extremelySkillfulRead.getNowEffectInfo(1)
	local value1, value2
	if 0 < buffIndex then
		for i, v in ipairs(self.effectInfo.PrivilegeEffect) do
			local effectType = buffltCtrl:getEffectType(v)
			table.insert(self.valueList, ExtremelySkillfulCtrl:getBuffVale(effectType))
		end
		self.fields.Text_Tips:initData(buffIndex)
	else
		self.fields.Text_Tips:initData(1)
	end
	dump(self.effectInfo, "self.effectInfo.EffectIcon", 100)
	self.fields.BuffList:setNumItems(table.nums(self.effectInfo.EffectIcon))
	self.fields.BuffList:resizeToFit(table.nums(self.effectInfo.EffectIcon))
end
function ExtremelySkillfulBuffPopPanel:onClickGo()
	SoraDPlaySound()
	uiManager:show("ExtremelySkillfulMain")
	self:removeFromParent()
end
function ExtremelySkillfulBuffPopPanel:onBuffItemRenderer(index, object)
	object:initData(self.effectInfo.EffectIcon[index + 1] .. ".png", self.effectInfo.PrivilegeEffect[index + 1], true, self.valueList[index + 1])
end
return ExtremelySkillfulBuffPopPanel
