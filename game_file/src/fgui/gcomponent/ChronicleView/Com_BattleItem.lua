local legendMDesRead = include("legendMDesRead")
local mailFunctions = include("mailFunctions")
local gametop = gModuleMgr.getObject("gametop")
local legendMCtrl = gametop.playertop_:getModule("legendMCtrl")
local hegemonRead = include("hegemonRead")
local palaceInfoRead = include("palaceInfoRead")
local KWKingdomCtrl = gametop.playertop_:getModule("KWKingdomCtrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_BattleItem = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://ChronicleView/Com_BattleItem", Com_BattleItem)
_ENV = fgui.register_extension
fgui.register_extension.imgInfo = "frame_sdbns_gantanhan.png"
fgui.register_extension.imgReward = "frame_sdbns_baoxinag.png"
fgui.register_extension.iconGoodNormal = "frame_sdbns_dianzan_dianji.png"
local fgui.register_extension.iconGooded, _defaultParam = "frame_sdbns_dianzan.png", fgui.register_extension
function Com_BattleItem:onInit()
	self:fixChildrenPos()
	self.originPosX = self.fields.imgBuild:getPositionX()
	self.fields.btn_like:addClickListener(handler(self, self.onClick_btnLike))
end
function Com_BattleItem:onShow()
end
function Com_BattleItem:initData(data, isSelfKindom)
	self.data = data
	dump(self.data, "self.data")
	self.serverData = data.data
	self.pageType = self.data.pageType
	self.isSelfKindom = isSelfKindom
	self:updatePraiseNum()
	if self.pageType == legendMDesRead.PageType.KINGDOM_BATTLE then
		self:updateKingdomBattle()
	elseif self.pageType == legendMDesRead.PageType.SERVER_BATTLE then
		self:updateServerBattle()
	end
	self.fields.txt_title:setString(self.strTitle)
	self.fields.txt_des:setString(self.strDes)
	local strYear = legendMCtrl:getHistoryYearFull(self.serverData.sortTime, true)
	self.fields.txt_time:setString(strYear)
end
function Com_BattleItem:updatePraiseNum()
	local praiseNum = self.serverData.praiseNum or 0
	self.fields.txt_like_num:setString(praiseNum)
	self.isSelfPraised = legendMCtrl:getIsSelfPraiseById(self.serverData.reportID)
	if self.isSelfPraised then
		self.fields.btn_like:setIcon(_defaultParam.iconGooded)
		self.fields.btn_like:setTouchable(false)
	else
		self.fields.btn_like:setIcon(_defaultParam.iconGoodNormal)
		self.fields.btn_like:setTouchable(true)
	end
end
function Com_BattleItem:updateKingdomBattle()
	if not self.serverData.warType then
		self.serverData.warType = self.serverData.recordType
	end
	local funcName = "updateCivilWarType_" .. self.serverData.warType
	if self[funcName] then
		self[funcName](self)
	end
end
function Com_BattleItem:updateServerBattle()
	local funcName = "updateCountryWarType_" .. self.serverData.warType
	if self[funcName] then
		self[funcName](self)
	end
end
function Com_BattleItem:updatePlayerCastleBuild()
	local castleLv, castleSkin
	if self.serverData.isAttackWin then
		castleLv = self.serverData.atkSummary.castleLv
	else
		castleLv = self.serverData.defSummary.castleLv
	end
	castleLv = castleLv or 10
	self.fields.playerCastle:setVisible(true)
	self.fields.imgBuild:setVisible(false)
	self.fields.playerCastle:displayObject():removeAllChildren()
	local offsetPos = cc.p(0, 0)
	offsetPos.x = -10
	local playerCastle = worldMapDefine.createCityImageWithLevel(castleLv)
	if 80 < castleLv then
		playerCastle:setScale(0.4)
	else
		playerCastle:setScale(0.45)
	end
	self.fields.playerCastle:displayObject():addChild(playerCastle)
	playerCastle:setPosition(-10, 5)
end
function Com_BattleItem:updateKingdomCastleBuild()
	local bigCastaleMode = self.serverData.palaceModel or KWKingdomCtrl:getKingdomCastaleModel()
	local imgBuildName = palaceInfoRead.getIcon(bigCastaleMode)
	self.fields.imgBuild:setURL(imgBuildName)
	self.fields.imgBuild:setScale(0.9)
	self.fields.playerCastle:setVisible(false)
	self.fields.imgBuild:setVisible(true)
	self.fields.imgBuild:setPositionX(self.originPosX)
