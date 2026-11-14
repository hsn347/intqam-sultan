local baseComponent = require("fgui.base.baseComponent")
local Com_MC_bagDetail = fgui.extension_class(fgui.GComponent, baseComponent)
local divineBeastMarkCtrl = SoraDGetCtrl("divineBeastMarkCtrl")
local publicRead = include("publicRead")
fgui.register_extension("ui://MythicalCreatures/Com_MC_bagDetail", Com_MC_bagDetail)
function Com_MC_bagDetail:onInit()
	self.itemID = gIDDef.DIVINE_BEAST_MARK_EXP
	self.fields.Btn_refine:setTitle(i18n("Divine_beast_mark_refinement_02"))
	self.fields.Btn_refine:addClickEventListener(handler(self, self.onRefineClick))
	self.fields.Btn_refine:setVisible(false)
	self.fields.Btn_change:setTitle(i18n("Divine_beast_mark_change_01"))
	self.fields.Btn_change:addClickEventListener(handler(self, self.onSwitchClick))
	self.fields.Btn_change:setVisible(false)
	self.fields.Btn_changeElem:setTitle(i18n("Divine_beast_mark_text_111"))
	self.fields.Btn_changeElem:addClickEventListener(handler(self, self.onChangeElemClick))
	self.fields.Btn_changeElem:setVisible(false)
	self.fields.Btn_up:setTitle(i18n("runningSheep_text_06"))
	self.fields.Btn_up:addClickEventListener(handler(self, self.onUpgradeClick))
	self.fields.Btn_up:setVisible(false)
	self.fields.Com_have:setVisible(false)
	self.fields.Btn_refine:fixPos()
	self.fields.Btn_change:fixPos()
	self.fields.Btn_up:fixPos()
	self.fields.Btn_changeElem:fixPos()
	self.fields.Com_have:fixPos()
	self.fields.Com_have:initData(self.itemID, handler(self, self.onGetItem))
end
function Com_MC_bagDetail:onShow()
end
function Com_MC_bagDetail:onGetItem()
	SoraDPlaySound()
	_ENV = nil
	;(nil).itemID = self.itemID
	uiManager:show("CommonSourceGuide", nil)
end
function Com_MC_bagDetail:initData(data, index)
	self.mark = data
	dump(data, "Com_MC_bagDetail:initData")
	self.fields.Image_arr:setPositionX(SoraDFPosX(625 - 126 * index + 55, 608))
	self.fields.Com_MC_MarkDetail:initData(data, true)
	self:updateBtn()
end
function Com_MC_bagDetail:updateMark()
	self.fields.Com_MC_MarkDetail:updateMark()
	self:updateBtn()
end
function Com_MC_bagDetail:updateBtn()
	self.needExp = self.fields.Com_MC_MarkDetail:getUpgradeExp()
	self.haveExp = divineBeastMarkCtrl:getExpCount()
	self.fields.Btn_up:setEnabled(self.needExp ~= 0)
	local isStar = false
	if self.needExp == 0 then
		self.fields.Btn_up:setFreeTitle(i18n("desretDig_btn_02"), 1)
	elseif self.fields.Com_MC_MarkDetail:getNextLvNeedStar() > self.mark.star then
		isStar = true
		self.fields.Btn_up:setFreeTitle(i18n("Divine_beast_mark_text_65"), 1)
	else
		self.fields.Btn_up:setCost2(gIDDef.DIVINE_BEAST_MARK_EXP, self.needExp, self.haveExp)
		self.fields.Com_have:updateNum(self.haveExp)
	end
	if self.mark and self.fields.Com_MC_MarkDetail:getNextLvNeedStar() > self.mark.star then
		self.fields.Btn_up:setFreeTitle(i18n("Divine_beast_mark_text_65"), 1)
	end
	local self.visibleBtns, divineBeastMarkCtrl, isRefineVisible = self.fields.Btn_up, self.fields.Btn_up, self.mark and (self.mark.randomBuff1 ~= 0 or self.mark.randomBuff2 ~= 0)
	self.fields.Btn_refine:setVisible(isRefineVisible)
	if isRefineVisible then
		table.insert(self.visibleBtns, self.fields.Btn_refine)
	end
	local isChangeVisible = self.mark and self.mark.isCanChange and self.mark.slot == nil
	self.fields.Btn_change:setVisible(isChangeVisible)
	if isChangeVisible then
		table.insert(self.visibleBtns, self.fields.Btn_change)
	end
	local randomElem = self.mark and self.mark.randomElem or 0
	local isChangeElemVisible = randomElem ~= 0
	local centerBtn = isChangeElemVisible and self.fields.Btn_changeElem or self.fields.Btn_up
	self.fields.Btn_up:setVisible(not isChangeElemVisible)
	print("isChangeElemVisible", isChangeElemVisible)
	self.fields.Btn_changeElem:setVisible(isChangeElemVisible)
	self.fields.Com_have:setVisible(self.fields.Btn_up:isVisible() and not isStar and self.needExp ~= 0)
	local centerX = self:getSize().width / 2
	if #self.visibleBtns == 0 then
		centerBtn:setX(centerX)
	elseif #self.visibleBtns == 1 then
		local space = SoraDFIsRA() and 142.0 or -142.0
		self.visibleBtns[1]:setX(centerX - space)
		centerBtn:setX(centerX + space)
	elseif #self.visibleBtns == 2 then
		local space = SoraDFIsRA() and 206 or -206
		self.visibleBtns[1]:setX(centerX - space)
		self.visibleBtns[2]:setX(centerX)
		centerBtn:setX(centerX + space)
	end
end
function Com_MC_bagDetail:onRefineClick()
	SoraDPlaySound()
	_ENV = nil
	;(nil).mark = self.mark
	uiManager:show("DivineBeastMarkRefine", nil)
end
function Com_MC_bagDetail:onSwitchClick()
	SoraDPlaySound()
	if self.mark and self.mark.lock == 1 then
		SoraDShowMsgTip(i18n("Divine_beast_mark_text_125"))
		return
	end
	_ENV = i18n("Divine_beast_mark_text_125")
	i18n("Divine_beast_mark_text_125").mark = self.mark
	uiManager:show("DivineBeastMarkChange", i18n("Divine_beast_mark_text_125"))
end
function Com_MC_bagDetail:onChangeElemClick()
	SoraDPlaySound()
	_ENV = nil
	;(nil).bagMarkId = self.mark.bagMarkId
	uiManager:show("DivineBeastMarkElementSwitch", nil)
end
function Com_MC_bagDetail:onUpgradeClick()
	SoraDPlaySound()
	if self.mark and self.fields.Com_MC_MarkDetail:getNextLvNeedStar() > self.mark.star then
		_ENV = nil
		;(nil).mark = self.mark
		uiManager:show("DivineBeastMarkStar", nil)
		return
	end
	if self.haveExp < self.needExp then
		_ENV = nil
		;(nil).itemID = self.itemID
		uiManager:show("CommonSourceGuide", nil)
		return
	end
	divineBeastMarkCtrl:sendUpgrade(self.mark.bagMarkId)
end
return Com_MC_bagDetail
