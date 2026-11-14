local mirajChallengeCtrl = SoraDGetCtrl("mirajChallengeCtrl")
local allianceMgr = SoraDGetCtrl("allianceMgr")
local baseComponent = require("fgui.base.baseComponent")
local Com_reward = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://AlmirajChange/Com_reward", Com_reward)
function Com_reward:onInit()
	self.activityID = gActivityTimeActivityID.MIRAJ_CHALLENGE_ACTIVITY
	self.fields.List:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.Btn_reward:addClickListener(handler(self, self.onRewardClick))
	self.fields.Text_claimed:setString(i18n("common_text_1892"))
	self:fixChildrenPos()
end
function Com_reward:onShow()
end
function Com_reward:onItemRenderer(index, obj)
	local data = self.reward[index + 1]
	obj:initData(data.id, data.count)
end
function Com_reward:initData(data)
	self.isCanReward = false
	self.data = data
	_ENV = nil
	;(nil).num = fguiHelper.getColorString("#FFC864", data.bossNum)
	self.fields.Text_des:setString(i18n("almirajChange_text07", nil))
	local killCount = mirajChallengeCtrl:getKilledCount()
	local killStr = killCount
	if killCount >= data.bossNum then
		killStr = fguiHelper.getColorString("#FFEBB9", killCount)
	else
		killStr = fguiHelper.getColorString("#FF0000", killCount)
	end
	_ENV = i18n("almirajChange_text07", nil)
	i18n("almirajChange_text07", nil).var = killStr
	i18n("almirajChange_text07", nil).var1 = data.bossNum
	self.fields.Text_progress:setString(i18n("alliance_stronghold_text_070", i18n("almirajChange_text07", nil)))
	_UPVALUE2_ = i18n("alliance_stronghold_text_070", i18n("almirajChange_text07", nil))
	i18n("alliance_stronghold_text_070", i18n("almirajChange_text07", nil))[1] = "id"
	i18n("alliance_stronghold_text_070", i18n("almirajChange_text07", nil))[2] = "count"
	self.reward = serviceFunctions.tableFormat(data.reward, i18n("alliance_stronghold_text_070", i18n("almirajChange_text07", nil)))
	self.fields.List:setNumItems(#self.reward)
	local isClaimed = mirajChallengeCtrl:checkBoxStatus(data.rank)
	if isClaimed then
		self.controllers.c1:setSelectedIndex(2)
	else
		self.fields.Btn_reward:setString(i18n("common_text_1146"))
		if killCount >= data.bossNum then
			self.controllers.c1:setSelectedIndex(1)
			self.fields.Btn_reward:setEnabled(true)
			self.fields.Btn_reward:setGrayed(false)
			self.isCanReward = true
		else
			self.controllers.c1:setSelectedIndex(0)
			self.fields.Btn_reward:setEnabled(false)
			self.fields.Btn_reward:setGrayed(true)
		end
	end
end
function Com_reward:onRewardClick()
	SoraDPlaySound()
	if self.isCanReward then
		if allianceMgr:hasJoinAlliance() then
			mirajChallengeCtrl:sendOpenBox(self.data.rank)
		else
			SoraDShowMsgTip(i18n("tips_place_noUnion"))
		end
	end
end
return Com_reward
