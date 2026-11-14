local worldMapComButton = class("worldMapComButton", include("worldMapCom"))
local gametop = gModuleMgr.getObject("gametop")
local kingdomMapCtrl = gametop.playertop_:getModule("kingdomMapCtrl")
local lordInfoCtrl = gametop.playertop_:getModule("lordInfoCtrl")
local allianceRelationCtrl = gametop.playertop_:getModule("allianceRelationCtrl")
local allianceMgr = gametop.playertop_:getModule("allianceMgr")
local cityCtrl = gametop.playertop_:getModule("cityCtrl")
local conquestWarCtrl = gametop.playertop_:getModule("conquestWarCtrl")
local hegemonCtrl = gametop.playertop_:getModule("hegemonCtrl")
local remainsWarUtil = include("remainsWarUtil")
local worldMapWarDef = include("worldMapWarDef")
local legendTeamCtrl = SoraDGetCtrl("legendTeamCtrl")
function worldMapComButton:ctor()
	worldMapComButton.super.ctor(self, "worldMapComButton")
end
function worldMapComButton:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_WORLD_MAP_TIPBUTTON_TOUCHCALL", handler(self, self.tipButtonTouchCall))
	SoraDAddMessage(self, "MESSAGE_WORLD_MAP_REMOVE_TROOPBINDINGPANEL", handler(self, self.removeTroopBindingPanel))
	SoraDAddMessage(self, "MESSAGE_SERVER_ESCORT_REQ_CLOSEST_BUILD", handler(self, self.serverMessage_reqClosestBuild))
	SoraDAddMessage(self, "MESSAGE_LORDINFO_BY_UID", handler(self, self.serverMessage_LordInfo))
	SoraDAddMessage(self, "MESSAGE_ALLIANCE_GET_BUILDINGINFO_SUCCESS", handler(self, self.serverMessage_AllianceBuildInfo))
end
function worldMapComButton:serverMessage_LordInfo(target, data)
	if data.clientData and data.lord then
		local targetName = data.clientData.targetName
		if targetName == self.__cname then
			SoraDOpenLordView(data.lord)
		end
	end
end
function worldMapComButton:serverMessage_AllianceBuildInfo(target, data)
	if data.buildingInfo then
		if GLOBAL_GAME_ALLIANCE_MODE then
			_ENV = nil
			;(nil).data = data.buildingInfo
			uiManager:show("AllianceBuildMainInfo", nil)
		else
			local infoView = SoraDCreatePanel("allianceBuildMainInfoView")
			infoView:initData(data.buildingInfo)
			infoView:show()
		end
	end
end
function worldMapComButton:serverMessage_reqClosestBuild(target, data)
	dump(data, "押运", 10)
	SoraDCloseLoading(self.target_)
	if self.isReqClosestBuild == nil or self.isReqClosestBuild == false then
		return
	end
	self.isReqClosestBuild = false
	if data.data and data.data.closestBuild then
		local closestBuild = data.data.closestBuild
		if self.reqEscortId == closestBuild.mapObjId then
			local worldEscortBeginView = uiManager:show("WorldEscortBeginView")
			worldEscortBeginView:initWithData(self.reqEscortData)
		else
			SoraDShowMsgBox(i18n("common_text_2319"), i18n("common_text_054"), i18n("common_text_185"), function(eventType)
				if eventType == MSGBOX_CALLBACK_YES then
					SoraDGotoWorldMapPoint(cc.p(closestBuild.x, closestBuild.y), true)
				end
			end)
		end
	end
	self.reqEscortData, _ENV, self.reqEscortId = data.data.closestBuild, data.data.closestBuild, 0
end
function worldMapComButton:tipButtonTouchCall(target, data)
