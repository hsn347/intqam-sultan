local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001680_MonsterPanel = class("Activity_9001680_MonsterPanel", baseFguiPanel)
local activity_9001680_Read = include("activity_9001680_Read")
local MAP_OBJ_TYPE = activity_9001680_Read.MAP_OBJ_TYPE
local publicRead = include("publicRead")
local activity_9001680_Ctrl = SoraDGetCtrl("activity_9001680_Ctrl")
local backpackltCtrl = include("backpackltCtrl")
function Activity_9001680_MonsterPanel:ctor(...)
	self.isLRU = true
	Activity_9001680_MonsterPanel.super.ctor(self, ...)
	print("Activity_9001680_MonsterPanel:ctor", self.viewName)
end
function Activity_9001680_MonsterPanel:onInit()
	print("=======Activity_9001680_MonsterPanel:onInit")
	self.fields.Button_attack:setTitle(i18n("common_text_008"))
	self.fields.Button_attack:addClickEventListener(handler(self, self.attackButtonCallFun))
	self.fields.Text_random:setString(i18n("common_text_488"))
	self.fields.Text_LvDes:setString("LEVEL")
	self.fields.rewardList:setItemRenderer(handler(self, self.onItemRender))
end
function Activity_9001680_MonsterPanel:endShow()
	print("=======Activity_9001680_MonsterPanel:endShow")
	self:updateView()
end
function Activity_9001680_MonsterPanel:updateView()
	self.cellX = self.param.x
	self.cellY = self.param.y
	self.objCfg = self.param.objCfg
	local level = 0
	local monsterType = 1
	if self.objCfg.type == MAP_OBJ_TYPE.BOSS then
		monsterType = 2
		level = activity_9001680_Ctrl:getBossLevel()
	else
		level = activity_9001680_Ctrl:getMonsterLevel()
	end
	local cfg = activity_9001680_Read.getMonster(monsterType, level)
	self.fields.Text_Lv:setString(level)
	self.fields.Text_Name:setString(cfg.name ~= "" and i18n(cfg.name) or "")
	self.fields.Image_boss:setURL(cfg.image)
	local classType = activity_9001680_Ctrl:getClassType()
	self.rewards, MAP_OBJ_TYPE = activity_9001680_Ctrl, activity_9001680_Ctrl
	local MAP_OBJ_TYPE, tempRewards = activity_9001680_Ctrl, activity_9001680_Ctrl
	local dropids = classType == 1 and cfg.dropid1 or cfg.dropid2
	for i, v in ipairs(dropids) do
		if not backpackltCtrl:getShowItems(v) then
			local MAP_OBJ_TYPE, rewards = backpackltCtrl:getShowItems(v), backpackltCtrl:getShowItems(v)
		end
		for i2, v2 in ipairs(rewards) do
			tempRewards[v2.id] = tempRewards[v2.id] or 0
			tempRewards[v2.id] = tempRewards[v2.id] + v2.count
		end
	end
	for k, v in pairs(tempRewards) do
		MAP_OBJ_TYPE = ipairs(rewards)
		ipairs(rewards).id = k
		ipairs(rewards).count = v
		table.insert(self.rewards, ipairs(rewards))
	end
	dump(self.rewards, "self.rewards")
	self.fields.rewardList:setNumItems(#self.rewards)
	self.fields.Text_warning:setVisible(self.objCfg.type ~= MAP_OBJ_TYPE.BOSS)
	local objCfg = activity_9001680_Read.getElement(1)
	local num = objCfg.minepick * (activity_9001680_Ctrl:getMonsterCount() + 1) - 1
	MAP_OBJ_TYPE = self.rewards
	self.rewards.num = num
	self.fields.Text_warning:setString(i18n("minecraft_text_21", self.rewards))
end
function Activity_9001680_MonsterPanel:onItemRender(index, item)
	local fields = fguiHelper.get_fields(item)
	local reward = self.rewards[index + 1]
	fields.item:initData(reward.id)
	fields.title:setString(publicRead.getName(reward.id))
end
function Activity_9001680_MonsterPanel:attackButtonCallFun(ref, type)
	SoraDPlaySound()
	local dispatchPanel = uiManager:show("WorldDispatchArmyView")
	_ENV = nil
	;(nil).activityID = gActivityTimeActivityID.NORMAL_ACTIVITY_9001680
	;(nil).dispatchCallback = handler(self, self.onDispatchCallback)
	dispatchPanel:initData(nil)
end
function Activity_9001680_MonsterPanel:onDispatchCallback(dispatchData)
	activity_9001680_Ctrl:reqGoldMinerPick(self.objCfg.index, self.cellX, self.cellY, false, dispatchData.armyList, dispatchData.heroInfo, dispatchData.armsInfo, dispatchData.divineBeastInfo)
	self:close()
	return true
end
return Activity_9001680_MonsterPanel
