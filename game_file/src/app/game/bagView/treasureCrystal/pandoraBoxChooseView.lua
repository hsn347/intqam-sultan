local gametop = gModuleMgr.getObject("gametop")
local backpackCtrl = gametop.playertop_:getModule("backpackCtrl")
local treasureCrystalRead = include("treasureCrystalRead")
local timeLimitedItemCtrl = SoraDGetCtrl("timeLimitedItemCtrl")
local pandoraBoxChooseView = class("pandoraBoxChooseView", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("pandoraBoxChooseView")
	end
	return target
end)
local MAXTASK = 5
function pandoraBoxChooseView:ctor()
	self.chooseType = nil
	self.titleItemName = SoraDGetChildByName(self, "Text_Title")
	self.btnClose = SoraDGetChildByName(self, "Button_Close")
	self.textBoxExplain = SoraDGetChildByName(self, "Text_BoxInfo")
	self.textGetCrystal = SoraDGetChildByName(self, "Text_CryStal")
	self.textGetMine = SoraDGetChildByName(self, "Text_Mine")
	self.textLeftExplain = SoraDGetChildByName(self, "Top_LeftText_Explain")
	self.textRightExplain = SoraDGetChildByName(self, "Top_RightText_Explain")
	self.imageBoxIcon = SoraDGetChildByName(self, "Image_PandoraBox")
	self.btnChoose = SoraDGetChildByName(self, "Button_Choose")
	self.leftChoose = SoraDGetChildByName(self, "Top_Left_Node")
	self.rightChoose = SoraDGetChildByName(self, "Top_Right_Node")
	SoraDMixtureGLONEByParent(self.rightChoose)
	SoraDMixtureGLONEByParent(self.leftChoose)
	self.btnLeftChoose = SoraDGetChildByName(self.leftChoose, "Button_go")
	self.btnLeftChoose:setTag(gPandoraBoxUseEffect.GET_TREASURE_CRYSTAL)
	self.btnRightChoose = SoraDGetChildByName(self.rightChoose, "Button_go")
	self.btnRightChoose:setTag(gPandoraBoxUseEffect.GET_REWARD)
	self.btnLeftChoose:addTouchEventListener(handler(self, self.btnClickChooseAward))
	self.btnRightChoose:addTouchEventListener(handler(self, self.btnClickChooseAward))
	self.titleItemName:setString(i18n("treasure_crystal_title_03"))
	self.textBoxExplain:setString(i18n("treasure_crystal_text_14"))
	self.textGetCrystal:setString(i18n("treasure_crystal_title_04"))
	self.textGetMine:setString(i18n("treasure_crystal_title_05"))
	self.textLeftExplain:setString(i18n("treasure_crystal_text_16"))
	self.textRightExplain:setString(i18n("treasure_crystal_text_18"))
	self.btnChoose:setTitleText(i18n("treasure_crystal_btn_02"))
	self.btnChoose:addTouchEventListener(handler(self, self.btnClickChoose))
	self.btnChoose:setBright(false)
	self.btnClose:addTouchEventListener(handler(self, self.close))
	self.singleItem = SoraDGetChildByName(self.rightChoose, "single_Award")
	self.singleItem:setVisible(false)
	self.topNode = SoraDGetChildByName(self, "Top_Node")
	self:initAnimation()
	self:fitView()
end
function pandoraBoxChooseView:setItemData(itemID, limitedData)
	self.itemID = itemID
	self.limitedTime = limitedData.dataFromItem.isLimitedItem
	self.index = limitedData.dataFromItem.pandoraIndex
	self.pandoraBoxData = timeLimitedItemCtrl:getPandoraBoxData(self.itemID, self.limitedTime, self.index)
	if not self.pandoraBoxData.reward then
		timeLimitedItemCtrl = self.pandoraBoxData.reward
	end
	self.awardInfo = self.pandoraBoxData.reward
	dump(self.pandoraBoxData, "pandoraBoxData", 10)
	self:judgeClose()
	self:initAwards()
end
function pandoraBoxChooseView:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_ITEM_UES_FROM_BAG_BACK", handler(self, self.judgeClose))
end
function pandoraBoxChooseView:fitView()
	local scale = self:getPanelOffsetHeight() / 1136
	scale = 1 < scale and 1 or scale
	self.pandoraBoxEffect:setScale(1 < scale and 1 or scale)
	self.pandoraBoxNEffect:setScale(1 < scale and 1 or scale)
	if self:getPanelOffsetHeight() <= 960 then
		SoraDGetChildByName(self, "Center_Node"):setScale(self:getPanelOffsetHeight() / 960)
		self.pandoraBoxEffect:setPositionY(-150 - (1 - scale) * 135)
		self.pandoraBoxNEffect:setPositionY(-150 - (1 - scale) * 135)
	end
	local height = (self:getPanelOffsetHeight() - 960) / 2
	height = 88 <= height and 88 or 0
	self.topNode:setPositionY(self.topNode:getPositionY() + height / 2)
	self.pandoraBoxEffect:setPositionY(self.pandoraBoxEffect:getPositionY() - height)
	self.pandoraBoxNEffect:setPositionY(self.pandoraBoxNEffect:getPositionY() - height)
	SoraDGetChildByName(self, "Down_Node"):setPositionY(-height)
