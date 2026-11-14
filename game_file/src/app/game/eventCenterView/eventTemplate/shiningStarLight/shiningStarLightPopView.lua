local shiningStarLightRead = include("shiningStarLightRead")
local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local shiningStarLightCtrl = SoraDGetCtrl("shiningStarLightCtrl")
local shiningStarLightPopView = class("shiningStarLightPopView", function(target)
	if target and tolua.type(target) == "string" then
		target = SoraDCreateTouchPanel(target)
	end
	return target or SoraDCreateTouchPanel("shiningStarLightPopView")
end)
function shiningStarLightPopView:ctor(properties)
	self.textName = SoraDGetChildByName(self, "Text_name")
	self.textTitleInfo = SoraDGetChildByName(self, "Text_TitleInfo")
	self.textTitleInfo:setString(i18n("Glorious_text_04"))
	self.textBoxName = SoraDGetChildByName(self, "Text_BoxName")
	self.nodeShiningStarLightSingle = SoraDGetExtendChildFromCCSByName(self, "CCS_shiningStarLightSingle")
	self.nodeAward = SoraDGetChildByName(self, "Node_Award")
	self.btnGo = SoraDGetChildByName(self, "Button_Go")
	self.btnGo:setTouchEnabled(true)
	self.btnGo:addTouchEventListener(handler(self, self.btnGoClick))
	self.nodeLamp = SoraDGetChildByName(self.btnGo, "Node_Lamp")
	self.textNum = SoraDGetChildByName(self.nodeLamp, "Text_Num")
	self.textTips = SoraDGetChildByName(self.btnGo, "Text_Tips")
end
function shiningStarLightPopView:initData(index, status)
	self.nodeShiningStarLightSingle:initData(index, false)
	self.index = index
	self.textName:setString(i18n("Glorious_text_1" .. self.index))
	self.status = status
	self.btnGo:setBright(true)
	self.textTips:setVisible(true)
	local initCastleLv = shiningStarLightCtrl:getInitCastleLv()
	if self.status == gLampLightStatusType.LIGHT then
		self.btnGo:setBright(false)
		self.btnGo:setTitleText(i18n("common_text_1892"))
		self.btnGo:setTouchEnabled(false)
		self.textTips:setVisible(false)
	elseif self.status == gLampLightStatusType.CANLIGHT then
		self.btnGo:setTitleText(i18n("Glorious_text_03"))
		self.textTips:setVisible(false)
	elseif self.status == gLampLightStatusType.GOTASK then
		self.btnGo:setTitleText(i18n("common_text_477"))
		self.textTips:setString(i18n("Glorious_text_06"))
	else
		self.btnGo:setTitleText(i18n("common_text_204"))
		self.textTips:setString(i18n("Glorious_text_05"))
	end
	local config = shiningStarLightRead.getLightAward(shiningStarLightCtrl:getInitCastleLv(), index)
	local reward = config.award
	for i, v in ipairs(reward) do
		local single = include("commonItemAward").new()
		single:setScale(0.8)
		single:setBaseScale(1.0)
		single:setOwnView(self)
		single:setPositionY(0)
		single:addTo(self.nodeAward)
		single:initData(v.id, v.count)
	end
	SoraDToCenter(self.nodeAward, 100)
	local needNum = config.need[2]
	local haveNum = backpackCtrl:getItemCount(config.need[1])
	self.textNum:setString(haveNum .. "/" .. needNum)
	self.textNum:setColor(needNum > haveNum and cc.c3b(255, 0, 0) or cc.c3b(255, 255, 255))
	SoraDToCenter(self.nodeLamp, 10, SoraDFIsRA())
	self.textBoxName:setString(i18n("Glorious_text_1" .. self.index))
end
function shiningStarLightPopView:btnGoClick(target, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local tag = target:getTag()
		if self.status == gLampLightStatusType.CANLIGHT then
			shiningStarLightCtrl:reqGloriousStarLampUpStarLamp()
		elseif self.status == gLampLightStatusType.GOTASK then
			_ENV = gLampLightStatusType.GOTASK
			gLampLightStatusType.GOTASK.msg = "MESSAGE_SHINING_STAR_LIGHT"
			gLampLightStatusType.GOTASK.subMsg = "Jump_Task"
			SoraDSendMessage(gLampLightStatusType.GOTASK)
		end
		self:removeFromParent()
	end
end
return shiningStarLightPopView