end
function Com_BattleItem:updateLegendBuild()
	local buildTypeID = self.serverData.buildId or self.serverData.toObjID
	local imgBuildName = hegemonRead.getImage(buildTypeID)
	self.fields.imgBuild:setURL(imgBuildName)
	local offsetPos = cc.p(0, 0)
	if hegemonRead.isLegendLordBuilding(buildTypeID) then
		offsetPos.x = -25
	else
		offsetPos.x = 10
	end
	self.fields.imgBuild:setScale(0.3)
	self.fields.imgBuild:setPositionX(self.originPosX + offsetPos.x)
	self.fields.playerCastle:setVisible(false)
	self.fields.imgBuild:setVisible(true)
end
function Com_BattleItem:onClick_btnLike()
	SoraDPlaySound()
	if not self.isSelfKindom then
		SoraDShowMsgTip(i18n("CombineServers_36"))
		return
	end
	legendMCtrl:reqPraise(self.serverData.reportType, self.serverData.reportID)
	SoraDShowMsgTip(i18n("history_text_16"))
	self.serverData.praiseNum = (self.serverData.praiseNum or 0) + 1
	self.fields.txt_like_num:setString(self.serverData.praiseNum)
	self.fields.btn_like:setIcon(_defaultParam.iconGooded)
	self.fields.btn_like:setTouchable(false)
end
function Com_BattleItem.calculateWar(serverData)
	local mailFunctions, ret
	local atkSummary = serverData.atkSummary
	local defSummary = serverData.defSummary
	ret.atkSummary = serverData.atkSummary
	ret.defSummary = serverData.defSummary
	ret.attackName = mailFunctions:getWrappedName(atkSummary.abbr, atkSummary.nickName, serverData.sourceKidAtk)
	ret.defName = mailFunctions:getWrappedName(defSummary.abbr, defSummary.nickName, serverData.sourceKidDef)
	ret.allLostPower = string.formatnumberthousands(atkSummary.lostPower + defSummary.lostPower)
	ret.num = ret.allLostPower
	ret.armyNum = string.formatnumberthousands(atkSummary.lostNum + atkSummary.woundedNum + defSummary.lostNum + defSummary.woundedNum)
	ret.defNum = string.formatnumberthousands(defSummary.woundedNum + defSummary.lostNum)
	ret.allNum = string.formatnumberthousands(atkSummary.lostNum + atkSummary.woundedNum + atkSummary.surviveNum + defSummary.lostNum + defSummary.woundedNum + defSummary.surviveNum)
	ret.atkLost = string.formatnumberthousands(ret.atkSummary.lostNum + ret.atkSummary.woundedNum)
	local name
	if serverData.isAttackWin then
		name = ret.attackName
	else
		name = ret.defName
	end
	ret.isAttackWin = serverData.isAttackWin
	ret.name = name
	return ret
end
function Com_BattleItem.getStrTitleAndDes_Civil_1(serverData)
	local warRet = Com_BattleItem.calculateWar(serverData)
	local strTitle = i18n("history_text_18")
	Com_BattleItem = nil
	;(nil).attackName = warRet.attackName
	;(nil).defName = warRet.defName
	;(nil).num = warRet.num
	;(nil).armyNum = warRet.armyNum
	;(nil).name = warRet.name
	local strDes = i18n("history_text_19", nil)
	return strTitle, strDes
end
function Com_BattleItem.getStrTitleAndDes_Civil_2(serverData)
	local strName = mailFunctions:getWrappedName(serverData.allianceAbbr, serverData.userName)
	mailFunctions = serverData.userName
	serverData.userName.name = strName
	local strTitle = i18n("history_text_24", serverData.userName)
	local server = SoraDGetKingdomName(serverData.sourcdKid)
	local time = SoraDConvertSecondToString(serverData.totalSec)
	mailFunctions = nil
	;(nil).time = time
	;(nil).allianceName = strName
	;(nil).server = server
	;(nil).name = strName
	local strDes = i18n("history_text_04", nil)
	return strTitle, strDes
end
function Com_BattleItem.getStrTitleAndDes_Civil_3(serverData)
	local warRet = Com_BattleItem.calculateWar(serverData)
	local strTitle = i18n("history_text_20")
	Com_BattleItem = nil
	;(nil).attactName = warRet.attackName
	;(nil).defName = warRet.defName
	;(nil).num = warRet.num
	;(nil).armyNum = warRet.armyNum
	;(nil).defNum = warRet.defNum
	;(nil).name = warRet.name
	local strDes = i18n("history_text_21", nil)
	return strTitle, strDes
end
function Com_BattleItem.getStrTitleAndDes_Civil_4(serverData)
	local warRet = Com_BattleItem.calculateWar(serverData)
	local num = warRet.allNum
	local num1 = warRet.allLostPower
	local num2 = warRet.armyNum
	local num3 = warRet.atkLost
	local strTitle = i18n("history_text_22")
	Com_BattleItem = nil
	;(nil).attackName = warRet.attackName
	;(nil).defName = warRet.defName
	;(nil).num = num
	;(nil).num1 = num1
	;(nil).num2 = num2
	;(nil).num3 = num3
	;(nil).armyNum = warRet.armyNum
	;(nil).name = warRet.name
	local strDes = i18n("history_text_23", nil)
	return strTitle, strDes
