local baseComponent = require("fgui.base.baseComponent")
local Com_FP_MainView = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://ForeignPavilion/Com_FP_MainView", Com_FP_MainView)
local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
local exoticPavilionCtrl = SoraDGetCtrl("exoticPavilionCtrl")
function Com_FP_MainView:onInit()
	if not SoraDFIsRA() then
		self:fixChildrenPos(false, true)
	end
	self.fields.btn_details:addClickEventListener(handler(self, self.detailsClick))
	self.fields.btn_chat:addClickEventListener(handler(self, self.chatClick))
	self.fields.btn_reward:addClickEventListener(handler(self, self.rewardClick))
	self.fields.btn_game:addClickEventListener(handler(self, self.gameClick))
	self.fields.btn_dress:addClickEventListener(handler(self, self.dressClick))
	self.fields.btn_gift:addClickEventListener(handler(self, self.giftClick))
	self.fields.btn_reward:setTitle(i18n("common_text_785"))
	self.fields.btn_game:setTitle(i18n("exitic_pavillion_text_0063"))
	self.fields.btn_gift:setTitle(i18n("exitic_pavillion_text_0065"))
	self.fields.btn_dress:setTitle(i18n("exitic_pavillion_text_0064"))
	self.fields.btn_details:setTitle(i18n("exitic_pavillion_text_0039"))
	self.fields.btn_game:setIcon("icon_ygg_zhuye_01.png")
	self.fields.btn_gift:setIcon("icon_ygg_zhuye_02.png")
	self.fields.btn_dress:setIcon("icon_ygg_zhuye_03.png")
	self.fields.btn_details:setIcon("icon_ygg_zhuye_04.png")
	self.chatEffect1 = fguiHelper.get_fields(self.fields.btn_chat).show
	self.chatEffect1:setAllFrameName("dh_ax_cx_%02d.png", 1)
	self.chatEffect2 = fguiHelper.get_fields(self.fields.btn_chat).loop
	self.chatEffect2:setAllFrameName("dh_ax_xh_%02d.png", 1)
end
function Com_FP_MainView:onShow()
	self.firstIn = true
	self:showChat(i18n("exitic_pavillion_text_0062"))
end
function Com_FP_MainView:showChatBtnAction()
	self.fields.btn_chat:stopAllActions()
	local seq = ffa.seq(ffa.delay(2), ffa.rotateTo(0.25, 10), ffa.rotateTo(0.21666666666666667, -10), ffa.rotateTo(0.2, 8), ffa.rotateTo(0.16666666666666666, -5), ffa.rotateTo(0.15, 2), ffa.rotateTo(0.15, 0))
	self.fields.btn_chat:setRotation(0)
	self.fields.btn_chat:runAction(ffa.repeatForever(seq))
	if not exoticPavilionCtrl:getIsChatCanAdd() then
		self.chatEffect1:setPlaySettings(0, -1, 1)
	else
		self.chatEffect2:setAlpha(0)
		self.chatEffect2:stopAllActions()
		self.chatEffect1:setPlaySettings(0, -1, 1, -1, function()
			self.chatEffect2:setPlaySettings(0, -1, 0)
			self.chatEffect2:runAction(ffa.fadeIn(0.33))
		end)
	end
