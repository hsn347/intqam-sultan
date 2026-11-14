local baseFguiPanel = require("fgui.base.baseFguiPanel")
local MiningMeteoritesPanel = class("MiningMeteoritesPanel", baseFguiPanel)
local publicRead = include("publicRead")
local miningMeteoritesCtrl = SoraDGetCtrl("miningMeteoritesCtrl")
local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
local miningMeteoritesRead = include("miningMeteoritesRead")
_ENV = "miningMeteoritesRead"
;("miningMeteoritesRead")[1] = "frame_blue_%02d.png"
local ("miningMeteoritesRead")[2], icons = "frame_red_%02d.png", "miningMeteoritesRead"
function MiningMeteoritesPanel:ctor(...)
	self.super.ctor(self, ...)
	self.isHideCurrentSceneView = true
	self.debug = true
	print("MiningMeteoritesPanel:ctor", self.viewName)
end
function MiningMeteoritesPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function MiningMeteoritesPanel:onInit()
	if not SoraDFIsRA() then
		self.view:fixChildrenPos(false, true)
	end
	print("=======MiningMeteoritesPanel:onInit")
	self.fields.Com_title:initData(i18n("activity_name_9001435"), handler(self, self.onClickClose), handler(self, self.onClickHelp))
	self.fields.text_tips:setString(i18n("mining_meteorites_05"))
	self.fields.scroll:setItemRenderer(handler(self, self.onQeustsRender))
	self.txt_time = SoraDCreateTimerLabel(self, self.fields.txt_time)
	self.txt_time:setTimeLast(function(strTime)
		_ENV = nil
		_ENV, _ENV, (nil).time = nil, nil, strTime
		;(nil).time, (nil).color = nil, "#5AB440"
		return i18n_html("common_text_607", nil, nil)
	end)
	local timer = activityShowCtrl:getTimeInfoByID(gActivityTimeActivityID.MINING_METEORITES_ACTIVITY)
	if timer then
		local leftTime = timer.timerNode.timer:getRemainTime()
		self.txt_time:setString(SoraDConvertSecondToString(leftTime))
		self.txt_time:beginTime(leftTime)
	end
	self.fields.Button_awardPreview:addClickEventListener(handler(self, self.onAwardClick))
	self.fields.Button_awardPreview:setTitle(i18n("decrypt_text_03"))
	self.fields.Button_awardPreview2:addClickEventListener(handler(self, self.onAwardClick))
	self.fields.Button_awardPreview2:setTitle(i18n("decrypt_text_03"))
	self.fields.Button_bakeOne:addClickEventListener(handler(self, self.onTakeClick), 1)
	self.fields.Button_bakeTen:addClickEventListener(handler(self, self.onTakeClick), 10)
	_ENV = self.onTakeClick
	self.onTakeClick.num = 1
	self.fields.Button_bakeOne:setTitle(i18n("mining_meteorites_12", self.onTakeClick))
	_ENV = i18n("mining_meteorites_12", self.onTakeClick)
	i18n("mining_meteorites_12", self.onTakeClick).num = 10
	self.fields.Button_bakeTen:setTitle(i18n("mining_meteorites_12", i18n("mining_meteorites_12", self.onTakeClick)))
	self.fields.btn_left:addClickEventListener(handler(self, self.onPageClick), SoraDFIsRA() and -1 or 1)
	self.fields.btn_right:addClickEventListener(handler(self, self.onPageClick), SoraDFIsRA() and 1 or -1)
	self.fields.Button_add:addClickEventListener(handler(self, self.onAddClick))
	self.fields.text_tip:setString(i18n("mining_meteorites_10"))
	self.fields.text_title:setString(i18n("mining_meteorites_09"))
	miningMeteoritesCtrl:sendReqInitDataMsg()
	self.curIndex = 0
end
function MiningMeteoritesPanel:onShow()
	print("=======MiningMeteoritesPanel:onShow")
	self:updateView()
end
function MiningMeteoritesPanel:setSelectedIndex(index)
	self.curIndex = index
	self:updateView()
	self.oldCurIndex = index
end
function MiningMeteoritesPanel:updateView()
	self.cfgs = miningMeteoritesRead.getConfig(miningMeteoritesCtrl:getGroupData())
	if self.oldCurIndex ~= nil and self.oldCurIndex ~= self.curIndex then
		self.mainSp = nil
		self.oldIconIndex = nil
		self.fields.Effect_1:clearEffect()
	end
	self.controllers.c1:setSelectedIndex(self.curIndex == 0 and 0 or 1)
	if self.curIndex == 0 then
		self:updateScroll()
	else
		self:updateMsg()
	end
