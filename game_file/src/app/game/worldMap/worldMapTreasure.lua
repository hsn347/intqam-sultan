local worldMapTreasure = class("worldMapTreasure", function(target)
	local target = include("worldMapInstance").new("worldMapTreasure")
	return target
end)
function worldMapTreasure:ctor()
	self.playerName = ""
	self.playerID = 0
	self.leagueID = 0
	self.leagueName = nil
	self.stateTime = 0
	self.treasureState = gMapObjStateTypeDef.gMapObjStateTypeFree
	self.emojiID = nil
	self.treasureImg = display.newSpriteNoChild("#Map_build_treasure.png")
	self:addChild(self.treasureImg, -1)
	self.image_TimeBg = display.newSprite("#title_main_build.png")
	self.image_TimeBg:setPosition(cc.p(self.centerPoint.x + 0, self.centerPoint.y - 30))
	self.image_TimeBg:addTo(self, 1)
	local size_TimeBg = self.image_TimeBg:getContentSize()
	_ENV = self
	self.UILabelType = 2
	self.text = "00:00:00"
	self.size = 20
	self.text_StateTime = cc.ui.UILabel.new(self)
	self.text_StateTime:setAnchorPoint(cc.p(0.5, 0.5))
	self.text_StateTime:setPosition(cc.p(size_TimeBg.width / 2, size_TimeBg.height / 2))
	self.text_StateTime:addTo(self.image_TimeBg, 1)
	self.text_StateTime = SoraDCreateTimerLabel(self, self.text_StateTime)
	self.text_StateTime:setTimeEndListener(function(...)
	end)
	self.workManImg = display.newSpriteNoChild("#kuanggong_01.png")
	self.workManImg:setPosition(cc.p(self.centerPoint.x, self.centerPoint.y + 20))
	self.workManImg:addTo(self, 1)
	local frames = display.newFrames("kuanggong_" .. "0%d.png", 1, 8)
	local animation = display.newAnimation(frames, 0.15)
	self.workManImg:playAnimationForever(animation)
end
function worldMapTreasure:setBatchNodeGroupID(groupID)
	self.treasureImg:setGroupID(groupID)
end
function worldMapTreasure:initInstanceData(treasureData)
	if not treasureData then
		return
	end
	if treasureData.playerName then
		self.playerName = treasureData.playerName
	end
	if treasureData.playerID then
		self.playerID = treasureData.playerID
	end
	self:updateData(treasureData)
end
function worldMapTreasure:updateData(treasureData)
	dump(treasureData, "treasureData", 10)
	if not treasureData then
		return
	end
	self.leagueID = treasureData.leagueID or 0
	if self.leagueID == 0 then
		self.leagueName = nil
	end
	if treasureData.leagueName then
		self.leagueName = treasureData.leagueName
	end
	if treasureData.digEndTime then
		self.stateTime = treasureData.digEndTime - serviceFunctions.systemTime()
		if 0 <= self.stateTime then
			self.text_StateTime:setVisible(true)
			self.text_StateTime:beginTime(self.stateTime)
		else
			self.text_StateTime:setVisible(false)
		end
	end
	self:updateFireEffect(self.treasureState)
	self:updateEmojiByData(treasureData)
end
function worldMapTreasure:getFavoriteName()
	local favoriteName = self.playerName
	if self.leagueName then
		_ENV = nil
		;(nil).abbr = self.leagueName
		;(nil).name = self.playerName
		favoriteName = i18n("common_text_186", nil)
	end
	return favoriteName
end
function worldMapTreasure:playClickSound()
	SoraDPlaySound("worldmap", 5)
end
function worldMapTreasure:getInstanceOp(isSelfKindom)
	local _ENV, buttonTypeArray
	local gametop = gModuleMgr.getObject("gametop")
	local allianceMgr = gametop.playertop_:getModule("allianceMgr")
	local selfLeagueID = allianceMgr:getOwnTeamID() or 0
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
		if 0 < selfLeagueID and selfLeagueID == leagueID then
			_ENV = selfPlayerID
			selfPlayerID.buttonType = worldMapDefine.worldMapTipButtonType_yongHuXinxi
			table.insert(buttonTypeArray, selfPlayerID)
		else
			_ENV = selfPlayerID
			selfPlayerID.buttonType = worldMapDefine.worldMapTipButtonType_gongJi
			table.insert(buttonTypeArray, selfPlayerID)
			local cityCtrl = gametop.playertop_:getModule("cityCtrl")
			local towerLv = cityCtrl:getBuildMaxLv(BUILDID.WATCH_TOWER)
			if 1 < towerLv then
				_ENV = nil
				;(nil).buttonType = worldMapDefine.worldMapTipButtonType_zhenCha
				table.insert(buttonTypeArray, nil)
			end
			_ENV = nil
			;(nil).buttonType = worldMapDefine.worldMapTipButtonType_yongHuXinxi
			table.insert(buttonTypeArray, nil)
		end
	else
		_ENV = table.insert
		table.insert.buttonType = worldMapDefine.worldMapTipButtonType_yongHuXinxi
		table.insert(buttonTypeArray, table.insert)
	end
	return buttonTypeArray
end
return worldMapTreasure
