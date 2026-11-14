local gametop = gModuleMgr.getObject("gametop")
local rechargeActivityCtrl = gametop.playertop_:getModule("rechargeActivityCtrl")
local monthSeasonNode = class("monthSeasonNode", function(target)
	if target == nil then
		return SoraDCreateBasePanel("monthSeasonNode")
	end
	return target
end)
function monthSeasonNode:ctor()
	self.Text_tip = SoraDGetChildByName(self, "Text_tip")
	self.Text_tip:setString(i18n("common_text_2458"))
	self.Button_help = SoraDGetChildByName(self, "Button_help")
	self.Button_help:addTouchEventListener(handler(self, self.onBtnHelpCallBack))
	self.scroll = SoraDGetChildByName(self, "ScrollView_scroll")
	self.scroll = include("commonAutoScrollList").new(self.scroll)
	self.scroll:setSingleCCS("monthSeasonSingle")
	self.scroll:setContentSize(cc.size(640, display.height - 265))
	self.ccs_first = SoraDGetExtendChildFromCCSByName(self, "CCS_rechargeFirstAward_node")
	self:initData()
end
function monthSeasonNode:initData()
	if not rechargeActivityCtrl:getWeekActivityList() then
		rechargeActivityCtrl = rechargeActivityCtrl:getWeekActivityList()
	end
	self.monthData = rechargeActivityCtrl:getWeekActivityList()
	if self.monthData then
		self.monthData.isGot, rechargeActivityCtrl, self.monthData.isRenew, rechargeActivityCtrl, self.monthData.canGet, rechargeActivityCtrl, self.monthData.onSale, rechargeActivityCtrl, rechargeActivityCtrl = rechargeActivityCtrl, rechargeActivityCtrl, rechargeActivityCtrl, rechargeActivityCtrl, rechargeActivityCtrl, rechargeActivityCtrl, rechargeActivityCtrl, rechargeActivityCtrl, self.monthData
		local sortTbl = self.monthData
		local keys = table.keys(self.monthData)
		if next(keys) then
			table.sort(keys, function(l, r)
				return l < r
			end)
		end
		for i, v in ipairs(keys) do
			local val = self.monthData[v]
			if val.isbuy then
				if val.isdayget then
					if val.canRenew then
						table.insert(sortTbl.isRenew, val)
					else
						table.insert(sortTbl.isGot, val)
					end
				else
					table.insert(sortTbl.canGet, val)
				end
			else
				table.insert(sortTbl.onSale, val)
			end
		end
		local loop2Insert = function(tbl)
			local _ENV, reTbl
			for i, v in ipairs(tbl) do
				if next(v) then
					for index, value in ipairs(v) do
						table.insert(reTbl, value)
					end
				end
			end
			return reTbl
		end
		for _, v in ipairs(sortTbl.onSale) do
			local lvLimit = SoraDStringSplit(v.lvLimit, ",")
			v.sortLvLimit = tonumber(lvLimit[1]) or 0
		end
		table.sort(sortTbl.onSale, function(a, b)
			if a.sortLvLimit == b.sortLvLimit then
				return a.ID < b.ID
			else
				return a.sortLvLimit > b.sortLvLimit
			end
		end)
		_UPVALUE4_ = sortTbl.onSale
		sortTbl.onSale[1] = sortTbl.canGet
		sortTbl.onSale[2] = sortTbl.onSale
		sortTbl.onSale[3] = sortTbl.isRenew
		sortTbl.onSale[4] = sortTbl.isGot
		local finalMonthTbl = loop2Insert(sortTbl.onSale)
		local singleSize = clientEventMgr.judgeIsOpen(gActivityTimeActivityID.RECHARGE_ACTIVITY_GIFT_ACTIVITY) and cc.size(640, 320) or cc.size(640, 290)
		rechargeActivityCtrl = lvLimit[1]
		lvLimit[1].scroll = self.scroll
		lvLimit[1].view = self:getParent()
		self.scroll:updateScrollView(singleSize, finalMonthTbl, 1, lvLimit[1])
	end
end
function monthSeasonNode:onBtnHelpCallBack(button, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		_ENV = "common_text_4177"
		;("common_text_4177").align = SoraDFLabelR()
		SoraDShowHelpMsgTip(i18n("common_text_4177"), "common_text_4177")
	end
end
return monthSeasonNode