end
function Com_BattleItem:updateCivilWarType_1()
	self.strTitle, self.strDes = Com_BattleItem.getStrTitleAndDes_Civil_1(self.serverData)
	self:updateKingdomCastleBuild()
end
function Com_BattleItem:updateCivilWarType_2()
	self.strTitle, self.strDes = Com_BattleItem.getStrTitleAndDes_Civil_2(self.serverData)
	self:updateKingdomCastleBuild()
end
function Com_BattleItem:updateCivilWarType_3()
	self.strTitle, self.strDes = Com_BattleItem.getStrTitleAndDes_Civil_3(self.serverData)
	self:updatePlayerCastleBuild()
end
function Com_BattleItem:updateCivilWarType_4()
	self.strTitle, self.strDes = Com_BattleItem.getStrTitleAndDes_Civil_4(self.serverData)
	self:updatePlayerCastleBuild()
end
function Com_BattleItem.getStrTitleAndDes_Country_1(serverData)
	local warRet = Com_BattleItem.calculateWar(serverData)
	local strTitle = i18n("history_text_25")
	local num1 = warRet.armyNum
	Com_BattleItem = nil
	;(nil).attackName = warRet.attackName
	;(nil).defName = warRet.defName
	;(nil).num = warRet.num
	;(nil).num1 = num1
	;(nil).name = warRet.name
	local strDes = i18n("history_text_26", nil)
	return strTitle, strDes
end
function Com_BattleItem:updateCountryWarType_1()
	self.strTitle, self.strDes = Com_BattleItem.getStrTitleAndDes_Country_1(self.serverData)
	self:updateLegendBuild()
end
function Com_BattleItem.getStrTitleAndDes_Country_2(serverData)
	local warRet = Com_BattleItem.calculateWar(serverData)
	local strTitle = i18n("history_text_27")
	local lord = warRet.name
	local buildTypeID = serverData.buildId or serverData.toObjID
	local buildName = hegemonRead.getName(buildTypeID)
	local name = buildName
	Com_BattleItem = nil
	;(nil).attackName = warRet.attackName
	;(nil).defName = warRet.defName
	;(nil).num = warRet.num
	;(nil).num1 = warRet.armyNum
	;(nil).name = name
	;(nil).lord = lord
	local strDes = i18n("history_text_28", nil)
	return strTitle, strDes
end
function Com_BattleItem:updateCountryWarType_2()
	self.strTitle, self.strDes = Com_BattleItem.getStrTitleAndDes_Country_2(self.serverData)
	self:updateLegendBuild()
end
function Com_BattleItem.getStrTitleAndDes_Country_3(serverData)
	local warRet = Com_BattleItem.calculateWar(serverData)
	local strTitle = i18n("history_text_20")
	Com_BattleItem = nil
	;(nil).attactName = warRet.attackName
	;(nil).defName = warRet.defName
	;(nil).num = warRet.num
	;(nil).armyNum = warRet.armyNum
	;(nil).defNum = warRet.defNum
	;(nil).name = warRet.name
	local strDes = i18n("history_text_21", nil)
	return strTitle, strDes
end
function Com_BattleItem:updateCountryWarType_3()
	self.strTitle, self.strDes = Com_BattleItem.getStrTitleAndDes_Country_3(self.serverData)
	self:updatePlayerCastleBuild()
end
function Com_BattleItem.getStrTitleAndDes_Country_4(serverData)
	local warRet = Com_BattleItem.calculateWar(serverData)
	local num = warRet.allNum
	local num1 = warRet.allLostPower
	local num2 = warRet.armyNum
	local num3 = warRet.atkLost
	local strTitle = i18n("history_text_22")
	Com_BattleItem = nil
	;(nil).attackName = warRet.attackName
	;(nil).defName = warRet.defName
	;(nil).num = num
	;(nil).num1 = num1
	;(nil).num2 = num2
	;(nil).num3 = num3
	;(nil).armyNum = warRet.armyNum
	;(nil).name = warRet.name
	local strDes = i18n("history_text_23", nil)
	return strTitle, strDes
end
function Com_BattleItem:updateCountryWarType_4()
	self.strTitle, self.strDes = Com_BattleItem.getStrTitleAndDes_Country_4(self.serverData)
	self:updatePlayerCastleBuild()
end
function Com_BattleItem.calculateResult(serverData)
	local round = serverData.round
	local time = SoraDConvertSecondToString(serverData.totalSec or 0)
	local lord = mailFunctions:getWrappedName(serverData.allianceAbbr, serverData.userName, serverData.sourceKid)
	_ENV = mailFunctions
	mailFunctions.round = round
	mailFunctions.time = time
	mailFunctions.lord = lord
	return mailFunctions
