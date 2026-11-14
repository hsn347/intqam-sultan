local allianceDesRead = include("allianceDesRead")
local gametop = gModuleMgr.getObject("gametop")
local allianceMgr = gametop.playertop_:getModule("allianceMgr")
local allianceTerritoryAPI = include("allianceTerritoryAPI")
local allianceTerritoryCtrl = gametop.playertop_:getModule("allianceTerritoryCtrl")
_ENV = gametop.playertop_
gametop.playertop_[1] = "icon_lzjn_hqz.png"
gametop.playertop_[2] = "icon_lzjn_lqz.png"
local gametop.playertop_[3], flagConfig = "icon_lzjn_lqz2.png", gametop.playertop_
local AllianceBuildFlagNode = class("allianceBuildFlagNode", function(target)
	if target == nil then
		return SoraDCreateBasePanel("allianceBuildFlagNode")
	end
	return target
end)
function AllianceBuildFlagNode:ctor()
	self.buildingArray, _ENV, self.tableSpare, _ENV, self.tableSingleData, _ENV = nil, nil, nil, nil, nil, nil
	self.scrollBaseH = 0
	self.scroll = nil
	self.singleIsMoved = false
	self.Node_building = SoraDGetChildByName(self, "Node_building")
	self.Node_base = SoraDGetChildByName(self, "Node_base")
	self.labelFlagCur = SoraDGetChildByName(self, "Text_flagCur")
	self.labelFlagDes = SoraDGetChildByName(self, "Text_flagDes")
	self.btnBuild = SoraDGetChildByName(self, "Button_build")
	self.scrollMember = SoraDGetChildByName(self, "ScrollView_member")
	self.scrollMember:addEventListener(handler(self, self.scrollEventCallBack))
	self.scrollBaseH = self.scrollMember:getContentSize().height
	self.labelRank = SoraDGetChildByName(self, "Text_rank")
	self.labelCount = SoraDGetChildByName(self, "Text_count")
	self.labelMember = SoraDGetChildByName(self, "Text_member")
	self.imgMember = SoraDGetChildByName(self, "Image_member")
	self.btnBuild:addTouchEventListener(handler(self, self.btnClickCallBack))
	self.btnBuild:setTitleText(i18n("common_text_042"))
	self.labelRank:setString(i18n("common_text_2193"))
	self.labelCount:setString(i18n("common_text_3004"))
	self.labelMember:setString(i18n("common_text_188"))
