local gametop = gModuleMgr.getObject("gametop")
local lordLocalData = include("lordLocalData")
local WorldMapSpyOnView = class("worldMapSpyOnView", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("worldMapSpyOnView")
	end
	return target
end)
function WorldMapSpyOnView:ctor()
	self.usrData, _ENV, self.scaleActTarget = SoraDGetChildByName(self, "Center_Panel_touch"), SoraDGetChildByName(self, "Center_Panel_touch"), SoraDGetChildByName(self, "Center_Panel_touch")
	self.costFood = 0
	self.ccs_bg = SoraDGetExtendChildFromCCSByName(self, "CCS_commonPopBox_bg")
	self.ccs_bg:setTitleName(i18n("common_text_007"))
	self.imgHead = SoraDGetChildByName(self, "Image_head")
	self.imgHeadFrm = SoraDGetChildByName(self, "Image_headFrm")
	self.nodeShow = SoraDGetChildByName(self, "Node_show")
	self.nodeShow:setVisible(false)
	self.txtName = SoraDGetChildByName(self.nodeShow, "Text_name")
	self.txtPos = SoraDGetChildByName(self, "Text_pos")
	self.txtCost = SoraDGetChildByName(self, "Text_res")
	self.txtTime = SoraDGetChildByName(self, "Text_time")
	self.btnGo = SoraDGetChildByName(self, "Button_go")
	self.btnRecent = SoraDGetChildByName(self, "Button_recent")
	self.imgScout = SoraDGetChildByName(self, "Image_scout")
	self.imgScout:loadTexture(SoraDCheckPNG("bg_mailinfo_scout.png", "bg_mailinfo_attacksuccess.png"), ccui.TextureResType.plistType)
	self.textRecent = SoraDGetChildByName(self, "Text_recent")
	self.text_btn_recent = SoraDGetChildByName(self.btnRecent, "text_button_recent")
	self.text_btn_recent:setString(i18n("common_text_2262"))
	self.nodeTime = SoraDGetChildByName(self, "Node_time")
	self.nodeRecent = SoraDGetChildByName(self, "Node_recent")
	SoraDToCenter(self.nodeRecent)
	self.nodeRes = SoraDGetChildByName(self, "Node_res")
	self.btnGo:addTouchEventListener(handler(self, self.btnGoClick))
	self.btnRecent:addTouchEventListener(handler(self, self.btnRecentClick))
	SoraDGetChildByName(self, "Text_scout"):setString(i18n("common_text_007"))
	self.btnRecent:setVisible(false)
	self.textRecent:setVisible(false)
	self.btnGo:setBright(false)
	self.btnGo:setTouchEnabled(false)
	self.imgHead:setVisible(false)
end
function WorldMapSpyOnView:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_LORDINFO_BY_UID", handler(self, self.msgGetLordInfo))
	SoraDAddMessage(self, "MESSAGE_WORLD_MAP_SPYONE_RESCOST", handler(self, self.getResCost))
end
function WorldMapSpyOnView:initData(data)
	self.usrData = data
	self:updateMailReport()
	_ENV = nil
	;(nil).x = self.usrData.uPos.x
	;(nil).y = self.usrData.uPos.y
	self.txtPos:setString(i18n("common_text_465", nil))
	local gametop = gModuleMgr.getObject("gametop")
	local kingdomMapCtrl = gametop.playertop_:getModule("kingdomMapCtrl")
	kingdomMapCtrl:reqGetScoutFood(self.usrData.uid, self.usrData.uPos.x, self.usrData.uPos.y, self.usrData.instanceID, self.usrData.instanceType)
	if gMapObjTypeDef.mapObjTypeAllianceBuild == self.usrData.instanceType then
		self.imgHeadFrm:setVisible(false)
		local bType = self.usrData.subMapID
		local allianceAbbr = self.usrData.otherData.leagueAbbrName
		local flagID = self.usrData.otherData.leagueFlag
		local allianceDesRead = include("allianceDesRead")
		local bIcon = allianceDesRead.getBuildIcon(bType)
		local name = allianceDesRead.getBuildName(bType)
		self.imgHead:setVisible(true)
		self.imgHead:loadTexture(bIcon, ccui.TextureResType.plistType)
		if gAllianceBuilding.FLAG == bType then
			local flagImg = display.newSprite(allianceDesRead.getFlagIcon(flagID, true))
			flagImg:setScale(0.3)
			flagImg:addTo(self.imgHead)
			flagImg:setPosition(50, 60)
		else
			self.imgHead:ignoreContentAdaptWithSize(true)
			self.imgHead:setScale(0.3)
		end
		_ENV = 60
		;(60).abbr = allianceAbbr
		;(60).name = name
		self.txtName:setString(i18n("common_text_186", 60))
	elseif gMapObjTypeDef.mapObjTypeBattlefieldSite == self.usrData.instanceType then
		self.imgHeadFrm:setVisible(false)
		local bType = self.usrData.subMapID
		local bIcon = worldMapDefine.getPyramidbuildingImage(bType)
		local name = worldMapDefine.getPyramidbuildingName(bType, self.usrData.objId)
		self.imgHead:setVisible(true)
		self.imgHead:loadTexture(bIcon, ccui.TextureResType.plistType)
		self.imgHead:ignoreContentAdaptWithSize(true)
		self.imgHead:setScale(125 / self.imgHead:getContentSize().width)
		self.txtName:setString(name)
	else
		if self.usrData.abbr then
			_ENV = self.txtName
			self.txtName.abbr = self.usrData.abbr
			self.txtName.name = self.usrData.name
			self.txtName:setString(i18n("common_text_186", self.txtName))
		else
			self.txtName:setString(self.usrData.name)
		end
		_ENV = i18n("common_text_186", self.txtName)
		i18n("common_text_186", self.txtName).targetName = self.__cname
		kingdomMapCtrl:getLordInfoByUid(self.usrData.uid, self.usrData.uPos.x, self.usrData.uPos.y, self.usrData.instanceID, i18n("common_text_186", self.txtName))
	end
	SoraDShowLoading(self, nil, nil, nil, 10)
