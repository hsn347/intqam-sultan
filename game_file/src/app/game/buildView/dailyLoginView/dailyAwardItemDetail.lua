local gametop = gModuleMgr.getObject("gametop")
local everydayTaskCtrl = gametop.playertop_:getModule("everydayTaskCtrl")
local everydayTaskRead = include("everydayTaskRead")
local dailyAwardItemDetail = class("dailyAwardItemDetail", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("dailyAwardItemDetail")
	end
	return target
end)
function dailyAwardItemDetail:ctor()
	self.scaleActTarget = SoraDGetChildByName(self, "Center_Node")
	self.ccs_bg = SoraDGetExtendChildFromCCSByName(self, "CCS_commonPopBox_bg")
	self.text_sub_title = SoraDGetChildByName(self, "text_sub_title")
	self.text_desc = SoraDGetChildByName(self, "text_desc")
	self.text_num_title = SoraDGetChildByName(self, "text_num_title")
	self.text_num_value = SoraDGetChildByName(self, "text_num_value")
	self.text_score_title = SoraDGetChildByName(self, "text_score_title")
	self.text_score_value = SoraDGetChildByName(self, "text_score_value")
	self.btn_go = SoraDGetChildByName(self, "btn_go")
	self.img_abg = SoraDGetChildByName(self, "Image_abg")
	self.img_abg:loadTexture(SoraDCheckPNG("bg_recharge_activity_monthly.png", gDefaultPNG.ACTIVITY_BG), ccui.TextureResType.plistType)
	self.btn_go:setSwallowTouches(false)
	self.btn_go:addTouchEventListener(handler(self, self.OnBtnClick))
	self.btn_go:setPressedActionEnabled(true)
	self.text_num_title:setString(i18n("common_text_2601"))
	self.text_score_title:setString(i18n("common_text_2699"))
	self.btn_go:setTitleText(i18n("common_text_678"))
end
function dailyAwardItemDetail:initWithData(data)
	self.data = data
	self.ccs_bg:setTitleName(i18n(self.data.itemInfo.name))
	self.text_desc:setString(i18n(self.data.itemInfo.des))
	_ENV = i18n(self.data.itemInfo.des)
	i18n(self.data.itemInfo.des).task = i18n(self.data.itemInfo.name)
	self.text_sub_title:setString(i18n("common_text_2693", i18n(self.data.itemInfo.des)))
	_ENV = i18n("common_text_2693", i18n(self.data.itemInfo.des))
	i18n("common_text_2693", i18n(self.data.itemInfo.des)).member = self.data.count
	i18n("common_text_2693", i18n(self.data.itemInfo.des)).total = self.data.limitTime
	self.text_num_value:setString(i18n("common_text_155", i18n("common_text_2693", i18n(self.data.itemInfo.des))))
	_ENV = i18n("common_text_155", i18n("common_text_2693", i18n(self.data.itemInfo.des)))
	i18n("common_text_155", i18n("common_text_2693", i18n(self.data.itemInfo.des))).member = self.data.point * self.data.count
	i18n("common_text_155", i18n("common_text_2693", i18n(self.data.itemInfo.des))).total = self.data.point * self.data.limitTime
	self.text_score_value:setString(i18n("common_text_155", i18n("common_text_155", i18n("common_text_2693", i18n(self.data.itemInfo.des)))))
	if SoraDFIsRA() then
		self.text_num_value:setPositionX(self.text_num_title:getPositionX() - self.text_num_title:getContentSize().width - 10)
	else
		self.text_num_value:setPositionX(self.text_num_title:getPositionX() + self.text_num_title:getContentSize().width + 10)
	end
	local everydayTaskID = self.data.everydayTaskID
	local taskIndex = everydayTaskCtrl:getIndexById(everydayTaskID)
	local jumpData = everydayTaskRead.getJumpData(taskIndex)
	if jumpData == nil or jumpData.jumpType == "none" then
		self.btn_go:setVisible(false)
	else
		self.btn_go:setVisible(true)
	end
	self.jumpData = jumpData
end
function dailyAwardItemDetail:OnBtnClick(target, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local mildGuideManager = gModuleMgr.sharedMgr("mildGuideManager")
		mildGuideManager:starMildByEverydayTaskID(self.data.everydayTaskID, everydayTaskRead.getJumpData(self.data.everydayTaskID))
		SoraDRemoveAllPanelFromManager()
	end
end
return dailyAwardItemDetail
