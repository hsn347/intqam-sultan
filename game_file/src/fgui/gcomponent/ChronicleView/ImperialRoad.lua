local gametop = gModuleMgr.getObject("gametop")
local legendMCtrl = gametop.playertop_:getModule("legendMCtrl")
local mileStoneCtrl = gametop.playertop_:getModule("mileStoneCtrl")
local legendMDesRead = include("legendMDesRead")
local baseComponent = require("fgui.base.baseComponent")
local ImperialRoad = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://ChronicleView/ImperialRoad", ImperialRoad)
function ImperialRoad:onInit()
	self.fields.List:setItemRenderer(handler(self, self.onItemRederer))
end
function ImperialRoad:onShow()
end
function ImperialRoad:getTitle()
	return self.pageTitle
end
function ImperialRoad:registerEvent()
	SoraDAddMessage(self, "MESSAGE_SERVER_LEGENDM_ALLIANCE_ACHIEVE_BACK", handler(self, self.sMsgRoadDataBack))
	SoraDAddMessage(self, "MESSAGE_SERVER_LEGENDM_KINGDOM_ACHIEVE_BACK", handler(self, self.sMsgRoadDataBack))
	SoraDAddMessage(self, "MESSAGE_SERVER_LEGENDM_KINGDOM_ACHIEVE_REWARD", handler(self, self.sMsgRoadDataBack))
	SoraDAddMessage(self, "MESSAGE_SERVER_LEGENDM_ALLIANCE_ACHIEVE_REWARD", handler(self, self.sMsgRoadDataBack))
end
function ImperialRoad:onItemRederer(index, target)
	target:initData(self.dataList[index + 1])
end
function ImperialRoad:setPageType(pageType)
	self.pageType = pageType
	if pageType == legendMDesRead.PageType.SERVERROAD then
		self.pageTitle = i18n("history_text_36")
	elseif pageType == legendMDesRead.PageType.ALLIANCEROAD then
		self.pageTitle = i18n("history_text_37")
	end
	self.fields.List:jumpToTop()
	self:req4Data()
end
function ImperialRoad:req4Data(index)
	SoraDShowLoading()
	if self.pageType == legendMDesRead.PageType.ALLIANCEROAD then
		legendMCtrl:reqAllianceAchieve()
	elseif self.pageType == legendMDesRead.PageType.SERVERROAD then
		legendMCtrl:reqKingdomAchieve()
	end
end
function ImperialRoad:sMsgRoadDataBack(target, data)
	print("legendMPageRoad:sMsgRoadDataBack(target, data)", self.pageType)
	if data.pageType ~= self.pageType then
		print("检测到类型不一致----")
		return
	end
	SoraDCloseLoading()
	dump(data, "data----")
	self.isDataBack = true
	self:initScroll()
end
function ImperialRoad:initScroll()
	self.dataList = self:getListData()
	self.fields.List:setNumItems(#self.dataList)
end
function ImperialRoad:getListData()
	local legendMDesRead, listData
	local typeCfgList
	if self.pageType == legendMDesRead.PageType.SERVERROAD then
		typeCfgList = legendMDesRead.getTypeServerRoadCfg()
	elseif self.pageType == legendMDesRead.PageType.ALLIANCEROAD then
		typeCfgList = legendMDesRead.getTypeAllianceRoadCfg()
	end
	local index = 1
	local legendMDesRead, filterTypeList = legendMDesRead.PageType.ALLIANCEROAD, legendMDesRead.PageType.ALLIANCEROAD
	for _, v in ipairs(typeCfgList) do
		local tbTypeList = v
		for j, item in ipairs(tbTypeList) do
			local achievementType = item.achievementType
			local achievementID = item.achievementID
			local serverData = self:getServerData(achievementID)
			if serverData and serverData.status == gKingChroniclesAchieveStatus.COMPLETED then
				if not self:isRewardGeted(achievementID) then
					if self.pageType == legendMDesRead.PageType.ALLIANCEROAD then
						local joinTime = self:getAllianceJoinTime()
						local finishTime = serverData.finishTime
						if joinTime <= finishTime and not filterTypeList[achievementType] then
							filterTypeList[achievementType] = true
							legendMDesRead = nil
							;(nil).data = item
							;(nil).index = index
							;(nil).pageType = self.pageType
							table.insert(listData, nil)
							index = index + 1
						elseif joinTime > finishTime and j == #tbTypeList and not filterTypeList[achievementType] then
							filterTypeList[achievementType] = true
							legendMDesRead = nil
							;(nil).data = item
							;(nil).index = index
							;(nil).pageType = self.pageType
							table.insert(listData, nil)
							index = index + 1
						end
					elseif not filterTypeList[achievementType] then
						filterTypeList[achievementType] = true
						legendMDesRead = table.insert
						table.insert.data = item
						table.insert.index = index
						table.insert.pageType = self.pageType
						table.insert(listData, table.insert)
						index = index + 1
					end
				elseif j == #tbTypeList and not filterTypeList[achievementType] then
					filterTypeList[achievementType] = true
					legendMDesRead = table.insert
					table.insert.data = item
					table.insert.index = index
					table.insert.pageType = self.pageType
					table.insert(listData, table.insert)
					index = index + 1
				end
			elseif serverData then
				if not filterTypeList[achievementType] then
					filterTypeList[achievementType] = true
					legendMDesRead = table.insert
					table.insert.data = item
					table.insert.index = index
					table.insert.pageType = self.pageType
					table.insert(listData, table.insert)
					index = index + 1
				end
			else
				dump(achievementID, "achievementID---没找到")
			end
		end
	end
	dump(listData, "----listData", 10)
	return listData
end
function ImperialRoad:getServerData(achievementID)
	print("legendMPageRoad:getServerData(achievementID):", achievementID)
	local serverData
	if self.pageType == legendMDesRead.PageType.ALLIANCEROAD then
		serverData = legendMCtrl:getAllianceAchieveDataById(achievementID)
	elseif self.pageType == legendMDesRead.PageType.SERVERROAD then
		serverData = legendMCtrl:getKingdomAchieveDataById(achievementID)
	end
	return serverData
end
function ImperialRoad:isRewardGeted(achievementID)
	local isRewardGeted = false
	if self.pageType == legendMDesRead.PageType.ALLIANCEROAD then
		isRewardGeted = legendMCtrl:getIsAllianceAchieveRewardGet(achievementID)
	elseif self.pageType == legendMDesRead.PageType.SERVERROAD then
		isRewardGeted = legendMCtrl:getIsKingdomAchieveRewardGet(achievementID)
	end
	return isRewardGeted
end
function ImperialRoad:getAllianceJoinTime()
	local memberMgr = gametop.playertop_:getModule("memberMgr")
	local jointime = memberMgr:getOwnMember():getProperty("joinTime")
	return jointime
end
return ImperialRoad
