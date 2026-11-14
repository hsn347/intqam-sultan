local baseFguiPanel = require("fgui.base.baseFguiPanel")
local starTreasuryCtrl = SoraDGetCtrl("starTreasuryCtrl")
local starTreasuryRead = include("starTreasuryRead")
local buildDescribeRead = include("buildDescribeRead")
local magicLampCtrl = SoraDGetCtrl("magicLampCtrl")
local magicLampRead = include("magicLampRead")
local StarTreasuryMainPanel = class("StarTreasuryMainPanel", baseFguiPanel)
function StarTreasuryMainPanel:ctor(...)
	self.super.ctor(self, ...)
	self.debug = true
	print("StarTreasuryMainPanel:ctor", self.viewName)
end
function StarTreasuryMainPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function StarTreasuryMainPanel:onInit()
	print("=======StarTreasuryMainPanel:onInit")
	self.activityID = gActivityTimeActivityID.STAR_TREASURY_ACTIVITY
	self.fields.Com_title:initActivityData(self.activityID, handler(self, self.onClickClose), handler(self, self.onClickHelp))
	self.fields.list:setVirtual()
	self.fields.list:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.btn_box:setTitle(i18n("common_text_282"))
	self.fields.btn_box:addClickEventListener(handler(self, self.onBoxClick))
	self.fields.btn_left:addClickEventListener(handler(self, self.onPageClick), SoraDFIsRA() and 1 or -1)
	self.fields.btn_right:addClickEventListener(handler(self, self.onPageClick), SoraDFIsRA() and -1 or 1)
	self.fields.List_point:setNeedAutoFix(false)
	local sType = starTreasuryCtrl:getSType()
	self.questList = starTreasuryRead.getQuestList(sType)
	if not starTreasuryRead.getBoxList(sType) then
		_ENV = starTreasuryRead.getBoxList(sType)
	end
	self.boxCfgs = starTreasuryRead.getBoxList(sType)
	self.boxIdx = #self.boxCfgs
	for i, v in ipairs(self.boxCfgs) do
		local isRecord = starTreasuryCtrl:getIsBoxRecord(v.recharge)
		print(v.recharge, isRecord)
		if not isRecord then
			self.boxIdx = i
			break
		end
	end
	starTreasuryCtrl:sendReqInitDataMsg()
end
function StarTreasuryMainPanel:onShow()
	print("=======StarTreasuryMainPanel:onShow")
	self:updateView()
