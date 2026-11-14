local baseFguiPanel = require("fgui.base.baseFguiPanel")
local ArisanHouseBuffPopPanel = class("ArisanHouseBuffPopPanel", baseFguiPanel)
function ArisanHouseBuffPopPanel:ctor(...)
	self.super.ctor(self, ...)
	print("ArisanHouseBuffPopPanel:ctor", self.viewName)
end
function ArisanHouseBuffPopPanel:getPackageList()
	if not self._packageList then
		_UPVALUE3_ = self._packageList
		self._packageList, self._packageList[1] = self._packageList, "ArtisanHouse"
		self._packageList, self._packageList[2] = self._packageList, "CommonNew"
		self._packageList, self._packageList[3] = self._packageList, "WiseTutor"
	end
	return self._packageList
end
function ArisanHouseBuffPopPanel:onInit()
	print("=======ArisanHouseBuffPopPanel:onInit")
	self.fields.Button_Go:addClickListener(handler(self, self.onClickGo))
	self.fields.Button_Go:setString(i18n("common_text_477"))
	self.fields.Text_Tips:setColorinfo("#70C723", "#B4AA87")
	self.fields.Text_Tips:initData()
	self.fields.Text_Tips:setEndHandle(function()
		if self then
			SoraDRemoveAllAfterPanelFromManager(self)
		end
	end)
end
function ArisanHouseBuffPopPanel:initData()
	self.fields.Text_Tips:initData()
end
function ArisanHouseBuffPopPanel:onShow()
	print("=======ArisanHouseBuffPopPanel:onShow")
	self.fields.panel_normal:setTitle(self.param.title)
	self.goHandle = self.param.goHandle
	local effectInfo = self.param.actltCtrl.getNowEffectInfo(SoraDGetCastleLv())
	self.fields.Buff_Item1:initData(effectInfo.EffectIcon[1] .. ".png", effectInfo.PrivilegeEffect[1], true)
	self.fields.Buff_Item2:initData(effectInfo.EffectIcon[2] .. ".png", effectInfo.PrivilegeEffect[2], true)
end
function ArisanHouseBuffPopPanel:onClickGo()
	SoraDPlaySound()
	self.goHandle()
	self:removeFromParent()
end
function ArisanHouseBuffPopPanel:onHide()
	print("=======ArisanHouseBuffPopPanel:onHide")
end
function ArisanHouseBuffPopPanel:onDispose()
	print("=======ArisanHouseBuffPopPanel:onDispose")
end
return ArisanHouseBuffPopPanel
