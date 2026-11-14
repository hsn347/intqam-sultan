local nebulaCelebrationCtrl = SoraDGetCtrl("nebulaCelebrationCtrl")
local nebulaCelebrationRead = include("nebulaCelebrationRead")
local baseComponent = require("fgui.base.baseComponent")
local NebulaCelebrationMainReward = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://NebulaCelebration/NebulaCelebrationMainReward", NebulaCelebrationMainReward)
function NebulaCelebrationMainReward:onInit()
	self:fixChildrenPos()
	self.fields.Bg_single:fix()
	self.fields.Bg_title:fix()
	self.fields.Usm_role:setPrepareCallback(function()
		self.transitions.t0:play()
		self.fields.Usm_role:play(true)
	end)
	self.fields.Text_lvTitle:setString(i18n("common_text_748"))
	self.fields.Text_rewardTitle:setString(i18n("Nebula_Celebration_title05"))
	self.fields.Text_rewardTitle1:setString(i18n("Nebula_Celebration_title06"))
	self.fields.Button_buyLevel:setString(i18n("Nebula_Celebration_button01"))
	self.fields.Button_buyGift:setString(i18n("Nebula_Celebration_button02"))
	self.fields.Button_oneKey:setString(i18n("cavalryrise_text_07"))
	self.fields.Button_buyLevel:addClickListener(handler(self, self.onClickBuyLevel))
	self.fields.Button_buyGift:addClickListener(handler(self, self.onClickBuyGift))
	self.fields.Button_oneKey:addClickListener(handler(self, self.onClickOneKey))
	self.fields.List:setVirtual()
	self.fields.List:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.List:addEventListener(fgui.UIEventType.Scroll, handler(self, self.onListScroll))
end
function NebulaCelebrationMainReward:onListScroll()
	self:updateSpecialReward()
end
function NebulaCelebrationMainReward:onItemRenderer(index, obj)
	local cfg = self.rewardList[index + 1]
	obj:initData(cfg)
end
function NebulaCelebrationMainReward:onClickBuyLevel()
	SoraDPlaySound()
	if self.controllers.c1:getSelectedIndex() == 1 then
		SoraDShowMsgTip(i18n("Nebula_Celebration_text08"))
		return
	end
	uiManager:show("NebulaCelebrationBuyLevel")
end
function NebulaCelebrationMainReward:onClickBuyGift()
	SoraDPlaySound()
	if nebulaCelebrationCtrl:isActiveGold() then
		print("NebulaCelebrationMainReward:onClickBuyGift 已激活过！")
		SoraDShowMsgTip(i18n("Nebula_Celebration_text19"))
		return
	end
	uiManager:show("NebulaCelebrationBuyGift")
end
function NebulaCelebrationMainReward:onClickOneKey()
	SoraDPlaySound()
	if not nebulaCelebrationCtrl:hasAward() then
		print("NebulaCelebrationMainReward:onClickOneKey 没有可领取的")
		return
	end
	nebulaCelebrationCtrl:sendReqRecieveReward()
end
function NebulaCelebrationMainReward:onShow()
end
function NebulaCelebrationMainReward:updateUI()
	self.fields.Label_time:initActivityTime(gActivityTimeActivityID.NEBULA_CELEBRATION_ACTIVITY)
	local lv = nebulaCelebrationCtrl:getCurLevel()
	local exp = nebulaCelebrationCtrl:getCurLevelExp()
	local expMax = nebulaCelebrationCtrl:getCurLevelExpMax()
	self.fields.Label_lv:setString(lv)
	self.fields.Text_exp:setString(string.formatnumberthousands(exp) .. "/" .. string.formatnumberthousands(expMax))
	self.fields.Progress_exp:setMax(expMax)
	self.fields.Progress_exp:setValue(exp)
	self.rewardList = nebulaCelebrationCtrl:getRewardList()
	self.fields.List:setNumItems(#self.rewardList - 1)
	local lvMax = nebulaCelebrationCtrl:getMaxLevel()
	self.controllers.c1:setSelectedIndex(lv >= lvMax - 1 and 1 or 0)
	local isActiveGold = nebulaCelebrationCtrl:isActiveGold()
	local unlockFlag = self:getUnlockFlag()
	isActiveGold = isActiveGold and not unlockFlag
	self.controllers.c2:setSelectedIndex(isActiveGold and 1 or 0)
	local hasAward = nebulaCelebrationCtrl:hasAward()
	local isActiveGold = nebulaCelebrationCtrl:isActiveGold()
	local rewardLv = nebulaCelebrationCtrl:getRewardLevel()
	local rewardLvGold = nebulaCelebrationCtrl:getRewardLevelGold()
	local index = rewardLv + 1
	if isActiveGold then
		index = math.min(index, rewardLvGold + 1)
	end
	index = math.min(index, lvMax - 1)
	self.fields.List:scrollToView(index - 1, false, false)
	self.fields.Button_oneKey:setReddot(hasAward)
	self.fields.Button_oneKey:setTouchable(hasAward)
	self.fields.Button_oneKey:setGrayed(not hasAward)
end
function NebulaCelebrationMainReward:updateSpecialReward()
	local cfg = self:getMaxShowReward()
	self.fields.Com_lastReward:initData(cfg)
end
function NebulaCelebrationMainReward:getMaxShowReward()
	local singleHeight = 98
	local contentHeight = self.fields.List:getContentSize().height
	local posY = self.fields.List:getScrollPane():getPosY()
	local index = (posY + contentHeight) / singleHeight
	return nebulaCelebrationRead.getShowRewad(nebulaCelebrationCtrl:getClassType(), index)
end
function NebulaCelebrationMainReward:getUnlockFlag()
	return self._unlocking or nebulaCelebrationCtrl:getUnlockFlag()
end
function NebulaCelebrationMainReward:showUnlockEffect()
	if not nebulaCelebrationCtrl:getUnlockFlag() then
		return
	end
	print("NebulaCelebrationMainReward:showUnlockEffect", debug.traceback())
	self._unlocking = true
	self.fields.Button_buyGift:showUnlockEffect(function()
		self._unlocking = false
		nebulaCelebrationCtrl:setUnlockFlag(false)
		self:updateUI()
	end)
end
function NebulaCelebrationMainReward:resizeBannerEffect()
	local bannerWidth = 853
	local bannerHeight = 481
	local scale = self:getWidth() / bannerWidth
	self.fields.Loader_banner:setSize(self:getWidth(), bannerHeight * scale, false)
	self.fields.Usm_role:setScale(scale, scale)
end
return NebulaCelebrationMainReward
