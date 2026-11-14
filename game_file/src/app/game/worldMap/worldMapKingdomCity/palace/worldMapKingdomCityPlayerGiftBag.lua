local WorldMapKingdomCityPlayerGiftBag = class("worldMapKingdomCityPlayerGiftBag", function(target)
	if target == nil then
		return SoraDCreateBasePanel("worldMapKingdomCityPlayerGiftBag")
	end
	return target
end)
function WorldMapKingdomCityPlayerGiftBag:ctor()
	self.giftUsrInfo, _ENV, self.myRank = nil, nil, nil
	self.btnExplain = SoraDGetChildByName(self, "Button_explain")
	self.btnRecord = SoraDGetChildByName(self, "Button_record")
	self.scroll = SoraDGetChildByName(self, "Top_Size_ScrollView_giftBag")
	self.nodeBottom = SoraDGetChildByName(self, "Bottom_Node_btns")
	self.Node_playerGift = SoraDGetChildByName(self, "Node_playerGift")
	self.Node_playerGift:setVisible(true)
	self.time = SoraDGetChildByName(self, "Text_time")
	self.time = SoraDCreateTimerLabel(self, self.time)
	self.btnExplain:setVisible(false)
	self.btnRecord:setVisible(false)
	self.btnExplain:addTouchEventListener(handler(self, self.btnExplainClick))
	self.btnRecord:addTouchEventListener(handler(self, self.btnRecordClick))
	SoraDGetChildByName(self, "Image_bg"):setFillType(1)
	self.windowTitle = SoraDGetExtendChildFromCCSByName(self, "Top_CCS_commonFramTitle_giftBag")
	self.windowTitle:setTitle(i18n("kindofwar_title_01"))
	self.windowTitle:setTitleSize()
	self.btnExplain:setTitleText(i18n("common_text_001"))
	self.btnRecord:setTitleText(i18n("common_text_836"))
	SoraDAddMessage(self, "MESSAGE_SERVER_KINGDOMWAR_KINGDOMGIFT_GETLIST", handler(self, self.initData))
	SoraDAddMessage(self, "MESSAGE_SERVER_KINGDOMWAR_KINGDOMGIFT_SENDSUCCESS", handler(self, self.reqForList))
	self:addFireEffect()
	self:setReqArg()
	self:reqForList()
end
function WorldMapKingdomCityPlayerGiftBag:setReqArg(...)
	local gametop = gModuleMgr.getObject("gametop")
	local kingdomMapCtrl = gametop.playertop_:getModule("kingdomMapCtrl")
	self.myRank = kingdomMapCtrl:getKingWarRank()
end
function WorldMapKingdomCityPlayerGiftBag:reqForList(target, data)
	if data and data.redata.uid then
		SoraDShowMsgTip(i18n("common_text_1433"))
	end
	local kingPacksRead = include("kingPacksRead")
	local gametop = gModuleMgr.getObject("gametop")
	local KWKingdomCtrl = gametop.playertop_:getModule("KWKingdomCtrl")
	KWKingdomCtrl:getPackData(true)
end
function WorldMapKingdomCityPlayerGiftBag:initData(target, data)
	self.giftUsrInfo = data.retdate
	self.kingdomLv = data.kingdomLv
	dump(self.giftUsrInfo, "用户")
	self:initView()
end
function WorldMapKingdomCityPlayerGiftBag:initView()
	self.scroll:removeAllChildren()
	local sSize = self.scroll:getContentSize()
	self.scroll:setPositionY(display.height - 280)
	self.scroll:setContentSize(cc.size(sSize.width, display.height - 378))
	local kingPacksRead = include("kingPacksRead")
	local keysTbl = kingPacksRead.getTblKeys(self.myRank, self.kingdomLv)
	local realHeight = 0
	local _ENV, singleArray = self.kingdomLv, self.kingdomLv
	for i, v in ipairs(keysTbl) do
		singleArray[i] = SoraDCreatePanel("worldMapKingdomCityPlayerGiftBagSingle")
		singleArray[i]:initData(v, self.giftUsrInfo, self.myRank, self.kingdomLv)
		realHeight = realHeight + singleArray[i]:returnHeigh()
	end
	local sH = math.max(realHeight, sSize.height)
	self.scroll:setInnerContainerSize(cc.size(sSize.width, sH))
	for i, v in ipairs(singleArray) do
		v:setScroll(self.scroll)
		v:setPosition(self.scroll:getContentSize().width / 2, sH)
		v:addTo(self.scroll, #keysTbl - i)
		sH = sH - v:returnHeigh()
	end
	local gametop = gModuleMgr.getObject("gametop")
	local kingdomMapCtrl = gametop.playertop_:getModule("kingdomMapCtrl")
	local timeLeft = kingdomMapCtrl:getKingWarPackLeftTime()
	self.time:setTimeEndListener(function()
		self:removeFromParent()
	end)
	self.time:setTimeLast(function(tick)
		_ENV = nil
		;(nil).time = tick
		return i18n("common_text_2797", nil)
	end)
	self.time:beginTime(timeLeft)
end
function WorldMapKingdomCityPlayerGiftBag:btnExplainClick(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		userSDKManager.showFAQs()
	end
end
function WorldMapKingdomCityPlayerGiftBag:btnRecordClick(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local panel = SoraDCreatePanel("worldMapKingdomCityPlayerGiftBagRecord")
		panel:initData(self.myRank)
		panel:show()
	end
end
function WorldMapKingdomCityPlayerGiftBag:addFireEffect(...)
	SoraDCreateFireEffectNode(self.nodeBottom:getChildByName("frame_lace_base_1"), self.nodeBottom:getChildByName("frame_lace_base_2"))
end
return WorldMapKingdomCityPlayerGiftBag
