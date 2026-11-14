local mailFunctions = include("mailFunctions")
local mailMgr = gModuleMgr.sharedMgr("mailMgr")
local mailUIConstDef = include("mailUIConstDef")
local mailNodeFactory = include("mailNodeFactory")
local mailItemReport = class("mailItemReport", function(target)
	return ccui.Layout:create()
end)
local totalWidth = gMailDetaiViewWidth
function mailItemReport:ctor()
	self:setCascadeOpacityEnabled(true)
	self.itemWidth = gMailDetaiViewWidth
	self.itemHeight = 150
	self:setContentSize(cc.size(self.itemWidth, self.itemHeight))
end
function mailItemReport:initWithData(mid, noNeedAdd)
	self.mail = mailMgr:queryMail(mid)
	self.noNeedAdd = noNeedAdd
	local needCleanFirst
	if needCleanFirst == true and self then
		self:removeAllChildren()
	end
	if not self.mail then
		print("self.mail", mid)
		return
	end
	self.mailType = self.mail:getProperty("mailType")
	self.contentData = self.mail:getProperty("data")
	if self.mailType == gMailType.MONSTER_REPORT then
		self:initWithMonsterReport()
	elseif self.mailType == gMailType.RESOURCE_GATHER_REPORT or self.mailType == gMailType.RESOURCE_HELP_REPORT then
		self:initWithResourceReport()
	elseif self.mailType == gMailType.ROMAN_SOUL_REPORT then
		self:initWithRomanSoul()
	elseif self.mailType == gMailType.PYRAMID_BATTLE_REPORT or self.mailType == gMailType.RUINS_BATTLE_REPORT or self.mailType == gMailType.DEVILVALLEY_BATTLE_REPORT then
		self:initWithPyramidBattle()
	elseif self.mailType == gMailType.BOSS_REPORT then
		self:initWithBossReport()
	end
	self:setLayoutType(ccui.LayoutType.VERTICAL)
	self:setContentSize(cc.size(self.itemWidth, self.itemHeight))
end
function mailItemReport:initWithMonsterReport()
	if nil == self.contentData then
		return
	end
	if self.contentData.monsterInfo and self.contentData.monsterInfo.coordinate and not self.contentData.monsterInfo.coordinate.kid then
		self.contentData.monsterInfo.coordinate.kid = self.mail:getKingdomID()
	end
	local itemNode = self:getChildByName("frameBox")
	if itemNode == nil then
		itemNode = include("mailItemMonsterReport").new()
		itemNode:initMonsterReport(self.contentData, self.mail)
		if not self.noNeedAdd then
			self:addChild(itemNode)
		end
	else
		itemNode:reinitMonsterReport(self.contentData, self.mail)
	end
	self.itemHeight = itemNode:getContentSize().height + self:refreshBtnFightReportLayout()
end
function mailItemReport:initWithResourceReport()
	local resGatherReport = SoraDGetChildByName(self, "resGatherReport")
	if resGatherReport == nil then
		local mailItemDetailResourceInfo = include("mailItemDetailResourceInfo")
		local itemNode = mailItemDetailResourceInfo.new()
		local lp1 = ccui.LinearLayoutParameter:create()
		itemNode:setLayoutParameter(lp1)
		itemNode:setName("resGatherReport")
		lp1:setGravity(ccui.LinearGravity.centerHorizontal)
		if not self.noNeedAdd then
			self:addChild(itemNode)
		end
		resGatherReport = itemNode
	end
	resGatherReport:initWithData(self.mail)
	self.itemHeight = resGatherReport:getItemHeight()
end
function mailItemReport:initWithRomanSoul()
	if nil == self.contentData then
		return
	end
	if self.contentData.romanSoulInfo and self.contentData.romanSoulInfo.coordinate and not self.contentData.romanSoulInfo.coordinate.kid then
		self.contentData.romanSoulInfo.coordinate.kid = self.mail:getKingdomID()
	end
	if self.contentData.uinfo and self.contentData.uinfo.coordinate and not self.contentData.uinfo.coordinate.kid then
		self.contentData.uinfo.coordinate.kid = self.mail:getKingdomID()
	end
	local itemNode = self:getChildByName("frameBox")
	if itemNode == nil then
		itemNode = self:createItemRoman()
		if not self.noNeedAdd then
			self:addChild(itemNode)
		end
	else
		self:reinitRoman(self.contentData)
	end
	self.itemHeight = itemNode:getContentSize().height + self:refreshBtnFightReportLayout()
