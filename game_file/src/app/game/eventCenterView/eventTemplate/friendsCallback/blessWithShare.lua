local gametop = gModuleMgr.getObject("gametop")
local friendsCallbackCtrl = gametop.playertop_:getModule("friendsCallbackCtrl")
local backpackCtrl = gametop.playertop_:getModule("backpackCtrl")
local activityShowCtrl = gametop.playertop_:getModule("activityShowCtrl")
local publicRead = include("publicRead")
local friendsCallbackRead = include("friendsCallbackRead")
local blessWithShare = class("blessWithShare", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("blessWithShare")
	end
	return target
end)
function blessWithShare:ctor()
	SoraDGetAllChildFromWidget(self, self)
	self.scaleActTarget = SoraDGetChildByName(self, "Center_Node")
	self.ccs_bg = SoraDGetExtendChildFromCCSByName(self, "CCS_commonPopBox_bg")
	self.ccs_bg:setTitleName(i18n("return_title_01"))
	self.Text_time = SoraDCreateTimerLabel(self, self.Text_time)
	self.Button_detail:setTitleText(i18n("common_text_1720"))
	self.Button_detail:addTouchEventListener(handler(self, self.btnDetailClick))
	local item = self.Node_single:clone()
	item:addTo(self.Node_single:getParent())
	item:setPosition(self.Panel_cut:getContentSize().width - self.Node_single:getPositionX(), self.Node_single:getPositionY())
	self.node_single_0 = item
	local offsety = math.min(40, display.height - 960)
	if 0 < offsety then
		self.Node_bottom:setPositionY(self.Node_bottom:getPositionY() - offsety)
		_UPVALUE3_ = self.Node_bottom.setPositionY
		self.Node_bottom.setPositionY[1] = self.Node_content
		self.Node_bottom.setPositionY[2] = self.Node_single
		local self.Node_bottom.setPositionY[3], offsetTable = self.node_single_0, self.Node_bottom.setPositionY
		for i, v in ipairs(offsetTable) do
			v:setPositionY(v:getPositionY() + offsety)
		end
		_UPVALUE3_ = (for generator)
		ipairs(offsetTable)[1] = self.ccs_bg
		ipairs(offsetTable)[2] = self.Panel_touch
		local ipairs(offsetTable)[3], sizeTable = self.Panel_cut, ipairs(offsetTable)
		for i, v in ipairs(sizeTable) do
			local fun = v.setSize or v.setContentSize
			fun(v, cc.size(v:getContentSize().width, v:getContentSize().height + offsety))
		end
	end
	self:initData()
end
function blessWithShare:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_SERVER_FRIEND_BACK_UPDATE_GOLD", function(target, data)
		self:initData()
	end)
end
function blessWithShare:initData(...)
	local eventTime = activityShowCtrl:getTimeInfoByID(gActivityTimeActivityID.FRIEND_CALLBACK)
	if eventTime then
		self.Text_time:beginTime(eventTime.timerNode.timer:getRemainTime())
		SoraDToCenter(self.Node_time, 10, not SoraDFIsRA())
	end
	activityShowCtrl, activityShowCtrl = self.Node_time, SoraDToCenter
	self.Node_time.name = "reurn_text_05"
	self.Node_time.title = "return_text_28"
	self.Node_time.content = "reurn_text_06"
	self.Node_time.num = friendsCallbackCtrl:getGoldNum()
	self.Node_time.icon = "icon_hyzh_cztx.png"
	_UPVALUE3_ = eventTime.timerNode.timer:getRemainTime()
	eventTime.timerNode.timer:getRemainTime()[1] = "ar"
	eventTime.timerNode.timer:getRemainTime()[2] = "en"
	eventTime.timerNode.timer:getRemainTime()[3] = "ko"
	self.Node_time.titleImage = SoraDGetImageNameByLang("farme_hyzh_cztx_%s.png", eventTime.timerNode.timer:getRemainTime())
	activityShowCtrl, SoraDToCenter[1], self.Node_time.resImage = self.Node_time, self.Node_time, "icon_small_gold.png"
	self.Node_time.name = "reurn_text_05"
	self.Node_time.title = "return_text_29"
	self.Node_time.content = "reurn_text_07"
	self.Node_time.num = friendsCallbackCtrl:getGiftsNum()
	self.Node_time.icon = "icon_hyzh_rwfz.png"
	_UPVALUE3_ = eventTime.timerNode.timer:getRemainTime()
	eventTime.timerNode.timer:getRemainTime()[1] = "ar"
	eventTime.timerNode.timer:getRemainTime()[2] = "en"
	eventTime.timerNode.timer:getRemainTime()[3] = "ko"
	self.Node_time.titleImage = SoraDGetImageNameByLang("farme_hyzh_rwfz_%s.png", eventTime.timerNode.timer:getRemainTime())
	friendsCallbackCtrl, SoraDToCenter[2], self.Node_time.resImage = self.Node_time, self.Node_time, "icon_recharge_gift.png"
	local singleConfig = SoraDToCenter
	self.Node_time[1] = self.Node_single
	local self.Node_time[2], singleTable = self.node_single_0, self.Node_time
	for i, v in ipairs(singleTable) do
		self:initSingleView(singleConfig[i], v, i)
	end
end
function blessWithShare:initSingleView(data, _single, idx)
	SoraDGetChildByName(_single, "Sprite_icon"):setSpriteFrame(data.icon)
	SoraDGetChildByName(_single, "Sprite_title"):setSpriteFrame(data.titleImage)
	SoraDGetChildByName(_single, "Text_23"):setString(i18n(data.content))
	SoraDGetChildByName(_single, "Text_22"):setString(i18n("common_text_2699"))
	SoraDGetChildByName(_single, "Text_gold"):setString("x" .. string.formatnumberthousands(data.num))
	local Node_gold = SoraDGetChildByName(_single, "Node_gold")
	SoraChangeSpriteImage(SoraDGetChildByName(Node_gold, "Image_gold"), data.resImage)
	SoraDToCenter(Node_gold, 0, SoraDFIsRA())
end
function blessWithShare:btnDetailClick(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local panel = SoraDCreatePanel("callbackFriendsShare")
		panel:show()
	end
end
return blessWithShare
