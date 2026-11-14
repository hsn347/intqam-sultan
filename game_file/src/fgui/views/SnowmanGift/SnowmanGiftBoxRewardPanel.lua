local signRewadRead = include("signRewadRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local SnowmanGiftBoxRewardPanel = class("SnowmanGiftBoxRewardPanel", baseFguiPanel)
local snowmanGiftCtrl = SoraDGetCtrl("snowmanGiftCtrl")
function SnowmanGiftBoxRewardPanel:ctor(...)
	self.super.ctor(self, ...)
	print("SnowmanGiftBoxRewardPanel:ctor", self.viewName)
end
function SnowmanGiftBoxRewardPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function SnowmanGiftBoxRewardPanel:onInit()
	print("=======SnowmanGiftBoxRewardPanel:onInit")
	self.fields.Button_get:addClickListener(handler(self, self.onClickGet))
	self.fields.List_reward:setItemRenderer(handler(self, self.onItemRenderer))
	if self.param.type == 1 then
		self.fields.title:setString(i18n("snowmangift_text_03"))
	else
		_ENV = i18n("snowmangift_text_03")
		i18n("snowmangift_text_03").num = self.param.day
		self.fields.title:setString(i18n("newYearRecharge_003", i18n("snowmangift_text_03")))
	end
	self:initData()
end
function SnowmanGiftBoxRewardPanel:initData()
	print("=======SnowmanGiftBoxRewardPanel:onInit")
	self.getStatus = snowmanGiftCtrl:getDayStatueByDay(self.param.day)
	if self.param.type == 1 then
		self.getStatus = snowmanGiftCtrl:getExtraRewardStatue(self.param.day)
	end
	self.fields.Button_get:getController("c2"):setSelectedIndex(0)
	if self.getStatus == 1 then
		if self.param.type == 1 then
			self.fields.Button_get:setTitleText(i18n("common_text_1146"))
		else
			self.fields.Button_get:setTitleText(i18n("build_colossus_11"))
		end
		self.fields.Button_get:setGrayed(true)
	elseif self.getStatus == 0 then
		if self.param.type == 1 then
			self.fields.Button_get:setTitleText(i18n("common_text_1146"))
		else
			self.fields.Button_get:setTitleText(i18n("common_text_2477"))
		end
		self.fields.Button_get:setGrayed(false)
		self.fields.Button_get:setTouchable(true)
	elseif self.getStatus == 3 then
		if self.param.type == 1 then
			self.fields.Button_get:setTitleText(i18n("common_text_1146"))
		else
			self.fields.Button_get:setCost(1001, include("constantRead").getConstValue("SNOWMANGIFT_SIGNIN_COST", 100))
			self.fields.Button_get:setTitleText(i18n("common_text_2875"))
			self.fields.Button_get:getController("c2"):setSelectedIndex(1)
		end
		self.fields.Button_get:setGrayed(false)
		self.fields.Button_get:setTouchable(true)
	elseif self.getStatus == 2 then
		self.fields.Button_get:setTitleText(i18n("common_text_1892"))
		self.fields.Button_get:setGrayed(true)
		self.fields.Button_get:setTouchable(false)
	end
	local classType = SoraDGetCtrl("activityShowCtrl"):getParamClassType(gActivityTimeActivityID.SNOW_MAN_GIFT_ACTIVITY) or 1
	if self.param.type == 1 then
		self.rewards = signRewadRead.getSnowmanGiftCumuSignCfg(classType)
	else
		self.rewards = signRewadRead.getSnowmanGiftSignCfg(classType, self.param.day)
	end
	self.fields.List_reward:setNumItems(table.nums(self.rewards))
end
function SnowmanGiftBoxRewardPanel:onClickGet()
	SoraDPlaySound()
	if self.getStatus == 1 then
		if self.param.type == 1 then
			SoraDShowMsgTip(i18n("snowmangift_text_01"))
		else
			SoraDShowMsgTip(i18n("Nebula_sign_tips_003"))
		end
		return
	elseif self.getStatus == 2 then
		self.fields.Button_get:setTitleText(i18n("common_text_1892"))
		self.fields.Button_get:setGrayed(true)
		self.fields.Button_get:setTouchable(false)
		return
	end
	if self.param.type == 1 then
		snowmanGiftCtrl:reqSnowManGiftActivityGetExtraReward(7)
	elseif snowmanGiftCtrl:getCurDay() > self.param.day then
		if SoraDEnoughGold(include("constantRead").getConstValue("SNOWMANGIFT_SIGNIN_COST", 100)) then
			snowmanGiftCtrl:reqSnowManGiftActivityUseGoldSign(self.param.day)
		end
	elseif snowmanGiftCtrl:getCurDay() == self.param.day then
		snowmanGiftCtrl:reqSnowManGiftActivitySign()
	end
	self:close()
end
function SnowmanGiftBoxRewardPanel:onItemRenderer(index, object)
	fguiHelper.get_fields(object).item:initData(self.rewards[index + 1].id, self.rewards[index + 1].count)
end
return SnowmanGiftBoxRewardPanel
