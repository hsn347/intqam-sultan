local mailUIConstDef = include("mailUIConstDef")
local worldMapDefine = include("worldMapDefine")
local publicRead = include("publicRead")
local mailFunctions = include("mailFunctions")
local mailNodeFactory = include("mailNodeFactory")
local mailItemMonsterReport = class("mailItemMonsterReport", function(target)
	local frameBox = include("mailItemDetailFrameBox").new()
	frameBox:setName("frameBox")
	frameBox = include("mailItemRewardRecycle").new(frameBox)
	return frameBox
end)
local totalWidth = gMailDetaiViewWidth
local totalHeight = 0
function mailItemMonsterReport:ctor()
	self:setCascadeOpacityEnabled(true)
	self.recycledReward, _UPVALUE0_ = self.setCascadeOpacityEnabled, self.setCascadeOpacityEnabled
end
function mailItemMonsterReport:initMonsterReport(contentData, mail)
	self.mail = mail
	self.contentData = contentData
	local fightResult = contentData.fightResult
	local isFirstKill = contentData.isFirstKill
	if isFirstKill == true and fightResult == 0 then
		self:createItemMonsterReportFistKill()
	elseif fightResult == 0 then
		self:createItemMonsterReportSuccess()
	elseif fightResult == 1 then
		self:createItemMonsterReportFailure()
	elseif fightResult == 2 then
		self:createItemMonsterReportInvalid()
	end
end
function mailItemMonsterReport:reinitMonsterReport(contentData, mail)
	self.mail = mail
	self.contentData = contentData
	local fightResult = self.contentData.fightResult
	local isFirstKill = self.contentData.isFirstKill
	if isFirstKill == true and fightResult == 0 then
		self:reinitMonsterFK()
	elseif fightResult == 0 then
		self:reinitMonsterSuccess()
	elseif fightResult == 1 then
		self:reinitMonsterFailure()
	elseif fightResult == 2 then
		self:reinitMonsterInvalid()
	end
end
function mailItemMonsterReport:createItemMonsterReportFistKill()
	local vLayout = ccui.VBox:create()
	vLayout:setCascadeOpacityEnabled(true)
	local totalHeight, autoHeight = 0, 0
	self.imgFK, autoHeight = self:addFirstKillImage(vLayout)
	self.imgFK:addTo(vLayout)
	totalHeight = totalHeight + autoHeight
	self.monsterDetail, autoHeight = self:addMonsterDetal(vLayout)
	totalHeight = totalHeight + autoHeight
	_ENV = vLayout
	vLayout.fontSize = 22
	vLayout.name = "desc"
	vLayout.str = self:getMonsterLvStr()
	vLayout.AlignH = SoraDFLabelR()
	vLayout.color = cc.c3b(80, 50, 0)
	vLayout.textHeight = 75
	vLayout.autoHeight = true
	_ENV, vLayout.linearLayoutType = ccui.LinearGravity.centerHorizontal, ccui.LinearGravity.centerHorizontal
	ccui.LinearGravity.centerHorizontal.left = 0
	ccui.LinearGravity.centerHorizontal.top = 10
	ccui.LinearGravity.centerHorizontal.right = 0
	vLayout.margin, ccui.LinearGravity.centerHorizontal.bottom = ccui.LinearGravity.centerHorizontal, 10
	self.textDes, autoHeight = mailNodeFactory:createTextLayout(vLayout)
	self.textDes:addTo(vLayout)
	totalHeight = totalHeight + autoHeight
	self.rewardHead, autoHeight = mailNodeFactory:createLayoutRewardItemHead()
	self.rewardHead:addTo(vLayout)
	totalHeight = totalHeight + autoHeight
	_ENV = vLayout
	vLayout.fontSize = 22
	vLayout.name = "translateDesc"
	vLayout.str = self:getTranslateRecordStr()
	vLayout.totalWidth = totalWidth
	vLayout.AlignH = SoraDFLabelR()
	vLayout.color = cc.c3b(80, 50, 0)
	vLayout.autoHeight = true
	vLayout.linearLayoutType = ccui.LinearGravity.centerHorizontal
	self.translateDesc, autoHeight = mailNodeFactory:createTextLayout(vLayout)
	self.translateDesc:addTo(vLayout)
	totalHeight = totalHeight + autoHeight
	self.rewardLayout, autoHeight = self:addAwardList(vLayout)
	totalHeight = totalHeight + autoHeight
	vLayout:setContentSize(cc.size(totalWidth, totalHeight))
	vLayout:setSwallowTouches(false)
	_ENV = false
	_ENV, (false).dataType = mailUIConstDef.MAIL_UI_TYPE_CUSTOM, mailUIConstDef.MAIL_UI_TYPE_CUSTOM
	mailUIConstDef.MAIL_UI_TYPE_CUSTOM.textShowResult = i18n("common_text_159")
	mailUIConstDef.MAIL_UI_TYPE_CUSTOM.textShowTime = mailFunctions:getMailDetailDate(self.mail)
	;(false).dataContent, mailUIConstDef.MAIL_UI_TYPE_CUSTOM.customNode = mailUIConstDef.MAIL_UI_TYPE_CUSTOM, vLayout
	self:initWithData(false)
