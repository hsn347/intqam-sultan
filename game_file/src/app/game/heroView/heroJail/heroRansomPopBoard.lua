local gametop = gModuleMgr.getObject("gametop")
local heroJailCtrl = gametop.playertop_:getModule("heroJailCtrl")
local publicRead = include("publicRead")
local HeroRansomPopBoard = class("heroRansomPopBoard", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("heroRansomPopBoard")
	end
	return target
end)
function HeroRansomPopBoard:ctor()
	self.resNodes, _ENV, self.scaleActTarget = SoraDGetChildByName(self, "Center_Node"), SoraDGetChildByName(self, "Center_Node"), SoraDGetChildByName(self, "Center_Node")
	self.curResId = nil
	self.nodeMain = SoraDGetChildByName(self, "Center_Node")
	self.ccs_bg = SoraDGetExtendChildFromCCSByName(self, "CCS_commonPopBox_bg")
	self.ccs_bg:setTitleName(i18n("prison_btn_03"))
	self.txtFieldNum = SoraDGetChildByName(self, "TextField_num")
	self.txtFieldNum:setPlaceHolder(tostring(gHeroRewardRansomMinMoney))
	self.txtFieldNum:setString(gHeroRewardRansomMinMoney)
	self.txtFieldNum:addEventListener(handler(self, self.textFieldChange))
	self:changeToEditBox()
	self.nodeRes = SoraDGetChildByName(self, "Node_item")
	self.txtTax = SoraDGetChildByName(self, "Text_tax")
	self.txtRealGain = SoraDGetChildByName(self, "Text_realGain")
	self.spRealRes = SoraDGetChildByName(self, "Sprite_realRes")
	self.spLight = SoraDGetChildByName(self, "Image_selected")
	self.btnOk = SoraDGetChildByName(self, "Button_ok")
	self.btnOk:setTitleText(i18n("common_text_204"))
	self.btnOk:addTouchEventListener(handler(self, self.btnOkClick))
	SoraDGetChildByName(self, "Text_selectTip"):setString(i18n("prison_text_15"))
	SoraDGetChildByName(self, "Text_moneyTip"):setString(i18n("prison_text_13"))
	SoraDGetChildByName(self, "Text_realGainTip"):setString(i18n("prison_text_16"))
	_ENV = i18n("prison_text_16")
	i18n("prison_text_16").tax = gHeroRansomTax * 100
	self.txtTax:setString(i18n("hero_text_21", i18n("prison_text_16")))
	self:initRes()
end
function HeroRansomPopBoard:changeToEditBox()
	if self.txtFieldNum then
		local size = self.txtFieldNum:getContentSize()
		local pos = cc.p(self.txtFieldNum:getPositionX(), self.txtFieldNum:getPositionY())
		local ap = self.txtFieldNum:getAnchorPoint()
		local editBox = ccui.EditBox:create(size, "bg_transparent.png", ccui.TextureResType.plistType)
		editBox:setPosition(pos)
		editBox:setAnchorPoint(ap)
		editBox:setFontColor(display.COLOR_BLACK)
		if self.txtFieldNum:getMaxLength() > 0 then
			editBox:setMaxLength(self.txtFieldNum:getMaxLength())
		end
		editBox:addTouchEventListener(handler(self, self.OnEditBoxTouch))
		editBox:addTo(self.txtFieldNum:getParent())
		editBox:registerScriptEditBoxHandler(handler(self, self.textFieldChange))
		editBox:setInputMode(2)
		editBox:setText(self.txtFieldNum:getString())
		self.txtFieldNum:removeFromParent()
		self.txtFieldNum = editBox
	end
end
function HeroRansomPopBoard:OnEditBoxTouch(target, type)
	if type == ccui.TouchEventType.ended then
		target:touchDownAction(target, type)
	end
end
function HeroRansomPopBoard:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_SERVER_HEROJAIN_SETRANSOMSUCCESS", function(target, redata)
		SoraDShowMsgTip(i18n("hero_text_89"))
		self:removeFromParent()
	end)
