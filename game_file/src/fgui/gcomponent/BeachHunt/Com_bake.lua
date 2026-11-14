local beachTreasureCtrl = SoraDGetCtrl("beachTreasureCtrl")
local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local constantRead = include("constantRead")
local publicRead = include("publicRead")
local treasureBeachRead = include("treasureBeachRead")
local baseComponent = require("fgui.base.baseComponent")
local Com_bake = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://BeachHunt/Com_bake", Com_bake)
function Com_bake:onInit()
	self:addClickListener(handler(self, self.onBtnClick))
end
function Com_bake:onShow()
end
function Com_bake:initData(data, index, idx)
	self.idx = data.id
	self.isReceived, self.rewardId = beachTreasureCtrl:isInRewardIds(self.idx)
	self.controllers.c2:setSelectedIndex(self.isReceived and 1 or 0)
	if self.isReceived and self.rewardId then
		local cfg = treasureBeachRead.getBeachCfgByIdx(self.rewardId)
		self.fields.item:initData(cfg.reward[1], cfg.reward[2])
		self.fields.item:setEffectShow(treasureBeachRead.getGrandPrizesIdx() == self.rewardId)
		self.fields.item:stopAllActions()
		if idx and index == idx then
			treasureBeachRead = self.rewardId
			self.rewardId[1] = ffa.scaleTo(0.1, 1.3)
			self.rewardId[2] = ffa.scaleTo(0.05, 1)
			self.rewardId[3] = ffa.scaleTo(0.05, 1)
			self.rewardId[4] = ffa.scaleTo(0.05, 1)
			self.fields.item:runAction(ffa.seq(self.rewardId))
		end
	end
	local sandStyle = 0
	if self.idx > 10 and self.idx <= 30 then
		sandStyle = 1
	elseif self.idx > 30 and self.idx <= 42 then
		sandStyle = 2
	elseif self.idx > 42 then
		sandStyle = 3
	end
	self.controllers.c1:setSelectedIndex(sandStyle)
end
function Com_bake:onBtnClick()
	if self.isReceived then
	else
		local costItemID = constantRead.getConstValue("TREASURE_BEACH_ITEM")
		self.itemCount = backpackCtrl:getItemCount(costItemID)
		if self.itemCount >= constantRead.getConstValue("TREASURE_BEACH_NUM2", 7) then
			if not self.isReceived then
				constantRead = constantRead.getConstValue("TREASURE_BEACH_NUM2", 7)
				constantRead.getConstValue("TREASURE_BEACH_NUM2", 7).msg = "MESSAGE_BEACH_HUNT_DIGBAKE"
				constantRead.getConstValue("TREASURE_BEACH_NUM2", 7).idx = self.idx
				SoraDSendMessage((constantRead.getConstValue("TREASURE_BEACH_NUM2", 7)))
				SoraDShowLoading(nil, nil, nil, true)
			end
		else
			constantRead = nil
			;(nil).item = publicRead.getName(costItemID)
			SoraDShowMsgTip(i18n("common_text_1806", nil))
		end
	end
end
return Com_bake
