local baseFguiPanel = require("fgui.base.baseFguiPanel")
local RadiantDecreeBuffPopPanel = class("RadiantDecreeBuffPopPanel", baseFguiPanel)
function RadiantDecreeBuffPopPanel:ctor(...)
	self.super.ctor(self, ...)
	self.debug = true
	print("RadiantDecreeBuffPopPanel:ctor", self.viewName)
end
function RadiantDecreeBuffPopPanel:getPackageList()
	if not self._packageList then
		_UPVALUE3_ = self._packageList
		self._packageList, self._packageList[1] = self._packageList, "RadiantDecree"
		self._packageList, self._packageList[2] = self._packageList, "CommonNew"
		self._packageList, self._packageList[3] = self._packageList, "WiseTutor"
	end
	return self._packageList
end
function RadiantDecreeBuffPopPanel:onInit()
	print("=======RadiantDecreeBuffPopPanel:onInit")
	self.fields.Button_Go:addClickListener(handler(self, self.onClickGo))
	self.fields.Button_Go:setString(i18n("common_text_477"))
	self.fields.Text_Tips:setColorinfo("#70C723", "#B4AA87")
	self.fields.Text_Tips:setEndHandle(function()
		if self then
			SoraDRemoveAllAfterPanelFromManager(self)
		end
	end)
end
function RadiantDecreeBuffPopPanel:initData()
end
function RadiantDecreeBuffPopPanel:onShow()
	print("=======RadiantDecreeBuffPopPanel:onShow")
	self.fields.panel_normal:setTitle(self.param.title)
	self.goHandle = self.param.goHandle
	local effectInfo = self.param.actltCtrl.getNowEffectInfo()
	if self.param.isStatue then
		effectInfo = self.param.actltCtrl.getNowStatueEffectInfo()
	end
	self.fields.Text_Tips:initData(self.param.isStatue)
	self.fields.Buff_Item1:setVisible(effectInfo.EffectIcon[1] ~= nil)
	if effectInfo.EffectIcon[1] then
		self.fields.Buff_Item1:initData(effectInfo.EffectIcon[1] .. ".png", effectInfo.PrivilegeEffect[1], true)
	end
	self.fields.Buff_Item2:setVisible(effectInfo.EffectIcon[2] ~= nil)
	if effectInfo.EffectIcon[2] then
		self.fields.Buff_Item2:initData(effectInfo.EffectIcon[2] .. ".png", effectInfo.PrivilegeEffect[2], true)
	end
	self.fields.Buff_Item3:setVisible(effectInfo.EffectIcon[3] ~= nil)
	if effectInfo.EffectIcon[3] then
		self.fields.Buff_Item3:initData(effectInfo.EffectIcon[3] .. ".png", effectInfo.PrivilegeEffect[3], true)
	end
	self.fields.Buff_Item4:setVisible(effectInfo.EffectIcon[4] ~= nil)
	if effectInfo.EffectIcon[4] then
		self.fields.Buff_Item4:initData(effectInfo.EffectIcon[4] .. ".png", effectInfo.PrivilegeEffect[4], true)
	end
end
function RadiantDecreeBuffPopPanel:onClickGo()
	SoraDPlaySound()
	self.goHandle()
	self:removeFromParent()
end
function RadiantDecreeBuffPopPanel:onHide()
	print("=======RadiantDecreeBuffPopPanel:onHide")
end
function RadiantDecreeBuffPopPanel:onDispose()
	print("=======RadiantDecreeBuffPopPanel:onDispose")
end
return RadiantDecreeBuffPopPanel
