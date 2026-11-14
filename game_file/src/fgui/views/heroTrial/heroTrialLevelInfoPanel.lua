local htPointMgr = include("htPointMgr")
local heroTrialCommon = include("heroTrialCommon")
local heroTrialltCtrl = include("heroTrialltCtrl")
local htBattleMgr = include("htBattleMgr")
local publicRead = include("publicRead")
local heroTrialCtrl = SoraDGetCtrl("heroTrialCtrl")
local lordInfoCtrl = SoraDGetCtrl("lordInfoCtrl")
local armyCtrl = SoraDGetCtrl("armyCtrl")
local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local heroTrialLevelInfoPanel = class("heroTrialLevelInfoPanel", baseFguiPanel)
function heroTrialLevelInfoPanel:ctor(...)
	self.isLRU = true
	heroTrialLevelInfoPanel.super.ctor(self, ...)
	print("heroTrialLevelInfoPanel:ctor", self.viewName)
end
function heroTrialLevelInfoPanel:onInit()
	print("=======heroTrialLevelInfoPanel:onInit")
	_UPVALUE9_ = print
	_UPVALUE4_, self.normalTalk, print[1] = print, print, i18n("common_text_1727")
	_UPVALUE4_, self.normalTalk, print[2] = print, print, i18n("common_text_1728")
	_UPVALUE4_, self.normalTalk, print[3] = print, print, i18n("common_text_1729")
	_UPVALUE4_, self.normalTalk, print[4] = print, print, i18n("common_text_1730")
	_UPVALUE4_, self.normalTalk, print[5] = print, print, i18n("common_text_1731")
	_UPVALUE4_, self.normalTalk, print[6] = print, print, i18n("common_text_1732")
	_UPVALUE4_, self.normalTalk, print[7] = print, print, i18n("common_text_1733")
	_UPVALUE4_, self.normalTalk, print[8] = print, print, i18n("common_text_1734")
	_UPVALUE4_, self.normalTalk, print[9] = print, print, i18n("common_text_1735")
	_UPVALUE4_, self.normalTalk, print[10] = print, print, i18n("common_text_1736")
	_UPVALUE4_, self.normalTalk, print[11] = print, print, i18n("common_text_1736")
	_ENV, _ENV, self.bossTalk, print[1] = i18n("common_text_1737"), print, print, i18n("common_text_1737")
	_ENV, _ENV, self.bossTalk, print[2] = i18n("common_text_1737"), print, print, i18n("common_text_1738")
	_ENV, _ENV, self.bossTalk, print[3] = i18n("common_text_1737"), print, print, i18n("common_text_1739")
	_ENV, _ENV, self.bossTalk, print[4] = i18n("common_text_1737"), print, print, i18n("common_text_1740")
	_ENV, _ENV, self.bossTalk, print[5] = i18n("common_text_1737"), print, print, i18n("common_text_1741")
	_ENV, _ENV, self.bossTalk, print[6] = i18n("common_text_1737"), print, print, i18n("common_text_1741")
	_ENV, _ENV, self.bossTalk, print[7] = i18n("common_text_1737"), print, print, i18n("common_text_1741")
	_ENV, _ENV, self.bossTalk, print[8] = i18n("common_text_1737"), print, print, i18n("common_text_1741")
	_ENV, _ENV, self.bossTalk, print[9] = i18n("common_text_1737"), print, print, i18n("common_text_1741")
	_ENV, _ENV, self.bossTalk, print[10] = i18n("common_text_1737"), print, print, i18n("common_text_1741")
	_ENV, _ENV, self.bossTalk, print[11] = i18n("common_text_1737"), print, print, i18n("common_text_1741")
	i18n("common_text_1737").name = i18n("common_text_1823")
	_ENV, print[1403008], i18n("common_text_1737").icon = i18n("common_text_1737"), i18n("common_text_1737"), "2991.png"
	i18n("common_text_1737").name = i18n("common_text_1824")
	_ENV, print[1403009], i18n("common_text_1737").icon = i18n("common_text_1737"), i18n("common_text_1737"), "2990.png"
	i18n("common_text_1737").name = i18n("common_text_3521")
	self.customItem, print[1407128], i18n("common_text_1737").icon = print, i18n("common_text_1737"), "2990.png"
	self.fields.Text_monterTalk:setAlign(2)
	self.fields.rewardTip:setString(i18n("common_text_488"))
	self.fields.Button_attack:setString(i18n("common_text_1774"))
	self.fields.Button_attack:addClickListener(handler(self, self.onBegin))
	self.fields.Button_autoAttack:setString(i18n("common_text_1766"))
	self.fields.Button_autoAttack:addClickListener(handler(self, self.onAuto))
	self.fields.Button_detail:setString(i18n("common_text_1773"))
	self.fields.Button_detail:addClickListener(handler(self, self.onDetail))
	self.fields.List:setItemRenderer(handler(self, self.onItemRenderer))
end
function heroTrialLevelInfoPanel:onItemRenderer(index, obj)
	local data = self.rewardList[index + 1]
	if self.customItem[data.id] then
		obj:getChild("item"):initData(data.id)
		obj:getChild("item"):setIcon(self.customItem[data.id].icon)
		obj:getChild("title"):setString(self.customItem[data.id].name)
	else
		obj:getChild("item"):initData(data.id)
		obj:getChild("title"):setString(publicRead.getName(data.id))
	end
