local godArmsRuneCtrl = SoraDGetCtrl("godArmsRuneCtrl")
local artifactRuneRead = include("artifactRuneRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local RuneChooseViewPanel = class("RuneChooseViewPanel", baseFguiPanel)
function RuneChooseViewPanel:ctor(...)
	self.super.ctor(self, ...)
	print("RuneChooseViewPanel:ctor", self.viewName)
end
function RuneChooseViewPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function RuneChooseViewPanel:onInit()
	print("=======RuneChooseViewPanel:onInit")
	self.uidList, _ENV = print, print
	self.fields.Panel_bg:setString(i18n("Weapon_Rune_tips_044"))
	self.fields.Btn_operate:setString(i18n("Weapon_Rune_tips_045"))
	self.fields.Btn_operate:addClickListener(handler(self, self.onBtnClick))
	self.fields.Btn_operate:setEnabled(false)
	self.fields.List:setVirtual()
	self.fields.List:setItemRenderer(handler(self, self.onItemRenderer))
	_ENV = handler(self, self.onItemRenderer)
	handler(self, self.onItemRenderer).num1 = fguiHelper.getColorString("#E02B2B", 0)
	handler(self, self.onItemRenderer).num2 = self.param.data.count
	self.fields.Text_num:setString(i18n("Weapon_Rune_tips_047", handler(self, self.onItemRenderer)))
	self.fields.Text_none:setString(i18n("Weapon_Rune_tips_019"))
	self.fields.Text_none:setVisible(false)
	self:initData()
end
function RuneChooseViewPanel:onItemRenderer(index, obj)
	local isChoose = false
	if SoraDisInList(self.myRuneList[index + 1].uid, self.uidList) then
		isChoose = true
	end
	obj:initData(self.myRuneList[index + 1], isChoose, true, true, 2)
end
function RuneChooseViewPanel:strengthenChooseBack(target, data)
	local chooseData = data.data
	if data.isChoose then
		if #self.uidList < self.param.data.count then
			table.insert(self.uidList, chooseData.uid)
		else
			_ENV = nil
			;(nil).num = self.param.data.count
			;(nil).maxNum = self.param.data.count
			SoraDShowMsgTip(i18n("common_text_4363", nil))
		end
	else
		for k, v in ipairs(self.uidList) do
			if v == chooseData.uid then
				table.remove(self.uidList, k)
			end
		end
	end
	_ENV = i18n("common_text_4363", nil)
	i18n("common_text_4363", nil).num1 = fguiHelper.getColorString(#self.uidList >= self.param.data.count and "#FFFFFF" or "#E02B2B", #self.uidList)
	i18n("common_text_4363", nil).num2 = self.param.data.count
	self.fields.Text_num:setString(i18n("Weapon_Rune_tips_047", i18n("common_text_4363", nil)))
	self.fields.Btn_operate:setEnabled(#self.uidList >= self.param.data.count)
	self.fields.List:setNumItems(#self.myRuneList)
end
function RuneChooseViewPanel:onShow()
	print("=======RuneChooseViewPanel:onShow")
end
function RuneChooseViewPanel:updateView()
	self:sortData()
	for k, v in ipairs(self.uidList) do
		local isIn = false
		for ki, vi in ipairs(self.myRuneList) do
			if vi.uid == v then
				isIn = true
				break
			end
		end
		if not isIn then
			for m, n in ipairs(self.uidList) do
				if n == v then
					table.remove(self.uidList, m)
				end
			end
		end
	end
	_ENV = nil
	;(nil).num1 = fguiHelper.getColorString(#self.uidList >= self.param.data.count and "#FFFFFF" or "#E02B2B", #self.uidList)
	;(nil).num2 = self.param.data.count
	self.fields.Text_num:setString(i18n("Weapon_Rune_tips_047", nil))
	self.fields.Btn_operate:setEnabled(#self.uidList >= self.param.data.count)
	self.fields.List:setNumItems(#self.myRuneList)
	self.fields.Text_none:setVisible(#self.myRuneList == 0)
end
function RuneChooseViewPanel:sortData()
	local runeList = godArmsRuneCtrl:getRuneData()
	self.myRuneList, godArmsRuneCtrl = godArmsRuneCtrl, godArmsRuneCtrl
	for k, v in ipairs(runeList) do
		if not v.isLock and v.uid ~= self.param.uid and not godArmsRuneCtrl:isRuneWear(v.uid) and v.rid == self.param.data.id then
			local info = artifactRuneRead.getRuneInfo(v.rid)
			local lvCfg = artifactRuneRead.getRuneLvCfg(info.ExpGrowingType, v.level)
			if not v.extraProperty then
				local godArmsRuneCtrl, extraProperty = v.extraProperty, v.extraProperty
			end
			godArmsRuneCtrl = nil
			;(nil).rid = v.rid
			;(nil).uid = v.uid
			;(nil).isLock = v.isLock
			;(nil).class = lvCfg.Class
			;(nil).level = lvCfg.Level
			;(nil).luckyValue = v.luckyValue or 0
			;(nil).runeType = info.RuneType
			;(nil).heritType = info.HeritType
			;(nil).isWear = godArmsRuneCtrl:isRuneWear(v.uid)
			;(nil).extraProperty = extraProperty
			table.insert(self.myRuneList, nil)
		end
	end
	table.sort(self.myRuneList, function(a, b)
		if a.class == b.class then
			if a.level == b.level then
				if a.luckyValue == b.luckyValue then
					return a.rid < b.rid
				else
					return a.luckyValue < b.luckyValue
				end
			else
				return a.level < b.level
			end
		else
			return a.class < b.class
		end
	end)
end
function RuneChooseViewPanel:initData()
	self:sortData()
	self.fields.List:setNumItems(#self.myRuneList)
	self.fields.List:jumpToTop()
	self.fields.Text_none:setVisible(#self.myRuneList == 0)
end
function RuneChooseViewPanel:onBtnClick()
	SoraDPlaySound()
	_ENV = nil
	;(nil).msg = "MESSAGE_UI_RUNE_CHOOSE_UPDATE"
	;(nil).uidList = self.uidList
	SoraDSendMessage(nil)
	self:close()
end
return RuneChooseViewPanel
