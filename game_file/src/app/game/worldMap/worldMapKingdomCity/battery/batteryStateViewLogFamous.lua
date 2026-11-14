local gametop = gModuleMgr.getObject("gametop")
local KWKingdomCtrl = gametop.playertop_:getModule("KWKingdomCtrl")
local nationalFlagRead = include("nationalFlagRead")
local lordInfoCtrl = gametop.playertop_:getModule("lordInfoCtrl")
local batteryStateViewLogFamous = class("batteryStateViewLogFamous", function(target)
	if target == nil then
		target = SoraDCreateTouchPanel("batteryStateViewLogFamous")
	end
	if target ~= nil then
		local timerClass = include("batteryStateViewLogBase")
		target = timerClass.new(target)
	end
	return target
end)
function batteryStateViewLogFamous:ctor()
	self.ccs_bg:setTitleName(i18n("common_text_837"))
	self.single = SoraDGetChildByName(self, "Image_kingSIngleCopy")
	self.single:setVisible(false)
end
function batteryStateViewLogFamous:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_SERVER_KINGDOMWAR_GETLOG_KING", handler(self, self.updateKing))
	SoraDAddMessage(self, "MESSAGE_LORDINFO_BY_UID", handler(self, self.serverMessageGetLordInfo))
end
function batteryStateViewLogFamous:updateKing(target, retdate)
	self:updateData(retdate.retdate)
	SoraDCloseLoading(self)
end
function batteryStateViewLogFamous:req4Info()
	SoraDShowLoading(self)
	KWKingdomCtrl:getKingLog(self.nextIndex)
end
function batteryStateViewLogFamous:createNode()
	return self.single:clone()
end
function batteryStateViewLogFamous:refreshNode(single, index, data)
	local defaultColor = cc.c3b(200, 170, 150)
	if 1 == index then
		defaultColor = cc.c3b(255, 165, 0)
		single:getChildByName("Node_king"):setVisible(true)
	else
		single:getChildByName("Node_king"):setVisible(false)
	end
	single:getChildByName("Text_name"):setColor(defaultColor)
	single:getChildByName("Text_turn"):setColor(defaultColor)
	single:getChildByName("Text_time"):setColor(defaultColor)
	local allianceName = data.abbr and "(" .. data.abbr .. ")" or ""
	single:getChildByName("Text_name"):setString(allianceName .. data.name)
	_ENV = nil
	;(nil).num = data.term
	single:getChildByName("Text_turn"):setString(i18n("common_text_1216", nil))
	_ENV = i18n("common_text_1216", nil)
	i18n("common_text_1216", nil).time = SoraDConvertTimeToDate(data.time, false, true)
	single:getChildByName("Text_time"):setString(i18n("common_text_1217", i18n("common_text_1216", nil)))
	SoraDGetHeadFromManager(SoraDGetChildByName(single, "Image_head"), data.icon, data.avatar)
	single:getChildByName("Button_showInfo"):addTouchEventListener(function(button, event)
		if event == ccui.TouchEventType.ended then
			_ENV = nil
			;(nil).targetName = "batteryStateViewLogFamous"
			lordInfoCtrl:getLordInfoByUid(data.uid, data.kid, nil)
		end
	end)
	local imgFlag = single:getChildByName("Image_flag")
	if not data.kingdomFlag then
		imgFlag:setVisible(false)
	else
		local flagImg = nationalFlagRead.getImgByID(data.kingdomFlag)
		imgFlag:loadTexture(flagImg, ccui.TextureResType.plistType)
		imgFlag:setVisible(true)
	end
end
function batteryStateViewLogFamous:serverMessageGetLordInfo(target, data)
	if data.clientData and data.lord then
		local targetName = data.clientData.targetName
		if targetName == "batteryStateViewLogFamous" then
			SoraDOpenLordView(data.lord)
		end
	end
end
return batteryStateViewLogFamous
