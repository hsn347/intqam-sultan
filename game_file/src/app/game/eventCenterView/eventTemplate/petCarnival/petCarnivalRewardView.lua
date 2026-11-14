local gametop = gModuleMgr.getObject("gametop")
local petCarnivalCtrl = gametop.playertop_:getModule("petCarnivalCtrl")
local petCarnivalRead = include("petCarnivalRead")
_ENV = "petCarnivalRead"
;("petCarnivalRead").noClaim = 1
;("petCarnivalRead").noReach = 2
local ("petCarnivalRead").claimed, giftStatus = 3, "petCarnivalRead"
local petCarnivalRewardView = class("petCarnivalRewardView", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("petCarnivalRewardView")
	end
	return target
end)
function petCarnivalRewardView:ctor()
	self.award, _ENV = nil, nil
	self.status = 0
	self.index = 0
	self.Button_get = SoraDGetChildByName(self, "Button_get")
	self.Text_des = SoraDGetChildByName(self, "Text_des")
	self.Text_point = SoraDGetChildByName(self, "Text_4")
	self.Text_8 = SoraDGetChildByName(self, "Text_8")
	self.Text_8:setString(i18n("pet_flip_text_06"))
	self.Text_next = SoraDGetChildByName(self, "Text_next")
	self.Text_next:setString(i18n("pet_flip_text_07"))
	self.Node_award_Double = SoraDGetChildByName(self, "Node_award_Double")
	self.Node_award = SoraDGetChildByName(self, "Node_award")
	self.CCS_commonItemAward_1 = SoraDGetChildByName(self, "CCS_commonItemAward_1")
	self.CCS_commonItemAward_1:setVisible(false)
	SoraDChangeTextToHtml(self.Text_des)
	SoraDChangeTextToHtml(self.Text_point)
	self.Text_point:setColor(cc.c3b(255, 255, 255))
	self.Text_point:setFontSize(20)
	self.Image_22 = SoraDGetChildByName(self, "Image_22")
end
function petCarnivalRewardView:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_PETCARNIVAL_INIT", handler(self, self.changeData))
	SoraDAddMessage(self, "MESSAGE_PETCARNIVAL_CLAIM_REWARD", handler(self, self.getAction))
end
function petCarnivalRewardView:getAction(target, data)
	local reward = data.reward
	local _ENV, itemData
	for i, v in ipairs(reward) do
		_ENV = nil
		;(nil).id = v.id
		;(nil).count = v.count
		table.insert(itemData, nil)
	end
	SoraDMailGainItems(itemData, true)
end
function petCarnivalRewardView:changeData()
	self.status = petCarnivalCtrl:getStageRewardStauts(self.index)
	self:setButton()
end
function petCarnivalRewardView:initIndex(index, otherData)
	dump("阶段", index)
	dump(index, "阶段")
	self.index = index
	local config = petCarnivalRead.getRewardConfig(index)
	self.Text_des:setColor(cc.c3b(255, 255, 255))
	self.Text_des:setFontSize(20)
	_ENV = cc.c3b(255, 255, 255)
	_ENV, _ENV, cc.c3b(255, 255, 255).num = config.num, string.formatnumberthousands(config.num), string.formatnumberthousands(config.num)
	_ENV, string.formatnumberthousands(config.num).num, config.num.color = config.num, config.num, "#FFFFFF"
	string.formatnumberthousands(config.num).__default, config.num.color = config.num, "#FFC550"
	self.Text_des:setString(i18n_html("pet_flip_text_04", cc.c3b(255, 255, 255)))
	local type = config.type
	self:setType(type)
	self.status = petCarnivalCtrl:getStageRewardStauts(index)
	print("状态", self.status)
	self.Button_get:addTouchEventListener(handler(self, self.clickGetBtn))
	self:setButton()
	for id = 1, table.nums(config.reward) do
		local rewardData = config.reward[id]
		local itemAward = self.award[id]
		if itemAward then
			itemAward:initData(rewardData.id, rewardData.count)
		else
			itemAward = include("commonItemAward").new()
			itemAward:setRealScale(0.75)
			itemAward:setOwnView(self)
			itemAward:setPosition(0, 0)
			itemAward:addTo(self.Node_award)
			itemAward:initData(rewardData.id, rewardData.count)
			self.award[id] = itemAward
		end
	end
	SoraDToCenter(self.Node_award, 85, SoraDFIsRA())
