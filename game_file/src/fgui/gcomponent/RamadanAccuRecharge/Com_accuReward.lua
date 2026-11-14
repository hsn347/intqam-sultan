local ramadanAccuRechargeltCtrl = include("ramadanAccuRechargeltCtrl")
local ramadanAccuRechargeCtrl = SoraDGetCtrl("ramadanAccuRechargeCtrl")
local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_accuReward = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://RamadanAccuRecharge/Com_accuReward", Com_accuReward)
function Com_accuReward:onInit()
	self:fixChildrenPos()
	self.fields.bg:fix(false)
	self.fields.Ani_get:setAllFrameName("dh_chongzhi01_%02d.png", 1)
	local classtype = activityShowCtrl:getParamByID(gActivityTimeActivityID.RAMADAN_ACCUMULATE_RECHARGE).classtype
	self.reachPointList = ramadanAccuRechargeltCtrl.getPointRewardDataByClassType(classtype)
	self.fields.scroll:setItemRenderer(handler(self, self.onItemRendererReward))
	self.fields.touch:addClickListener(handler(self, self.onClickGetReward))
	self.fields.btn_get:setTouchable(false)
end
function Com_accuReward:initData(index, data)
	dump(data, "Com_accuReward:initData(")
	self.index = index
	self.data = data
	self.levelScore = data.point
	self.curScore = ramadanAccuRechargeCtrl:getCurScore()
	self.hadGot = ramadanAccuRechargeCtrl:hadGotReward(index)
	local strCurScore = self.curScore
	if self.curScore < self.levelScore then
		strCurScore = fguiHelper.getColorString("#FF0000", self.curScore)
	else
		strCurScore = fguiHelper.getColorString("#D4C495", self.levelScore)
	end
	self.fields.text_need:setString(strCurScore .. "/" .. self.levelScore)
	self.fields.scroll:setNumItems(table.nums(data.reward) / 2)
	if self.curScore >= self.levelScore and not self.hadGot then
		self.fields.btn_get:getController("c1"):setSelectedIndex(1)
		self.fields.touch:setTouchable(true)
		self.fields.bar:setFillAmount(1)
		self.fields.hightLight:setVisible(true)
		self.fields.Ani_get:setVisible(true)
	elseif self.curScore >= self.levelScore and self.hadGot then
		self.fields.btn_get:getController("c1"):setSelectedIndex(2)
		self.fields.touch:setTouchable(false)
		self.fields.hightLight:setVisible(true)
		self.fields.bar:setFillAmount(1)
		self.fields.Ani_get:setVisible(false)
	else
		self.fields.btn_get:getController("c1"):setSelectedIndex(0)
		self.fields.touch:setTouchable(false)
		self.fields.hightLight:setVisible(false)
		self.fields.Ani_get:setVisible(false)
		local lastLevelScore = 1 < index and self.reachPointList[index - 1].point or 0
		if lastLevelScore <= self.curScore then
			self.fields.bar:setFillAmount((self.curScore - lastLevelScore) / (self.levelScore - lastLevelScore))
		else
			self.fields.bar:setFillAmount(0)
		end
	end
end
function Com_accuReward:onItemRendererReward(index, object)
	object:initData(self.data.reward[2 * index + 1], self.data.reward[2 * index + 2])
end
function Com_accuReward:onClickGetReward()
	if self.curScore >= self.levelScore and not self.hadGet then
		ramadanAccuRechargeCtrl:sendRewardMsg(self.index)
	end
end
function Com_accuReward:onShow()
end
return Com_accuReward
