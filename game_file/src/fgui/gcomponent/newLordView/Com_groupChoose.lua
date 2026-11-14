local warGemltCtrl = include("warGemltCtrl")
local combinationCtrl = SoraDGetCtrl("combinationCtrl")
local godArmsRuneCtrl = SoraDGetCtrl("godArmsRuneCtrl")
local divineBeastCtrl = SoraDGetCtrl("divineBeastCtrl")
local divineBeastMarkCtrl = SoraDGetCtrl("divineBeastMarkCtrl")
local divineBeastRead = include("divineBeastRead")
local baseComponent = require("fgui.base.baseComponent")
local Com_groupChoose = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://newLordView/Com_groupChoose", Com_groupChoose)
local COMBINATION_TYPE = combinationCtrl.COMBINATION_TYPE
function Com_groupChoose:onInit()
	self.setIDList, _ENV = nil, nil
	self.fields.List:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.List:addEventListener(fgui.UIEventType.ClickItem, handler(self, self.onChooseItem))
end
function Com_groupChoose:onShow()
end
function Com_groupChoose:onItemRenderer(index, obj)
	local setName = self.setIDList[index + 1].setID
	if self.weaponID then
		setName = godArmsRuneCtrl:getArmGroupName(self.weaponID, self.setIDList[index + 1].setID)
	else
		setName = combinationCtrl:getSetName(self.ctype, self.setIDList[index + 1].setID)
	end
	obj:setTitle(setName)
	obj:setSelected(tonumber(self.setIDList[index + 1].curSetId) == tonumber(self.setIDList[index + 1].setID))
end
function Com_groupChoose:onChooseItem()
	SoraDPlaySound()
	local selIndex = self.fields.List:getSelectedIndex() + 1
	_ENV, self.cellList[self.ctype] = self.cellList, tonumber(self.setIDList[selIndex].setID)
	self.cellList.setId = self.idx
	self.cellList.godArmsRunes = self.godArmsRunes
	local self.cellList.divineBeastMarkSet, data = self.divineBeastMarkSet, self.cellList
	for _, slotInfo in ipairs(combinationCtrl:getBaseCombinationSlotList()) do
		data[slotInfo.fieldKey] = self.cellList[slotInfo.ctype] or 0
	end
	if self.weaponID then
		local group = self.setIDList[selIndex].setID
		if include("artifactRuneRead").isRuneSetLock(group - 1) then
			SoraDShowMsgTip(i18n("Weapon_Rune_tips_086"))
		else
			self.godArmsRunes[tostring(self.weaponID)] = self.setIDList[selIndex].setID
			data.godArmsRunes = self.godArmsRunes
			if self.idx == combinationCtrl:getCurSetId() then
				data.isUsing = true
				combinationCtrl:reqCombinationSet(data, self.idx)
			else
				combinationCtrl:reqCombinationSet(data)
			end
			_ENV = combinationCtrl
			combinationCtrl.msg = "MESSAGE_UI_COMBINATION_SET"
			combinationCtrl.isSet = true
			SoraDSendMessage(combinationCtrl)
		end
	elseif self.ctype == COMBINATION_TYPE.DIVINEBEASTMARK then
		self.divineBeastMarkSet[tostring(self.divineID)] = self.setIDList[selIndex].setID
		data.divineBeastMarkSet = self.divineBeastMarkSet
		if self.idx == combinationCtrl:getCurSetId() then
			data.isUsing = true
			combinationCtrl:reqCombinationSet(data, self.idx)
		else
			combinationCtrl:reqCombinationSet(data)
		end
		_ENV = combinationCtrl
		combinationCtrl.msg = "MESSAGE_UI_COMBINATION_SET"
		combinationCtrl.isSet = true
		SoraDSendMessage(combinationCtrl)
	elseif self:checkSetUnLock(data) then
		if self.idx == combinationCtrl:getCurSetId() then
			data.isUsing = true
			combinationCtrl:reqCombinationSet(data, self.idx)
		else
			combinationCtrl:reqCombinationSet(data)
		end
		_ENV = combinationCtrl
		combinationCtrl.msg = "MESSAGE_UI_COMBINATION_SET"
		combinationCtrl.isSet = true
		SoraDSendMessage(combinationCtrl)
	end
end
function Com_groupChoose:checkSetUnLock(data)
	for _, slotInfo in ipairs(combinationCtrl:getBaseCombinationSlotList()) do
		local setID = data and tonumber(data[slotInfo.fieldKey]) or 0
		if 0 < setID then
			local unlock = combinationCtrl:checkSetUnLock(slotInfo.ctype, setID)
			if not unlock then
				SoraDShowMsgTip(i18n("privilege_text_128"))
				return false
			end
		end
	end
	return true
end
function Com_groupChoose:initData(idx, index, weaponID, isFromUsing, ctype, otherData)
	self.idx = idx
	self.index = index
	self.setIDList, combinationCtrl, self.weaponID = nil, nil, weaponID
	self.isFromUsing = isFromUsing or false
	self.ctype = ctype or self.index
	if (not self.isFromUsing or not combinationCtrl:getCombinationPreData(self.idx)) and not combinationCtrl:getCombinationData(self.idx) then
		local combinationCtrl, combData = combinationCtrl:getCombinationData(self.idx), combinationCtrl:getCombinationData(self.idx)
	end
	self.cellList, combinationCtrl = combinationCtrl, combinationCtrl
	for _, slotInfo in ipairs(combinationCtrl:getBaseCombinationSlotList()) do
		self.cellList[slotInfo.ctype] = tonumber(combData[slotInfo.fieldKey]) or 0
	end
	if not combData.godArmsRunes then
		combinationCtrl = combData.godArmsRunes
	end
	self.godArmsRunes = combData.godArmsRunes
	if not combData.divineBeastMarkSet then
		combinationCtrl = combData.divineBeastMarkSet
	end
	self.divineBeastMarkSet = combData.divineBeastMarkSet
	if self.weaponID then
		for i = 1, 3 do
			if not include("artifactRuneRead").isRuneSetLock(i) then
				combinationCtrl = i
				i.setID = i + 1
				self.setIDList[i], i.curSetId = i, self.godArmsRunes[tostring(self.weaponID)]
			end
		end
	elseif self.ctype == COMBINATION_TYPE.DIVINEBEASTMARK then
		self.divineID = otherData and otherData.divineID or divineBeastRead.getDefaultDivineID()
		for i = 1, 6 do
			combinationCtrl = i
			i.setID = i
			self.setIDList[i], i.curSetId = i, self.divineBeastMarkSet[tostring(self.divineID)]
		end
	else
		for i, setID in ipairs(combinationCtrl:getSetIDListForType(self.ctype)) do
			combinationCtrl = combinationCtrl:getSetIDListForType(self.ctype)
			combinationCtrl:getSetIDListForType(self.ctype).setID = setID
			self.setIDList[i], combinationCtrl:getSetIDListForType(self.ctype).curSetId = combinationCtrl:getSetIDListForType(self.ctype)
		end
	end
	self.fields.List:setNumItems(#self.setIDList)
end
return Com_groupChoose
