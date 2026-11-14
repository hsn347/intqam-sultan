local roaringFlameWarCtrl = SoraDGetCtrl("roaringFlameWarCtrl")
local roaringFlameWarRead = include("roaringFlameWarRead")
local worldMapRoaringFlameBox = class("worldMapRoaringFlameBox", function()
	local target = include("worldMapInstance").new("worldMapRoaringFlameBox")
	return target
end)
function worldMapRoaringFlameBox:ctor()
	self.ignoreRequest = true
	self.totalTime = roaringFlameWarRead.getConstValue("FLAMES_DUNES_CITY_BOX_TIME", 7200)
	self:_initUI()
	self:_initData()
end
function worldMapRoaringFlameBox:_initData()
	self.warStatus = gKingdomWarStatusType.close
	self.preStatus = nil
end
function worldMapRoaringFlameBox:_initUI()
	local obj = fgui.UIPackage:createObject("RoaringFlameWorldMap", "worldMapRoaringFlameBox")
	obj:addTo(self)
	self.fields = fguiHelper.get_fields(obj)
	self.image_Protect = worldMapDefine.createWorldMapProtect()
	self.image_Protect:setScale(0.7)
	self.image_Protect:setPosition(cc.p(self.centerPoint.x + 0, self.centerPoint.y + 50))
	self.image_Protect:addTo(self, 1)
end
function worldMapRoaringFlameBox:addCacheBefore()
	local nodeEffect_unlock = SoraDGetChildByName(self, "nodeEffect_unlock")
	if nodeEffect_unlock then
		nodeEffect_unlock:removeFromParent()
	end
end
function worldMapRoaringFlameBox:initProgressBar(...)
	self.progressBar = SoraDCreatePanel("worldMapBossProgressBar")
	self.progressBar:setPosition(cc.p(self.centerPoint.x - 0, self.centerPoint.y - 60))
	self.progressBar:setAnchorPoint(cc.p(0.5, 0.5))
	self.progressBar:addTo(self, 1)
	self.progressBar:setGroupID(worldMapDefine.GROU_ID.group_progress_monster)
	self.progressBar:setGroupAuto(true)
	self.progressBar:setVisible(false)
end
function worldMapRoaringFlameBox:initInstanceData(siteClassID, siteData, objId)
	self.siteClassID = siteClassID
	self:updateData(siteData)
end
function worldMapRoaringFlameBox:updateData(data)
	dump(data, "worldMapRoaringFlameBox:updateData")
	if not data then
		return
	end
	self.data = data
	local boxImage
	if not self.data.receiveUidMap then
		local _ENV, receiveUidMap = self.data.receiveUidMap, self.data.receiveUidMap
	end
	local selfUid = SoraDGetPlayerID()
	self.isReceive = receiveUidMap[tostring(selfUid)]
	if self.isReceive then
		boxImage = "frames_dunes_build_box_open.png"
	else
		boxImage = "frames_dunes_build_box.png"
	end
	self.fields.Image_box:setURL(boxImage)
	local camp = self.data.camp
	if camp and 0 < camp then
		self.warStatus = gKingdomWarStatusType.inWar
		local leftTime = self.data.boxEndTime - serviceFunctions.systemTime()
		if 0 < leftTime then
			if not self.progressBar then
				self:initProgressBar()
			end
			self.progressBar:setVisible(true)
			self.progressBar:setTimeValue(leftTime, self.totalTime)
		elseif self.progressBar then
			self.progressBar:setVisible(false)
		end
		self.fields.Node_camp:setVisible(true)
		local campName = roaringFlameWarRead.getCampName(camp)
		if self.isReceive then
			campName = campName .. string.format("(%s)", i18n("common_text_1892"))
		end
		self.fields.Text_camp:setString(campName)
		local campColor = roaringFlameWarRead.getCampColor(camp)
		self.fields.Text_camp:setColor(campColor)
	else
		self.warStatus = gKingdomWarStatusType.close
		if self.progressBar then
			self.progressBar:setVisible(false)
		end
		self.fields.Node_camp:setVisible(false)
	end
	self:updateSafeState()
	self:showNodeEffectUnlock()
end
function worldMapRoaringFlameBox:updateSafeState()
	if self:checkInWarStatus() then
		self.image_Protect:setVisible(false)
	else
		self.image_Protect:setVisible(true)
	end
end
function worldMapRoaringFlameBox:checkInWarStatus(...)
	return self.warStatus == gKingdomWarStatusType.inWar
end
function worldMapRoaringFlameBox:showNodeEffectUnlock()
	if self.preStatus and self.preStatus ~= gKingdomWarStatusType.inWar and self:checkInWarStatus() then
		local roaringFlameWarUtil = include("roaringFlameWarUtil")
		roaringFlameWarUtil.showNodeEffectUnlock(self)
	end
	self.preStatus = self.warStatus
end
function worldMapRoaringFlameBox:getInstanceOp(isSelfKindom)
	local _ENV, buttonTypeArray
	if self:checkInWarStatus() then
		_ENV = nil
		;(nil).buttonType = worldMapDefine.worldMapTipButtonType_activity_9001670_lingqu
		table.insert(buttonTypeArray, nil)
	end
	_ENV = nil
	;(nil).buttonType = worldMapDefine.worldMapTipButtonType_shuoMing
	table.insert(buttonTypeArray, nil)
	return buttonTypeArray
end
function worldMapRoaringFlameBox:onClickTipButton(tipButtonType, tipButtonData, tipButtonExtra)
	if tipButtonType == worldMapDefine.worldMapTipButtonType_shuoMing then
		_ENV = nil
		;(nil).defaultClick = 1
		;(nil).buildLv = self.data.level
		uiManager:show("RoaringFlameWar_BuildReward", nil)
		return true
	elseif tipButtonType == worldMapDefine.worldMapTipButtonType_activity_9001670_lingqu then
		local selfCamp = roaringFlameWarCtrl:getSelfCamp()
		local camp = self.data.camp
		if camp and camp == selfCamp then
			roaringFlameWarCtrl:reqReceiveOccupyBox(self.siteClassID)
		else
			SoraDShowMsgTip(i18n("flames_dunes_text245"))
		end
		return true
	end
	return false
end
return worldMapRoaringFlameBox
