local gametop = gModuleMgr.getObject("gametop")
local kingdomCtrl = gametop.playertop_:getModule("kingdomCtrl")
local cityCtrl = gametop.playertop_:getModule("cityCtrl")
local worldMapGotoPointPanel = class("worldMapGotoPointPanel", function()
	return SoraDCreateBasePanel("worldMapGotoPointPanel")
end)
function worldMapGotoPointPanel:ctor(hideKingIDTextField)
	self.scaleActTarget = SoraDGetChildByName(self, "Center_Panel_touch")
	self.hideKingIDTextField = hideKingIDTextField or false
	self.isHaveTextField = true
	self:addTouchEventListener(function(ref, type)
		self:viewOnClick(ref, type)
	end)
	self.gotoButton = SoraDGetChildByName(self, "Button_goto")
	self.gotoButton:addTouchEventListener(function(ref, type)
		self:buttonOnClick(ref, type)
	end)
	self.ccs_bg = SoraDGetExtendChildFromCCSByName(self, "CCS_commonPopBox_bg")
	self.ccs_bg:setTitleName(i18n("common_text_166"))
	self.Node_k = SoraDGetChildByName(self, "Node_k")
	self.Node_x = SoraDGetChildByName(self, "Node_x")
	self.Node_y = SoraDGetChildByName(self, "Node_y")
	self.fieldText_x = SoraDGetChildByName(self, "TextField_x")
	self.fieldText_y = SoraDGetChildByName(self, "TextField_y")
	self.fieldText_country = SoraDGetChildByName(self, "TextField_country")
	_ENV = "TextField_country"
	;("TextField_country").inputMode = cc.EDITBOX_INPUT_MODE_NUMERIC
	self.fieldText_x = SoraDChangeToEditBox(self.fieldText_x, "TextField_country")
	_ENV = "TextField_country"
	;("TextField_country").inputMode = cc.EDITBOX_INPUT_MODE_NUMERIC
	self.fieldText_y = SoraDChangeToEditBox(self.fieldText_y, "TextField_country")
	_ENV = "TextField_country"
	;("TextField_country").inputMode = cc.EDITBOX_INPUT_MODE_NUMERIC
	self.fieldText_country = SoraDChangeToEditBox(self.fieldText_country, "TextField_country")
	if self.hideKingIDTextField then
		self.Node_k:setVisible(false)
	end
	local titleText = SoraDGetChildByName(self, "Text_title")
	titleText:setString(i18n("common_text_478"))
	local countryText = SoraDGetChildByName(self, "Text_country")
	countryText:setString(i18n("common_text_479") .. ":")
	self.gotoButton:setTitleText(i18n("common_text_477"))
	SoraDGetChildByName(self, "Text_x"):setString(SoraDFValueSuit("X", ":"))
	SoraDGetChildByName(self, "Text_y"):setString(SoraDFValueSuit("Y", ":"))
	SoraDToCenter(self.Node_k, 60)
	SoraDToCenter(self.Node_x, 60)
	SoraDToCenter(self.Node_y, 60)
	local manorCityUtil = include("manorCityUtil")
	if manorCityUtil.checkServerUnlock() and not worldMapDefine.isGardenKingdomID() then
		local obj = fguiHelper.createObject("WorldMapUI", "Button_garden")
		obj:addTo(self.scaleActTarget)
		obj:setPosition(cc.p(SoraDFPosX(80), 110))
		obj:setString(i18n("garden_text_01"))
		obj:addClickEventListener(handler(self, self.onClickBtnGarden))
	end
	if worldMapDefine.isGardenKingdomID() then
		local obj = fguiHelper.createObject("WorldMapUI", "Text_garden")
		obj:addTo(self.scaleActTarget)
		obj:setPosition(cc.p(320, 140))
		obj:setString(i18n("garden_text_01"))
	end
