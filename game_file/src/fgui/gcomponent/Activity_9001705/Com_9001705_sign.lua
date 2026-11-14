local baseComponent = require("fgui.base.baseComponent")
local Com_9001705_sign = fgui.extension_class(fgui.GComponent, baseComponent)
local activity_9001705_Ctrl = SoraDGetCtrl("activity_9001705_Ctrl")
local activity_9001705_Read = include("activity_9001705_Read")
fgui.register_extension("ui://Activity_9001705/Com_9001705_sign", Com_9001705_sign)
function Com_9001705_sign:onInit()
	self:fixChildrenPos()
	self.fields.Bg_single:fix()
	self.fields.Button_buyGift:addClickListener(handler(self, self.onClickBuyGift))
	self.fields.Button_oneKey:addClickListener(handler(self, self.onClickOneKey))
	self.fields.Text_lvTitle:setString(i18n("snow_competition_text_08"))
	self.fields.Text_rewardTitle:setString(i18n("return_peak_04"))
	self.fields.Text_rewardTitle1:setString(i18n("StarlitNight_text_07"))
	self.fields.Button_buyGift:setString(i18n("StarlitNight_text_02"))
	self.fields.Button_oneKey:setString(i18n("cavalryrise_text_07"))
	self.fields.List:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.Text_des:setString(i18n("snow_competition_text_07"))
end
function Com_9001705_sign:onShow()
end
function Com_9001705_sign:onItemRenderer(index, obj)
	local cfg = self.rewardList[index + 1]
	obj:initData(cfg, index + 1)
end
function Com_9001705_sign:onClickBuyGift()
	SoraDPlaySound()
	if activity_9001705_Ctrl:isActiveGold() then
		return
	end
	uiManager:show("Activity_9001705_BuyGift")
end
function Com_9001705_sign:onClickOneKey()
	SoraDPlaySound()
	if not activity_9001705_Ctrl:hasAward() then
		print("Com_9001705_sign:onClickOneKey 没有可领取的")
		return
	end
	activity_9001705_Ctrl:reqSnowCompetitionBattlePassAllReward()
end
function Com_9001705_sign:updateUI()
	local isActiveGold = activity_9001705_Ctrl:isActiveGold()
	self.controllers.c1:setSelectedIndex(isActiveGold and 1 or 0)
	local hasAward = activity_9001705_Ctrl:hasAward()
	self.fields.Button_oneKey:setTouchable(hasAward)
	self.fields.Button_oneKey:setGrayed(not hasAward)
	self.rewardList = activity_9001705_Read:getRewardList()
	self.fields.List:setNumItems(#self.rewardList)
end
function Com_9001705_sign:updateRedDot()
	local hasAward = activity_9001705_Ctrl:hasAward()
	self.fields.Button_oneKey:setReddot(hasAward)
	return hasAward and 1 or 0
end
return Com_9001705_sign
