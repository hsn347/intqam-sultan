local baseComponent = require("fgui.base.baseComponent")
local Pet_Com_Train_Level = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://PetFguiView/Pet_Com_Train_Level", Pet_Com_Train_Level)
local gametop = gModuleMgr.getObject("gametop")
local lordInfoCtrl = gametop.playertop_:getModule("lordInfoCtrl")
local petCtrl = gametop.playertop_:getModule("petCtrl")
local petltCtrl = include("petltCtrl")
local backpackCtrl = gametop.playertop_:getModule("backpackCtrl")
local backpackltCtrl = gModuleMgr.sharedMgr("backpackltCtrl")
local shopCtrl = gametop.playertop_:getModule("shopCtrl")
local petDesRead = include("petDesRead")
local itemDesRead = include("itemDesRead")
local guideCtrl = gametop.playertop_:getModule("guideCtrl")
function Pet_Com_Train_Level:onInit()
	if not SoraDFIsRA() then
		self:fixChildrenPos(false, true)
	end
	self.isFeedClick = false
	self.fields.btn_item_train:addClickEventListener(handler(self, self.btnItemFeedClick), 1)
	self.fields.btn_train_one:addClickEventListener(handler(self, self.btnFeedClickCallBack), 1)
	self.fields.btn_train_ten:addClickEventListener(handler(self, self.btnFeedAllClickCallBack), 10)
	self.fields.btn_item_train:setTitle(i18n("common_text_2923"))
	_ENV = i18n("common_text_2923")
	i18n("common_text_2923").num = 1
	self.fields.btn_train_one:setTitle(i18n("common_text_2919", i18n("common_text_2923")))
	_ENV = i18n("common_text_2919", i18n("common_text_2923"))
	i18n("common_text_2919", i18n("common_text_2923")).count = PET_FEED_COUNT_ONCE
	self.fields.btn_train_ten:setTitle(i18n("common_text_2920", i18n("common_text_2919", i18n("common_text_2923"))))
end
function Pet_Com_Train_Level:onShow()
end
function Pet_Com_Train_Level:initData(petData)
	self.petData = petData
	self:isFeedItemClick(self.isFeedClick)
	local gold = lordInfoCtrl:getBaseInfo().gold
	self.feedTwentyGold = 0
	self.feedTwentyExp = 0
	for i = 1, 20 do
		local exp, gold = petltCtrl.getFeedGoldAddExp(petCtrl.feedInfo.curGoldFeed + i)
		self.feedTwentyExp = self.feedTwentyExp + exp
		self.feedTwentyGold = self.feedTwentyGold + gold
		if i == 1 then
			self.fields.btn_train_one:setCostNum(self.feedTwentyGold, gold)
		end
	end
	self.fields.btn_train_ten:setCostNum(self.feedTwentyGold, gold)
	if petCtrl.feedInfo.curFreeFeed < PET_FEED_FREE_TIMES_LIMIT then
		self.fields.btn_train_one:setCostNum(0, gold)
		self.fields.btn_train_one:setFreeTitle(i18n("common_text_2932") .. "\n" .. PET_FEED_FREE_TIMES_LIMIT - petCtrl.feedInfo.curFreeFeed .. "/" .. PET_FEED_FREE_TIMES_LIMIT)
		if SoraDIsGameGuide() == nil then
			local guideCtrl = gametop.playertop_:getModule("guideCtrl")
			guideCtrl:updateGuideModule(gGuideModule.PET_FEED)
		end
	end
end
function Pet_Com_Train_Level:isFeedItemClick(isClick)
	self.isFeedClick = isClick
	self.fields.btn_item_train:setVisible(not isClick)
	self.fields.btn_train_one:setVisible(not isClick)
	self.fields.btn_train_ten:setVisible(not isClick)
	self.fields.com_petFeed:setVisible(isClick)
	if isClick then
		self.fields.com_petFeed:initData(isClick, self.petData, self)
	end
end
function Pet_Com_Train_Level:btnFeedClickCallBack(button, type)
	SoraDPlaySound()
	if petCtrl.feedInfo.curFreeFeed >= PET_FEED_FREE_TIMES_LIMIT then
		if petCtrl.feedInfo.curGoldFeed >= PET_FEED_GOLD_TIMES_LIMIT then
			SoraDShowMsgTip(i18n("common_text_2933"))
		else
			local exp, gold = petltCtrl.getFeedGoldAddExp(petCtrl.feedInfo.curGoldFeed + 1)
			if SoraDEnoughGold(gold) then
				petCtrl:reqFeedPet(self.petData.petid, gPetFeedType.GOLD)
			end
		end
	else
		petCtrl:reqFeedPet(self.petData.petid, gPetFeedType.FREE)
	end
end
function Pet_Com_Train_Level:btnFeedAllClickCallBack(button, type)
	SoraDPlaySound()
	if petCtrl.feedInfo.curGoldFeed > PET_FEED_GOLD_TIMES_LIMIT - 20 then
		SoraDShowMsgTip(i18n("common_text_2933"))
	else
		if SoraDEnoughGold(self.feedTwentyGold) then
			local dailyRemindManager = include("dailyRemindManager")
			local ctype = dailyRemindManager.REMIND_TYPE.petTrainView
			if dailyRemindManager.checkNeedRemind(ctype) then
				_ENV = ctype
				_ENV, ctype.msgKey = i18n("common_text_2933")
				i18n("common_text_2933").gold = string.formatnumberthousands(self.feedTwentyGold)
				i18n("common_text_2933").count = 20
				ctype.msgParams, i18n("common_text_2933").exp = i18n("common_text_2933")
				ctype.gold = self.feedTwentyGold
				_ENV = self.feedTwentyExp
				self.feedTwentyExp.count = PET_FEED_COUNT_ONCE
				ctype.title = i18n("common_text_2920", self.feedTwentyExp)
				function ctype.handle(callBack)
					if callBack == MSGBOX_CALLBACK_YES then
						petCtrl:reqFeedPet(self.petData.petid, gPetFeedType.TWENTY)
						dailyRemindManager.addRemindToManager(ctype)
					end
				end
				SoraDShowBuyBoxNew(ctype)
			else
				petCtrl:reqFeedPet(self.petData.petid, gPetFeedType.TWENTY)
			end
		else
		end
	end
end
function Pet_Com_Train_Level:btnItemFeedClick(button, type)
	if petCtrl.feedInfo.curToolFeedExp < PET_FEED_TOOL_EXP_LIMIT then
		self:isFeedItemClick(true)
		petCtrl = self
		self.msg = "MESSAGE_UI_PET_ISFEEDITEM_SHOW"
		self.data = self.isFeedClick
		SoraDSendMessage(self)
	else
		SoraDShowMsgTip(i18n("common_text_2939"))
	end
end
function Pet_Com_Train_Level:gameGuide_getTarget(itemName, parameters)
	if itemName == "CCS_commonGoldNormalBtn_feed" then
		return self.fields.btn_train_one
	end
	return SoraDGetChildByName(self, itemName)
end
return Pet_Com_Train_Level