end
function heroTrialLevelInfoPanel:endShow()
	print("=======heroTrialLevelInfoPanel:endShow")
	self.canAttack = self.param.canAttack
	self.enemyData = self.param.enemyData
	self.levelId = self.param.levelId
	self.bustName = self.param.bustName
	self.beginTile = self.param.beginTile
	self.endTile = self.param.endTile
	self.mapId = self.param.mapId
	self:initData()
	self:updateAutoVip()
end
function heroTrialLevelInfoPanel:initData()
	self.fields.Button_attack:setVisible(self.canAttack)
	self.fields.Button_autoAttack:setVisible(self.canAttack)
	self.rewardList = heroTrialltCtrl.getRewardOfStage(self.levelId)
	self.fields.List:setNumItems(math.min(5, #self.rewardList))
	self.fields.Image_monster:setSpriteFrame(self.bustName)
	local num = heroTrialCommon.convertLevelToNum(self.levelId)
	heroTrialltCtrl = math.min(5, #self.rewardList)
	math.min(5, #self.rewardList).level = num
	self.fields.Text_monterName:setString(i18n("common_text_1769", math.min(5, #self.rewardList)))
	if num % 10 == 0 then
		self.fields.Text_monterTalk:setString(self.bossTalk[math.random(#self.bossTalk)])
	else
		self.fields.Text_monterTalk:setString(self.normalTalk[math.random(#self.normalTalk)])
	end
end
function heroTrialLevelInfoPanel:handleRsp(target, data)
	if data.rsp.subcmd == gCmd.REQ_HT_OPEN_TRIAL and data.rsp.data.mapID == self.mapId and self.canOpenTrial and data.rsp.err == gErrDef.Err_None then
		self:openDispatch()
	end
end
function heroTrialLevelInfoPanel:updateAutoVip()
	self.isVipGet = true
	local vipDetail = lordInfoCtrl:getVipDetails()
	local vip_limited = IsArClient and _G.VIP_LV5_LIMITED or _G.VIP_LV4_LIMITED
	if not vipDetail.isActivated or not (vip_limited <= vipDetail.level) then
		self.isVipGet = false
	end
end
function heroTrialLevelInfoPanel:checkOpenTrial()
	local title = i18n("common_text_1742")
	if htBattleMgr.trialStatus then
		title = i18n("common_text_1836")
	end
	SoraDShowMsgBox(title, i18n("common_text_054"), i18n("common_text_185"), function(type, sender)
		if type == MSGBOX_CALLBACK_YES then
			local armyIDList = armyCtrl:getArmyIDList()
			local count = 0
			for i, v in ipairs(armyIDList) do
				count = count + armyCtrl:getArmyCount(v, ARMY_OPTYPE.ALL_ARMY)
			end
			if 0 < count then
				heroTrialCtrl:openTrial(self.mapId)
				self.canOpenTrial = true
			else
				SoraDShowMsgBox(i18n("common_text_1744"), i18n("common_text_054"))
			end
		end
	end)
end
function heroTrialLevelInfoPanel:onBegin()
	SoraDPlaySound()
	self.isAuto = false
	self:checkDispatch()
end
function heroTrialLevelInfoPanel:checkDispatch()
	if not heroTrialCommon.isTrialStarted(self.mapId) then
		if htPointMgr.isPointEnough(heroTrialltCtrl.getCostPointOfTrial()) then
			self:checkOpenTrial()
		else
			local itemId = 800301
			local itemCount = backpackCtrl:getItemCount(itemId)
			if 0 < itemCount then
				heroTrialCommon, heroTrialCommon = heroTrialltCtrl.getCostPointOfTrial()
				heroTrialltCtrl.getCostPointOfTrial().id = itemId
				heroTrialltCtrl.getCostPointOfTrial().itemData, heroTrialltCtrl.getCostPointOfTrial().count = heroTrialltCtrl.getCostPointOfTrial()
				heroTrialltCtrl.getCostPointOfTrial().msg = i18n("common_text_3420")
				uiManager:show("newItemSingleUse", heroTrialltCtrl.getCostPointOfTrial())
			else
				heroTrialCommon = heroTrialltCtrl.getCostPointOfTrial()
				heroTrialltCtrl.getCostPointOfTrial().point = HEROTRIAL_COST_POINTS
				SoraDShowMsgTip(i18n("common_text_1743", heroTrialltCtrl.getCostPointOfTrial()))
			end
		end
	else
		self:openDispatch()
	end
end
function heroTrialLevelInfoPanel:openDispatch()
	_ENV = nil
	;(nil).isAuto = self.isAuto
	;(nil).beginTile = self.beginTile
	;(nil).endTile = self.endTile
	uiManager:show("heroTrialDispatchArmy", nil)
	self:close()
end
function heroTrialLevelInfoPanel:onAuto()
	SoraDPlaySound()
	if self.isVipGet then
		self.isAuto = true
		self:checkDispatch()
	else
		_ENV = nil
		;(nil).content = i18n("common_text_1837")
		;(nil).confirmString = i18n("common_text_449")
		;(nil).cancelString = i18n("common_text_1838")
		;(nil).confirmFunc = function()
			uiManager:show("vipCenterView")
		end
		;(nil).cancelFunc = function()
			self.isAuto = false
			self:checkDispatch()
		end
		uiManager:show("MessageBox", nil)
	end
end
function heroTrialLevelInfoPanel:onDetail()
	SoraDPlaySound()
	_ENV = nil
	;(nil).armyList = self.enemyData
	uiManager:show("heroTrialLevelDetail", nil)
end
function heroTrialLevelInfoPanel:gameGuide_getTarget(itemName, parameters)
	return self.fields[itemName]
end
return heroTrialLevelInfoPanel