end
function mailItemMonsterReport:createItemMonsterReportSuccess()
	local vLayout = ccui.VBox:create()
	vLayout:setCascadeOpacityEnabled(true)
	local totalHeight, autoHeight = 0, 0
	self.monsterDetail, autoHeight = self:addMonsterDetal(vLayout)
	totalHeight = totalHeight + autoHeight
	self.rewardHead, autoHeight = mailNodeFactory:createLayoutRewardItemHead()
	self.rewardHead:addTo(vLayout)
	self.rewardHeadHeight = autoHeight
	if not self.contentData.reward then
		self.rewardHead:setContentSize(cc.size(self.rewardHead:getContentSize().width, 0))
		self.rewardHead:setVisible(false)
	else
		totalHeight = totalHeight + autoHeight
	end
	_ENV = false
	;(false).fontSize = 22
	;(false).name = "translateDesc"
	;(false).str = self:getTranslateRecordStr()
	;(false).AlignH = cc.TEXT_ALIGNMENT_CENTER
	;(false).color = cc.c3b(80, 50, 0)
	;(false).autoHeight = true
	;(false).linearLayoutType = ccui.LinearGravity.centerHorizontal
	self.translateDesc, autoHeight = mailNodeFactory:createTextLayout(false)
	self.translateDesc:addTo(vLayout)
	totalHeight = totalHeight + autoHeight
	self.rewardLayout, autoHeight = self:addAwardList(vLayout)
	totalHeight = totalHeight + autoHeight
	self.monsterSummary, autoHeight = self:addMonsterSummary(vLayout)
	totalHeight = totalHeight + autoHeight
	vLayout:setContentSize(cc.size(totalWidth, totalHeight))
	vLayout:setSwallowTouches(false)
	_ENV = false
	_ENV, (false).dataType = mailUIConstDef.MAIL_UI_TYPE_CUSTOM, mailUIConstDef.MAIL_UI_TYPE_CUSTOM
	mailUIConstDef.MAIL_UI_TYPE_CUSTOM.fightResult = true
	mailUIConstDef.MAIL_UI_TYPE_CUSTOM.isShowTime = true
	mailUIConstDef.MAIL_UI_TYPE_CUSTOM.textShowTime = mailFunctions:getMailDetailDate(self.mail)
	;(false).dataContent, mailUIConstDef.MAIL_UI_TYPE_CUSTOM.customNode = mailUIConstDef.MAIL_UI_TYPE_CUSTOM, vLayout
	self:initWithData(false)
