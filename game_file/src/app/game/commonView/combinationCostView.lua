local combinationCtrl = SoraDGetCtrl("combinationCtrl")
_ENV = "combinationCtrl"
;("combinationCtrl").RES = 1
local ("combinationCtrl").TOOL, CONDITION_TYPE = 2, "combinationCtrl"
local combinationCostView = class("combinationCostView", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("combinationCostView")
	end
	return target
end)
function combinationCostView:ctor(...)
	self.itemList, _ENV = nil, nil
	self:initWidget()
	SoraDAddMessage(self, "MESSAGE_RESOURCE_UPDATE", handler(self, self.resUpdate))
end
function combinationCostView:initWidget(...)
	self.scaleActTarget = SoraDGetChildByName(self, "Center_Node")
	self.ccs_bg = SoraDGetExtendChildFromCCSByName(self, "CCS_commonPopBox_bg")
	self.ccs_bg:setTitleName(i18n("common_text_676"))
	self.Text_tips = SoraDGetChildByName(self, "Text_tips")
	self.Text_tips:setString(i18n("privilege_text_106"))
	self.Node_content = SoraDGetChildByName(self, "Node_content")
	local Node_single = SoraDGetChildByName(self, "Node_single")
	local Node_single_en = SoraDGetChildByName(self, "Node_single_en")
	Node_single:setVisible(false)
	Node_single_en:setVisible(false)
	self.Node_single = SoraDFIsRA() and Node_single or Node_single_en
	self.Button_ok = SoraDGetChildByName(self, "Button_ok")
	self.Button_ok:addTouchEventListener(handler(self, self.onClickUse))
	self.Button_ok:setTitleText(i18n("common_text_204"))
end
function combinationCostView:initData(setID)
	self.setID = setID
	self.singleData = self:getSingleData(self.setID)
	local isEnough = true
	for i, data in ipairs(self.singleData) do
		data.index = i
		local item = self.itemList[i]
		if not item then
			item = self:createItem(data)
			item:addTo(self.Node_single:getParent())
			item:setVisible(true)
			item:setPosition(0, -65 * i)
			self.itemList[i] = item
		end
		self:refreshItem(item, data)
		if not data.enough then
			isEnough = false
		end
	end
	if isEnough or self.needMithril ~= 0 then
		self.Button_ok:setTouchEnabled(true)
	else
		self.Button_ok:setTouchEnabled(false)
	end
	local ctype = combinationCtrl.COMBINATION_TYPE.COMBINATION
	local name = combinationCtrl:getSetName(ctype, self.setID)
	_ENV = data.enough
	data.enough.name = name
	self.Text_tips:setString(i18n("privilege_text_106", data.enough))
end
function combinationCostView:getSingleData(setID)
	_ENV, _ENV = nil, nil
	;(nil).resid = gIDDef.MITHRIL
	;(nil).rescount = 0
	_ENV, (nil)[1], (nil).resType = nil, nil, CONDITION_TYPE.RES
	;(nil).resid = gIDDef.GOLD
	;(nil).rescount = 0
	;(nil)[2], (nil).resType = nil, CONDITION_TYPE.RES
	local singleData
	local combData = combinationCtrl:getCombinationData(setID)
	dump(combData, "==combData==")
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
				singleData[2].resType = CONDITION_TYPE.TOOL
			else
				singleData[2].resid = gIDDef.GOLD
				singleData[2].rescount = gConstValue.LORD_RESET_SKILL_POINT
			end
		end
	end
	for i, v in ipairs(singleData) do
		if CONDITION_TYPE.RES == v.resType then
			v.enough, v.curRes = SoraDEnoughRes(v.resid, v.rescount)
		elseif CONDITION_TYPE.TOOL == v.resType then
			v.curRes = SoraDGetCtrl("backpackCtrl"):getItemCount(v.resid)
			v.enough = v.curRes >= v.rescount
		end
	end
	return singleData