end
function MiningMeteoritesPanel:updateScroll()
	self.fields.scroll:setNumItems(#self.cfgs)
end
function MiningMeteoritesPanel:updateMsg(isMax)
	local cfg = self.cfgs[self.curIndex]
	self.cfg = cfg
	self.curType = cfg.type
	self.itemID = self.cfg.miningTools[1]
	self.curScore = miningMeteoritesCtrl:getCurScore(self.curType)
	self.fields.progress:setMax(cfg.durability)
	self.fields.progress:setValue(isMax and cfg.durability or self.curScore)
	self.fields.text_name:setString(i18n(cfg.name))
	miningMeteoritesCtrl = i18n(cfg.name)
	i18n(cfg.name).num = miningMeteoritesCtrl:getCurStage(self.curType)
	self.fields.text_show_stage:setString(i18n("mining_meteorites_18", i18n(cfg.name)))
	self.fields.Image_cost:setURL(publicRead.getIcon(self.itemID))
	self:updateCost()
	if not isMax then
		self:showChangeAni(cfg)
	end
end
function MiningMeteoritesPanel:updateCost()
	if self.cfg == nil then
		return
	end
	local backpackCtrl = SoraDGetCtrl("backpackCtrl")
	self.itemNum = backpackCtrl:getItemCount(self.itemID)
	self.fields.Text_num:setString(self.itemNum)
	self.fields.Button_bakeOne:setCost(self.itemID, self.cfg.miningTools[2], true)
	self.fields.Button_bakeTen:setCost(self.itemID, self.cfg.miningTools[2] * 10, true)
end
function MiningMeteoritesPanel:showChangeAni(cfg)
	local iconURL = icons[cfg.type]
	local percent = self.curScore / cfg.durability * 100
	local iconIndex = 1
	local usmName = ""
	local addY = 0
	if 70 <= percent then
		iconIndex = 3
		usmName = "G_kaicaiyunshibj_03.usm"
		addY = -40
	elseif 30 <= percent then
		usmName = "G_kaicaiyunshibj_02.usm"
		iconIndex = 2
	elseif percent < 30 then
		usmName = "G_kaicaiyunshibj_02.usm"
	end
	if self.mainSp == nil then
		self.fields.Effect_1:setEffectPath("Node_Stone" .. cfg.type + 1)
		self.mainSp = SoraDGetChildByName(self.fields.Effect_1.effect, "mainSp")
		self.mainSp:setLocalZOrder(1)
	end
	self.mainSp:setSpriteFrame(string.format(iconURL, iconIndex))
	if self.oldIconIndex ~= nil and self.oldIconIndex ~= iconIndex then
		usmName = "G_kaicaiyunshidj_01.usm," .. usmName
		local cloneNode = self.mainSp:clone()
		cloneNode:setSpriteFrame(string.format(iconURL, iconIndex - 1))
		cloneNode:addTo(self.mainSp:getParent(), -1)
		self.mainSp:setOpacity(0)
		self.mainSp:runAction(cca.fadeIn(0.8))
		cloneNode:runAction(cca.seq(cca.fadeOut(0.8), cca.callFunc(function()
			cloneNode:removeFromParent()
		end)))
		self.fields.Usm_2:clearEffect()
		self.fields.Usm_2:setMaxChunkSize(44896)
	else
	end
	self.fields.Usm_2:setPositionY(self.fields.Usm_1:getPositionY() + addY)
	self.fields.Usm_2:setBlendFunc(gl.ONE, gl.SRC_ALPHA)
	self.fields.Usm_2:setEffectPath(usmName, true)
	self.oldIconIndex = iconIndex
end
function MiningMeteoritesPanel:onQeustsRender(index, obj)
	local tmpIdx = 0
	obj:initData(self.cfgs[index + 1], self)
end
function MiningMeteoritesPanel:onTakeClick(sender, params)
	SoraDPlaySound()
	local isFree = false
	if not isFree and self.itemNum < params * self.cfg.miningTools[2] or params == 10 and self.itemNum < params * self.cfg.miningTools[2] then
		_ENV = nil
		_ENV = nil
		;(nil).item = publicRead.getName(self.itemID)
		;(nil).content = i18n("common_text_1806", nil)
		;(nil).confirmFunc = function()
			self:onAddClick()
		end
		;(nil).cancel = true
		uiManager:show("MessageBox", nil)
		return
	end
	miningMeteoritesCtrl:sendMining(self.curType, params)
end
function MiningMeteoritesPanel:onAddClick()
	SoraDPlaySound()
	_ENV = nil
	;(nil).itemID = self.itemID
	uiManager:show("CommonSourceGuide", nil)
end
function MiningMeteoritesPanel:showReward(rewards)
	local _ENV, tmpRewards
	for k, v in pairs(rewards.reward) do
		for k2, v2 in pairs(v.reward) do
			v2.rate = v.ratio
			table.insert(tmpRewards, v2)
		end
	end
	if #tmpRewards == 1 then
		SoraDMailGainItems(tmpRewards, true)
	else
		SoraDMailGainItems(tmpRewards, true)
	end
	if rewards.exReward then
		dump(rewards.exReward, "rewards.exReward")
		self:updateMsg(true)
		_UPVALUE2_ = true
		;(true)[1] = "id"
		;(true)[2] = "count"
		local rewards2 = serviceFunctions.tableFormat(self.cfg.meteoriteRewards, true)
		_ENV = "count"
		;("count").rewards = rewards2
		;("count").getRewards = rewards.exReward
		;("count").cfg = self.cfg
		;("count").closeCallback = handler(self, self.updateView)
		uiManager:show("MiningMeteoritesReward", "count")
	else
		self:updateView()
	end
end
function MiningMeteoritesPanel:onAwardClick()
	SoraDPlaySound()
	_ENV = nil
	;(nil).type = self.curIndex
	uiManager:show("MiningMeteoritesRewradPreview", nil)
end
function MiningMeteoritesPanel:onPageClick(sender, params)
	local curIndex = self.curIndex + params
	print("params", params)
	if self.cfgs[curIndex] == nil then
		if 0 < params then
			curIndex = 1
		else
			curIndex = #self.cfgs
		end
	end
	self:setSelectedIndex(curIndex)
end
function MiningMeteoritesPanel:onClickClose()
	if self.curIndex ~= 0 then
		self:setSelectedIndex(0)
		return
	end
	self:close()
end
function MiningMeteoritesPanel:onClickHelp()
	SoraDPlaySound()
	_ENV = nil
	;(nil).content = i18n("mining_meteorites_04")
	uiManager:show("RuleView", nil):setOwnerKey(self)
end
return MiningMeteoritesPanel
