local baseFguiPanel = require("fgui.base.baseFguiPanel")
local ForeignPsettlementPanel = class("ForeignPsettlementPanel", baseFguiPanel)
local foreignPavilionRead = include("foreignPavilionRead")
function ForeignPsettlementPanel:ctor(...)
	self.super.ctor(self, ...)
	self.isHideCurrentSceneView = true
	print("ForeignPsettlementPanel:ctor", self.viewName)
	self.debug = true
end
function ForeignPsettlementPanel:getPackageList()
	if not self._packageList then
		_UPVALUE6_ = self._packageList
		self._packageList, self._packageList[1] = self._packageList, "ForeignPavilion"
		self._packageList, self._packageList[2] = self._packageList, "CommonNew"
		self._packageList, self._packageList[3] = self._packageList, "CommonUI"
		self._packageList, self._packageList[4] = self._packageList, "CommonUI0"
		self._packageList, self._packageList[5] = self._packageList, "CommonUI1"
		self._packageList, self._packageList[6] = self._packageList, "fonts"
	end
	return self._packageList
end
function ForeignPsettlementPanel:onInit()
	print("=======ForeignPsettlementPanel:onInit")
	self.fields.button_1:addClickEventListener(handler(self, self.closeSelf))
	self.fields.button_1:setTitle(i18n("common_text_204"))
	self.fields.heartAni:setAllFrameName("aixin_ygg_max%02d.png", 1)
	self.fields.heartAni:setPlaySettings(0, -1, -1)
	self.fields.button_2:addClickEventListener(handler(self, self.reStart))
	self.fields.button_2:setTitle(i18n("exitic_pavillion_text_0028"))
	self.fields.text_add_plus:setString("+")
	foreignPavilionRead = self.fields.text_add_plus.setString
	self.points, self.fields.text_add_plus.setString[1] = self.fields.text_add_plus.setString, foreignPavilionRead:getIntimacyValue(1, 1)
	self.points, self.fields.text_add_plus.setString[2] = self.fields.text_add_plus.setString, foreignPavilionRead:getIntimacyValue(1, 2)
	self.points, self.fields.text_add_plus.setString[3] = self.fields.text_add_plus.setString, foreignPavilionRead:getIntimacyValue(1, 2)
	self.points, self.fields.text_add_plus.setString[4] = self.fields.text_add_plus.setString, foreignPavilionRead:getIntimacyValue(1, 2)
	self.points, self.fields.text_add_plus.setString[5] = self.fields.text_add_plus.setString, foreignPavilionRead:getIntimacyValue(1, 2)
end
function ForeignPsettlementPanel:onShow()
	self.isWin = self.proxy.param and self.proxy.param.isWin
	self.isInStory = self.proxy.param and self.proxy.param.isInStory
	self.gameType = self.proxy.param.type
	if self.isWin then
		SoraDPlaySound("elimiateGame", 5)
		if display.height > 1136 then
			self.fields.Usm_1:setScale(display.height / 1136)
			self.fields.Usm_2:setScale(display.height / 1136)
			self.fields.Usm_3:setScale(display.height / 1136)
		end
		self.fields.Usm_1:setEffectPath("dunpai2.usm", false)
		self.fields.Usm_2:setEffectPath(SoraDFIsRA() and "dunpai5.usm" or "dunpai4.usm", false)
		self.fields.Usm_2:setBlendFunc(gl.SRC_ALPHA, gl.ONE_MINUS_SRC_ALPHA)
		self.fields.Usm_3:setEffectPath("G_dunpai1.usm,G_xh_dunpai3.usm")
		self.fields.Usm_3:setBlendFunc(gl.SRC_ALPHA, gl.ONE)
		if self.gameType == 5 then
			self:initCommandHallRewards()
		else
			self.fields.text:setString(i18n("exitic_pavillion_text_0113"))
		end
	else
		SoraDPlaySound("huntSound", "hunt_lost")
		self.fields.Usm_1:setBlendFunc(gl.SRC_ALPHA, gl.ONE_MINUS_SRC_ALPHA)
		self.fields.Usm_1:setEffectPath("sp_sszzsb_001.usm", false)
		self.fields.lose_sp:setURL(SoraDFIsRA() and "FONT_shibai_ar.png" or "FONT_shibai.png")
		self.fields.text:setString(i18n("exitic_pavillion_text_0114"))
	end
	if self.isInStory then
		self.controllers.c1:setSelectedIndex(1)
		self.fields.text_lose:setString(i18n("exitic_pavillion_text_0027"))
	else
		self.fields.text_add:setString(self.points[self.isWin and 1 or 2].point)
	end
	if self.gameType == 4 and not self.isInStory then
		local towerDefendRead = include("towerDefendRead")
		_ENV = i18n("exitic_pavillion_text_0027")
		i18n("exitic_pavillion_text_0027").num = self.proxy.param.totalKillNum
		self.fields.Text_count:setString(i18n("EP_settle_tips_0001", i18n("exitic_pavillion_text_0027")))
		self.fields.Text_count:setVisible(true)
	end
	print("=======ForeignPsettlementPanel:onShow")
end
function ForeignPsettlementPanel:closeSelf()
	SoraDPlaySound()
	if self.gameType == 4 then
		SoraDResetBackGroundMusic()
	end
	self:close()
end
function ForeignPsettlementPanel:reStart()
	SoraDPlaySound()
	local isInStory = self.isInStory
	dump(isInStory, "ForeignPsettlementPanel:reStart")
	self:close()
	_ENV = nil
	;(nil).isInStory = isInStory
	uiManager:show("TowerDefend", nil)
end
function ForeignPsettlementPanel:initCommandHallRewards(...)
	self.fields.text:setString(i18n("commandhall_text_64"))
	_UPVALUE5_ = self.fields.text
	self.fields.text[1] = "n44"
	self.fields.text[2] = "n46"
	self.fields.text[3] = "heartAni"
	self.fields.text[4] = "text_add_plus"
	self.fields.text[5] = "text_add"
	for i, v in ipairs(self.fields.text) do
		local widget = self.fields[v]
		widget:setVisible(false)
	end
	if not self.proxy.param or not self.proxy.param.rewards then
		local _ENV, rewards = self.proxy.param.rewards, self.proxy.param.rewards
	end
	self.fields.List_rewards:setItemRenderer(function(index, obj)
		local data = rewards[index + 1]
		obj:initData(data.id, data.count)
	end)
	self.fields.List_rewards:setNumItems(#rewards)
	self.fields.List_rewards:setVisible(true)
end
return ForeignPsettlementPanel
