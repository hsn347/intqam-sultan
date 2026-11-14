local worldMapCampsite = class("worldMapCampsite", function(target)
	local target = include("worldMapInstance").new("worldMapCampsite")
	return target
end)
function worldMapCampsite:ctor()
	self:_initUI()
	self:_initData()
end
function worldMapCampsite:_initData()
	self.playerName = ""
	self.playerID = 0
	self.leagueID = 0
	self.leagueName = nil
	self.campsiteState = gMapObjStateTypeDef.gMapObjStateTypeFree
	self.emojiID = nil
end
function worldMapCampsite:_initUI()
	self.campsiteImg = display.newSpriteNoChild("#Map_build_campsite.png")
	self:addChild(self.campsiteImg, -1)
end
function worldMapCampsite:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_GREEN_POINT_UPDATE", handler(self, self.updateAllianceCounter))
end
function worldMapCampsite:updateAllianceCounter(target, data)
	if data and data.type and data.type == GREEN_POINT_NOTICE_TYPE.COUNTER_SYS then
		self:updateAllianceCounterAtkEffect()
	end
end
function worldMapCampsite:addCacheBefore()
end
function worldMapCampsite:setBatchNodeGroupID(groupID)
	self.campsiteImg:setGroupID(groupID)
end
function worldMapCampsite:initInstanceData(campsiteData)
	self:updateData(campsiteData)
end
function worldMapCampsite:updateData(campsiteData)
	if not campsiteData then
		return
	end
	if campsiteData.playerName then
		self.playerName = campsiteData.playerName
	end
	if campsiteData.playerID then
		self.playerID = campsiteData.playerID
	end
	if campsiteData.state then
		self.campsiteState = campsiteData.state
	end
	self.leagueID = campsiteData.leagueID or 0
	if self.leagueID == 0 then
		self.leagueName = nil
	end
	if campsiteData.leagueName then
		self.leagueName = campsiteData.leagueName
	end
	if campsiteData.status then
		self.campsiteState = campsiteData.status
	end
	self:updateFireEffect(self.campsiteState)
	self:updateEmojiByData(campsiteData)
	self:updateAllianceCounterAtkEffect()
end
function worldMapCampsite:getFavoriteName()
	local favoriteName = self.playerName
	if self.leagueName then
		_ENV = nil
		;(nil).abbr = self.leagueName
		;(nil).name = self.playerName
		favoriteName = i18n("common_text_186", nil)
	end
	return favoriteName
end
function worldMapCampsite:playClickSound()
	SoraDPlaySound("worldmap", 20)
end
function worldMapCampsite:getInstanceOp(isSelfKindom)
	local _ENV, buttonTypeArray
	local gametop = gModuleMgr.getObject("gametop")
	local selfPlayerID = gametop.playertop_:getPlayerID()
	local playerID = self.playerID or 0
	local leagueID = self.leagueID or 0
	if playerID == selfPlayerID then
		_ENV = nil
		;(nil).buttonType = worldMapDefine.worldMapTipButtonType_fanHui
		table.insert(buttonTypeArray, nil)
		_ENV = nil
		;(nil).buttonType = worldMapDefine.worldMapTipButtonType_buDuiXiangqing
		table.insert(buttonTypeArray, nil)
		if self:canHasEmojiOperator(selfPlayerID) then
			_ENV = selfPlayerID
			selfPlayerID.buttonType = worldMapDefine.worldMapTipButtonType_biaoqingyinzhang
			table.insert(buttonTypeArray, selfPlayerID)
		end
	elseif isSelfKindom then
		local allianceMgr = gametop.playertop_:getModule("allianceMgr")
		local selfLeagueID = allianceMgr:getOwnTeamID() or 0
		if 0 < selfLeagueID and selfLeagueID == leagueID then
			_ENV = nil
			;(nil).buttonType = worldMapDefine.worldMapTipButtonType_yongHuXinxi
			table.insert(buttonTypeArray, nil)
		else
			local _ENV, atlantis = table.insert, table.insert
			do
				local isEnable = true
				local msgTipsKey
				if worldMapDefine.isRadianceKingdomID(self.kingdomID) then
					isEnable = false
					function msgTipsKey()
						local radianceWarUtil = include("radianceWarUtil")
						radianceWarUtil.showGuildToBuild(self:getTilePoint())
					end
				elseif worldMapDefine.isInAtlantis() then
					local atlantisWarUtil = include("atlantisWarUtil")
					atlantis = atlantisWarUtil.checkAreaState(self:getTilePoint())
					isEnable = atlantis.isCanZhanling
					msgTipsKey = atlantis.clickTips
				elseif worldMapDefine.isInNebula() then
					local nebulaActivityCtrl = SoraDGetCtrl("nebulaActivityCtrl")
					if nebulaActivityCtrl:getCurRound() <= 3 then
						isEnable = false
						msgTipsKey = i18n("nebula_war_text_0194")
					end
				end
				_ENV = "nebula_war_text_0194"
				;("nebula_war_text_0194").buttonType = worldMapDefine.worldMapTipButtonType_gongJi
				;("nebula_war_text_0194").isButtonEnabled = isEnable
				;("nebula_war_text_0194").msgTipsKey = msgTipsKey
				table.insert(buttonTypeArray, "nebula_war_text_0194")
			end
			local cityCtrl = gametop.playertop_:getModule("cityCtrl")
			local towerLv = cityCtrl:getBuildMaxLv(BUILDID.WATCH_TOWER)
			if 1 < towerLv then
				local isEnable = true
				local msgTipsKey
				if worldMapDefine.isInAtlantis() then
					isEnable = atlantis.isCanZhencha
					msgTipsKey = atlantis.zhenchaTips
				elseif worldMapDefine.isInNebula() then
					local nebulaActivityCtrl = SoraDGetCtrl("nebulaActivityCtrl")
					if nebulaActivityCtrl:getCurRound() <= 3 then
						isEnable = false
						msgTipsKey = i18n("nebula_war_text_0194")
					end
				end
				_ENV = "nebula_war_text_0194"
				;("nebula_war_text_0194").buttonType = worldMapDefine.worldMapTipButtonType_zhenCha
				;("nebula_war_text_0194").isButtonEnabled = isEnable
				;("nebula_war_text_0194").msgTipsKey = msgTipsKey
				table.insert(buttonTypeArray, "nebula_war_text_0194")
			end
			_ENV = table.insert
			table.insert.buttonType = worldMapDefine.worldMapTipButtonType_yongHuXinxi
			table.insert(buttonTypeArray, table.insert)
		end
	else
		_ENV = atlantisWarUtil.checkAreaState(self:getTilePoint())
		atlantisWarUtil.checkAreaState(self:getTilePoint()).buttonType = worldMapDefine.worldMapTipButtonType_yongHuXinxi
		table.insert(buttonTypeArray, (atlantisWarUtil.checkAreaState(self:getTilePoint())))
	end
	return buttonTypeArray
end
return worldMapCampsite
