local gametop = gModuleMgr.getObject("gametop")
local allianceBuild = gametop.playertop_:getModule("allianceBuild")
local kingdomMapCtrl = gametop.playertop_:getModule("kingdomMapCtrl")
local allianceDesRead = include("allianceDesRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local AllianceBuildInfoPanel = class("AllianceBuildInfoPanel", baseFguiPanel)
local string_fnt = string.formatnumberthousands
function AllianceBuildInfoPanel:ctor(...)
	self.super.ctor(self, ...)
	print("AllianceBuildInfoPanel:ctor", self.viewName)
	self.isHideCurrentSceneView = true
end
function AllianceBuildInfoPanel:getPackageList()
	if not self._packageList then
		_UPVALUE1_ = self._packageList
		self._packageList, self._packageList[1] = self._packageList, "BuildWatchTower"
	end
	return self._packageList
end
function AllianceBuildInfoPanel:onInit()
	print("=======AllianceBuildInfoPanel:onInit")
	self.buildSingle = nil
	self.timer = nil
	self.queueIds, _ENV, self.fromLoadText = print, print, false
	self.curLoad = 0
	self.cantJoin = true
	self.memberListData, _ENV, self.buildState = gAllianceBuildingStatus.BUILD, gAllianceBuildingStatus.BUILD, gAllianceBuildingStatus.BUILD
	self.nodeTitle = self.fields.Com_title
	self.fields.Com_title:setCloseCallback(handler(self, self.onClickClose))
	self.labelName = self.fields.Text_name
	self.labelTitle1 = self.fields.Text_title_1
	self.labelValue1 = self.fields.Text_value_1
	self.labelTitle2 = self.fields.Text_title_2
	self.labelValue2 = self.fields.Text_value_2
	self.labelTitle3 = self.fields.Text_title_3
	self.labelValue3 = self.fields.Text_value_3
	self.scroll = self.fields.List
	self.fields.List:setItemRenderer(handler(self, self.onItemRenerer))
	self.fields.List:setVirtual()
	self.labelLog = self.fields.Com_log
	self.spriteBuild = self.fields.Sprite_build
	self.btnRemove = self.fields.Button_remove
	self.btnRemove:setTitleText(i18n("common_text_728"))
	self.btnRemove:addTouchEventListener(handler(self, self.btnClickCallBack))
	if not SoraDFIsRA() then
		_UPVALUE8_ = self.btnRemove
		self.btnRemove[1] = self.spriteBuild
		self.btnRemove[2] = self.labelName
		self.btnRemove[3] = self.labelTitle1
		self.btnRemove[4] = self.labelTitle2
		self.btnRemove[5] = self.labelTitle3
		self.btnRemove[6] = self.labelValue1
		self.btnRemove[7] = self.labelValue2
		self.btnRemove[8] = self.labelValue3
		for __, widget in ipairs(self.btnRemove) do
			widget:fixPos()
		end
		local _fields = fguiHelper.get_fields(self.labelLog)
		_fields.title:fixPos()
		_fields.icon_message:fixPos()
	end
end
function AllianceBuildInfoPanel:onShow()
	print("=======AllianceBuildInfoPanel:onShow")
	local initData = self.param and self.param.initData
	self:initData(initData.bid, initData.iid)
end
function AllianceBuildInfoPanel:initScroll(allQueueIds)
	self.memberListData, _ENV = nil, nil
	self.queueIds = allQueueIds
	if self.buildState == gAllianceBuildingStatus.BUILD then
		local maxQueue = self.buildSingle:getMaxNumOfQueue() + 1
		for i = 1, maxQueue do
			_ENV = nil
			;(nil).data = nil
			;(nil).isLaunched = false
			;(nil).type = i == 1 and gAWarRallyMemberType.LOCK or gAWarRallyMemberType.OPEN
			table.insert(self.memberListData, nil)
		end
	else
		local maxQueue = #self.queueIds
		for i = 1, maxQueue do
			_ENV = nil
			;(nil).data = nil
			;(nil).isLaunched = false
			;(nil).type = gAWarRallyMemberType.OPEN
			table.insert(self.memberListData, nil)
		end
	end
	self.curLoad = 0
end
function AllianceBuildInfoPanel:updateScroll(target, data)
	dump(data, "AllianceBuildInfoPanel:updateScroll", 5)
	if data.data and data.data.allQueueIds then
		self:initScroll(data.data.allQueueIds)
	end
	if not self.memberListData then
		_ENV = self.memberListData
	end
	self.memberListData = self.memberListData
	if data.msg == "MESSAGE_ALLIANCE_BUILD_INFOLIST_DEL" then
		for i, v in ipairs(self.memberListData) do
			if v.data and data.data == v.data.queueId then
				table.remove(self.memberListData, i)
				break
			end
		end
		if self.queueIds and #self.queueIds > 0 then
			for i, v in ipairs(self.queueIds) do
				if v == data.data then
					table.remove(self.queueIds, i)
					break
				end
			end
		end
		if self.buildState == gAllianceBuildingStatus.BUILD then
			_ENV = 5
			;(5).data = nil
			;(5).isLaunched = false
			;(5).type = gAWarRallyMemberType.OPEN
			table.insert(self.memberListData, 2, 5)
		end
		self.curLoad = self.curLoad - 1
	elseif data.msg == "MESSAGE_ALLIANCE_BUILD_INFOLIST_ADD" then
		local index = #self.memberListData - self.curLoad
		if self.buildState == gAllianceBuildingStatus.COMPLETE then
			index = #self.memberListData
		end
		if index == 0 or self.memberListData[index] and self.memberListData[index].type ~= gAWarRallyMemberType.OPEN then
			_ENV = 5
			;(5).data = nil
			;(5).isLaunched = false
			;(5).type = gAWarRallyMemberType.OPEN
			table.insert(self.memberListData, 5)
			index = index + 1
		end
		self.memberListData[index].data = data.data
		self.memberListData[index].type = gAWarRallyMemberType.FULL
		self.curLoad = self.curLoad + 1
	else
		if not data.data.queues then
			local _ENV, allianceBuildListData = data.data.queues, data.data.queues
		end
		local totalCount = #self.memberListData
		for i, v in ipairs(allianceBuildListData) do
			local index = totalCount - (i + self.curLoad) + 1
			if self.memberListData[index] then
				if self.buildState == gAllianceBuildingStatus.BUILD and self.memberListData[index].type == gAWarRallyMemberType.LOCK then
					_ENV = nil
					;(nil).data = nil
					;(nil).isLaunched = false
					;(nil).type = gAWarRallyMemberType.OPEN
					table.insert(self.memberListData, 2, nil)
					totalCount = #self.memberListData
					index = totalCount - (i + self.curLoad) + 1
				end
				self.memberListData[index].data = v
				self.memberListData[index].type = gAWarRallyMemberType.FULL
				if self.queueIds and #self.queueIds > 0 then
					self.memberListData[index].data.queueId = table.remove(self.queueIds, 1)
				end
			end
		end
		self.curLoad = self.curLoad + #allianceBuildListData
	end
	if self.buildState == gAllianceBuildingStatus.COMPLETE and not kingdomMapCtrl:hasQueue2AllianceBuild(self.buildSingle:getIID()) then
		if #self.memberListData == 0 or self.memberListData[#self.memberListData] and self.memberListData[#self.memberListData].type ~= gAWarRallyMemberType.OPEN then
			_ENV = self.buildSingle:getIID()
			self.buildSingle:getIID().data = nil
			self.buildSingle:getIID().isLaunched = false
			self.buildSingle:getIID().type = gAWarRallyMemberType.OPEN
			table.insert(self.memberListData, self.buildSingle:getIID())
		end
		self.curLoad = self.curLoad + 1
	end
	self:initMemberList()
	SoraDCloseLoading(self)
end
function AllianceBuildInfoPanel:updateScrollSize(index, isLaunched)
	print("==AllianceBuildInfoPanel:updateScrollSize==", index)
	local member = self.memberListData[index]
	if member then
		member.isLaunched = isLaunched
	end
	self:initMemberList()
	if isLaunched then
		local index = #self.memberListData - index
		self.fields.List:scrollToView(index)
	end
end
function AllianceBuildInfoPanel:initMemberList(...)
	self.fields.List:setNumItems(#self.memberListData)
end
function AllianceBuildInfoPanel:onItemRenerer(index, obj)
	local index = #self.memberListData - index
	local v = self.memberListData[index]
	obj:initData(v.data, v.type, self.buildSingle)
	obj:setState(v.isLaunched)
	obj:updateOpenShow(self.cantJoin)
	obj:setClickCallBack(handlerEx(self, self.updateScrollSize, index))
end
function AllianceBuildInfoPanel:initData(bid, iid)
	local ret, building = allianceBuild:getBuilding(bid, iid)
	if gErrDef.Err_None == ret then
		self.buildSingle = building
		if self.timer == nil then
			self.timer = SoradCreateTimer(self, handler(self, self.openTimeUp))
			self:openTimeUp()
		end
		if self.buildSingle:getPos() and self.buildSingle:getPos().x then
			kingdomMapCtrl:reqSuperResQueuesByIds(self.buildSingle:getPos().x, self.buildSingle:getPos().y, self.buildSingle:getIID(), self.queueIds)
			SoraDShowLoading(self)
		end
		self:updateNormal()
		self.curLoad = 0
	end
end
function AllianceBuildInfoPanel:updateNormal()
	local allianceMgr = gametop.playertop_:getModule("allianceMgr")
	local memberMgr = gametop.playertop_:getModule("memberMgr")
	local ownmember = memberMgr:getOwnMember()
	local ownRank = ownmember:getProperty("rank")
	local alliacnePoint = allianceMgr:getAlliance()
	gametop = nil
	;(nil).abbr = alliacnePoint:getProperty("abbr")
	;(nil).name = allianceDesRead.getBuildName(self.buildSingle:getBID())
	self.nodeTitle:setTitle(i18n("common_text_186", nil))
	self.btnRemove:setBright(ownRank >= gAllianceRank.R4)
	self.spriteBuild:setURL(allianceDesRead.getBuildIcon(self.buildSingle:getBID()))
end
function AllianceBuildInfoPanel:openTimeUp()
	if self.buildSingle then
		self.buildState = self.buildSingle:getBuildingStatus()
		if self.buildState == gAllianceBuildingStatus.BUILD then
			self:showBuilding()
		elseif self.buildState == gAllianceBuildingStatus.COMPLETE then
			self:showCollect()
		else
			print("状态出错")
		end
	elseif self.timer then
		SoraDManagerRemoveTimer(self, self.timer)
		self.timer = nil
	end
end
function AllianceBuildInfoPanel:showBuilding()
	_ENV = nil
	;(nil).point = ""
	self.labelTitle1:setString(i18n("common_text_2140", nil))
	local curValue, totalValue = self.buildSingle:getBuildValueInfo()
	_ENV = i18n("common_text_2140", nil)
	i18n("common_text_2140", nil).member = string_fnt(curValue)
	i18n("common_text_2140", nil).total = string_fnt(totalValue)
	self.labelValue1:setString(i18n("common_text_155", i18n("common_text_2140", nil)))
	self.labelTitle2:setString(i18n("common_text_2135"))
	_ENV = i18n("common_text_2135")
	i18n("common_text_2135").member = string_fnt(self.buildSingle:getCurNumOfSoldier())
	i18n("common_text_2135").total = string_fnt(self.buildSingle:getMaxNumOfSoldier())
	self.labelValue2:setString(i18n("common_text_155", i18n("common_text_2135")))
	if self.buildSingle:getMaxNumOfSoldier() == 0 then
		self.labelName:setString(i18n("common_text_2139"))
	else
		self.labelName:setString(i18n("common_text_043"))
	end
	local buildTime = self.buildSingle:getBuildRemainTime()
	if buildTime and 0 < buildTime then
		self.labelTitle3:setString(i18n("common_text_2136"))
		self.labelValue3:setString(SoraDConvertSecondToString(buildTime))
		self.labelTitle3:setVisible(true)
		self.labelValue3:setVisible(true)
	else
		self.labelTitle3:setVisible(false)
		self.labelValue3:setVisible(false)
	end
	_ENV = SoraDConvertSecondToString(buildTime)
	SoraDConvertSecondToString(buildTime).build = allianceDesRead.getBuildName(self.buildSingle:getBID())
	self.labelLog:setString(i18n("common_text_2137", SoraDConvertSecondToString(buildTime)))
	local massNum = self.buildSingle:getCurNumOfSoldier()
	local maxMassNum = self.buildSingle:getMaxNumOfSoldier()
	self.cantJoin = massNum >= maxMassNum and 0 < maxMassNum
	_ENV = i18n("common_text_2137", SoraDConvertSecondToString(buildTime))
	i18n("common_text_2137", SoraDConvertSecondToString(buildTime)).msg = "MESSAGE_ALLIACNE_WAR_RALLY_MASS_UPDATE"
	i18n("common_text_2137", SoraDConvertSecondToString(buildTime)).massNum = massNum
	i18n("common_text_2137", SoraDConvertSecondToString(buildTime)).maxMassNum = maxMassNum
	SoraDSendMessage(i18n("common_text_2137", SoraDConvertSecondToString(buildTime)))
end
function AllianceBuildInfoPanel:showCollect()
	local collectData = kingdomMapCtrl:getSuperResCollInfo(self.buildSingle:getIID(), self.buildSingle:getPos().x, self.buildSingle:getPos().y)
	local buildTime = self.buildSingle:getRemainLifeTime()
	kingdomMapCtrl = nil
	;(nil).time = ""
	self.labelTitle1:setString(i18n("common_text_766", nil))
	self.labelValue1:setString(SoraDConvertSecondToString(buildTime))
	self.labelTitle2:setString(i18n("common_text_572"))
	self.labelValue2:setString(string_fnt(collectData.speed) .. "/h")
	self.labelTitle3:setString(i18n("common_text_573"))
	self.labelValue3:setString(string_fnt(collectData.num))
	if collectData.num == 0 then
		self.labelName:setString(i18n("common_text_2224"))
	else
		self.labelName:setString(i18n("common_text_830"))
	end
	self.labelLog:setString(i18n("common_text_2142"))
end
function AllianceBuildInfoPanel:btnClickCallBack()
	local memberMgr = gametop.playertop_:getModule("memberMgr")
	local ownmember = memberMgr:getOwnMember()
	local ownRank = ownmember:getProperty("rank")
	local buildName = allianceDesRead.getBuildName(self.buildSingle:getBID())
	if ownRank >= gAllianceRank.R4 then
		gametop = self.buildSingle:getBID()
		self.buildSingle:getBID().build = buildName
		SoraDShowMsgBox(i18n("common_text_2144", self.buildSingle:getBID()), i18n("common_text_490"), i18n("common_text_185"), function(type)
			if type == MSGBOX_CALLBACK_YES then
				_ENV = nil
				;(nil).build = buildName
				_ENV = nil
				;(nil).build = buildName
				SoraDShowMsgBox(i18n("common_text_2144", nil) .. "\n" .. i18n("common_text_2145", nil), i18n("common_text_490"), i18n("common_text_185"), function(type)
					if type == MSGBOX_CALLBACK_YES then
						allianceBuild:demolishBuilding(self.buildSingle:getBID(), self.buildSingle:getIID())
						self:removeFromParent()
					end
				end)
			end
		end)
	else
		SoraDShowMsgTip(i18n("notice_0073"), "#icon_alliance_R4.png")
	end
end
function AllianceBuildInfoPanel:onMsgAllianceBuildInfoListRefresh(target, data)
	self:initData(self.buildSingle:getBID(), self.buildSingle:getIID())
end
function AllianceBuildInfoPanel:onMsgAllianceBuildInfoListDemolish(target, data)
	if data.data.bid == self.buildSingle:getBID() and data.data.iid == self.buildSingle:getIID() then
		self:removeFromParent()
	end
end
return AllianceBuildInfoPanel