end
function mailItemMonsterReport:createItemMonsterReportFailure()
	local monsterLv = self:getMonsterLevel(self.contentData.monsterInfo)
	local monsterName = worldMapDefine.getMonsterName(self.contentData.monsterInfo.id)
	worldMapDefine = nil
	;(nil).lv = monsterLv
	;(nil).name = monsterName
	local strInfo = i18n("common_text_160", nil)
	local vLayout = ccui.VBox:create()
	vLayout:setCascadeOpacityEnabled(true)
	local totalHeight, autoHeight = 0, 0
	self.monsterDetail, autoHeight = self:addMonsterDetal(vLayout)
	totalHeight = totalHeight + autoHeight
	worldMapDefine = vLayout
	vLayout.fontSize = 20
	vLayout.name = "desc"
	vLayout.str = strInfo
	vLayout.AlignH = SoraDFLabelR()
	vLayout.AlignV = cc.TEXT_ALIGNMENT_CENTER
	vLayout.color = cc.c3b(80, 50, 0)
	vLayout.textHeight = 75
	vLayout.autoHeight = true
	worldMapDefine, vLayout.linearLayoutType = ccui.LinearGravity.centerHorizontal, ccui.LinearGravity.centerHorizontal
	ccui.LinearGravity.centerHorizontal.left = 0
	ccui.LinearGravity.centerHorizontal.top = 10
	ccui.LinearGravity.centerHorizontal.right = 0
	vLayout.margin, ccui.LinearGravity.centerHorizontal.bottom = ccui.LinearGravity.centerHorizontal, 10
	self.textDes, autoHeight = mailNodeFactory:createTextLayout(vLayout)
	self.textDes:addTo(vLayout)
	totalHeight = totalHeight + autoHeight
	self.monsterSummary, autoHeight = self:addMonsterSummary(vLayout)
	totalHeight = totalHeight + autoHeight
	vLayout:setContentSize(cc.size(totalWidth, totalHeight))
	vLayout:setSwallowTouches(false)
	worldMapDefine = false
	worldMapDefine, (false).dataType = mailUIConstDef.MAIL_UI_TYPE_CUSTOM, mailUIConstDef.MAIL_UI_TYPE_CUSTOM
	mailUIConstDef.MAIL_UI_TYPE_CUSTOM.fightResult = false
	mailUIConstDef.MAIL_UI_TYPE_CUSTOM.isShowTime = true
	mailUIConstDef.MAIL_UI_TYPE_CUSTOM.textShowTime = mailFunctions:getMailDetailDate(self.mail)
	mailUIConstDef.MAIL_UI_TYPE_CUSTOM.customNode = vLayout
	;(false).dataContent, mailUIConstDef.MAIL_UI_TYPE_CUSTOM.isShowBlueTop = mailUIConstDef.MAIL_UI_TYPE_CUSTOM, true
	self:initWithData(false)
end
function mailItemMonsterReport:createItemMonsterReportInvalid()
	local vLayout = ccui.VBox:create()
	vLayout:setCascadeOpacityEnabled(true)
	local totalHeight, autoHeight = 0, 0
	self.monsterDetail, autoHeight = self:addMonsterDetal(vLayout)
	totalHeight = totalHeight + autoHeight
	local monsterLv = self:getMonsterLevel(self.contentData.monsterInfo)
	local monsterName = worldMapDefine.getMonsterName(self.contentData.monsterInfo.id)
	_ENV = nil
	;(nil).name = monsterName
	;(nil).lv = monsterLv
	local strInfo = i18n("common_text_161", nil)
	_ENV = nil
	;(nil).fontSize = 20
	;(nil).name = "desc"
	;(nil).str = strInfo
	;(nil).AlignH = SoraDFLabelR()
	;(nil).AlignV = cc.TEXT_ALIGNMENT_CENTER
	;(nil).color = cc.c3b(80, 50, 0)
	;(nil).autoHeight = true
	_ENV, (nil).textHeight = cc.c3b(80, 50, 0), 75
	cc.c3b(80, 50, 0).left = 0
	cc.c3b(80, 50, 0).top = 10
	cc.c3b(80, 50, 0).right = 0
	;(nil).margin, cc.c3b(80, 50, 0).bottom = cc.c3b(80, 50, 0), 10
	self.textDes, autoHeight = mailNodeFactory:createTextLayout(nil)
	self.textDes:addTo(vLayout)
	totalHeight = totalHeight + autoHeight
	vLayout:setContentSize(cc.size(totalWidth, totalHeight))
	vLayout:setSwallowTouches(false)
	_ENV = false
	_ENV, (false).dataType = mailUIConstDef.MAIL_UI_TYPE_CUSTOM, mailUIConstDef.MAIL_UI_TYPE_CUSTOM
	mailUIConstDef.MAIL_UI_TYPE_CUSTOM.textShowResult = i18n("common_text_154")
	mailUIConstDef.MAIL_UI_TYPE_CUSTOM.isShowTime = true
	mailUIConstDef.MAIL_UI_TYPE_CUSTOM.textShowTime = mailFunctions:getMailDetailDate(self.mail)
	mailUIConstDef.MAIL_UI_TYPE_CUSTOM.customNode = vLayout
	;(false).dataContent, mailUIConstDef.MAIL_UI_TYPE_CUSTOM.isShowBlueTop = mailUIConstDef.MAIL_UI_TYPE_CUSTOM, true
	self:initWithData(false)