end
function WorldMapSpyOnView:getResCost(target, redata)
	self.costFood = redata.data
	self.txtCost:setString(string.formatnumberthousands(redata.data))
	SoraDToCenter(self.nodeRes)
	self.btnGo:setBright(true)
	self.btnGo:setTouchEnabled(true)
	local kingdomMapCtrl = gametop.playertop_:getModule("kingdomMapCtrl")
	local costTime = kingdomMapCtrl:getArmyMoveTime(gMapObjTypeDef.mapObjTypePlayer, worldMapDefine.worldMapTipButtonType_zhenCha, nil, self.usrData.uPos)
	self.txtTime:setString(SoraDConvertSecondToString(costTime))
	self.nodeShow:setVisible(true)
	SoraDToCenter(self.nodeTime)
	SoraDCloseLoading(self)
end
function WorldMapSpyOnView:btnGoClick(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if SoraDEnoughTroops() then
			if SoraDEnoughRes(gIDDef.FOOD, self.costFood) then
				_ENV = SoraDEnoughRes(gIDDef.FOOD, self.costFood)
				SoraDEnoughRes(gIDDef.FOOD, self.costFood).dispatchType = worldMapDefine.worldMapTipButtonType_zhenCha
				SoraDEnoughRes(gIDDef.FOOD, self.costFood).toPoint = self.usrData.uPos
				local SoraDEnoughRes(gIDDef.FOOD, self.costFood).instanceID, armyData = self.usrData.instanceID, SoraDEnoughRes(gIDDef.FOOD, self.costFood)
				worldMapFunction.gotoDispatch(armyData, true)
				self:removeFromParent()
			else
				SoraDShowMsgBox(i18n("common_text_800"), i18n("common_text_204"), nil, nil)
				self:removeFromParent()
			end
		else
			self:removeFromParent()
		end
	end
end
function WorldMapSpyOnView:msgGetLordInfo(target, data)
	SoraDCloseLoading()
	if not data.lord then
		return
	end
	local lordHeadID = data.lord.base.imageId
	local lordAvatar = data.lord.base.avatar
	self.imgHead:setVisible(true)
	SoraDGetHeadFromManager(self.imgHead, lordHeadID, lordAvatar)
end
function WorldMapSpyOnView:updateMailReport()
	local scoutRecordCtrl = gametop.playertop_:getModule("scoutRecordCtrl")
	local reportRecord = scoutRecordCtrl:getScoutRecord(self.usrData.uid)
	if reportRecord ~= nil then
		self.btnRecent:setVisible(true)
		self.textRecent:setVisible(true)
		local lastSpyTime = reportRecord.t
		local timeStr = SoraDConvertTimeToDate(lastSpyTime, false, true, true)
		self.textRecent:setString(timeStr)
		if SoraDFIsRA() then
			self.btnRecent:setPositionX(150)
			self.btnGo:setPositionX(450)
		else
			self.btnRecent:setPositionX(450)
			self.btnGo:setPositionX(150)
		end
	else
		self.btnRecent:setVisible(false)
		self.textRecent:setVisible(false)
		self.btnRecent:setPositionX(300)
		self.btnGo:setPositionX(300)
	end
end
function WorldMapSpyOnView:btnRecentClick(target, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local scoutRecordCtrl = gametop.playertop_:getModule("scoutRecordCtrl")
		local reportRecord = scoutRecordCtrl:getScoutRecord(self.usrData.uid)
		if reportRecord ~= nil then
			local mid = reportRecord.mailId
			SoraDRequestMailReport(mid, true)
			self:close(nil, ccui.TouchEventType.ended)
		else
			SoraDShowMsgTip(i18n("common_text_502"))
		end
	end
end
return WorldMapSpyOnView
