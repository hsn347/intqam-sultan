local divineBeastMarkCtrl = SoraDGetCtrl("divineBeastMarkCtrl")
local divineBeastMarkRead = include("divineBeastMarkRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local DivineBeastMarkElementSwitchPanel = class("DivineBeastMarkElementSwitchPanel", baseFguiPanel)
function DivineBeastMarkElementSwitchPanel:ctor(...)
	self.isLRU = true
	DivineBeastMarkElementSwitchPanel.super.ctor(self, ...)
	print("DivineBeastMarkElementSwitchPanel:ctor", self.viewName)
end
function DivineBeastMarkElementSwitchPanel:onInit()
	print("=======DivineBeastMarkElementSwitchPanel:onInit")
	self.fields.Panel_bg:setString(i18n("Divine_beast_mark_text_112"))
	self.fields.Btn_switch:setTitle(i18n("Divine_beast_mark_text_116"))
	self.fields.Btn_switch:addClickEventListener(handler(self, self.onClick_Btn_switch))
	self.fields.text_desc:setString(i18n("Divine_beast_mark_text_117"))
	self.elementUIs, _ENV = self.fields.text_desc.setString, self.fields.text_desc.setString
	for i = 1, 4 do
		self.elementUIs[i] = self.fields["Check_MC_Element" .. i]
		self.elementUIs[i]:fixPos()
	end
	self.targetElementUIs, _ENV = 1, (for index)
	for i = 1, 3 do
		self.targetElementUIs[i] = self.fields["elem_taerget" .. i]
		self.targetElementUIs[i]:addClickEventListener(handler(self, self.onClick_CheckBtn), i)
		self.targetElementUIs[i]:fixPos()
	end
	self.checkBtns, _ENV = 1, (for index)
	for i = 1, 3 do
		self.checkBtns[i] = self.fields["Check" .. i]
		self.checkBtns[i]:addClickEventListener(handler(self, self.onClick_CheckBtn), i)
		self.checkBtns[i]:fixPos()
	end
	self.fields.Label_title1:setString(i18n("Divine_beast_mark_text_113"))
	self.fields.Label_title2:setString(i18n("Divine_beast_mark_text_114"))
	self.sorElements = divineBeastMarkRead.getElementsSort()
	self.itemId = CONST_ARRAY.ELEMENT_MODIFICATION_ITEM[1]
	self.cost = CONST_ARRAY.ELEMENT_MODIFICATION_ITEM[2]
	self.fields.Com_have:initData(self.itemId)
end
function DivineBeastMarkElementSwitchPanel:endShow()
	print("=======DivineBeastMarkElementSwitchPanel:endShow")
	self.fields.Btn_switch:setGrayed(false)
	self:hideEffect()
	self.bagMarkId = self.param.bagMarkId
	self:updateView()
end
function DivineBeastMarkElementSwitchPanel:hideEffect()
	self.fields.ani_effect1:setVisible(false)
	self.fields.ani_effect2:setVisible(false)
	self.fields.ani_effect3:setVisible(false)
	for i = 1, 3 do
		self.fields["line_effect" .. i]:setVisible(false)
		self.fields["target_effect" .. i]:setVisible(false)
	end
end
function DivineBeastMarkElementSwitchPanel:updateView()
	self:hideEffect()
	self.selectedTargetElem = nil
	self.mark = divineBeastMarkCtrl:getMarkByBagMarkId(self.bagMarkId)
	self.markCfg = self.mark.markCfg
	for i = 1, 4 do
		local element = self.markCfg.elements[i] or 0
		self.elementUIs[i]:setVisible(element ~= 0)
		if element ~= 0 then
			self.elementUIs[i]:setIcon(divineBeastMarkRead.getElementIcon(element))
		end
	end
	self.fields.elem_random:setIcon(divineBeastMarkRead.getElementIcon(self.mark.randomElem or 5))
	local refineElemCount = self.mark.refineElemCount or 0
	local switchTimes = self.markCfg.modification_times or 0
	print("refineElemCount", refineElemCount, switchTimes)
	self.isRandomMode = refineElemCount < switchTimes
	self.controllers.c1:setSelectedIndex(self.isRandomMode and 0 or 1)
	if self.isRandomMode then
		self.transitions.t0:play(1, 0, 0, 0)
		divineBeastMarkCtrl = 0
		divineBeastMarkCtrl, divineBeastMarkCtrl, (0).num = divineBeastMarkRead.getElementIcon(self.mark.randomElem or 5)
		;(switchTimes - refineElemCount).num, divineBeastMarkRead.getElementIcon(self.mark.randomElem or 5).color = divineBeastMarkRead.getElementIcon(self.mark.randomElem or 5)
		self.fields.text_desc:setString(i18n_html("Divine_beast_mark_text_115", 0, switchTimes - refineElemCount))
	else
		self.transitions.t1:play(1, 0, 0, 0)
		self.fields.text_desc:setString(i18n("Divine_beast_mark_text_117"))
		local idx = 1
		for _, v in ipairs(self.sorElements) do
			if v ~= self.mark.randomElem then
				self.targetElementUIs[idx]:setIcon(divineBeastMarkRead.getElementIcon(v))
				idx = idx + 1
			end
		end
		self:updateSelectedElements()
	end
	self:updateBtnStatus()
	self.lastMarkRandomElem = self.mark.randomElem
end
function DivineBeastMarkElementSwitchPanel:onUpdateNewRandomElem()
	local mark = divineBeastMarkCtrl:getMarkByBagMarkId(self.bagMarkId)
	if self.isRandomMode then
		SoraDShowLoading(nil, nil, nil, true, 3.2)
		self.fields.ani_effect1:setVisible(true)
		self.fields.ani_effect2:setVisible(true)
		self.fields.ani_effect1:setAllFrameName("ssyj_effect_sj_%02d.png", 1)
		self.fields.ani_effect2:setAllFrameName("dh_xiagubk_%02d.png", 1)
		self.transitions.t0:play(function()
			SoraDCloseLoading()
			self:updateView()
		end)
		self:runAction(ffa.seq(ffa.delay(0.38), ffa.callFunc(function()
			self.fields.elem_random:setIcon(divineBeastMarkRead.getElementIcon(mark.randomElem or 5))
		end)))
		return
	end
	if self.lastMarkRandomElem == mark.randomElem then
		self:updateView()
		return
	end
	local idx = 1
	for i = 1, #self.sorElements do
		if self.sorElements[i] ~= self.lastMarkRandomElem then
			if mark.randomElem == self.sorElements[i] then
				local showIdx = SoraDFIsRA() and idx or 4 - idx
				self.fields["line_effect" .. showIdx]:setAllFrameName("dh_xiagufei_%02d.png", 1)
				self.fields["target_effect" .. showIdx]:setAllFrameName("ssyj_effect_js_%02d.png", 1)
				self.fields["target_effect" .. showIdx]:setVisible(true)
				self.fields["line_effect" .. showIdx]:setVisible(true)
			end
			idx = idx + 1
		end
	end
	self.fields.ani_effect1:setVisible(true)
	self.fields.ani_effect2:setVisible(true)
	self.fields.ani_effect3:setVisible(true)
	self.fields.ani_effect1:setAllFrameName("ssyj_effect_sj_%02d.png", 1)
	self.fields.ani_effect2:setAllFrameName("dh_xiagubk_%02d.png", 1)
	self.fields.ani_effect3:setFrames("YDTS_glowkuang_%02d.png", false)
	SoraDShowLoading(nil, nil, nil, true, 3.2)
	self:runAction(ffa.seq(ffa.delay(0.38), ffa.callFunc(function()
		self.fields.elem_random:setIcon(divineBeastMarkRead.getElementIcon(mark.randomElem or 5))
	end)))
	self.transitions.t1:play(function()
		SoraDCloseLoading()
		self:updateView()
	end)
end
function DivineBeastMarkElementSwitchPanel:updateBtnStatus()
	self.fields.Btn_switch:setCost(self.itemId, self.cost)
	self.fields.Com_have:updateNum()
end
function DivineBeastMarkElementSwitchPanel:updateSelectedElements(selectedIdx)
	if selectedIdx then
		local tempIdx = 1
		for _, v in ipairs(self.sorElements) do
			if v ~= self.mark.randomElem then
				if selectedIdx == tempIdx then
					self.selectedTargetElem = v
					break
				end
				tempIdx = tempIdx + 1
			end
		end
	end
	local idx = 1
	for _, v in ipairs(self.sorElements) do
		if v ~= self.mark.randomElem then
			self.checkBtns[idx]:setSelected(self.selectedTargetElem == v)
			self.targetElementUIs[idx]:setSelected(false)
			idx = idx + 1
		end
	end
	self.fields.Btn_switch:setGrayed(not self.isRandomMode and self.selectedTargetElem == nil)
end
_ENV, DivineBeastMarkElementSwitchPanel.onClick_CheckBtn = function(self, sender, param)
	SoraDPlaySound()
	self:updateSelectedElements(param)
end, function(self, sender, param)
	SoraDPlaySound()
	self:updateSelectedElements(param)
end
;(function(self, sender, param)
	SoraDPlaySound()
	self:updateSelectedElements(param)
end)[2] = "Divine_beast_mark_text_121"
;(function(self, sender, param)
	SoraDPlaySound()
	self:updateSelectedElements(param)
end)[4] = "Divine_beast_mark_text_122"
;(function(self, sender, param)
	SoraDPlaySound()
	self:updateSelectedElements(param)
end)[3] = "Divine_beast_mark_text_123"
local (function(self, sender, param)
	SoraDPlaySound()
	self:updateSelectedElements(param)
end)[1], strMap = "Divine_beast_mark_text_124", function(self, sender, param)
	SoraDPlaySound()
	self:updateSelectedElements(param)
end
function DivineBeastMarkElementSwitchPanel:onClick_Btn_switch(context)
	SoraDPlaySound()
	if not self.isRandomMode and self.selectedTargetElem == nil then
		SoraDShowMsgTip(i18n("Divine_beast_mark_text_119"))
		return
	end
	print("self.fields.Btn_switch:checkItem", self.fields.Btn_switch:checkItem(true))
	if not self.fields.Btn_switch:checkItem(true) then
		return
	end
	if self.selectedTargetElem then
		_ENV = self.fields.Btn_switch:checkItem(true)
		_ENV = self.fields.Btn_switch:checkItem(true)
		_ENV, _ENV, self.fields.Btn_switch:checkItem(true).name = strMap[self.selectedTargetElem], i18n(strMap[self.selectedTargetElem]), i18n(strMap[self.selectedTargetElem])
		i18n(strMap[self.selectedTargetElem]).name, strMap[self.selectedTargetElem].color = strMap[self.selectedTargetElem], "#70C723"
		self.fields.Btn_switch:checkItem(true).content = i18n_html("Divine_beast_mark_text_120", self.fields.Btn_switch:checkItem(true))
		self.fields.Btn_switch:checkItem(true).cancel = true
		self.fields.Btn_switch:checkItem(true).confirmFunc = function()
			if tolua.isnull(self) then
				return
			end
			divineBeastMarkCtrl:sendModifyRandomElem(self.bagMarkId, self.selectedTargetElem)
		end
		uiManager:show("MessageBox", self.fields.Btn_switch:checkItem(true))
	else
		divineBeastMarkCtrl:sendRefineRandomElem(self.bagMarkId)
	end
end
return DivineBeastMarkElementSwitchPanel
