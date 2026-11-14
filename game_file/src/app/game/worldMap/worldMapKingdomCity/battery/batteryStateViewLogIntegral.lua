local gametop = gModuleMgr.getObject("gametop")
local KWKingdomCtrl = gametop.playertop_:getModule("KWKingdomCtrl")
local batteryStateViewLogIntegral = class("batteryStateViewLogIntegral", function(target)
	if target == nil then
		target = SoraDCreateTouchPanel("batteryStateViewLogIntegral")
	end
	if target ~= nil then
		local timerClass = include("batteryStateViewLogBase")
		target = timerClass.new(target)
	end
	return target
end)
function batteryStateViewLogIntegral:ctor()
	self.ccs_bg:setTitleName(i18n("common_text_2719"))
	SoraDGetChildByName(self, "Text_intIntegral"):setString(i18n("common_text_1764"))
	SoraDGetChildByName(self, "Text_integralAlliance"):setString(i18n("common_text_171"))
	SoraDGetChildByName(self, "Text_integralRank"):setString(i18n("common_text_2193"))
	self.single = SoraDGetChildByName(self, "Image_intSIngleCopy")
	self.single:setVisible(false)
end
function batteryStateViewLogIntegral:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_SERVER_KINGDOMWAR_GETLOG_ALLIANCEINTEGRAL", handler(self, self.updateIngegral))
end
function batteryStateViewLogIntegral:updateIngegral(target, retdate)
	if retdate.retdate then
		self:updateData(retdate.retdate)
	else
		local kingWarState = self.argList.kingWarState
		if kingWarState and gKingdomWarStatusType.close == kingWarState then
			self:addWarnText(i18n("common_text_699"))
		else
			self:addWarnText(i18n("common_text_2764"))
		end
	end
	SoraDCloseLoading(self)
end
function batteryStateViewLogIntegral:req4Info()
	SoraDShowLoading(self)
	KWKingdomCtrl:getKingWarScoreRank()
end
function batteryStateViewLogIntegral:createNode()
	return self.single:clone()
end
function batteryStateViewLogIntegral:refreshNode(single, index, data)
	if data.score then
		single:getChildByName("Text_int"):setString(data.score)
	else
		single:getChildByName("Text_int"):setString(SoraDConvertSecondToString(data.occupyTotalTime))
	end
	_ENV = SoraDConvertSecondToString(data.occupyTotalTime)
	SoraDConvertSecondToString(data.occupyTotalTime).abbr = data.abbr
	SoraDConvertSecondToString(data.occupyTotalTime).name = data.aName
	single:getChildByName("Text_alliance"):setString(i18n("common_text_186", SoraDConvertSecondToString(data.occupyTotalTime)))
	_ENV = i18n("common_text_186", SoraDConvertSecondToString(data.occupyTotalTime))
	i18n("common_text_186", SoraDConvertSecondToString(data.occupyTotalTime)).name = data.leaderName
	single:getChildByName("Text_lord"):setString(i18n("common_text_926", i18n("common_text_186", SoraDConvertSecondToString(data.occupyTotalTime))))
	local Node_singleflag = single:getChildByName("Node_singleflag")
	Node_singleflag:removeAllChildren()
	SoraDGetAllianceFlagByFid(data.flag):addTo(Node_singleflag)
	if index <= 3 then
		single:getChildByName("Text_num"):setVisible(false)
		single:getChildByName("Image_num"):setVisible(true)
		single:getChildByName("Image_num"):loadTexture("icon_ranking_" .. index .. ".png", ccui.TextureResType.plistType)
		single:getChildByName("Image_levelBg"):loadTexture("frame_alliance_pank_0" .. index .. ".png", ccui.TextureResType.plistType)
		single:getChildByName("Text_num"):setColor(cc.c3b(255, 200, 100))
		single:getChildByName("Text_int"):setColor(cc.c3b(255, 200, 100))
		single:getChildByName("Text_alliance"):setColor(cc.c3b(255, 200, 100))
		single:getChildByName("Text_lord"):setColor(cc.c3b(255, 200, 100))
	else
		single:getChildByName("Text_num"):setVisible(true)
		single:getChildByName("Text_num"):setString(index)
		single:getChildByName("Image_num"):setVisible(false)
		single:getChildByName("Image_levelBg"):loadTexture("frame_alliance_pank_04.png", ccui.TextureResType.plistType)
		single:getChildByName("Text_num"):setColor(cc.c3b(175, 175, 175))
		single:getChildByName("Text_int"):setColor(cc.c3b(175, 175, 175))
		single:getChildByName("Text_alliance"):setColor(cc.c3b(175, 175, 175))
		single:getChildByName("Text_lord"):setColor(cc.c3b(175, 175, 175))
	end
end
function batteryStateViewLogIntegral:scrollEventCallBack(target, event)
end
return batteryStateViewLogIntegral