end
function pandoraBoxChooseView:initAnimation()
	self.pandoraBoxNEffect = SoraDCreatAnimationEx("pandoraBoxNEffect", nil, false)
	self.pandoraBoxNEffect:setPosition(0, -150)
	self.pandoraBoxNEffect:setVisible(false)
	self.pandoraBoxNEffect.action:gotoFrameAndPause(0)
	SoraDMixtureGLONEByParent(self.pandoraBoxNEffect)
	self.topNode:addChild(self.pandoraBoxNEffect, 0, "pandoraBoxNEffect")
	self.pandoraBoxEffect = SoraDCreatAnimationEx("pandoraBoxEffect", nil, false)
	self.pandoraBoxEffect:setPosition(0, -150)
	SoraDMixtureGLONEByParent(self.pandoraBoxEffect)
	self.topNode:addChild(self.pandoraBoxEffect, -1, "pandoraBoxEffect")
	local action = self.pandoraBoxEffect.action
	action:gotoFrameAndPlay(0, false)
	if action and tolua.cast(action, "cc.Action") then
		action:setFrameEventCallFunc(handler(self, self.pandoraEffectCallBack))
	end
	self.pandoraSelectEffect = SoraDCreatAnimationEx("pandoraSelectEffect", nil, true)
	self.pandoraSelectEffect:setPosition(160, -623)
	self.pandoraSelectEffect:setVisible(false)
	SoraDMixtureGLONEByParent(self.pandoraSelectEffect)
	SoraDGetChildByName(self, "Down_Node"):addChild(self.pandoraSelectEffect, 999, "pandoraSelectEffect")
end
function pandoraBoxChooseView:initAwards()
	local nums = table.nums(self.awardInfo)
	local beginPosX = (SoraDFIsRA() and 1 or -1) * 45 * (3 < nums and 2 or nums - 1)
	local beginPosY = -240
	local offSetX = SoraDFIsRA() and -90 or 90
	for i = 1, nums do
		local single = self.singleItem:clone()
		single = include("commonItemAward").new(single)
		single:setScale(0.8)
		single:setOwnView(self)
		single:setVisible(true)
		single:setPosition(beginPosX + offSetX * ((i - 1) % 3), beginPosY + 90 * math.floor((i - 1) / 3))
		single:addTo(self.singleItem:getParent())
		single:initData(self.awardInfo[i].id, self.awardInfo[i].count)
	end
