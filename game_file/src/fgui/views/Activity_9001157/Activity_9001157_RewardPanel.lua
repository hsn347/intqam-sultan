local outStandingsRead = include("outStandingsRead")
local outStandingsCtrl = SoraDGetCtrl("outStandingsCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001157_RewardPanel = class("Activity_9001157_RewardPanel", baseFguiPanel)
function Activity_9001157_RewardPanel:ctor(...)
	self.super.ctor(self, ...)
	print("Activity_9001157_RewardPanel:ctor", self.viewName)
end
function Activity_9001157_RewardPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function Activity_9001157_RewardPanel:onInit()
	print("=======Activity_9001157_RewardPanel:onInit")
	self.fields.bg:setString(i18n("hero_title_02"))
	self.fields.Btn_reward:setString(i18n("common_text_1146"))
	self.fields.Btn_reward:addClickListener(handler(self, self.buttonClickCallBack))
	self.fields.List_award:setItemRenderer(handler(self, self.onItemRederer))
end
function Activity_9001157_RewardPanel:onShow()
	print("=======Activity_9001157_RewardPanel:onShow")
	self:initData(self.proxy.param.rewardList, self.proxy.param.index, self.proxy.param.classType)
end
function Activity_9001157_RewardPanel:initData(rewardList, index, classType)
	if not rewardList or not next(rewardList) then
		return
	end
	self.rewardList = rewardList
	self.classType = classType
	self.index = index
	self.realIndex = outStandingsRead.getRealIndex(self.classType, outStandingsCtrl:getBasicType(), index)
	local scoreList = outStandingsRead.getBasicScoreByType(self.classType, outStandingsCtrl:getBasicType())
	local curPower = outStandingsCtrl:getPowerByType(self.classType)
	_UPVALUE3_ = self.classType
	self.classType[1] = curPower
	self.classType[2] = self.realIndex
	self.classType[3] = #scoreList
	dump(self.classType, "initData")
	local targetScore = scoreList[self.realIndex]
	local isReceive = outStandingsCtrl:judgeReceiveRewardsByIndex(self.index)
	self.fields.Btn_reward:setEnabled(curPower >= targetScore and not isReceive)
	self.fields.List_award:setNumItems(#self.rewardList)
end
function Activity_9001157_RewardPanel:onItemRederer(index, target)
	target:initData(self.rewardList[index + 1].id, self.rewardList[index + 1].count)
end
function Activity_9001157_RewardPanel:buttonClickCallBack()
	SoraDPlaySound()
	print("adkfjhkjfds", self.index, self.classType)
	outStandingsCtrl:sendReqRewards(self.classType, self.index)
	SoraDShowLoading(self)
end
return Activity_9001157_RewardPanel