end
function combinationCostView:createItem(data)
	local item = self.Node_single:clone()
	item.Button_jump = SoraDGetChildByName(item, "Button_jump")
	item.Button_jump:addTouchEventListener(handler(self, self.onClickJump))
	item.Button_jump:setTitleText(i18n("Secret_explore_text_14"))
	SoraDAutoSizeButtonText(item.Button_jump)
	item.Button_jump:setTag(data.index)
	item.Text_des = SoraDChangeTextToHtml(SoraDGetChildByName(item, "Text_des"))
	item.Image_icon = SoraDGetChildByName(item, "Image_icon")
	item.Image_state = SoraDGetChildByName(item, "Image_state")
	if CONDITION_TYPE.RES == data.resType then
		local resDesRead = include("resDesRead")
		item.Image_icon:loadTexture(resDesRead.getIcon(data.resid), ccui.TextureResType.plistType)
		item.Image_icon:setScale(40 / item.Image_icon:getContentSize().height)
	elseif CONDITION_TYPE.TOOL == data.resType then
		local itemDesRead = include("itemDesRead")
		item.Image_icon:loadTexture(itemDesRead.getIcon(data.resid), ccui.TextureResType.plistType)
		item.Image_icon:setScale(40 / item.Image_icon:getContentSize().height)
	end
	return item
end
function combinationCostView:refreshItem(item, data)
	local total = string.formatnumberthousands(data.rescount)
	local curCount = string.formatnumberthousands(data.curRes)
	_ENV = nil
	;(nil).total = total
	;(nil).cur = curCount
	local str = i18n("common_text_1641", nil)
	item.Text_des:setString(str)
	_ENV, _ENV = item.Text_des, item.Text_des.setString
	item.Text_des.setString.__default, item.Text_des.color = item.Text_des, "#C8C8C8"
	local styles = item.Text_des.setString
	if data.enough then
		SoraChangeSpriteImage(item.Image_state, "icon_yes.png")
		item.Button_jump:setVisible(false)
	else
		_ENV = item.Button_jump.setVisible
		styles.total, item.Button_jump.setVisible.color = item.Button_jump.setVisible, "#FE2E2E"
		SoraChangeSpriteImage(item.Image_state, "icon_no.png")
		item.Button_jump:setVisible(true)
	end
	_ENV = true
	;(true).total = total
	;(true).cur = curCount
	local str = i18n_html("common_text_1641", true, styles)
	item.Text_des:setString(str)
end
function combinationCostView:onClickUse(button, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if self:checkSetUnLock() and self:checkEnough(button, event) then
			combinationCtrl:reqCombinationUse(self.setID)
			self:close(button, event)
		end
	end
end
function combinationCostView:onClickJump(button, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local data = self.singleData[button:getTag()]
		if gIDDef.GOLD == data.resid then
			if GLOBAL_GAME_RECHARGE_MODE then
				uiManager:show("rechargeView")
			else
				SoraDCreatePanel("rechargeView"):show()
			end
			paymentManager.openRechargeView(gRechargeActiveFromEnum.ROAD09)
		elseif CONDITION_TYPE.RES == data.resType then
			_ENV, _ENV = data.resType, CONDITION_TYPE.RES
			data.resType.resid = data.resid
			CONDITION_TYPE.RES[1], data.resType.rescount = data.resType, data.rescount
			local needResList = CONDITION_TYPE.RES
			_ENV = nil
			;(nil).rid = data.resid
			;(nil).needResData = needResList
			uiManager:show("resourceBuyView", nil)
		end
	end
end
function combinationCostView:resUpdate(...)
	self:initData(self.setID)
end
function combinationCostView:checkSetUnLock(...)
	local _ENV, setIds
	if self.combData then
		_UPVALUE3_ = self.combData
		setIds, self.combData[1] = self.combData, self.combData.warGemSetId or 0
		setIds, self.combData[2] = self.combData, self.combData.lordSkillSetId or 0
		setIds, self.combData[3] = self.combData, self.combData.equipmentSetId or 0
	end
	for ctype, setID in ipairs(setIds) do
		if setID ~= 0 then
			local unlock = combinationCtrl:checkSetUnLock(ctype, setID)
			if not unlock then
				SoraDShowMsgTip(i18n("privilege_text_128"))
				return false
			end
		end
	end
	return true
end
function combinationCostView:checkEnough(button, event)
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
				self:close(button, event)
			end
			uiManager:show("buildCreateResBuy", math.max(0, data.rescount))
		end
		return false
	end
	return true
end
return combinationCostView
