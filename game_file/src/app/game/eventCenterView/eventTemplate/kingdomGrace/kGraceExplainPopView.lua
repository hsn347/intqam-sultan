local kingdomGraceCtrl = SoraDGetCtrl("kingdomGraceCtrl")
local kingdomGraceRead = include("kingdomGraceRead")
local kGraceExplainPopView = class("kGraceExplainPopView", function(target)
	return target or SoraDCreateTouchPanel("kingGraceExplainPop")
end)
function kGraceExplainPopView:ctor()
	self.ccs_bg = SoraDGetExtendChildFromCCSByName(self, "CCS_commonPopBox_KG")
	self.ccs_bg:setTitleName(i18n("kingdom_grace_btn_01"))
	self.textExplain = SoraDGetChildByName(self, "Text_Explain")
	self.textExplain:setString(i18n("kingdom_grace_text_11"))
	SoraDGetAutoHeightLabel(self.textExplain, 450)
	local group = kingdomGraceCtrl:getGroup()
	self.textUpBound = SoraDGetChildByName(self, "Text_PointTop")
	_ENV = i18n("kingdom_grace_text_11")
	i18n("kingdom_grace_text_11").num = kingdomGraceCtrl:getTotalGetScore() .. "/" .. kingdomGraceRead.getExchangeConfig(group, "personLimit")
	self.textUpBound:setString(i18n("kingdom_grace_text_12", i18n("kingdom_grace_text_11")))
	self.btnKill = SoraDGetChildByName(self, "Button_Kill")
	self.btnKill:addTouchEventListener(handler(self, self.btnClickKill))
	self.btnKill:setTitleText(i18n("limitactivities_sectiontitle_02"))
	self.scroll = SoraDGetChildByName(self, "ScrollView_Point")
	self.singleItem = SoraDGetChildByName(self, "Node_Single")
	self.singleItem:setVisible(false)
	self.textIsUp = SoraDGetChildByName(self, "Text_IsUp")
	self.textIsUp:setString(i18n("kingdom_grace_text_10"))
	if SoraDGetDefaultLanguage() == "ko" or SoraDGetDefaultLanguage() == "vi" then
		self.textIsUp:setFontSize(16)
	end
	self.textIsUp:setVisible(kingdomGraceCtrl:getTotalGetScore() >= kingdomGraceRead.getExchangeConfig(group, "personLimit"))
	self:initScroll()
end
function kGraceExplainPopView:initScroll()
	self.scoreData = kingdomGraceRead.getScoreConfig()
	local scrollInner = self.scroll:getInnerContainer()
	local scrollInnerNewH = math.max(35 * table.nums(self.scoreData), self.scroll:getContentSize().height)
	local scrollW = self.scroll:getContentSize().width
	for k, v in ipairs(self.scoreData) do
		local item = self.singleItem:clone()
		item:addTo(self.scroll)
		item:setPosition(0, scrollInnerNewH - k * 35)
		local textLeft = SoraDGetChildByName(item, "Text_Left")
		textLeft = SoraDChangeTextToHtml(textLeft)
		kingdomGraceRead = scrollInnerNewH - k * 35
		;(scrollInnerNewH - k * 35).lv1 = v.monsterLv[1]
		kingdomGraceRead, kingdomGraceRead, (scrollInnerNewH - k * 35).lv2 = nil, v.monsterLv[2], v.monsterLv[2]
		kingdomGraceRead, v.monsterLv[2].down, (nil).color = nil, nil, "#ffff00"
		kingdomGraceRead, v.monsterLv[2].up, (nil).color = nil, nil, "#ffff00"
		v.monsterLv[2].__default, (nil).color = nil, "#ffffff"
		local leftStr = i18n_html("kingdom_grace_text_13", scrollInnerNewH - k * 35, v.monsterLv[2])
		textLeft:setString(leftStr)
		if SoraDGetDefaultLanguage() == "ro" then
			textLeft:setFontSize(16)
		end
		local textRight = SoraDGetChildByName(item, "Text_Right")
		textRight = SoraDChangeTextToHtml(textRight)
		kingdomGraceRead = nil
		kingdomGraceRead, kingdomGraceRead, (nil).point = nil, v.integral, v.integral
		kingdomGraceRead, v.integral.point, (nil).color = nil, nil, "#ffff00"
		v.integral.__default, (nil).color = nil, "#ffffff"
		local rightStr = i18n_html("kingdom_grace_text_14", nil, v.integral)
		textRight:setString(rightStr)
		SoraDGetChildByName(item, "frame_sheer_white_02_86"):setVisible(k % 2 == 0 and true or false)
		item:setVisible(true)
	end
	self.scroll:setInnerContainerSize(cc.size(scrollW, scrollInnerNewH))
	self.scroll:jumpToTop()
end
function kGraceExplainPopView:btnClickKill(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		SoraDRemoveAllPanelFromManager()
		local mildGuideManager = gModuleMgr.sharedMgr("mildGuideManager")
		_ENV = nil
		mildGuideManager:starMildByNewPlayerQuestID(gNewPLayerTaskType.QUICK_TO_WORLD, nil)
		local panel = SoraDCreatePanel("worldMapMonsterSearch")
		panel:show()
	end
end
return kGraceExplainPopView
