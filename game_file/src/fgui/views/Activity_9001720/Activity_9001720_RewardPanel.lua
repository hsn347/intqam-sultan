local activity_9001720_Ctrl = SoraDGetCtrl("activity_9001720_Ctrl")
local activity_9001720_Read = include("activity_9001720_Read")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001720_RewardPanel = class("Activity_9001720_RewardPanel", baseFguiPanel)
function Activity_9001720_RewardPanel:ctor(...)
	Activity_9001720_RewardPanel.super.ctor(self, ...)
	print("Activity_9001720_RewardPanel:ctor", self.viewName)
	self.curLv = nil
end
function Activity_9001720_RewardPanel:onInit()
	print("=======Activity_9001720_RewardPanel:onInit")
	self.fields.Com_title:initData(i18n("lion_park_text23"), handler(self, self.onClickClose), handler(self, self.onClickHelp))
	self.fields.Com_title:setTitleWidthHeight(480, 40)
	self.fields.Text_des:setString(i18n("lion_park_text37") .. "\n" .. i18n("lion_park_text38"))
	self.fields.Text_des:setAlign(cc.TEXT_ALIGNMENT_LEFT)
	self.fields.Label_lv = self.fields.bar:getChild("Label_lv")
	local Text_lv = self.fields.Label_lv:getChild("Text_lv")
	Text_lv:setString("lv")
	self.fields.Text_Title2:setString(i18n("commandhall_text_56"))
	self.fields.Text_Title3:setString(i18n("datepalm_tree_text18"))
	self.fields.List:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.List:setVirtual()
	if not SoraDFIsRA() then
		self.fields.bar:fixChildrenPos()
	end
end
function Activity_9001720_RewardPanel:onShow()
	print("=======Activity_9001720_RewardPanel:onShow")
	self:updateProgressBar()
	self.config = activity_9001720_Read.getAllLevelConfig()
	local showNum = 20
	self.showLv = math.min(self.curLv, self.lvMax - showNum + 1)
	self.fields.List:setNumItems(showNum)
	if self.showLv < self.curLv then
		self.fields.List:scrollToView(self.curLv - self.showLv)
	end
end
function Activity_9001720_RewardPanel:onClickHelp(...)
	SoraDPlaySound()
	_ENV = nil
	;(nil).content = i18n("lion_park_text39")
	uiManager:show("RuleView", nil)
end
function Activity_9001720_RewardPanel:updateProgressBar(...)
	local growthValue = activity_9001720_Ctrl:getGrowthValue()
	local curLv = activity_9001720_Read.getLevelByExp(growthValue)
	self.fields.Label_lv:setString(curLv)
	local lvMax = activity_9001720_Read.getLevelMax()
	self.lvMax = lvMax
	if curLv == lvMax then
		self.fields.bar:setMax(1)
		self.fields.bar:setValue(1)
		self.fields.bar:getChild("title"):setString(i18n("hero_text_41"))
	else
		local nextLv = curLv + 1
		local curExp = activity_9001720_Read.getLevelConfigExp(curLv)
		local nextExp = activity_9001720_Read.getLevelConfigExp(nextLv)
		local expMax = nextExp - curExp
		self.fields.bar:setMax(expMax)
		self.fields.bar:setValue(growthValue - curExp)
	end
	if self.curLv ~= curLv then
		self.curLv = curLv
		local treeIcon = activity_9001720_Read.getTreeIcon(self.curLv, true)
		print("==treeIcon==", treeIcon)
		self.fields.Usm_tree:clearEffect()
		self.fields.Usm_tree:setEffectPath(treeIcon, true)
	end
end
function Activity_9001720_RewardPanel:onItemRenderer(index, obj)
	if not obj._fields then
		obj._fields = fguiHelper.get_fields(obj)
		obj._controllers = fguiHelper.get_controllers(obj)
	end
	local showLv = self.showLv + index
	local cfg = self.config[showLv]
	local _fields = obj._fields
	local _controllers = obj._controllers
	if cfg.level == self.curLv then
		_controllers.c1:setSelectedIndex(1)
	else
		_controllers.c1:setSelectedIndex(0)
	end
	_ENV = 0
	;(0).size = 22
	local lvStr = SoraDWrapHtmlTagByStyle(cfg.level, 0)
	_fields.Text_lv:setString("lv" .. "\n" .. lvStr)
	local nexLvCfg = self.config[showLv + 1]
	_UPVALUE2_ = showLv + 1
	if not nexLvCfg or not nexLvCfg.levelitem then
		_ENV = nexLvCfg.levelitem
	end
	if not cfg.dailyitem then
		_ENV = cfg.dailyitem
	end
	;(showLv + 1)[1] = nexLvCfg.levelitem
	local (showLv + 1)[2], rewards = cfg.dailyitem, showLv + 1
	for i, reward in ipairs(rewards) do
		local Com_item = _fields["Com_Item" .. i]
		local itemID, itemCount = reward[1], reward[2]
		if itemID then
			Com_item:setVisible(true)
			Com_item:initData(itemID, itemCount)
		else
			Com_item:setVisible(false)
		end
	end
end
return Activity_9001720_RewardPanel
