local baseComponent = require("fgui.base.baseComponent")
local Com_MiningMeteorites_Task = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://MiningMeteorites/Com_MiningMeteorites_Task", Com_MiningMeteorites_Task)
local miningMeteoritesCtrl = SoraDGetCtrl("miningMeteoritesCtrl")
function Com_MiningMeteorites_Task:onInit()
	if not SoraDFIsRA() then
		self:fixChildrenPos(false, true)
	end
	self.fields.Button:addClickListener(handler(self, self.onButtonClick))
	self.fields.RewardList:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.Button:setString(i18n("treasure_crystal_btn_02"))
	self.fields.Text_Tip:setString(i18n("mining_meteorites_08"))
end
function Com_MiningMeteorites_Task:onShow()
end
function Com_MiningMeteorites_Task:initData(cfg, parentPanel)
	self.parentPanel = parentPanel
	self.cfg = cfg
	_UPVALUE2_ = nil
	;(nil)[1] = "id"
	;(nil)[2] = "count"
	self.rewards = serviceFunctions.tableFormat(self.cfg.meteoriteRewards, nil)
	self.fields.RewardList:setNumItems(#self.rewards)
	self.fields.Text_Name:setString(i18n(cfg.name))
	self.fields.Text_Des:setString(i18n("mining_meteorites_07") .. cfg.durability)
	self.controllers.c2:setSelectedIndex(cfg.type - 1)
	_ENV = i18n(cfg.name)
	i18n(cfg.name).num = miningMeteoritesCtrl:getCurStage(cfg.type)
	self.fields.Text_stage:setString(i18n("mining_meteorites_18", i18n(cfg.name)))
	local backpackCtrl = SoraDGetCtrl("backpackCtrl")
	local num = backpackCtrl:getItemCount(self.cfg.miningTools[1])
	self.fields.Button:setReddot(num > self.cfg.miningTools[2])
end
function Com_MiningMeteorites_Task:onItemRenderer(index, target)
	target:initData(self.rewards[index + 1].id, self.rewards[index + 1].count)
end
function Com_MiningMeteorites_Task:onButtonClick()
	SoraDPlaySound()
	self.parentPanel:setSelectedIndex(self.cfg.type)
end
return Com_MiningMeteorites_Task