end
function mailItemMonsterReport:reinitMonsterFK()
	local boxInfo = self.customNode
	local totalHeight = 0
	local deltaTopImg = 6
	_ENV = nil
	;(nil).textShowResult = i18n("common_text_159")
	;(nil).isShowTime = true
	;(nil).textShowTime = mailFunctions:getMailDetailDate(self.mail)
	self:reInitTop(nil)
	totalHeight = totalHeight + self.imgFK:getContentSize().height + deltaTopImg
	self.monsterDetail:initWithData(self.contentData)
	totalHeight = totalHeight + self.monsterDetail:getItemHeight()
	totalHeight = totalHeight + self.rewardHead:getContentSize().height
	self:recycleRewardItems(self.rewardLayout)
	self:createLayoutMonsterRewardItem(self.contentData, self.rewardLayout)
	totalHeight = totalHeight + self.rewardLayout:getContentSize().height
	self.translateDesc:setString(self:getTranslateRecordStr())
	totalHeight = totalHeight + self.translateDesc:getContentSize().height
	self.textDes:setString(self:getMonsterLvStr())
	totalHeight = totalHeight + mailNodeFactory:getWidgetItemHeight(self.textDes)
	boxInfo:setContentSize(cc.size(totalWidth, totalHeight))
	self:reSize(cc.size(self:getContentSize().width, self:getNewHeight(totalHeight)))
end
function mailItemMonsterReport:reinitMonsterSuccess()
	local boxInfo = self.customNode
	local totalHeight = 0
	mailFunctions = nil
	;(nil).fightResult = true
	;(nil).isShowTime = true
	;(nil).textShowTime = mailFunctions:getMailDetailDate(self.mail)
	self:reInitTop(nil)
	if not self.contentData.reward then
		self.rewardHead:setContentSize(cc.size(self.rewardHead:getContentSize().width, 0))
		self.rewardHead:setVisible(false)
	else
		self.rewardHead:setContentSize(cc.size(self.rewardHead:getContentSize().width, self.rewardHeadHeight))
		self.rewardHead:setVisible(true)
		totalHeight = totalHeight + self.rewardHead:getContentSize().height
	end
	self.monsterDetail:initWithData(self.contentData)
	totalHeight = totalHeight + self.monsterDetail:getItemHeight()
	self:recycleRewardItems(self.rewardLayout)
	self:createLayoutMonsterRewardItem(self.contentData, self.rewardLayout)
	totalHeight = totalHeight + self.rewardLayout:getContentSize().height
	self.translateDesc:setString(self:getTranslateRecordStr())
	totalHeight = totalHeight + self.translateDesc:getContentSize().height
	self.monsterSummary:initWithData(self.contentData)
	totalHeight = totalHeight + self.monsterSummary:getContentSize().height
	boxInfo:setContentSize(cc.size(totalWidth, totalHeight))
	self:reSize(cc.size(self:getContentSize().width, self:getNewHeight(totalHeight)))
