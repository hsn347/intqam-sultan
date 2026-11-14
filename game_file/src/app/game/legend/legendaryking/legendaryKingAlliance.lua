local gametop = gModuleMgr.getObject("gametop")
local legendLordWarCtrl = gametop.playertop_:getModule("legendLordWarCtrl")
local hegemonRead = include("hegemonRead")
local legendaryKingAlliance = class("legendaryKingAlliance", function(target)
	if target == nil then
		return SoraDCreateBasePanel("legendaryKingAlliance")
	end
	if type(target) == "string" then
		return SoraDCreateBasePanel(target)
	end
	return target
end)
local ctGridScroll = include("ctGridScroll")
function legendaryKingAlliance:ctor()
	self.nodeBg = SoraDGetExtendChildFromCCSByName(self, "CCS_nodeBg_node", true)
	self.commonFramTitle_Node = SoraDGetExtendChildFromCCSByName(self, "CCS_commonFramTitle_Node")
	self.nodePhbTitle_node = SoraDGetExtendChildFromCCSByName(self, "CCS_nodePhbTitle_node")
	self.nodePhbTitle_node:setType(3)
	self.Top_Node_Title = SoraDGetChildByName(self, "Top_Node_Title")
	self.Top_Node_info = SoraDGetChildByName(self, "Top_Node_info")
	self.headBig_node = SoraDGetExtendChildFromCCSByName(self, "CCS_headBig_node")
	self.icon_chat_king = SoraDGetChildByName(self, "icon_chat_king")
	self.text_des = SoraDGetChildByName(self, "text_des")
	_ENV = "text_des"
	;("text_des").title = i18n("legendaryking_title_06")
	local strName = i18n("common_text_1915", "text_des")
	self.text_des:setString(strName)
	self.scroll = SoraDGetChildByName(self, "Top_Size_ScrollView_pm")
	self.scroll = ctGridScroll.new(self.scroll)
	self.nodePhb_node = SoraDGetChildByName(self, "nodePhb_node")
	self.nodePhb_node:setVisible(false)
	self.text_tips = SoraDGetChildByName(self, "Center_Text_Tip")
	self.text_tips:setString(i18n("common_text_927"))
	self.text_tips:setVisible(false)
	self.text_kill = SoraDGetChildByName(self, "text_kill")
	self.text_status_title = SoraDGetChildByName(self, "Text_Status_Title")
	self.head_base = SoraDGetChildByName(self, "head_base")
	self.head_frame = SoraDGetChildByName(self, "head_frame")
	self.frame_head = SoraDGetChildByName(self, "frame_head")
	self.Button_help = SoraDGetChildByName(self, "Top_Button_help")
	if self.Button_help then
		self.Button_help:addTouchEventListener(handler(self, self.onClick_Button_help))
	end
	self.rankData, _ENV, self.legendLord, _ENV, self.rankList, _ENV = self.Button_help.addTouchEventListener, self.Button_help.addTouchEventListener, self.Button_help.addTouchEventListener, self.Button_help.addTouchEventListener, self.Button_help.addTouchEventListener, self.Button_help.addTouchEventListener
	self.buildID = 0
	self.initScroll = false
end
function legendaryKingAlliance:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_SERVER_LEGENDLORD_ALLIANCE", handler(self, self.initData))
	SoraDAddMessage(self, "MESSAGE_LORDINFO_BY_UID", handler(self, self.serverMessageGetLordInfo))
end
function legendaryKingAlliance:init(bid, mapid)
	self.mapid = mapid
	bid = bid or legendLordWarCtrl:getOpenBuildID(mapid)
	bid = bid or 0
	self.buildID = bid
	self.isHegemon = not hegemonRead.isLegendLordBuilding(self.buildID)
	if self.isHegemon then
		self.commonFramTitle_Node:setTitle(i18n("hegemon_text_31"))
		self.head_frame:setSpriteFrame("4120.png")
		self.icon_chat_king:setSpriteFrame("icon_bazhuzhizhan_01.png")
		self.icon_chat_king:setScale(0.5)
	elseif worldMapDefine.isKingStarMapId(self.mapid) then
		self.commonFramTitle_Node:setTitle(i18n("kingstarbattle_text_32"))
		self.head_frame:setSpriteFrame("headframe_96.png")
		self.icon_chat_king:setSpriteFrame("icon_kingstarbattle_01.png")
		self.icon_chat_king:setScale(0.9)
	else
		self.commonFramTitle_Node:setTitle(i18n("legendaryking_title_05"))
		self.head_frame:setSpriteFrame("4086.png")
		self.icon_chat_king:setSpriteFrame("icon_legendary_01.png")
		self.icon_chat_king:setScale(0.9)
	end
	self:req4Data()
end
function legendaryKingAlliance:req4Data(index)
	legendLordWarCtrl:getKingAlliance(self.buildID, nil, self.mapid)
	SoraDShowLoading(self)