end
function pandoraBoxChooseView:btnClickChoose(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if self.chooseType then
			_ENV = nil
			;(nil).time = self.limitedTime
			;(nil).effect = self.chooseType
			;(nil).idx = self.index
			backpackCtrl:reqUseItem(self.itemID, 1, nil)
			self:close(self, type)
		else
			SoraDShowMsgTip(i18n("treasure_crystal_text_20"))
		end
	end
end
function pandoraBoxChooseView:btnClickChooseAward(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		self.chooseType = button:getTag()
		self.btnChoose:setBright(true)
		self.pandoraSelectEffect:setVisible(true)
		self:changeAnimation(button:getParent(), true)
		if self.chooseType == gPandoraBoxUseEffect.GET_TREASURE_CRYSTAL then
			self:changeAnimation(self.rightChoose, false)
			self.pandoraSelectEffect:setPositionX(-160)
		else
			self:changeAnimation(self.leftChoose, false)
			self.pandoraSelectEffect:setPositionX(160)
		end
	end
end
function pandoraBoxChooseView:changeAnimation(parent, isShow)
	local texPdmlh9 = SoraDGetChildByName(parent, "G_dh_Tex_pdlmh_009")
	local texPdmlh6 = SoraDGetChildByName(parent, "G_dh_Tex_pdlmh_006")
	local texPdmlh7 = SoraDGetChildByName(parent, "G_dh_Tex_pdlmh_007")
	local texPdmlh8 = SoraDGetChildByName(parent, "G_dh_Tex_pdlmh_008")
	texPdmlh9:setOpacity(0)
	texPdmlh6:setOpacity(0)
	texPdmlh8:setOpacity(255)
	texPdmlh7:setOpacity(0)
	if isShow then
		_UPVALUE1_ = nil
		;(nil)[1] = cca.fadeTo(0.16666666666666666, 0.2)
		;(nil)[2] = cca.fadeTo(0.4166666666666667, 0)
		;(nil)[3] = cca.fadeTo(0.4166666666666667, 0)
		;(nil)[4] = cca.fadeTo(0.4166666666666667, 0)
		;(nil)[5] = cca.fadeTo(0.4166666666666667, 0)
		;(nil)[6] = cca.fadeTo(0.4166666666666667, 0)
		;(nil)[7] = cca.fadeTo(0.4166666666666667, 0)
		texPdmlh9:runAction(cca.seq(nil))
		_UPVALUE3_ = cca.seq(nil)
		cca.seq(nil)[1] = cca.fadeTo(0.36666666666666664, 0.3)
		cca.seq(nil)[2] = cca.fadeTo(0.36666666666666664, 0.15)
		cca.seq(nil)[3] = cca.fadeTo(0.36666666666666664, 0.3)
		cca.seq(nil)[4] = cca.fadeTo(0.36666666666666664, 0)
		cca.seq(nil)[5] = cca.fadeTo(0.36666666666666664, 0)
		cca.seq(nil)[6] = cca.fadeTo(0.36666666666666664, 0)
		texPdmlh6:runAction(cca.repeatForever(cca.seq(cca.seq(nil))))
		_UPVALUE1_ = cca.repeatForever(cca.seq(cca.seq(nil)))
		cca.repeatForever(cca.seq(cca.seq(nil)))[1] = cca.fadeTo(0.75, 0)
		cca.repeatForever(cca.seq(cca.seq(nil)))[2] = cca.fadeTo(0.75, 1)
		cca.repeatForever(cca.seq(cca.seq(nil)))[3] = cca.fadeTo(0.75, 1)
		cca.repeatForever(cca.seq(cca.seq(nil)))[4] = cca.fadeTo(0.75, 1)
		cca.repeatForever(cca.seq(cca.seq(nil)))[5] = cca.fadeTo(0.75, 1)
		cca.repeatForever(cca.seq(cca.seq(nil)))[6] = cca.fadeTo(0.75, 1)
		texPdmlh8:runAction(cca.repeatForever(cca.seq(cca.repeatForever(cca.seq(cca.seq(nil))))))
		_UPVALUE1_ = cca.repeatForever(cca.seq(cca.repeatForever(cca.seq(cca.seq(nil)))))
		cca.repeatForever(cca.seq(cca.repeatForever(cca.seq(cca.seq(nil)))))[1] = cca.fadeTo(0.75, 1)
		cca.repeatForever(cca.seq(cca.repeatForever(cca.seq(cca.seq(nil)))))[2] = cca.fadeTo(0.75, 0)
		cca.repeatForever(cca.seq(cca.repeatForever(cca.seq(cca.seq(nil)))))[3] = cca.fadeTo(0.75, 0)
		cca.repeatForever(cca.seq(cca.repeatForever(cca.seq(cca.seq(nil)))))[4] = cca.fadeTo(0.75, 0)
		cca.repeatForever(cca.seq(cca.repeatForever(cca.seq(cca.seq(nil)))))[5] = cca.fadeTo(0.75, 0)
		cca.repeatForever(cca.seq(cca.repeatForever(cca.seq(cca.seq(nil)))))[6] = cca.fadeTo(0.75, 0)
		texPdmlh7:runAction(cca.repeatForever(cca.seq(cca.repeatForever(cca.seq(cca.repeatForever(cca.seq(cca.seq(nil))))))))
	else
		texPdmlh9:stopAllActions()
		texPdmlh8:stopAllActions()
		texPdmlh6:stopAllActions()
		texPdmlh7:stopAllActions()
		texPdmlh8:setOpacity(0)
	end
end
function pandoraBoxChooseView:pandoraEffectCallBack(frameEventName)
	local frameEvent = frameEventName:getEvent()
	if frameEvent and frameEvent == "BEGIN_END" then
		self.pandoraBoxNEffect:setOpacity(0)
		self.pandoraBoxNEffect:runAction(cca.fadeTo(0.7, 1))
		self.pandoraBoxNEffect.action:gotoFrameAndPlay(0, 112, true)
		self.pandoraBoxNEffect:setVisible(true)
	end
end
function pandoraBoxChooseView:judgeClose()
	if nil == next(timeLimitedItemCtrl:getPandoraBoxData(self.itemID, self.limitedTime, self.index)) then
		self:close(self, ccui.TouchEventType.ended)
	end
end
return pandoraBoxChooseView