end
function AllianceBuildFlagNode:initData(data)
	if allianceTerritoryAPI:checkIsRecycleBuilding(gAllianceBuilding.FLAG) then
		self.btnBuild:setVisible(false)
		self.labelFlagDes:setString(i18n("alliance_stronghold_text_084"))
	else
		self.btnBuild:setVisible(true)
		local size = 1.0
		local radioation = 1.0
		local allianceBuildInfo = worldMapDefine.getAllianceBuildInfo(gAllianceBuilding.FLAG)
		if allianceBuildInfo then
			size = allianceBuildInfo.size
			radioation = allianceBuildInfo.radioation
		end
		size = size + 2 * radioation
		size = size * size
		allianceTerritoryAPI = i18n("alliance_stronghold_text_084")
		i18n("alliance_stronghold_text_084").build = i18n("common_text_2903")
		i18n("alliance_stronghold_text_084").count = size
		self.labelFlagDes:setString(i18n("common_text_3005", i18n("alliance_stronghold_text_084")))
	end
	allianceTerritoryAPI = self.labelFlagDes
	self.labelFlagDes.count = string.formatnumberthousands(allianceTerritoryAPI:getAllianceFlagCount())
	self.labelFlagCur:setString(i18n("common_text_2989", self.labelFlagDes))
	self:clearOld()
	for i, v in ipairs(data) do
		allianceTerritoryAPI = i18n("common_text_2989", self.labelFlagDes)
		i18n("common_text_2989", self.labelFlagDes).data = v
		allianceTerritoryAPI, i18n("common_text_2989", self.labelFlagDes).point = i18n("common_text_2989", self.labelFlagDes)
		i18n("common_text_2989", self.labelFlagDes).x = 0
		i18n("common_text_2989", self.labelFlagDes).pos, i18n("common_text_2989", self.labelFlagDes).y = i18n("common_text_2989", self.labelFlagDes)
		table.insert(self.tableSingleData, i18n("common_text_2989", self.labelFlagDes))
	end
	self.buildingFlags = allianceTerritoryCtrl:getBuildingFlags()
	table.sort(self.buildingFlags, function(a, b)
		return a.createTime < b.createTime
	end)
	for k, v in ipairs(self.buildingArray) do
		v:setVisible(false)
	end
	local bHeight = math.ceil(#self.buildingFlags / 2) * 376
	for k, v in ipairs(self.buildingFlags) do
		if self.buildingArray[k] then
			self.buildingArray[k]:setVisible(true)
		else
			self.buildingArray[k] = include("allianceBuildMainSingle").new()
			self.buildingArray[k]:addTo(self.Node_building)
		end
		self.buildingArray[k]:setScroll(self.scroll)
		local h = k % 2
		local l = math.ceil(k / 2)
		self.buildingArray[k]:setPosition(SoraDFPosX(h * 320 - 160, 0), -l * 376 + 376)
		self.buildingArray[k]:initData(v)
	end
	self.Node_base:setPositionY(-bHeight)
	self:initScroll()
	self:initMemberList()
end
function AllianceBuildFlagNode:clearOld()
	for i, v in ipairs(self.tableSingleData) do
		if v.point then
			v.point:setVisible(false)
			table.insert(self.tableSpare, v.point)
		end
	end
	self.tableSingleData, _ENV = ipairs(self.tableSingleData)
end
function AllianceBuildFlagNode:initScroll()
	local scrollInner = self.scrollMember:getInnerContainer()
	local scrollInnerNewH = 100 * #self.tableSingleData
	local scrollW = self.scrollMember:getContentSize().width
	for i, v in ipairs(self.tableSingleData) do
		v.pos = cc.p(0.5 * scrollW, scrollInnerNewH - (i - 1) * 100 - 10)
		if v.point then
			v.point:setPosition(v.pos)
		end
	end
	self.scrollMember:setContentSize(cc.size(scrollW, math.min(self.scrollBaseH, scrollInnerNewH)))
	self.scrollMember:setInnerContainerSize(cc.size(scrollW, scrollInnerNewH))
	self.scrollMember:setBounceEnabled(scrollInnerNewH > self.scrollMember:getContentSize().height)
	self.scrollMember:setSwallowTouches(scrollInnerNewH > self.scrollMember:getContentSize().height)
	self.scrollMember:jumpToTop()
end
function AllianceBuildFlagNode:scrollEventCallBack(target, event)
	self:initMemberList()
end
function AllianceBuildFlagNode:initMemberList()
	local scrollInner = self.scrollMember:getInnerContainer()
	local offsetY = -scrollInner:getPositionY()
	local scrollH = self.scrollMember:getContentSize().height
	_ENV = self.scrollMember
	self.scrollMember.beginY = math.max(0, offsetY - 0.5 * scrollH)
	local self.scrollMember.endY, tableShowH = offsetY + 1.5 * scrollH, self.scrollMember
	for i, v in ipairs(self.tableSingleData) do
		if v.point then
			if v.pos.y < tableShowH.beginY or v.pos.y > tableShowH.endY then
				v.point:setVisible(false)
				table.insert(self.tableSpare, v.point)
				v.point = nil
			end
		elseif tableShowH.beginY <= v.pos.y and tableShowH.endY >= v.pos.y then
			local single
			if 0 < #self.tableSpare then
				single = table.remove(self.tableSpare)
				single:setVisible(true)
			else
				single = self.imgMember:clone()
				single:addTo(self.scrollMember)
			end
			local labelRank = SoraDGetChildByName(single, "Text_rank")
			local iconQz = SoraDGetChildByName(single, "icon_qz")
			local labelCount = SoraDGetChildByName(single, "Text_count")
			local labelName = SoraDGetChildByName(single, "Text_name")
			local imgHead = SoraDGetChildByName(single, "Sprite_head")
			SoraDGetHeadFromManager(imgHead, v.data.iconID, v.data.avatar)
			labelRank:setString(tostring(i))
			if i <= 3 then
				labelRank:setColor(cc.c3b(255, 255, 255))
				iconQz:setSpriteFrame(flagConfig[i])
				iconQz:setVisible(true)
			else
				labelRank:setColor(cc.c3b(50, 30, 0))
				iconQz:setVisible(false)
			end
			labelName:setString(v.data.nickname)
			labelCount:setString(tostring(v.data.count))
			single:setPosition(v.pos)
			v.point = single
		end
	end
end
function AllianceBuildFlagNode:setScroll(scroll)
	self.scroll = scroll
end
function AllianceBuildFlagNode:getAlliancePlacePos()
	local pos
	local buildPosData = allianceTerritoryAPI:getAllBuildingPos()
	for i, v in ipairs(buildPosData) do
		if v.bid == gAllianceBuilding.PALACE then
			ret = true
			pos = v.pos
			break
		end
	end
	return pos
end
function AllianceBuildFlagNode:btnClickCallBack(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local curCount = allianceTerritoryAPI:getAllianceFlagCount()
		_ENV = nil
		;(nil).rank = "R4"
		if not allianceDesRead.checkRank(gAllianceRank.R4, true, i18n("common_text_3011", nil)) then
			return
		end
		if curCount >= allianceTerritoryAPI:getFlagLimit() then
			SoraDShowMsgTip(i18n("common_text_3003"))
		elseif curCount >= allianceTerritoryAPI:getCurrentFlagLimit() then
			SoraDShowMsgTip(i18n("common_text_3002"))
		elseif not allianceTerritoryAPI:checkHasMainBuilding(gAllianceBuilding.PALACE) and not allianceTerritoryAPI:checkHasMainBuilding(gAllianceBuilding.PRIMARY_PALACE) then
			SoraDShowMsgTip(i18n("common_text_3065"))
		elseif #self.buildingFlags >= include("constantRead").getConstValue("MAX_IN_BUILDING_FLAG_COUNT", 4) then
			SoraDShowMsgTip(i18n("alliance_stronghold_text_095"))
		else
			local pos = include("allianceBuildView").getParam().buildMovePos
			if table.nums(pos) <= 0 then
				local currentScene = display.getRunningScene()
				if currentScene.name == "MainScene" then
					local currentView = currentScene:currentSceneShowView()
					if currentView.__cname == "worldMapView" then
						pos = currentView:getDisplayCenterTilePoint()
					else
						local jumpPos = allianceMgr:getLeaderPos()
						if jumpPos == nil or jumpPos.x == -1 and jumpPos.y == -1 then
							SoraDShowMsgTip(i18n("common_text_3065"), nil, button)
							return
						end
						pos = jumpPos
					end
				end
			end
			local jumpPos = self:getAlliancePlacePos()
			_ENV = button
			button.buildClassID = gAllianceBuilding.FLAG
			button.leagueFlag = allianceMgr:getAllianceProperty("flag")
			SoraDGotoWorldMapPoint(pos, false, nil, worldMapLayInstanceTypeDef.layInstanceAllianceManor, button)
			SoraDRemoveAllPrePanelFromManager(self)
		end
	end
end
return AllianceBuildFlagNode