end
function legendaryKingAlliance:initData(target, data)
	SoraDCloseLoading(self)
	if not data.legendLord then
		_ENV = data.legendLord
	end
	self.legendLord = data.legendLord
	if next(data.rankList) ~= nil then
		local cpyTbl = clone(data.rankList)
		for _, v in ipairs(cpyTbl) do
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
function legendaryKingAlliance:setLegendLordInfo()
	local data = self:getLegendLordData()
	if data then
		local name = data.playerName
		if name then
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
				self.text_status_title:setString(i18n("hegemon_title_04", nil))
			elseif worldMapDefine.isKingStarMapId(self.mapid) then
				_ENV = i18n("hegemon_title_04", nil)
				i18n("hegemon_title_04", nil).name = name
				self.text_status_title:setString(i18n("kingstarbattle_text_79", i18n("hegemon_title_04", nil)))
			else
				_ENV = i18n("kingstarbattle_text_79", i18n("hegemon_title_04", nil))
				i18n("kingstarbattle_text_79", i18n("hegemon_title_04", nil)).name = name
				self.text_status_title:setString(i18n("legendaryking_text_07", i18n("kingstarbattle_text_79", i18n("hegemon_title_04", nil))))
			end
			self.frame_head:setVisible(true)
			SoraDGetHeadFromManager(self.frame_head, data.headid, data.avatar)
			self.frame_head:setTouchEnabled(true)
			self.frame_head:addTouchEventListener(handler(self, self.btnClickCallBack))
			self.text_kill:setString(string.formatnumberthousands(data.killFc))
		else
			self.Top_Node_info:setVisible(false)
			self.frame_head:setTouchEnabled(false)
			self.text_status_title:setString(i18n("common_text_480"))
		end
	else
		self.Top_Node_info:setVisible(false)
		self.frame_head:setTouchEnabled(false)
		self.text_status_title:setString(i18n("common_text_480"))
	end
end
function legendaryKingAlliance:initView()
	self:setLegendLordInfo()
	if #self.rankList <= 0 then
		self.text_tips:setVisible(true)
		self.scroll:setVisible(false)
	else
		self.text_tips:setVisible(false)
		self.scroll:setVisible(true)
		if not self.initScroll then
			self.scroll:init(self.rankList, handler(self, self.createSingle), cc.size(640, 115))
			self.scroll:begin2Run()
			self.initScroll = true
		else
			self.scroll:setNewTable(self.rankList)
		end
	end
end
function legendaryKingAlliance:createSingle(info, index)
	local ocx = self.nodePhb_node:clone()
	local single = include("nodePhb").new(ocx)
	single:setVisible(true)
	single:setScroll(self.scroll)
	single:setHandle(handler(self, self.queryPlayerInfo))
	info.rank = index
	single:initData(info, 3, self.buildID)
	return ocx
end
function legendaryKingAlliance:serverMessageGetLordInfo(target, data)
	SoraDCloseLoading(self)
	if data and data.lord then
		SoraDOpenLordView(data.lord)
	end
end
function legendaryKingAlliance:getLegendLordData()
	return self.legendLord
end
function legendaryKingAlliance:btnClickCallBack(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local data = self:getLegendLordData()
		self:queryPlayerInfo(data)
	end
end
function legendaryKingAlliance:queryPlayerInfo(data)
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
function legendaryKingAlliance:testAddData()
	local base = #self.rankList
	self.rankList, _ENV = nil, nil
	for i = 1, base + 10 do
		_ENV = nil
		;(nil).data, _ENV, (nil).index = base + i, base + i, base + i
		table.insert(self.rankList, nil)
	end
	self:initView()
end
function legendaryKingAlliance:onClick_Button_help(sender, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if self.isHegemon then
			_ENV = "hegemon_text_31"
			;("hegemon_text_31")[1] = i18n("hegemon_text_21")
			;("hegemon_text_31")[2] = i18n("hegemon_text_21")
			SoraDShowFixWindow(i18n("hegemon_text_31"), "hegemon_text_31")
		elseif worldMapDefine.isKingStarMapId(self.mapid) then
			_ENV = "legendaryking_title_05"
			;("legendaryking_title_05")[1] = i18n("legendaryking_text_26")
			;("legendaryking_title_05")[2] = i18n("legendaryking_text_26")
			SoraDShowFixWindow(i18n("legendaryking_title_05"), "legendaryking_title_05")
		else
			_ENV = "kingstarbattle_text_32"
			;("kingstarbattle_text_32")[1] = i18n("kingstarbattle_text_63")
			;("kingstarbattle_text_32")[2] = i18n("kingstarbattle_text_63")
			SoraDShowFixWindow(i18n("kingstarbattle_text_32"), "kingstarbattle_text_32")
		end
	end
end
return legendaryKingAlliance
