local gametop = gModuleMgr.getObject("gametop")
local allianceMgr = gametop.playertop_:getModule("allianceMgr")
local allianceDesRead = include("allianceDesRead")
local allianceRelationCtrl = gametop.playertop_:getModule("allianceRelationCtrl")
local lordInfoCtrl = gametop.playertop_:getModule("lordInfoCtrl")
local cityCtrl = gametop.playertop_:getModule("cityCtrl")
local alliancePetRead = include("alliancePetRead")
local allianceMgr = gametop.playertop_:getModule("allianceMgr")
local worldMapFeast = class("worldMapFeast", function()
	local target = include("worldMapInstance").new("worldMapFeast")
	return target
end)
function worldMapFeast:ctor()
	self.modelImage = display.newSprite("#Map_build_feast.png")
	self.modelImage:setPosition(cc.p(0, 0))
	self:addChild(self.modelImage, -1)
	self.tilePoint = nil
	self.leagueFlag = 1
	self.occupyIcon = display.newSprite("#frame_ditubiaoji.png")
	self.occupyIcon:setAnchorPoint(0.5, 0.0)
	self.occupyIcon:setVisible(false)
	self.occupyIcon:setPosition(cc.p(0, self.centerPoint.y + 100))
	self:addChild(self.occupyIcon, 2)
	self.occupyIcon:setGroupID(worldMapDefine.GROU_ID.group_protect)
	self.image_LeagueFlag = display.newSprite(allianceDesRead.getFlagIcon(self.leagueFlag, true))
	self.image_LeagueFlag:setScale(0.3)
	self.image_LeagueFlag:setPosition(cc.p(self.centerPoint.x - 90, self.centerPoint.y - 80))
	self.image_LeagueFlag:setVisible(false)
	self.image_LeagueFlag:addTo(self, 2)
	self.image_LeagueFlag:setGroupID(worldMapDefine.GROU_ID.group_flag)
	self.image_name = display.newSprite("#frame_map_07.png")
	self.image_name:setAnchorPoint(cc.p(0.5, 0.5))
	self.image_name:setPosition(cc.p(self.centerPoint.x - 0, self.centerPoint.y - 80))
	self.image_name:addTo(self, 3)
	self.image_name:setGroupID(worldMapDefine.GROU_ID.group_level_build)
	_ENV = self.image_name
	self.image_name.UILabelType = 2
	self.image_name.text = ""
	self.image_name.size = 20
	self.text_Name = SoraDCreateLabel(self.image_name)
	self.text_Name:setAnchorPoint(cc.p(0.5, 0.5))
	self.text_Name:setPosition(cc.p(self.centerPoint.x - 0, self.centerPoint.y - 85))
	self.text_Name:setColor(cc.c3b(98, 185, 235))
	self.text_Name:addTo(self, 4)
	self.text_Name:setGroupID(worldMapDefine.GROU_ID.group_text)
	local effectLast = SoraDCreatAnimation("hjyt_map_last", nil, true)
	effectLast:setPosition(cc.p(0, 0))
	self:addChild(effectLast, 10)
end
function worldMapFeast:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_ALLIACNE_MEMBER_UPDATE", function(target, data)
		self:updateData(self.feastData)
	end)
	SoraDAddMessage(self, "MESSAGE_ALLIANCE_RELATION_DATA_CHANGE", function(target, data)
		self:updateData(self.feastData)
	end)
end
function worldMapFeast:setBatchNodeGroupID(groupID)
	self.modelImage:setGroupID(groupID)
end
function worldMapFeast:initInstanceData(feastClassID, feastData)
	self.feastClassID = feastClassID
	self:updateData(feastData)
end
function worldMapFeast:setTilePoint(tilePoint)
	self.tilePoint = cc.p(tonumber(tilePoint.x), tonumber(tilePoint.y))
end
function worldMapFeast:getTilePoint()
	return self.tilePoint
end
function worldMapFeast:setInstanceID(instanceID)
	self.instanceID = instanceID
end
function worldMapFeast:getInstanceID()
	return self.instanceID
end
function worldMapFeast:updateData(data)
	if not data then
		return
	end
	dump(data, "worldMapFeastupdateData")
	self.feastData = data
	if data.allianceFlag then
		self.image_LeagueFlag:setVisible(true)
		self.image_LeagueFlag:setSpriteFrame(allianceDesRead.getFlagIcon(data.allianceFlag))
	end
	if data.feastLv and data.leagueName then
		_ENV = allianceDesRead.getFlagIcon(data.allianceFlag)
		allianceDesRead.getFlagIcon(data.allianceFlag).var1 = data.leagueName
		allianceDesRead.getFlagIcon(data.allianceFlag).var2 = data.feastLv
		self.text_Name:setString(i18n("activity_feastLv_name02", allianceDesRead.getFlagIcon(data.allianceFlag)))
	end
	if data.feastRef then
		local isShow = false
		local uid = gametop.playertop_:getPlayerID()
		for k, v in pairs(data.feastRef) do
			if uid == v then
				isShow = true
			end
		end
		self.occupyIcon:setVisible(isShow)
	end
	if data.aid then
		local selfLeagueID = allianceMgr:getOwnAid() or 0
		print("skdjfslkjfklsdjf", selfLeagueID, data.aid)
		self.text_Name:setColor(selfLeagueID ~= data.aid and cc.c3b(200, 200, 200) or cc.c3b(98, 185, 235))
	end
end
function worldMapFeast:onClickInstance()
	self:playClickSound()
	if not allianceMgr:hasJoinAlliance() then
		SoraDShowMsgTip(i18n("tips_place_noUnion"))
		return
	end
	if allianceMgr:getOwnAid() ~= self.feastData.aid then
		SoraDShowMsgTip(i18n("tips_activity_hjyt_viewOtherUnion"))
		return
	end
	local feastPopPanel = SoraDSearchPanelFromManagerByName("getTogertherFeastPopView")
	if feastPopPanel then
		feastPopPanel:removeFromParent()
	end
	local selectShowPanel = SoraDCreatePanel("getTogertherFeastPopView")
	selectShowPanel:initData(self.feastData, self.instanceID)
	selectShowPanel:show()
	return selectShowPanel, false
end
function worldMapFeast:playClickSound()
	SoraDPlaySound("innerbuildsound", 119)
end
return worldMapFeast
