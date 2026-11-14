local gametop = gModuleMgr.getObject("gametop")
local kingdomMapCtrl = gametop.playertop_:getModule("kingdomMapCtrl")
local lordInfoCtrl = gametop.playertop_:getModule("lordInfoCtrl")
local worldMapComForbidWar = class("worldMapComForbidWar", include("worldMapCom"))
function worldMapComForbidWar:ctor()
	worldMapComForbidWar.super.ctor(self, "worldMapComForbidWar")
end
function worldMapComForbidWar:init()
	self.forbidWarTips = SoraDGetChildByName(self.target_, "Top_node_tip")
	if self.forbidWarTips then
		self.forbidWarTips:setPositionY(display.height - 300 + display.iPhoneXBottom)
		self.forbidWarTips:setVisible(false)
		local forbidWarTipsTitle = SoraDGetChildByName(self.forbidWarTips, "Text_tip_title")
		forbidWarTipsTitle:setString(i18n("common_text_3446"))
		self.forbidWarTipsTime = SoraDGetChildByName(self.forbidWarTips, "Text_tip_time")
		self.forbidWarTipsTime = SoraDCreateTimerLabel(self, self.forbidWarTipsTime)
		self.forbidWarTipsIcon = SoraDGetChildByName(self.forbidWarTips, "icon_hourglass")
	end
	self.buttonMyCity = SoraDGetChildByName(self.target_, "Button_myCity")
end
function worldMapComForbidWar:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_SERVER_WORLD_MAP_FORBID_WAR", handler(self, self.updateForbidWarSatusData))
	SoraDAddMessage(self, "MESSAGE_SERVER_WORLD_MAP_xxsStatus", handler(self, self.updateForbidWarSatusData))
	self:updateForbidWarSatusData()
end
function worldMapComForbidWar:doReqestData()
	self:updateForbidWarSatusData()
end
function worldMapComForbidWar:updateForbidWarSatusData()
	local time = kingdomMapCtrl:getForbitWarBeginTime()
	if 0 < time then
		self.forbidWarTips:setVisible(false)
		self.forbidWarTipsTime:setTimeEndListener(function()
			self:updateForbidWarSatusData()
		end)
		self.forbidWarTipsTime:beginTime(time)
	else
		time = kingdomMapCtrl:getForbitWarLeftTime()
		if 0 < time and (include("pyramidWarltCtrl").checkPwXianXiaSai(true) and 1 ~= lordInfoCtrl:getAnchorStatus() or not worldMapDefine.isPyramidKingdomID() and not worldMapDefine.isRemainsKingdomID()) then
			self.forbidWarTips:setVisible(true)
			local myKindomID = gametop.playertop_:getMapID()
			if worldMapDefine.isLegendLordKingdomID(myKindomID) then
				if worldMapDefine.isInLegendLord() then
					self.buttonMyCity:setVisible(true)
				end
				SoraDSetTextWidthHeight(self.forbidWarTipsTime, cc.size(600, 80))
				self.forbidWarTipsTime:setTimeLast(function(str, tick)
					local legendLordWarCtrl = gametop.playertop_:getModule("legendLordWarCtrl")
					if legendLordWarCtrl:isInWar() then
						gametop = nil
						;(nil).time = str
						local reText = i18n("common_text_607", nil)
						return reText
					else
						local percent = legendLordWarCtrl:getCostResPercent(worldMapDefine.currentMapKindomID)
						if worldMapDefine.isKingStarMapId(worldMapDefine.currentMapKindomID) then
							gametop = nil
							;(nil).time = str
							;(nil).percent = percent
							if i18n("kingstarbattle_text_66", nil) then
								goto lbl_41
							end
						end
						gametop = nil
						;(nil).time = str
						;(nil).percent = percent
						local reText = i18n("legendaryking_text_27", nil)
						::lbl_41::
						return reText
					end
				end)
			else
				self.forbidWarTipsTime:setTimeLast(function(str, tick)
					_ENV = nil
					;(nil).time = str
					local reText = i18n("common_text_607", nil)
					return reText
				end)
			end
			self.forbidWarTipsTime:setTimeUpdateListener(function()
				self.forbidWarTipsIcon:setPositionX(SoraDFSign(self.forbidWarTipsTime:getContentSize().width / 2 + 20))
			end)
			self.forbidWarTipsTime:setTimeEndListener(function()
				self.forbidWarTips:setVisible(false)
				self.forbidWarTipsTime:setTimeEndListener(nil)
				local legendLordWarCtrl = gametop.playertop_:getModule("legendLordWarCtrl")
				if legendLordWarCtrl:isInWar() then
					self.buttonMyCity:setVisible(false)
				end
			end)
			self.forbidWarTipsTime:beginTime(time)
		else
			if worldMapDefine.isLegendLordKingdomID() and worldMapDefine.isInLegendLord() then
				self.buttonMyCity:setVisible(false)
			end
			self.forbidWarTips:setVisible(false)
			self.forbidWarTipsTime:removeTime()
		end
	end
end
return worldMapComForbidWar
