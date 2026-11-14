local gametop = gModuleMgr.getObject("gametop")
local itemDesRead = include("itemDesRead")
local christmasTreeCtrl = gametop.playertop_:getModule("christmasTreeCtrl")
local allianceChristmasTreeView = class("allianceChristmasTreeView", function(target)
	if target == nil then
		return SoraDCreateBasePanel("allianceChristmasTreeView")
	end
	return target
end)
local PANEL_HEIGHT = 140
function _ENV(target)
	if target == nil then
		return SoraDCreateBasePanel("allianceChristmasTreeView")
	end
	return target
end
;(function(target)
	if target == nil then
		return SoraDCreateBasePanel("allianceChristmasTreeView")
	end
	return target
end)[1] = 851501
;(function(target)
	if target == nil then
		return SoraDCreateBasePanel("allianceChristmasTreeView")
	end
	return target
end)[2] = 851601
;(function(target)
	if target == nil then
		return SoraDCreateBasePanel("allianceChristmasTreeView")
	end
	return target
end)[3] = 851701
local _ENV, (function(target)
	if target == nil then
		return SoraDCreateBasePanel("allianceChristmasTreeView")
	end
	return target
end)[4], treeId = nil, 851801, function(target)
	if target == nil then
		return SoraDCreateBasePanel("allianceChristmasTreeView")
	end
	return target
end
;(nil)[1] = "BG_zzsds_12.png"
;(nil)[2] = "BG_zzsds_11.png"
;(nil)[3] = "BG_zzsds_10.png"
local (nil)[4], bgName = "BG_zzsds_09.png", nil
function allianceChristmasTreeView:ctor()
	self:initControls()
end
function allianceChristmasTreeView:initControls()
	self.bg = SoraDGetChildByName(self, "Image_bg")
	self.nodeTitle = SoraDGetExtendChildFromCCSByName(self, "CCS_commonFramTitle_eventCenter")
	self.btnQuest = SoraDGetChildByName(self, "btn_quest")
	self.txtJumpTo = SoraDGetChildByName(self, "text_jump")
	self.txtNoMember = SoraDGetChildByName(self, "text_noMember")
	self.scroll = SoraDGetChildByName(self, "Top_Size_ScrollView_2")
	self.nodeSingle = SoraDGetChildByName(self, "node_single")
	self.bg:setFillType(1)
	self.nodeTitle:setTitle(i18n("christmas_tree_text_03"))
	self.btnQuest:addTouchEventListener(handler(self, self.questClickCallBack))
	self.txtJumpTo:setString(i18n("christmas_tree_text_15"))
	SoraDSetTextWidthHeight(self.txtJumpTo, cc.size(600, 60))
	self.txtNoMember:setPositionY(display.height / 2)
	self.txtNoMember:setString(i18n("christmas_tree_text_16"))
	christmasTreeCtrl:sendAllianceListMsg()
	SoraDShowLoading(self)
end
function allianceChristmasTreeView:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.judgeClose))
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_CHRISTMAS_TREE_LIST_BACK", function(target, data)
		SoraDCloseLoading(self)
		self.txtNoMember:setVisible(table.nums(data.list) <= 0)
		self:initScroll(data.list)
		self.list = data.list
	end)
end
function allianceChristmasTreeView:initScroll(list)
	self.scroll:removeAllChildren()
	if table.nums(list) <= 0 then
		return
	end
	local scrollH = math.max(PANEL_HEIGHT * #list, self.scroll:getContentSize().height)
	self.scroll:setInnerContainerSize(cc.size(self.scroll:getContentSize().width, scrollH))
	for i = 1, #list do
		local single = self.nodeSingle:clone()
		single:setPosition(cc.p(320, scrollH - PANEL_HEIGHT * (i - 1)))
		single:addTo(self.scroll)
		local imageHead = SoraDGetChildByName(single, "Image_head")
		SoraDGetHeadFromManager(imageHead, list[i].imageId, list[i].avatar)
		imageHead:addTouchEventListener(handler(self, self.jumpToClickCallBack))
		imageHead:setTag(list[i].uid)
		local txtName = SoraDGetChildByName(single, "Text_name")
		txtName:setString(list[i].nickName)
		local txtTreeName = SoraDGetChildByName(single, "Text_tree")
		txtTreeName:setString(itemDesRead.getName(treeId[list[i].level]))
		local txtCordinate = SoraDGetChildByName(single, "Text_cordinate")
		local posStr = string.format("（X：%d,Y：%d）", list[i].x, list[i].y)
		txtCordinate:setString(posStr)
		SoraDDrawTextUnderLine(txtCordinate, cc.c4b(255, 0, 0, 255))
		txtCordinate:setPositionX(txtTreeName:getContentSize().width + txtTreeName:getPositionX())
		txtCordinate:addTouchEventListener(handler(self, self.jumpClickCallBack))
		txtCordinate:setTag(i)
		local remainTime = tonumber(list[i].leftTime) - serviceFunctions.systemTime()
		local totalTime = tonumber(list[i].leftTime) - list[i].createTime
		local loadingBar = SoraDGetChildByName(single, "LoadingBar_progress")
		local txtRemainTime = SoraDGetChildByName(single, "Text_remainTime")
		txtRemainTime = SoraDCreateTimerLabel(single, txtRemainTime)
		txtRemainTime:setTimeLast(function(str)
			loadingBar:setPercent(remainTime / totalTime * 100)
			remainTime = remainTime / totalTime * 100
			;(remainTime / totalTime * 100).time = str
			return i18n("common_text_766", remainTime / totalTime * 100)
		end)
		txtRemainTime:beginTime(remainTime)
		txtRemainTime:setTimeEndListener(function(...)
			christmasTreeCtrl:sendAllianceListMsg()
			SoraDShowLoading(self)
		end)
		local txtCount = SoraDGetChildByName(single, "Text_count")
		local countStr = string.format("（%d/%d）", list[i].leftCount, list[i].maxCount)
		txtCount:setString(countStr)
		local txtAlreadyGet = SoraDGetChildByName(single, "Text_alreadyGet")
		txtAlreadyGet:setString(i18n("common_text_1892"))
		txtAlreadyGet:setVisible(list[i].isColl)
		local imageBg = SoraDGetChildByName(single, "Image_barBg")
		imageBg:loadTexture(bgName[list[i].level], ccui.TextureResType.plistType)
	end
end
function allianceChristmasTreeView:jumpToClickCallBack(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local playerID = button:getTag()
		local kid = gametop.playertop_:getKingdomID()
		_ENV = nil
		;(nil).msg = "MESSAGE_CHAT_REQUEST_LORD_INFO"
		;(nil).playerID = playerID
		;(nil).kid = kid
		SoraDSendMessage(nil)
	end
end
function allianceChristmasTreeView:jumpClickCallBack(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if self.list[button:getTag()] then
			SoraDGotoWorldMapPoint(cc.p(self.list[button:getTag()].x, self.list[button:getTag()].y), true)
			SoraDRemoveAllPanelFromManager()
		end
	end
end
function allianceChristmasTreeView:questClickCallBack(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		userSDKManager.showFAQSection(gSDKDef.FAQSectionType.CHRISTMAS_TREE_PRODUCTION)
	end
end
function allianceChristmasTreeView:judgeClose()
	if not clientEventMgr.judgeIsOpen(gActivityTimeActivityID.CHRISTMAS_TREE_PRODUCTION) then
		SoraDRemoveAllAfterPanelFromManager(self)
	end
end
return allianceChristmasTreeView
