local remainsWarRead = include("remainsWarRead")
local remainsWarResultShareView = class("remainsWarResultShareView", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("remainsWarResultShareView")
	end
	return target
end)
function remainsWarResultShareView:ctor()
	self:setBackGround(229.5)
	self:initWidget()
	self:initEffect()
	self.selectBigTab = 1
	self:updateBigTab()
end
function remainsWarResultShareView:initWidget()
	self.spFlagSuc = SoraDGetChildByName(self, "Sprite_flag_suc")
	self.spFlagFail = SoraDGetChildByName(self, "Sprite_flag_fail")
	self.txtScoreSouth = SoraDGetChildByName(self, "Text_score_south")
	self.txtScoreNorth = SoraDGetChildByName(self, "Text_score_north")
	self.scroll = SoraDGetChildByName(self, "Top_Size_ScrollView_team")
	self.scrollTitle = SoraDGetChildByName(self, "Top_Size_ScrollView_title")
	self.nodeMemberLeft = SoraDGetExtendChildFromCCSByName(self, "CCS_remainsWarResultSingle_left")
	self.nodeMemberRight = SoraDGetExtendChildFromCCSByName(self, "CCS_remainsWarResultSingle_right")
	self.btnBigTab, _ENV, self.Node_team = SoraDGetChildByName(self, "Node_team"), SoraDGetChildByName(self, "Node_team"), SoraDGetChildByName(self, "Node_team")
	self.btnBigTab[1] = SoraDGetChildByName(self, "Button_left")
	self.btnBigTab[2] = SoraDGetChildByName(self, "Button_right")
	SoraDGetChildByName(self.btnBigTab[1], "Text_name"):setString(i18n("Anchor_text_14"))
	SoraDGetChildByName(self.btnBigTab[2], "Text_name"):setString(i18n("lord_title_01"))
	for i, v in ipairs(self.btnBigTab) do
		v:setTag(i)
		v:setPressedActionEnabled(false)
		v:addTouchEventListener(handler(self, self.btnClickTabCallBack))
	end
	self.Text_time = SoraDGetChildByName(self, "Text_time")
	self.Panel_1 = SoraDGetChildByName(self, "Panel_1")
	self.Button_share = SoraDGetChildByName(self, "Button_share")
	self.Button_share:setVisible(false)
end
function remainsWarResultShareView:btnClickTabCallBack(button, event)
	if event == ccui.TouchEventType.ended then
		self.selectBigTab = button:getTag()
		self:updateBigTab()
	end
end
function remainsWarResultShareView:updateBigTab(...)
	for _, v in pairs(self.btnBigTab) do
		local btnName = v:getChildByName("Text_name")
		if v:getTag() == self.selectBigTab then
			btnName:setColor(cc.c3b(255, 238, 169))
			v:setTouchEnabled(false)
			v:setBright(false)
		else
			btnName:setColor(cc.c3b(136, 123, 112))
			v:setTouchEnabled(true)
			v:setBright(true)
		end
	end
	self.Node_team:setVisible(self.selectBigTab == 1)
	self.scrollTitle:setVisible(self.selectBigTab ~= 1)
end
function remainsWarResultShareView:initEffect()
	local remainsWarUtil = include("remainsWarUtil")
	self.nodeVS = SoraDGetChildByName(self, "Node_VS")
	remainsWarUtil.addVSEffect(self.nodeVS)
	self.spVSBG = SoraDGetChildByName(self, "Sprite_VS_BG")
	remainsWarUtil.addVSAnimation(self, self.spVSBG)
end
function remainsWarResultShareView:initData(data)
