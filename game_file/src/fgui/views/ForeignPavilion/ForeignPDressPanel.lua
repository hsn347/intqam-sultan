local baseFguiPanel = require("fgui.base.baseFguiPanel")
local ForeignPDressPanel = class("ForeignPDressPanel", baseFguiPanel)
local exoticPavilionCtrl = SoraDGetCtrl("exoticPavilionCtrl")
local foreignPavilionRead = include("foreignPavilionRead")
local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
function ForeignPDressPanel:ctor(...)
	self.super.ctor(self, ...)
	self.isHideCurrentSceneView = true
	print("ForeignPDressPanel:ctor", self.viewName)
end
function ForeignPDressPanel:getPackageList()
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
function ForeignPDressPanel:onInit()
	if not SoraDFIsRA() then
		self.view:fixChildrenPos(false, true)
	end
	self.fields.com_title:initData(i18n("exitic_pavillion_text_0064"), handler(self, self.onClickClose), handler(self, self.onClickHelp))
	self.fields.text_npc_name:setString(i18n("exitic_pavillion_text_0046"))
	self.fields.scroll_dress:setItemRenderer(handler(self, self.onDressRenderer))
	self.fields.scroll_attribute:setItemRenderer(handler(self, self.onAttributeRenderer))
end
function ForeignPDressPanel:onShow()
	print("=======ForeignPDressPanel:onShow")
	self.firstIn = true
	self.fields.role:setChat(3, 1)
	self.intimacyCfgs = foreignPavilionRead:getIntimacyCfgs()
	self.curLv = exoticPavilionCtrl:getCurIntimacyLv()
	self.curDressLv = exoticPavilionCtrl:getCurDressLv()
	local idx = self.proxy.param and self.proxy.param.idx or self.curDressLv
	self.curIdx = idx
	self:updateView()
	self.fields.n51:setVisible(false)
	self.fields.txt_time:setVisible(false)
	self.fields.titlebg:setAllFrameName("G_ygg_daji2_%02d.png", 1)
	self.fields.titlebg:setPlaySettings(0, -1, -1)
end
function ForeignPDressPanel:onHide()
	print("=======ForeignPDressPanel:onHide")
end
function ForeignPDressPanel:onDispose()
	print("=======ForeignPDressPanel:onDispose")
end
function ForeignPDressPanel:updateView()
	self.curDressLv = exoticPavilionCtrl:getCurDressLv()
	if self.oldDressLv and self.oldDressLv ~= self.curDressLv then
		exoticPavilionCtrl = nil
		;(nil).showType = 0
		uiManager:show("Foreignsublimation", nil)
	end
	self.oldDressLv = self.curDressLv
	self.fields.scroll_dress:setNumItems(#self.intimacyCfgs)
	self:setCurSelecteIdx(self.curIdx)
	self.fields.role:updateRole(exoticPavilionCtrl:getCurDressLv(), self.firstIn)
	self.firstIn = false
end
function ForeignPDressPanel:onClickHelp()
	SoraDPlaySound()
	_ENV = nil
	;(nil).content = i18n("exitic_pavillion_text_0038")
	uiManager:show("RuleView", nil):setOwnerKey(self)
end
function ForeignPDressPanel:onDressRenderer(index, obj)
	local intimacyCfg = self.intimacyCfgs[index + 1]
	local lv = intimacyCfg.intimacy
	local isUnLock = self.curLv >= intimacyCfg.intimacy
	obj:initData(intimacyCfg, isUnLock, self.curIdx == index + 1, self.curDressLv == lv)
	obj:setDressClickEvent(handler(self, self.onDressClick), index + 1)
	obj:setChangeClickEvent(handler(self, self.onChangeDress), index + 1)
end
function ForeignPDressPanel:onAttributeRenderer(index, obj)
	local isCurDress = self.isUnLockAtt and (index == 0 and self.curDressLv == self.curIdx or index ~= 0)
	obj:initData(self.texts[index + 1], self.isUnLockAtt, isCurDress)
end
function ForeignPDressPanel:setCurSelecteIdx(idx)
	self.curIdx = idx
	_ENV, self.curCfg = self.intimacyCfgs[idx], self.intimacyCfgs[idx]
	_ENV = nil
	;(nil).var = i18n(self.curCfg.clothesname)
	self.texts, self.intimacyCfgs[idx][1] = self.intimacyCfgs[idx], i18n("exitic_pavillion_text_0146", nil)
	self.texts, self.intimacyCfgs[idx][2] = self.intimacyCfgs[idx], i18n("exitic_pavillion_text_0146", nil)
	self.texts, self.intimacyCfgs[idx][3] = self.intimacyCfgs[idx], i18n("exitic_pavillion_text_0146", nil)
	self.texts, self.intimacyCfgs[idx][4] = self.intimacyCfgs[idx], i18n("exitic_pavillion_text_0146", nil)
	self.texts, self.intimacyCfgs[idx][5] = self.intimacyCfgs[idx], i18n("exitic_pavillion_text_0146", nil)
	if self.curCfg.boxdes and self.curCfg.boxdes ~= "" then
		self.texts[2] = i18n(self.curCfg.boxdes)
	end
	if self.curCfg.buffdes and next(self.curCfg.buffdes) ~= nil then
		self.texts[3] = i18n(self.curCfg.buffdes[1], self.curCfg.buffdes)
	end
	self.isUnLockAtt = idx <= self.curLv
	self.fields.scroll_attribute:removeChildrenToPool()
	self.fields.scroll_attribute:setNumItems(#self.texts)
	self.isCanChagneDress = self.isUnLockAtt and self.curDressLv ~= self.curCfg.intimacy
	self.controllers.c1:setSelectedIndex(0)
end
function ForeignPDressPanel:onDressClick(sender, idx)
	if self.curIdx == idx then
		return
	end
	self.curIdx = idx
	self:updateView()
	self.fields.role:hideChat()
	if not self.isUnLockAtt then
		_ENV = nil
		;(nil).name = i18n("exitic_pavillion_text_00" .. 46 + idx)
		self.fields.role:showChat(i18n("exitic_pavillion_text_0070", nil))
	end
end
function ForeignPDressPanel:onChangeDress(sender, index)
	exoticPavilionCtrl:reqEPChangeDress(index)
end
function ForeignPDressPanel:onDressChanged()
	self:updateView()
end
return ForeignPDressPanel
