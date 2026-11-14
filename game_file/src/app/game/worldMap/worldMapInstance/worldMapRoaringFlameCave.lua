local roaringFlameWarCtrl = SoraDGetCtrl("roaringFlameWarCtrl")
local roaringFlameWarRead = include("roaringFlameWarRead")
local worldMapRoaringFlameCave = class("worldMapRoaringFlameCave", function()
	local target = include("worldMapInstance").new("worldMapRoaringFlameCave")
	return target
end)
function worldMapRoaringFlameCave:ctor()
	self.totalTime = roaringFlameWarRead.getConstValue("FLAMES_DUNES_CAVE_TIME", 43200)
	self:_initUI()
	self:_initData()
end
function worldMapRoaringFlameCave:_initData()
	self.warStatus = gKingdomWarStatusType.close
end
function worldMapRoaringFlameCave:_initUI()
	local obj = fgui.UIPackage:createObject("RoaringFlameWorldMap", "worldMapRoaringFlameCave")
	obj:addTo(self)
	self.fields = fguiHelper.get_fields(obj)
	self.controllers = fguiHelper.get_controllers(obj)
end
function worldMapRoaringFlameCave:initInstanceData(siteClassID, siteData, objId)
	self.siteClassID = siteClassID
	self:updateData(siteData)
end
function worldMapRoaringFlameCave:updateData(data)
	dump(data, "worldMapRoaringFlameCave:updateData")
	if not data then
		return
	end
	self.data = data
	local playerNum = #self.data.uidList
	self.controllers.c1:setSelectedIndex(0 < playerNum and 1 or 0)
	self.fields.Text_member:setString(playerNum)
	local campName = roaringFlameWarRead.getCampName(self.data.campId)
	self.fields.Text_camp:setString(campName)
	local campColor = roaringFlameWarRead.getCampColor(self.data.campId)
	self.fields.Text_camp:setColor(campColor)
	_ENV = nil
	;(nil).name = self.data.userName
	self.fields.Text_name:setString(i18n("flames_dunes_text143", nil))
	self.controllers.c2:setSelectedIndex(self.data.state == gRoaringFlameWarCaveStateEnum.EXPLORE and 0 or 1)
	local leftTime = self.data.endTime - serviceFunctions.systemTime()
	if self.data.state == gRoaringFlameWarCaveStateEnum.EXPLORE then
		if not self.totalTime then
			self.totalTime = self.data.endTime - self.data.beginTime
		end
		print("leftTime,self.totalTime=====", leftTime, self.totalTime)
		self.fields.Bar_explore:setTime(leftTime, self.totalTime)
	else
		self.fields.Label_time:beginTime(leftTime)
	end
end
function worldMapRoaringFlameCave:getInstanceOp(isSelfKindom)
	local roaringFlameWarCtrl, buttonTypeArray
	local selfCamp = roaringFlameWarCtrl:getSelfCamp()
	if self.data.campId == selfCamp then
		if self.data.state == gRoaringFlameWarCaveStateEnum.EXPLORE then
			roaringFlameWarCtrl = nil
			;(nil).buttonType = worldMapDefine.worldMapTipButtonType_9001674_cave_explore
			table.insert(buttonTypeArray, nil)
		elseif self.data.state == gRoaringFlameWarCaveStateEnum.EXPLORE_FINISH then
			roaringFlameWarCtrl = nil
			;(nil).buttonType = worldMapDefine.worldMapTipButtonType_9001674_cave_claim
			table.insert(buttonTypeArray, nil)
		end
	end
	roaringFlameWarCtrl = nil
	;(nil).buttonType = worldMapDefine.worldMapTipButtonType_shuoMing
	table.insert(buttonTypeArray, nil)
	return buttonTypeArray
end
function worldMapRoaringFlameCave:onClickTipButton(tipButtonType, tipButtonData, tipButtonExtra)
	if tipButtonType == worldMapDefine.worldMapTipButtonType_shuoMing then
		_ENV = nil
		;(nil).data = self.data
		;(nil).playerInfo = tipButtonData.playerInfo
		;(nil).receiveRecord = tipButtonData.receiveRecord
		uiManager:show("RoaringFlameTreasureCave_Detail", nil)
		return true
	elseif tipButtonType == worldMapDefine.worldMapTipButtonType_9001674_cave_explore then
		_ENV = nil
		;(nil).data = self.data
		uiManager:show("RoaringFlameTreasureCave_Pop", nil)
		return true
	elseif tipButtonType == worldMapDefine.worldMapTipButtonType_9001674_cave_claim then
		local isReveived = false
		if not tipButtonData.receiveRecord then
			_ENV = tipButtonData.receiveRecord
		end
		for k, v in ipairs(tipButtonData.receiveRecord) do
			if v.uid == SoraDGetPlayerID() then
				isReveived = true
				break
			end
		end
		if isReveived then
			SoraDShowMsgTip(i18n("rides_text_02"))
		else
			roaringFlameWarCtrl:reqReceiveCaveTreasure(self.data.objId)
		end
		return true
	end
	return false
end
return worldMapRoaringFlameCave