end
function worldMapGotoPointPanel:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_SERVER_ESCORT_REQ_CLOSEST_BUILD", handler(self, self.sMsgClosestBuild))
	SoraDAddMessage(self, "MESSAGE_SERVER_ESCORT_REQ_CLOSEST_BUILD_FAILED", handler(self, self.sMsgClosestBuildFailed))
end
function worldMapGotoPointPanel:updateData(kingdomID, tilePoint)
	if worldMapDefine.worldMapSearchKindomID and not self.hideKingIDTextField then
		kingdomID = worldMapDefine.worldMapSearchKindomID
	end
	if not self.hideKingIDTextField and worldMapDefine.isLegendLordKingdomID(kingdomID) then
		kingdomID = worldMapDefine.currentMapKindomID
	end
	if worldMapDefine.worldMapSearchPoint then
		tilePoint = worldMapDefine.worldMapSearchPoint
	end
	self.fieldText_country:setString(tostring(kingdomID))
	self.fieldText_x:setString(tostring(tilePoint.x))
	self.fieldText_y:setString(tostring(tilePoint.y))
end
function worldMapGotoPointPanel:viewOnClick(ref, type)
	if type == ccui.TouchEventType.ended then
		self:close(ref, type)
	end
end
function worldMapGotoPointPanel:buttonOnClick(ref, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local kingdomID = tonumber(self.fieldText_country:getString()) or 0
		if self.hideKingIDTextField then
		else
			if kingdomCtrl:getIsKingdomMerged(kingdomID) then
				SoraDShowMsgTip(i18n("CombineServers_61"))
				return
			end
			if not kingdomCtrl:isFoundKingdomID(kingdomID) or worldMapDefine.isPyramidKingdomID(kingdomID) or worldMapDefine.isLegendLordKingdomID(kingdomID) then
				SoraDShowMsgTip(i18n("common_text_516"))
				return
			end
		end
		local x = tonumber(self.fieldText_x:getString()) or 0
		local y = tonumber(self.fieldText_y:getString()) or 0
		if x < 0 then
			x = 0
		end
		local maxCoordinate = worldMapDefine.getMaxCoordinateByKid(kingdomID)
		if x > maxCoordinate then
			x = maxCoordinate
		end
		if y < 0 then
			y = 0
		end
		if maxCoordinate < y then
			y = maxCoordinate
		end
		local gotoPoint = cc.p(x, y)
		SoraDGotoWorldMapPoint(gotoPoint, false, kingdomID)
		if not self.hideKingIDTextField then
			worldMapDefine.worldMapSearchKindomID = kingdomID
		end
		worldMapDefine.worldMapSearchPoint = gotoPoint
		self:close(ref, type)
	end
end
function worldMapGotoPointPanel:sMsgClosestBuild(target, data)
	dump(data, "worldMapGotoPointPanel:sMsgClosestBuild")
	local retData = data.data
	SoraDCloseLoading(self)
	if retData.closestBuild == nil then
		return
	end
	local x = retData.closestBuild.x
	local y = retData.closestBuild.y
	if x ~= -1 and y ~= -1 then
		print("开始跳转到坐标 -------", x, " ,", y)
		SoraDGotoWorldMapPoint(cc.p(x, y), true)
		self:close(nil, ccui.TouchEventType.ended)
	else
		SoraDShowMsgTip("Sorry! cannot find!")
	end
end
function worldMapGotoPointPanel:sMsgClosestBuildFailed(target, data)
	SoraDCloseLoading(self)
	local err = data.err
	if err == gErrDef.Err_ESCORT_ACTIVITY_NOT_OPEN then
		SoraDShowMsgTip(i18n("common_text_2486"), "#icon_escort_convey.png")
	else
		SoraDShowMsgTip("escort search error: code= " .. err, "#icon_escort_convey.png")
	end
end
function worldMapGotoPointPanel:onClickBtnGarden(EventContext)
	SoraDPlaySound()
	local manorCityUtil = include("manorCityUtil")
	manorCityUtil.gotoGardenWar()
end
return worldMapGotoPointPanel