end
function mailItemReport:initWithPyramidBattle()
	if nil == self.contentData then
		return
	end
	if self.contentData.ancientSoulInfo and self.contentData.ancientSoulInfo.coordinate and not self.contentData.ancientSoulInfo.coordinate.kid then
		self.contentData.ancientSoulInfo.coordinate.kid = self.mail:getKingdomID()
	end
	if self.contentData.uinfo and self.contentData.uinfo.coordinate and not self.contentData.uinfo.coordinate.kid then
		self.contentData.uinfo.coordinate.kid = self.mail:getKingdomID()
	end
	local itemNode = self:getChildByName("frameBox")
	if itemNode == nil then
		itemNode = self:createItemPyramid()
		if not self.noNeedAdd then
			self:addChild(itemNode)
		end
	else
		self:reinitPyramid()
	end
	self.itemHeight = itemNode:getContentSize().height + self:refreshBtnFightReportLayout()
end
function mailItemReport:initWithBossReport()
	if nil == self.contentData then
		return
	end
	local itemHeight = 0
	local itemNode = self:getChildByName("frameBox")
	if itemNode == nil then
		itemNode = self:createItemBossReport()
		if not self.noNeedAdd then
			self:addChild(itemNode)
		end
	else
		itemNode.customNode:refreshData(self.mail)
		local showResult, isVectory = self:getResultStr(self.contentData.contentType)
		mailFunctions = nil
		;(nil).fightResult = isVectory
		;(nil).isShowBlueTop = not isVectory
		;(nil).isShowTitle = false
		;(nil).isShowTime = true
		;(nil).isShowFrame = true
		;(nil).textShowTime = mailFunctions:getMailDetailDate(self.mail)
		itemNode:reInitTop(nil)
		print("itemNode.customNode:getContentSize().height", itemNode.customNode:getContentSize().height)
		itemNode:reSize(cc.size(itemNode:getContentSize().width, itemNode:getNewHeight(itemNode.customNode:getContentSize().height)))
	end
	self.itemHeight = itemNode:getContentSize().height + self:refreshBtnFightReportLayout()
end
function mailItemReport:reinitRoman()
	local totalHeight = 0
	local frameBox = self:getChildByName("frameBox")
	local boxInfo = frameBox.customNode
	local playerInfoNode = boxInfo:getChildByName("playerInfoNode")
	local monsterInfoNode = boxInfo:getChildByName("monsterInfoNode")
	local textDes = boxInfo:getChildByName("monsterDes")
	local romanSoulResultNode = boxInfo:getChildByName("romanSoulResultNode")
	local title = i18n("mail_text_13")
	local strDes = i18n("common_text_1476")
	if self.contentData.result == 1 then
		title = i18n("mail_text_14")
		_ENV = nil
		;(nil).defTime = self.contentData.failedTime
		strDes = i18n("common_text_1479", nil)
	end
	_ENV = nil
	;(nil).fightResult = self.contentData.result == 0
	;(nil).isShowBlueTop = self.contentData.result == 1
	;(nil).isShowTitle = false
	;(nil).isShowTime = true
	;(nil).textShowTime = mailFunctions:getMailDetailDate(self.mail)
	frameBox:reInitTop(nil)
	playerInfoNode:initWithData(self.contentData)
	totalHeight = totalHeight + playerInfoNode:getItemHeight()
	monsterInfoNode:initWithData(self.contentData)
	totalHeight = totalHeight + monsterInfoNode:getItemHeight()
	textDes:setString(strDes)
	totalHeight = totalHeight + SoraDGetAutoHeightLabel(textDes, 443)
	if romanSoulResultNode then
		romanSoulResultNode:initWithData(self.contentData)
		totalHeight = totalHeight + romanSoulResultNode:getContentSize().height
	end
	boxInfo:setContentSize(cc.size(totalWidth, totalHeight))
	frameBox:reSize(cc.size(frameBox:getContentSize().width, frameBox:getNewHeight(totalHeight)))
end
function mailItemReport:reinitPyramid()
	local totalHeight = 0
	local frameBox = self:getChildByName("frameBox")
	local pyramidNode = frameBox.customNode
	mailFunctions = nil
	;(nil).isShowTitle = false
	;(nil).isShowTime = true
	;(nil).textShowTime = mailFunctions:getMailDetailDate(self.mail)
	frameBox:reInitTop(nil)
	pyramidNode:initWithData(self.contentData, self.mailType)
	totalHeight = totalHeight + pyramidNode:getItemHeight()
	frameBox:reSize(cc.size(frameBox:getContentSize().width, frameBox:getNewHeight(totalHeight)))
