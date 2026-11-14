local allianceScience = SoraDGetCtrl("allianceScience")
local memberMgr = SoraDGetCtrl("memberMgr")
local allianceMgr = SoraDGetCtrl("allianceMgr")
local constantRead = include("constantRead")
local allianceProsperityView = class("allianceProsperityView", function(target)
	if target == nil then
		return SoraDCreateBasePanel("allianceProsperityView")
	end
	return target
end)
function allianceProsperityView:ctor()
	self:initWidget()
	self:fitDevice()
	self:initData()
end
function allianceProsperityView:initWidget()
	SoraDGetAllChildFromWidget(self._ccsView, self)
	SoraDCreatAnimation(self.__cname, self, true)
	self.nodeTitle = SoraDGetExtendChildFromCCSByName(self, "CCS_commonFramTitle")
	self.nodeTitle:setTitle(i18n("common_text_191"))
	self.Text_reward:setString(i18n("common_text_2078"))
	self.Text_bonus:setString(i18n("common_text_473"))
	self.Text_prosperity:setString(i18n("alliance_prosperity_text_12"))
	local addValue = constantRead.getConstValue("ADD_PROSPERITY_EVERY_TIME", 10)
	_ENV = i18n("alliance_prosperity_text_12")
	i18n("alliance_prosperity_text_12").num = addValue
	self.Text_tips:setString(i18n("alliance_prosperity_text_18", i18n("alliance_prosperity_text_12")))
	self.Button_question:addTouchEventListener(handler(self, self.btnHelpCallback))
	self.Button_reward:addTouchEventListener(handler(self, self.btnRewardCallback))
	self.Button_bonus:addTouchEventListener(handler(self, self.btnBonusCallback))
	self.Button_donate:setTitleText(i18n("common_text_284"))
	SoraDAutoSizeButtonTextByContent(self.Button_donate)
	self.Button_donate:addTouchEventListener(handler(self, self.btnDonateCallback))
	self.ccs_tab = SoraDGetExtendChildFromCCSByName(self, "CCS_commonTabBtn_btns")
	_ENV = "CCS_commonTabBtn_btns"
	;("CCS_commonTabBtn_btns").tabNum = 2
	_ENV, _ENV, ("CCS_commonTabBtn_btns").defaultClick = handler(self, self.btnDonateCallback)
	handler(self, self.btnDonateCallback).title = i18n("alliance_prosperity_text_23")
	_ENV, handler(self, self.btnDonateCallback)[1], handler(self, self.btnDonateCallback).handle = handler(self, self.btnDonateCallback)
	handler(self, self.btnDonateCallback).title = i18n("alliance_prosperity_text_12")
	;("CCS_commonTabBtn_btns").tabsetArray, handler(self, self.btnDonateCallback)[2], handler(self, self.btnDonateCallback).handle = handler(self, self.btnDonateCallback)
	self.ccs_tab:initView("CCS_commonTabBtn_btns")
	SoraDAddMessage(self, "MESSAGE_ALLIANCE_PROSPERITY_REFRESH", handler(self, self.refreshView))
	SoraDAddMessage(self, "MESSAGE_ALLIANCE_PROSPERITY_CHANGE", handler(self, self.refreshProsperity))
	SoraDAddMessage(self, "MESSAGE_ALLIANCE_POPULARITY_CHANGE", handler(self, self.refreshPopularity))
	SoraDAddMessage(self, "MESSAGE_ALLIANCE_POPULARITY_FULL", handler(self, self.showFullEffect))
	local spine_npc = sp.SkeletonAnimation:create("spine/chebingcuihui.skel", "spine/chebingcuihui.atlas", 1)
	spine_npc:setAnimation(0, "animation", true)
	spine_npc:setPosition(cc.p(0, 0))
	spine_npc:addTo(self.Node_flag)