end
function petCarnivalRewardView:setType(type)
	self.Button_get:setVisible(type == 1)
	self.Text_next:setVisible(type == 2)
	self.Node_award_Double:setVisible(type == 2)
	self.Node_award:setVisible(type == 1)
end
function petCarnivalRewardView:setButton()
	local num = petCarnivalCtrl:getTotalPoint()
	petCarnivalCtrl = petCarnivalCtrl
	petCarnivalCtrl[giftStatus.noReach] = function()
		self.Button_get:setTitleText(i18n("common_text_1146"))
		self.Button_get:loadTextures("btn_gray_normal.png", "btn_gray_normal.png", "btn_gray_normal.png", ccui.TextureResType.plistType)
		self.Button_get:setTitleColor(cc.c3b(255, 255, 255))
		self.Button_get:setTouchEnabled(true)
		self = cc.c3b(255, 255, 255)
		self, self, cc.c3b(255, 255, 255).num = num, string.formatnumberthousands(num), string.formatnumberthousands(num)
		self, string.formatnumberthousands(num).num, num.color = num, num, "#FF0000"
		string.formatnumberthousands(num).__default, num.color = num, "#D7C39B"
		self.Text_point:setString(i18n_html("pet_flip_text_03", cc.c3b(255, 255, 255)))
	end
	petCarnivalCtrl[giftStatus.noClaim] = function()
		self.Button_get:setTitleText(i18n("common_text_1146"))
		self.Button_get:loadTextures("btn_green_normal_01.png", "btn_green_normal_01.png", "btn_green_normal_01.png", ccui.TextureResType.plistType)
		self.Button_get:setTitleColor(cc.c3b(255, 255, 255))
		self.Button_get:setTouchEnabled(true)
		self = cc.c3b(255, 255, 255)
		self, self, cc.c3b(255, 255, 255).num = num, string.formatnumberthousands(num), string.formatnumberthousands(num)
		self, string.formatnumberthousands(num).num, num.color = num, num, "#FFFFFF"
		string.formatnumberthousands(num).__default, num.color = num, "#D7C39B"
		self.Text_point:setString(i18n_html("pet_flip_text_03", cc.c3b(255, 255, 255)))
	end
	local petCarnivalCtrl[giftStatus.claimed], switch = function()
		self.Button_get:setTitleText(i18n("common_text_1892"))
		self.Button_get:loadTextures("btn_gray_normal.png", "btn_gray_normal.png", "btn_gray_normal.png", ccui.TextureResType.plistType)
		self.Button_get:setTitleColor(cc.c3b(255, 255, 255))
		self.Button_get:setTouchEnabled(false)
		self = cc.c3b(255, 255, 255)
		self, self, cc.c3b(255, 255, 255).num = num, string.formatnumberthousands(num), string.formatnumberthousands(num)
		self, string.formatnumberthousands(num).num, num.color = num, num, "#FFFFFF"
		string.formatnumberthousands(num).__default, num.color = num, "#D7C39B"
		self.Text_point:setString(i18n_html("pet_flip_text_03", cc.c3b(255, 255, 255)))
	end, petCarnivalCtrl
	switch[self.status]()
end
function petCarnivalRewardView:clickGetBtn(button, eventType)
	giftStatus = nil
	;(nil)[giftStatus.noReach] = function()
		SoraDShowMsgTip(i18n("pet_flip_text_05"))
	end
	;(nil)[giftStatus.noClaim] = function()
		petCarnivalCtrl:reqClaimReward(self.index)
	end
	local (nil)[giftStatus.claimed], switch = function()
	end, nil
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		switch[self.status]()
	end
end
return petCarnivalRewardView
