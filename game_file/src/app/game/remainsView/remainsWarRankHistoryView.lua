local gametop = gModuleMgr.getObject("gametop")
local remainsTeamCtrl = gametop.playertop_:getModule("remainsTeamCtrl")
local remainsWarRankHistoryView = class("remainsWarRankHistoryView", function(ccsFileName)
	local target = SoraDCreateBasePanel(ccsFileName)
	SoraDDeviceFitOffset(target)
	return target
end)
local ctGridScroll = include("ctGridScroll")
function remainsWarRankHistoryView:ctor()
	self.scroll = SoraDGetChildByName(self, "Size_ScrollView_pm")
	self.scroll = ctGridScroll.new(self.scroll)
	self.single = SoraDGetChildByName(self, "Node_history")
	self.single:setVisible(false)
	self.txtTitleDate = SoraDGetChildByName(self, "Text_title_date")
	self.txtTitleScore = SoraDGetChildByName(self, "Text_title_score")
	self.txtTitleDate:setString(i18n("remains_text_92"))
	self.txtTitleScore:setString(i18n("remains_text_94"))
	self.text_tips = SoraDGetChildByName(self, "Center_Text_Tip")
	self.text_tips:setString(i18n("common_text_927"))
	self.text_tips:setVisible(false)
	self.rankData, _ENV, self.rankList, _ENV = self.text_tips.setVisible, self.text_tips.setVisible, self.text_tips.setVisible, self.text_tips.setVisible
	self.initScroll = false
end
function remainsWarRankHistoryView:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_SERVER_REMAINS_RANK_HISTORY_LIST", handler(self, self.initData))
end
function remainsWarRankHistoryView:init()
	self:req4Data(self.sIndex)
end
function remainsWarRankHistoryView:req4Data(index)
	remainsTeamCtrl:getRankHistoryList()
	local loading = SoraDShowLoading(self)
	local x, y = self.text_tips:getPosition()
	loading:setPosition(cc.p(x, y))
end
function remainsWarRankHistoryView:initData(target, data)
	SoraDCloseLoading(self)
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
function remainsWarRankHistoryView:initView()
	if #self.rankList <= 0 then
		self.text_tips:setVisible(true)
		self.scroll:setVisible(false)
	else
		self.text_tips:setVisible(false)
		self.scroll:setVisible(true)
		if not self.initScroll then
			self.scroll:init(self.rankList, handler(self, self.createSingle), cc.size(640, 110))
			self.scroll:begin2Run()
			self.initScroll = true
		else
			self.scroll:setNewTable(self.rankList)
		end
	end
end
function remainsWarRankHistoryView:scrollEventCallBack(target, event)
	if event == ccui.ScrollviewEventType.bounceBottom and self.wGet then
		self:req4Data(self.sIndex)
	end
end
function remainsWarRankHistoryView:createSingle(info, index)
	local ocx = self.single:clone()
	local single = include("remainsWarRankHistorySingle").new(ocx)
	single:setVisible(true)
	single:initData(info)
	return ocx
end
function remainsWarRankHistoryView:testAddData()
	local base = #self.rankList
	self.rankList, _ENV = nil, nil
	for i = 1, base + 10 do
		_ENV = nil
		_ENV, (nil).index = base + i, base + i
		;(base + i).addScore = -5 + i
		;(base + i).teamName = "nameleft"
		;(base + i).enemyTeamName = "nameright"
		;(nil).data, (base + i).time = base + i, 0
		table.insert(self.rankList, nil)
	end
	self:initView()
end
return remainsWarRankHistoryView