end
function Com_BattleItem.getStrTitleAndDes_Country_5(serverData)
	local warRet = Com_BattleItem.calculateResult(serverData)
	Com_BattleItem = nil
	;(nil).lord = warRet.lord
	;(nil).num = warRet.round
	local strTitle = i18n("history_text_31", nil)
	Com_BattleItem = warRet.round
	warRet.round.time = warRet.time
	warRet.round.lord = warRet.lord
	warRet.round.num = string.formatnumberthousands(serverData.totalKill)
	warRet.round.num1 = warRet.round
	local strDes = i18n("history_text_32", warRet.round)
	return strTitle, strDes
end
function Com_BattleItem:updateCountryWarType_5()
	self.strTitle, self.strDes = Com_BattleItem.getStrTitleAndDes_Country_5(self.serverData)
	self:updateLegendBuild()
end
function Com_BattleItem.getStrTitleAndDes_Country_6(serverData)
	local warRet = Com_BattleItem.calculateResult(serverData)
	local buildTypeID = serverData.buildId
	local buildName = hegemonRead.getName(buildTypeID)
	Com_BattleItem = nil
	;(nil).lord = warRet.lord
	;(nil).name = buildName
	local strTitle = i18n("history_text_29", nil)
	Com_BattleItem = warRet.lord
	warRet.lord.time = warRet.time
	warRet.lord.lord = warRet.lord
	warRet.lord.num1 = string.formatnumberthousands(serverData.totalKill)
	warRet.lord.name = buildName
	warRet.lord.num = warRet.round
	warRet.lord.name1 = buildName
	local strDes = i18n("history_text_30", warRet.lord)
	return strTitle, strDes
end
function Com_BattleItem:updateCountryWarType_6()
	self.strTitle, self.strDes = Com_BattleItem.getStrTitleAndDes_Country_6(self.serverData)
	self:updateLegendBuild()
end
function Com_BattleItem.getStrTitleAndDes_Country_7(serverData)
	local warRet = Com_BattleItem.calculateResult(serverData)
	Com_BattleItem = nil
	;(nil).num = warRet.round
	;(nil).time = warRet.time
	;(nil).num1 = string.formatnumberthousands(serverData.totalKill)
	local strDes1 = i18n("mail_text_530", nil)
	local strDes2, strTitle
	if serverData.kid == serverData.winKid then
		strTitle = i18n("history_title_03")
		local loseKid = SoraDGetKingdomName(serverData.loseKid)
		Com_BattleItem = nil
		;(nil).lord = loseKid
		strDes2 = i18n("mail_text_531", nil)
	else
		strTitle = i18n("history_title_06")
		strDes2 = i18n("mail_text_532")
	end
	local strDes = strDes1 .. strDes2
	return strTitle, strDes
end
function Com_BattleItem:updateCountryWarType_7()
	self.strTitle, self.strDes = Com_BattleItem.getStrTitleAndDes_Country_7(self.serverData)
	self:updateKingdomCastleBuild()
end
function Com_BattleItem.getStrTitleAndDes_Country_8(serverData)
	local warRet = Com_BattleItem.calculateWar(serverData)
	local strTitle = i18n("history_text_25")
	local num1 = warRet.armyNum
	Com_BattleItem = nil
	;(nil).attackName = warRet.attackName
	;(nil).defName = warRet.defName
	;(nil).num = warRet.num
	;(nil).num1 = num1
	;(nil).name = warRet.name
	local strDes = i18n("kingstarbattle_text_82", nil)
	return strTitle, strDes
end
function Com_BattleItem:updateCountryWarType_8()
	self.strTitle, self.strDes = Com_BattleItem.getStrTitleAndDes_Country_8(self.serverData)
	self:updateLegendBuild()
end
function Com_BattleItem.getStrTitleAndDes_Country_9(serverData)
	local warRet = Com_BattleItem.calculateResult(serverData)
	Com_BattleItem = nil
	;(nil).lord = warRet.lord
	;(nil).num = warRet.round
	local strTitle = i18n("kingstarbattle_text_71", nil)
	Com_BattleItem = warRet.round
	warRet.round.time = warRet.time
	warRet.round.lord = warRet.lord
	warRet.round.num = string.formatnumberthousands(serverData.totalKill)
	warRet.round.num1 = warRet.round
	local strDes = i18n("kingstarbattle_text_83", warRet.round)
	return strTitle, strDes
end
function Com_BattleItem:updateCountryWarType_9()
	self.strTitle, self.strDes = Com_BattleItem.getStrTitleAndDes_Country_9(self.serverData)
	self:updateLegendBuild()
end
return Com_BattleItem