end
function mailItemMonsterReport:reinitMonsterFailure()
	local boxInfo = self.customNode
	local totalHeight = 0
	mailFunctions = nil
	;(nil).isShowBlueTop = true
	;(nil).fightResult = false
	;(nil).isShowTime = true
	;(nil).textShowTime = mailFunctions:getMailDetailDate(self.mail)
	self:reInitTop(nil)
	self.monsterDetail:initWithData(self.contentData)
	totalHeight = totalHeight + self.monsterDetail:getItemHeight()
	local monsterLv = self:getMonsterLevel(self.contentData.monsterInfo)
	local monsterName = worldMapDefine.getMonsterName(self.contentData.monsterInfo.id)
	mailFunctions = mailFunctions
	mailFunctions.lv = monsterLv
	mailFunctions.name = monsterName
	local strInfo = i18n("common_text_160", mailFunctions)
	self.textDes:setString(strInfo)
	totalHeight = totalHeight + mailNodeFactory:getWidgetItemHeight(self.textDes)
	self.monsterSummary:initWithData(self.contentData)
	totalHeight = totalHeight + self.monsterSummary:getContentSize().height
	self:reSize(cc.size(self:getContentSize().width, self:getNewHeight(totalHeight)))
end
function mailItemMonsterReport:reinitMonsterInvalid()
	local boxInfo = self.customNode
	local totalHeight = 0
	_ENV = nil
	;(nil).isShowBlueTop = true
	;(nil).textShowResult = i18n("common_text_154")
	;(nil).isShowTime = true
	;(nil).isShowBg2 = true
	;(nil).textShowTime = mailFunctions:getMailDetailDate(self.mail)
	self:reInitTop(nil)
	self.monsterDetail:initWithData(self.contentData)
	totalHeight = totalHeight + self.monsterDetail:getItemHeight()
	local monsterLv = self:getMonsterLevel(self.contentData.monsterInfo)
	local monsterName = worldMapDefine.getMonsterName(self.contentData.monsterInfo.id)
	_ENV = mailFunctions
	mailFunctions.name = monsterName
	mailFunctions.lv = monsterLv
	local strInfo = i18n("common_text_161", mailFunctions)
	self.textDes:setString(strInfo)
	totalHeight = totalHeight + mailNodeFactory:getWidgetItemHeight(self.textDes)
	boxInfo:setContentSize(cc.size(totalWidth, totalHeight))
	self:reSize(cc.size(self:getContentSize().width, self:getNewHeight(totalHeight)))
end
function mailItemMonsterReport:addFirstKillImage(vLayout)
	local firstKillTexName = SoraDFIsRA() and "bg_mailinfo_monster_firstkill.png" or "bg_mailinfo_monster_firstkill_en.png"
	local channel = userSDKManager.getChannel()
	if channel == "ar" then
		firstKillTexName = SoraDFIsRA() and "bg_mailinfo_monster_firstkill.png" or "bg_mailinfo_monster_firstkill_en.png"
	elseif channel == "en" then
		firstKillTexName = "bg_mailinfo_monster_firstkill_en.png"
	elseif channel == "fa" then
		firstKillTexName = "bg_mailinfo_monster_firstkill_fa.png"
	else
		firstKillTexName = "bg_mailinfo_monster_firstkill_en.png"
	end
	_ENV, _ENV = nil, nil
	;(nil).left = 0
	;(nil).top = 20
	;(nil).right = 0
	;(nil).margin, (nil).bottom = nil, 0
	;(nil).imgName = firstKillTexName
	;(nil).name = "imgFK"
	;(nil).imagHeight = 108
	;(nil).imagWidth = 586
	;(nil).linearLayoutType = ccui.LinearGravity.centerHorizontal
	return mailNodeFactory:createImgViewLayout(nil)
end
function mailItemMonsterReport:addMonsterDetal(vLayout)
	local monsterInfoNode = include("mailItemDetailKillMonster").new()
	monsterInfoNode:setName("monsterDetail")
	monsterInfoNode:initWithData(self.contentData)
	monsterInfoNode:setContentSize(cc.size(monsterInfoNode:getItemWidth(), monsterInfoNode:getItemHeight()))
	vLayout:addChild(monsterInfoNode)
	monsterInfoNode:setSwallowTouches(false)
	local lp3 = ccui.LinearLayoutParameter:create()
	monsterInfoNode:setLayoutParameter(lp3)
	lp3:setGravity(ccui.LinearGravity.centerHorizontal)
	_ENV = ccui.LinearGravity.centerHorizontal
	ccui.LinearGravity.centerHorizontal.left = 0
	ccui.LinearGravity.centerHorizontal.top = 0
	ccui.LinearGravity.centerHorizontal.right = 0
	ccui.LinearGravity.centerHorizontal.bottom = 0
	lp3:setMargin(ccui.LinearGravity.centerHorizontal)
	return monsterInfoNode, monsterInfoNode:getItemHeight()
