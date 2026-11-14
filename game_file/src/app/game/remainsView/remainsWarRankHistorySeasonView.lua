local gametop = gModuleMgr.getObject("gametop")
local remainsTeamCtrl = gametop.playertop_:getModule("remainsTeamCtrl")
local remainsWarRankHistorySeasonView = class("remainsWarRankHistorySeasonView", function(ccsFileName)
	local target = SoraDCreateBasePanel(ccsFileName)
	SoraDDeviceFitOffset(target)
	return target
end)
local ctGridScroll = include("ctGridScroll")
function remainsWarRankHistorySeasonView:ctor()
	self.scroll = SoraDGetChildByName(self, "Size_ScrollView_pm")
	self.scroll = ctGridScroll.new(self.scroll)
	self.single = SoraDGetChildByName(self, "Node_history")
	self.single:setVisible(false)
	self.text_tips = SoraDGetChildByName(self, "Center_Text_Tip")
	self.text_tips:setString(i18n("common_text_927"))
	self.text_tips:setVisible(false)
	self.rankData, _ENV, self.rankList, _ENV = self.text_tips.setVisible, self.text_tips.setVisible, self.text_tips.setVisible, self.text_tips.setVisible
	self.initScroll = false
end
function remainsWarRankHistorySeasonView:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_SERVER_REMAINS_RANK_HISTORY_SEASON_LIST", handler(self, self.initData))
end
function remainsWarRankHistorySeasonView:init()
	self:req4Data(self.sIndex)
end
function remainsWarRankHistorySeasonView:req4Data(index)
	remainsTeamCtrl:reqGetHistoryGrade()
	local loading = SoraDShowLoading(self)
	local x, y = self.text_tips:getPosition()
	loading:setPosition(cc.p(x, y))
end
function remainsWarRankHistorySeasonView:initData(target, data)
	SoraDCloseLoading(self)
	if next(data.rankList) ~= nil then
		local cpyTbl = clone(data.rankList)
		for _, v in pairs(cpyTbl) do
			table.insert(self.rankData, v)
		end
		table.sort(self.rankData, function(v1, v2)
			return v2.season < v1.season
		end)
		self.rankList, _ENV = table.sort, table.sort
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
function remainsWarRankHistorySeasonView:initView()
	if #self.rankList <= 0 then
		self.text_tips:setVisible(true)
		self.scroll:setVisible(false)
	else
		self.text_tips:setVisible(false)
		self.scroll:setVisible(true)
		if not self.initScroll then
			self.scroll:init(self.rankList, handler(self, self.createSingle), cc.size(640, 400))
			self.scroll:begin2Run()
			self.initScroll = true
		else
			self.scroll:setNewTable(self.rankList)
		end
	end
end
function remainsWarRankHistorySeasonView:scrollEventCallBack(target, event)
	if event == ccui.ScrollviewEventType.bounceBottom and self.wGet then
		self:req4Data(self.sIndex)
	end
end
function remainsWarRankHistorySeasonView:createSingle(info, index)
	local ocx = self.single:clone()
	local single = include("remainsWarRankHistorySeasonSingle").new(ocx)
	single:setVisible(true)
	single:initData(info)
	return ocx
end
function remainsWarRankHistorySeasonView:testAddData()
	local base = #self.rankList
	self.rankList, _ENV = nil, nil
	for i = 1, base + 10 do
		_ENV = nil
		_ENV, (nil).index = base + i, base + i
		;(base + i).season = i
		;(base + i).activeTime = 0
		;(base + i).finishTime = 518400
		;(base + i).segment = 1
		;(base + i).totalGradePoints = 0
		;(base + i).battleTimes = 100
		;(base + i).winTimes = 50
		;(base + i).mvpTimes = 10
		;(base + i).atkCityWinNum = 10000
		;(base + i).killNpcNum = 10000
		;(base + i).killArmyFc = 10000
		;(nil).data, (base + i).alreadyBattleTimes = base + i, i
		table.insert(self.rankList, nil)
	end
	table.sort(self.rankList, function(v1, v2)
		return v2.data.season < v1.data.season
	end)
	self:initView()
end
return remainsWarRankHistorySeasonView
