local atlantisWarCtrl = SoraDGetCtrl("atlantisWarCtrl")
local kingdomMapCtrl = SoraDGetCtrl("kingdomMapCtrl")
local kingdomMapUtil = include("kingdomMapUtil")
local allianceDesRead = include("allianceDesRead")
local AMBC = require_data("atlantiswar_map_build_config").data
local atlantisWarUtil = include("atlantisWarUtil")
local atlantisWarBatteryStateView = class("atlantisWarBatteryStateView", function(target)
	if target == nil then
		return SoraDCreateBasePanel("atlantisWarBatteryStateView")
	elseif type(target) == "string" then
		return SoraDCreateBasePanel(target)
	end
	return target
end)
function atlantisWarBatteryStateView:ctor()
	self.isHideCurrentSceneView = true
	self:initWidget()
	self:showEffect()
end
function atlantisWarBatteryStateView:showEffect()
	local effectzcjr_top = SoraDCreatAnimation("atlantis_zcjr_top", nil, true)
	effectzcjr_top:setPosition(cc.p(240, 460))
	self.frame_shmc_flag_02_5:addChild(effectzcjr_top)
	local effectzcjr = SoraDCreatAnimation("atlantis_zcjr", nil, true)
	effectzcjr:setPosition(cc.p(320, 900))
	self.Top_Size_Image:addChild(effectzcjr)
end
function atlantisWarBatteryStateView:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_SERVER_KINGDOMWAR_KINGDOMWAR_PLACEINFOBACK", handler(self, self.updateStateInfo))
	SoraDAddMessage(self, "MESSAGE_ATLANTISWAR_BUILD_UPDATE", handler(self, self.updateBuild))
end
function atlantisWarBatteryStateView:initWidget(...)
	SoraDGetAllChildFromWidget(self._ccsView, self)
	self.ccs_title = SoraDGetExtendChildFromCCSByName(self, "CCS_commonFramTitle_title")
	self.ccs_title:setBtnHelpClickCallBack(handler(self, self.btnHelpClick))
	self.Text_time = SoraDCreateTimerLabel(self, self.Text_time)
	self.Text_time:setTimeLast(function(time)
		_ENV = nil
		;(nil).var = time
		return i18n("atlantiswar_text_0068", nil)
	end)
	self.Text_time:setTimeEndListener(function()
		self.Node_time:setVisible(false)
	end)
	self.ccs_head = SoraDGetExtendChildFromCCSByName(self, "CCS_commonHead_1")
	self.Text_noOccupy:setString(i18n("atlantiswar_text_0069"))