end
function mailItemReport:refreshBtnFightReportLayout()
	if self.contentData.fightDetail or self.contentData.content and self.contentData.content.fightDetail then
		local fightReportBtnLayout = self:getChildByName("fightDetail")
		local autoHeight = 0
		if fightReportBtnLayout == nil then
			mailNodeFactory = nil
			;(nil).fontSize = 22
			mailNodeFactory, (nil).titleText = i18n("mail_text_01"), i18n("mail_text_01")
			i18n("mail_text_01").left = 0
			i18n("mail_text_01").top = 5
			i18n("mail_text_01").right = 0
			;(nil).margin, i18n("mail_text_01").bottom = i18n("mail_text_01"), 5
			;(nil).normalImgName = "btn_BXanniu_yellow.png"
			;(nil).handler = handler(self, self.onBtnFightReport)
			fightReportBtnLayout, autoHeight = mailNodeFactory:createButtonLayout(nil)
			fightReportBtnLayout:setName("fightDetail")
			if not self.noNeedAdd then
				self:addChild(fightReportBtnLayout)
			end
		else
			autoHeight = mailNodeFactory:getWidgetItemHeight(fightReportBtnLayout)
		end
		fightReportBtnLayout:setVisible(true)
		return autoHeight
	else
		local fightReportBtnLayout = self:getChildByName("fightDetail")
		if fightReportBtnLayout ~= nil then
			fightReportBtnLayout:setVisible(false)
		end
		return 0
	end
end
function mailItemReport:createItemRoman()
	local totalHeight = 0
	local vLayout = ccui.VBox:create()
	vLayout:setCascadeOpacityEnabled(true)
	vLayout:setName("boxInfo")
	vLayout:setSwallowTouches(false)
	local playerInfoNode = include("mailRomanSoulPlayerInfo").new()
	playerInfoNode:initWithData(self.contentData)
	playerInfoNode:setName("playerInfoNode")
	playerInfoNode:setContentSize(cc.size(playerInfoNode:getItemWidth(), playerInfoNode:getItemHeight()))
	vLayout:addChild(playerInfoNode)
	totalHeight = totalHeight + playerInfoNode:getItemHeight()
	local monsterInfoNode = include("mailRomanSoulSummary").new()
	monsterInfoNode:initWithData(self.contentData)
	monsterInfoNode:setName("monsterInfoNode")
	monsterInfoNode:setContentSize(cc.size(monsterInfoNode:getItemWidth(), monsterInfoNode:getItemHeight()))
	vLayout:addChild(monsterInfoNode)
	totalHeight = totalHeight + monsterInfoNode:getItemHeight()
	local textDes = ""
	if self.contentData.result == 1 then
		_ENV = cc.size(monsterInfoNode:getItemWidth(), monsterInfoNode:getItemHeight())
		cc.size(monsterInfoNode:getItemWidth(), monsterInfoNode:getItemHeight()).defTime = self.contentData.failedTime
		textDes = i18n("common_text_1479", cc.size(monsterInfoNode:getItemWidth(), monsterInfoNode:getItemHeight()))
	else
		textDes = i18n("common_text_1476")
	end
	_ENV = cc.size(monsterInfoNode:getItemWidth(), monsterInfoNode:getItemHeight())
	cc.size(monsterInfoNode:getItemWidth(), monsterInfoNode:getItemHeight()).linearLayoutType = ccui.LinearGravity.centerHorizontal
	cc.size(monsterInfoNode:getItemWidth(), monsterInfoNode:getItemHeight()).name = "monsterDes"
	cc.size(monsterInfoNode:getItemWidth(), monsterInfoNode:getItemHeight()).str = textDes
	cc.size(monsterInfoNode:getItemWidth(), monsterInfoNode:getItemHeight()).AlignH = cc.TEXT_ALIGNMENT_CENTER
	cc.size(monsterInfoNode:getItemWidth(), monsterInfoNode:getItemHeight()).color = cc.c3b(80, 50, 0)
	_ENV, cc.size(monsterInfoNode:getItemWidth(), monsterInfoNode:getItemHeight()).autoHeight = cc.c3b(80, 50, 0), true
	cc.c3b(80, 50, 0).left = 0
	cc.c3b(80, 50, 0).top = 0
	cc.c3b(80, 50, 0).right = 0
	cc.size(monsterInfoNode:getItemWidth(), monsterInfoNode:getItemHeight()).margin, cc.c3b(80, 50, 0).bottom = cc.c3b(80, 50, 0), 5
	local textLayout, autoHeight = mailNodeFactory:createTextLayout(cc.size(monsterInfoNode:getItemWidth(), monsterInfoNode:getItemHeight()))
	textLayout:addTo(vLayout)
	totalHeight = totalHeight + autoHeight + 10
	vLayout:setContentSize(cc.size(totalWidth, totalHeight))
	local title = i18n("mail_text_13")
	if self.contentData.result == 1 then
		title = i18n("mail_text_14")
	end
	local frameBox = include("mailItemDetailFrameBox")
	local frameBoxNode = frameBox.new()
	frameBoxNode:setSwallowTouches(false)
	frameBoxNode:setName("frameBox")
	_ENV = "frameBox"
	_ENV, ("frameBox").dataType = mailUIConstDef.MAIL_UI_TYPE_CUSTOM, mailUIConstDef.MAIL_UI_TYPE_CUSTOM
	mailUIConstDef.MAIL_UI_TYPE_CUSTOM.fightResult = self.contentData.result == 0
	mailUIConstDef.MAIL_UI_TYPE_CUSTOM.isShowBlueTop = self.contentData.result == 1
	mailUIConstDef.MAIL_UI_TYPE_CUSTOM.textShowTime = mailFunctions:getMailDetailDate(self.mail)
	;("frameBox").dataContent, mailUIConstDef.MAIL_UI_TYPE_CUSTOM.customNode = mailUIConstDef.MAIL_UI_TYPE_CUSTOM, vLayout
	frameBoxNode:initWithData("frameBox")
	return frameBoxNode