end
function mailItemMonsterReport:addAwardList(vLayout)
	local rewardLayout = self:createLayoutMonsterRewardItem(self.contentData)
	vLayout:addChild(rewardLayout)
	local lp3 = ccui.LinearLayoutParameter:create()
	rewardLayout:setLayoutParameter(lp3)
	lp3:setGravity(ccui.LinearGravity.centerHorizontal)
	_ENV = ccui.LinearGravity.centerHorizontal
	ccui.LinearGravity.centerHorizontal.left = 0
	ccui.LinearGravity.centerHorizontal.top = 0
	ccui.LinearGravity.centerHorizontal.right = 0
	ccui.LinearGravity.centerHorizontal.bottom = 0
	lp3:setMargin(ccui.LinearGravity.centerHorizontal)
	return rewardLayout, rewardLayout:getContentSize().height
end
function mailItemMonsterReport:addMonsterSummary(vLayout)
	local summaryNode = include("mailItemDetailMonsterSummary").new()
	summaryNode:initWithData(self.contentData)
	summaryNode:setName("monsterSummary")
	summaryNode:setContentSize(cc.size(summaryNode:getItemWidth(), summaryNode:getItemHeight()))
	vLayout:addChild(summaryNode)
	summaryNode:setSwallowTouches(false)
	local lp3 = ccui.LinearLayoutParameter:create()
	summaryNode:setLayoutParameter(lp3)
	lp3:setGravity(ccui.LinearGravity.centerHorizontal)
	_ENV = ccui.LinearGravity.centerHorizontal
	ccui.LinearGravity.centerHorizontal.left = 0
	ccui.LinearGravity.centerHorizontal.top = 0
	ccui.LinearGravity.centerHorizontal.right = 0
	ccui.LinearGravity.centerHorizontal.bottom = 0
	lp3:setMargin(ccui.LinearGravity.centerHorizontal)
	return summaryNode, summaryNode:getContentSize().height
end
function mailItemMonsterReport:getTranslateRecordStr()
	local strInfo = ""
	local translateRecord = self.contentData.reward and self.contentData.reward.translateRecord
	if translateRecord and next(translateRecord) ~= nil then
		local afterID = translateRecord.afterID
		local afterCount = SoraDConvertNumberWithUnit(translateRecord.afterCount)
		local name = publicRead.getName(afterID)
		local count = afterCount
		_ENV = nil
		;(nil).name = name
		;(nil).num = count
		strInfo = i18n("common_text_3120", nil)
	end
	return strInfo
end
function mailItemMonsterReport:getMonsterLvStr()
	local monsterLv = worldMapDefine.getMonsterLevel(self.contentData.monsterInfo.id)
	local maxMonsterLv = worldMapDefine.getMaxMonsterLevel()
	local strInfo = ""
	if monsterLv < maxMonsterLv then
		worldMapDefine = nil
		;(nil).lv = monsterLv
		;(nil).lvNext = monsterLv + 1
		strInfo = i18n("common_text_158", nil)
	else
		strInfo = i18n("common_text_3121")
	end
	return strInfo
end
function mailItemMonsterReport:getMonsterLevel(monsterInfo)
	local monsterLv
	if monsterInfo.armyGroupID then
		local commandHallUtil = include("commandHallUtil")
		monsterLv = commandHallUtil.getMonsterLevel(monsterInfo.armyGroupID)
	else
		monsterLv = worldMapDefine.getMonsterLevel(monsterInfo.id)
	end
	return monsterLv
end
return mailItemMonsterReport
