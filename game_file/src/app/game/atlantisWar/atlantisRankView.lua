local atlantisRankView = class("atlantisRankView", function(target)
	if target and tolua.type(target) == "string" then
		target = SoraDCreateBasePanel(target)
	end
	return target or SoraDCreateBasePanel("atlantisRankView")
end)
function atlantisRankView:ctor(properties)
	self.nodeAtlantisPersonalRankNode = SoraDGetExtendChildFromCCSByName(self, "CCS_atlantisPersonalRankNode")
	self.nodeAtlantisTitleRankNode = SoraDGetExtendChildFromCCSByName(self, "CCS_atlantisTitleRankNode")
	self.nodeAtlantisKindomRankNode = SoraDGetExtendChildFromCCSByName(self, "CCS_atlantisKindomRankNode")
	self.nodeCommonFramTitle = SoraDGetExtendChildFromCCSByName(self, "Top_CCS_commonFramTitle_node")
	self.nodeCommonFramTitle:setTitle(i18n("common_text_851"))
	self.nodeCommonFramTitle:setBtnHelpClickCallBack(handler(self, self.btnHelpClick))
	_ENV, self.nodeCommonTabBtn = SoraDGetExtendChildFromCCSByName(self, "Top_CCS_commonTabBtn"), SoraDGetExtendChildFromCCSByName(self, "Top_CCS_commonTabBtn")
	SoraDGetExtendChildFromCCSByName(self, "Top_CCS_commonTabBtn").tabNum = 3
	_ENV, _ENV, SoraDGetExtendChildFromCCSByName(self, "Top_CCS_commonTabBtn").defaultClick = "Top_CCS_commonTabBtn", self, 1
	;("Top_CCS_commonTabBtn").title = i18n("common_text_479")
	;("Top_CCS_commonTabBtn").handle = handler(self, self.btnTabClick)
	;("Top_CCS_commonTabBtn").tag = 1
	_ENV, self[1], ("Top_CCS_commonTabBtn").fontSize = "Top_CCS_commonTabBtn", "Top_CCS_commonTabBtn", 24
	;("Top_CCS_commonTabBtn").title = i18n("pyramid_btn_35")
	;("Top_CCS_commonTabBtn").handle = handler(self, self.btnTabClick)
	;("Top_CCS_commonTabBtn").tag = 2
	_ENV, self[2], ("Top_CCS_commonTabBtn").fontSize = "Top_CCS_commonTabBtn", "Top_CCS_commonTabBtn", 24
	;("Top_CCS_commonTabBtn").title = i18n("lord_title_01")
	;("Top_CCS_commonTabBtn").handle = handler(self, self.btnTabClick)
	;("Top_CCS_commonTabBtn").tag = 3
	SoraDGetExtendChildFromCCSByName(self, "Top_CCS_commonTabBtn").tabsetArray, self[3], ("Top_CCS_commonTabBtn").fontSize = self, "Top_CCS_commonTabBtn", 24
	local param = SoraDGetExtendChildFromCCSByName(self, "Top_CCS_commonTabBtn")
	self.nodeCommonTabBtn:initView(param)
end
function atlantisRankView:onMessageListener()
end
function atlantisRankView:initData(target, data)
end
function atlantisRankView:btnHelpClick(target, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local atlantisWarUtil = include("atlantisWarUtil")
		local msgTip = ""
		if atlantisWarUtil.isNewMap() then
			msgTip = i18n("atlantiswar_text_0329_KOH")
		else
			msgTip = i18n("atlantiswar_text_0266")
		end
		_ENV = nil
		;(nil).title = i18n("atlantiswar_text_0265")
		;(nil).align = SoraDFLabelR()
		SoraDShowHelpMsgTip(msgTip, nil)
	end
end
function atlantisRankView:btnTabClick(tag, name)
	self.nodeAtlantisKindomRankNode:setVisible(tag == 1)
	self.nodeAtlantisPersonalRankNode:setVisible(tag == 2)
	self.nodeAtlantisTitleRankNode:setVisible(tag == 3)
	if tag == 1 then
		self.nodeAtlantisKindomRankNode:requestMore()
	elseif tag == 2 then
		self.nodeAtlantisPersonalRankNode:requestMore()
	elseif tag == 3 then
		self.nodeAtlantisTitleRankNode:requestMore()
	end
end
function atlantisRankView:msgCallBack(target, data)
	if not clientEventMgr.judgeIsOpen(self.activityID) then
		SoraDRemoveAllAfterPanelFromManager(self)
	end
end
return atlantisRankView