end
function atlantisWarBatteryStateView:btnHelpClick(button, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local title_name = AMBC[self.siteClassID].name
		local describe = AMBC[self.siteClassID].describe
		_ENV = nil
		;(nil)[902] = true
		;(nil)[903] = true
		local (nil)[904], config = true, nil
		if config[self.siteClassID] then
			_ENV = title_name
			_ENV = nil
			;(nil).key = i18n("atlantiswar_text_0428")
			title_name[1] = i18n(describe, nil)
			title_name[2] = i18n(describe, nil)
			title_name[3] = i18n(describe, nil)
			title_name[4] = i18n(describe, nil)
			title_name[5] = i18n(describe, nil)
			SoraDShowFixWindow(i18n(title_name), title_name)
		else
			_ENV = title_name
			title_name[1] = i18n(describe)
			title_name[2] = i18n(describe)
			title_name[3] = i18n(describe)
			title_name[4] = i18n(describe)
			title_name[5] = i18n(describe)
			SoraDShowFixWindow(i18n(title_name), title_name)
		end
	end
end
function atlantisWarBatteryStateView:initData(mapInstance, tipButtonData)
	dump(tipButtonData, "==tipButtonData==")
	self.mapInstance = mapInstance
	self.tipButtonData = tipButtonData
	self.siteClassID = self.mapInstance:getSiteClassID()
	self.subType = self.mapInstance:getSubType()
	if self.subType == gWorldTypeServerDef.subMapTypeAtlantisWarBattery then
		self.targetSubType = atlantisWarUtil.getTargetSubType(self.siteClassID)
	end
	self:refreshWarStatues()
	self:initTitleName()
	local buildIcon = AMBC[self.siteClassID].picture
	if buildIcon then
		self.Sprite_build:setSpriteFrame(buildIcon)
	end
	self:fitView()
	SoraDCreatAnimation(self.__cname, self._ccsView, false)
	self:reqInfo()
end
function atlantisWarBatteryStateView:fitView(...)
	if display.height < 1000 then
		self.Bottom_Node:setPositionY(-110)
		self.Text_des:setPositionY(175)
		if display.height < 900 then
			self.Sprite_build:setScale(0.7)
			if self.targetSubType == gBossType.atlantisWarWlyn then
				self.Sprite_build:setPositionX(-12)
			elseif self.targetSubType == gBossType.atlantisWarSd then
				self.Sprite_build:setPositionX(56)
			end
		end
	end
end
function atlantisWarBatteryStateView:initTitleName(...)
	local title_name = AMBC[self.siteClassID].name
	self.ccs_title:setTitle(i18n(title_name))
	if self.subType == gWorldTypeServerDef.subMapTypeAtlantisWarBattery then
		if self.targetSubType == gBossType.atlantisWarWlyn then
			self.Text_des:setString(i18n("atlantiswar_text_0071"))
			self.Sprite_build:setPositionX(-17)
		elseif self.targetSubType == gBossType.atlantisWarSd then
			self.Text_des:setString(i18n("atlantiswar_text_0084"))
		end
	end
end
function atlantisWarBatteryStateView:refreshWarStatues(...)
	if self.mapInstance and self.mapInstance.checkInWarStatus and self.mapInstance:checkInWarStatus() then
		self:updateView_inWar()
	else
		self:updateView_close()
	end
end
function atlantisWarBatteryStateView:updateView_close(...)
	self.Text_status:setString(i18n("common_text_4210"))
	self.Text_status:setColor(cc.c3b(94, 235, 61))
	self.Sprite_state:setVisible(true)
	self.Sprite_state_war:setVisible(false)
	if self.subType ~= gWorldTypeServerDef.subMapTypeAtlantisWarBattery then
		return
	end
	local stage
	if self.targetSubType == gBossType.atlantisWarWlyn then
		stage = gAtlantisWarStageType.wlynReady
	elseif self.targetSubType == gBossType.atlantisWarSd then
		stage = gAtlantisWarStageType.sdReady
	end
	local time = atlantisWarCtrl:getWarStageRemainTime(stage)
	if 0 < time then
		self.Node_time:setVisible(true)
		self.Text_time:beginTime(time)
	end
end
function atlantisWarBatteryStateView:updateView_inWar(...)
	self.Text_status:setString(i18n("common_text_1446"))
	self.Text_status:setColor(cc.c3b(239, 1, 1))
	self.Sprite_state:setVisible(false)
	self.Sprite_state_war:setVisible(true)
	self.Node_time:setVisible(false)
end
function atlantisWarBatteryStateView:showOcuppyInfo()
	local occupyUsrData = self.myPlaceInfo
	if occupyUsrData and occupyUsrData.uid and occupyUsrData.uid > 0 then
		self.Text_noOccupy:setVisible(false)
		self.Node_occupy:setVisible(true)
		self.ccs_head:setHeadSprite(occupyUsrData.iconID, occupyUsrData.avatar)
		self.ccs_head:setPlayerID(occupyUsrData.uid)
		local playerStr = serviceFunctions.getKingdomFormatName(occupyUsrData.name, occupyUsrData.fromKid)
		self.Text_player:setString(playerStr)
		local flagSprite = display.newSprite(allianceDesRead.getFlagIcon(occupyUsrData.flag, true))
		flagSprite:addTo(self.Node_flag)
		local kingdomName = occupyUsrData.kingdomName
		if not kingdomName or kingdomName == "" then
			kingdomName = "Kingdom"
		end
		self.Text_kingdom:setString(kingdomName)
		local selfCamp = atlantisWarCtrl:getSelfCamp()
		if occupyUsrData.camp == selfCamp then
			self.Node_troop:setVisible(true)
			local curNum = kingdomMapUtil.getArmyCount(self.tipButtonData.army)
			local maxNum = occupyUsrData.maxNum
			self.Text_troop:setString(string.format("%s/%s", string.formatnumberthousands(curNum), string.formatnumberthousands(maxNum)))
		else
			self.Node_troop:setVisible(false)
		end
	else
		self.Text_noOccupy:setVisible(true)
		self.Node_occupy:setVisible(false)
	end
end
function atlantisWarBatteryStateView:updateStateInfo(target, data)
	dump(data, "==atlantisWarBatteryStateView:updateStateInfo==")
	self.myPlaceInfo = data.retdata
	SoraDCloseLoading(self)
	self:showOcuppyInfo()
end
function atlantisWarBatteryStateView:updateBuild(target, data)
	print("==atlantisWarBatteryStateView:updateBuild==", data.siteClassID)
	if data and data.siteClassID == self.siteClassID then
		self:refreshWarStatues()
		self:reqInfo()
	end
end
function atlantisWarBatteryStateView:reqInfo(...)
	local mapInKid = worldMapDefine.currentMapKindomID
	kingdomMapCtrl:reqPlaceOwnerInfo(mapInKid, self.siteClassID)
	SoraDShowLoading(self)
end
return atlantisWarBatteryStateView
