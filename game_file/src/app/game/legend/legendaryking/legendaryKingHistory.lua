local gametop = gModuleMgr.getObject("gametop")
local legendLordWarCtrl = gametop.playertop_:getModule("legendLordWarCtrl")
local hegemonRead = include("hegemonRead")
local legendaryKingHistory = class("legendaryKingHistory", function(target)
	if target == nil then
		return SoraDCreateBasePanel("legendaryKingHistory")
	end
	if type(target) == "string" then
		return SoraDCreateBasePanel(target)
	end
	return target
end)
local ctGridScroll = include("ctGridScroll")
local MAX_REQ_NUM = 10
function legendaryKingHistory:ctor()
	self.nodeBg = SoraDGetExtendChildFromCCSByName(self, "CCS_nodeBg_node", true)
	self.commonFramTitle_Node = SoraDGetExtendChildFromCCSByName(self, "CCS_commonFramTitle_Node")
	self.nodePhbTitle_node = SoraDGetExtendChildFromCCSByName(self, "CCS_nodePhbTitle_node")
	self.nodePhbTitle_node:setType(2)
	self.Top_Node_Title = SoraDGetChildByName(self, "Top_Node_Title")
	self.Top_Node_info = SoraDGetChildByName(self, "Top_Node_info")
	self.headBig_node = SoraDGetChildByName(self, "headBig_node")
	self.headBig_node = include("headBig").new(self.headBig_node)
	self.text_des = SoraDGetChildByName(self, "text_des")
	self.scroll = SoraDGetChildByName(self, "Top_Size_ScrollView_pm")
	self.scroll = ctGridScroll.new(self.scroll)
	self.nodePhb_node = SoraDGetChildByName(self, "nodePhb_node")
	self.nodePhb_node:setVisible(false)
	self.node_tips = SoraDGetChildByName(self, "Top_Node_Tips")
	self.node_tips:setVisible(false)
	self.text_player_tips = SoraDGetChildByName(self, "Text_Tips")
	self.text_tips = SoraDGetChildByName(self, "Center_Text_Tip")
	self.text_tips:setString(i18n("common_text_927"))
	self.text_tips:setVisible(false)
	self.text_first_name = SoraDGetChildByName(self, "text_first_name")
	self.head_base = SoraDGetChildByName(self, "head_base")
	self.head_frame = SoraDGetChildByName(self, "head_frame")
	self.rankData, _ENV, self.rankList, _ENV, self.frame_head = SoraDGetChildByName(self, "frame_head"), SoraDGetChildByName(self, "frame_head"), SoraDGetChildByName(self, "frame_head"), SoraDGetChildByName(self, "frame_head"), SoraDGetChildByName(self, "frame_head")
	self.buildID = 0
	self.sIndex = 1
	self.wGet = false
	self.initScroll = false
end
function legendaryKingHistory:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_SERVER_LEGENDLORD_MEMOIR", handler(self, self.initData))
	SoraDAddMessage(self, "MESSAGE_LORDINFO_BY_UID", handler(self, self.serverMessageGetLordInfo))
end
function legendaryKingHistory:init(bid, mapid, activityID)
	self.activityID = activityID
	if mapid then
		self.mapid = mapid
	elseif self.activityID then
		self.mapid = worldMapDefine.getKingStarMapid(self.activityID)
	end
	bid = bid or legendLordWarCtrl:getOpenBuildID(mapid)
	bid = bid or 0
	self.buildID = bid
	self.isHegemon = not hegemonRead.isLegendLordBuilding(self.buildID)
	if self.isHegemon then
		self.commonFramTitle_Node:setTitle(i18n("hegemon_title_10"))
		self.text_des:setString(i18n("hegemon_text_27"))
		self.text_player_tips:setString(i18n("hegemon_text_35"))
		self.headBig_node:setViewType(2)
		local icon_chat_king = SoraDGetChildByName(self.headBig_node, "icon_chat_king")
		icon_chat_king:setScale(0.5)
		icon_chat_king:setPositionX(63)
	else
		local icon_chat_king = SoraDGetChildByName(self.headBig_node, "icon_chat_king")
		if worldMapDefine.isKingStarMapId(self.mapid) then
			_ENV = worldMapDefine.isKingStarMapId(self.mapid)
			worldMapDefine.isKingStarMapId(self.mapid)[gActivityTimeActivityID.KING_STAR_BATTLE] = i18n("kingstarbattle_text_27")
			_ENV = i18n("hegemon_text_35")
			i18n("hegemon_text_35").ranklist = i18n("remains_name_01")
			worldMapDefine.isKingStarMapId(self.mapid)[gActivityTimeActivityID.LEGEND_LORD_9001646] = i18n("king_star_rank_text10", i18n("hegemon_text_35"))
			_ENV = i18n("hegemon_text_35")
			i18n("hegemon_text_35").ranklist = i18n("king_star_rank_text3")
			local worldMapDefine.isKingStarMapId(self.mapid)[gActivityTimeActivityID.LEGEND_LORD_9001647], titleCfg = i18n("king_star_rank_text10", i18n("hegemon_text_35")), worldMapDefine.isKingStarMapId(self.mapid)
			self.commonFramTitle_Node:setTitle(self.activityID and titleCfg[self.activityID] or i18n("kingstarbattle_text_27"))
			self.headBig_node:setViewType(3)
			self.text_des:setString(i18n("kingstarbattle_text_54"))
			self.text_player_tips:setString(i18n("kingstarbattle_text_53"))
		else
			self.commonFramTitle_Node:setTitle(i18n("common_text_4231"))
			self.text_des:setString(i18n("legendaryking_text_01"))
			self.text_player_tips:setString(i18n("legendaryking_text_21"))
			self.headBig_node:setViewType(1)
			icon_chat_king:setScale(1.0)
		end
	end
	self:req4Data(self.sIndex)