end
function mailItemReport:createItemPyramid()
	local pyramidNode = include("mailItemPyramidBattle").new()
	pyramidNode:initWithData(self.contentData, self.mailType)
	pyramidNode:setName("pyramidNode")
	pyramidNode:setContentSize(cc.size(pyramidNode:getItemWidth(), pyramidNode:getItemHeight()))
	local frameBox = include("mailItemDetailFrameBox")
	local frameBoxNode = frameBox.new()
	frameBoxNode:setSwallowTouches(false)
	frameBoxNode:setName("frameBox")
	_ENV = "frameBox"
	_ENV, ("frameBox").dataType = mailUIConstDef.MAIL_UI_TYPE_CUSTOM, mailUIConstDef.MAIL_UI_TYPE_CUSTOM
	mailUIConstDef.MAIL_UI_TYPE_CUSTOM.textShowTime = mailFunctions:getMailDetailDate(self.mail)
	mailUIConstDef.MAIL_UI_TYPE_CUSTOM.isShowFrame = true
	;("frameBox").dataContent, mailUIConstDef.MAIL_UI_TYPE_CUSTOM.customNode = mailUIConstDef.MAIL_UI_TYPE_CUSTOM, pyramidNode
	frameBoxNode:initWithData("frameBox")
	return frameBoxNode
end
function mailItemReport:createItemBossReport()
	local frameBoxNode = SoraDCreatePanel("mailItemDetailFrameBox")
	frameBoxNode:setName("frameBox")
	local vLayout = SoraDCreatePanel("mailItemBossReport")
	vLayout:refreshData(self.mail)
	local showResult, isVectory = self:getResultStr(self.contentData.contentType)
	_ENV = nil
	_ENV, (nil).dataType = mailUIConstDef.MAIL_UI_TYPE_CUSTOM, mailUIConstDef.MAIL_UI_TYPE_CUSTOM
	mailUIConstDef.MAIL_UI_TYPE_CUSTOM.fightResult = isVectory
	mailUIConstDef.MAIL_UI_TYPE_CUSTOM.isShowBlueTop = not isVectory
	mailUIConstDef.MAIL_UI_TYPE_CUSTOM.textShowTime = mailFunctions:getMailDetailDate(self.mail)
	;(nil).dataContent, mailUIConstDef.MAIL_UI_TYPE_CUSTOM.customNode = mailUIConstDef.MAIL_UI_TYPE_CUSTOM, vLayout
	frameBoxNode:initWithData(nil)
	return frameBoxNode
end
function mailItemReport:onBtnFightReport(target, event)
	if event == ccui.TouchEventType.ended then
		if self.singleIsMoved then
			self.singleIsMoved = false
			return
		end
		SoraDPlaySound()
		local fightDetail = not self.contentData.fightDetail and self.contentData.content and self.contentData.content.fightDetail
		local panel = SoraDCreatePanel("mailItemDetailFightDefense")
		_ENV = nil
		;(nil).fightDetail = fightDetail
		panel:initWithFightDetail(nil)
		panel:show()
	elseif event == ccui.TouchEventType.moved then
		local touchBeganPoint = target:getTouchBeganPosition()
		local touchmovePoint = target:getTouchMovePosition()
		local distance = cc.pGetDistance(touchBeganPoint, touchmovePoint)
		if tonumber(distance) > TOUCH_MOVED_ERROR_VALUE then
			self.singleIsMoved = true
		end
	else
		self.singleIsMoved = false
	end
end
function mailItemReport:getResultStr(contentType)
	local showResultStr = i18n("mail_text_13")
	local isVectory = true
	if contentType == gMailNPCContentType.Content_WorldBoss_AttackFailure or contentType == gMailNPCContentType.Content_HeroBoss_AttackFailure then
		showResultStr = i18n("mail_text_14")
		isVectory = false
	end
	return showResultStr, isVectory
end
function mailItemReport:getItemWidth()
	return self.itemWidth
end
function mailItemReport:getItemHeight()
	return self.itemHeight
end
return mailItemReport
