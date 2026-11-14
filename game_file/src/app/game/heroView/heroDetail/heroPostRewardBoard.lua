local gametop = gModuleMgr.getObject("gametop")
local heroJailCtrl = gametop.playertop_:getModule("heroJailCtrl")
local cityCtrl = gametop.playertop_:getModule("cityCtrl")
local publicRead = include("publicRead")
local HeroPostRewardBoard = class("heroPostRewardBoard", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("heroPostRewardBoard")
	end
	return target
end)
function HeroPostRewardBoard:ctor()
	self.resNodes, _ENV, self.scaleActTarget = SoraDGetChildByName(self, "Center_Node"), SoraDGetChildByName(self, "Center_Node"), SoraDGetChildByName(self, "Center_Node")
	self.curResId = gHeroRewardRansomMaxMoney[1]
	self.minResNum = 0
	self.nodeMain = SoraDGetChildByName(self, "Center_Node")
	self.ccs_bg = SoraDGetExtendChildFromCCSByName(self, "CCS_commonPopBox_bg")
	self.ccs_bg:setTitleName(i18n("hero_btn_02"))
	self.txtFieldNum = SoraDGetChildByName(self, "TextField_num")
	self.txtFieldNum:setPlaceHolder(tostring(gHeroRewardRansomMinMoney))
	self.txtFieldNum:setString(tostring(gHeroRewardRansomMinMoney))
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
	SoraDGetChildByName(self, "Text_selectTip"):setString(i18n("hero_text_20"))
	SoraDGetChildByName(self, "Text_moneyTip"):setString(i18n("hero_text_19"))
	SoraDGetChildByName(self, "Text_realGainTip"):setString(i18n("prison_text_16"))
	_ENV = i18n("prison_text_16")
	i18n("prison_text_16").tax = gHeroRansomTax * 100
	self.txtTax:setString(i18n("hero_text_21", i18n("prison_text_16")))
	self:initRes()
end
function HeroPostRewardBoard:changeToEditBox()
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
function HeroPostRewardBoard:OnEditBoxTouch(target, type)
	if type == ccui.TouchEventType.ended then
		target:touchDownAction(target, type)
	end
end
function HeroPostRewardBoard:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_SERVER_HEROJAIN_REWARDSUCCESS", function(target, redata)
		SoraDShowMsgTip(i18n("hero_text_55"))
		self:removeFromParent()
	end)
	SoraDAddMessage(self, "MESSAGE_SERVER_HEROJAIN_SERVERNORMALFAIL", function(...)
		SoraDCloseLoading(self)
	end)
end
function HeroPostRewardBoard:initRes(...)
	for i, v in ipairs(gHeroRansomRes) do
		local res = self.nodeRes:clone()
		res:addTo(self.nodeMain)
		res:setPosition(SoraDFSign(#gHeroRansomRes * 110 / 2 - (i - 1) * 110 - 55.0), 60)
		res:getChildByName("Image_res"):loadTexture(publicRead.getIcon(v), ccui.TextureResType.plistType)
		res:getChildByName("Button_touch"):setTag(v)
		res:getChildByName("Button_touch"):addTouchEventListener(handler(self, self.resClick))
		res:setColor(cc.c3b(125, 125, 125))
		self.resNodes[v] = res
	end
end
function HeroPostRewardBoard:lightItem(itemNode)
	for _, v in pairs(self.resNodes) do
		if itemNode == v then
			v:setColor(cc.c3b(255, 255, 255))
		else
			v:setColor(cc.c3b(125, 125, 125))
		end
	end
end
function HeroPostRewardBoard:chooseRes(tag)
	self.curResId = tag
	local curResNode = self.resNodes[self.curResId]
	self.spLight:setPosition(curResNode:getPositionX() - 1, curResNode:getPositionY() + 1.5)
	self:lightItem(curResNode)
	self.spRealRes:setSpriteFrame(publicRead.getSmallIcon(self.curResId))
end
function HeroPostRewardBoard:resClick(button, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		print("tag=", button:getTag())
		self:chooseRes(button:getTag())
	end
end
function HeroPostRewardBoard:initData(jailInfo)
	self.heroJailInfo = jailInfo
	if next(self.heroJailInfo.rewardData) then
		self.lockRes = self.heroJailInfo.rewardData.id
		self.lockNum = self.heroJailInfo.rewardData.num
	end
	self:initView()
end
function HeroPostRewardBoard:initView(...)
	dump(self.heroJailInfo, "self.heroJailInfo")
	if self.lockRes then
		self:chooseRes(self.lockRes)
		for _, v in pairs(self.resNodes) do
			v:getChildByName("Button_touch"):addTouchEventListener(function(button, eventType)
				if eventType == ccui.TouchEventType.ended then
					SoraDPlaySound()
					SoraDShowMsgTip(i18n("hero_text_56"))
				end
			end)
		end
	else
		self:chooseRes(gIDDef.FOOD)
	end
	if self.lockNum then
		self.minResNum = self.lockNum
		self.txtFieldNum:setText(self.minResNum)
	end
	self:textFieldChange("return", self.txtFieldNum)
end
function HeroPostRewardBoard:btnOkClick(button, eventType)
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
		elseif resNum < self.minResNum then
			_ENV = i18n("hero_text_58")
			i18n("hero_text_58").num = self.minResNum
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
		local resCount = math.floor(cityCtrl:getResCount(self.curResId))
		local safeNum = math.floor(cityCtrl:getSafeRes(self.curResId))
		local resCurNum = resCount - safeNum
		if resNum > resCurNum then
			SoraDShowMsgTip(i18n("hero_text_90"))
			return
		end
		SoraDShowMsgBox(i18n("hero_text_22"), i18n("common_text_204"), nil, function(msgType)
			if msgType == MSGBOX_CALLBACK_YES then
				SoraDShowLoading(self)
				_ENV = SoraDShowLoading
				SoraDShowLoading.id = self.curResId
				local SoraDShowLoading.num, resList = resNum, SoraDShowLoading
				heroJailCtrl:reqOfferReward(self.heroJailInfo.heroID, self.heroJailInfo.wardenUid, resList)
			end
		end)
	end
end
function HeroPostRewardBoard:textFieldChange(event, editBox)
	if event == "began" then
	elseif event == "changed" then
	elseif event == "ended" or event == "return" then
		local inputText = editBox:getText()
		local num = tonumber(inputText) or 0
		self.txtFieldNum:setText(num)
		self.txtRealGain:setString(string.formatnumberthousands(math.floor(num * (1 - gHeroRansomTax))))
	end
end
return HeroPostRewardBoard