end
function legendaryKingHistory:req4Data(index)
	legendLordWarCtrl:getMemoirList(self.buildID, index, MAX_REQ_NUM, self.mapid)
	SoraDShowLoading(self)
end
function legendaryKingHistory:initData(target, data)
	SoraDCloseLoading(self)
	self.sIndex = data.idx
	self.wGet = data.wget
	if next(data.rankList) ~= nil then
		local cpyTbl = clone(data.rankList)
		for i, v in ipairs(cpyTbl) do
			table.insert(self.rankData, v)
		end
		self.rankList, _ENV = ipairs(cpyTbl)
		for i, v in ipairs(self.rankData) do
			v.rank = i
			_ENV = v
			v.index = i
			v.data = v
			table.insert(self.rankList, v)
		end
	end
	self:initView()
end
function legendaryKingHistory:setFirstInfo()
	local data = self:getFirstLegendLordData()
	if data then
		local name = data.playerName
		if name then
			self.node_tips:setVisible(false)
			self.Top_Node_info:setVisible(true)
			if data.leagueAbbrName then
				_ENV = true
				;(true).abbr = data.leagueAbbrName
				;(true).name = data.playerName
				name = i18n("common_text_186", true)
			end
			if data.sourceKid then
				name = name .. "#" .. tostring(data.sourceKid)
			end
			if self.isHegemon then
				local buildName = hegemonRead.getName(self.buildID)
				_ENV = nil
				;(nil).build = buildName
				;(nil).name = name
				self.text_first_name:setString(i18n("hegemon_title_04", nil))
			elseif worldMapDefine.isKingStarMapId(self.mapid) then
				_ENV = i18n("hegemon_title_04", nil)
				i18n("hegemon_title_04", nil).name = name
				self.text_first_name:setString(i18n("kingstarbattle_text_79", i18n("hegemon_title_04", nil)))
			else
				_ENV = i18n("kingstarbattle_text_79", i18n("hegemon_title_04", nil))
				i18n("kingstarbattle_text_79", i18n("hegemon_title_04", nil)).name = name
				self.text_first_name:setString(i18n("legendaryking_text_07", i18n("kingstarbattle_text_79", i18n("hegemon_title_04", nil))))
			end
			self.frame_head:setVisible(true)
			SoraDGetHeadFromManager(self.frame_head, data.headid, data.avatar)
			self.frame_head:setTouchEnabled(true)
			self.frame_head:addTouchEventListener(handler(self, self.btnClickCallBack))
		else
			self.node_tips:setVisible(true)
			self.Top_Node_info:setVisible(false)
			self.frame_head:setTouchEnabled(false)
		end
	else
		self.node_tips:setVisible(false)
		self.Top_Node_info:setVisible(true)
		self.frame_head:setVisible(false)
		self.text_first_name:setString(i18n("common_text_480"))
		self.frame_head:setTouchEnabled(false)
	end
end
function legendaryKingHistory:initView()
	self:setFirstInfo()
	if #self.rankList <= 0 then
		self.text_tips:setVisible(true)
		self.scroll:setVisible(false)
	else
		self.text_tips:setVisible(false)
		self.scroll:setVisible(true)
		if not self.initScroll then
			self.scroll:init(self.rankList, handler(self, self.createSingle), cc.size(640, 115))
			self.scroll:begin2Run()
			self.scroll:addEventListener(handler(self, self.scrollEventCallBack))
			self.initScroll = true
		else
			self.scroll:setNewTable(self.rankList)
		end
	end
end
function legendaryKingHistory:scrollEventCallBack(target, event)
	if event == ccui.ScrollviewEventType.bounceBottom and self.wGet then
		self:req4Data(self.sIndex)
	end
end
function legendaryKingHistory:createSingle(info, index)
	local ocx = self.nodePhb_node:clone()
	local single = include("nodePhb").new(ocx)
	single:setVisible(true)
	single:setScroll(self.scroll)
	single:setHandle(handler(self, self.queryPlayerInfo))
	info.rank = index
	single:initData(info, 1, self.buildID, self.mapid)
	return ocx
end
function legendaryKingHistory:serverMessageGetLordInfo(target, data)
	SoraDCloseLoading(self)
	if data and data.lord then
		SoraDOpenLordView(data.lord)
	end
end
function legendaryKingHistory:getFirstLegendLordData()
	if legendLordWarCtrl:isLegendLordHasLord(self.mapid) and #self.rankList > 0 then
		return self.rankList[1].data
	end
end
function legendaryKingHistory:btnClickCallBack(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local data = self:getFirstLegendLordData()
		self:queryPlayerInfo(data)
	end
end
function legendaryKingHistory:queryPlayerInfo(data)
	if data then
		local playerID = data.uid
		if playerID and 0 < playerID then
			local kid = data.sourceKid
			local lordInfoCtrl = gametop.playertop_:getModule("lordInfoCtrl")
			gametop = nil
			;(nil).targetName = self.__cname
			lordInfoCtrl:getLordInfoByUid(playerID, kid, nil)
			SoraDShowLoading(self)
		end
	end
end
function legendaryKingHistory:testAddData()
	local base = #self.rankList
	self.rankList, _ENV = nil, nil
	for i = 1, base + 10 do
		_ENV = nil
		;(nil).data, _ENV, (nil).index = base + i, base + i, base + i
		table.insert(self.rankList, nil)
	end
	self:initView()
end
return legendaryKingHistory