end
function Com_FP_MainView:updateView()
	local curStage = exoticPavilionCtrl:getCurStage()
	local curStep = exoticPavilionCtrl:getCurStep()
	if not self:isVisible() and curStage == 2 then
		self:showChat(i18n("exitic_pavillion_text_0062"))
	end
	if curStage ~= 2 then
		return false
	end
	local isShowFinger = gModuleMgr.sharedMgr("mildGuideManager"):getVariate("ForeignPavilionActivity", "isFromTask")
	if isShowFinger then
		exoticPavilionCtrl = i18n("exitic_pavillion_text_0062")
		exoticPavilionCtrl, i18n("exitic_pavillion_text_0062").z = i18n("exitic_pavillion_text_0062")
		i18n("exitic_pavillion_text_0062").x = 0
		i18n("exitic_pavillion_text_0062").offset, i18n("exitic_pavillion_text_0062").y = i18n("exitic_pavillion_text_0062")
		gModuleMgr.sharedMgr("mildGuideManager"):drawFingerToTarget(self.fields.btn_reward, i18n("exitic_pavillion_text_0062"))
	end
	self.curIntimacyLv = exoticPavilionCtrl:getCurIntimacyLv()
	self.isCanUp = self.fields.intimacy:updateData()
	local isGotReward = exoticPavilionCtrl:getIsGetDailyReward()
	self.fields.btn_reward:setIcon(not isGotReward and "frame_ygg_deng_kelingqu.png" or "frame_ygg_deng_yilingqu.png")
	self.fields.btn_reward:setTitle(i18n(isGotReward and "common_text_1892" or "common_text_785"))
	local lightAni = fguiHelper.get_fields(self.fields.btn_reward).light
	lightAni:setVisible(not isGotReward)
	if not isGotReward then
		lightAni:setAllFrameName("G_ygg_light_%02dsd.png", 1)
		lightAni:setPlaySettings(0, -1, -1)
	end
	local fields = fguiHelper.get_fields(self.fields.btn_reward)
	fields.title:setGrayed(isGotReward)
	local gameLastNum = exoticPavilionCtrl:getLastGameCount()
	fguiHelper.get_fields(self.fields.btn_game).redpoint:setVisible(1 <= gameLastNum)
	fguiHelper.get_fields(self.fields.btn_game).red_num:setString(1 <= gameLastNum and gameLastNum or "")
	local giftItemNUm = exoticPavilionCtrl:getGiftNum()
	fguiHelper.get_fields(self.fields.btn_gift).redpoint:setVisible(1 <= giftItemNUm)
	fguiHelper.get_fields(self.fields.btn_gift).red_num:setString(99 < giftItemNUm and "99+" or 1 <= giftItemNUm and giftItemNUm or "")
	self.fields.role:updateRole(exoticPavilionCtrl:getCurDressLv(), self.firstIn)
	self.firstIn = false
	self.fields.Usm_1:setBlendFunc(gl.ONE, gl.SRC_ALPHA)
	self.fields.Usm_1:setEffectPath("G_ygg_daiji1.usm", true)
	return true
end
function Com_FP_MainView:detailsClick(sender, params)
	SoraDPlaySound()
	uiManager:show("ForeignNpcIntroduction")
end
function Com_FP_MainView:chatClick(sender, params)
	SoraDPlaySound()
	self:showChat(5, self.curIntimacyLv)
end
function Com_FP_MainView:rewardClick(sender, params)
	SoraDPlaySound()
	uiManager:show("ForeignPReward")
	gModuleMgr.sharedMgr("mildGuideManager"):clean()
end
function Com_FP_MainView:intimacyClick(sender, params)
	SoraDPlaySound()
	uiManager:show("ForeignPIntimacy")
end
function Com_FP_MainView:gameClick(sender, params)
	SoraDPlaySound()
	uiManager:show("ForeignPGameChoose")
end
function Com_FP_MainView:attributeClick(sender, params)
	SoraDPlaySound()
end
function Com_FP_MainView:dressClick(sender, params)
	SoraDPlaySound()
	uiManager:show("ForeignPDress")
end
function Com_FP_MainView:giftClick(sender, params)
	SoraDPlaySound()
	uiManager:show("ForeignPGift")
end
function Com_FP_MainView:showChat(type1OrChatStr, type2)
	self.fields.btn_chat:setVisible(false)
	if type(type1OrChatStr) == "string" then
		self.fields.role:showChat(type1OrChatStr, nil, function()
			self:showChatBtnAction()
			self.fields.btn_chat:setVisible(true)
		end)
	else
		self.fields.role:setChat(type1OrChatStr, type2, nil, function()
			self:showChatBtnAction()
			self.fields.btn_chat:setVisible(true)
		end)
	end
end
function Com_FP_MainView:onChatAddIntimacy()
	self.fields.intimacy:addHeartShow(function()
		self:updateView()
	end, self.fields.btn_chat)
end
return Com_FP_MainView
