local radianceActivityCtrl = SoraDGetCtrl("radianceActivityCtrl")
local radianceWarHistoryDetailView = class("radianceWarHistoryDetailView", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("radianceWarHistoryDetailView")
	end
	return target
end)
function radianceWarHistoryDetailView:ctor()
	self.nodeCommonPopBox = SoraDGetExtendChildFromCCSByName(self, "CCS_commonPopBox_bg")
	self.textDate = SoraDGetChildByName(self, "Text_Date")
	self.scroll = SoraDGetChildByName(self, "ScrollView")
	self.scroll = include("commonAutoScrollList").new(self.scroll)
	self.scroll:setSingleCreate(handler(self, self.createScrollSingle))
	self.nodeSingle = SoraDGetChildByName(self, "Node_Single")
end
function radianceWarHistoryDetailView:initData(data)
	dump(data, "data", 10)
	local settleData = data.settleData
	table.sort(settleData, function(l, r)
		if l.occupyTime > r.occupyTime then
			return true
		elseif l.occupyTime == r.occupyTime then
			if l.isWin then
				return true
			elseif r.isWin then
				return false
			else
				return l.kid < r.kid
			end
		elseif l.occupyTime < r.occupyTime then
			return false
		end
	end)
	for i, v in ipairs(settleData) do
		v.rank = i
	end
	_ENV = nil
	;(nil).scroll = self.scroll
	;(nil).view = self
	self.scroll:updateScrollView(cc.size(540, 78), settleData, 1, nil)
	local timeStr = os.date("!%Y/%m/%d", data.time)
	self.textDate:setString(timeStr)
	_ENV = nil
	;(nil).num = radianceActivityCtrl:getActivitySeasonRound()
	self.nodeCommonPopBox:setTitleName(i18n("brightWar_text_24", nil))
end
function radianceWarHistoryDetailView:createScrollSingle()
	local single = self.nodeSingle:clone()
	return include("radianceWarHistoryDetailSingle").new(single)
end
return radianceWarHistoryDetailView