end
function HeroRansomPopBoard:initRes(...)
	for i, v in ipairs(gHeroRansomRes) do
		local res = self.nodeRes:clone()
		res:addTo(self.nodeMain)
		res:setPosition(SoraDFSign(#gHeroRansomRes * 110 / 2 - (i - 1) * 110 - 55.0), 60)
		res:getChildByName("Image_res"):loadTexture(publicRead.getIcon(v), ccui.TextureResType.plistType)
		res:getChildByName("Button_touch"):setTag(v)
		res:getChildByName("Button_touch"):addTouchEventListener(handler(self, self.resClickBack))
		res:setColor(cc.c3b(125, 125, 125))
		self.resNodes[v] = res
	end
	self:resClick(gHeroRansomRes[1])
end
function HeroRansomPopBoard:lightItem(itemNode)
	for _, v in pairs(self.resNodes) do
		if itemNode == v then
			v:setColor(cc.c3b(255, 255, 255))
		else
			v:setColor(cc.c3b(125, 125, 125))
		end
	end
end
function HeroRansomPopBoard:resClick(tag)
	print("tag", tag)
	local fNode = self.resNodes[tag]
	self.curResId = tag
	self.spLight:setPosition(fNode:getPositionX() - 1, fNode:getPositionY() + 1.5)
	self:lightItem(fNode)
	self.spRealRes:setSpriteFrame(publicRead.getSmallIcon(self.curResId))
end
function HeroRansomPopBoard:resClickBack(button, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		self:resClick(button:getTag())
	end
end
function HeroRansomPopBoard:initData(flagID)
	self.heroFlagID = flagID
	self.heroInfo = heroJailCtrl:getHerosInMyPrisonByID(self.heroFlagID)
	self:initView()
end
function HeroRansomPopBoard:initView(...)
	if self.heroInfo.ransomData and next(self.heroInfo.ransomData) then
		self:resClick(self.heroInfo.ransomData.id)
		self.txtFieldNum:setText(self.heroInfo.ransomData.num)
	end
	self:textFieldChange("return", self.txtFieldNum)
end
function HeroRansomPopBoard:btnOkClick(button, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		self:textFieldChange("ended", self.txtFieldNum)
		if not self.curResId then
			SoraDShowMsgTip(i18n("hero_text_57"))
			return
		end
		local resNum = tonumber(self.txtFieldNum:getText())
		if not resNum then
			SoraDShowMsgTip(i18n("hero_text_58"))
			return
		elseif resNum <= 0 then
			_ENV = i18n("hero_text_58")
			i18n("hero_text_58").num = "0"
			SoraDShowMsgTip(i18n("hero_text_59", i18n("hero_text_58")))
			return
		elseif resNum > gHeroRewardRansomMaxMoney[self.curResId] then
			_ENV = i18n("hero_text_59", i18n("hero_text_58"))
			i18n("hero_text_59", i18n("hero_text_58")).num = string.formatnumberthousands(gHeroRewardRansomMaxMoney[self.curResId])
			SoraDShowMsgTip(i18n("hero_text_60", i18n("hero_text_59", i18n("hero_text_58"))))
			return
		elseif resNum < gHeroRewardRansomMinMoney then
			_ENV = i18n("hero_text_60", i18n("hero_text_59", i18n("hero_text_58")))
			i18n("hero_text_60", i18n("hero_text_59", i18n("hero_text_58"))).num = string.formatnumberthousands(gHeroRewardRansomMinMoney)
			SoraDShowMsgTip(i18n("hero_text_61", i18n("hero_text_60", i18n("hero_text_59", i18n("hero_text_58")))))
			return
		end
		SoraDShowLoading(self)
		_ENV = SoraDShowLoading
		SoraDShowLoading.id = self.curResId
		local SoraDShowLoading.num, resList = resNum, SoraDShowLoading
		heroJailCtrl:reqSetRansom(self.heroInfo.heroID, self.heroInfo.ownerUid, resList)
	end
end
function HeroRansomPopBoard:textFieldChange(event, editBox)
	if event == "began" then
	elseif event == "changed" then
	elseif event == "ended" or event == "return" then
		local inputText = editBox:getText()
		local num = tonumber(inputText) or 0
		self.txtFieldNum:setText(num)
		self.txtRealGain:setString(string.formatnumberthousands(math.floor(num * (1 - gHeroRansomTax))))
	end
end
return HeroRansomPopBoard
