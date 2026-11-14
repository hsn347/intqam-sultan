local nebulaExplorationCtrl = SoraDGetCtrl("nebulaExplorationCtrl")
local nebulaExplorationRead = include("nebulaExplorationRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local NebulaTreasureUIPanel = class("NebulaTreasureUIPanel", baseFguiPanel)
function NebulaTreasureUIPanel:ctor(...)
	self.super.ctor(self, ...)
	print("NebulaTreasureUIPanel:ctor", self.viewName)
end
function NebulaTreasureUIPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function NebulaTreasureUIPanel:onInit()
	self.itemID = include("constantRead").getConstValue("NEBULA_TREASURE_CONSUME_ITEM", 864801)
	print("=======NebulaTreasureUIPanel:onInit")
	self.fields.Com_title:initData(i18n("activity_name_9001434"), handler(self, self.onClickClose), handler(self, self.onHelpBack))
	self.fields.Label_time:initActivityTimeStyle(gActivityTimeActivityID.NEBULA_EXPLORATION_ACTIVITY)
	self.fields.Button_Award:setTitle(i18n("decrypt_text_03"))
	self.fields.Button_Award:addClickEventListener(handler(self, self.onClickPreAward))
	self.fields.Text_LevelTip:setString(i18n("nebula_treasure_hunt_10"))
	self.fields.Text_NextTips:setString(i18n("nebula_treasure_hunt_02"))
	self.fields.Text_AwardTips:setString(i18n("nebula_treasure_hunt_04"))
	self.fields.com_itemNum:initData(self.itemID)
	_ENV = i18n("nebula_treasure_hunt_04")
	i18n("nebula_treasure_hunt_04").num = ""
	self.fields.com_itemNum:setTitle(i18n("nebula_treasure_hunt_03", i18n("nebula_treasure_hunt_04")))
	self.fields.List_Box:setItemRenderer(handler(self, self.onItemRederer))
	self.transitions.t0:play()
	self.transitions.t1:play()
	self.fields.Usm_3:setBlendFunc(gl.SRC_ALPHA, gl.ONE_MINUS_SRC_ALPHA)
	self.fields.Usm_1:setPrepareCallback(function()
		self.fields.Usm_1:play(false)
		self = false
		;(false).frame = 59
		self.fields.Usm_1:getCriSprite():addFrameEventData(false)
		self.fields.Usm_1:getCriSprite():setFrameEventCallback(handler(self, self.showUsm2))
	end)
	self.fields.Usm_3:setPrepareCallback(function()
		self.fields.Usm_3:play(false)
		self = false
		;(false).frame = 29
		self.fields.Usm_3:getCriSprite():addFrameEventData(false)
		self.fields.Usm_3:getCriSprite():setFrameEventCallback(handler(self, self.showUsm4))
	end)
	self.fields.Usm_4:setPrepareCallback(function()
		print("Usm_4-触发")
		self.fields.Usm_4:play(false)
		_ENV = false
		;(false).frame = 44
		self.fields.Usm_4:getCriSprite():addFrameEventData(false)
		self.fields.Usm_4:getCriSprite():setFrameEventCallback(handler(self, self.endShowUsm))
	end)
end
function NebulaTreasureUIPanel:onShow()
	print("=======NebulaTreasureUIPanel:onShow")
	self.processConfig = nebulaExplorationRead:getProgressCfg()
	self:refreshLevel()
end
function NebulaTreasureUIPanel:refreshNebula()
	for i = 1, 10 do
		local rewardIndex = nebulaExplorationCtrl:doorIndex2RewardIndex(i)
		local award
		if rewardIndex then
			award = self.awardConfig[tonumber(rewardIndex)]
		end
		self.fields[string.format("Nebula_%d", i)]:initData(i, self.costNum, award, handler(self, self.onClickNebulaBack))
	end
end
function NebulaTreasureUIPanel:onClickPreAward()
	SoraDPlaySound()
	uiManager:show("NebulaTreasureReward")
end
function NebulaTreasureUIPanel:onClickAdd()
	_ENV = nil
	;(nil).itemID = self.itemID
	uiManager:show("CommonSourceGuide", nil)
end
function NebulaTreasureUIPanel:onClickNebulaBack(index)
	print(self.isRunAnimation, "self.isRunAnimation")
	if self.isRunAnimation then
		return
	end
	if self.costNum <= include("publicUtil").getCount(self.itemID) then
		self.isRunAnimation = true
		SoraDShowLoading()
		nebulaExplorationCtrl:reqNebuleExplorationExplore(index)
	else
		_ENV = nil
		;(nil).itemID = self.itemID
		uiManager:show("CommonSourceGuide", nil)
	end
end
function NebulaTreasureUIPanel:onHelpBack()
	SoraDPlaySound()
	_ENV = nil
	;(nil).content = i18n("nebula_treasure_hunt_01")
	uiManager:show("RuleView", nil)
end
function NebulaTreasureUIPanel:onItemRederer(index, object)
	object:initData(self.processConfig[index + 1])
end
function NebulaTreasureUIPanel:refreshBox()
	self.fields.List_Box:setNumItems(table.nums(self.processConfig))
end
function NebulaTreasureUIPanel:refreshLevel()
	if self.level == nebulaExplorationCtrl:getCurLevel() then
		return
	end
	self.level = nebulaExplorationCtrl:getCurLevel()
	self.fields.Text_Level:setString(self.level)
	local config = nebulaExplorationRead:getLevelConfig(self.level)
	if config == nil then
		return
	end
	_ENV = nil
	;(nil)[1] = "id"
	;(nil)[2] = "count"
	self.awardConfig = serviceFunctions.tableFormat(config.award, nil)
	self.costNum = config.consume
	self:refreshBox()
	self:refreshNebula()
end
function NebulaTreasureUIPanel:showAllItemEffect(newProgress)
	local _ENV, awardList
	for awardIndex, index in pairs(newProgress) do
		if self.awardConfig[tonumber(awardIndex)] then
			table.insert(awardList, self.awardConfig[tonumber(awardIndex)])
		end
		self.fields[string.format("Nebula_%d", index)]:showEffect(self.awardConfig[tonumber(awardIndex)])
	end
	_UPVALUE3_ = nil
	;(nil)[1] = ffa.delay(1)
	;(nil)[2] = ffa.callFunc(function()
		SoraDMailGainItems(awardList, true)
	end)
	;(nil)[3] = ffa.delay(0.5)
	;(nil)[4] = ffa.callFunc(function()
		self:nextLevel()
	end)
	;(nil)[5] = ffa.callFunc(function()
		self:nextLevel()
	end)
	;(nil)[6] = ffa.callFunc(function()
		self:nextLevel()
	end)
	self:runAction(ffa.seq(nil))
end
function NebulaTreasureUIPanel:nextLevel()
	if self.level == nebulaExplorationCtrl:getCurLevel() then
		self.isRunAnimation = false
		return
	end
	self.fields.Usm_3:play(false)
	self.transitions.t1:play()
end
function NebulaTreasureUIPanel:showUsm2(info)
	print("showUsm2", self.fields.Usm_1:getCriSprite():getTotalFrame(), info.frame)
	if info and info.frame and info.frame == self.fields.Usm_1:getCriSprite():getCurPlayFrame() then
		self.fields.Usm_2:play(true)
	end
end
function NebulaTreasureUIPanel:showUsm4(info)
	print("showUsm3", self.fields.Usm_3:getCriSprite():getTotalFrame(), info.frame)
	if info and info.frame and info.frame == self.fields.Usm_3:getCriSprite():getCurPlayFrame() then
		self.fields.Usm_4:play(false)
		self:refreshLevel()
	end
end
function NebulaTreasureUIPanel:endShowUsm(info)
	print("showUsm4", self.fields.Usm_4:getCriSprite():getTotalFrame(), info.frame)
	if info and info.frame and info.frame == self.fields.Usm_4:getCriSprite():getCurPlayFrame() then
		self.fields.Usm_4:setVisible(false)
		self.fields.Usm_3:setVisible(false)
		self.isRunAnimation = false
	end
end
return NebulaTreasureUIPanel
