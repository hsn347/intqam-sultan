local publicRead = include("publicRead")
local backpackltCtrl = gModuleMgr.sharedMgr("backpackltCtrl")
local summerPrayRead = include("summerPrayRead")
local summerPrayCtrl = SoraDGetCtrl("summerPrayCtrl")
local summerPrayersSuccessView = class("summerPrayersSuccessView", function(target)
	if target and tolua.type(target) == "string" then
		target = SoraDCreateTouchPanel(target)
	end
	return target or SoraDCreateTouchPanel("summerPrayersSuccessView")
end)
function summerPrayersSuccessView:ctor(properties)
	self.scaleActTarget = SoraDGetChildByName(self, "Center_Node")
	self.textTitle = SoraDGetChildByName(self.scaleActTarget, "Text_Title")
	self.textTitle:setString(i18n("pray_text_10"))
	self.imgBox = SoraDGetChildByName(self.scaleActTarget, "Image_Box")
	self.textBoxName = SoraDGetChildByName(self.scaleActTarget, "Text_BoxName")
	self.textAwardTitle = SoraDGetChildByName(self.scaleActTarget, "Text_AwardTitle")
	self.textAwardTitle:setString(i18n("hero_title_02"))
	self.nodeAward = SoraDGetChildByName(self.scaleActTarget, "Node_Award")
	self.nodeTip = SoraDGetChildByName(self.scaleActTarget, "Node_Tip")
	self.textAwardTip = SoraDGetChildByName(self.scaleActTarget, "Text_AwardTip")
	self.textAwardTip:setString(i18n("pray_text_30"))
	self.nodeTip:setVisible(false)
	self.scrollAward = SoraDGetChildByName(self, "ScrollView_Award")
	self.scrollAward:setVisible(false)
	self.scrollAward = include("commonAutoScrollList").new(self.scrollAward)
	self.scrollAward:setSingleCreate(handler(self, self.createItemFun))
	self.scrollAward:setSingleRefresh(handler(self, self.refreshItemFun))
	self.nodeSingle = SoraDGetChildByName(self, "Node_Single")
	self.btnSure = SoraDGetChildByName(self.scaleActTarget, "Button_Sure")
	self.btnSure:setTouchEnabled(true)
	self.btnSure:setTitleText(i18n("common_text_204"))
	self.btnSure:addTouchEventListener(handler(self, self.btnClickSure))
	local cssFileName = "summerPrayersSuccessView"
	local cssFilePath = getCCSPath(cssFileName)
	local action = cc.CSLoader:createTimeline(cssFilePath)
	action:gotoFrameAndPlay(0, true)
	self:runAction(action)
	self.enableTouchCloseSelf = true
	self:setCloseCallBack(handler(self, self.onClose))
end
function summerPrayersSuccessView:initData(data)
	local itemId = data.successItem
	local ret = backpackltCtrl:getRandomGiftShowItems(itemId)
	self:createItem(data.packreward)
	self:createItem(ret)
	SoraDToCenter(self.nodeAward, 75, not SoraDFIsRA())
	local config = summerPrayRead.getBoxConfigByOrder(summerPrayCtrl:getGiftOrder())
	self.textBoxName:setString(i18n(config.packname))
	self.imgBox:loadTexture(publicRead.getIcon(config.packreward1[1].id), ccui.TextureResType.plistType)
	_ENV = ccui.TextureResType.plistType
	ccui.TextureResType.plistType[1] = cca.delay(0.3)
	ccui.TextureResType.plistType[2] = cca.callFunc(function()
		self.enableTouchCloseSelf = false
	end)
	ccui.TextureResType.plistType[3] = cca.callFunc(function()
		self.enableTouchCloseSelf = false
	end)
	self:runAction(cca.seq(ccui.TextureResType.plistType))
end
function summerPrayersSuccessView:initTenData(reward)
	self.enableTouchCloseSelf = false
	self.textTitle:setString(i18n("pray_text_29"))
	SoraDGetAutoHeightLabel(self.textTitle, 381)
	SoraDGetChildByName(self, "Node_Effect_2"):setVisible(false)
	SoraDGetChildByName(self, "Node_AwardTitle"):setVisible(false)
	SoraDGetChildByName(self, "Node_Bag"):setVisible(false)
	self.scrollAward:updateScrollView(cc.size(100, 100), reward, 3)
	self.nodeTip:setVisible(true)
	self.scrollAward:setVisible(true)
end
function summerPrayersSuccessView:createItem(list)
	for i, v in ipairs(list) do
		local single = include("commonItemAward").new()
		single:setScale(0.7)
		single:setBaseScale(1.0)
		single:setOwnView(self)
		single:setPositionY(0)
		single:addTo(self.nodeAward)
		single:initData(v.id, v.count)
	end
end
function summerPrayersSuccessView:createItemFun()
	return self.nodeSingle:clone()
end
function summerPrayersSuccessView:refreshItemFun(target, data)
	local imageIcon = SoraDGetChildByName(target, "Image_Box")
	local textNum = SoraDGetChildByName(target, "Text_Num")
	print("jsdhfjsdh", data.id)
	imageIcon:loadTexture(publicRead.getIcon(data.id), ccui.TextureResType.plistType)
	textNum:setString(string.format("x%d", data.count))
end
function summerPrayersSuccessView:btnClickSure(target, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		print("data.id")
		self:layerClickCallBack(self, eventType)
	end
end
function summerPrayersSuccessView:onClose(eType)
	if eType == MSGBOX_CALLBACK_CANCEL and not self.first then
		self.first = true
		_ENV = nil
		;(nil).msg = "MESSAGE_SUMMER_PRAY_VIEW"
		;(nil).subMsg = "updateView"
		SoraDSendMessage(nil)
	end
end
return summerPrayersSuccessView
