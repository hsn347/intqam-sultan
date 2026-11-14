local gametop = gModuleMgr.getObject("gametop")
local armyCtrl = gametop.playertop_:getModule("armyCtrl")
local queueCtrl = gametop.playertop_:getModule("queueCtrl")
local worldMapComHospital = class("worldMapComHospital", include("worldMapCom"))
_ENV = "worldMapComHospital"
;("worldMapComHospital").HOSPITAL_STATUES_NORMAL = 1
;("worldMapComHospital").HOSPITAL_STATUES_HAS_CURE = 2
;("worldMapComHospital").HOSPITAL_STATUES_HELP = 3
local ("worldMapComHospital").HOSPITAL_STATUES_CURING, HOSPITAL_STATUES = 4, "worldMapComHospital"
local getHospitalStatus = function(queueType)
	local bRet = HOSPITAL_STATUES.HOSPITAL_STATUES_NORMAL
	if worldMapDefine:isInWar() then
		if armyCtrl:getCuringArmyCount(queueType) > 0 then
			if queueCtrl:isNeedReqHelp(queueType) then
				bRet = HOSPITAL_STATUES.HOSPITAL_STATUES_HELP
			else
				bRet = HOSPITAL_STATUES.HOSPITAL_STATUES_CURING
			end
		else
			if 0 < armyCtrl:getTotalWoundedArmyCount() then
				bRet = HOSPITAL_STATUES.HOSPITAL_STATUES_HAS_CURE
			else
			end
		end
	end
	return bRet
end
function worldMapComHospital:ctor()
	worldMapComHospital.super.ctor(self, "worldMapComHospital")
	self.hospitalStatues = HOSPITAL_STATUES.HOSPITAL_STATUES_NORMAL
end
function worldMapComHospital:init()
	self.buttonHospital = SoraDGetChildByName(self.target_, "Button_hospital")
	if self.buttonHospital then
		self.buttonHospital:addTouchEventListener(handler(self, self.buttonHospitalCall))
		if worldMapDefine.isRoaringFlameKingdomID() then
			self.iconHospital = SoraDGetChildByName(self.buttonHospital, "icon")
			self.buttonHospital:setString(i18n("flames_dunes_text25"))
		elseif worldMapDefine.isInSimulatedDrill() then
			self.iconHospital = SoraDGetChildByName(self.buttonHospital, "icon")
			self.buttonHospital:setString(i18n("common_text_065"))
		else
			self.iconHospital = SoraDGetChildByName(self.buttonHospital, "icon_hospital")
			if not self.iconHospital then
				self.iconHospital = SoraDGetChildByName(self.buttonHospital, "icon")
			end
		end
	end
	local worldMapWarDef = include("worldMapWarDef")
	self.queueType = worldMapWarDef.getHostpitalQueueType(self.target_.mapClassType)
end
function worldMapComHospital:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_MAINCITYVIEW_UPDATE_HOSPTIAL_VIEW", handler(self, self.updateHospitalBtn))
	SoraDAddMessage(self, "MESSAGE_ITEM_SPEED_UP_BACK", handler(self, self.updateHospitalBtn))
	SoraDAddMessage(self, "MESSAGE_MAINCITYVIEW_UPDATE_ALLIANCE_HELP_LIST", handler(self, self.updateHospitalBtn))
	self:updateHospitalBtn()
end
function worldMapComHospital:updateHospitalBtn()
	self.hospitalStatues = getHospitalStatus(self.queueType)
	if not self.buttonHospital then
		return
	end
	if self.hospitalStatues == HOSPITAL_STATUES.HOSPITAL_STATUES_NORMAL then
		self.buttonHospital:setVisible(false)
		getHospitalStatus = self.buttonHospital
		self.buttonHospital.msg = "MESSAGE_MAINUIBOTTOM_SORTBOTTOMQUESTBTNS"
		SoraDSendMessage(self.buttonHospital)
		return
	end
	self.buttonHospital:setVisible(true)
	getHospitalStatus = self.buttonHospital
	self.buttonHospital.msg = "MESSAGE_MAINUIBOTTOM_SORTBOTTOMQUESTBTNS"
	SoraDSendMessage(self.buttonHospital)
	local scale = 1.0
	if self.hospitalStatues == HOSPITAL_STATUES.HOSPITAL_STATUES_HAS_CURE then
		if worldMapDefine.isInSimulatedDrill() then
			self.iconHospital:setSpriteFrame("frame_9001725_zl_icon.png")
		else
			self.iconHospital:setSpriteFrame("icon_building_cure.png")
		end
	elseif self.hospitalStatues == HOSPITAL_STATUES.HOSPITAL_STATUES_HELP then
		scale = 1.3
		self.iconHospital:setSpriteFrame("icon_alliance_help.png")
	elseif self.hospitalStatues == HOSPITAL_STATUES.HOSPITAL_STATUES_CURING then
		self.iconHospital:setSpriteFrame("icon_building_speedup.png")
	end
	self.iconHospital:setScale(scale)
end
function worldMapComHospital:refreshEventModule(target, redata)
	self:updateHospitalBtn()
end
function worldMapComHospital:buttonHospitalCall(button, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if self.hospitalStatues == HOSPITAL_STATUES.HOSPITAL_STATUES_NORMAL then
			return
		end
		if self.hospitalStatues == HOSPITAL_STATUES.HOSPITAL_STATUES_HAS_CURE then
			uiManager:show("HospitalView"):setLV()
		elseif self.hospitalStatues == HOSPITAL_STATUES.HOSPITAL_STATUES_HELP then
			local allianceHelp = gametop.playertop_:getModule("allianceHelp")
			allianceHelp:reqAllianceHelp(self.queueType)
		elseif self.hospitalStatues == HOSPITAL_STATUES.HOSPITAL_STATUES_CURING then
			local backpackCtrl = SoraDGetCtrl("backpackCtrl")
			if self.queueType == gQueueTypeDef.radiance_war_hostpital_queue then
				local speedUpItemList = backpackCtrl:getSpeedUpItemList(gAbbrSpeedUpType.CURE_WAR)
				if #speedUpItemList <= 0 then
					SoraDShowSpeedUpByItemBox(gQueueTypeDef.radiance_war_hostpital_queue)
					SoraDShowMsgTip(i18n("brightWar_text_48"))
					return
				end
			end
			local worldMapWarDef = include("worldMapWarDef")
			local itemType = worldMapWarDef.getItemTypeByQueueType(self.queueType)
			local speedUpItemList = backpackCtrl:getSpeedUpItemList(itemType)
			if 0 < #speedUpItemList then
				SoraDShowSpeedUpByItemBox(self.queueType)
			else
				local queue = queueCtrl:queryQueue(self.queueType)
				SoraDShowSpeedUpBox(queue)
			end
		end
	end
end
return worldMapComHospital