end
function StarTreasuryMainPanel:updateView()
	local sType = starTreasuryCtrl:getSType()
	self.questCfgs, starTreasuryCtrl = starTreasuryCtrl, starTreasuryCtrl
	for i, v in ipairs(self.questList) do
		local starTreasuryCtrl, questData
		questData.taskID = v.index
		questData.award = clone(v.reward)
		local needBuyBoxType = 0
		for i2, v2 in ipairs(v.boxType) do
			local boxCfg = starTreasuryRead.getBoxCfgByType(v2.type, sType)
			if boxCfg then
				local isUnLock = starTreasuryCtrl:getIsBoxRecord(boxCfg.recharge)
				starTreasuryCtrl = nil
				;(nil).id = boxCfg.itemId
				;(nil).count = v2.count
				;(nil).lock = isUnLock and 0 or 1
				table.insert(questData.award, nil)
				if not isUnLock and needBuyBoxType == 0 then
					needBuyBoxType = v2.type
				end
			end
		end
		local qType = v.lv[1]
		if qType == 1 then
			questData.count = SoraDGetBuildStarLv(v.lv[2])
			starTreasuryCtrl = nil
			;(nil).lv = v.lv[3]
			local lvStr = i18n("common_text_100", nil)
			if v.lv[2] == BUILDID.STAR_BRAVE_STATUE then
				local cityltCtrl = include("cityltCtrl")
				local info = cityltCtrl.getQualityByStarLv(v.lv[3])
				local qualityName = cityltCtrl.getStatueBraveQualityName(info.quality)
				starTreasuryCtrl = table.insert
				table.insert.quality = qualityName
				table.insert.lv = info.level
				_ENV, lvStr = i18n("%{quality}Lv.%{lv}", table.insert), i18n("%{quality}Lv.%{lv}", table.insert)
				i18n("%{quality}Lv.%{lv}", table.insert).lv = lvStr
				questData.taskDes, i18n("%{quality}Lv.%{lv}", table.insert)[1] = i18n("%{quality}Lv.%{lv}", table.insert), "star_treasury_9"
			elseif v.lv[2] == BUILDID.CASTLE then
				_ENV = v.lv[2]
				v.lv[2].num = "Lv." .. v.lv[3]
				questData.taskDes, v.lv[2][1] = v.lv[2], "achievement_des_56"
			end
		elseif qType == 2 then
			questData.count = magicLampCtrl:getJinnLv(v.lv[2])
			local jinnName = magicLampRead.getJinnName(v.lv[2])
			_ENV = v.lv[2]
			v.lv[2].name = jinnName
			v.lv[2].lv = v.lv[3]
			questData.taskDes, v.lv[2][1] = v.lv[2], "star_treasury_10"
		end
		questData.total = v.lv[3]
		questData.str = ""
		questData.guideId = v.lv
		questData.needBuyBoxType = needBuyBoxType
		local taskStatus = starTreasuryCtrl:getTaskStatus(v.index)
		if taskStatus == gStarTreasuryStatus.ALREADY_RECEIVE then
			questData.taskStatus = gBtnTargetStatusDef.GOT
		elseif questData.total <= questData.count then
			questData.taskStatus = gBtnTargetStatusDef.GET
		else
			questData.taskStatus = gBtnTargetStatusDef.GO
		end
		questData.order = questData.taskStatus
		if questData.taskStatus == gBtnTargetStatusDef.GOT and needBuyBoxType ~= 0 then
			questData.order = gBtnTargetStatusDef.GO
		end
		table.insert(self.questCfgs, questData)
	end
	table.sort(self.questCfgs, function(a, b)
		if a.order == b.order then
			return a.taskID < b.taskID
		else
			return a.order < b.order
		end
	end)
	self.fields.list:setNumItems(#self.questCfgs)
	self:updateBox()
end
function StarTreasuryMainPanel:updateBox()
	self.curBoxCfg = self.boxCfgs[self.boxIdx]
	self.preBoxCfg = self.boxCfgs[self.boxIdx - 1]
	if not self.curBoxCfg then
		return
	end
	local icon = self.curBoxCfg.icon == "" and "icon_ghbk_xz_01.png" or self.curBoxCfg.icon
	self.fields.boxIcon:setURL(icon)
	self.fields.Usm_2:setBlendFunc(gl.ONE, gl.ONE)
	self.fields.Usm_2:clearEffect()
	self.fields.Usm_2:stopAllActions()
	self.fields.Usm_2:setAlpha(0)
	self.fields.Usm_2:runAction(ffa.fadeIn(0.3))
	self.fields.Usm_2:setEffectPath("G_ghbk_baoxiang" .. self.boxIdx .. ".usm")
	local isRecord = starTreasuryCtrl:getIsBoxRecord(self.curBoxCfg.recharge)
	local isPreRecord = self.preBoxCfg == nil and true or starTreasuryCtrl:getIsBoxRecord(self.preBoxCfg.recharge)
	local btnTitle = isRecord and i18n("common_text_3833") or isPreRecord and i18n("common_text_282") or i18n("common_text_829")
	self.fields.btn_box:setTitle(btnTitle)
	self.fields.btn_box:setBright(not isRecord)
	self.fields.List_point:setNumItems(#self.boxCfgs)
	local isAddEnable = self.boxCfgs[self.boxIdx + 1] ~= nil
	local isMinEnable = self.boxCfgs[self.boxIdx - 1] ~= nil
	if SoraDFIsRA() then
		self.fields.btn_left:setVisible(isAddEnable)
		self.fields.btn_right:setVisible(isMinEnable)
		self.fields.List_point:setSelectedIndex(#self.boxCfgs - self.boxIdx)
	else
		self.fields.btn_left:setVisible(isMinEnable)
		self.fields.btn_right:setVisible(isAddEnable)
		self.fields.List_point:setSelectedIndex(self.boxIdx - 1)
	end
end
function StarTreasuryMainPanel:onBoxClick()
	SoraDPlaySound()
	_ENV = nil
	;(nil).boxIdx = self.boxIdx
	uiManager:show("StarTreasuryBox", nil):setOwnerKey(self)
end
function StarTreasuryMainPanel:onItemRenderer(index, object)
	local config = self.questCfgs[index + 1]
	object:initData(config)
	object:setHandler(handler(self, self.onClickGetAward), handler(self, self.onGoClick), handler(self, self.onBuyClick))
end
function StarTreasuryMainPanel:onClickGetAward(taskID)
	starTreasuryCtrl:sendReceive(taskID)
end
function StarTreasuryMainPanel:onGoClick(guideId)
	SoraDRemoveAllPanelFromManager()
	local mildGuideManager = gModuleMgr.sharedMgr("mildGuideManager")
	local qType = guideId[1]
	dump(guideId, "StarTreasuryMainPanel:onGoCl")
	if qType == 1 then
		_ENV = "StarTreasuryMainPanel:onGoCl"
		;("StarTreasuryMainPanel:onGoCl").bid = guideId[2]
		mildGuideManager:starToUpgradeStar("StarTreasuryMainPanel:onGoCl")
	elseif qType == 2 then
		_ENV = "StarTreasuryMainPanel:onGoCl"
		mildGuideManager:starToUpgradeMagicLamp("StarTreasuryMainPanel:onGoCl")
	end
end
function StarTreasuryMainPanel:onBuyClick(boxType)
	for i, v in ipairs(self.boxCfgs) do
		if v.type == boxType then
			_ENV = nil
			;(nil).boxIdx = i
			uiManager:show("StarTreasuryBox", nil):setOwnerKey(self)
			break
		end
	end
end
function StarTreasuryMainPanel:onPageClick(sender, params)
	SoraDPlaySound()
	local curIndex = self.boxIdx + params
	if self.boxCfgs[curIndex] == nil then
		if 0 < params then
			curIndex = #self.boxCfgs
		else
			curIndex = 1
		end
	end
	self.boxIdx = curIndex
	self:updateBox()
end
function StarTreasuryMainPanel:onClickHelp()
	SoraDPlaySound()
	_ENV = nil
	;(nil).content = i18n("star_treasury_1")
	uiManager:show("RuleView", nil):setOwnerKey(self)
end
return StarTreasuryMainPanel
