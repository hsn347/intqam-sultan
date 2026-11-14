local combinationCtrl = SoraDGetCtrl("combinationCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local combinationCostViewPanel = class("combinationCostViewPanel", baseFguiPanel)
function combinationCostViewPanel:ctor(...)
	combinationCostViewPanel.super.ctor(self, ...)
	print("combinationCostViewPanel:ctor", self.viewName)
end
function combinationCostViewPanel:onInit()
	print("=======combinationCostViewPanel:onInit")
	self.fields.Panel_bg:setString(i18n("common_text_676"))
	self.fields.Text_tips:setString(i18n("privilege_text_106"))
	self.fields.Button_ok:setString(i18n("common_text_204"))
	self.fields.Button_ok:addClickListener(handler(self, self.onClickUse))
	self.fields.List:setItemRenderer(handler(self, self.onListRenderer))
end
function combinationCostViewPanel:onShow()
	print("=======combinationCostViewPanel:onShow")
	self.setID = self.param.setID
	self.isFromUsing = self.param.isFromUsing
	self:initData()
end
function combinationCostViewPanel:onListRenderer(index, obj)
	obj:initData(self.singleData[index + 1])
end
function combinationCostViewPanel:initData()
	self.singleData = self:getSingleData(self.setID)
	local ctype = combinationCtrl.COMBINATION_TYPE.COMBINATION
	local name = combinationCtrl:getSetName(ctype, self.setID)
	combinationCtrl = nil
	;(nil).name = name
	self.fields.Text_tips:setString(i18n("privilege_text_106", nil))
	self.fields.List:setNumItems(#self.singleData)
	local isEnough = true
	for i, data in ipairs(self.singleData) do
		if not data.enough then
			isEnough = false
		end
	end
	if isEnough or self.needMithril ~= 0 then
		self.fields.Button_ok:setEnabled(true)
	else
		self.fields.Button_ok:setEnabled(false)
	end
end
function combinationCostViewPanel:getSingleData(setID)
	_ENV, _ENV = nil, nil
	;(nil).resid = gIDDef.MITHRIL
	;(nil).rescount = 0
	_ENV, (nil)[1], (nil).resType = nil, nil, 1
	;(nil).resid = gIDDef.GOLD
	;(nil).rescount = 0
	;(nil)[2], (nil).resType = nil, 1
	local singleData
	local combData = self.isFromUsing and combinationCtrl:getCombinationPreData(setID) or combinationCtrl:getCombinationData(setID)
	self.combData = combData
	if not combData then
		return singleData
	end
	self.needMithril = 0
	if combData.warGemSetId and 0 < combData.warGemSetId then
		local warGemCtrl = SoraDGetCtrl("warGemCtrl")
		local curActiveSetID = warGemCtrl:getActPanelId()
		if tonumber(combData.warGemSetId) ~= tonumber(curActiveSetID) then
			local const = warGemCtrl:getActivePanelCost(combData.warGemSetId)
			if const and const[singleData[1].resid] then
				singleData[1].rescount = -const[singleData[1].resid]
				self.needMithril = singleData[1].rescount
			end
		end
	end
	if combData.lordSkillSetId and 0 < combData.lordSkillSetId then
		local lordSkillModuleAPI = include("lordSkillModuleAPI")
		local curActiveSetID = lordSkillModuleAPI:getActiveSetID()
		if tonumber(combData.lordSkillSetId) ~= tonumber(curActiveSetID) then
			local itemID = 501301
			local itemCount = SoraDGetCtrl("backpackCtrl"):getItemCount(itemID)
			if 0 < itemCount then
				singleData[2].resid = itemID
				singleData[2].rescount = 1
				singleData[2].resType = 2
			else
				singleData[2].resid = gIDDef.GOLD
				singleData[2].rescount = gConstValue.LORD_RESET_SKILL_POINT
			end
		end
	end
	for i, v in ipairs(singleData) do
		if 1 == v.resType then
			v.enough, v.curRes = SoraDEnoughRes(v.resid, v.rescount)
		elseif 2 == v.resType then
			v.curRes = SoraDGetCtrl("backpackCtrl"):getItemCount(v.resid)
			v.enough = v.curRes >= v.rescount
		end
	end
	return singleData
end
function combinationCostViewPanel:resUpdate()
	self:initData()
end
function combinationCostViewPanel:checkSetUnLock(...)
	for _, slotInfo in ipairs(combinationCtrl:getBaseCombinationSlotList()) do
		local setID = self.combData and tonumber(self.combData[slotInfo.fieldKey]) or 0
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
function combinationCostViewPanel:checkEnough()
	local dismountCost = self.needMithril
	if not SoraDEnoughRes(gIDDef.MITHRIL, dismountCost) then
		local cityCtrl = SoraDGetCtrl("cityCtrl")
		local curRes = cityCtrl:getResCount(gIDDef.MITHRIL)
		local _ENV, shortList = cityCtrl, cityCtrl
		local _ENV, data = gIDDef.MITHRIL, gIDDef.MITHRIL
		data.resid = gIDDef.MITHRIL
		data.curcount = curRes
		data.rescount = dismountCost - data.curcount
		table.insert(shortList, data)
		local proxy = uiManager:getOrCreateProxy("CommonQuicklyadd")
		if proxy:checkNeedRes(shortList) then
			uiManager:show("CommonQuicklyadd")
		else
			local resToGold = serviceFunctions.resConvertToGold(gIDDef.MITHRIL, math.max(0, data.rescount))
			_ENV, _ENV = math.max(0, data.rescount)
			_ENV, combinationCtrl, math.max(0, data.rescount).resToGold = math.max(0, data.rescount)
			math.max(0, data.rescount).resid = gIDDef.MITHRIL
			math.max(0, data.rescount).rescount = data.rescount
			math.max(0, data.rescount).needResData, math.max(0, data.rescount).retCostRes, math.max(0, data.rescount)[1] = math.max(0, data.rescount)
			math.max(0, data.rescount).viewType = RESBUYVIEW_TYPE.WAR_GEM_REPLACE
			math.max(0, data.rescount).handle = function()
				combinationCtrl:reqCombinationUse(self.setID)
				self:close()
			end
			uiManager:show("buildCreateResBuy", math.max(0, data.rescount))
		end
		return false
	end
	return true
end
function combinationCostViewPanel:onClickUse()
	SoraDPlaySound()
	if self:checkSetUnLock() and self:checkEnough() then
		if self.isFromUsing then
			self.combData.isUse = true
			self.combData.isUsing = nil
			combinationCtrl:reqCombinationSet(self.combData)
			self:close()
		else
			combinationCtrl:reqCombinationUse(self.setID)
			self:close()
		end
	end
end
return combinationCostViewPanel