end
function allianceProsperityView:fitDevice(...)
	if display.height < 1136 then
		local scale = (1136 - display.height) / 283
		scale = math.min(math.max(scale, 0), 1.0)
		scale = 1 - scale * 0.2
		self.Node_content:setScale(scale)
		self.Node_LoadingBar:setScale(scale)
		local offsety = 1136 - display.height
		offsety = math.min(math.max(offsety, 0), 200)
		self.Top_Image_bg:setPositionY(self.Top_Image_bg:getPositionY() + offsety)
	end
	local imageSize = self.Top_Image_bg:getContentSize()
	if display.height > imageSize.height then
		self.Top_Image_bg:setContentSize(cc.size(imageSize.width, display.height))
		self.Node_main:setPositionY(self.Node_main:getPositionY() - 70)
		local offsetH = display.height - imageSize.height
		local sSize = self.Image_right:getContentSize()
		self.Image_right:setContentSize(cc.size(sSize.width, sSize.height + offsetH))
		self.Image_left:setContentSize(cc.size(sSize.width, sSize.height + offsetH))
		self.G_dh_Tex_lmfrd_006:setVisible(false)
	end
end
function allianceProsperityView:initData(...)
	local curPoint = memberMgr:getOwnMember():getProperty("playerHonor")
	self.Text_honor:setString(string.formatnumberthousands(curPoint))
	SoraDToCenter(self.Node_honor)
	self.Text_score:setString(string.formatnumberthousands(allianceMgr:getAllianceProperty("bonus")))
	SoraDToCenter(self.Node_score)
	self:refreshProsperity()
	self:refreshPopularity()
	if allianceScience:getProsperityRemainCount() > 0 then
		self.Button_donate:setTitleColor(display.COLOR_WHITE)
	else
		self.Button_donate:setTitleColor(display.COLOR_RED)
	end
end
function allianceProsperityView:refreshProsperity(target, data)
	local prosperity = allianceScience:getProsperity()
	self.TextBMFont_prosperity:setString(string.formatnumberthousands(prosperity))
	local rewardsCount = allianceScience:getProsperityRewardsCount()
	self.Image_redPoint:setVisible(0 < rewardsCount)
	if 99 < rewardsCount then
		self.Text_redPointInt:setString("99+")
	else
		self.Text_redPointInt:setString(tostring(rewardsCount))
	end
	self.ccs_tab:setRedPointState(2, 0 < rewardsCount)
end
function allianceProsperityView:refreshPopularity(target, data)
	local percent = allianceScience:getPopularity() / 100
	self.LoadingBar_1:setPercent(percent)
	self.LoadingBar_2:setPercent(percent)
	allianceScience = nil
	;(nil).value = percent
	self.Text_popularity:setString(i18n("alliance_prosperity_text_15", nil))
end
function allianceProsperityView:btn_onClick_btns(tag, name)
	if tag == 1 then
		SoraDRemoveAllAfterPanelFromManager(self)
		SoraDCreatePanel("allianceScienceView"):show()
	end
end
function allianceProsperityView:btnHelpCallback(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		_ENV = "alliance_prosperity_text_13"
		;("alliance_prosperity_text_13").align = SoraDFLabelR()
		SoraDShowHelpMsgTip(i18n("alliance_prosperity_text_13"), "alliance_prosperity_text_13")
	end
end
function allianceProsperityView:btnRewardCallback(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		SoraDCreatePanel("allianceProsperityRewardPopView"):show()
	end
end
function allianceProsperityView:btnBonusCallback(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		SoraDCreatePanel("allianceProsperityBonusPopView"):show()
	end
end
function allianceProsperityView:btnDonateCallback(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		SoraDCreatePanel("allianceProsperityDonateView"):show()
	end
end
function allianceProsperityView:refreshView(target, data)
	self:initData()
end
function allianceProsperityView:showFullEffect(target, data)
	local effect = SoraDCreatAnimation("Node_Effect_lmfrd02", nil, false)
	effect:addTo(self.Node_main)
	effect:setPosition(cc.p(320, 567))
	_UPVALUE1_ = cc.p(320, 567)
	cc.p(320, 567)[1] = cca.delay(1.3666666666666667)
	cc.p(320, 567)[2] = cca.removeSelf()
	effect:runAction(cca.seq(cc.p(320, 567)))
end
return allianceProsperityView
